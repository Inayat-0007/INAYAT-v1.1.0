# Changelog

All notable changes to I.N.A.Y.A.T. are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] — 2026-10-31

Baseline before this release: single commit `v1.0.0-august-inayat` (incremental
ingest, PDF extract, user-scoped RAG, Streamlit UI, Mem0 session fix).

### Added

- `.streamlit/config.toml` — dark neon cyber theme for the Streamlit UI.
- `.github/workflows/integration.yml` — weekly schedule + manual `workflow_dispatch`
  live integration tests (`tests/backend_feature_test.py`).
- `RUN_REAL_SETUP.txt` — end-to-end setup, verification, and troubleshooting guide.
- `_ensure_ca_bundle()` — certifi CA fallback so Neo4j TLS works on Windows.
- `ping_mem0()` — real read probe so the Mem0 health check reflects live state.

### Changed

- Adopted a dark neon cyber palette across Streamlit and React
  (`#020304`, `#39FF14`, `#BF00FF`, `#A855F7`).
- CI runs on Python 3.12 with `pip-audit` (advisory) and a parallel frontend build.
- Documentation test counts normalized to **59 smoke / 10 live**.
- Docker SPA healthcheck now targets `GET /api/startup`.

### Fixed

- Neo4j TLS failures on Windows resolved via the certifi CA bundle.
- FastAPI startup blocked the event loop; moved to `asyncio.to_thread`.
- Malformed sample PDFs (`inayat_company_facts.pdf`, `inayat_product_overview.pdf`)
  regenerated as valid, text-extractable PDFs.
- Stale live-test fallback assertion corrected.
- Browser E2E assertions aligned with current UI copy.
- `run_spa.py` npm invocation fixed for Windows.
- `activate.ps1` now seeds sample documents into the demo profile.

### Removed

- Stale `Rahul` persona copy and outdated `52` test references.

[Unreleased]: https://github.com/Inayat-0007/INAYAT/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/Inayat-0007/INAYAT/releases/tag/v1.1.0
