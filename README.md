<div align="center">

# 🤖 TrapAI

### Systematic Algorithmic Trading with AI Pine Script Generation

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![OpenAI](https://img.shields.io/badge/OpenAI-412991?style=for-the-badge&logo=openai&logoColor=white)
![TradingView](https://img.shields.io/badge/TradingView-131722?style=for-the-badge&logo=tradingview&logoColor=white)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/fahm99/TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-/pulls)

</div>

---

## 📱 About TrapAI

TrapAI is a full-stack application designed to bridge the gap between complex algorithmic trading and everyday traders. By leveraging **Generative AI**, TrapAI allows users to create custom **Pine Script v6** indicators and strategies through natural language prompts or image uploads of charts/concepts. The app integrates a live **TradingView** widget to visualize results instantly.

### 🎯 The Problem
Traders often have ideas for indicators or strategies but lack the programming skills (Pine Script) to implement them.

### 💡 The Solution
A conversational AI interface that generates, explains, and visualizes trading code in real-time.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🧠 **AI Chat Engine** | Text-to-code and Image-to-code generation using GPT-4o |
| 📊 **Live TradingView Chart** | Real-time chart visualization with injected indicators |
| 💻 **Code Viewer** | Syntax-highlighted Pine Script with copy/share/download |
| 🔐 **Authentication** | Email/Password + Google OAuth + OTP verification |
| 📁 **Script Library** | Save and manage generated Pine Script indicators |
| 🎨 **Theme Support** | Light, Dark, and System Default themes |
| 🔄 **Indicator/Strategy Modes** | Toggle between indicator and strategy code generation |
| 📱 **Cross-Platform** | Single codebase for iOS and Android |

---

## 🏗️ Project Structure

```
trapai/
├── trapai_flutter/           # Flutter Frontend
│   └── lib/
│       ├── core/             # Theme, constants, utils
│       ├── domain/           # Entities, repositories, use cases
│       ├── data/             # Models, datasources, repositories
│       └── presentation/     # Screens, widgets, providers
│
└── trapai_backend/           # FastAPI Backend
    └── app/
        ├── models/           # SQLAlchemy models
        ├── schemas/          # Pydantic schemas
        ├── routers/          # API endpoints
        ├── services/         # AI, TradingView services
        ├── utils/            # Security, helpers
        └── middleware/        # Auth middleware
```

---

## 🛠️ Tech Stack

### Frontend (Flutter)
| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | Provider |
| Fonts | Google Fonts (Inter, JetBrains Mono) |
| Chart | TradingView Widget Integration |

### Backend (FastAPI)
| Component | Technology |
|-----------|------------|
| Framework | FastAPI (Python 3.11+) |
| Database | PostgreSQL 15+ |
| ORM | SQLAlchemy (async) |
| Migrations | Alembic |
| Authentication | JWT + OAuth 2.0 |
| AI Engine | OpenAI GPT-4o API |
| Caching | Redis (optional) |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- [Python 3.11+](https://www.python.org/downloads/)
- [PostgreSQL 15+](https://www.postgresql.org/download/)
- [Redis](https://redis.io/download) (optional)

### 1️⃣ Backend Setup

```bash
# Navigate to backend
cd trapai_backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with your database credentials and API keys

# Run migrations
alembic upgrade head

# Start the server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**API Documentation**: http://localhost:8000/docs

### 2️⃣ Frontend Setup

```bash
# Navigate to Flutter app
cd trapai_flutter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 3️⃣ Environment Variables

Create `.env` file in `trapai_backend/`:

```env
# Database
DATABASE_URL=postgresql+asyncpg://postgres:password@localhost:5432/trapai_db

# JWT
SECRET_KEY=your-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# OpenAI
OPENAI_API_KEY=your-openai-api-key
OPENAI_MODEL=gpt-4o

# Redis (optional)
REDIS_URL=redis://localhost:6379/0
```

---

## 📡 API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Create new account |
| POST | `/api/auth/login` | Login and get tokens |
| POST | `/api/auth/verify-otp` | Verify OTP code |
| POST | `/api/auth/reset-password` | Request password reset |
| POST | `/api/auth/refresh-token` | Refresh access token |
| GET | `/api/auth/me` | Get current user |

### Chat
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/chat/sessions` | List all sessions |
| POST | `/api/chat/sessions` | Create new session |
| GET | `/api/chat/sessions/{id}` | Get session details |
| DELETE | `/api/chat/sessions/{id}` | Delete session |
| GET | `/api/chat/sessions/{id}/messages` | List messages |
| POST | `/api/chat/send` | Send message & get AI response |

### Scripts
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/scripts/` | List all scripts |
| POST | `/api/scripts/` | Create new script |
| GET | `/api/scripts/{id}` | Get script details |
| PUT | `/api/scripts/{id}` | Update script |
| DELETE | `/api/scripts/{id}` | Delete script |
| POST | `/api/scripts/{id}/favorite` | Toggle favorite |

### TradingView
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tradingview/symbols` | Search symbols |
| GET | `/api/tradingview/timeframes` | List timeframes |
| POST | `/api/tradingview/widget-config` | Generate widget config |
| POST | `/api/tradingview/inject-script` | Prepare script for TV |

### Users
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users/me` | Get profile |
| PUT | `/api/users/me` | Update profile |
| GET | `/api/users/me/settings` | Get settings |
| PUT | `/api/users/me/settings` | Update settings |
| DELETE | `/api/users/me` | Delete account |

---

## 🗄️ Database Schema

```sql
-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    subscription_tier VARCHAR(20) DEFAULT 'free',
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Chat sessions
CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    mode VARCHAR(20) DEFAULT 'indicator',
    pine_version VARCHAR(10) DEFAULT 'v6',
    created_at TIMESTAMP DEFAULT NOW()
);

-- Chat messages
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY,
    session_id UUID REFERENCES chat_sessions(id),
    role VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    code_block TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Pine scripts
CREATE TABLE pine_scripts (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    filename VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    version VARCHAR(10) DEFAULT 'v6',
    mode VARCHAR(20) DEFAULT 'indicator',
    is_favorite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 🎨 Design System

### Colors
| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#000000` | Buttons, active states |
| Background | `#F9F9F9` | Main canvas |
| Surface | `#FFFFFF` | Cards, containers |
| Border | `#E5E5E5` | Dividers, outlines |
| Error | `#BA1A1A` | Error states |

### Typography
- **Inter**: Primary font for UI elements
- **JetBrains Mono**: Code blocks and technical labels

---

## 📱 Flutter Screens

| Screen | Description |
|--------|-------------|
| Login | User authentication |
| Sign Up | New user registration |
| OTP | 6-digit verification code |
| Reset Password | Password recovery |
| Success | Post-auth confirmation |
| Chart | TradingView integration |
| Chat | AI conversation interface |
| Code | Generated code viewer |
| Settings | App preferences |
| Account | Profile management |
| Appearance | Theme customization |

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Fahmi Alamere**
- GitHub: [@fahm99](https://github.com/fahm99)
- Repository: [TrapAI](https://github.com/fahm99/TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-)

---

<div align="center">

### ⭐ Star this repository if you find it helpful!

Made with ❤️ using Flutter & FastAPI

</div>
