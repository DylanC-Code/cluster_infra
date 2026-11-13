# external_secrets

Turns `ExternalSecret` objects into Kubernetes Secrets, read from Bitwarden
Secrets Manager: no secret value is ever in Git. A value changed in
Bitwarden reaches its Secret at the next refresh, with no commit.

Bitwarden is reached through its SDK server (`bitwarden-sdk-server`,
installed by the same chart), over HTTPS only. Its certificate is
`config/certificates.yaml`, issued by cert_manager's `internal-ca`.

Depends on: cilium, cert_manager (the SDK server's certificate).
Depended on by: every component and app that reads a secret.

The SDK server reads its certificate only when it starts: after a renewal,
it serves the old one until its pod restarts. The certificate is renewed
30 days before it expires, which leaves that long for a restart.
