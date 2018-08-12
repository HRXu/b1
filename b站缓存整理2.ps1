#丢av号文件夹下面运行 
#需要安装ffmpeg 添加环境变量
#按p整理，安卓版滋瓷合并分段
#用前备份
$type = Read-Host "Choose 0 or 1 //Android[0] UWP[1]"
$currentPath=Split-Path -Parent $MyInvocation.MyCommand.Definition #当前文件夹
if($type -eq "0")
{
    Get-ChildItem -Filter *.blv -Recurse |
    ForEach-Object{       
        cd $_.DirectoryName
        Move-Item $_.Name -Destination ../    
        Out-File -FilePath ../filelist.txt -Append -Encoding ASCII -InputObject "file $_" 
    }
    cd $currentPath
#弹幕
    Get-ChildItem -Filter *.xml -Recurse |
    ForEach-Object{
        $bar=($_.DirectoryName).Split('\\')
        $partNumber=$bar[$bar.Count-1] #分p号
        cd $_.DirectoryName
        $newName = 'av{0}-p{1}.xml' -f $av,$partNumber
        Rename-Item -Path $_.FullName -NewName $newName    
    }
    cd $currentPath

    Get-ChildItem -Filter *.txt -Recurse |
    ForEach-Object{
        $bar=($_.DirectoryName).Split('\\')
        $partNumber=$bar[$bar.Count-2] #分p号
        $file='av{0}-p{1}.mkv' -f $av,$partNumber
        cd $_.DirectoryName
        ffmpeg -f concat -i filelist.txt -c copy "$file"
    }
    cd $currentPath
    Remove-Item ./* -Exclude *.mkv,*.xml,*ps1 -Recurse #删掉其他文件
}
else
{
    $foo =($currentPath).Split('\\') 
    Get-ChildItem -Filter *.flv -Recurse |
    ForEach-Object{
        cd $_.DirectoryName
        $newName = 'av{0}' -f $_.Name
        Rename-Item -Path $_.FullName -NewName $newName
        Move-Item $newName -Destination ../
    }
    cd $currentPath
    Get-ChildItem -Filter *.xml -Recurse |
    ForEach-Object{
       $newName = 'av{0}' -f $_.Name
       cd $_.DirectoryName
       Rename-Item -Path $_.FullName -NewName $newName
       Move-Item $newName -Destination ../
    }
    cd $currentPath
    Remove-Item ./* -Exclude *.flv,*.xml,*.ps1 -Recurse #删掉其他文件
}
