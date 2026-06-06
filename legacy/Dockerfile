# install debian base image
FROM debian:latest

# install dependencies
RUN apt update && apt upgrade -y
RUN apt install -y build-essential
RUN apt install -y git
RUN apt install -y nodejs npm
RUN apt install -y curl wget

# install zsh and oh-my-zsh
RUN apt install -y zsh curl
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# set zsh as default shell
RUN chsh -s $(which zsh)

# clone the repository
RUN git clone https://github.com/Goku-kun/dotfiles

# copy zshrc file
RUN cp /dotfiles/zsh/.zshrc /root/.zshrc

# set working directory
WORKDIR /dotfiles

# run the install script
RUN echo "make install_nvim_debian_root"
