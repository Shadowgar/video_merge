# select_files.ps1
[void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")

# Prompt the user to select multiple video files
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
$FileBrowser.Multiselect = $true
$FileBrowser.Filter = "Video Files|*.mp4;*.mov;*.avi;*.mkv;*.flv|All Files|*.*"

# Show the file dialog and store selected file paths in an array
$Selected = $FileBrowser.ShowDialog()
if ($Selected -eq [System.Windows.Forms.DialogResult]::OK) {
    $fileList = $FileBrowser.FileNames | ForEach-Object { "file '$($_ -replace "'", "''")'" }
    
    # Write the file list to filelist.txt without BOM encoding
    Out-File -FilePath "filelist.txt" -Encoding ASCII -InputObject $fileList -Force
}
