# Gamelist-Translator By Schmurtz
# V1.0 - 2022-04-20

# Translate games descriptions in gamelist.xml from EmulationStation (thanks to a powershell script and Google Translate).
# https://github.com/schmurtzm/Gamelist-Translator

# usage : run a powershell cmd then type :
# Gamelist-Translator.ps1 "c:\RetroBat\roms\ports\gamelist.xml"


if($args.Count -eq 0) {
     
    write-host  No parameters.`n Command example : Gamelist-Translator.ps1 "c:\RetroBat\roms\ports\gamelist.xml"
    return
}



$TargetLanguage = “fr”


# Read the existing file properties
$file_Fullpath = $args[0]
$file_path = (Get-Item $args[0]).DirectoryName
$file_baseName = (Get-Item $args[0] ).Basename 


# We make a dated backup of the original gamelist.xml
$ts = $(get-date -f yyyy-MM-dd_HHmmss)
$fn = -join($file_baseName , '_', $ts, '.xml')
write-host Creating backup file : $file_path\$fn
copy-Item -Path $file_Fullpath -Destination $file_path\$fn


pause

# Get-Content doesn't manage UTF8 accent in the right way...
#[xml]$xmlDoc = Get-Content -Path $file_Fullpath

[xml]$xmlDoc = ( Select-Xml -Path $file_Fullpath  -XPath / ).Node


# foreach game, we get the description and translate it

foreach ($element in $xmlDoc.gameList.game)
{
    # display current game name
    write-host `n------------ $element.name   ------------`n
    # display current game description
    write-host $element.desc

    # Translation thanks to Google Translate API
    $Text = $element.desc
    $Uri = “https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$($TargetLanguage)&dt=t&q=$Text”
    $Response = Invoke-RestMethod -Uri $Uri -Method Get
    $RawResponse = (Invoke-WebRequest -Uri $Uri -Method Get).Content

    $Translation = $Response[0].SyncRoot | foreach { $_[0] }

    # we display the translation result
    write-host ************ Translation ************
    write-host $Translation

    # we replace the description for the current game
    $element.desc = "$Translation"
}
    
# Then we save that back to the xml file

$xmlDoc.Save($file_Fullpath)





