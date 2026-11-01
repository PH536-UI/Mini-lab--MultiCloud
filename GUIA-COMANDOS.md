# Guia rápido de comandos | Quick Command Guide

Este guia traz os mesmos comandos em português e inglês.

---

## Subir serviços separadamente | Start services independently

```bash
floci start
floci az start
floci gcp start
floci oci start
```

| Português | English |
|---|---|
| `floci start`: inicia AWS na porta 4566 | `floci start`: starts AWS on port 4566 |
| `floci az start`: inicia Azure na porta 4577 | `floci az start`: starts Azure on port 4577 |
| `floci gcp start`: inicia GCP na porta 4588 | `floci gcp start`: starts GCP on port 4588 |
| `floci oci start`: inicia OCI na porta 4599 | `floci oci start`: starts OCI on port 4599 |

PT-BR: Execute somente o comando da cloud que quer testar. Para iniciar as quatro, rode os quatro comandos, um por vez.

EN: Run only the command for the cloud you want to test. To start all four, run the four commands one at a time.

---

## Parar serviços separadamente | Stop services independently

```bash
floci stop
floci az stop
floci gcp stop
floci oci stop
```

PT-BR: Cada comando para somente o emulador correspondente.

EN: Each command stops only its matching emulator.

---

## Criar a sessão tmux | Create the tmux session

```bash
tmux new -s trabalho
```

PT-BR: Cria uma sessão chamada `trabalho`.

EN: Creates a session named `trabalho`.

---

## Dividir e usar a tela | Split and use the screen

| Atalho | Português | English |
|---|---|---|
| `Ctrl+B`, depois `%` | divide esquerda e direita | splits left and right |
| `Ctrl+B`, depois `"` | divide em cima e baixo | splits top and bottom |
| `Ctrl+B`, depois setas | troca de painel | switches panes |
| `Ctrl+B`, depois `d` | sai sem encerrar a sessão | detaches without stopping the session |

> Primeiro pressione `Ctrl+B`, solte as teclas e pressione a próxima tecla.
>
> First press `Ctrl+B`, release the keys, then press the next key.

---

## Voltar para a sessão | Reattach to the session

```bash
tmux attach -t trabalho
```

PT-BR: Retorna à sessão sem reiniciar os serviços.

EN: Returns to the session without restarting services.

---

## Conferir o que está ativo | Check what is running

```bash
docker ps
docker stats
```

| Comando | Português | English |
|---|---|---|
| `docker ps` | lista os contêineres em execução | lists running containers |
| `docker stats` | mostra CPU e memória em tempo real | shows live CPU and memory usage |

---

## Vocabulário técnico | Technical vocabulary

| English | Português |
|---|---|
| start | iniciar |
| stop | parar |
| service | serviço |
| container | contêiner |
| port | porta |
| pane | painel |
| split | dividir |
| running | em execução |
| local environment | ambiente local |
