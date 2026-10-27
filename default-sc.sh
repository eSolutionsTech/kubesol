#!/bin/bash
# List StorageClasses, or set one as the cluster default.
# Usage:
#   ./default-sc.sh              # list storage classes
#   ./default-sc.sh <name>       # set <name> as default; exit 1 if it does not exist

set -euo pipefail

list_storage_classes() {
  kubectl get storageclass
}

if [[ $# -eq 0 ]]; then
  list_storage_classes
  exit 0
fi

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [storage-class-name]" >&2
  exit 1
fi

SC="$1"

if ! kubectl get storageclass "$SC" >/dev/null 2>&1; then
  echo "Storage class '$SC' not found; listing storage classes:" >&2
  list_storage_classes
  exit 1
fi

# Clear default on all StorageClasses, then mark the requested one as default.
while read -r name; do
  [[ -z "$name" ]] && continue
  kubectl annotate storageclass "$name" \
    storageclass.kubernetes.io/is-default-class- \
    --overwrite >/dev/null
done < <(kubectl get storageclass -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

kubectl annotate storageclass "$SC" \
  storageclass.kubernetes.io/is-default-class=true \
  --overwrite >/dev/null

echo "Default StorageClass is now: $SC"
list_storage_classes
