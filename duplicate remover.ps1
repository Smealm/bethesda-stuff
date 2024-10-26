# Prompt user for folder paths
$ReferenceFolder = Read-Host -Prompt "Enter the path to the folder with the reference files (e.g., FOLDER_TO_BE_SCANNED)"
$TargetFolder = Read-Host -Prompt "Enter the path to the folder where files will be deleted (e.g., THE_OTHER_FOLDER)"

# Check if the Reference Folder and Target Folder are the same
if ($ReferenceFolder -eq $TargetFolder) {
    Write-Output "Error: The Reference Folder and Target Folder are the same. Operation stopped to prevent accidental deletion."
    exit
}

# Validate folder paths
if (!(Test-Path -Path $ReferenceFolder -PathType Container)) {
    Write-Output "Reference folder path is invalid. Please check the path and try again."
    exit
}

if (!(Test-Path -Path $TargetFolder -PathType Container)) {
    Write-Output "Target folder path is invalid. Please check the path and try again."
    exit
}

# Get all files in the Reference Folder
$ReferenceFiles = Get-ChildItem -Path $ReferenceFolder -Recurse -File
$totalFiles = $ReferenceFiles.Count
$currentFile = 0

foreach ($file in $ReferenceFiles) {
    # Update progress bar
    $currentFile++
    $percentComplete = [math]::Round(($currentFile / $totalFiles) * 100)
    Write-Progress -Activity "Deleting files from Target Folder" `
                   -Status "$percentComplete% Complete" `
                   -PercentComplete $percentComplete

    # Get the relative path of the file in the Reference Folder
    $relativePath = $file.FullName.Substring($ReferenceFolder.Length + 1)

    # Construct the corresponding file path in the Target Folder
    $targetFilePath = Join-Path -Path $TargetFolder -ChildPath $relativePath

    # Check if the file exists in the Target Folder
    if (Test-Path -Path $targetFilePath) {
        Remove-Item -Path $targetFilePath -Force
    }
}

Write-Output "File deletion complete!"

# Function to remove empty directories with progress bar
function Remove-EmptyDirectories {
    param (
        [string]$folder
    )
    
    # Get all directories in the folder recursively
    $directories = Get-ChildItem -Path $folder -Recurse -Directory
    $totalDirs = $directories.Count
    $currentDir = 0
    $removedAny = $false

    foreach ($dir in $directories) {
        # Update progress bar
        $currentDir++
        $percentComplete = [math]::Round(($currentDir / $totalDirs) * 100)
        Write-Progress -Activity "Deleting empty folders" `
                       -Status "$percentComplete% Complete" `
                       -PercentComplete $percentComplete

        # Check if the directory is empty
        if (!(Get-ChildItem -Path $dir.FullName -Recurse)) {
            # Remove the empty directory
            Remove-Item -Path $dir.FullName -Force -Recurse
            Write-Output "Deleted empty folder: $($dir.FullName)"
            $removedAny = $true
        }
    }

    return $removedAny
}

# Repeat empty directory deletion until no more empty directories are found
do {
    $removedAny = Remove-EmptyDirectories -folder $TargetFolder
} while ($removedAny)

Write-Output "Empty folder deletion complete!"
Write-Output "Done!"
