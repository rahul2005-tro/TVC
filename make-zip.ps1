$src = "C:\Users\Rahul\Downloads\tvc web"
$dst = "C:\Users\Rahul\Downloads\tvc-web-github.zip"

if (Test-Path $dst) { Remove-Item $dst -Force }

Add-Type -Assembly "System.IO.Compression.FileSystem"
$zip = [System.IO.Compression.ZipFile]::Open($dst, "Create")

$exclude = @(".next", "node_modules", ".git")

Get-ChildItem $src -Recurse -File | ForEach-Object {
    $file = $_
    $rel = $file.FullName.Substring($src.Length + 1)
    $parts = $rel -split "\\"
    $skip = $false
    foreach ($part in $parts) {
        if ($exclude -contains $part) { $skip = $true; break }
    }
    if (-not $skip) {
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.FullName, $rel) | Out-Null
        Write-Host "Added: $rel"
    }
}

$zip.Dispose()
$size = [math]::Round((Get-Item $dst).Length / 1KB)
Write-Host "`nDone! tvc-web-github.zip created ($size KB)"
