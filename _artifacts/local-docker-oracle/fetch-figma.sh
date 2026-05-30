#!/usr/bin/env bash
# NSCM Figma REST API fetch (bash 버전)
#
# 사용법:
#   ./fetch-figma.sh <FIGMA_URL>
#   ./fetch-figma.sh <FIGMA_URL> --out temp.json
#   ./fetch-figma.sh <FIGMA_URL> --minimal
#
# 인증: /c/Projects/NSCM/.figma_token
#
# Exit codes: 0 OK / 1 no token / 2 URL parse / 3 HTTP fail

set -e

URL=""
OUT_FILE=""
MINIMAL=false
DEPTH=5
TOKEN_FILE="${TOKEN_FILE:-/c/Projects/NSCM/.figma_token}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out) OUT_FILE="$2"; shift 2 ;;
    --minimal) MINIMAL=true; shift ;;
    --depth) DEPTH="$2"; shift 2 ;;
    --token-file) TOKEN_FILE="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: $0 <FIGMA_URL> [--out FILE] [--minimal] [--depth N] [--token-file PATH]"
      exit 0 ;;
    *)
      if [[ -z "$URL" ]]; then URL="$1"; fi
      shift ;;
  esac
done

# Token
if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "ERROR: $TOKEN_FILE 없음" >&2
  echo "  발급: https://www.figma.com/settings → Personal access tokens" >&2
  exit 1
fi
TOKEN=$(tr -d '\r\n ' < "$TOKEN_FILE")
if [[ ${#TOKEN} -lt 10 ]]; then
  echo "ERROR: $TOKEN_FILE 내용 비정상 (length=${#TOKEN})" >&2
  exit 1
fi

# URL 파싱
if [[ -z "$URL" ]]; then
  echo "ERROR: URL 인자 필수" >&2
  exit 2
fi
FILE_KEY=$(echo "$URL" | sed -nE 's|.*/(design|file)/([A-Za-z0-9]+).*|\2|p')
if [[ -z "$FILE_KEY" ]]; then
  echo "ERROR: URL 에서 file_key 추출 실패: $URL" >&2
  exit 2
fi
NODE_ID=$(echo "$URL" | sed -nE 's|.*[?&]node-id=([^&]+).*|\1|p')
API_NODE_ID="${NODE_ID//-/:}"

# Endpoint
ENDPOINT="https://api.figma.com/v1/files/$FILE_KEY"
if [[ -n "$NODE_ID" ]]; then
  ENC_NODE_ID=$(printf '%s' "$API_NODE_ID" | sed 's/:/%3A/g')
  ENDPOINT="$ENDPOINT?ids=$ENC_NODE_ID&depth=$DEPTH&geometry=paths"
else
  ENDPOINT="$ENDPOINT?depth=$DEPTH"
fi

echo "[fetch] $ENDPOINT"

# Fetch
RESPONSE=$(curl -s --max-time 60 -H "X-Figma-Token: $TOKEN" "$ENDPOINT")
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 60 -H "X-Figma-Token: $TOKEN" "$ENDPOINT")
if [[ "$HTTP_STATUS" != "200" ]]; then
  echo "ERROR: HTTP $HTTP_STATUS" >&2
  echo "$RESPONSE" | head -c 500 >&2
  echo >&2
  exit 3
fi

# Save full
if [[ -n "$OUT_FILE" ]]; then
  mkdir -p "$(dirname "$OUT_FILE")"
  echo "$RESPONSE" > "$OUT_FILE"
  SIZE=$(wc -c < "$OUT_FILE")
  echo "  saved: $OUT_FILE ($((SIZE/1024)) KB)"
fi

# Summary (jq 가 있으면 사용, 없으면 grep)
if command -v jq >/dev/null 2>&1; then
  echo ""
  echo "=== Figma File ==="
  echo "$RESPONSE" | jq -r '"  name        : " + .name + "\n  lastModified: " + .lastModified + "\n  version     : " + .version'

  if [[ "$MINIMAL" == "true" ]]; then exit 0; fi

  echo ""
  echo "=== Node tree (depth <= 3) ==="
  if echo "$RESPONSE" | jq -e '.nodes' >/dev/null 2>&1; then
    echo "$RESPONSE" | jq -r '.nodes[].document | recurse(.children[]?; . != null) | "[" + .type + "] " + .name' | head -50
  else
    echo "$RESPONSE" | jq -r '.document | recurse(.children[]?; . != null) | "[" + .type + "] " + .name' | head -50
  fi
else
  echo ""
  echo "=== Summary (jq 미설치 — limited) ==="
  echo "$RESPONSE" | grep -oE '"name":"[^"]*"' | head -20
fi

exit 0
