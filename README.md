# Nvim en tant que IDE


Le but de la présentation est de faciliter la découverte de quelques unes parmi les nombreuses possibilités d'extension de Neovim avec des plugins pour customiser l'outil et ajouter des fonctionnalités traditionnellement trouvées exclusivement sur des IDE


## Dépendances

- docker
  
Installation sur Linux
  
```bash
# dépendances
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release

# setup keyring
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# setup repo
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# installation docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# tester l'installation
sudo docker run hello-world
```
  

## Lancement du container de test

```bash
# récupérer le dépôt de la présentation
git clone https://github.com/voltux/nvim_ide_presentation.git

# se placer dedans
cd nvim_ide_presentation

# build l'image docker définie par le Dockerfile
docker build . -t debian-nvim

# run le container et faire tourner un shell bash dessus
docker run -it debian-nvim /bin/bash
```
  A la fin de ces commandes on se retrouve dans le container avec la configuration mise en place. En lançant la commande
```bash
nvim
```
  Neovim se lancera et les plugins seront installés automatiquement. Si on rencontre quelques erreurs à la fin de l'installation on peut lancer la commande:
```vim
:Lazy sync
```
  afin de relancer la mise à jour pour les plugins

## Contenu du container docker

Dans le container docker on trouvera l'utilisateur voltux avec trois répertoires dans son $HOME:
  
- opt
  
le répertoire d'installation de Neovim
  
- dotfiles
  
le clone de mon dépôt de configuration personnelle
  
- workspace/sudoku-solver-qt
  
le petit projet pour tester la configuration Neovim
