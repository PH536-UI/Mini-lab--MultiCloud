# Guia rápido de comandos

## Subir serviços separadamente

```bash
floci start
floci az start
floci gcp start
floci oci start
```

- `floci start`: AWS, porta 4566
- `floci az start`: Azure, porta 4577
- `floci gcp start`: GCP, porta 4588
- `floci oci start`: OCI, porta 4599

Rode apenas o comando do ambiente que for usar. Para iniciar os quatro, execute os quatro comandos, um de cada vez.

## Parar serviços separadamente

```bash
floci stop
floci az stop
floci gcp stop
floci oci stop
```

Cada comando para somente o emulador correspondente.

## Criar a sessão tmux

```bash
tmux new -s trabalho
```

## Dividir e usar a tela no tmux

```text
Ctrl+B, depois %       divide esquerda e direita
Ctrl+B, depois "       divide em cima e baixo
Ctrl+B, depois ↑ ↓ ← → troca de painel
Ctrl+B, depois d       sai sem encerrar a sessão
```

## Voltar para a sessão

```bash
tmux attach -t trabalho
```

## Conferir o que está ativo

```bash
docker ps
docker stats
```
