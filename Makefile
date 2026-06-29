.PHONY: help build pdf watch check spell clean

help:
	@echo "Targets disponíveis (raiz do projeto):"
	@echo "  make build   — compila document/main.tex e publica main.pdf na raiz"
	@echo "  make pdf     — alias de build"
	@echo "  make watch   — recompila a cada save (PDF na raiz atualizado automaticamente)"
	@echo "  make check   — verifica citações, figuras e contagem de palavras"
	@echo "  make spell   — verifica ortografia PT-BR (aspell)"
	@echo "  make clean   — remove auxiliares (document/*.aux etc.) e PDF da raiz"

build pdf:
	./compile.sh

watch:
	./watch.sh

check:
	./scripts/check.sh all

spell:
	./scripts/spell-check.sh

clean:
	@if [ -d document ]; then \
	  cd document && latexmk -c && rm -f *.bbl; \
	fi
	rm -f main.pdf *.aux *.log *.bbl *.blg *.toc *.out *.fdb_latexmk *.fls *.synctex.gz
