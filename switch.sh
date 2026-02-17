#!/bin/bash
# ═══════════════════════════════════════════════
#   GitHub Pages Theme Switcher
#   by MKA.DEV
# ═══════════════════════════════════════════════

# ── CONFIG ──────────────────────────────────────
GITHUB_USER="moekyaw-aung-mm"
REPO="moekyaw-aung-mm.github.io"

# Token မရှိရင် prompt လုပ်မယ်
if [ -z "$GITHUB_TOKEN" ]; then
  echo ""
  read -s -p "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 " GITHUB_TOKEN
  echo ""
fi

# ── THEMES ──────────────────────────────────────
BRANCHES=("main" "theme/cyberpunk" "theme/luxury" "theme/synthwave" "theme/nature")
NAMES=("🌌  Cosmic (Original)" "💻  Cyberpunk Neon" "✨  Luxury Gold" "🎵  Retro Synthwave" "🌿  Nature Organic")

# ── COLORS ──────────────────────────────────────
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m' # No Color

clear

# ── HEADER ──────────────────────────────────────
echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}  ║${WHITE}     GitHub Pages — Theme Switcher        ${CYAN}║${NC}"
echo -e "${CYAN}  ║${DIM}     moekyaw-aung-mm.github.io             ${CYAN}║${NC}"
echo -e "${CYAN}  ╚══════════════════════════════════════════╝${NC}"
echo ""

# ── GET CURRENT ACTIVE BRANCH ───────────────────
echo -e "${DIM}  ⏳ Current theme စစ်ဆေးနေတယ်...${NC}"

CURRENT=$(curl -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/${GITHUB_USER}/${REPO}/pages" \
  | grep '"branch"' | head -1 | sed 's/.*"branch": *"\([^"]*\)".*/\1/')

echo ""

# ── SHOW THEME LIST ──────────────────────────────
echo -e "  ${WHITE}Available Themes:${NC}"
echo -e "  ${DIM}──────────────────────────────────────────${NC}"
echo ""

for i in "${!BRANCHES[@]}"; do
  NUM=$((i+1))
  if [ "${BRANCHES[$i]}" = "$CURRENT" ]; then
    echo -e "  ${GREEN}  $NUM.  ${NAMES[$i]}   ◄ ACTIVE${NC}"
  else
    echo -e "  ${DIM}  $NUM.  ${NC}${NAMES[$i]}"
  fi
done

echo ""
echo -e "  ${DIM}──────────────────────────────────────────${NC}"
echo ""

# ── USER INPUT ───────────────────────────────────
read -p "  Theme အမှတ် ရွေးပါ (1-5) သို့မဟုတ် q=ထွက်: " CHOICE
echo ""

# Quit
if [ "$CHOICE" = "q" ] || [ "$CHOICE" = "Q" ]; then
  echo -e "  ${DIM}Bye! 👋${NC}"
  echo ""
  exit 0
fi

# Validate input
if ! [[ "$CHOICE" =~ ^[1-5]$ ]]; then
  echo -e "  ${RED}❌  1-5 ကြားထဲက ရွေးပါ!${NC}"
  echo ""
  exit 1
fi

IDX=$((CHOICE-1))
SELECTED_BRANCH="${BRANCHES[$IDX]}"
SELECTED_NAME="${NAMES[$IDX]}"

# Already active check
if [ "$SELECTED_BRANCH" = "$CURRENT" ]; then
  echo -e "  ${YELLOW}⚠️  ${SELECTED_NAME} က Already active ဖြစ်နေပြီ!${NC}"
  echo ""
  exit 0
fi

# ── SWITCH ───────────────────────────────────────
echo -e "  ${CYAN}⏳ Switching to ${WHITE}${SELECTED_NAME}${CYAN}...${NC}"
echo ""

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
  -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/${GITHUB_USER}/${REPO}/pages" \
  -d "{\"source\":{\"branch\":\"${SELECTED_BRANCH}\",\"path\":\"/\"}}")

# ── RESULT ───────────────────────────────────────
if [ "$RESPONSE" = "204" ] || [ "$RESPONSE" = "200" ]; then
  echo -e "  ${GREEN}╔══════════════════════════════════════════╗${NC}"
  echo -e "  ${GREEN}║  ✅  Successfully switched!               ║${NC}"
  echo -e "  ${GREEN}║                                          ║${NC}"
  echo -e "  ${GREEN}║  Theme : ${WHITE}${SELECTED_NAME}${NC}"
  echo -e "  ${GREEN}║  Branch: ${WHITE}${SELECTED_BRANCH}${NC}"
  echo -e "  ${GREEN}║                                          ║${NC}"
  echo -e "  ${GREEN}║  🔗  moekyaw-aung-mm.github.io           ║${NC}"
  echo -e "  ${GREEN}║  ⏱️   2-3 မိနစ် စောင့်ပါ...               ║${NC}"
  echo -e "  ${GREEN}╚══════════════════════════════════════════╝${NC}"
else
  echo -e "  ${RED}╔══════════════════════════════════════════╗${NC}"
  echo -e "  ${RED}║  ❌  Error! (HTTP: ${RESPONSE})               ║${NC}"
  echo -e "  ${RED}║                                          ║${NC}"
  echo -e "  ${RED}║  စစ်ဆေးပါ:                               ║${NC}"
  echo -e "  ${RED}║  • GitHub Token မှန်/မမှန်               ║${NC}"
  echo -e "  ${RED}║  • Branch ရှိ/မရှိ                        ║${NC}"
  echo -e "  ${RED}║  • Internet connection                    ║${NC}"
  echo -e "  ${RED}╚══════════════════════════════════════════╝${NC}"
fi

echo ""
