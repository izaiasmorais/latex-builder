## examples/

Snippets prontos pra copiar e colar. Cada arquivo é um trecho LaTeX autocontido com comentário no topo explicando o que faz e quais pacotes requer.

| Arquivo | O que faz | Pacotes necessários |
|---|---|---|
| `tabela-booktabs.tex` | Tabela padrão com 3 réguas horizontais | `booktabs` |
| `tabela-longtable.tex` | Tabela que quebra entre páginas | `longtable`, `booktabs` |
| `figura-simples.tex` | Figura única centralizada | `graphicx` |
| `figura-lado-a-lado.tex` | Duas figuras lado a lado com sub-labels | `graphicx`, `subcaption` |
| `figura-wrap-texto.tex` | Figura com texto fluindo ao redor | `wrapfig` |
| `codigo-listings.tex` | Bloco de código com syntax highlight | `listings`, `xcolor` |
| `equacao.tex` | Equações numeradas e alinhadas | `amsmath`, `amssymb` |

## Como usar

1. Abra o snippet, copie o trecho relevante.
2. Cole dentro de uma seção do seu documento (em `sections/`, `chapters/` ou direto no `main.tex`).
3. Verifique se os pacotes necessários estão no preâmbulo (`\usepackage{...}` no `main.tex`).
4. Adapte: troque o caption, o label, o conteúdo da tabela/figura.
5. Coloque imagens em `figures/` (referenciadas sem extensão graças ao `\graphicspath`).

## Convenções de labels

- `tab:nome` para tabelas
- `fig:nome` para figuras
- `lst:nome` para listings
- `eq:nome` para equações

Referencie sempre com `~\ref{...}` (o til evita quebra de linha entre "Figura" e o número).
