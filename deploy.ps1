<#
脚本功能：将 Obsidian 里的“公开”文件夹同步到 Quartz 并发布
使用方法：右键本文件 -> 使用 PowerShell 运行
#>

# --- 1. 配置路径 (请核对您的路径) ---
# 源路径：指向您 Obsidian 库里的 "公开" 文件夹
# 注意：路径结尾不要加斜杠
$SourcePath = "C:\Users\25899\Documents\GitHub\sukiya_vault\公开"

# 目标路径：自动获取当前脚本所在目录下的 content 文件夹
$QuartzPath = $PSScriptRoot
$ContentPath = Join-Path $QuartzPath "content"

# --- 2. 检查源文件夹是否存在 ---
if (-not (Test-Path $SourcePath)) {
    Write-Host "错误：找不到源文件夹！请检查路径：" -ForegroundColor Red
    Write-Host $SourcePath
    Write-Host "按任意键退出..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# --- 3. 同步文件 (Robocopy) ---
Write-Host "🚀 正在从 [公开] 文件夹同步笔记..." -ForegroundColor Cyan

# /MIR: 镜像模式 (完全保持一致，源删则删，源增则增)
# /XD: 排除可能存在的 .obsidian 文件夹
# /XF: 排除系统文件
# /MT: 多线程加速
robocopy $SourcePath $ContentPath /MIR /XD .obsidian .git .trash /XF .DS_Store thumbs.db /MT:8 /njh /njs /ndl /nc /ns

# Robocopy 返回值小于 8 代表成功
if ($LASTEXITCODE -ge 8) {
    Write-Host "❌ 同步过程中出现严重错误！" -ForegroundColor Red
    Pause
    exit
}

# --- 4. Git 提交与推送 ---
Write-Host "`n📦 正在提交到 GitHub..." -ForegroundColor Cyan

# 切换到 quartz 目录 (确保 git 命令在正确的地方执行)
Set-Location $QuartzPath

# 添加所有更改
git add .

# 提交信息包含时间戳，方便查看
$Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Auto-deploy: Update from Public folder at $Time"

# 推送
Write-Host "☁️ 正在触发 Netlify 构建..." -ForegroundColor Cyan
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ 发布成功！Netlify 正在处理您的更新。" -ForegroundColor Green
    Write-Host "请稍等 1-2 分钟后访问您的网站。" -ForegroundColor Gray
} else {
    Write-Host "`n⚠️ Git 推送可能遇到问题，请检查网络或日志。" -ForegroundColor Yellow
}

# 暂停 3 秒自动关闭
Start-Sleep -Seconds 3