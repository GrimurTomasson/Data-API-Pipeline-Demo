Write-Host "`nLoading environment variables" # Without the write operations, we get out of order errors when running the script remotely!
.\load_env.ps1
Write-Host "`nActivating Python virtual environment"
.\pyEnv\Scripts\activate
Write-Host "`nMigrating change-sets"
.\database.bat migrate
CD ExtractionLoad
Write-Host "`nLoading Thjonustukortagogn"
python .\Byggdastofnun_thjonustukortagogn.py
Write-Host "`nLoading Stadfangaskra"
python .\Hus_og_mannvirkjastofnun_stadfangaskra.py
CD ..
Write-Host "`nRunning DAPI"
dapi build
Write-Host "`nAll done!"
