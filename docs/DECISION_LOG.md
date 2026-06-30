# Decision Log

This log records important company and product decisions.

Each decision should explain the reason, expected benefit, and future review
point.

## Why Flutter

Decision: Use Flutter for TimeTrack Pro.

Reason: Flutter supports Android, iOS, Web, Windows, and future desktop targets
from one product codebase.

Expected Benefit: Faster development, consistent UI, and easier cross-platform
delivery for small business users.

Future Review: Revisit if platform-specific requirements become more important
than shared delivery speed.

## Why Cloudflare

Decision: Use Cloudflare-oriented deployment where practical.

Reason: Cloudflare supports fast global delivery, simple static hosting, and
low operational overhead.

Expected Benefit: Lower infrastructure complexity and easier public beta
deployment.

Future Review: Revisit if backend complexity, data residency, or enterprise
requirements require a different platform.

## Why Open Platform

Decision: Make Business OS Open by Default.

Reason: Small businesses already use many tools. Business OS should cooperate
with those tools instead of forcing replacement.

Expected Benefit: More trust, easier adoption, and less workflow disruption.

Future Review: Revisit supported formats as customer workflows evolve.

## Why Excel Stays

Decision: Excel will always remain supported.

Reason: Excel is familiar, flexible, and trusted by many small businesses,
accountants, HR teams, and owners.

Expected Benefit: Customers can adopt Business OS without losing existing
spreadsheet workflows.

Future Review: Continue improving Excel support while adding structured formats
such as JSON, `.ttp`, and `.bos`.

## Why TimeTrack Pro First

Decision: Start Business OS with TimeTrack Pro, the Employee Assistant.

Reason: Employee time, OT, payroll-ready records, and HR handoff are daily pain
points for many Thai SMEs.

Expected Benefit: Solve a clear operational problem and establish the first
assistant pattern.

Future Review: Use customer feedback to decide the next assistant.

## Why Subscription

Decision: Treat subscription as a future business model, not the first product
problem.

Reason: Customers should trust the workflow before monetization becomes the
center of the product.

Expected Benefit: Better product-market fit and pricing based on validated
customer value.

Future Review: Revisit after repeated customer usage and clear willingness to
pay.

## Why Founder Testing

Decision: Founder testing remains part of the release process.

Reason: Early products need direct, opinionated feedback from real workflows
before scaling decisions.

Expected Benefit: Faster learning, fewer confusing workflows, and stronger
customer trust.

Future Review: Expand testing with customers, partners, and support feedback as
usage grows.
