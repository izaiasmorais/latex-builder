#!/usr/bin/env bash
# Recompila o documento automaticamente a cada save (latexmk -pvc).
# Se existe document/main.tex, observa esse diretório e copia o PDF pra raiz a
# cada compilação (via document/.latexmkrc). Caso contrário, observa main.tex
# na raiz.
#
# Abra main.pdf no seu leitor preferido — ele recarrega quando o arquivo muda.
# Ctrl+C encerra.

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"

if [[ -f document/main.tex ]]; then
  SRC_DIR="document"
elif [[ -f main.tex ]]; then
  SRC_DIR="."
else
  echo "❌ nem document/main.tex nem main.tex existem. Rode ./new-doc.sh <template> primeiro." >&2
  exit 1
fi

if ! command -v latexmk >/dev/null; then
  echo "❌ latexmk não encontrado. Instale TeX Live (texlive-full)." >&2
  exit 1
fi

echo "👀 watch ativo — main.pdf na raiz recompila a cada salvamento em $SRC_DIR/."
echo "   Abra main.pdf no seu leitor de PDF (zathura, evince, etc.) e edite à vontade."
echo "   Ctrl+C para encerrar."
echo

cd "$SRC_DIR"
exec latexmk -pdf -pvc -interaction=nonstopmode -halt-on-error main.tex
