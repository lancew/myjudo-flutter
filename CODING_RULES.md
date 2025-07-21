# Project Coding Rules for myjudo_flutter

1. **Always add or update tests**
   - Every new feature, bug fix, or refactor must include relevant unit, widget, or integration tests.
   - Code without tests should be flagged for follow-up.

2. **No test-only hacks in production code**
   - Use interfaces and dependency injection for testability.
   - Never add test-only methods or fields to production classes.

3. **Keep code and tests clean**
   - Remove unused imports, dead code, and test scaffolding after refactors.
   - Ensure all tests pass before considering a change complete.

4. **Consistent dependency injection**
   - All services used by widgets should be injectable (via constructor or provider).
   - Avoid hard-coding singletons in widgets.

5. **Database and async code**
   - Use in-memory or mock services for tests, never the real database.
   - Widget tests should not depend on real async delays.

6. **Documentation**
   - Public classes and methods should have doc comments.
   - Complex logic should be explained in code comments.

7. **Code formatting and linting**
   - All code should be formatted with `dart format` and pass `flutter analyze`. 