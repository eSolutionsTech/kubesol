# Agents and Cursor

Starting in **October 2026**, this project began using [Cursor](https://cursor.com) (AI-assisted editing) to improve **code** and **documentation**.

Human review remains the source of truth: playbooks, Inventory, and docs should stay consistent with how the cluster is actually installed and operated. Prefer small, focused changes; keep optional components optional; and align docs with the defaults in `ansible/400-setup-k8s.yaml`.

## Conventions for agents

1. **Defaults vs optional** — Treat `ansible/400-setup-k8s.yaml` as the source of truth for what a default install runs. Do not document optional stacks (Longhorn, DirectPV, monitoring, and so on) as always installed. Keep optional imports commented unless explicitly asked to enable them.

2. **Storage** — The default path is `local-path` (marked default in `425-local-path.yaml`). Prefer omitting `storageClass` / `storageClassName` so workloads use the cluster default; leave commented `longhorn` (or other) lines rather than deleting them. Do not assume Longhorn is present.

3. **Ingress** — The in-cluster controller is **Traefik**; the default IngressClass name is **`nginx`**. Do not confuse that with the gateway host nginx (`280-gw.yaml`). IngressClass default enforcement lives in `407-ingressclass-defaults.yaml`, not in `405-get-nodes.yaml`.

4. **Docs ↔ code** — When changing playbook behavior or defaults, update the matching docs in the same change (Quickstart, component pages, hub README).

5. **Safety** — Do not wipe or format disks without Inventory vars (`longhorn_device` / `directpv_device`). Never use OS disks (for example `sda`) as wipe targets in examples.

6. **Language** — Use English for documentation, code identifiers, and comments.
