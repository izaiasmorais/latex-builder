# LaTeX — criador de documentos

Repositório base pra escrever qualquer documento LaTeX (artigo, relatório, livro/tese, slides, carta, paper acadêmico). Cada tipo é um preset em `templates/`. Você escolhe um, edita, compila localmente.

## Quickstart

```bash
./new-doc.sh                # lista templates disponíveis
./new-doc.sh article        # copia o preset para a raiz (cria main.tex etc.)
./watch.sh                  # recompila a cada save (latexmk -pvc)
./compile.sh                # build único, gera main.pdf
```

Visualize `main.pdf` no leitor de PDF de sua preferência (zathura, evince, Adobe, etc.) — ele recarrega sozinho quando o `watch.sh` recompila.

> **Sempre que fizer qualquer alteração em arquivo `.tex` (ou `.bib`), recompile o PDF rodando `./compile.sh` ao final.** Não deixe o documento dessincronizado do código fonte.

## Templates

| Nome        | Quando usar                                                                       |
| ----------- | --------------------------------------------------------------------------------- |
| `article`   | documento curto a médio em PT-BR                                                  |
| `report`    | relatório longo com capítulos                                                     |
| `book`      | livro ou tese com frontmatter/mainmatter/backmatter                               |
| `slides`    | apresentação (beamer)                                                             |
| `letter`    | carta formal                                                                      |
| `paper-sbc` | artigo no formato SBC — tem regras próprias (ver `templates/paper-sbc/README.md`) |

## Tabelas, figuras, código

Snippets prontos em `examples/`:

- `tabela-booktabs.tex` — tabela padrão
- `tabela-longtable.tex` — tabela que quebra entre páginas
- `figura-simples.tex` — figura única
- `figura-lado-a-lado.tex` — duas figuras com subcaption
- `figura-wrap-texto.tex` — figura com texto fluindo ao redor
- `codigo-listings.tex` — bloco de código com syntax highlight
- `equacao.tex` — equações numeradas

Copie o conteúdo do snippet pra dentro de uma seção, ajuste pacotes no preâmbulo se necessário, adapte. Imagens vão em `figures/` (já cadastrado em `\graphicspath`).

## Scripts genéricos (em `scripts/`)

```bash
./scripts/check.sh citations   # citações TODO-*, quebradas, órfãs (precisa refs.bib)
./scripts/check.sh figures     # labels não referenciados, refs sem label
./scripts/check.sh words       # contagem de palavras por arquivo
./scripts/check.sh all         # tudo acima

./scripts/spell-check.sh       # aspell PT-BR (requer aspell-pt-br)
./scripts/resolve-ref.sh ...   # CrossRef/arXiv → entry BibTeX
```

## Regras editoriais gerais

Servem pra qualquer prosa, não só acadêmica:

- Sem em-dash (—) para parêntese — use parênteses, vírgulas, ponto, ponto-e-vírgula
- Sem setas (→ ←) no texto corrido — use palavras
- Sem `(i) (ii) (iii)` em série — varie conectivos
- Sem "Esta seção apresenta..." — começar direto
- Sem adjetivos avaliativos vazios ("particularmente útil", "deliberadamente diversa")
- Sem paralelismos perfeitos em listas de 4+ itens — varie estrutura

## Preset paper-sbc

Se for paper acadêmico SBC, leia `templates/paper-sbc/README.md`. Tem regras específicas (Conceito + Ref + Instância, página budget 6–12, skills `/paper-write`, `/paper-review`, `/paper-coherence`, `/paper-status`, e o agente `academic-reviewer`). Ao ativar com `./new-doc.sh paper-sbc`, ele também instala o próprio CI, que aplica enforcement de páginas.

## Build remoto (opcional)

O repositório não traz workflow de CI por padrão. O preset `paper-sbc` instala seu próprio `.github/workflows/ci.yml` ao ser ativado pelo `new-doc.sh`: ele compila `main.tex` a cada push, anexa o PDF como artifact e falha se o documento passar de 12 páginas. Para os demais presets, crie um workflow em `.github/workflows/` se quiser CI.

## NÃO FAZER

- Não rodar `git push --force` ou `rm -rf` sem confirmação
- Não editar arquivos dentro de `templates/` quando estiver escrevendo o documento da raiz — `templates/` é fonte de verdade dos presets
