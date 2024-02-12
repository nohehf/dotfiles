FONTS_DIR="/Library/Fonts"

function isFontInstalled() {
    if [ $(ls -a $FONTS_DIR | grep -i "$1" | wc -l | tr -d ' ') -gt 0 ]; then
        echo true
    else
        echo false
    fi
}

if [ ! $(isFontInstalled "JetBrains") ]; then
    cd $FONTS_DIR
    echo "Installing JetBrains Mono nerd font..."
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip JetBrainsMono.zip
    rm JetBrainsMono.zip
else
    echo "JetBrains Mono already installed, skipping..."
fi
