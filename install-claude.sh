#!/usr/bin/env bash

bash <<'EOF'
echo "🔧  Claude MCP 서버 설치 (최신 버전)…"

# 순차적 사고 — Claude의 사고 연쇄 엔진
claude mcp add sequential-thinking -s user \
  -- npx -y @modelcontextprotocol/server-sequential-thinking || true

# 파일 시스템 — Claude에게 로컬 폴더에 대한 액세스 권한 부여
# claude mcp add filesystem -s user \
#   -- npx -y @modelcontextprotocol/server-filesystem \
#      ~/Documents ~/Desktop ~/Downloads ~/Projects || true

# Playwright — 최신 멀티 브라우저 자동화
claude mcp add playwright -s user \
  -- npx -y @playwright/mcp-server || true

# Fetch — 간단한 HTTP GET/POST
claude mcp add fetch -s user \
  -- npx -y @kazuph/mcp-fetch || true

# 브라우저 도구 — DevTools 로그, 스크린샷 등
claude mcp add browser-tools -s user \
  -- npx -y @agentdeskai/browser-tools-mcp || true

echo "--------------------------------------------------"
echo "✅  MCP 등록 완료."
echo ""
echo "🔴  브라우저 도구를 활성화하려면 *두 번째* 터미널에서 다음을 실행하고 열어두세요:"
echo "    npx -y @agentdeskai/browser-tools-server"
echo "--------------------------------------------------"
claude mcp list
EOF
