#!/bin/sh

TMP=$(mktemp)

echo "Téléchargement page 1..."

curl -s "https://www.listesdemots.net/mots5lettres.htm" |
grep -oE '[A-Z]{5}' >> "$TMP"

for i in $(seq 2 17)
do
    URL="https://www.listesdemots.net/mots5lettrespage${i}.htm"

    echo "Téléchargement page $i..."

    curl -s "$URL" |
    grep -oE '[A-Z]{5}' >> "$TMP"
done

sort -u "$TMP" > mots.txt

echo "Nombre de mots : $(wc -l < mots.txt)"