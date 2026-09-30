#!/bin/sh

TMP=$(mktemp)

for i in $(seq 1 17)
do
    URL="https://www.listesdemots.net/mots5lettrespage${i}.htm"

    echo "Téléchargement page $i..."

    curl -s "$URL" |
    grep -oE '\b[A-Z]{5}\b' >> "$TMP"
done

sort -u "$TMP" > mots.txt

{
    printf 'const WORDS = [\n'

    COUNT=$(wc -l < mots.txt)
    CURRENT=0

    while read -r WORD
    do
        CURRENT=$((CURRENT + 1))

        if [ "$CURRENT" -lt "$COUNT" ]
        then
            printf '    "%s",\n' "$WORD"
        else
            printf '    "%s"\n' "$WORD"
        fi

    done < mots.txt

    printf '];\n'

} > words.js

echo "Nombre de mots uniques : $(wc -l < mots.txt)"
echo "Fichier généré : words.js"

rm -f "$TMP"