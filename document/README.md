# document/ — artigo SBC

Modelo genérico de artigo no formato da Sociedade Brasileira de Computação (SBC),
pronto pra editar e compilar localmente. É o documento ativo do repositório: os
scripts da raiz (`./compile.sh`, `./watch.sh`) detectam `document/main.tex` e
geram `main.pdf` na raiz automaticamente.

## Estrutura

```
document/
├── main.tex            # preâmbulo, título, autores, abstract/resumo, includes
├── refs.bib            # bibliografia (estilo sbc)
├── sections/           # uma seção por arquivo
│   ├── 01-introducao.tex
│   ├── 02-referencial-teorico.tex
│   ├── 03-trabalhos-relacionados.tex
│   ├── 04-abordagem.tex
│   ├── 05-experimentos.tex
│   └── 06-conclusao.tex
├── figures/            # imagens (referenciadas sem extensão)
├── sbc-template.sty    # classe SBC (vendored)
├── sbc.bst             # estilo de bibliografia SBC
└── caption2.sty        # dependência do template SBC
```

## Como usar

```bash
./compile.sh            # build único; gera main.pdf na raiz
./watch.sh              # recompila a cada save
```

Ou, de dentro de `document/`:

```bash
make build              # compila main.pdf in-place
make watch              # recompila a cada save
```

Edite `main.tex` pra ajustar título, autores e o `abstract`/`resumo`. O texto de
cada seção fica em `sections/`. Imagens vão em `figures/` e são referenciadas sem
a extensão (ex.: `\includegraphics{diagrama}`).

## Bibliografia

O estilo é o `sbc` (`sbc.bst`). Cite com `\cite{chave}` e cadastre as entradas em
`refs.bib`. As duas entradas de exemplo (`exemplo2024`, `exemplo2023conf`) servem
só pra o modelo compilar com a bibliografia resolvida; substitua-as pelas suas.

## Dependências

TeX Live com `latexmk`, `pdflatex` e `bibtex`. Os arquivos da classe SBC
(`sbc-template.sty`, `sbc.bst`, `caption2.sty`) já acompanham este diretório, então
não é necessário instalá-los à parte.
