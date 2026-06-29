#!/usr/bin/env bash
# Verifica ortografia dos arquivos .tex em PT-BR usando aspell.
# Uso:
#   ./scripts/spell-check.sh             -> verifica todos os .tex em sections/, chapters/ e main.tex
#   ./scripts/spell-check.sh <arquivo>   -> verifica um arquivo específico (ex: sections/01-intro.tex)

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

if ! command -v aspell >/dev/null; then
  echo "❌ aspell não encontrado. Instale: sudo apt install aspell aspell-pt-br" >&2
  exit 1
fi

if ! aspell dicts | grep -q '^pt_BR$'; then
  echo "❌ Dicionário pt_BR não instalado. Instale: sudo apt install aspell-pt-br" >&2
  exit 1
fi

PERSONAL_WORDS=$(mktemp)
trap 'rm -f "$PERSONAL_WORDS"' EXIT

cat > "$PERSONAL_WORDS" <<'EOF'
personal_ws-1.1 pt 0
EOF
if [[ -f styles/config/vocabularies/Tech/accept.txt ]]; then
  grep -v '^$' styles/config/vocabularies/Tech/accept.txt >> "$PERSONAL_WORDS"
fi

check_file() {
  local file="$1"
  echo "── $file ──"

  local misspelled
  misspelled=$(sed 's/%.*$//' "$file" \
    | sed 's/\\[a-zA-Z]\+\(\[[^]]*\]\)*\({[^}]*}\)*//g' \
    | sed 's/\$[^$]*\$//g' \
    | aspell --lang=pt_BR --personal="$PERSONAL_WORDS" --encoding=utf-8 list \
    | sort -u)

  if [[ -z "$misspelled" ]]; then
    echo "  ✅ sem problemas detectados"
  else
    echo "$misspelled" | sed 's/^/  ❓ /'
  fi
  echo
}

if [[ $# -eq 1 ]]; then
  [[ ! -f "$1" ]] && { echo "❌ arquivo não encontrado: $1" >&2; exit 1; }
  check_file "$1"
else
  found=0
  for dir in sections chapters; do
    if [[ -d "$dir" ]]; then
      for f in "$dir"/*.tex; do
        [[ -f "$f" ]] || continue
        check_file "$f"
        found=1
      done
    fi
  done
  if [[ -f main.tex ]]; then
    check_file main.tex
    found=1
  fi
  [[ $found -eq 0 ]] && echo "ℹ️  nenhum arquivo .tex encontrado pra verificar"
fi

echo "💡 Palavras desconhecidas mas corretas: adicionar em styles/config/vocabularies/Tech/accept.txt"
