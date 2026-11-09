# Checklist de execução local

## Pré-condições

- [ ] Docker e Docker Compose instalados.
- [ ] Terraform >= 1.6 instalado no host.
- [ ] `floci-aws`, `floci-az`, `floci-gcp` e `floci-oci` em `healthy`.
- [ ] `FLOCI_AZ_TLS_ENABLED: "true"` presente no serviço Azure do `compose.yaml`.
- [ ] Nenhuma variável de credencial real exportada para esta demonstração.

## Segurança e preparação

- [ ] Rodar `bash scripts/preflight.sh`.
- [ ] Certificado Azure obtido apenas de `https://localhost:4577/_floci/tls-cert`.
- [ ] Chave OCI criada localmente em `oci/.local/oci_api_key.pem` e não versionada.
- [ ] Conferir `git status --ignored` para garantir que `.local/`, states e certificados não serão incluídos em commit.

## Aceite por cloud

- [ ] AWS: o plano cria somente `aws_s3_bucket.storage_lab` no endpoint local `:4566`.
- [ ] Azure: o plano cria RG, Storage Account com TLS 1.2 e container privado em `:4577`.
- [ ] GCP: o plano define `uniform_bucket_level_access = true` no endpoint local `:4588`.
- [ ] OCI: o plano define `access_type = "NoPublicAccess"` no endpoint local `:4599`.
- [ ] `bash scripts/plan-all.sh` termina sem `apply`.

## Demonstração

- [ ] Abrir `bash scripts/start-tmux.sh`.
- [ ] Mostrar os quatro endpoints e o painel `docker stats`.
- [ ] Declarar que o ambiente é emulado, local e sem conta real.
- [ ] Mostrar isolamento por pasta/state e os critérios de segurança antes de falar de automação.

## Encerramento local

- [ ] Caso um apply local tenha sido aprovado e executado, aplicar `terraform destroy` em cada pasta.
- [ ] Remover a chave OCI com `rm -rf oci/.local` se não for reutilizar o lab.
- [ ] Não publicar `.terraform`, states, certificados ou chaves.
