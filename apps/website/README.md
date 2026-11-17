# website

dylancastor.com: Dylan's site, static pages built with Astro.

- **Repo**: [DylanC-Code/DylanCastorSite](https://github.com/DylanC-Code/DylanCastorSite).
  Its CI builds the image on every push to main and publishes it as
  `ghcr.io/dylanc-code/dylancastor-site:<commit>`. Publishing is not
  deploying: an overlay names the commit it runs (`images` in its
  `kustomization.yaml`), and a rollback is that line set back.
- **Image**: the built pages served as files by static-web-server, on port
  8080, `GET /health` for the probes (the repo's `Dockerfile`, `sws.toml`).
- **Domains**: prod `dylancastor.com`, with `www.dylancastor.com`
  redirected to it; staging `staging.dylancastor.com`, not deployed yet
  (not in any `clusters/<name>/apps.yaml`): it needs Cloudflare Access in
  front of it first.
- **Elsewhere**: `dylancastor.com/api/message`, the contact form, is a
  Cloudflare Worker deployed by the site's repo; Cloudflare answers it
  before the tunnel, so it never reaches this app.
- **Database**: none. **Secrets**: none.

Two copies on different nodes, one at most unavailable at a time (drains,
kured's reboots).
