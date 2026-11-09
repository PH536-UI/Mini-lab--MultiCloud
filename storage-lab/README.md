# Onboarding multicloud de storage com Terraform, local-first

Demonstração técnica para onboarding de storage em AWS, Azure, Google Cloud e OCI sem conta, credenciais ou recursos reais. Cada pasta é um estado Terraform independente e fala apenas com um emulador local.

## O que o laboratório entrega

| Cloud | Recurso | Critério de aceite |
|---|---|---|
| AWS | S3 bucket | endpoint `localhost:4566`, sem acesso a AWS real |
| Azure | Resource Group, Storage Account e Blob Container | TLS 1.2 e container `private` no endpoint `localhost:4577` |
| GCP | Cloud Storage bucket | acesso uniforme no endpoint `localhost:4588` |
| OCI | Object Storage bucket | `NoPublicAccess`, endpoint `localhost:4599` e chave efêmera local |

## Limites de segurança

- Não há `terraform apply` em nenhum script.
- Os valores de identidade são sementes públicas do emulador, não credenciais de cloud.
- A chave OCI é criada em `oci/.local/`, com permissão `600`, e fica ignorada pelo Git.
- Cada cloud tem seu próprio diretório e state. Não compartilhe `.terraform` nem `terraform.tfstate`.

## Preparar o host

```bash
docker compose up -d
docker compose ps
cd storage-lab
bash scripts/preflight.sh
```

Se o preflight indicar TLS ausente no Azure, recrie apenas o emulador Azure e tente de novo:

```bash
docker compose up -d --force-recreate floci-az
cd storage-lab
bash scripts/preflight.sh
```

## Validar o onboarding sem criar recursos

```bash
cd storage-lab
bash scripts/plan-all.sh
```

O script prepara o certificado autoassinado Azure para o processo Terraform, gera uma chave OCI descartável e executa somente `init`, `validate` e `plan` em `aws`, `azure`, `gcp` e `oci`.

## Painel de observabilidade

```bash
cd storage-lab
bash scripts/start-tmux.sh
tmux attach -t storage-lab
```

São cinco painéis: endpoints AWS, Azure, GCP e OCI, mais `docker stats` dos quatro contêineres. Para soltar a sessão sem encerrar, use `Ctrl+B`, depois `d`.

## Narrativa curta para a vaga

> I designed a local-first, Terraform-based storage onboarding across AWS, Azure, Google Cloud, and OCI. Each cloud has isolated state, local endpoints, explicit security controls, and reproducible acceptance criteria. The Azure path handles TLS trust, GCP enforces uniform bucket-level access, OCI uses an ephemeral local API key, and the monitoring view confirms emulator health and container consumption. No cloud account or real resource is used in this demonstration.

## Depois de uma execução local autorizada

Após um `apply` local executado conscientemente, destrua cada estado separadamente:

```bash
for cloud in aws azure gcp oci; do (cd "$cloud" && terraform destroy -input=false); done
```

Não use esse comando contra contas reais.
