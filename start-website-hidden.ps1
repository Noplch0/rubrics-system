param(
    [string]$PythonExecutable
)

$ErrorActionPreference = 'Stop'

$websiteRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8080
$logPath = Join-Path $websiteRoot 'server.log'
$accessLogPath = Join-Path $websiteRoot 'server-access.log'

Set-Location $websiteRoot

if (-not $PythonExecutable) {
    $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if (-not $pythonCommand) {
        $pythonCommand = Get-Command py -ErrorAction SilentlyContinue
    }

    if ($pythonCommand) {
        $PythonExecutable = $pythonCommand.Source
    }
}

if (-not $PythonExecutable -or -not (Test-Path $PythonExecutable)) {
    "$(Get-Date -Format s) ERROR: Python was not found." | Out-File -FilePath $logPath -Append -Encoding utf8
    exit 1
}

"$(Get-Date -Format s) Starting rubric-system server with $PythonExecutable at http://0.0.0.0:$port/" | Out-File -FilePath $logPath -Append -Encoding utf8

$process = Start-Process `
    -FilePath $PythonExecutable `
    -ArgumentList @('-m', 'http.server', $port, '--bind', '0.0.0.0', '--directory', "`"$websiteRoot`"") `
    -WorkingDirectory $websiteRoot `
    -WindowStyle Hidden `
    -RedirectStandardOutput $logPath `
    -RedirectStandardError $accessLogPath `
    -PassThru `
    -Wait

"$(Get-Date -Format s) Server stopped with exit code $($process.ExitCode)." | Out-File -FilePath $logPath -Append -Encoding utf8
exit $process.ExitCode