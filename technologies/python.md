# Python 3.11

## Installation
### Ubuntu
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 python3.11-dev python3.11-venv
```
### Windows
```
1. Download the Python 3.11 installer from the official [Python website](https://www.python.org/downloads/windows/).
2. Run the installer and ensure you check the box "Add Python to PATH".
3. Follow the installation steps.
```

### Mac
```
brew update
brew install python@3.11
```

## Usage Guidelines
- Follow [PEP8 conventions](https://www.python.org/dev/peps/pep-0008/)
- Always use [virtual environments](https://docs.python.org/3/library/venv.html)
```
python3.11 -m venv ./venv
source ./venv/bin/activate
pip install -r requirements.txt
```

You can also add the following to your .bashrc or .zshrc file for easy virtual environment creation
```
venv(){
        python3.11 -m venv ./venv
}

activate(){
    deactivate
    source ./venv/bin/activate  # commented out by conda initialize
}
```