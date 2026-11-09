# Mini Lab MultiCloud

Laboratório multicloud local para testar infraestrutura, automação e armazenamento em AWS, Azure, GCP e OCI, sem conta cloud, cobrança ou credenciais reais.

> Para recrutadores: veja o [resumo de portfólio do Professor PH](PORTFOLIO.md), com arquitetura, resultados verificáveis, controles e pitch técnico em inglês.

## Objetivo

Validar fluxos multicloud, recursos de storage, automação e integração entre ferramentas em um ambiente local, isolado e reproduzível. Este lab é voltado a estudo, desenvolvimento e experimentação.

## Arquitetura local

```text
┌───────────────────────────────────────────────────────────────┐
│ Windows                                                        │
│  └── Docker Desktop                                            │
│       └── WSL2 · Ubuntu                                        │
│            └── tmux · sessão: trabalho                        │
│                 ├── AWS Floci   → localhost:4566              │
│                 ├── Azure Floci → localhost:4577              │
│                 ├── GCP Floci   → localhost:4588              │
│                 ├── OCI Floci   → localhost:4599              │
│                 └── docker stats → CPU e memória ao vivo      │
└───────────────────────────────────────────────────────────────┘

Todos os emuladores executam em contêineres Docker locais.
Não exigem conta cloud, cartão, cobrança ou credenciais reais.
```

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

## Iniciar o lab pelo Floci CLI

```bash
floci start
floci az start
floci gcp start
floci oci start
```

## Alternativa reproduzível: Docker Compose

O arquivo `compose.yaml` inicia os quatro emuladores com volumes persistentes. Use *uma forma de início por vez*. Se o Floci CLI já estiver com os contêineres ativos, pare-os antes para evitar conflito nas portas.

```bash
floci stop
floci az stop
floci gcp stop
floci oci stop

docker compose up -d
docker compose ps
```

Para encerrar a stack criada pelo Compose, preservando os dados:

```bash
docker compose down
```

Para remover também os dados persistidos, ação destrutiva:

```bash
docker compose down -v
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

## Parar o lab iniciado pelo Floci CLI

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
