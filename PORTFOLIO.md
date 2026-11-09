# Professor PH | Multi-Cloud Storage Validation Lab

> **PT-BR:** Demonstração local-first de infraestrutura como código para onboarding de storage em AWS, Azure, Google Cloud e Oracle Cloud Infrastructure (OCI), sem contas cloud, custos ou recursos reais.
>
> **EN:** A local-first infrastructure-as-code demonstration for storage onboarding across AWS, Azure, Google Cloud, and Oracle Cloud Infrastructure (OCI), with no cloud accounts, costs, or real resources.

## Resumo para recrutadores / Recruiter summary

**PT-BR**

Este projeto demonstra como estruturo uma validação multicloud com Terraform de forma reproduzível e segura. Cada cloud possui configuração e state isolados, mas todas seguem o mesmo fluxo de qualidade: validar o ambiente, inicializar providers, validar HCL e gerar um plano de execução.

O laboratório foi desenhado para discutir decisões de arquitetura, segurança de automação, diferenças entre provedores e critérios de aceite, sem depender de infraestrutura de produção.

**Escopo:** proof of concept local, voltado a desenvolvimento, documentação e demonstração técnica. Não é um ambiente de produção nem cria recursos em contas reais.

**EN**

This project shows how I structure reproducible and safe multicloud validation with Terraform. Each cloud has an isolated configuration and state, while all follow the same quality flow: validate the environment, initialize providers, validate HCL, and generate an execution plan.

The lab is designed to discuss architecture decisions, automation safety, provider differences, and acceptance criteria without depending on production infrastructure.

**Scope:** a local proof of concept for development, documentation, and technical demonstrations. It is not a production environment and does not create resources in real cloud accounts.

## Problema abordado / Problem addressed

**PT-BR**

Times que atendem múltiplas clouds precisam validar padrões de storage, controles de acesso e automação sem transformar uma atividade de estudo em custo, risco de credencial ou recurso órfão. A solução cria uma camada de experimentação local, com emuladores Docker e Terraform, para testar a intenção da infraestrutura antes de qualquer decisão de implantação oficial.

**EN**

Teams operating across multiple clouds need to validate storage patterns, access controls, and automation without turning a learning activity into cost, credential exposure, or orphaned resources. The solution creates a local experimentation layer using Docker emulators and Terraform to test infrastructure intent before any official deployment decision.

## Arquitetura / Architecture

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

**PT-BR:** A arquitetura mantém o state de cada provider separado, reduzindo o raio de impacto e facilitando diagnóstico por cloud.

**EN:** The architecture keeps each provider state separate, reducing blast radius and simplifying per-cloud troubleshooting.

## Resultados verificáveis / Verifiable results

| Cloud | PT-BR | EN | Plano esperado / Expected plan |
|---|---|---|---:|
| AWS | Bucket S3 local, endpoint exclusivo do emulador | Local S3 bucket, emulator-only endpoint | 1 recurso / resource |
| Azure | Resource Group, Storage Account e Blob Container privado com TLS 1.2 | Resource Group, Storage Account, and private Blob Container with TLS 1.2 | 3 recursos / resources |
| GCP | Bucket Cloud Storage com uniform bucket-level access | Cloud Storage bucket with uniform bucket-level access | 1 recurso / resource |
| OCI | Bucket Object Storage com `NoPublicAccess` e chave local efêmera | Object Storage bucket with `NoPublicAccess` and an ephemeral local key | 1 recurso / resource |
| **Total** |  |  | **6 recursos planejados / planned resources** |

**PT-BR:** A esteira executa somente `terraform init`, `terraform validate` e `terraform plan`. `terraform apply` não integra o fluxo.

**EN:** The pipeline runs only `terraform init`, `terraform validate`, and `terraform plan`. `terraform apply` is not part of the workflow.

## Controles de engenharia / Engineering controls

| Controle / Control | PT-BR | EN |
|---|---|---|
| Local-first | Todos os providers apontam para `localhost`; não há endpoint de cloud pública no laboratório. | All providers target `localhost`; the lab has no public-cloud endpoint. |
| Credenciais / Credentials | Variáveis comuns de credenciais de AWS, Azure, GCP e OCI no host fazem a esteira falhar antes do Terraform. | Common AWS, Azure, GCP, and OCI credential variables on the host make the pipeline fail before Terraform runs. |
| Isolamento / Isolation | Cada cloud tem diretório e state independentes. | Each cloud has an independent directory and state. |
| Evidências / Evidence | Saídas técnicas são sanitizadas antes do relatório; states, chaves, certificados e logs ficam fora do Git. | Technical outputs are sanitized before reporting; states, keys, certificates, and logs stay out of Git. |
| Reprodutibilidade / Reproducibility | Um fluxo padronizado reduz diferenças entre demonstrações. | A standardized flow reduces variation between demonstrations. |

## Decisões e trade-offs / Decisions and trade-offs

| Decisão / Decision | Motivo / Why | Trade-off |
|---|---|---|
| Emuladores Docker locais / Local Docker emulators | **PT-BR:** segurança, custo zero e ciclos rápidos de teste.<br>**EN:** safety, zero cost, and fast test cycles. | **PT-BR:** não substituem APIs, IAM, quotas e comportamento de produção.<br>**EN:** they do not replace production APIs, IAM, quotas, or behavior. |
| Estados Terraform separados / Separate Terraform states | **PT-BR:** reduz impacto e facilita diagnóstico por cloud.<br>**EN:** reduces blast radius and simplifies per-cloud troubleshooting. | **PT-BR:** exige orquestração simples para executar tudo junto.<br>**EN:** requires lightweight orchestration to run everything together. |
| Sem `apply` / No `apply` | **PT-BR:** evita efeitos colaterais e recursos persistentes.<br>**EN:** avoids side effects and persistent resources. | **PT-BR:** valida intenção, não o ciclo completo de provisionamento.<br>**EN:** validates intent, not the full provisioning lifecycle. |
| Sem GitHub Actions hospedado / No hosted GitHub Actions | **PT-BR:** `localhost` existe apenas no host que executa Docker.<br>**EN:** `localhost` only exists on the Docker host. | **PT-BR:** automação remota exige runner self-hosted isolado e revisão humana.<br>**EN:** remote automation requires an isolated self-hosted runner and human review. |

## Demonstração em 5 minutos / Five-minute demo

```bash
docker compose up -d
docker compose ps
cd storage-lab
bash scripts/run-local-validation.sh
```

**Critérios de aceite / Acceptance criteria**

1. **PT-BR:** Os quatro emuladores respondem saudavelmente.  
   **EN:** All four emulators respond healthily.
2. **PT-BR:** A proteção local-first confirma endpoints locais e ausência de credenciais reais no host.  
   **EN:** The local-first guard confirms local endpoints and no real credentials on the host.
3. **PT-BR:** Os quatro diretórios Terraform completam `init`, `validate` e `plan`.  
   **EN:** All four Terraform directories complete `init`, `validate`, and `plan`.
4. **PT-BR:** O relatório sanitizado registra 6 recursos para adicionar, 0 para alterar e 0 para destruir.  
   **EN:** The sanitized report records 6 resources to add, 0 to change, and 0 to destroy.
5. **PT-BR:** Nenhum recurso é criado.  
   **EN:** No resources are created.

## Competências demonstradas / Demonstrated skills

**PT-BR:** Terraform, Docker Compose, automação Shell e Python, validação de infraestrutura como código, fundamentos de storage multicloud, proteção de credenciais, TLS local, documentação técnica, critérios de aceite e comunicação de trade-offs.

**EN:** Terraform, Docker Compose, Shell and Python automation, infrastructure-as-code validation, multicloud storage fundamentals, credential protection, local TLS, technical documentation, acceptance criteria, and trade-off communication.

## Pitch de entrevista / Interview pitch

**PT-BR**

> Construí um laboratório local-first de validação Terraform para onboarding de storage em AWS, Azure, Google Cloud e OCI. Cada provider usa state isolado e emulador local, enquanto uma camada de segurança bloqueia credenciais reais do host e comandos Terraform mutáveis. A esteira executa somente init, validate e plan, depois sanitiza as evidências e produz um relatório objetivo. Ela foi criada para demonstrar decisões de engenharia multicloud sem criar recursos reais em cloud.

**EN**

> I built a local-first Terraform validation lab for storage onboarding across AWS, Azure, Google Cloud, and OCI. Each provider uses an isolated state and a local emulator, while a safety gate blocks real host credentials and mutable Terraform commands. The pipeline runs init, validate, and plan only, then sanitizes the evidence and produces a concise validation report. It is designed to demonstrate multicloud engineering decisions without creating real cloud resources.

## Documentação técnica / Technical documentation

- [Guia do onboarding de storage / Storage onboarding guide](storage-lab/README.md)
- [Esteira local-first e critérios de aceite / Local-first pipeline and acceptance criteria](storage-lab/PIPELINE-LOCAL-FIRST.md)
- [Checklist de execução / Execution checklist](storage-lab/EXECUTION-CHECKLIST.md)
- [Guia de comandos do laboratório / Lab command guide](GUIA-COMANDOS.md)
