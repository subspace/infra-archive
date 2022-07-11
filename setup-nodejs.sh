#!/bin/bash

sudo apt-get -y update && \
     sudo  apt-get -y upgrade && \
     sudo  apt-get -y install curl && \
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && \
      export NVM_DIR="$HOME/.nvm" && \
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
      nvm install v15.0.1 && \
      nvm use v15.0.1

export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    npm install --global yarn
