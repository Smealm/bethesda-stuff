# Define a function to convert the JSON input to the desired output format
function Convert-ConflictRules {
    param (
        [string]$jsonFilePath
    )

    # Attempt to read JSON from the specified file
    try {
        $jsonInput = Get-Content -Path $jsonFilePath -Raw -ErrorAction Stop
    } catch {
        Write-Host "Error reading the JSON file: $_" -ForegroundColor Red
        return
    }

    # Attempt to convert JSON to PowerShell object
    try {
        $jsonObject = $jsonInput | ConvertFrom-Json -ErrorAction Stop
    } catch {
        Write-Host "Error converting JSON to PowerShell object: $_" -ForegroundColor Red
        return
    }

    # Initialize an array to store the output
    $output = @()

    # Check if the info property exists and format it
    if ($jsonObject.info) {
        $info = $jsonObject.info
        $gameVersion = ($info.gameVersions -join ", ")  # Join versions if multiple
        $infoLine = "`"$($info.name)`" was made by $($info.author) for `"$($info.domainName)`" version $gameVersion"
        $output += "$infoLine`n`n"  # Add the info line with spacing
    } else {
        Write-Host "No 'info' section found in the JSON." -ForegroundColor Yellow
    }

    # Add distinction line
    $output += "----------------------------------------------------------------------------`n`n"

    # Get the name for the mods section header
    $modName = $jsonObject.info.name

    # Add header for mods section
    $output += "The following mods are included in `"$modName`":`n`n"

    # Check if the mods property exists
    if ($jsonObject.mods) {
        $modCount = 1  # Initialize a counter for numbering the mods
        foreach ($mod in $jsonObject.mods) {
            # Check if the mod has a name and output it
            if ($mod.name) {
                $output += "$modCount. $($mod.name)`n"  # Add mod name to output
                $modCount++  # Increment the counter
            }
        }
        $output += "`n"  # Add extra spacing after mods
    } else {
        Write-Host "No 'mods' section found in the JSON." -ForegroundColor Yellow
    }

    # Add distinction line for mod rules
    $output += "----------------------------------------------------------------------------`n`n"

    # Get the name for the mod rules section header
    $rulesName = $jsonObject.info.name

    # Add header for mod rules section
    $output += "The following conflicts are resolved in `"$rulesName`":`n`n"

    # Check if the modRules property exists
    if (-not $jsonObject.modRules) {
        Write-Host "No 'modRules' found in the JSON. Exiting." -ForegroundColor Red
        return
    }

    $count = 1  # Initialize a counter for numbering the Load commands

    foreach ($rule in $jsonObject.modRules) {
        # Check if the rule has the correct structure
        if ($rule.PSObject.Properties["type"] -and 
            $rule.PSObject.Properties["reference"] -and 
            $rule.PSObject.Properties["source"]) {
            
            # Determine the action (before or after)
            $action = $rule.type
            # Get the relevant file expressions
            $referenceFile = $rule.reference.fileExpression
            $sourceFile = $rule.source.fileExpression

            # Construct the output line with swapped references
            if ($action -eq "before") {
                $outputLine = "Load `"$sourceFile`" before `"$referenceFile`""
            } elseif ($action -eq "after") {
                $outputLine = "Load `"$sourceFile`" after `"$referenceFile`""
            }

            # Prepend the count number and format the output
            $output += "$count. $outputLine`n`n"  # Added spacing
            $count++  # Increment the counter
        } else {
            Write-Host "Skipping invalid rule: $rule" -ForegroundColor Yellow
        }
    }

    # Return the output array, joined into a single string
    return $output -join "`n"  # Remove additional newline at the end
}

# Prompt the user for the JSON file path
$jsonFilePath = Read-Host -Prompt "Please enter the path to your JSON file"

# Check if the file exists
if (Test-Path -Path $jsonFilePath) {
    # Call the function and get the result
    $result = Convert-ConflictRules -jsonFilePath $jsonFilePath

    # Create the new file path using the 'name' from 'info'
    try {
        # Extract the name for the output file from the JSON
        $jsonInput = Get-Content -Path $jsonFilePath -Raw
        $jsonObject = $jsonInput | ConvertFrom-Json
        $outputFileName = $jsonObject.info.name  # Get the name for the filename
    } catch {
        Write-Host "Error retrieving the 'name' property from the JSON: $_" -ForegroundColor Red
        return
    }

    # Create new filename with _LOAD-ORDER appended
    $directory = Split-Path -Path $jsonFilePath
    $newFileName = "${outputFileName}_LOAD-ORDER.txt"  # Change extension to .txt
    $newFilePath = Join-Path -Path $directory -ChildPath $newFileName

    # Write the result to the new TXT file
    if ($result) {
        try {
            $result | Out-File -FilePath $newFilePath -Encoding utf8 -Force -ErrorAction Stop
            Write-Host "The output has been written to: $newFilePath" -ForegroundColor Green
        } catch {
            Write-Host "Error writing the output file: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "No valid conflict rules found to process." -ForegroundColor Yellow
    }
} else {
    Write-Host "The specified file does not exist. Please check the path and try again." -ForegroundColor Red
}
