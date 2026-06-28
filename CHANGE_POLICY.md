# Change Policy

This policy defines how Business OS changes should be evaluated before
implementation and release.

## Documentation-Only Changes

When a sprint is documentation-only:

- Do not modify runtime behavior.
- Do not modify business logic.
- Do not redesign UI.
- Do not introduce new features.

## Product Changes

Every product change must solve a real customer problem and improve at least
one of:

- Save time.
- Reduce mistakes.
- Reduce stress.
- Increase confidence.
- Improve business visibility.

## Business Rules

Business rules must be configurable. Do not hardcode company-specific rules.

Examples include payroll, overtime, allowances, taxes, social security,
business hours, and holiday rules.

## Architecture Changes

Architecture changes must support modular Assistants and shared platform
capabilities.

Do not duplicate business logic across Assistants.

## Verification

Every release must pass required verification. If verification fails, do not
commit or ship failing changes.

Common verification:

```powershell
flutter analyze
flutter test
flutter build web
```
