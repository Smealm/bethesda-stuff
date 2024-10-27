# Prompt the user for the input file path
$inputFilePath = Read-Host -Prompt "Enter the path to the input text file"

# Check if the file exists
if (-Not (Test-Path $inputFilePath)) {
    Write-Host "The specified file does not exist. Please check the path and try again."
    exit
}

# Extract the directory and file name without extension
$directory = Split-Path $inputFilePath -Parent
$fileName = Split-Path $inputFilePath -LeafBase

# Create the output file path by appending '_FIXED' to the original file name
$outputFilePath = Join-Path -Path $directory -ChildPath ("{0}_FIXED.txt" -f $fileName)

# Initialize an empty array to store the processed lines
$processedLines = @()

# Read the input file line by line
Get-Content $inputFilePath | ForEach-Object {
    # Trim the line to remove leading/trailing whitespace
    $line = $_.Trim()

    # Split the line into parts using spaces
    $parts = $line -split '\s+'

    # Check if there are at least 3 parts
    if ($parts.Count -ge 3) {
        # Keep the second string (index 1) and ignore everything after the second space
        $processedLines += $parts[1]
    }
}

# Check if any lines were processed
if ($processedLines.Count -gt 0) {
    # Write the processed lines to the new output file
    $processedLines | Set-Content -Path $outputFilePath -Encoding utf8
    Write-Host "Processing complete. The output has been saved to $outputFilePath."
} else {
    Write-Host "No valid lines were found to process."
}
