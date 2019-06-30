
FROM thawk/neovim:latest

ENV HOME=/root

RUN true \
  && git clone --depth 1 --shallow-submodules https://github.com/SpaceVim/SpaceVim.git $HOME/.SpaceVim \
  && git clone --depth 1 --shallow-submodules https://github.com/natac13/dotspacevim.git $HOME/.SpaceVim.d \
  && rm -r $HOME/.SpaceVim/.git $HOME/.SpaceVim.d/.git \
  && mkdir -p $HOME/.config \
  && ln -s $HOME/.SpaceVim $HOME/.config/nvim \
  && sed -i -e '/begin optional layers/,/end optional layers/ d' $HOME/.SpaceVim.d/init.toml \
  && git clone --depth 1 --shallow-submodules https://github.com/Shougo/dein.vim.git $HOME/.cache/vimfiles/repos/github.com/Shougo/dein.vim \
  && nvim --headless +'call dein#install()' +qall \
  && (find $HOME/.cache/vimfiles -type d -name ".git" | xargs rm -r) \
  && true

# Still getting the Error from startify-faq-02 that it cannot read the .viminfo file
# Was getting this error with the thawk/spacevim-base image aswell
RUN rm -rf $HOME/.viminfo && touch $HOME/.viminfo 

WORKDIR /src
VOLUME /src

ENTRYPOINT ["/usr/bin/nvim"]
