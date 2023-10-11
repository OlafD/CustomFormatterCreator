$contentJson = [string] (Get-Content -Path .\ContentFormatter.json)

$json = ConvertFrom-Json -InputObject $contentJson -Depth 16
$hashtableJson = ConvertFrom-Json -InputObject $contentJson -Depth 16 -AsHashtable

Write-Host
