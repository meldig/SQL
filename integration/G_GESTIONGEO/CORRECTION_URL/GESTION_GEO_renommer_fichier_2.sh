#!/bin/bash

# 1. COMMAND DE RENOMMAGE DES FICHIERS
awk -F , '{ system("mv -v "$1" "$2"") }' liste_fichier_renommer.csv

PAUSE