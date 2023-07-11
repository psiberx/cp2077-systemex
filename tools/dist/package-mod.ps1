param ($ProjectName = "SystemEx")

$StageDir = "build/package"
$DistDir = "build/dist"
$Version = & $($PSScriptRoot + "\steps\get-version.ps1")

& $($PSScriptRoot + "\steps\compose-redscripts.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName} -Version ${Version}
& $($PSScriptRoot + "\steps\compose-hints.ps1") -StageDir ${StageDir}
& $($PSScriptRoot + "\steps\create-zip-from-stage.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName} -DistDir ${DistDir} -Version ${Version}

Remove-Item -Recurse ${StageDir}
