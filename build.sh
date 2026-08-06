#!/bin/zsh
# this file will compile all the assets into a neat zip-package under build/ folder to be distributed
zip -r build/Enigmaticless.zip LICENSE.md README.md pack.mcmeta pack.png assets/ -x "*.aseprite"
