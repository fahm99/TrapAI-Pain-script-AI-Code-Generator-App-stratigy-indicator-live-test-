from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List
from uuid import UUID

from app.database import get_db
from app.models.models import User, ChatSession, ChatMessage, MessageRole
from app.schemas.schemas import (
    SessionCreate, SessionResponse, MessageCreate,
    MessageResponse, ChatRequest, ChatResponse,
)
from app.middleware.auth import get_current_user
from app.services.ai_service import AIService

router = APIRouter()
ai_service = AIService()


@router.get("/sessions", response_model=List[SessionResponse])
async def list_sessions(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(ChatSession)
        .where(ChatSession.user_id == current_user.id)
        .order_by(ChatSession.updated_at.desc())
    )
    sessions = result.scalars().all()

    response = []
    for session in sessions:
        msg_count = await db.execute(
            select(ChatMessage).where(ChatMessage.session_id == session.id)
        )
        count = len(msg_count.scalars().all())
        session_dict = SessionResponse.from_orm(session)
        session_dict.message_count = count
        response.append(session_dict)

    return response


@router.post("/sessions", response_model=SessionResponse, status_code=status.HTTP_201_CREATED)
async def create_session(
    data: SessionCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    session = ChatSession(
        user_id=current_user.id,
        title=data.title,
        mode=data.mode,
        pine_version=data.pine_version,
    )
    db.add(session)
    await db.commit()
    await db.refresh(session)

    return SessionResponse.from_orm(session)


@router.get("/sessions/{session_id}", response_model=SessionResponse)
async def get_session(
    session_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(ChatSession).where(
            ChatSession.id == session_id,
            ChatSession.user_id == current_user.id,
        )
    )
    session = result.scalar_one_or_none()

    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    return SessionResponse.from_orm(session)


@router.delete("/sessions/{session_id}")
async def delete_session(
    session_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(ChatSession).where(
            ChatSession.id == session_id,
            ChatSession.user_id == current_user.id,
        )
    )
    session = result.scalar_one_or_none()

    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    await db.delete(session)
    await db.commit()

    return {"message": "Session deleted"}


@router.get("/sessions/{session_id}/messages", response_model=List[MessageResponse])
async def list_messages(
    session_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(ChatSession).where(
            ChatSession.id == session_id,
            ChatSession.user_id == current_user.id,
        )
    )
    session = result.scalar_one_or_none()

    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    result = await db.execute(
        select(ChatMessage)
        .where(ChatMessage.session_id == session_id)
        .order_by(ChatMessage.created_at)
    )

    return result.scalars().all()


@router.post("/send", response_model=ChatResponse)
async def send_message(
    data: ChatRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    if data.session_id:
        result = await db.execute(
            select(ChatSession).where(
                ChatSession.id == data.session_id,
                ChatSession.user_id == current_user.id,
            )
        )
        session = result.scalar_one_or_none()
        if not session:
            raise HTTPException(status_code=404, detail="Session not found")
    else:
        session = ChatSession(
            user_id=current_user.id,
            title=data.prompt[:100],
            mode=data.mode,
            pine_version=data.pine_version,
        )
        db.add(session)
        await db.flush()

    user_message = ChatMessage(
        session_id=session.id,
        role=MessageRole.USER,
        content=data.prompt,
        image_url=data.image_url,
    )
    db.add(user_message)
    await db.flush()

    response = await ai_service.generate_pine_script(
        prompt=data.prompt,
        mode=data.mode.value,
        version=data.pine_version,
    )

    ai_message = ChatMessage(
        session_id=session.id,
        role=MessageRole.ASSISTANT,
        content=response["explanation"],
        code_block=response["code"],
    )
    db.add(ai_message)

    session.updated_at = __import__("datetime").datetime.utcnow()
    await db.commit()
    await db.refresh(ai_message)

    return ChatResponse(
        session_id=session.id,
        message=MessageResponse.from_orm(ai_message),
        script=response["code"],
    )
