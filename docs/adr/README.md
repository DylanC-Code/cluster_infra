# Architecture decision records

One short file per structural decision: the context, the decision, and its
consequences. A decision is never edited away: a new ADR supersedes it.

File name: `NNNN_short_title.md`, numbered in order.

| ADR | Decision | Status |
| --- | --- | --- |
| [0001](0001_record_architecture_decisions.md) | Record decisions as ADRs | Accepted |
| [0002](0002_repository_layout.md) | Repository layout and rules | Accepted, rules 3 and 5 amended by 0004, rule 10 by 0006, rule 3 by 0008 |
| [0003](0003_platform_choices.md) | Platform choices for the eu1 cluster | Accepted |
| [0004](0004_component_source_file.md) | Each component declares its chart in source.yaml | Accepted, rule 3 amended by 0005 and 0007 |
| [0005](0005_component_dashboards_file.md) | A component's dashboards in their own values file | Accepted |
| [0006](0006_exported_dashboards.md) | Dashboards of our own are exported JSON, outside the line limit | Accepted |
| [0007](0007_component_rules_file.md) | A component's alert rules in their own values file | Accepted |
| [0008](0008_staging_optional.md) | An app's staging is optional | Accepted |
