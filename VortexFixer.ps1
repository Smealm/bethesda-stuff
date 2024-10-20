# Define the maximum number of files to process at a time
$BatchSize = 10000

# Get the current directory
$CurrentDirectory = Get-Location

# Get the name of this script
$ScriptName = [System.IO.Path]::GetFileName($MyInvocation.MyCommand.Path)

# List of specific files to exclude from deletion
$ExcludedFiles = @(
    'ccASVSSE001-ALMSIVI.bsa', 'ccASVSSE001-ALMSIVI.esm',
    'ccBGSSSE001-Fish.bsa', 'ccBGSSSE001-Fish.esm',
    'ccBGSSSE002-ExoticArrows.bsa', 'ccBGSSSE002-ExoticArrows.esl',
    'ccBGSSSE003-Zombies.bsa', 'ccBGSSSE003-Zombies.esl',
    'ccBGSSSE004-RuinsEdge.bsa', 'ccBGSSSE004-RuinsEdge.esl',
    'ccBGSSSE005-Goldbrand.bsa', 'ccBGSSSE005-Goldbrand.esl',
    'ccBGSSSE006-StendarsHammer.bsa', 'ccBGSSSE006-StendarsHammer.esl',
    'ccBGSSSE007-Chrysamere.bsa', 'ccBGSSSE007-Chrysamere.esl',
    'ccBGSSSE008-Wraithguard.bsa', 'ccBGSSSE008-Wraithguard.esl',
    'ccBGSSSE010-PetDwarvenArmoredMudcrab.bsa', 'ccBGSSSE010-PetDwarvenArmoredMudcrab.esl',
    'ccBGSSSE011-HrsArmrElvn.bsa', 'ccBGSSSE011-HrsArmrElvn.esl',
    'ccBGSSSE012-HrsArmrStl.bsa', 'ccBGSSSE012-HrsArmrStl.esl',
    'ccBGSSSE013-Dawnfang.bsa', 'ccBGSSSE013-Dawnfang.esl',
    'ccBGSSSE014-SpellPack01.bsa', 'ccBGSSSE014-SpellPack01.esl',
    'ccBGSSSE016-Umbra.bsa', 'ccBGSSSE016-Umbra.esm',
    'ccBGSSSE018-Shadowrend.bsa', 'ccBGSSSE018-Shadowrend.esl',
    'ccBGSSSE019-StaffofSheogorath.bsa', 'ccBGSSSE019-StaffofSheogorath.esl',
    'ccBGSSSE020-GrayCowl.bsa', 'ccBGSSSE020-GrayCowl.esl',
    'ccBGSSSE021-LordsMail.bsa', 'ccBGSSSE021-LordsMail.esl',
    'ccBGSSSE025-AdvDSGS.bsa', 'ccBGSSSE025-AdvDSGS.esm',
    'ccBGSSSE031-AdvCyrus.bsa', 'ccBGSSSE031-AdvCyrus.esm',
    'ccBGSSSE034-MntUni.bsa', 'ccBGSSSE034-MntUni.esl',
    'ccBGSSSE035-PetNHound.bsa', 'ccBGSSSE035-PetNHound.esl',
    'ccBGSSSE036-PetBWolf.bsa', 'ccBGSSSE036-PetBWolf.esl',
    'ccBGSSSE037-Curios.bsa', 'ccBGSSSE037-Curios.esl',
    'ccBGSSSE038-BowofShadows.bsa', 'ccBGSSSE038-BowofShadows.esl',
    'ccBGSSSE040-AdvObGobs.bsa', 'ccBGSSSE040-AdvObGobs.esl',
    'ccBGSSSE041-NetchLeather.bsa', 'ccBGSSSE041-NetchLeather.esl',
    'ccBGSSSE043-CrossElv.bsa', 'ccBGSSSE043-CrossElv.esl',
    'ccBGSSSE045-Hasedoki.bsa', 'ccBGSSSE045-Hasedoki.esl',
    'ccBGSSSE050-BA_Daedric.bsa', 'ccBGSSSE050-BA_Daedric.esl',
    'ccBGSSSE051-BA_DaedricMail.bsa', 'ccBGSSSE051-BA_DaedricMail.esl',
    'ccBGSSSE052-BA_Iron.bsa', 'ccBGSSSE052-BA_Iron.esl',
    'ccBGSSSE053-BA_Leather.bsa', 'ccBGSSSE053-BA_Leather.esl',
    'ccBGSSSE054-BA_Orcish.bsa', 'ccBGSSSE054-BA_Orcish.esl',
    'ccBGSSSE055-BA_OrcishScaled.bsa', 'ccBGSSSE055-BA_OrcishScaled.esl',
    'ccBGSSSE056-BA_Silver.bsa', 'ccBGSSSE056-BA_Silver.esl',
    'ccBGSSSE057-BA_Stalhrim.bsa', 'ccBGSSSE057-BA_Stalhrim.esl',
    'ccBGSSSE058-BA_Steel.bsa', 'ccBGSSSE058-BA_Steel.esl',
    'ccBGSSSE059-BA_Dragonplate.bsa', 'ccBGSSSE059-BA_Dragonplate.esl',
    'ccBGSSSE060-BA_Dragonscale.bsa', 'ccBGSSSE060-BA_Dragonscale.esl',
    'ccBGSSSE061-BA_Dwarven.bsa', 'ccBGSSSE061-BA_Dwarven.esl',
    'ccBGSSSE062-BA_DwarvenMail.bsa', 'ccBGSSSE062-BA_DwarvenMail.esl',
    'ccBGSSSE063-BA_Ebony.bsa', 'ccBGSSSE063-BA_Ebony.esl',
    'ccBGSSSE064-BA_Elven.bsa', 'ccBGSSSE064-BA_Elven.esl',
    'ccBGSSSE066-Staves.bsa', 'ccBGSSSE066-Staves.esl',
    'ccBGSSSE067-DaedInv.bsa', 'ccBGSSSE067-DaedInv.esm',
    'ccBGSSSE068-Bloodfall.bsa', 'ccBGSSSE068-Bloodfall.esl',
    'ccBGSSSE069-Contest.bsa', 'ccBGSSSE069-Contest.esl',
    'ccCBHSSE001-Gaunt.bsa', 'ccCBHSSE001-Gaunt.esl',
    'ccEDHSSE001-NorJewel.bsa', 'ccEDHSSE001-NorJewel.esl',
    'ccEDHSSE002-SplKntSet.bsa', 'ccEDHSSE002-SplKntSet.esl',
    'ccEDHSSE003-Redguard.bsa', 'ccEDHSSE003-Redguard.esl',
    'ccEEJSSE001-Hstead.bsa', 'ccEEJSSE001-Hstead.esm',
    'ccEEJSSE002-Tower.bsa', 'ccEEJSSE002-Tower.esl',
    'ccEEJSSE003-Hollow.bsa', 'ccEEJSSE003-Hollow.esl',
    'ccEEJSSE004-Hall.bsa', 'ccEEJSSE004-Hall.esl',
    'ccEEJSSE005-Cave.bsa', 'ccEEJSSE005-Cave.esm',
    'ccFFBSSE001-ImperialDragon.bsa', 'ccFFBSSE001-ImperialDragon.esl',
    'ccFFBSSE002-CrossbowPack.bsa', 'ccFFBSSE002-CrossbowPack.esl',
    'ccFSVSSE001-Backpacks.bsa', 'ccFSVSSE001-Backpacks.esl',
    'ccKRTSSE001_Altar.bsa', 'ccKRTSSE001_Altar.esl',
    'ccMTYSSE001-KnightsOfTheNine.bsa', 'ccMTYSSE001-KnightsOfTheNine.esl',
    'ccMTYSSE002-VE.bsa', 'ccMTYSSE002-VE.esl',
    'ccPEWSSE002-ArmsOfChaos.bsa', 'ccPEWSSE002-ArmsOfChaos.esl',
    'ccQDRSSE001-SurvivalMode.bsa', 'ccQDRSSE001-SurvivalMode.esl',
    'ccQDRSSE002-Firewood.bsa', 'ccQDRSSE002-Firewood.esl',
    'ccRMSSSE001-NecroHouse.bsa', 'ccRMSSSE001-NecroHouse.esl',
    'ccTWBSSE001-PuzzleDungeon.bsa', 'ccTWBSSE001-PuzzleDungeon.esm',
    'ccVSVSSE001-Winter.bsa', 'ccVSVSSE001-Winter.esl',
    'ccVSVSSE002-Pets.bsa', 'ccVSVSSE002-Pets.esl',
    'ccVSVSSE003-NecroArts.bsa', 'ccVSVSSE003-NecroArts.esl',
    'ccVSVSSE004-BeAFarmer.bsa', 'ccVSVSSE004-BeAFarmer.esl',
    'Dawnguard.esm', 'Dragonborn.esm',
    'HearthFires.esm', 'MarketplaceTextures.bsa',
    'Skyrim - Animations.bsa', 'Skyrim - Interface.bsa',
    'Skyrim - Meshes0.bsa', 'Skyrim - Meshes1.bsa',
    'Skyrim - Misc.bsa', 'Skyrim - Shaders.bsa',
    'Skyrim - Sounds.bsa', 'Skyrim - Textures0.bsa',
    'Skyrim - Textures1.bsa', 'Skyrim - Textures2.bsa',
    'Skyrim - Textures3.bsa', 'Skyrim - Textures4.bsa',
    'Skyrim - Textures5.bsa', 'Skyrim - Textures6.bsa',
    'Skyrim - Textures7.bsa', 'Skyrim - Textures8.bsa',
    'Skyrim - Voices_de0.bsa', 'Skyrim - Voices_en0.bsa',
    'Skyrim - Voices_es0.bsa', 'Skyrim - Voices_fr0.bsa',
    'Skyrim - Voices_it0.bsa', 'skyrim - voices_ja0.bsa',
    'Skyrim - Voices_pl0.bsa', 'Skyrim - Voices_ru0.bsa',
    'Skyrim.esm', 'Update.esm',
    '_ResourcePack.bsa', '_ResourcePack.esl',
    'ccAFDSSE001-DweSanctuary.bsa', 'ccAFDSSE001-DweSanctuary.esm',
    'BGS_Logo.bik', 'VortexFixer.ps1',
    'vortex.deployment.json'
)

# Loop through all files in the directory
Get-ChildItem -Path $CurrentDirectory -File -Recurse | Where-Object {
    # Exclude files ending with 'vortex_backup'
    $_.Name -notlike "*vortex_backup*" -and
    # Exclude specified files
    $ExcludedFiles -notcontains $_.Name -and
    # Exclude hard links
    $_.LinkType -ne 'HardLink'
} | ForEach-Object -Process {
    # Deleting files
    Write-Host "Deleting file: $($_.FullName)"
    Remove-Item -Path $_.FullName -Force
}
