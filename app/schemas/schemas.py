from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from uuid import UUID
from datetime import datetime
from app.models.models import UserRole, SubscriptionTier, ScriptMode, MessageRole


# ─── Auth Schemas ───
class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=8)
    name: str = Field(..., min_length=2, max_length=100)


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class OTPVerify(BaseModel):
    email: EmailStr
    otp: str = Field(..., min_length=6, max_length=6)


class ResetPassword(BaseModel):
    email: EmailStr


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int


class RefreshToken(BaseModel):
    refresh_token: str


# ─── User Schemas ───
class UserResponse(BaseModel):
    id: UUID
    email: str
    name: str
    avatar_url: Optional[str] = None
    role: UserRole
    subscription_tier: SubscriptionTier
    is_verified: bool
    created_at: datetime

    class Config:
        from_attributes = True


class UserUpdate(BaseModel):
    name: Optional[str] = None
    avatar_url: Optional[str] = None


class ChangePassword(BaseModel):
    current_password: str
    new_password: str = Field(..., min_length=8)


# ─── Chat Schemas ───
class SessionCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=200)
    mode: ScriptMode = ScriptMode.INDICATOR
    pine_version: str = "v6"


class SessionResponse(BaseModel):
    id: UUID
    title: str
    mode: ScriptMode
    pine_version: str
    message_count: int = 0
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class MessageCreate(BaseModel):
    content: str = Field(..., min_length=1)
    image_url: Optional[str] = None


class MessageResponse(BaseModel):
    id: UUID
    role: MessageRole
    content: str
    image_url: Optional[str] = None
    code_block: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class ChatRequest(BaseModel):
    prompt: str = Field(..., min_length=1)
    mode: ScriptMode = ScriptMode.INDICATOR
    pine_version: str = "v6"
    image_url: Optional[str] = None
    session_id: Optional[UUID] = None


class ChatResponse(BaseModel):
    session_id: UUID
    message: MessageResponse
    script: Optional[str] = None


# ─── Script Schemas ───
class ScriptCreate(BaseModel):
    filename: str = Field(..., min_length=1, max_length=255)
    content: str
    version: str = "v6"
    mode: ScriptMode = ScriptMode.INDICATOR
    description: Optional[str] = None


class ScriptResponse(BaseModel):
    id: UUID
    filename: str
    content: str
    version: str
    mode: ScriptMode
    description: Optional[str] = None
    is_favorite: bool
    download_count: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ScriptUpdate(BaseModel):
    filename: Optional[str] = None
    content: Optional[str] = None
    description: Optional[str] = None
    is_favorite: Optional[bool] = None


# ─── Settings Schemas ───
class SettingsUpdate(BaseModel):
    language: Optional[str] = None
    currency: Optional[str] = None
    chart_provider: Optional[str] = None
    theme: Optional[str] = None
    compact_view: Optional[bool] = None
    monospaced_labels: Optional[bool] = None
    notifications_enabled: Optional[bool] = None


class SettingsResponse(BaseModel):
    language: str
    currency: str
    chart_provider: str
    theme: str
    compact_view: bool
    monospaced_labels: bool
    notifications_enabled: bool

    class Config:
        from_attributes = True


# ─── TradingView Schemas ───
class ChartConfig(BaseModel):
    symbol: str = "BTCUSD"
    timeframe: str = "15m"
    theme: str = "dark"


class PineCodeInject(BaseModel):
    script: str
    chart_config: Optional[ChartConfig] = None
