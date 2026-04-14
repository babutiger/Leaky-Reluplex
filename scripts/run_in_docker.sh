#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

IMAGE_TAG="${IMAGE_TAG:-leaky-reluplex:local}"
SKIP_IMAGE_BUILD=0
RUN_ARGS=()

usage() {
    cat <<'EOF'
Usage:
  ./scripts/run_in_docker.sh [--skip-image-build] [reproduce_paper args...]

Examples:
  ./scripts/run_in_docker.sh full
  ./scripts/run_in_docker.sh --skip-image-build property1 property6 adversarial
EOF
}

require_cmd() {
    local cmd="$1"
    if ! command -v "${cmd}" >/dev/null 2>&1; then
        echo "Missing required command: ${cmd}" >&2
        exit 1
    fi
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --skip-image-build)
            SKIP_IMAGE_BUILD=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            RUN_ARGS+=("$1")
            shift
            ;;
    esac
done

if [ "${#RUN_ARGS[@]}" -eq 0 ]; then
    RUN_ARGS=(full)
fi

require_cmd docker

if [ "${SKIP_IMAGE_BUILD}" -eq 0 ]; then
    docker build -t "${IMAGE_TAG}" "${REPO_ROOT}"
fi

docker run --rm \
    --user "$(id -u):$(id -g)" \
    --volume "${REPO_ROOT}:/workspace" \
    --workdir /workspace \
    "${IMAGE_TAG}" \
    ./scripts/reproduce_paper.sh "${RUN_ARGS[@]}"
