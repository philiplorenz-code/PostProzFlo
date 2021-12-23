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
function Search-Array(){
  param(
      [array]$text,
      [string]$searchkey
  )

  $searchkey = "*" + $searchkey + "*"
  foreach ($line in $text){
      if ($line -like $searchkey){
          #return $line
          return $line
      }
  }
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

  if ($Filename -like "*MA*_1*" -or $Filename -like "*MA_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_MA_1", "PYTHA_MA");')
    #$Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",10.0000,10.0000,3.0000,3.0000,0.0000,0.0000);')
    
    # Custom Replace
    $2replace = Search-Array -text $Content -searchkey 'CreateRawWorkpiece(*,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);'
    $splitting = $2replace.Split(",")
    $splitting[1] = '10.0000'
    $splitting[2] = '10.0000'
    $splitting[3] = '3.0000'
    $splitting[4] = '3.0000'
    $replacant = [system.String]::Join(",", $splitting)
    $Content = $Content.replace($2replace,$replacant)
 
    $Content = $Content.replace('SetWorkpieceSetupPosition(0.0000, 0.0000, 0.0000, 0.0000);','SetWorkpieceSetupPosition(10.0000, 3.0000, 0.0000, 0.0000);')

  }
  elseif ($Filename -like "*MA*_2*"){
  }
  elseif ($Filename -like "*FUF*_1*" -or $Filename -like "*FUF_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_FUF_1", "PYTHA_FUF");')
    #$Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",3.0000,3.0000,3.0000,3.0000,0.0000,0.0000);')
    
    # Custom Replace
    $2replace = Search-Array -text $Content -searchkey 'CreateRawWorkpiece(*,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);'
    $splitting = $2replace.Split(",")
    $splitting[1] = '3.0000'
    $splitting[2] = '3.0000'
    $splitting[3] = '3.0000'
    $splitting[4] = '3.0000'
    $replacant = [system.String]::Join(",", $splitting)
    $Content = $Content.replace($2replace,$replacant)
    
    $Content = $Content.replace('SetWorkpieceSetupPosition(0.0000, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(3.0000, 3.0000, 0.0, 0.0);')
  }
  elseif ($Filename -like "*FUF*_2*"){
  }
  elseif ($Filename -like "*FUS*_1*" -or $Filename -like "*FUS_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_FUS_1", "PYTHA_FUS");')
    # $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",1.5000, 1.5000, 1.5000, 1.5000,0.0000,0.0000);')

    # Custom Replace
    $2replace = Search-Array -text $Content -searchkey 'CreateRawWorkpiece(*,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);'
    $splitting = $2replace.Split(",")
    $splitting[1] = '1.5000'
    $splitting[2] = '1.5000'
    $splitting[3] = '1.5000'
    $splitting[4] = '1.5000'
    $replacant = [system.String]::Join(",", $splitting)
    $Content = $Content.replace($2replace,$replacant)

    $Content = $Content.replace('SetWorkpieceSetupPosition(0.0000, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(1.5, 1.5000, 0.0, 0.0);')
  }
  elseif ($Filename -like "*FUS*_2*"){
  }

  elseif ($Filename -like "*KUB*_1*" -or $Filename -like "*KUB_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_KUB_1", "PYTHA_KUB");')
    
    # Custom Replace
    $2replace = Search-Array -text $Content -searchkey 'CreateRawWorkpiece(*,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);'
    $splitting = $2replace.Split(",")
    $splitting[1] = '3.0000'
    $splitting[2] = '3.0000'
    $splitting[3] = '3.0000'
    $splitting[4] = '3.0000'
    $replacant = [system.String]::Join(",", $splitting)
    $Content = $Content.replace($2replace,$replacant)

    $Content = $Content.replace('SetWorkpieceSetupPosition(0.0000, 0.0000, 0.0000, 0.0000);','SetWorkpieceSetupPosition(3.0000, 3.0000, 0.0000, 0.0000);')
  }

  elseif ($Filename -like "*KUB*_2*"){
    #$Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_KUB_1", "PYTHA_KUB");')
    #$Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",3.0000,3.0000,3.0000,3.0000,0.0000,0.0000);')
    #$Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(3, 3.0000, 0.0, 0.0);')
    # "SeiteL_19.0" -> kann sich ändern
  }

  elseif ($Filename -like "*VW*_1*" -or $Filename -like "*VW_1*"){
    $Content = $Content.replace('CreateMacro("PYTHA_INIT_1", "PYTHA_INIT");','CreateMacro("PYTHA_VW_1", "PYTHA_VW");')
    
    $Content = $Content.replace('CreateRawWorkpiece("SeiteL_19.0",0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);','CreateRawWorkpiece("SeiteL_19.0",5.0000,5.0000,5.0000,5.0000,0.0000,0.0000);')
    # Custom Replace
    $2replace = Search-Array -text $Content -searchkey 'CreateRawWorkpiece(*,0.0000,0.0000,0.0000,0.0000,0.0000,0.0000);'
    $splitting = $2replace.Split(",")
    $splitting[1] = '5.0000'
    $splitting[2] = '5.0000'
    $splitting[3] = '5.0000'
    $splitting[4] = '5.0000'
    $replacant = [system.String]::Join(",", $splitting)
    $Content = $Content.replace($2replace,$replacant)

    $Content = $Content.replace('SetWorkpieceSetupPosition(0, 0.0000, 0.0, 0.0);','SetWorkpieceSetupPosition(5, 5.0000, 0.0, 0.0);')
  }

  elseif ($Filename -like "*VW*_2*"){
  }

  else {
    Write-Output "Für diesen Dateinamen ist keine Aktion definiert!"
  }


  Set-Content -Path $Filename -Value $Content
}

function Replace-CreateBladeCut([string]$Filename){
  $Content = Get-Content $Filename

  # Add Lines Before
  $Array = @()
  $Array += 'SetApproachStrategy(true, true, 0.8);'
  $Array += 'SetRetractStrategy(true, true, 0.8, 0);'
  $Array += 'CreateSectioningMillingStrategy(3, 150, 0);'

  $KeyWord = Search-Array -text $Content -searchkey 'CreateBladeCut("SlantedBladeCut1", "", TypeOfProcess.GeneralRouting,*, "-1",*, 2);'
  if($KeyWord){
    Add-StringBefore -insert $Array -keyword $KeyWord -textfile $Filename
  }

  # 78.1113 kann sich ändern

  # Replace Line
  $Content = Get-Content $Filename
  $2replace = Search-Array -text $Content -searchkey 'CreateBladeCut("SlantedBladeCut1", "", TypeOfProcess.GeneralRouting,*, "-1",*, 2);'
  if ($2replace){
    $replacant = ($2replace.Replace(");","")) + ", -1, -1, -1, 0, true, true, 0, 10);"
    $Content = $Content.Replace($2replace,$replacant)
  }
  #$replacant = 'CreateBladeCut("SlantedBladeCut1", "", TypeOfProcess.GeneralRouting, "E041", "-1", 78.1113, 2, -1, -1, -1, 0, true, true, 0, 10);'
  # 78.1113 kann sich ändern
  
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
  $Content = Get-Content $Filename
  
  # Add Lines Before
  $Array = @()
  $Array += 'SetApproachStrategy(true, false, 2);'
  $Array += 'CreateContourParallelStrategy(true, 0, true, 7, 0, 0);'
  
  $KeyWord = Search-Array -text $Content -searchkey 'CreateContourPocket("",*, "", TypeOfProcess.ConcentricalPocket,*);'

  If($KeyWord){
    Add-StringBefore -insert $Array -keyword $KeyWord -textfile $Filename
  }

  #Add-StringBefore -insert $Array -keyword 'CreateContourPocket("", 12.0000, "", TypeOfProcess.ConcentricalPocket, "E010");' -textfile $Filename
  # "E010" und 12.0000 kann anders sein
}

function Replace-SetMacroParam([string]$Filename){
  $charCount = ($Filename.ToCharArray() | Where-Object {$_ -eq '_'} | Measure-Object).Count
  if($charCount -gt 3){
    $Filename = Split-Path $Filename -leaf
    $Elements = $Filename.split('_')
    
    $Desk = ([Environment]::GetFolderPath("Desktop")+"\a.txt")
    $Elements | ConvertTo-Json | Out-File -Path $Desk
    
    $MM = $Elements[3]
    
    $Desk = ([Environment]::GetFolderPath("Desktop")+"\b.txt")
    $MM | ConvertTo-Json | Out-File -Path $Desk
    
    Get-Process | ConvertTo-Json | Out-File
    
    $Elements | ConvertTo-Json 

    $content = Get-Content $Filename
    $output = @()
    foreach ($string in $content) {
      $output += $string
      if ($string -like "*SetMacroParam*Angle*") {
        $output += 'SetMacroParam("Depth", ' + $MM + ');'
      }

    }

    Set-Content -Path $Filename -Value $output
    
  }
}

function Replace-CreateRoughFinish([string]$Filename){
  $Content = Get-Content $Filename
  # Add Lines Before
  $Array = @()
  $Array += 'CreateHelicMillingStrategy(9, true, 0);'

  $KeyWord = Search-Array -text $Content -searchkey 'CreateRoughFinish("",*,"",TypeOfProcess.GeneralRouting,*, "-1", 2);'
  if ($KeyWord){
    Add-StringBefore -insert $Array -keyword $KeyWord -textfile $Filename
  }
  

  $KeyWord = Search-Array -text $Content -searchkey 'CreateRoughFinish("",*,"",TypeOfProcess.GeneralRouting,*, "-1", 0);'
  if ($KeyWord){
    Add-StringBefore -insert $Array -keyword $KeyWord -textfile $Filename
  }

  #Add-StringBefore -insert $Array -keyword 'CreateRoughFinish("",22.0000,"",TypeOfProcess.GeneralRouting, "E010", "-1", 2);' -textfile $Filename
  #Add-StringBefore -insert $Array -keyword 'CreateRoughFinish("",1.5000,"",TypeOfProcess.GeneralRouting, "E031", "-1", 0);' -textfile $Filename
  # kann sich aendern: 22.0000,E010 und 1.5000,E031
  # hier war im Bsp schon Helic gesetzt -> wird deshalb doppelt geschrieben
}


$i = 0
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

<#
    try {
      Initial-Replace -Filename $XCS
    }
    catch {
      Write-Error "Error in Initial-Replace in run $i"
      throw $Error
    }

    try {
      Replace-CreateBladeCut -Filename $XCS
    }
    catch {
      Write-Error "Error in Replace-CreateBladeCut in run $i"
      throw $Error
    }

    try {
      Replace-CreateSlot -Filename $XCS
    }
    catch {
      Write-Error "Error in Replace-CreateSlot in run $i"
      throw $Error
    }

    try {
      Replace-CreateContourPocket -Filename $XCS
    }
    catch {
      Write-Error "Replace-CreateContourPocket in run $i"
      throw $Error
    }

    try {
      Replace-CreateRoughFinish -Filename $XCS
    }
    catch {
      Write-Error "Error in Replace-CreateRoughFinish in run $i"
      throw $Error
    }

    try {
      Replace-SetMacroParam -Filename $XCS
    }
    catch {
      Write-Error "Error in Replace-SetMacroParam in run $i"
      throw $Error
    }
 #>
 
 

    $xcsPath = $Prog.CamPath
    $pgmxPath = $xcsPath -replace '.xcs$', '.pgmx'
    $tmpPath = $xcsPath -replace '.xcs$', '__tmp.pgmx'
    
        
    $count += 1
    $inFiles += $xcsPath
    $outFiles += $pgmxPath
    $tmpFiles += $tmpPath

    $i++
}


convert-xcs-to-pgmx

Start-Sleep 1






















