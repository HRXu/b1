$FunctionName ={
    param (
        [string]$filename
    )
    cwebp -q 85 "$filename.jpg" -o "$filename.webp"
}


$a=New-Object -TypeName System.Collections.ArrayList
Get-ChildItem -Filter *.jpg|
ForEach-Object{
    $a.Add($_.BaseName)
    #Write-Output $_.Name
}

$jobs=@()
$RunspacePool=[runspacefactory]::CreateRunspacePool(1,4)
$RunspacePool.Open()
foreach ($f in $a) {
    $Job = [powershell]::Create().AddScript($FunctionName).AddArgument($f)
    $Job.RunspacePool = $RunspacePool
    $Jobs += New-Object PSObject -Property @{
        Pipe = $Job
        Result = $Job.BeginInvoke()
    }
    #Write-Output $f
}


Write-Host "Waiting.." -NoNewline
Do {
   Write-Host "." -NoNewline
   Start-Sleep -Seconds 1
} While ( $Jobs.Result.IsCompleted -contains $false)
Write-Host "All jobs completed!"
$Results = @()
ForEach ($Job in $Jobs)
{   $Results += $Job.Pipe.EndInvoke($Job.Result)
}
Write-Host $Results
