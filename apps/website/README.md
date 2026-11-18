# website

dylancastor.com: Dylan's site, static pages built with Astro.

- **Repo**: [DylanC-Code/DylanCastorSite](https://github.com/DylanC-Code/DylanCastorSite).
  Its CI scans the image (Trivy) and, on every push to main, publishes it as
  `ghcr.io/dylanc-code/dylancastor-site:<commit>` and `:main`. Publishing is
  not deploying: the prod overlay pins `main` by its digest, and Renovate
  opens a pull request here when `main` moves (`.github/renovate.json5`).
  Merging it deploys; reverting it rolls back.
- **Image**: the built pages served as files by static-web-server, on port
  8080, `GET /health` for the probes (the repo's `Dockerfile`, `sws.toml`).
- **Domains**: prod `dylancastor.com`, with `www.dylancastor.com`
  redirected to it. No staging (ADR 0008).
- **Elsewhere**: `dylancastor.com/api/message`, the contact form, is a
  Cloudflare Worker deployed by the site's repo; Cloudflare answers it
  before the tunnel, so it never reaches this app.
- **Database**: none. **Secrets**: none.

Two copies on different nodes, one at most unavailable at a time (drains,
kured's reboots).
