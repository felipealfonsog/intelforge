# Threat Model (IntelForge)

## Assets
- Output artifacts (IOCs + provenance)
- Source lists and analyst configurations
- Local logs and caches (future)

## Threats
- Malicious input (poisoned feeds, crafted HTML/text)
- IOC injection and false positives
- Over-collection or privacy leaks
- Supply-chain attacks on dependencies

## Mitigations
- Strict schemas and normalization
- Provenance and confidence tracking
- Rate limits, caching, and safe defaults
- Minimal privileges and local-only operation for v0.1
