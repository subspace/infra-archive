## Installation
```bash
wget https://github.com/mikefarah/yq/releases/download/v4.25.3/yq_linux_amd64
snap install yq
```

[yq](https://github.com/mikefarah/yq) - a lightweight and portable command-line YAML, JSON and XML processor.

## Commands
* -cp=value - name of command property for replacement
* -cv=value - value of command property for replacement
* -cpr=value - command property for removing
* -i=value - new image 

## Usage example
```bash
chmod u+x templating.sh

./templating.sh -i=ghcr.io/subspace/node:gemini-1b-2022-jun-18 -cp=in-peers -cv=100 -cpr=reserved-only
```