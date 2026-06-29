#!/usr/bin/env bash
# Conta páginas do PDF compilado e alerta contra o limite SBC (6-12).
# Uso: ./templates/paper-sbc/scripts/check-pages.sh [caminho/para/main.pdf]
#
# Quando o preset paper-sbc está ativo, este arquivo costuma viver em
# scripts/check-pages.sh na raiz (foi copiado pelo new-doc.sh).

set -uo pipefail

PDF="${1:-main.pdf}"

if [[ ! -f "$PDF" ]]; then
  echo "⚠️  $PDF não existe — rode ./compile.sh primeiro" >&2
  exit 1
fi

if ! command -v pdfinfo >/dev/null; then
  echo "❌ pdfinfo não disponível (instale poppler-utils)" >&2
  exit 1
fi

PAGES=$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/ {print $2}')
if [[ -z "$PAGES" ]]; then
  echo "❌ pdfinfo não conseguiu ler $PDF" >&2
  exit 1
fi

echo "── Páginas (preset SBC: alvo 6-12) ──"
echo
echo "Total: $PAGES páginas"

if (( PAGES < 6 )); then
  echo "🟡 Abaixo do mínimo — expandir Abordagem ou Experimentos"
  exit 0
elif (( PAGES > 12 )); then
  echo "🔴 Acima do limite — cortar (Referencial Teórico costuma ser o primeiro alvo)"
  exit 1
else
  echo "🟢 Dentro do limite"
  exit 0
fi
