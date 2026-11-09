# Evidências de desenvolvimento

Este laboratório não é uma apresentação estática. A evidência vem da cadeia reproduzível abaixo:

1. **Código versionado**: módulos Terraform separados por cloud, cada um com endpoint local explícito.
2. **Segurança verificável**: Azure com TLS 1.2 e container privado, GCP com acesso uniforme, OCI com `NoPublicAccess` e chave efêmera fora do Git.
3. **Saúde do ambiente**: quatro contêineres em estado `healthy` e endpoints monitorados.
4. **Execução sem risco**: `init`, `validate` e `plan`, sem `apply` e sem conta real.
5. **Artefatos de execução**: logs datados de saúde, preflight e plans, gerados localmente em `evidence/`.

## Gerar um pacote de evidências

Com os emuladores ativos, execute a partir de `storage-lab`:

```bash
bash scripts/collect-evidence.sh
```

O script grava arquivos datados em `evidence/` e não executa `terraform apply`.

## Como demonstrar em entrevista

Mostre, nesta ordem:

- o commit que adiciona os módulos e scripts;
- um `main.tf` de cada cloud, destacando endpoint e controle de segurança;
- o resultado do `preflight` e dos quatro `terraform plan`;
- o tmux com endpoints e `docker stats`;
- a pasta local `evidence/` com os logs datados.

A conclusão técnica é objetiva: o onboarding foi desenvolvido, versionado e executado de forma repetível em emuladores locais. Não alegue provisionamento em contas reais.
