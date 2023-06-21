#Quick and dirty script to simplify size-reducing a large amount of JPG images nested within many folders. 
#This script requires ImageMagick to be installed and available on PATH

$folderPath = Read-Host "Enter a folder path"
$totalFiles = 0

if (Test-Path -Path $folderPath -PathType Container) {

    $subdirectories = Get-ChildItem -Path $folderPath -Recurse -Directory

    foreach ($subdirectory in $subdirectories) {     

        $jpgFiles = Get-ChildItem -Path $subdirectory.FullName -Filter "*.jpg" -File

        if ($jpgFiles) {
            $numFiles = $jpgFiles.Count
            $totalFiles += $numFiles
            Write-Host "Compressing images in Subdirectory: $($subdirectory.FullName)"
            Write-Host "There are $numFiles JPG files in this directory"
            Invoke-Command -ScriptBlock { magick mogrify -quality 85 "$($subdirectory.FullName)\*.jpg" }
        }
        else{
            Write-Host "Skipping Empty Subdirectory: $($subdirectory.FullName)"
        }
        Write-Host " "
    }
}
else {
    Write-Host "The specified folder path does not exist."
}
Write-Host "Compressor has finished. Total files processed: $totalFiles"
