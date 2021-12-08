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


function Add-StringBefore {
  param(
    [array]$insert,
    [string]$keyword,
    # in $textfile muss eigentlich immer $Prog.CamPath übergeben werden
    [string]$textfile
  )
  Write-Host "Das ist der insert: $insert"
  Write-Host "Das ist das keyword: $keyword"
  Write-Host "Das ist der PFad: $textfile"

  $content = Get-Content $textfile

  Write-Host "Das ist der aktuelle inhalt: $content"
  $counter = 0
  $keywordcomplete = ""
  foreach ($string in $content) {

    if ($string -like "*$keyword*") {
      $keywordcomplete = $string

      $content[$counter] = ""
      for ($i = 0; $i -lt $insert.Count; $i++) {
        $content[$counter] = $content[$counter] + $insert[$i] + "`n"
      }

      $content[$counter] = $content[$counter] + $keywordcomplete + "`n"
      

    }
    $counter++
  }


  $content | Out-File $textfile



}

function Initial-Replace([string]$Filename){

  $Content = Get-Content $Filename

  if ($Filename -like "*MA_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_MA_1", "PYTHA_MA");')
    $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",10.0000,10.0000,3.0000,3.0000,0.0000,0.0000);')
    $Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(10, 3.0000, 0.0, 0.0);')
  }
  elseif ($Filename -like "*MA_2*"){
  }
  elseif ($Filename -like "*FUF_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_FUF_1", "PYTHA_FUF");')
    $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateMacro("CreateRawWorkpiece("SeiteL_19.0",3.0000,3.0000,3.0000,3.0000,0.0000,0.0000);')
    $Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(3, 3.0000, 0.0, 0.0);')

  }
  elseif ($Filename -like "*FUF_2*"){
  }
  elseif ($Filename -like "*FUS_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_FUS_1", "PYTHA_FUS");')
    $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",1.5000, 1.5000, 1.5000, 1.5000,0.0000,0.0000);')
    $Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(1.5, 1.5000, 0.0, 0.0);')
  }
  elseif ($Filename -like "*FUS_2*"){
  }

  elseif ($Filename -like "*KUB_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_KUB_1", "PYTHA_KUB");')
    $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",3.0000,3.0000,3.0000,3.0000,0.0000,0.0000);')
    $Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(3, 3.0000, 0.0, 0.0);')
  }

  elseif ($Filename -like "*KUB_2*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_KUB_1", "PYTHA_KUB");')
    $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",3.0000,3.0000,3.0000,3.0000,0.0000,0.0000);')
    $Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(3, 3.0000, 0.0, 0.0);')
  }

  elseif ($Filename -like "*VW_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_VW_1", "PYTHA_VW");')
    $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",5.0000,5.0000,5.0000,5.0000,0.0000,0.0000);')
    $Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(5, 5.0000, 0.0, 0.0);')
  }

  elseif ($Filename -like "*VW_2*"){
  }

  else {
    Write-Output "Für diesen Dateinamen ist keine Aktion definiert!"
  }


  Set-Content -Path $Filename -Value $Content
}

function Replace-CreateBladeCut([string]$Filename){

  # Add Lines Before
  $Array = @()
  $Array += 'SetApproachStrategy(true, true, 0.8);'
  $Array += 'SetRetractStrategy(true, true, 0.8, 0);'
  $Array += 'SetApproachStrategy(true, true, 0.8);'
  Add-StringBefore -insert $Array -$keyword 'CreateBladeCut("SlantedBladeCut1", "", TypeOfProcess.GeneralRouting, "E041", "-1", 78.1113, 2);' -textfile $Filename

  # Replace Line
  $Content = Get-Content $Filename
  $Content.Replace(
    'CreateBladeCut("SlantedBladeCut1", "", TypeOfProcess.GeneralRouting, "E041", "-1", 78.1113, 2);',
    'CreateBladeCut("SlantedBladeCut1", "", TypeOfProcess.GeneralRouting, "E041", "-1", 78.1113, 2, -1, -1, -1, 0, true, true, 0, 10);'
  )
  Set-Content -Path $Filename -Value $Content
}

function Replace-CreateSlot([string]$Filename){
  $Content = Get-Content -Path $Filename
  $Output = @()
  foreach ($string in $content) {
    if ($string -like "*CreateSlot*") {
      $string = $string.Replace("-1","6")
    }
    $output += $string
  }
  
  Set-Content -Path $Filename -Value $Output
}

function Replace-CreateContourPocket([string]$Filename){
  # Add Lines Before
  $Array = @()
  $Array += 'SetApproachStrategy(true, false, 2);'
  $Array += 'CreateContourParallelStrategy(true, 0, true, 7, 0, 0);'
  Add-StringBefore -insert $Array -$keyword 'CreateContourPocket("", 12.0000, "", TypeOfProcess.ConcentricalPocket, "E010");' -textfile $Filename
}

function Replace-SetMacroParam([string]$Filename){
  $charCount = ($Filename.ToCharArray() | Where-Object {$_ -eq '_'} | Measure-Object).Count
  if($charCount -gt 3){
    $Elements = $Filename.split('_')
    $MM = $Elements[3]

    $content = Get-Content $Filename
    foreach ($string in $content) {
      if ($string -like "*SetMacroParam*") {
        $LastSetMacro = $string
      }
    }

    $NewValue = @()
    $NewValue += $LastSetMacro
    $NewValue += 'SetMacroParam("Depth", ' + $MM + ');'
  
    $content -replace $LastSetMacro,$NewValue

    Set-Content -Path $Filename -Value $content
    
  }
}

function Replace-CreateRoughFinish([string]$Filename){
  # Add Lines Before
  $Array = @()
  $Array += 'CreateHelicMillingStrategy(9, true, 0);'
  Add-StringBefore -insert $Array -$keyword 'CreateRoughFinish("",22.0000,"",TypeOfProcess.GeneralRouting, "E010", "-1", 2);' -textfile $Filename
  Add-StringBefore -insert $Array -$keyword 'CreateRoughFinish("",1.5000,"",TypeOfProcess.GeneralRouting, "E031", "-1", 0);' -textfile $Filename
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


    $XCS = $Prog.CamPath

    Initial-Replace -Filename $XCS
    Replace-CreateBladeCut -Filename $XCS
    Replace-CreateSlot -Filename $XCS
    Replace-CreateContourPocket -Filename $XCS
    Replace-CreateRoughFinish -Filename $XCS
    Replace-SetMacroParam -Filename $XCS
    


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






















