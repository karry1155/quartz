<#
Script: Sync Obsidian Public folder to Quartz
Usage: Right-click -> Run with PowerShell
#>

# --- 1. CONFIGURATION (CHECK THIS PATH) ---
# Your Obsidian Public folder path (No trailing slash)
$SourcePath = "C:\Users\25899\Documents\GitHub\sukiya_vault\public"

# Target path: The 'content' folder in the current directory
$QuartzPath = $PSScriptRoot
$ContentPath = Join-Path $QuartzPath "content"

# --- 2. CHECK SOURCE PATH ---
Write-Host "------------------------------------------"
Write-Host "      Obsidian -> Quartz Sync Tool"
Write-Host "------------------------------------------"
Write-Host "Source: $SourcePath"
Write-Host "Target: $ContentPath"

if (-not (Test-Path $SourcePath)) {
    Write-Host "❌ ERROR: Source folder not found!" -ForegroundColor Red
    Write-Host "Please check line 8 in this script." -ForegroundColor Yellow
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# --- 3. SYNC FILES (ROBOCOPY) ---
Write-Host "`n🚀 [1/3] Syncing files..." -ForegroundColor Cyan

# /MIR: Mirror mode
# /XD: Exclude folders
# /XF: Exclude files
# /ndl /nc /ns: Reduce log noise
robocopy $SourcePath $ContentPath /MIR /XD .obsidian .git .trash /XF .DS_Store thumbs.db /MT:8 /ndl /nc /ns

if ($LASTEXITCODE -ge 8) {
    Write-Host "❌ Sync Failed! Robocopy Error Code: $LASTEXITCODE" -ForegroundColor Red
    Pause
    exit
} else {
    Write-Host "✅ Sync Complete." -ForegroundColor Green
}

# --- 4. GIT COMMIT ---
Write-Host "`n📦 [2/3] Checking Git status..." -ForegroundColor Cyan

Set-Location $QuartzPath

$GitStatus = git status --porcelain
if ([string]::IsNullOrWhiteSpace($GitStatus)) {
    Write-Host "⚠️ No changes detected. Nothing to commit." -ForegroundColor Yellow
} else {
    Write-Host "Changes detected. Committing..." -ForegroundColor Gray
    git add .
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Auto-deploy: Update content $Time"
    Write-Host "✅ Committed to Git." -ForegroundColor Green
}

# --- 5. GIT PUSH ---
Write-Host "`n☁️ [3/3] Pushing to GitHub..." -ForegroundColor Cyan

git push

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n🎉 SUCCESS! Netlify is building your site." -ForegroundColor Green
    Write-Host "Please wait 1-2 minutes." -ForegroundColor Gray
} else {
    Write-Host "`n❌ Push Failed!" -ForegroundColor Red
    Write-Host "Check your internet connection or proxy settings." -ForegroundColor Yellow
}

# --- 6. PAUSE (PREVENT CLOSING) ---
Write-Host "`n=========================================="
Write-Host "Press any key to close..." -ForegroundColor White -BackgroundColor DarkBlue
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")