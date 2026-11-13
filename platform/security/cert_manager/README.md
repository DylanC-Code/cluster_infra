# cert_manager

Issues and renews TLS certificates inside the cluster. For now only
internal ones: the certificate of Bitwarden's SDK server, which External
Secrets reaches over HTTPS. Public sites get theirs from Cloudflare.

Depends on: cilium.
Depended on by: external_secrets (its SDK server's certificate).

Its resource definitions stay when the chart is removed, so removing it
never deletes existing certificates.
