# Compatible PowerShell 5+ et PowerShell 7+

$words = [System.Collections.Generic.HashSet[string]\]::new()

for ($i = 1; $i -le 17; $i++) {

    $url = "https://www.listesdemots.net/mots5lettrespage$i.htm"

    Write-Host "Lecture de $url"

    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing

        $matches = [regex\]::Matches(
            $response.Content,
            '<span\s+class="mt">(.*?)</span>',
            [System.Text.RegularExpressions.RegexOptions\]::Singleline
        )

        foreach ($match in $matches) {

            $content = $match.Groups[1].Value

            $foundWords = [regex\]::Matches(
                $content.ToUpper(),
                '\b[A-Z]{5}\b'
            )

            foreach ($word in $foundWords) {
                $null = $words.Add($word.Value)
            }
        }
    }
    catch {
        Write-Warning "Erreur sur la page $i : $_"
    }

    Start-Sleep -Milliseconds 200
}

$sortedWords = $words | Sort-Object

$jsonWords = ($sortedWords | ForEach-Object {
    '"' + $_ + '"'
}) -join ", "

$output = "const WORDS = [$jsonWords];"

Set-Content `
    -Path "words.js" `
    -Value $output `
    -Encoding UTF8

Write-Host ""
Write-Host "Nombre de mots trouvés : $($sortedWords.Count)"
Write-Host "Fichier généré : words.js"
