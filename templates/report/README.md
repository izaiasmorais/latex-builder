# Template: report

Relatório técnico em PT-BR no formato institucional brasileiro, com cabeçalho da instituição e tabela de metadados de Termo de Contrato na página 1.

## Quando usar

- Relatório técnico parcial ou final para órgão público.
- Documento de ~5 a 20 páginas, com seções numeradas (1. INTRODUÇÃO, 2. CONTEXTUALIZAÇÃO, ...).
- Necessidade de bibliografia ABNT.

Para artigos científicos, use `paper-sbc` ou `article`. Para livro/tese, use `book`.

## Características

- Classe `article` (apesar do nome do preset), fonte Times Roman (`mathptmx`), margens ABNT (sup/esq 3 cm, inf/dir 2 cm), espaçamento 1,5.
- Cabeçalho institucional + tabela de metadados em `sections/00-cabecalho-metadados.tex`.
- 11 seções de exemplo (`sections/01-introducao.tex` ... `sections/11-consideracoes.tex`) com conteúdo placeholder neutro. Substitua pelos seus textos.
- Bibliografia ABNT via `abntex2cite` (estilo `alf` = autor-data).
- `Makefile` com targets: `build`, `watch`, `check`, `spell`, `clean`.

## Como usar

```bash
./new-doc.sh report           # copia para a raiz
make build                    # gera main.pdf
make watch                    # recompila a cada save
```

Edite `main.tex` para incluir/remover seções. Os textos vão em `sections/`.

## Dependências

- TeX Live com `latexmk`, pacote `abntex2cite` (em `texlive-publishers` no Debian/Ubuntu, ou `texlive-full`).
- Para `make spell`: `aspell` + `aspell-pt-br`.

## Trocando o estilo de citação

Padrão é ABNT autor-data (`[alf]`). Para ABNT numérico, edite `main.tex`:

```latex
\usepackage[num]{abntex2cite}
% ...
\bibliographystyle{abnt-num}
```

Se `abntex2cite` não estiver disponível, troque por `\bibliographystyle{plain}` e remova o `\usepackage{abntex2cite}`, que funciona em qualquer instalação TeX Live.
