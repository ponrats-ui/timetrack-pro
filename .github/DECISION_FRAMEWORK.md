# Decision Framework

Business OS decisions follow this priority order:

1. Founder Vision
2. Customer Value
3. Architecture
4. Engineering
5. Implementation

Implementation convenience must never override product vision.

## Founder Vision

The founder defines product vision, architecture direction, customer
philosophy, long-term roadmap, and AI governance.

Future contributors must preserve these principles unless explicitly changed by
the founder.

## Customer Value

Every feature must answer:

- Does this solve a real customer problem?
- Would a restaurant owner understand this?
- Would a coffee shop owner use this tomorrow?
- Does this reduce stress?
- Does this save time?
- Does this reduce mistakes?

If the answer is no, redesign before implementation.

## Architecture

Every Assistant should remain independently useful and sellable while sharing
the same platform direction.

Business logic should be reusable. Rules should be configurable. Company-
specific assumptions should not be hardcoded.

## Engineering

Engineering choices must protect reliability, maintainability, testability, and
production quality.

## Implementation

Implementation details are the final layer. They must serve the product,
customer, architecture, and engineering principles above them.
