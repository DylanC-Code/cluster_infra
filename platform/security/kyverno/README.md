# kyverno

Checks every resource before it enters an app namespace (env=staging or
env=prod), and refuses what breaks a rule: missing CPU or memory settings,
missing app.kubernetes.io/name or part-of labels, a Bitwarden key outside
the app's own. Platform namespaces are not checked: their charts come from
upstream.

It also generates, in every app namespace, the NetworkPolicy
default-isolation: the namespace's pods reach each other and DNS, nothing
else. An app opens more with a NetworkPolicy of its own.

The Restricted pod security standard is not Kyverno's: Kubernetes enforces
it itself, from the pod-security label the apps ApplicationSet puts on app
namespaces.

Rules: `config/`, tested by `tests/check_policies.sh`.

Depends on: cilium (it enforces the NetworkPolicies).
Depended on by: every app (its resources must pass the rules).

Kyverno's admission webhook runs 3 copies: when none answers, Kubernetes
refuses changes in the namespaces it checks.
