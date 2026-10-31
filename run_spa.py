# -*- coding: utf-8 -*-
"""I.N.A.Y.A.T. — SPA Runner.

Orchestrates running both the FastAPI backend server (port 8000) and the
Vite development frontend server (port 5173) concurrently.
"""

import os
import shutil
import subprocess
import sys
import threading
import time

FRONTEND_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "frontend")


def _npm() -> str:
    """Return the npm executable path (``npm.cmd`` on Windows)."""
    found = shutil.which("npm")
    if not found:
        print(
            "❌ Error: npm/Node.js is not installed. Install Node.js to run the "
            "frontend developer tools."
        )
        sys.exit(1)
    return found


def run_backend() -> None:
    print("🚀 Starting FastAPI Backend Server on http://localhost:8000...")
    subprocess.run(
        [
            sys.executable,
            "-m",
            "uvicorn",
            "api:app",
            "--host",
            "0.0.0.0",
            "--port",
            "8000",
        ],
        check=False,
    )


def run_frontend(npm: str) -> None:
    print("⚡ Starting Vite React Dev Server on http://localhost:5173...")
    if not os.path.exists(os.path.join(FRONTEND_DIR, "node_modules")):
        print("⚠️ node_modules not found in /frontend. Installing packages first...")
        subprocess.run([npm, "install"], cwd=FRONTEND_DIR, check=False)

    subprocess.run([npm, "run", "dev"], cwd=FRONTEND_DIR, check=False)


def main() -> None:
    npm = _npm()

    backend_thread = threading.Thread(target=run_backend, daemon=True)
    frontend_thread = threading.Thread(target=run_frontend, args=(npm,), daemon=True)

    backend_thread.start()
    time.sleep(2.5)  # Wait for FastAPI to bind port
    frontend_thread.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n🛑 Shutting down I.N.A.Y.A.T. development servers...")
        sys.exit(0)


if __name__ == "__main__":
    main()
