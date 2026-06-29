# LaTeX — criador de documentos

Repositório base agnóstico pra escrever qualquer documento LaTeX. Você escolhe um preset (artigo, relatório, livro/tese, slides, carta, paper SBC), o repositório se monta na raiz e você compila localmente com PDF preview.

## Começar

```bash
./new-doc.sh                # vê opções disponíveis
./new-doc.sh article        # ativa o preset article
./watch.sh                  # recompila a cada save (deixe rodando enquanto edita)
./compile.sh                # build único quando quiser
```

`main.pdf` é gerado na raiz. Abra no leitor de PDF da sua preferência — ele recarrega automaticamente.

## Pré-requisitos

- TeX Live com `latexmk`, `pdflatex` e `bibtex` (no Ubuntu/Debian: `sudo apt install texlive-full`)
- `poppler-utils` opcional, pra contagem de páginas (`sudo apt install poppler-utils`)

## Templates disponíveis

| Nome        | O que é                                                       |
| ----------- | ------------------------------------------------------------- |
| `article`   | documento curto a médio (article class), seções em PT-BR      |
| `report`    | relatório longo com capítulos (report class)                  |
| `book`      | livro/tese com frontmatter/mainmatter/backmatter (book class) |
| `slides`    | apresentação em beamer                                        |
| `letter`    | carta formal (letter class)                                   |
| `paper-sbc` | artigo SBC com classe vendored, abstract+resumo, CI 6–12 págs |

Cada preset vive em `templates/<nome>/`. O `new-doc.sh` copia o conteúdo pra raiz.

## Snippets

Pasta `examples/` tem trechos prontos:

| Arquivo                  | Pra que serve                     |
| ------------------------ | --------------------------------- |
| `tabela-booktabs.tex`    | tabela padrão com 3 réguas        |
| `tabela-longtable.tex`   | tabela que quebra entre páginas   |
| `figura-simples.tex`     | figura única centralizada         |
| `figura-lado-a-lado.tex` | duas figuras com subcaption       |
| `figura-wrap-texto.tex`  | figura com texto fluindo ao redor |
| `codigo-listings.tex`    | bloco de código com highlight     |
| `equacao.tex`            | equações numeradas e alinhadas    |

Copie e adapte. Imagens em `figures/` (referenciadas sem extensão).

## Tooling

```bash
./compile.sh                       # latexmk -pdf main.tex
./compile.sh --quiet               # versão silenciosa, só status final
./watch.sh                         # recompila a cada save (Ctrl+C pra encerrar)

./scripts/check.sh citations       # TODO-* pendentes, citações quebradas, órfãs
./scripts/check.sh figures         # labels sem ref e refs sem label
./scripts/check.sh words           # contagem por arquivo
./scripts/check.sh all             # tudo acima

./scripts/spell-check.sh           # aspell PT-BR
./scripts/resolve-ref.sh search "termo"   # busca CrossRef
./scripts/resolve-ref.sh fetch <DOI>      # baixa BibTeX
./scripts/resolve-ref.sh arxiv <id>       # gera entry de arXiv
```

## CI/CD

O repositório não traz workflow de CI por padrão. Os presets que incluem um (hoje só o `paper-sbc`) instalam o próprio `.github/workflows/ci.yml` ao serem ativados pelo `new-doc.sh`: ele compila `main.tex` a cada push, anexa o PDF como artifact e, no caso do `paper-sbc`, falha se o documento passar de 12 páginas. Se quiser CI para os demais presets, crie um workflow em `.github/workflows/`.

## Estrutura

```
.
├── new-doc.sh             # escolhe preset
├── compile.sh             # build único
├── watch.sh               # build contínuo (recompila a cada save)
├── main.tex               # criado pelo new-doc.sh
├── figures/               # imagens
├── examples/              # snippets reutilizáveis
├── templates/             # presets
│   ├── article/
│   ├── report/
│   ├── book/
│   ├── slides/
│   ├── letter/
│   └── paper-sbc/         # template SBC completo (classe + scripts + CI próprios)
└── scripts/               # tooling agnóstico
```

> O preset `paper-sbc` instala seu próprio `.github/workflows/ci.yml` ao ser ativado pelo `new-doc.sh`.

## Licença

MIT (do template). O conteúdo que você escrever é seu.

A classe SBC (`templates/paper-sbc/sbc-template.sty`, `sbc.bst`, `caption2.sty`) segue suas próprias licenças (geralmente LPPL).
