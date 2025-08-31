#!/bin/zsh

#  install.sh
#  acli
#
#  Created by Antonio Izquierdo Álvarez on 5/6/25.
#
# open -a Terminal

# Obtiene la ruta del binario compilado
# open -a Terminal "$(ls -d ~/Library/Developer/Xcode/DerivedData/* | grep 'PhaseCLT-')/Build/Products/Release"
open -a Terminal "$(ls -d ~/Library/Developer/Xcode/DerivedData/* | grep 'PhaseCLT-')/Build/Products/Debug"
