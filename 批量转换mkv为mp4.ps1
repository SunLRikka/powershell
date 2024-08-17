Set-Location "D:\library\Videos\OBS Studio"
$inputFolder = "."
$outputFolder = ".\converted"

# 创建输出文件夹
if (!(Test-Path -Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory | Out-Null
}

# 遍历输入文件夹中的所有视频文件
Get-ChildItem -Path $inputFolder -Include *.mkv -Recurse | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = Join-Path -Path $outputFolder -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($_.Name) + ".mp4")

    # 使用 FFmpeg 的 CUDA 硬件加速转换,并保持视频和音频编码不变
    ffmpeg -hwaccel cuda -i $inputFile -map 0:v:0 -map 0:a:1 -c copy $outputFile
    Write-Host "Converted $inputFile to $outputFile"
}