#### intelforge
Defensive CTI pipeline built in Perl. IntelForge is a Perl-first, CLI-driven defensive cyber threat intelligence (CTI) pipeline that ingests public sources, extracts and normalizes indicators, applies lightweight rules and scoring, and produces auditable artifacts (JSONL + reports).

#

IntelForge is an open-source, Perl-first defensive cyber threat intelligence (CTI) pipeline designed for analysts and engineers who want a reproducible, auditable, and automation-friendly workflow. IntelForge ingests authorized public sources (RSS/Atom feeds, local files, and curated text inputs), extracts indicators of compromise (IOCs) such as domains, IP addresses, and file hashes, and normalizes them into a strict JSONL format with provenance and timestamps. It then applies a rules layer to tag and score indicators based on evidence strength and source reliability, generating artifacts suitable for downstream tooling (SIEM, case management, data lakes) while keeping the core pipeline transparent and testable.
IntelForge is explicitly defensive: it focuses on collection, normalization, correlation signals, and reporting—no exploitation, targeting guidance, or intrusive scanning. The CLI is the product: if optional UI/report tooling is added later, it will remain non-required and strictly downstream from the Perl core outputs.
