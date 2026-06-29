# Founder Feedback Workflow

TimeTrack Pro should improve from real user evidence, not from interesting
ideas alone. This workflow applies to Founder Feedback Sprints and any future
product-market fit work.

## Principle

The most valuable artifact is user feedback.

The second most valuable artifact is production data.

The third is code.

Do not expand product scope unless the change is backed by a real user request,
a repeated usability problem, or production data that clearly shows confusion,
mistakes, stress, or wasted time.

## Feature Filter

Before proposing a meaningful new feature, answer:

- Did a real user request this?
- Does it solve a real daily problem?
- Will it save time?
- Will it reduce mistakes?
- Will it reduce stress?
- Is it understandable without explanation?
- Can it be reused by other Business Assistants?

If most answers are "No", do not build it yet. Capture it as a possible future
idea and keep the current sprint focused on learning.

## Issue Workflow

For every user-reported issue:

1. Reproduce it.
2. Identify the root cause.
3. Classify it as one of:
   - Bug
   - UX issue
   - Missing feature
   - Product misunderstanding
4. Propose the smallest useful solution.
5. Implement only after confirmation.

The preferred solution should reduce confusion with the least product change.

## UX Defaults

Prefer one obvious button over five optional buttons.

Prefer a simple workflow over more configuration.

Prefer helpful guidance over long documentation.

Every first-time screen should answer: "What should I do next?"

## Product Goals

Founder Feedback Sprints may improve:

- First launch experience
- Record creation flow
- Navigation clarity
- Report readability
- Mobile friendliness
- Error recovery
- Empty states
- Performance

Do not redesign everything. Iterate carefully.

## Metrics

Track progress using:

- Time to first successful record
- Number of taps
- Number of reported bugs
- Number of confused users
- Number of returning users

When possible, pair qualitative feedback with simple production observations.

## Release Checklist

Each sprint should end with:

```powershell
flutter analyze
flutter test
flutter build web
git status
```

The working tree should be clean after the commit.

Release steps:

1. Commit with a clear prefix: `feat:`, `fix:`, `docs:`, `refactor:`, or
   `release:`.
2. Push to GitHub.
3. Deploy Cloudflare Pages.
4. Complete founder acceptance testing.

If a step cannot be completed from the current environment, document the reason
in the sprint handoff.

## Definition of Done

A change is finished when a real user can use it confidently without asking for
help.

For TimeTrack Pro, a first-time user should be able to open the app, understand
what it does, add a first record, save it, and view the summary without reading
documentation.
