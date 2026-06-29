.PHONY: help build pdf watch check spell clean

help:
	@echo "Targets disponíveis:"
	@echo "  make build   — compila main.pdf (one-shot, via latexmk)"
	@echo "  make pdf     — alias de build"
	@echo "  make watch   — recompila a cada save (latexmk -pvc)"
	@echo "  make check   — verifica citações, figuras e contagem de palavras"
	@echo "  make spell   — verifica ortografia PT-BR (aspell)"
	@echo "  make clean   — remove arquivos auxiliares (preserva main.pdf)"

build pdf:
	./compile.sh

watch:
	./watch.sh

check:
	./scripts/check.sh all

spell:
	./scripts/spell-check.sh

clean:
	rm -f *.aux *.log *.bbl *.blg *.toc *.lof *.lot *.out *.fdb_latexmk *.fls *.synctex.gz *.nav *.snm *.vrb *.dvi
