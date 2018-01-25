Get-ChildItem -Filter *.blv -Recurse |
ForEach-Object{
    $newName = '{0}{1}' -f $_.FullName,".flv"
    Rename-Item -Path $_.FullName -NewName $newName
}
