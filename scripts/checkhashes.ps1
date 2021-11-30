if(!$env:SCOOP_HOME) { $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop) }
$checkhashes = "$env:SCOOP_HOME/bin/checkhashes.ps1"
$dir = "$psscriptroot/../" # checks the parent dir

#Incase of mismatched hash, generate and update manifest with latest hash
Invoke-Expression -command "& '$checkhashes' -dir '$dir' $($args | ForEach-Object { "$_ " }) -UseCache -Update"