# Contributing to MyJudo Flutter

Thank you for your interest in contributing to MyJudo Flutter! This document provides guidelines for contributing to the project.

## Development Setup

1. **Install Flutter SDK** (3.32.6 or higher)
2. **Clone the repository**:
   ```bash
   git clone https://github.com/lancew/myjudo-flutter.git
   cd myjudo-flutter
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the app**:
   ```bash
   flutter run -d linux  # For desktop testing
   ```

## Backend Setup

The app connects to a Raku backend. To test full functionality:

1. Clone the backend repository: `https://github.com/lancew/MyJudo`
2. Start the backend server: `raku service.p6`
3. The Flutter app will connect to `http://localhost`

## Code Style

- Follow Dart's official style guide
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues
- Ensure all tests pass with `flutter test`

## Git Workflow

1. **Fork the repository** on GitHub
2. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** and commit:
   ```bash
   git commit -m "Add: your feature description"
   ```
4. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
5. **Create a Pull Request** on GitHub

## Pull Request Guidelines

- **Clear description**: Explain what your PR does and why
- **Reference issues**: Link to related GitHub issues
- **Tests**: Add tests for new functionality
- **Documentation**: Update README or comments if needed
- **One feature per PR**: Keep PRs focused and manageable

## Commit Message Format

Use clear, descriptive commit messages:
- `Add: new feature description`
- `Fix: bug description`
- `Update: change description`
- `Refactor: code improvement description`

## Project Structure

```
lib/
├── models/          # Data models
├── services/        # API and business logic
├── screens/         # UI screens
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

## Testing

- Write unit tests for models and services
- Write widget tests for UI components
- Write integration tests for user flows
- Run tests with: `flutter test`

## Priority Areas for Contribution

Check the [TODO.md](TODO.md) file for current priorities:

1. **Backend API Integration**: Add JSON endpoints to Raku backend
2. **Add/Edit Training Sessions**: Complete CRUD operations
3. **Mobile Testing**: Android/iOS testing and optimization
4. **UI/UX Improvements**: Enhanced user experience
5. **Offline Support**: Local data storage and sync

## Questions and Support

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For general questions and ideas
- **Email**: Contact the maintainer for urgent issues

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

Thank you for contributing to MyJudo Flutter! 🥋
