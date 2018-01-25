Get-ChildItem -Filter *.blv -Recurse |
ForEach-Object{
    $newName = $_.FullName.Replace(".blv",".flv")
    Rename-Item -Path $_.FullName -NewName $newName
    $parent=Split-Path -Parent $_.DirectoryName #上一级目录
    Move-Item $newName -Destination $parent
}
Remove-Item ./* -Exclude *.flv,*.xml -Recurse #删掉其他文件
