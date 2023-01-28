FROM debian:latest

# Update system
RUN apt update && apt upgrade -y

# Install dependencies
RUN apt install wget tar unzip git g++ python3 python3-venv python3-pip ripgrep bat htop -y

# Create new user without root access
RUN useradd voltux -m
USER voltux

# Get neovim
WORKDIR /home/voltux
RUN mkdir opt
WORKDIR /home/voltux/opt
RUN wget https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.tar.gz
RUN tar -xzvf nvim-linux64.tar.gz
RUN rm nvim-linux64.tar.gz
RUN echo 'alias nvim=$HOME/opt/nvim-linux64/bin/nvim' >> /home/voltux/.bashrc

# Get configuration files
WORKDIR /home/voltux
RUN git clone https://github.com/voltux/dotfiles.git
RUN mkdir -p /home/voltux/.config
RUN ln -s /home/voltux/dotfiles/nvim/.config/nvim /home/voltux/.config/nvim

# Get nvm node manager for LSP
RUN wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh && bash ./install.sh
RUN echo 'export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> .bashrc
RUN rm install.sh

# Get sudoku solver project
RUN mkdir workspace
WORKDIR /home/voltux/workspace
RUN git clone https://github.com/voltux/sudoku-solver-qt.git
RUN git clone https://github.com/voltux/nvim_ide_presentation.git

# Install debugpy for dap
WORKDIR /home/voltux
RUN mkdir .virtualenvs
WORKDIR /home/voltux/.virtualenvs
RUN python3 -m venv debugpy
RUN ./debugpy/bin/pip install debugpy
WORKDIR /home/voltux

RUN /home/voltux/opt/nvim-linux64/bin/nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN /home/voltux/opt/nvim-linux64/bin/nvim --headless -c 'autocmd User LspInstallComplete quitall' "+MasonInstall python-lsp-server" "+sleep 3" +qa
RUN /home/voltux/opt/nvim-linux64/bin/nvim --headless -c 'autocmd User TSInstallComplete quitall' "+TSInstall python" "+sleep 10" +qa
RUN /home/voltux/opt/nvim-linux64/bin/nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Configure git
RUN git config --global user.email "voltux@debian-nvim.com"
RUN git config --global user.name "voltux"
