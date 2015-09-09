[CmdletBinding()]
Param(
    [string]$directoryPath,
    [string]$filePath,
    [string]$suffixFormat = "yyyMMddhhmmss"
)

$now = Get-Date
$suffix = "{0}" -f $now.ToString($suffixFormat)
Write-Verbose "Directory path $directoryPath"
Write-Verbose "File path: $filePath"
Write-Verbose "Suffix format: $suffixFormat"
Write-Verbose "Actual suffix: $suffix"

function RenameDirectory($path){
    if (-not (Test-Path $path)) {
        throw [System.IO.DirectoryNotFoundException] "$path directory not found"
    }
    $dir = Get-Item $path
    $newDirName = "{0}-{1}" -f $dir.Name,  $suffix
    $newDirFullPath = [System.IO.Path]::Combine($dir.Parent.FullName, $newDirName)
    Write-Verbose "Directory will be renamed to $newDirFullPath"
    Rename-Item $dir $newDirFullPath
    Write "Renamed directory from $path to $newDirFullPath"
}

function RenameFile($path){
    if (-not (Test-Path $path)) {
        throw [System.IO.FileNotFoundException] "$path file not found"
    }
    $file = Get-Item $path
    $newFileName = "{0}-{1}{2}" -f [System.IO.Path]::GetFileNameWithoutExtension($file), $suffix, $file.Extension
    $newFileFullPath = [System.IO.Path]::Combine($file.Directory.FullName, $newFileName)
    Write-Verbose "File will be renamed to $newFileFullPath"
    Rename-Item $file $newFileFullPath
    Write "Renamed file from $path to $newFileFullPath"
}

if ($directoryPath -and ![string]::IsNullOrEmpty($directoryPath.Trim())) {
    RenameDirectory($directoryPath)
} elseif ($filePath -and ![string]::IsNullOrEmpty($filePath.Trim())) {
    RenameFile($filePath)
} else {
    throw [System.ArgumentException] "Either directoryPath or filePath must be supplied"
}