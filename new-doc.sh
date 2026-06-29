#!/usr/bin/env bash
# Inicializa um documento novo a partir de um template.
# Uso:
#   ./new-doc.sh                 -> lista templates disponíveis
#   ./new-doc.sh article         -> copia templates/article/* para a raiz
#   ./new-doc.sh paper-sbc       -> copia templates/paper-sbc/* (incluindo .sty, .bst, sections, CI)
#   ./new-doc.sh <nome> --force  -> sobrescreve mesmo se main.tex já existir

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"

TEMPLATES_DIR="$PROJECT_ROOT/templates"

list_templates() {
  echo "Templates disponíveis:"
  for d in "$TEMPLATES_DIR"/*/; do
    name=$(basename "$d")
    desc=""
    case "$name" in
      article)   desc="documento genérico em PT-BR (article class)" ;;
      report)    desc="relatório longo com capítulos (report class)" ;;
      book)      desc="livro/tese com frontmatter/mainmatter/backmatter (book class)" ;;
      slides)    desc="apresentação (beamer)" ;;
      letter)    desc="carta formal (letter class)" ;;
      paper-sbc) desc="artigo SBC com abstract+resumo+6 seções e CI 6-12 págs" ;;
      *)         desc="" ;;
    esac
    printf "  %-12s %s\n" "$name" "$desc"
  done
  echo
  echo "Uso: ./new-doc.sh <nome> [--force]"
}

TEMPLATE="${1:-}"
FORCE=0
[[ "${2:-}" == "--force" ]] && FORCE=1

if [[ -z "$TEMPLATE" ]]; then
  list_templates
  exit 0
fi

SRC="$TEMPLATES_DIR/$TEMPLATE"
if [[ ! -d "$SRC" ]]; then
  echo "❌ template '$TEMPLATE' não existe em $TEMPLATES_DIR/" >&2
  echo
  list_templates >&2
  exit 1
fi

if [[ -f "$PROJECT_ROOT/main.tex" && $FORCE -eq 0 ]]; then
  echo "❌ já existe um main.tex na raiz. Use --force para sobrescrever." >&2
  exit 1
fi

echo "→ copiando templates/$TEMPLATE/ para a raiz..."
# rsync exclui README.md do preset (é doc interna) e tudo dentro de workflows/
# que será reposicionado em .github/workflows/.
if command -v rsync >/dev/null; then
  rsync -a --exclude='README.md' --exclude='workflows/' "$SRC/" "$PROJECT_ROOT/"
else
  # Fallback sem rsync: cp recursivo e depois limpa.
  cp -r "$SRC/." "$PROJECT_ROOT/"
  if [[ -f "$PROJECT_ROOT/README.md.tmp-preset" ]]; then :; fi
  # Restaura README só se o cp tiver sobrescrito (heurística: existe README.md no template)
  if [[ -f "$SRC/README.md" ]]; then
    echo "⚠️  rsync não disponível; README.md da raiz pode ter sido sobrescrito pelo do preset." >&2
    echo "    Restaure manualmente se necessário." >&2
  fi
fi

if [[ -d "$SRC/workflows" ]]; then
  mkdir -p "$PROJECT_ROOT/.github/workflows"
  for wf in "$SRC/workflows/"*.yml; do
    [[ -f "$wf" ]] || continue
    cp "$wf" "$PROJECT_ROOT/.github/workflows/$(basename "$wf")"
    echo "→ workflow $(basename "$wf") instalado em .github/workflows/"
  done
fi

# Garante scripts executáveis (no caso de presets que trazem scripts próprios).
if [[ -d "$PROJECT_ROOT/scripts" ]]; then
  chmod +x "$PROJECT_ROOT/scripts/"*.sh 2>/dev/null || true
fi

echo "✅ template '$TEMPLATE' pronto. Edite main.tex e rode ./compile.sh ou ./watch.sh."
