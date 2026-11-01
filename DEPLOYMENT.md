# Share a Sudhaar demonstration

This deployment is a public demo: the seeded accounts in README.md remain active,
and OTP codes are displayed because SMS delivery is not implemented. Use sample
data only. Before collecting real citizen data, connect SMS, disable dev OTP,
and replace all seeded passwords.

## Docker locally

Install Docker Desktop, then run from this directory:

```powershell
docker compose up --build -d
```

Open http://localhost:7860. The named volume preserves the database, uploaded
media, and signing key across container restarts. Do not use `down -v` unless
you intend to delete that data. Phone camera access needs an HTTPS cloud URL.

## Cloud on Render

1. Push Dockerfile, .dockerignore, compose.yaml, and render.yaml to the GitHub repository.
2. Open https://dashboard.render.com/select-repo?type=blueprint and select
   Snehlata826/Sudhaar, branch main.
3. Review the paid Standard compute and 1 GB disk charges, then deploy.
4. Wait for the Docker build and /api/meta health check to pass. Copy the HTTPS
   onrender.com URL shown by Render and share it with reviewers.

The Docker build includes CPU PyTorch and both YOLO models, so the initial build
can take longer than five minutes. A persistent disk is required to keep SQLite
and media across deployments. One instance is intentional for SQLite storage.
The blueprint generates a signing secret; API keys are optional and should be
set in Render's Environment settings, never committed.

Demo accounts: admin / admin1234, vmc_eng / demo1234,
sudhaar / sudhaar1234. Citizen login uses a valid Indian mobile number and the
on-screen demo OTP. See README.md for the remaining departments.
