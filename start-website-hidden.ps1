$ErrorActionPreference = 'Stop'

$websiteRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8080
$logPath = Join-Path $websiteRoot 'server.log'

Set-Location $websiteRoot

$pythonCommand = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCommand) {
    $pythonCommand = Get-Command py -ErrorAction SilentlyContinue
}

if (-not $pythonCommand) {
    "$(Get-Date -Format s) ERROR: Python was not found." | Out-File -FilePath $logPath -Append -Encoding utf8
    exit 1
}

"$(Get-Date -Format s) Starting rubric-system server at http://127.0.0.1:$port/" | Out-File -FilePath $logPath -Append -Encoding utf8

& $pythonCommand.Source -m http.server $port --bind 0.0.0.0 --directory $websiteRoot *>> $logPath