## intelforge
Defensive CTI pipeline built in Perl. IntelForge is a Perl-first, CLI-driven defensive cyber threat intelligence (CTI) pipeline that ingests public sources, extracts and normalizes indicators, applies lightweight rules and scoring, and produces auditable artifacts (JSONL + reports).

#

## Description

IntelForge is an open-source, Perl-first defensive cyber threat intelligence (CTI) pipeline designed for analysts and engineers who want a reproducible, auditable, and automation-friendly workflow. IntelForge ingests authorized public sources (RSS/Atom feeds, local files, and curated text inputs), extracts indicators of compromise (IOCs) such as domains, IP addresses, and file hashes, and normalizes them into a strict JSONL format with provenance and timestamps. It then applies a rules layer to tag and score indicators based on evidence strength and source reliability, generating artifacts suitable for downstream tooling (SIEM, case management, data lakes) while keeping the core pipeline transparent and testable.
IntelForge is explicitly defensive: it focuses on collection, normalization, correlation signals, and reporting—no exploitation, targeting guidance, or intrusive scanning. The CLI is the product: if optional UI/report tooling is added later, it will remain non-required and strictly downstream from the Perl core outputs.

## Features


- **Perl-first design.** Built in Perl with a focus on maintainability, testability, and transparency.
- **CLI-driven workflow.** Command-line interface for easy automation and integration into existing toolchains.
- **IOC extraction.** Extracts domains, IPs, and SHA256 hashes from authorized public sources.
- **Normalization & deduplication.** Converts IOCs into a strict JSONL format with provenance and timestamps.
- **Lightweight rules & scoring.** Applies a rules layer to tag and score indicators based on evidence strength and source reliability.
- **Auditable artifacts.** Produces JSONL outputs suitable for downstream tooling (SIEM, case management, data lakes).
- **Defensive focus.** Emphasizes collection, normalization, correlation signals, and reporting without aggressive tactics
- **Open source.** Fully open-source under the MIT License for community collaboration and transparency.

## Overview
**Perl-first defensive CTI pipeline (CLI).**

IntelForge ingests authorized sources (v0.1 starts with local files), extracts IOCs (domains, IPs, SHA256),
normalizes and deduplicates them, applies lightweight defensive rules and scoring, and produces auditable artifacts.

## Defensive-only
IntelForge is built for defensive cyber threat intelligence: collection, normalization, signals, and reporting.
No exploitation, intrusion, targeting guidance, or aggressive scanning.

## Quick start

### Install deps

```
perl Makefile.PL
make
```


## Run it
```
perl Makefile.PL
make
```
# Ensure sample exists:
```

```
mkdir -p docs/samples artifacts
echo "test indicator: example.com 1.1.1.1 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef" > docs/samples/sample1.txt
```
bin/intelforge run --config config/sample.yml --artifacts artifacts
```
# View output
```
cat artifacts/indicators.jsonl
```
artifacts/report.md

## Next upgrades (still Perl-first) are:
```
	1.	RSS ingestion (safe, rate-limited, cached)
	2.	Evidence windows (store small context around each match)
	3.	Source reliability profiles (config-driven confidence)
	4.	SQLite storage (optional) when JSONL gets too big
	5.	STIX export for interoperability
```

# IntelForge — Automation, Scheduling, and Fixes

IntelForge is designed to be easily integrated into existing toolchains and workflows. Here are some examples of how you can use IntelForge:

## 1) Manual run

Build the project:
```

perl Makefile.PL
make
```

#

Run manually:

```
perl Makefile.PL
Makefile
```
Run bash manually:
```
chmod +x run-intelforge.sh
./run-intelforge.sh
```
#

Run with explicit config:
```
./run-intelforge.sh config/sample.yml
```

#

Each run produces a timestamped directory:
```
	•	artifacts/run-<UTC_TIMESTAMP>/raw.jsonl
	•	artifacts/run-<UTC_TIMESTAMP>/iocs.jsonl
	•	artifacts/run-<UTC_TIMESTAMP>/iocs.norm.jsonl
	•	artifacts/run-<UTC_TIMESTAMP>/iocs.scored.jsonl
	•	artifacts/run-<UTC_TIMESTAMP>/report.md
```
#

Logs are written to
```
logs/run-<UTC_TIMESTAMP>.log
```

#

2) Cron (Linux + macOS)
```
crontab -e
```
Example: run daily at 02:30 (local time):
```
30 2 * * * /absolute/path/to/intelforge/run-intelforge.sh /absolute/path/to/intelforge/config/sample.yml >> /absolute/path/to/intelforge/logs/cron.log 2>&1
```

NOTES:
	•	Always use absolute paths.
	•	Cron environments are minimal; if Perl is not found, set PATH explicitly.


#

3) systemd — user timer (Arch Linux / Debian-based)

Service file
```
~/.config/systemd/user/intelforge.service
```
```
[Unit]
Description=IntelForge CTI pipeline (user)

[Service]
Type=oneshot
WorkingDirectory=%h/path/to/intelforge
ExecStart=%h/path/to/intelforge/run-intelforge.sh %h/path/to/intelforge/config/sample.yml
```

Timer file
```
~/.config/systemd/user/intelforge.timer
```
```
[Unit]
Description=Run IntelForge daily (user)

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=default.target
```

Enable:
```
systemctl --user daemon-reload
systemctl --user enable --now intelforge.timer
systemctl --user list-timers | grep intelforge
journalctl --user -u intelforge.service -n 200 --no-pager
```
4) systemd — system-wide timer (optional)

Service
```
/etc/systemd/system/intelforge.service
```
```
[Unit]
Description=IntelForge CTI pipeline (system)

[Service]
Type=oneshot
User=felipe
WorkingDirectory=/absolute/path/to/intelforge
ExecStart=/absolute/path/to/intelforge/run-intelforge.sh /absolute/path/to/intelforge/config/sample.yml
```
Timer
```
/etc/systemd/system/intelforge.timer
```
```
[Unit]
Description=Run IntelForge daily (system)

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```
Enable:
```
sudo systemctl daemon-reload
sudo systemctl enable --now intelforge.timer
sudo systemctl list-timers | grep intelforge
journalctl -u intelforge.service -n 200 --no-pager
```

#

5) macOS (Intel + Apple Silicon) — launchd

LaunchAgent
```
~/Library/LaunchAgents/com.intelforge.pipeline.plist
```
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.intelforge.pipeline</string>

  <key>ProgramArguments</key>
  <array>
    <string>/absolute/path/to/intelforge/run-intelforge.sh</string>
    <string>/absolute/path/to/intelforge/config/sample.yml</string>
  </array>

  <key>WorkingDirectory</key>
  <string>/absolute/path/to/intelforge</string>

  <key>StandardOutPath</key>
  <string>/absolute/path/to/intelforge/logs/launchd.out.log</string>

  <key>StandardErrorPath</key>
  <string>/absolute/path/to/intelforge/logs/launchd.err.log</string>

  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>2</integer>
    <key>Minute</key>
    <integer>30</integer>
  </dict>

  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
```


#
Load and manage:

```
launchctl load ~/Library/LaunchAgents/com.intelforge.pipeline.plist
launchctl list | grep intelforge
launchctl unload ~/Library/LaunchAgents/com.intelforge.pipeline.plist
```
#


## Contributing

Contributions are welcome! Please contribute by submitting a pull request or opening an issue.

## License

IntelForge is licensed under the [BSD3-clause](LICENSE).

## Contact

If you have any questions or feedback, please reach out to us at [felipe@gnlz.cl](mailto:felipe@gnlz.cl).


