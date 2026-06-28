# Contributing

Thank you for helping protect the quality and direction of Business OS.

This repository is closed-source. Contributions are accepted only from people
explicitly authorized by the repository owner or founder.

## Before You Start

Read:

- `.github/PROJECT_CONSTITUTION.md`
- `.github/FOUNDER_LETTER.md`
- `.github/CUSTOMER_PROMISE.md`
- `.github/AI_RULES.md`
- `FOUNDER.md`
- `VISION.md`
- `PRINCIPLES.md`

## Product Standard

Every change must solve a real customer problem.

Ask:

- Would a small business owner understand this?
- Would they use it tomorrow?
- Does it save time, reduce mistakes, reduce stress, increase confidence, or
  improve business visibility?
- Can the business rule be configured?
- Can another Assistant reuse this?

If not, redesign before implementation.

## Engineering Standard

- Keep the app production-ready.
- Keep business rules configurable.
- Do not duplicate business logic.
- Do not hardcode company-specific rules.
- Preserve Thai-first UX.
- Keep workflows simple.
- Prefer maintainable solutions over fast hacks.

## Documentation-Only Sprints

When a sprint is marked documentation-only:

- Do not modify application behavior.
- Do not change business logic.
- Do not change UI.
- Do not regenerate files unless explicitly requested.

## Verification

Run the verification requested by the task before committing. If verification
fails, do not commit failing code.

Typical checks:

```powershell
flutter analyze
flutter test
flutter build web
```

## Commit Messages

Use clear conventional commit messages when practical, such as:

- `docs(governance): establish founder, vision, constitution and project governance`
- `fix(ui): restore add record button interaction`
- `feat(payroll): implement configurable payroll rule engine`
