# activate.ps1 — I.N.A.Y.A.T. Super Engineer Activator
$ErrorActionPreference = "Stop"

Write-Host "[1/6] Checking Python..." -ForegroundColor Cyan
python --version

Write-Host "[2/6] Verifying virtual environment..." -ForegroundColor Cyan
if (-not (Test-Path ".venv/Scripts/python.exe")) {
    Write-Host "Creating venv with Python..." -ForegroundColor Yellow
    python -m venv .venv
}

Write-Host "[3/6] Installing locked dependencies..." -ForegroundColor Cyan
& .venv\Scripts\pip install -r requirements.txt -c constraints.txt --upgrade

Write-Host "[4/6] Checking data/documents..." -ForegroundColor Cyan
if (-not (Test-Path "data/documents")) {
    New-Item -ItemType Directory -Path "data/documents" -Force | Out-Null
}
$profileDocs = Get-ChildItem -Path "data/documents" -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Extension -in ".pdf", ".txt" -and
        $_.DirectoryName -notmatch "[\\/]_samples([\\/]|$)"
    }
if (-not $profileDocs) {
    $demoDir = "data/documents/Demo"
    New-Item -ItemType Directory -Path $demoDir -Force | Out-Null
    $samples = Get-ChildItem -Path "data/documents/_samples" -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -in ".pdf", ".txt" }
    if ($samples) {
        Copy-Item -Path $samples.FullName -Destination $demoDir -Force
        Write-Host "Seeded demo profile 'Demo' from data/documents/_samples." -ForegroundColor Yellow
    } else {
        @"
I.N.A.Y.A.T. is a next-generation agentic RAG system built for MCA 2026.
It combines Google Gemini, Mem0 memory, and Neo4j knowledge graphs.
The architecture uses a self-healing circuit breaker.
"@ | Out-File -FilePath "$demoDir/sample.txt" -Encoding utf8
        Write-Host "Created demo document data/documents/Demo/sample.txt." -ForegroundColor Yellow
    }
}

Write-Host "[5/6] Running service warmup..." -ForegroundColor Cyan
& .venv\Scripts\python warmup.py

Write-Host "[6/6] Launching Streamlit..." -ForegroundColor Cyan
if (-not $env:INAYAT_DEMO_MODE) {
    $env:INAYAT_DEMO_MODE = "true"
    Write-Host "INAYAT_DEMO_MODE enabled for presentation circuit-breaker demos." -ForegroundColor Yellow
}
& .venv\Scripts\streamlit run app.py
