# Doc Helper App
A Flutter Application that provides RAG-powered document utility features based on the user's plan and enabled features. 

https://github.com/user-attachments/assets/be975437-8d10-4545-a0c9-3e42cf1ddd41


https://github.com/user-attachments/assets/55fa983b-7888-44c4-8a5a-1ca03638a65e

The backend project can be found [here](https://github.com/singhayush20/doc_helper_backend).

## Features

### Chat Interface
- **AI-Powered Questions**: Ask questions about your uploaded documents and receive AI-generated responses
- **Conversation History**: Access previous conversations and maintain context across multiple sessions
- **Real-Time Responses**: Get instant answers powered by advanced language models

### Document Summarizer
- **Generate document summary**: Generate a summary for your documents by controlling tone and length.
- **Share and Save**: Share or save the document summary from within the summarizer interface.
- **Track your activity**: Track what you did in the app, as recent activity.

### User Authentication
- **Secure Sign-Up**: Create accounts with email verification
- **Password Recovery**: Reset passwords through email-based verification
- **Session Management**: Automatic session handling and logout functionality

### Subscription & Billing
- **Multiple Plans**: Choose from different subscription tiers with varying features
- **Token-Based Usage**: Monthly token limits for API interactions
- **Payment Integration**: Secure payment processing with Razorpay
- **Subscription Management**: View, upgrade, or manage active subscriptions
- **Usage Tracking**: Monitor monthly token consumption and reset dates
- **Flexible Billing**: Cancel subscriptions with grace periods

### User Profile
- **Usage Analytics**: Track current token usage against monthly limits
- **Subscription Details**: View active plan, pricing, and renewal information

## Architecture

### Project Structure

```
lib/
├── core/                          # Core functionality and utilities
│   ├── common/                    # Shared components
│   │   ├── base_bloc/             # Base BLoC classes for state management
│   │   ├── base_widget/           # Base widget utilities
│   │   ├── constants/             # App-wide constants
│   │   └── utils/                 # Common utility functions
│   ├── exception_handling/        # Custom exception definitions
│   ├── extensions/                # Dart extensions for objects
│   ├── local_storage/             # Local data persistence (Hive)
│   ├── network/                   # API client configuration (Retrofit/Dio)
│   ├── permission_handler/        # Device permission management
│   ├── router/                    # Navigation routing (GoRouter)
│   └── utils/                     # General utilities
│
├── design/                        # Design system components
│   ├── atoms/                     # Basic UI components (Text, Icons, Buttons)
│   ├── molecules/                 # Composite UI components (Lists, Cards)
│   ├── foundations/               # Design tokens (Colors, Spacing, Typography)
│   ├── theme/                     # App theme configuration
│   └── widgets/                   # Custom widgets
│
├── di/                            # Dependency injection setup
│   └── injection.dart             # GetIt and Injectable configuration
│
├── env/                           # Environment configuration
│   └── config_options.dart        # Dev/Prod environment settings
│
├── feature/                       # Feature modules (Clean Architecture)
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Data layer (DTOs, API calls)
│   │   ├── domain/                # Domain layer (Entities, Use Cases)
│   │   └── presentation/          # Presentation layer (UI, BLoC)
│   ├── user_docs/                 # Document management
│   ├── chat/                      # Chat interface
│   ├── billing/                   # Billing and payments
│   ├── plan/                      # Subscription plans
│   ├── profile/                   # User profile management
│   ├── payment_gateway/           # Payment processing
│   ├── user_activity/             # User activity tracking
│   ├── main/                      # Main landing page
│   ├── splash_screen/             # Splash screen
│   └── features_page/             # App features showcase
│
├── main_dev.dart                  # Development environment entry
├── main_prod.dart                 # Production environment entry
```

### Design Patterns & Technologies

**State Management**: Flutter BLoC with Freezed for immutable state classes  
**API Integration**: Retrofit and Dio for type-safe REST API calls  
**Dependency Injection**: GetIt with Injectable for service location and registration  
**Local Storage**: Hive for offline-first local data persistence  
**Navigation**: GoRouter for declarative routing  
**UI/UX**: Flutter ScreenUtil for responsive design across different screen sizes  
**Data Parsing**: JSON serialization with json_serializable for type safety  
**Authentication**: Firebase Authentication for secure user management  
**Payments**: Razorpay integration for payment processing  
**Loading States**: Custom loader overlay with global state management  
**Images & Media**: Cached network images and file picker for media handling  
**Markdown Rendering**: GPT Markdown for rich text rendering of AI responses  
**Animations**: Lottie for smooth animation effects  
**Pagination**: Infinite scroll pagination for efficient list rendering  

## Environment Configuration

The app supports multiple environments:

- **Development**: Connects to development API and Firebase project
- **Production**: Connects to production API and Firebase project

Environment setup is handled through the `env/config_options.dart` and dependency injection.

## Key Packages

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `dio` & `retrofit` | HTTP networking |
| `get_it` & `injectable` | Dependency injection |
| `hive` | Local database |
| `go_router` | Navigation and routing |
| `firebase_auth` & `firebase_core` | Authentication |
| `razorpay_flutter` | Payment processing |
| `flutter_screenutil` | Responsive design |
| `freezed` | Code generation for immutable classes |
| `dartz` | Functional programming utilities |
| `file_picker` | File selection from device |
| `gpt_markdown` | Markdown rendering for AI responses |
| `infinite_scroll_pagination` | Efficient list pagination |
| `cached_network_image` | Image caching |
| `lottie` | Animation support |

## Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd doc_helper_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (BLoC, DTOs, Injectable)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run -t lib/main_prod.dart          # Production
   flutter run -t lib/main_dev.dart      # Development
   ```

## Project Setup Notes

- **Responsive Design**: Built with Flutter ScreenUtil (design size: 360x690)
- **App Orientation**: Locked to portrait mode
- **Theme**: Custom design system with primary colors and typography
- **Icons**: Material Design icons with custom SVG support
- **Linting**: Follows Flutter linting rules defined in `analysis_options.yaml`

## Code Generation

This project uses code generation for several features:

```bash
# Generate all code
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean before rebuilding (if issues occur)
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

Generated code includes:
- BLoC state and event classes (Freezed)
- API client implementations (Retrofit)
- Dependency injection configuration (Injectable)
- JSON serialization (json_serializable)

## Development Workflow

1. **Feature Development**: Add features within the `feature/` directory following the module structure
2. **State Management**: Use BLoC pattern with Freezed for type safety
3. **API Integration**: Define Retrofit services and update API clients
4. **Dependency Injection**: Use @Injectable annotations and configure in injection.dart
5. **Styling**: Utilize design system components from the `design/` directory

