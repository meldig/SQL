#!/bin/bash

# 1. COMMAND DE RENOMMAGE DES FICHIERS
exec &> liste_fichier_renommer.log
awk -F , '{ system("mv -v "$1" "$2"") }' liste_fichier_renommer.csv

PAUSE