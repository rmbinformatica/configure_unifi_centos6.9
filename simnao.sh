#!/bin/bash
# Script para perguntar SIM ou NÃO a um usuário e executar um segundo script caso escolhido sim
# Utilização simnao.sh "Mensagem da pergunta" [script_a_executar.sh]
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 [pergunta] [script caso sim]"
else
   read -p "$1 (S/N) ? " -n 1 -r
   echo 
   if [[ $REPLY =~ ^[YySs]$ ]]
   then
      ./$2
   fi
fi
