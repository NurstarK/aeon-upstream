#!/usr/bin/env bash
set -u
if [ -z "${XAI_API_KEY:-}" ]; then
  echo "XAI_UNSET"
  exit 3
fi
echo "XAI_SET"
FROM_DATE=$(date -u -d "1 day ago" +%Y-%m-%d 2>/dev/null || date -u -v-1d +%Y-%m-%d)
TO_DATE=$(date -u +%Y-%m-%d)
curl -s --max-time 90 -X POST "https://api.x.ai/v1/responses" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${XAI_API_KEY}" \
  -d '{
    "model": "grok-4-1-fast",
    "input": [{"role": "user", "content": "Search X from '"$FROM_DATE"' to '"$TO_DATE"' for tweets in the AI-agents conversation: autonomous agents, agent frameworks, MCP / agent protocols, agent products, agent benchmarks, agent research papers. Return up to 40 candidates. For EACH candidate you MUST return: @handle, follower_count (integer or null), role_guess (builder|founder|researcher|investor|commentator|anon), one-line claim, likes (int), retweets (int), replies (int), posted_at (ISO), direct_link (https://x.com/username/status/ID). Prefer builders/founders/researchers. Skip engagement-farming threads."}],
    "tools": [{"type": "x_search", "from_date": "'"$FROM_DATE"'", "to_date": "'"$TO_DATE"'"}]
  }'
echo ""
echo "---CURL_EXIT=$?---"
