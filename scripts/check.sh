#!/usr/bin/env bash
# Verifica saúde do documento: citações, figuras/tabelas, palavras.
# Uso: ./scripts/check.sh <comando>
#   citations  — lista \cite{TODO-*} pendentes, órfãs no .bib, e quebradas
#   figures    — figuras/tabelas com label sem ref, ou refs sem label
#   words      — palavras por arquivo .tex (estimativa)
#   all        — todos os checks
#
# Para enforcement de páginas (preset paper-sbc), use scripts/check-pages.sh.

set -uo pipefail
# Intentionally not using `set -e`: grep exits non-zero quando não há matches.

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

# Se existir document/main.tex (layout export-ready), opera lá dentro.
# Senão, opera na raiz (layout simples).
if [[ -f document/main.tex ]]; then
  cd document
fi

CMD="${1:-all}"

# Acha diretórios de conteúdo (sections/, chapters/, ou só main.tex).
# Exclui templates/ pra não poluir o resultado com os presets.
content_files() {
  local files=()
  [[ -d sections ]] && files+=(sections)
  [[ -d chapters ]] && files+=(chapters)
  [[ -f main.tex ]] && files+=(main.tex)
  printf '%s\n' "${files[@]}"
}

check_citations() {
  echo "── Citações ──"
  echo

  if [[ ! -f refs.bib ]]; then
    echo "ℹ️  refs.bib não existe — pulando (documento sem bibliografia)"
    return
  fi

  local targets
  targets=($(content_files))
  [[ ${#targets[@]} -eq 0 ]] && { echo "ℹ️  sem arquivos .tex pra inspecionar"; return; }

  local todo
  todo=$({ grep -roh '\\cite{TODO-[a-zA-Z0-9-]*}' "${targets[@]}" 2>/dev/null || true; } | sort -u | grep -c . || true)
  echo "TODO-* pendentes: $todo"
  if [[ $todo -gt 0 ]]; then
    grep -roh '\\cite{TODO-[a-zA-Z0-9-]*}' "${targets[@]}" 2>/dev/null | sort -u | head -10 | sed 's/^/  /'
    [[ $todo -gt 10 ]] && echo "  ... (+$((todo-10)) outras)"
  fi
  echo

  local cited
  cited=$(grep -roh '\\cite{[a-zA-Z0-9_-]*}' "${targets[@]}" 2>/dev/null | sed 's/\\cite{//;s/}//' | sort -u)
  local defined
  defined=$(grep -E '^@[a-zA-Z]+\{[a-zA-Z0-9_-]+,' refs.bib 2>/dev/null | sed 's/^@[a-zA-Z]\+{//;s/,$//' | sort -u)

  local broken
  broken=$(comm -23 <(echo "$cited") <(echo "$defined") 2>/dev/null || true)
  local orphan
  orphan=$(comm -13 <(echo "$cited") <(echo "$defined") 2>/dev/null || true)

  if [[ -n "$broken" ]]; then
    echo "Citações quebradas (cite sem entry no .bib):"
    echo "$broken" | sed 's/^/  ❌ /'
  else
    echo "✅ Sem citações quebradas"
  fi
  echo

  if [[ -n "$orphan" ]]; then
    echo "Entries órfãs no .bib (não citadas):"
    echo "$orphan" | sed 's/^/  ⚠️  /'
  else
    echo "✅ Sem entries órfãs no refs.bib"
  fi
}

check_figures() {
  echo "── Figuras e tabelas ──"
  echo

  local targets
  targets=($(content_files))
  [[ ${#targets[@]} -eq 0 ]] && { echo "ℹ️  sem arquivos .tex pra inspecionar"; return; }

  local labels
  labels=$(grep -roh '\\label{\(fig\|tab\):[a-zA-Z0-9_-]*}' "${targets[@]}" 2>/dev/null | sort -u | sed 's/\\label{//;s/}//')
  local refs
  refs=$(grep -roh '\\ref{\(fig\|tab\):[a-zA-Z0-9_-]*}' "${targets[@]}" 2>/dev/null | sort -u | sed 's/\\ref{//;s/}//')

  local unreffed
  unreffed=$(comm -23 <(echo "$labels") <(echo "$refs") 2>/dev/null || true)
  local missing
  missing=$(comm -13 <(echo "$labels") <(echo "$refs") 2>/dev/null || true)

  if [[ -n "$unreffed" ]]; then
    echo "Labels não referenciados no texto (fig/tab definidos mas não citados):"
    echo "$unreffed" | sed 's/^/  ⚠️  /'
  else
    echo "✅ Todos os labels são referenciados"
  fi
  echo

  if [[ -n "$missing" ]]; then
    echo "Refs sem label correspondente:"
    echo "$missing" | sed 's/^/  ❌ /'
  else
    echo "✅ Todas as refs têm label"
  fi
  echo

  if [[ -d figures ]]; then
    local figs
    figs=$(find figures/ -maxdepth 1 -type f \( -name '*.pdf' -o -name '*.png' -o -name '*.jpg' \) 2>/dev/null | wc -l)
    echo "Arquivos em figures/: $figs"
  fi
}

check_words() {
  echo "── Palavras por arquivo (estimativa) ──"
  echo

  local files=()
  [[ -d sections ]] && files+=(sections/*.tex)
  [[ -d chapters ]] && files+=(chapters/*.tex)
  [[ -f main.tex ]] && files+=(main.tex)

  for f in "${files[@]}"; do
    [[ -f "$f" ]] || continue
    local name="$f"
    local words
    words=$(grep -v '^\s*%' "$f" | sed 's/\\[a-zA-Z]\+\(\[[^]]*\]\)\?\({[^}]*}\)\?//g' | wc -w)
    printf "  %-40s %5d palavras\n" "$name" "$words"
  done
}

case "$CMD" in
  citations) check_citations ;;
  figures)   check_figures ;;
  words)     check_words ;;
  all)
    check_citations
    echo
    check_figures
    echo
    check_words
    ;;
  *)
    echo "Uso: $0 <citations|figures|words|all>" >&2
    echo "Para contagem de páginas com limite SBC, use templates/paper-sbc/scripts/check-pages.sh" >&2
    exit 1
    ;;
esac
