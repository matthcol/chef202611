# Image Chef Workstation — macOS + Podman

Variante de [`../docker-chef-workstation`](../docker-chef-workstation/) pour les stagiaires sur **macOS avec Podman** (pas Docker Desktop). Deux différences par rapport à Docker Desktop qui cassent sinon le build/run :

1. **Architecture** : Chef Workstation 25.x ne fournit pas de paquet Linux **arm64** (le support aarch64 n'arrive qu'en 26.2.0, qu'on évite ici — voir plus bas). Sur un Mac Apple Silicon (M1/M2/M3), il faut donc forcer l'image en **amd64** et faire tourner l'émulation. C'est fait dans le `Dockerfile` de ce dossier via `FROM --platform=linux/amd64`.
2. **Socket Docker** : `kitchen-dokken` cherche le daemon via `/var/run/docker.sock`. Ce chemin n'existe pas nativement avec Podman (c'est une spécificité Docker Desktop) — il faut installer `podman-mac-helper` pour que ce chemin existe.

On reste volontairement sur **Chef Workstation 25.x** : la branche 26.x remplace Test Kitchen communautaire par Chef Test Kitchen Enterprise (TKE), ce qui casserait potentiellement `kitchen-dokken` utilisé par les exercices 02 à 05.

## Prérequis (une fois, par stagiaire)

### 1. Podman Desktop / Podman installé et une machine démarrée

```sh
podman machine list
```

Si aucune machine n'existe :

```sh
podman machine init
podman machine start
```

### 2. Émulation amd64 sur Apple Silicon (M1/M2/M3 uniquement)

Sur Mac Intel, cette étape ne sert à rien (l'hôte est déjà amd64) — passez directement à l'étape 3.

Sur Apple Silicon, la VM Podman doit pouvoir traduire les binaires x86_64 (Rosetta, nettement plus rapide que l'émulation QEMU). La syntaxe exacte dépend de la version de Podman installée ; vérifiez d'abord :

```sh
podman machine init --help | grep -i rosetta
```

- Si l'option `--rosetta` existe : recréez la machine avec `podman machine init --rosetta` (après avoir supprimé l'ancienne si besoin : `podman machine rm`).
- Sinon, utilisez la variable d'environnement au moment de la création de la machine :
  ```sh
  CONTAINERS_MACHINE_ROSETTA=true podman machine init
  ```

Sans cette étape, l'image amd64 construite plus bas risque de ne pas démarrer du tout sur Apple Silicon (pas de fallback automatique comme avec Docker Desktop).

### 3. Compatibilité du socket Docker

```sh
sudo podman-mac-helper install
podman machine stop
podman machine start
```

Vérifiez que le symlink existe :

```sh
ls -la /var/run/docker.sock
```

## Build

```sh
cd podman-mac-chef_workstation
podman build -t chef-tooling:local .
```

## Run

```sh
podman run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)/code:/workdir" \
  -w /workdir \
  chef-tooling:local bash
```

Si vous voyez un warning du type *"image platform does not match the detected host platform"*, c'est normal sur Apple Silicon (émulation amd64) et sans impact — ajoutez `--platform=linux/amd64` à la commande ci-dessus si vous préférez le faire taire explicitement.

## Valider les outils

Une fois dans le container :

```sh
chef --version      # cli workstation
kitchen --version   # tester les recettes
knife --version     # appliquer/synchroniser les recettes
docker ps           # doit atteindre le daemon Podman via le socket monté
```

## Dépannage

| Symptôme | Cause probable | Fix |
|---|---|---|
| `podman build` échoue sur le `curl \| bash` de Chef Workstation (404 / package not found) | Build parti en arm64 natif au lieu d'amd64 | Vérifier que `FROM --platform=linux/amd64` est bien dans le Dockerfile, relancer le build |
| Le container ne démarre pas du tout / erreur `exec format error` | Rosetta/QEMU pas configuré sur la machine Podman | Revoir l'étape 2 des prérequis, recréer la machine si besoin |
| `kitchen converge` ne trouve pas de daemon Docker | `/var/run/docker.sock` absent ou périmé | Revoir l'étape 3 (`podman-mac-helper`), relancer `podman machine stop && podman machine start` |
