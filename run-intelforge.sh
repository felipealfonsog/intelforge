#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${PROJECT_ROOT}"

INTELFORGE_BIN="${PROJECT_ROOT}/bin/intelforge"
CONFIG_PATH="${1:-${PROJECT_ROOT}/config/sample.yml}"

ARTIFACTS_BASE="${PROJECT_ROOT}/artifacts"
LOGS_BASE="${PROJECT_ROOT}/logs"

TS="$(date -u +"%Y%m%dT%H%M%SZ")"
RUN_DIR="${ARTIFACTS_BASE}/run-${TS}"
LOG_FILE="${LOGS_BASE}/run-${TS}.log"

mkdir -p "${RUN_DIR}" "${LOGS_BASE}"

echo "IntelForge runner"
echo " - UTC timestamp: ${TS}"
echo " - Config: ${CONFIG_PATH}"
echo " - Run dir: ${RUN_DIR}"
echo " - Log: ${LOG_FILE}"
echo

"${INTELFORGE_BIN}" run --config "${CONFIG_PATH}" --artifacts "${RUN_DIR}" \
  > >(tee -a "${LOG_FILE}") \
  2> >(tee -a "${LOG_FILE}" >&2)

RC=$?

if [[ $RC -ne 0 ]]; then
  echo "IntelForge status: FAILED (${RC})" | tee -a "${LOG_FILE}"
  exit $RC
fi

echo "IntelForge status: OK" | tee -a "${LOG_FILE}"
echo "Artifacts saved under: ${RUN_DIR}"