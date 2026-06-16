from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List
from uuid import UUID

from app.database import get_db
from app.models.models import User, PineScript
from app.schemas.schemas import ScriptCreate, ScriptResponse, ScriptUpdate
from app.middleware.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[ScriptResponse])
async def list_scripts(
    skip: int = 0,
    limit: int = 50,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(PineScript)
        .where(PineScript.user_id == current_user.id)
        .order_by(PineScript.created_at.desc())
        .offset(skip)
        .limit(limit)
    )
    return result.scalars().all()


@router.get("/{script_id}", response_model=ScriptResponse)
async def get_script(
    script_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(PineScript).where(
            PineScript.id == script_id,
            PineScript.user_id == current_user.id,
        )
    )
    script = result.scalar_one_or_none()

    if not script:
        raise HTTPException(status_code=404, detail="Script not found")

    return script


@router.post("/", response_model=ScriptResponse, status_code=status.HTTP_201_CREATED)
async def create_script(
    data: ScriptCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    script = PineScript(
        user_id=current_user.id,
        filename=data.filename,
        content=data.content,
        version=data.version,
        mode=data.mode,
        description=data.description,
    )
    db.add(script)
    await db.commit()
    await db.refresh(script)

    return script


@router.put("/{script_id}", response_model=ScriptResponse)
async def update_script(
    script_id: UUID,
    data: ScriptUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(PineScript).where(
            PineScript.id == script_id,
            PineScript.user_id == current_user.id,
        )
    )
    script = result.scalar_one_or_none()

    if not script:
        raise HTTPException(status_code=404, detail="Script not found")

    update_data = data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(script, key, value)

    await db.commit()
    await db.refresh(script)
    return script


@router.delete("/{script_id}")
async def delete_script(
    script_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(PineScript).where(
            PineScript.id == script_id,
            PineScript.user_id == current_user.id,
        )
    )
    script = result.scalar_one_or_none()

    if not script:
        raise HTTPException(status_code=404, detail="Script not found")

    await db.delete(script)
    await db.commit()

    return {"message": "Script deleted"}


@router.post("/{script_id}/favorite")
async def toggle_favorite(
    script_id: UUID,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(PineScript).where(
            PineScript.id == script_id,
            PineScript.user_id == current_user.id,
        )
    )
    script = result.scalar_one_or_none()

    if not script:
        raise HTTPException(status_code=404, detail="Script not found")

    script.is_favorite = not script.is_favorite
    await db.commit()

    return {"is_favorite": script.is_favorite}


@router.get("/favorites", response_model=List[ScriptResponse])
async def list_favorites(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(PineScript)
        .where(PineScript.user_id == current_user.id, PineScript.is_favorite == True)
        .order_by(PineScript.created_at.desc())
    )
    return result.scalars().all()
