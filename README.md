<div align="center">

# 🤖 TrapAI Backend

### FastAPI Backend for AI Pine Script Generation

![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![OpenAI](https://img.shields.io/badge/OpenAI-412991?style=for-the-badge&logo=openai&logoColor=white)
![TradingView](https://img.shields.io/badge/TradingView-131722?style=for-the-badge&logo=tradingview&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

</div>

---

## 📋 Overview

This is the backend API for TrapAI, built with FastAPI and PostgreSQL. It handles:
- **Authentication** (JWT, OTP verification)
- **AI Integration** (OpenAI GPT-4o for Pine Script generation)
- **TradingView Integration** (Chart widgets, symbol search)
- **Chat/Conversation Management**
- **Pine Script Storage & Management**

---

## 🏗️ Architecture

```
trapai_backend/
├── app/
│   ├── main.py              # FastAPI application
│   ├── config.py            # Configuration settings
│   ├── database.py          # Database connection
│   ├── models/              # SQLAlchemy models
│   ├── schemas/             # Pydantic schemas
│   ├── routers/             # API endpoints
│   ├── services/            # Business logic
│   ├── utils/               # Utility functions
│   └── middleware/           # Auth middleware
├── migrations/              # Alembic migrations
├── tests/                   # Unit tests
├── requirements.txt         # Dependencies
└── .env.example            # Environment template
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.11+
- PostgreSQL 15+
- Redis (optional, for caching)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/fahm99/TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-.git
   cd TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-/trapai_backend
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   # or
   venv\Scripts\activate  # Windows
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

5. **Run migrations**
   ```bash
   alembic upgrade head
   ```

6. **Start the server**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

---

## 📚 API Documentation

Once running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

---

## 🔐 Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Create new account |
| POST | `/api/auth/login` | Login and get tokens |
| POST | `/api/auth/verify-otp` | Verify OTP code |
| POST | `/api/auth/reset-password` | Request password reset |
| POST | `/api/auth/refresh-token` | Refresh access token |
| GET | `/api/auth/me` | Get current user |
| POST | `/api/auth/logout` | Logout |

---

## 💬 Chat Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/chat/sessions` | List all sessions |
| POST | `/api/chat/sessions` | Create new session |
| GET | `/api/chat/sessions/{id}` | Get session details |
| DELETE | `/api/chat/sessions/{id}` | Delete session |
| GET | `/api/chat/sessions/{id}/messages` | List messages |
| POST | `/api/chat/send` | Send message & get AI response |

---

## 📜 Script Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/scripts/` | List all scripts |
| POST | `/api/scripts/` | Create new script |
| GET | `/api/scripts/{id}` | Get script details |
| PUT | `/api/scripts/{id}` | Update script |
| DELETE | `/api/scripts/{id}` | Delete script |
| POST | `/api/scripts/{id}/favorite` | Toggle favorite |
| GET | `/api/scripts/favorites` | List favorites |

---

## 📊 TradingView Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tradingview/symbols` | Search symbols |
| GET | `/api/tradingview/symbol/{symbol}` | Get symbol info |
| GET | `/api/tradingview/timeframes` | List timeframes |
| POST | `/api/tradingview/widget-config` | Generate widget config |
| POST | `/api/tradingview/inject-script` | Prepare script for TV |

---

## 👤 User Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users/` | List all users (admin) |
| GET | `/api/users/{id}` | Get user details |
| PUT | `/api/users/me` | Update profile |
| POST | `/api/users/me/change-password` | Change password |
| GET | `/api/users/me/settings` | Get settings |
| PUT | `/api/users/me/settings` | Update settings |
| DELETE | `/api/users/me` | Delete account |

---

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(500),
    role VARCHAR(20) DEFAULT 'user',
    subscription_tier VARCHAR(20) DEFAULT 'free',
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Chat Sessions Table
```sql
CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    mode VARCHAR(20) DEFAULT 'indicator',
    pine_version VARCHAR(10) DEFAULT 'v6',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Chat Messages Table
```sql
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY,
    session_id UUID REFERENCES chat_sessions(id),
    role VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(500),
    code_block TEXT,
    token_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### Pine Scripts Table
```sql
CREATE TABLE pine_scripts (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    session_id UUID REFERENCES chat_sessions(id),
    filename VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    version VARCHAR(10) DEFAULT 'v6',
    mode VARCHAR(20) DEFAULT 'indicator',
    description TEXT,
    is_favorite BOOLEAN DEFAULT FALSE,
    download_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🔧 Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | Required |
| `SECRET_KEY` | JWT secret key | Required |
| `OPENAI_API_KEY` | OpenAI API key | Required |
| `REDIS_URL` | Redis connection | Optional |
| `DEBUG` | Debug mode | false |

---

## 🧪 Testing

```bash
pytest tests/ -v
```

---

## 📝 License

MIT License
