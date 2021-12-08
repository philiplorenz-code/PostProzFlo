[CmdletBinding()]
Param(
    $SystemPath,      # the value can be set in PYTHA Interface Setup
    $SystemCommand,   # the value can be set in PYTHA Interface Setup
    $SystemProfile,   # the value can be set in PYTHA Interface Setup
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]$Program
)
############################################################################

$XConverter = "C:\Program Files (x86)\SCM Group\Maestro\XConverter.exe"
$Tooling = "C:\Program Files (x86)\SCM Group\Maestro\Tlgx\def.tlgx"






$count = 0
$inFiles = @()
$tmpFiles = @()
$outFiles = @()

function convert-xcs-to-pgmx{
    Write-Output "Converting" $inFiles to $outFiles
    # Konvertieren in tmp pgmx
    & $XConverter -ow -s -report -m 0  -i $inFiles -t $Tooling -o $tmpFiles | Out-Default

    # Sauger positionieren
    & $XConverter -ow -s -m 13  -i $tmpFiles -t $Tooling -o $outFiles | Out-Default

    # Loesche die temporaeren Dateien
    Remove-Item $tmpFiles  
}

foreach ($Prog in $input)  {
    if ($count -ge 200) { 
        # Die Kommandozeile darf nicht laenger als 8000 Zeichen werden      

        convert-xcs-to-pgmx

        $count = 0
        $inFiles = ""
        $tmpFiles = ""
        $outFiles = ""
    }

    $xcsPath = $Prog.CamPath
    $pgmxPath = $xcsPath -replace '.xcs$', '.pgmx'
    $tmpPath = $xcsPath -replace '.xcs$', '__tmp.pgmx'
    
        
    $count += 1
    $inFiles += $xcsPath
    $outFiles += $pgmxPath
    $tmpFiles += $tmpPath
}

convert-xcs-to-pgmx

Start-Sleep 1