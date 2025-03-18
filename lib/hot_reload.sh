#!/bin/bash
# Script pour exécuter Flutter avec rechargement à chaud

# Vérifiez que PROJECT_DIR est défini
if [ -z "$PROJECT_DIR" ]; then
  echo "Erreur : PROJECT_DIR n'est pas défini."
  exit 1
fi

# Accédez au répertoire du projet
cd $PROJECT_DIR/..

# Exécutez Flutter en mode développement avec rechargement à chaud
flutter run

