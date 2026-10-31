# I.N.A.Y.A.T. v1.1.0

Single-agent agentic RAG with persistent memory, property-graph retrieval, and dual UIs
(Streamlit + FastAPI/React). Built on Google Gemini, LlamaIndex `PropertyGraphIndex`,
Neo4j AuraDB, and Mem0.

## Highlights

- **Dark neon cyber theme** applied consistently across the Streamlit app and the React SPA.
- **Neo4j TLS fixed on Windows** — the driver now falls back to the certifi CA bundle.
- **Non-blocking FastAPI startup** — boot work runs off the event loop via `asyncio.to_thread`.
- **Real Mem0 health probe** — `ping_mem0()` performs a live read instead of reporting a cached state.
- **Valid sample PDFs** — `inayat_company_facts.pdf` and `inayat_product_overview.pdf` are valid, text-extractable PDFs again.
- **Live integration CI** — new `integration.yml` runs the 10 live tests weekly and on manual dispatch.
- **Docs normalized** to honest counts: **59 smoke** (`tests/smoke_test.py`) + **10 live** (`tests/backend_feature_test.py`).

## Upgrade notes

- **Chunking:** if you changed `INAYAT_CHUNK_SIZE` / `INAYAT_CHUNK_OVERLAP`, rebuild the index
  so stored chunks match the new settings.
- **Seed documents:** copy `data/documents/_samples/*` into `data/documents/{your_profile}/`
  before indexing. The two previously malformed sample PDFs are now valid.
- **Neo4j:** on Windows, TLS is resolved automatically via certifi; no manual CA configuration is required.

## Environment

| Variable | Required | Notes |
| --- | --- | --- |
| `GEMINI_API_KEY` | **Yes** | Generation + embeddings; the app refuses to start without it. |
| `MEM0_API_KEY` | Recommended | Memory degrades gracefully if missing. |
| `NEO4J_URI` / `NEO4J_USERNAME` / `NEO4J_PASSWORD` | Recommended | Graph retrieval degrades to LLM answers if missing. |
| `INAYAT_API_KEY` | Optional | If set, mutating `/api/*` routes require `X-INAYAT-KEY`. |
| `INAYAT_DEMO_MODE` | Optional | `true` enables circuit-breaker demo toggles. |

See `.env.example` for the full list of `INAYAT_*` tuning keys.

## Verify

```bash
# Smoke suite — 59 tests, no live keys required
python tests/smoke_test.py

# Live integration — 10 tests, requires real Gemini / Mem0 / Neo4j keys
python tests/backend_feature_test.py
```

## Known limitations

- **Soft multi-tenancy** — isolation is folder + metadata + Mem0 `user_id` on a **shared** Neo4j
  database; this is demo-grade, not a multi-tenant SaaS.
- **Optional auth** — `INAYAT_API_KEY` is empty by default; the demo is open unless you set it.
- **Free-tier rate limits** — Gemini free tier is rate limited; heavy indexing may hit `429`s
  (the app retries with exponential backoff).

Full details: [CHANGELOG.md](https://github.com/Inayat-0007/INAYAT/blob/main/CHANGELOG.md).
