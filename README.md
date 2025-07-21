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
- Flutter SDK (3.32.6 or later)
- Raku backend server running on localhost
- For Android development: Android Studio, Java 17+
- For iOS development: Xcode (macOS only)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/lancew/myjudo-flutter.git
   cd myjudo-flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   # For desktop (Linux)
   flutter run -d linux
   
   # For Android emulator
   flutter run -d emulator-5554
   
   # For iOS simulator (macOS only)
   flutter run -d ios
   ```

## Android Development Setup

### Prerequisites
- Android Studio (latest version)
- Java 17 or later
- Android SDK

### Installation Steps

1. **Install Android Studio:**
   ```bash
   # On Arch Linux
   yay -S android-studio
   
   # On Ubuntu/Debian
   sudo snap install android-studio --classic
   ```

2. **Install Java 17:**
   ```bash
   # On Arch Linux
   yay -S jdk17-openjdk
   sudo archlinux-java set java-17-openjdk
   
   # On Ubuntu/Debian
   sudo apt install openjdk-17-jdk
   ```

3. **Accept Android licenses:**
   ```bash
   flutter doctor --android-licenses
   ```

4. **Install system images and create emulator:**
   ```bash
   # Install Android 11 (API 30) system image
   $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "system-images;android-30;google_apis_playstore;x86_64"
   
   # Create emulator
   flutter emulators --create --name pixel_android30
   ```

### Running on Android

1. **Set environment variables (IMPORTANT):**
   ```bash
   export ANDROID_SDK_ROOT=$HOME/Android/Sdk
   export ANDROID_HOME=$HOME/Android/Sdk
   ```

2. **Check available devices:**
   ```bash
   flutter devices
   ```

3. **Check available emulators:**
   ```bash
   flutter emulators
   ```

4. **Launch emulator:**
   ```bash
   flutter emulators --launch pixel_android30
   ```

5. **Install dependencies (if needed):**
   ```bash
   flutter pub get
   ```

6. **Run the app:**
   ```bash
   flutter run -d emulator-5554
   ```

### Troubleshooting

#### Common Issues and Solutions

**1. Emulator fails to start with "Cannot find AVD system path" error:**
   ```bash
   # Set environment variables
   export ANDROID_SDK_ROOT=$HOME/Android/Sdk
   export ANDROID_HOME=$HOME/Android/Sdk
   
   # Then try launching again
   flutter emulators --launch pixel_android30
   ```

**2. Build fails with "cannot find symbol SqflitePlugin" error:**
   ```bash
   # Install dependencies
   flutter pub get
   
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter run -d emulator-5554
   ```

**3. Emulator not detected:**
   ```bash
   # Check if emulator is running
   ps aux | grep -i emulator
   
   # Wait for emulator to fully start (can take 1-2 minutes)
   flutter devices
   ```

**4. General troubleshooting:**
   - **If emulator fails to start:** Ensure hardware acceleration is enabled in BIOS
   - **If build fails:** Run `flutter clean` and `flutter pub get`
   - **If licenses not accepted:** Run `flutter doctor --android-licenses`
   - **Check setup:** Run `flutter doctor` to verify all components
   - **Memory issues:** Close other applications to free up RAM for emulator

## Local-First & Desktop Support

- The app is now fully local-first: all data is stored in a local SQLite database.
- No authentication is required; users can use the app immediately.
- Works on Linux desktop (and other desktop platforms with sqflite_common_ffi).
- All training session data and user profile are persisted locally.
- Backend/API sync is optional and planned for the future.

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

1. **Start your Raku backend server:**
   ```bash
   cd /path/to/MyJudo
   raku service.p6
   ```

2. **Run the Flutter app:**
   ```bash
   cd /path/to/myjudo_flutter
   
   # On desktop
   flutter run -d linux
   
   # On Android emulator
   flutter emulators --launch pixel_android30  # Start emulator first
   flutter run -d emulator-5554               # Then run app
   ```

3. **Test the integration:**
   - The app will connect to the Raku backend running on localhost
   - You can test login/registration functionality
   - Note: Some features may not work until JSON API endpoints are implemented

## Quick Start Commands

```bash
# Set environment variables (IMPORTANT for Android)
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_HOME=$HOME/Android/Sdk

# Check Flutter setup
flutter doctor

# Check available devices
flutter devices

# Check available emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch pixel_android30

# Install dependencies
flutter pub get

# Run on desktop
flutter run -d linux

# Run on Android
flutter run -d emulator-5554

# Hot reload (when app is running)
r

# Hot restart (when app is running)
R

# Quit app
q
```

## Coding Rules

Please see [CODING_RULES.md](./CODING_RULES.md) for project coding standards and contribution guidelines. All contributions must follow these rules.
