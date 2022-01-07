#!/bin/bash

# 1. COMMAND DE RENOMMAGE DES REPERTOIRES
awk -F , '{ system("mv -v "$1" "$2"") }' liste_repertoire_renommer.csv

PAUSE