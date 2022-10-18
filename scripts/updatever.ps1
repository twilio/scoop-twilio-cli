param(
    [String] $version = ''
)
if(!$env:SCOOP_HOME) { $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop) }
$checkver = "$env:SCOOP_HOME/bin/checkver.ps1"
$dir = "$psscriptroot/../" # checks the parent dir
if($version -like "*draft*"){
    Invoke-Expression -command "& '$checkver' -a '$psscriptroot/../twiliodraft.json' -Update -v '$version'"
}else{
    Invoke-Expression -command "& '$checkver' -dir '$dir' $($args | ForEach-Object { "$_ " }) -Update"
}