# Preset: paper-sbc

Template para artigos no formato da Sociedade Brasileira de Computação (SBC) e venues similares. Inclui classe SBC vendored, abstract + resumo bilíngue, estrutura de 6 seções, bibliografia BibTeX e enforcement de página (6-12).

## Ativar

```bash
./new-doc.sh paper-sbc
```

Esse comando copia para a raiz do repositório:

- `main.tex` — preâmbulo SBC + abstract + resumo + 6 `\input{sections/0N-*}`
- `sbc-template.sty`, `caption2.sty`, `sbc.bst` — classe e bibliography style
- `refs.bib` — esqueleto da bibliografia
- `sections/01-introducao.tex` ... `06-conclusao.tex`
- `scripts/check-pages.sh` — conta páginas e alerta contra o limite
- `scripts/audit-refs.sh` — auditoria da qualidade da bibliografia
- `.github/workflows/ci.yml` — CI com enforcement 6-12 (substitui o CI genérico)

## Estrutura de seções

| # | Seção | Páginas alvo |
|---|---|---|
| 1 | Introdução (problema, justificativa, motivação, objetivos, contribuições) | 0,5–1 |
| 2 | Referencial Teórico (enxuto — só conceitos transversais) | 0,5–1 |
| 3 | Trabalhos Relacionados | 0,5–1 |
| 4 | **Abordagem** — miolo do paper | 3–5 |
| 5 | Experimentos (metodologia + resultados) | 1–2 |
| 6 | Conclusão (síntese + limitações + trabalhos futuros) | 0,3–0,5 |
| — | Referências | 0,5–1 |

## Regras editoriais

### 1. Conceito + Referência + Instância

No corpo, sempre:

> *"Cross-encoder* [Nogueira & Cho, 2019], instanciado com ColBERTv2 [Santhanam et al., 2022]"

**Conceito acadêmico** (durável) é protagonista. **Modelos específicos** só viram protagonistas em Sec. Experimentos.

### 2. Citações como `\cite{TODO-xxx}` durante drafts

Não interrompa fluxo de escrita pra caçar referência. Resolva no polimento.

### 3. Texto enxuto + figuras + tabelas

1 figura/tabela vale 200 palavras em paper denso.

### 4. Português consistente

Conteúdo em PT-BR com acentuação correta. Termos técnicos consagrados em inglês ficam em itálico (*pipeline*, *embedding*, *chunk*).

### 5. Convenções tipográficas

- Texto normal: nomes de tecnologias (Qdrant, FastAPI, Neo4j)
- Itálico (`\textit{}`): termos estrangeiros e padrões de projeto (*Strategy*, *Factory*)
- Aspas duplas (`"foo"`): identificadores de campo/atributo
- `\texttt{}`: snippets de código executável

### 6. Evitar marcadores de IA

- Sem em-dash (—) para parêntese
- Sem setas (→ ←) no texto corrido — use palavras
- Sem `(i) (ii) (iii)` — varie conectivos
- Sem "Esta seção apresenta..." — começar direto
- Sem adjetivos avaliativos ("particularmente útil")
- Sem paralelismos perfeitos em listas de 4+ itens

## Skills e agente

Disponíveis em qualquer sessão Claude Code neste repo (mas faz sentido invocar só quando o preset paper-sbc está ativo):

- `/paper-write` — escrever ou editar uma seção
- `/paper-review` — revisar contra critérios acadêmicos
- `/paper-coherence` — coerência entre Introdução e Conclusão
- `/paper-status` — estado atual (páginas, citações, build)
- Agente `academic-reviewer` — revisão simulada de banca/par

## Tooling

```bash
./scripts/check-pages.sh                  # alvo 6-12 (somente preset SBC)
./scripts/audit-refs.sh                   # qualidade da bibliografia
./scripts/resolve-ref.sh search "query"   # busca CrossRef
./scripts/resolve-ref.sh fetch <DOI>      # baixa BibTeX
./scripts/resolve-ref.sh arxiv <id>       # gera entry de ID arXiv
```

## NÃO FAZER

- Não amarrar arquitetura/método a modelos específicos no corpo geral
- Não inflar Referencial Teórico repetindo o que vai na Abordagem
