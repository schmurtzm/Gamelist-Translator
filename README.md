# Gamelist-Translator By Schmurtz


Translate games descriptions in gamelist.xml from EmulationStation (thanks to a powershell script and Google Translate).


Usage example : run a powershell cmd then type :
```powershell
Gamelist-Translator.ps1 "c:\RetroBat\roms\ports\gamelist.xml"
```
------
#Version history :

V1.0 - 2022-04-20 - initial version
- You can change the target language inside the script.
- Create backup of the original gamelist.xml before modification (the backup will be named gamelist-yyyy-MM-dd_HHmmss.xml)
- Should support accents / UTF8 in the right way.
