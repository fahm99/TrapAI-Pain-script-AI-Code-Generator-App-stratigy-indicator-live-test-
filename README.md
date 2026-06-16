<div align="center">

# 🤖 TrapAI

### Systematic Algorithmic Trading with AI Pine Script Generation

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![TradingView](https://img.shields.io/badge/TradingView-131722?style=for-the-badge&logo=tradingview&logoColor=white)
![OpenAI](https://img.shields.io/badge/OpenAI-412991?style=for-the-badge&logo=openai&logoColor=white)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/fahm99/TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-/pulls)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)

</div>

---

## 📱 About TrapAI

TrapAI is a mobile application designed to bridge the gap between complex algorithmic trading and everyday traders. By leveraging **Generative AI**, TrapAI allows users to create custom **Pine Script v6** indicators and strategies through natural language prompts or image uploads of charts/concepts. The app integrates a live **TradingView** widget to visualize results instantly.

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

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                          # Core utilities and configurations
│   ├── theme/                     # App colors, typography, theme
│   ├── constants/                 # App-wide constants
│   └── utils/                     # Validators and formatters
├── domain/                        # Business logic layer
│   ├── entities/                  # Domain entities
│   ├── repositories/              # Repository interfaces
│   └── usecases/                  # Use cases
├── data/                          # Data layer
│   ├── models/                    # Data models
│   ├── datasources/               # Remote/Local data sources
│   └── repositories/              # Repository implementations
└── presentation/                  # UI layer
    ├── screens/                   # Screen widgets
    │   ├── auth/                  # Login, SignUp, OTP, ResetPassword
    │   ├── main/                  # Chart, Chat, Code, Home
    │   ├── settings/              # Settings, Account, Appearance
    │   └── error/                 # Error screen
    ├── widgets/                   # Reusable widgets
    ├── providers/                 # State management (Provider)
    └── navigation/                # App routing
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **State Management** | Provider |
| **Fonts** | Google Fonts (Inter, JetBrains Mono) |
| **Chart** | TradingView Widget Integration |
| **AI Engine** | OpenAI GPT-4o API |
| **Backend** | Node.js with NestJS |
| **Database** | PostgreSQL + Redis |
| **Authentication** | JWT + OAuth 2.0 |

---

## 📸 Screenshots

<div align="center">

| Login | Chat | Chart | Code |
|-------|------|-------|------|
| ![Login](https://via.placeholder.com/200x400/ffffff/000000?text=Login) | ![Chat](https://via.placeholder.com/200x400/ffffff/000000?text=Chat) | ![Chart](https://via.placeholder.com/200x400/131722/d1d4dc?text=Chart) | ![Code](https://via.placeholder.com/200x400/000000/ffffff?text=Code) |

</div>

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code
- A Google Fonts internet connection

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/fahm99/TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-.git
   cd TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

### Screens Included

| Screen | File | Description |
|--------|------|-------------|
| Login | `login_screen.dart` | User authentication |
| Sign Up | `signup_screen.dart` | New user registration |
| OTP | `otp_screen.dart` | 6-digit verification code |
| Reset Password | `reset_password_screen.dart` | Password recovery |
| Success | `success_screen.dart` | Post-auth confirmation |
| Chart | `chart_screen.dart` | TradingView integration |
| Chat | `chat_screen.dart` | AI conversation interface |
| Code | `code_screen.dart` | Generated code viewer |
| Settings | `settings_screen.dart` | App preferences |
| Account | `account_settings_screen.dart` | Profile management |
| Appearance | `appearance_screen.dart` | Theme customization |
| Error | `error_screen.dart` | Error handling |

---

## 🎨 Design System

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#000000` | Buttons, active states |
| Background | `#F9F9F9` | Main canvas |
| Surface | `#FFFFFF` | Cards, containers |
| Border | `#E5E5E5` | Dividers, outlines |
| Text Main | `#1A1C1C` | Primary text |
| Text Secondary | `#4C4546` | Secondary text |
| Error | `#BA1A1A` | Error states |

### Typography

- **Inter**: Primary font for UI elements
- **JetBrains Mono**: Code blocks and technical labels

---

## 📋 User Stories

1. ✅ Create an account using email
2. ✅ Login securely with OTP verification
3. ✅ Type prompts to generate Pine Script code
4. ✅ Upload chart screenshots for pattern recognition
5. ✅ View generated code on live TradingView chart
6. ✅ Copy/download code as .txt file
7. ✅ Switch between Indicator and Strategy modes
8. ✅ View history of previous conversations
9. ✅ Reset chart view
10. ✅ Receive OTP via email for password recovery

---

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
OPENAI_API_KEY=your_openai_api_key
TRADINGVIEW_WIDGET_ID=your_widget_id
BACKEND_URL=http://localhost:3000
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Fahmi Alamere**
- GitHub: [@fahm99](https://github.com/fahm99)
- Repository: [TrapAI](https://github.com/fahm99/TrapAI-Pain-script-AI-Code-Generator-App-stratigy-indicator-live-test-)

---

<div align="center">

### ⭐ Star this repository if you find it helpful!

Made with ❤️ and Flutter

</div>
