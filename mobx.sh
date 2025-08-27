#!/bin/bash

# Script utilitário para rodar o MobX Codegen no projeto Flutter
# Uso:
#   ./mobx.sh build         -> roda o build_runner normal
#   ./mobx.sh watch         -> roda o build_runner em modo watch
#   ./mobx.sh clean         -> limpa os arquivos gerados
#   ./mobx.sh file <path>   -> roda o codegen só em um arquivo específico

case "$1" in
  build)
    flutter pub run build_runner build --delete-conflicting-outputs
    ;;
  watch)
    flutter pub run build_runner watch --delete-conflicting-outputs
    ;;
  clean)
    flutter pub run build_runner clean
    ;;
  file)
    if [ -z "$2" ]; then
      echo "🚨 Informe o arquivo! Exemplo:"
      echo "./mobx.sh file lib/stores/todo_store.dart"
      exit 1
    fi
    flutter pub run build_runner build --delete-conflicting-outputs --build-filter="$2"
    ;;
  *)
    echo "⚡ Comandos disponíveis:"
    echo "  ./mobx.sh build         -> build normal"
    echo "  ./mobx.sh watch         -> build em modo watch"
    echo "  ./mobx.sh clean         -> limpa arquivos gerados"
    echo "  ./mobx.sh file <path>   -> build para arquivo específico"
    ;;
esac
