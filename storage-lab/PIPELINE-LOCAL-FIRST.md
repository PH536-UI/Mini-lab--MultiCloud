# Esteira local-first de validação

## Objetivo

Executar uma validação repetível de Terraform para storage em AWS, Azure, GCP e OCI, usando exclusivamente os emuladores Docker locais do laboratório. A esteira não executa `terraform apply`, não utiliza credenciais reais e não é um pipeline de produção.

## Fluxo

```text
verify-local-only → preflight → init → validate → plan
                                      ↓
                            evidence (ignorada pelo Git)
                                      ↓
                    evidence-sanitized → RELATORIO-VALIDACAO.md
```

## Execução

Com os quatro emuladores saudáveis:

```bash
cd storage-lab
bash scripts/run-local-validation.sh
```

O resultado contém:

- `evidence/`: saída técnica local bruta, ignorada pelo Git.
- `evidence-sanitized/`: cópia revisável, com mascaramento de chaves e segredos comuns, também ignorada pelo Git.
- `evidence-sanitized/RELATORIO-VALIDACAO.md`: total por cloud de recursos planejados, alterações e destruições.

## Barreiras de segurança

`verify-local-only.sh` falha antes do Terraform se detectar:

1. Variáveis comuns de credenciais reais de AWS, Azure, GCP ou OCI no ambiente.
2. Endpoints esperados fora de `localhost` nos arquivos do laboratório.
3. Comandos Terraform mutáveis, como `apply`, `destroy`, `import` ou `state`, nos scripts da esteira.

A barreira cobre a execução guiada pelos scripts. Ela não impede alguém de rodar manualmente `terraform apply`; essa ação permanece deliberada, fora do fluxo de demonstração e não faz parte do aceite.

## Por que não há GitHub Actions

Os provedores apontam para `localhost`, isto é, para Docker e os emuladores no computador que executa o laboratório. Um runner hospedado do GitHub não alcança esses endpoints. Publicar um workflow com planos que falhariam ou exigiriam credenciais reais seria enganoso.

Se houver necessidade de automação remota no futuro, use um runner self-hosted isolado, execute os mesmos controles locais e mantenha `apply` bloqueado por política e revisão humana.

## Critérios de aceite

- Os quatro containers `floci-*` estão saudáveis.
- A validação finaliza sem chamadas a contas cloud reais.
- Há quatro resumos `Plan:` válidos, um por cloud.
- O relatório sanitizado registra apenas recursos planejados.
- O total esperado no laboratório atual é 6 recursos para adicionar, 0 para alterar e 0 para destruir.
