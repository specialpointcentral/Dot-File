#!/bin/bash

PWD=$(pwd)

git submodule init
git submodule update

sudo apt update
sudo apt install git gcc python3 wget build-essential automake curl clang cmake ninja-build -y

# tmux
echo "Install tmux"
sudo apt install libevent-dev libncurses-dev byacc -y
cd tmux
sh autogen.sh
./configure && make -j
sudo make install
cd ..

# nvim
echo "Install nvim"
sudo apt install libtool libtool-bin gettext -y
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=Release
sudo make install
cd ..

# font
echo "Install Nerd Fonts: Fira code"
sudo apt install fonts-firacode -y

echo "==You need change font byhand!=="

# nvchad
echo "Install NvChad"
rm -rf ~/.config/nvim.bak || true
mv ~/.config/nvim ~/.config/nvim.bak || true
cp -r $PWD/NvChad/ ~/.config/nvim

# zsh
echo "Install ohmyzsh"
sudo apt install zsh -y
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ""--keep-zshrc
# Add oh-my-zsh plugins
echo "Install ohmyzsh plugins"
cp -r $PWD/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
cp -r $PWD/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
# Add oh-my-zsh themes
echo "Install ohmyzsh themes"
cp -r $PWD/powerlevel10k ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/

# ccls
echo "Install ccls"
sudo apt install libclang-10-dev zlib1g-dev rapidjson-dev -y
cd ccls
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-10 \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-10/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-10/
sudo cmake --build Release --target install
cd ..

# tmux config
echo "Config tmux"
cp $PWD/config/.tmux.conf ~/

# zsh config
echo "Config zsh"
cp $PWD/config/.zshrc ~/

