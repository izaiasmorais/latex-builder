.PHONY: help build pdf watch clean

help:
	@echo "Targets (executar dentro de document/):"
	@echo "  make build   — compila main.pdf in-place (latexmk)"
	@echo "  make pdf     — alias de build"
	@echo "  make watch   — recompila a cada save (latexmk -pvc)"
	@echo "  make clean   — remove arquivos auxiliares (preserva main.pdf)"
	@echo ""
	@echo "Para usar a infraestrutura completa do repositório (check/spell/etc.),"
	@echo "rode 'make build|watch|check|spell' a partir da raiz do projeto."

build pdf:
	latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex

watch:
	latexmk -pdf -pvc -interaction=nonstopmode -halt-on-error main.tex

clean:
	latexmk -c
	rm -f *.bbl
