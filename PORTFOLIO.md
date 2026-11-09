# Professor PH | Multi-Cloud Storage Validation Lab

> Demonstração local-first de infraestrutura como código para onboarding de storage em AWS, Azure, Google Cloud e Oracle Cloud Infrastructure (OCI), sem contas cloud, custos ou recursos reais.

## Resumo para recrutadores

Este projeto demonstra como estruturo uma validação multicloud com Terraform de forma reproduzível e segura. Cada cloud possui configuração e state isolados, mas todas seguem o mesmo fluxo de qualidade: validar o ambiente, inicializar providers, validar HCL e gerar um plano de execução.

O laboratório foi desenhado para discutir decisões de arquitetura, segurança de automação, diferenças entre provedores e critérios de aceite, sem depender de infraestrutura de produção.

**Escopo:** proof of concept local, voltado a desenvolvimento, documentação e demonstração técnica. Não é um ambiente de produção nem cria recursos em contas reais.

## Problema abordado

Times que atendem múltiplas clouds precisam validar padrões de storage, controles de acesso e automação sem transformar uma atividade de estudo em custo, risco de credencial ou recurso órfão.

A solução cria uma camada de experimentação local, com emuladores Docker e Terraform, para testar a intenção da infraestrutura antes de qualquer decisão de implantação oficial.

## Arquitetura

```text
Terraform local-first validation pipeline
             │
             ├── AWS emulator     → localhost:4566 → S3 bucket
             ├── Azure emulator   → localhost:4577 → Resource Group + Storage Account + private Blob Container
             ├── GCP emulator     → localhost:4588 → Cloud Storage bucket with uniform access
             └── OCI emulator     → localhost:4599 → Object Storage bucket with NoPublicAccess

Controls: endpoint verification · host credential blocking · isolated Terraform state
Outputs: sanitized evidence · validation report · reproducible acceptance criteria
```

## Resultados verificáveis

| Cloud | Validação de storage | Controle destacado | Plano esperado |
|---|---|---|---:|
| AWS | Bucket S3 local | Endpoint exclusivo do emulador | 1 recurso |
| Azure | Resource Group, Storage Account e Blob Container | TLS 1.2 e container privado | 3 recursos |
| GCP | Bucket Cloud Storage local | Uniform bucket-level access | 1 recurso |
| OCI | Bucket Object Storage local | `NoPublicAccess` e chave local efêmera | 1 recurso |
| **Total** |  |  | **6 recursos planejados** |

A esteira executa somente `terraform init`, `terraform validate` e `terraform plan`. `terraform apply` não integra o fluxo.

## Controles de engenharia

- **Local-first:** todos os providers apontam para `localhost`; não há endpoint de cloud pública no laboratório.
- **Credenciais:** variáveis comuns de credenciais de AWS, Azure, GCP e OCI no host fazem a esteira falhar antes do Terraform.
- **Isolamento:** cada cloud tem diretório e state independentes, evitando acoplamento entre providers.
- **Evidências:** as saídas técnicas são sanitizadas antes de gerar o relatório final; states, chaves, certificados e logs ficam fora do Git.
- **Reprodutibilidade:** o fluxo padronizado reduz diferenças de execução entre demonstrações.

## Decisões e trade-offs

| Decisão | Motivo | Trade-off |
|---|---|---|
| Emuladores Docker locais | Segurança, custo zero e ciclos rápidos de teste | Não substituem APIs, IAM, quotas e comportamento de produção |
| Estados Terraform separados | Reduz raio de impacto e facilita diagnóstico por cloud | Exige orquestração simples para rodar tudo junto |
| Sem `apply` | Evita efeitos colaterais e recursos persistentes | Valida intenção, não o ciclo de provisionamento completo |
| Sem GitHub Actions hospedado | `localhost` existe apenas no host que roda Docker | Automação remota exige runner self-hosted isolado e política de revisão |

## Demonstração em 5 minutos

```bash
docker compose up -d
docker compose ps
cd storage-lab
bash scripts/run-local-validation.sh
```

Critérios de aceite:

1. Os quatro emuladores respondem saudavelmente.
2. A proteção local-first confirma endpoints locais e ausência de credenciais reais no host.
3. Os quatro diretórios Terraform completam `init`, `validate` e `plan`.
4. O relatório sanitizado registra 6 recursos para adicionar, 0 para alterar e 0 para destruir.
5. Nenhum recurso é criado.

## Competências demonstradas

Terraform, Docker Compose, automação Shell e Python, validação de infraestrutura como código, fundamentos de storage multicloud, proteção de credenciais, TLS local, documentação técnica, critérios de aceite e comunicação de trade-offs.

## Pitch em inglês

> I built a local-first Terraform validation lab for storage onboarding across AWS, Azure, Google Cloud, and OCI. Each provider uses an isolated state and a local emulator, while a safety gate blocks real host credentials and mutable Terraform commands. The pipeline runs init, validate, and plan only, then sanitizes the evidence and produces a concise validation report. It is designed to demonstrate multicloud engineering decisions without creating real cloud resources.

## Documentação técnica

- [Guia do onboarding de storage](storage-lab/README.md)
- [Esteira local-first e critérios de aceite](storage-lab/PIPELINE-LOCAL-FIRST.md)
- [Checklist de execução](storage-lab/EXECUTION-CHECKLIST.md)
- [Guia de comandos do laboratório](GUIA-COMANDOS.md)
