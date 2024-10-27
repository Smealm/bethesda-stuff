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

            # Construct the output line based on the action
            if ($action -eq "before") {
                $outputLine = "Load `"$referenceFile`" before `"$sourceFile`""
            } elseif ($action -eq "after") {
                $outputLine = "Load `"$referenceFile`" after `"$sourceFile`""
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

    # Create the new file path with _LOAD-ORDER appended
    $directory = Split-Path -Path $jsonFilePath
    $filenameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($jsonFilePath)
    $newFileName = "${filenameWithoutExtension}_LOAD-ORDER.txt"  # Change extension to .txt
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
