# Test Documentation

This directory contains comprehensive tests for the Payvidence Flutter application.

## Test Structure

```
test/
├── unit/                    # Unit tests
│   ├── models/             # Model tests
│   ├── services/           # Service layer tests
│   ├── providers/          # Provider/state management tests
│   └── utilities/          # Utility function tests
├── widget/                 # Widget tests
├── integration/            # Integration tests
├── test_helpers/           # Test utilities and mock data
└── test_runner.dart        # Main test runner
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests only
flutter test test/integration/

# Specific test file
flutter test test/unit/models/product_model_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Test Categories

### Unit Tests
- **Models**: Test data models, JSON serialization/deserialization
- **Services**: Test business logic, API services, caching
- **Providers**: Test state management and data flow
- **Utilities**: Test helper functions and utilities

### Widget Tests
- Test individual widgets and their behavior
- Test user interactions and UI state changes
- Test widget rendering and layout

### Integration Tests
- Test complete user flows
- Test API integration and data persistence
- Test cross-component interactions

## Test Conventions

1. **Naming**: Test files should end with `_test.dart`
2. **Structure**: Use `group()` to organize related tests
3. **Mocking**: Use mockito for mocking dependencies
4. **Data**: Use MockData helper for consistent test data
5. **Assertions**: Use descriptive test names and clear assertions

## Dependencies

Add these to `dev_dependencies` in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.9
  test: ^1.24.9
```

## Mock Generation

Generate mocks for testing:

```bash
flutter packages pub run build_runner build
```

## Coverage Goals

- Unit tests: >90% coverage
- Widget tests: >80% coverage
- Integration tests: Cover critical user flows