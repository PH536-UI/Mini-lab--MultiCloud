# Mini Lab MultiCloud

Laboratório multicloud local para testar infraestrutura, automação e armazenamento em AWS, Azure, GCP e OCI, sem conta cloud, cobrança ou credenciais reais.

## Objetivo

Validar fluxos multicloud, recursos de storage, automação e integração entre ferramentas em um ambiente local, isolado e reproduzível. Este lab é voltado a estudo, desenvolvimento e experimentação.

## Ambiente

- Windows com WSL2 e Ubuntu
- Docker Desktop integrado ao WSL
- tmux para organizar os terminais e monitorar o lab
- Floci CLI para os emuladores locais

## Nuvens emuladas

| Cloud | Endpoint local | Comando de início |
|---|---|---|
| AWS | `http://localhost:4566` | `floci start` |
| Azure | `http://localhost:4577` | `floci az start` |
| GCP | `http://localhost:4588` | `floci gcp start` |
| OCI | `http://localhost:4599` | `floci oci start` |

## Pré-requisitos

- WSL2 com Ubuntu
- Docker Desktop em execução e integrado à distribuição Ubuntu
- Floci CLI instalado

Valide o Docker antes de iniciar:

```bash
docker version
docker run --rm hello-world
```

## Iniciar o lab

```bash
floci start
floci az start
floci gcp start
floci oci start
```

## Validar os ambientes

```bash
floci doctor
floci az doctor
floci gcp doctor
floci oci doctor
```

Para acompanhar CPU e memória dos contêineres:

```bash
docker stats
```

## Organização no tmux

Uma sugestão de cinco painéis:

1. AWS Floci
2. Azure Floci
3. GCP Floci
4. OCI Floci
5. Monitoramento com `docker stats`

Atalhos básicos:

- `Ctrl+B`, depois `%`: dividir na vertical
- `Ctrl+B`, depois `"`: dividir na horizontal
- `Ctrl+B`, depois setas: trocar de painel
- `Ctrl+B`, depois `d`: desconectar sem encerrar a sessão

## Parar o lab

```bash
floci stop
floci az stop
floci gcp stop
floci oci stop
```

## Próximos testes

- Criar e listar buckets locais em AWS S3, GCP Storage e OCI Object Storage
- Testar persistência de dados entre reinicializações
- Validar scripts de provisionamento e automação sem custos em nuvem
- Documentar diferenças de endpoint, serviços suportados e limitações de cada emulador

## Observações

Este laboratório não substitui serviços cloud reais. IAM, rede gerenciada, observabilidade, limites de serviço e comportamento de produção devem ser validados posteriormente em ambientes oficiais e controlados.
