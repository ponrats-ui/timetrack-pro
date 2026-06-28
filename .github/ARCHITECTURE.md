# Architecture

Business OS is a modular platform of independent Business Assistants.

It must never become an ERP-style monolith.

## Assistant Rules

Every Assistant must be:

- Installable independently.
- Removable independently.
- Independently useful.
- Independently sellable.
- Integrated with Shared Core when platform capabilities are needed.

## Shared Platform Capabilities

Every Assistant should reuse shared platform capabilities:

- Authentication
- Authorization
- Configuration
- Database
- Reporting
- Notification
- Localization
- Theme
- AI Layer
- Analytics
- Audit
- Security

## Current Assistant

TimeTrack Pro is the Employee Assistant.

It is responsible for attendance, payroll-ready calculations, work records,
reports, and employee insights.

## Architecture Principles

- Shared Core everywhere.
- No duplicated logic.
- No hardcoded company rules.
- Business rules must be configurable.
- Platform interfaces should be reusable across Assistants.
- Implementation convenience never overrides product philosophy.
