# MyJudo Flutter App

A cross-platform mobile application for tracking judo training sessions, built with Flutter and designed to work with the existing MyJudo Raku backend.

## Features

- **User Authentication**: Login and registration
- **Training Statistics**: View comprehensive training statistics including sessions, techniques, and progress over time
- **Session Management**: View and manage training sessions (add/edit functionality coming soon)
- **Cross-Platform**: Works on Android, iOS, and Desktop (Linux, macOS, Windows)

## Architecture

The app is structured using the Model-View-Controller (MVC) pattern with the following components:

### Models
- `User`: Represents user data and training statistics
- `TrainingSession`: Represents individual training sessions with techniques and types

### Services
- `ApiService`: Handles all communication with the Raku backend API
- Manages authentication state and session cookies
- Provides methods for user data, training sessions, and authentication

### Screens
- `LoginScreen`: User authentication
- `RegisterScreen`: New user registration
- `HomeScreen`: Main dashboard with statistics and quick actions
- `TrainingSessionsScreen`: List and view training sessions

## Setup

### Prerequisites
- Flutter SDK (installed)
- Raku backend server running on localhost

### Installation

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   # For desktop (Linux)
   flutter run -d linux
   
   # For Android (requires Android Studio setup)
   flutter run -d android
   
   # For iOS (requires Xcode on macOS)
   flutter run -d ios
   ```

## Backend Integration

The Flutter app communicates with the existing Raku backend via HTTP requests. The `ApiService` class handles:

- Session-based authentication using cookies
- RESTful API calls for user data and training sessions
- Error handling and connection management

### API Endpoints Used

- `POST /login` - User authentication
- `POST /register` - User registration
- `GET /logout` - User logout
- `GET /api/user/{username}` - Get user data (will need to be implemented in Raku backend)
- `GET /api/training-sessions/{userId}` - Get training sessions (will need to be implemented in Raku backend)
- `POST /api/training-session/add` - Add training session (will need to be implemented in Raku backend)
- `PUT /api/training-session/{id}` - Update training session (will need to be implemented in Raku backend)

## Next Steps

To complete the mobile app, you'll need to:

1. **Add API endpoints to your Raku backend** for:
   - JSON user data (`/api/user/{username}`)
   - JSON training sessions (`/api/training-sessions/{userId}`)
   - Add/edit training sessions via JSON API

2. **Implement remaining features**:
   - Add training session screen
   - Edit training session screen
   - Password reset functionality
   - Offline support with local storage

3. **Mobile-specific optimizations**:
   - Add proper app icons
   - Configure splash screens
   - Add push notifications
   - Implement biometric authentication

4. **Testing and deployment**:
   - Set up Android/iOS development environment
   - Test on physical devices
   - Prepare for app store deployment

## Development Notes

- The app uses Provider for state management
- HTTP client handles session cookies automatically
- Material Design 3 theming for consistent UI
- Responsive design works on various screen sizes

## Running with Raku Backend

To test the full functionality:

1. Start your Raku backend server:
   ```bash
   cd /home/lancew/dev/MyJudo
   raku service.p6
   ```

2. Run the Flutter app:
   ```bash
   cd /home/lancew/dev/myjudo_flutter
   flutter run -d linux
   ```

The app will connect to the Raku backend running on localhost and you can test login/registration functionality.
