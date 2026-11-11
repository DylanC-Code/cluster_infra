# eu1

Production cluster in Europe: par1 (Hostinger, Paris), waw1 (OVH, Warsaw),
gra1 (OVH, Gravelines). All three run the control plane and etcd.

Nodes and admin UIs live on `dylancastor.dev`; apps on their own domains.

Contents are added phase by phase: `bootstrap/` in Phase 4, then
`platform.yaml`, `apps.yaml` and `values/` as components and apps arrive.
