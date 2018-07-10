$shell= New-Object -ComObject Shell.Application
$currentPath=Split-Path -Parent $MyInvocation.MyCommand.Definition #当前文件夹
$shellfolder = $shell.Namespace($currentPath)
$fileList=Get-ChildItem -Filter *.jpg

$Name = Read-Host "Rename[y] Undo[n]"

if($Name -eq "y")
{
    ForEach($file in $fileList){
        $shellfile = $shellfolder.ParseName($file.Name)
        $date=$shellfolder.GetDetailsOf($shellfile, 12).Replace('/','-').Split(' ') #获取拍摄日期

        if($date[0] -eq “”)
        {
            "{0} 该文件没有拍摄日期" -f $file.Name
        }
        else
        {
            $newName = '{0}_{1}_{2}' -f $date[0],$date[2].Replace(':','.'),$file.Name
            Rename-Item -LiteralPath $file.Name -NewName $newName
        }
    }
}
else
{
    ForEach($file in $fileList){
        $newName= $file.Name.Split(' ')
        Rename-Item -LiteralPath $file.Name -NewName $newName[$newName.Count-1]
    }
}

