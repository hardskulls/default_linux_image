FROM debian:latest

# Useful for running container forever.
ENTRYPOINT ["top", "-b"]


# Installing utils for further installations.
RUN apt-get update
RUN apt-get -y install build-essential procps curl file git


# Installing zsh and oh-my-zsh.
RUN apt-get -y install zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

SHELL ["/bin/zsh", "-ec"]
RUN chsh -s $(which zsh)


# Installing brew.
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"


# Install go.
RUN brew install go
# Install rust (manually, docker and brew versions are too big).
# ❗ Notice the added ' -s -- -y' at the end.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN source "$HOME/.cargo/env"
#ENV PATH="/root/.cargo/bin:${PATH}"


# Install nano CLI editor.
RUN brew install nano


# Installing task util for Taskfiles.
RUN brew install go-task


# Install fzf for zoxide (z).
RUN brew install fzf
# To install useful key bindings and fuzzy completion:
RUN $(brew --prefix)/opt/fzf/install

# Install zoxide (z).
RUN brew install zoxide
RUN echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc


# Install some CLI tools.
# 🔗 from: https://dev.to/deepu105/rust-easy-modern-cross-platform-command-line-tools-to-supercharge-your-terminal-4dd3?comments_sort=top
RUN brew install bat
RUN brew install lsd
# Throws an error.
#RUN brew install exa
RUN brew install ripgrep
RUN brew install rm-improved
RUN brew install dust
RUN brew install fd
RUN brew install sd
RUN brew install bottom
RUN brew install topgrade
RUN brew install broot
RUN brew install tokei


# Prettify zsh.
# Full plugin list: 'git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete'.
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
RUN git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/g' ~/.zshrc
