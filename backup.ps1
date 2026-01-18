# Firefly III Backup Script

# Stops containers
# Backs up volumes
# Restarts containers

$BackupDir = ".\Backups"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupFile = "$BackupDir\firefly-backup-$Timestamp.tar.gz"

# Create backup directory if doesn't exist
if (!(Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

Write-Host "Starting Firefly III backup..." -ForegroundColor Cyan

# Stop containers
Write-Host "Stopping containers..." -ForegroundColor Yellow
docker compose down

# Backup database volume
Write-Host "Backing up database..." -ForegroundColor Yellow
docker run --rm `
    -v firefly-finance_firefly_iii_db:/data `
    -v ${BackupDir}:/backup `
    alpine tar czf /backup/firefly-db-$Timestamp.tar.gz -C /data .

# Backup upload volume
Write-Host "Backing up uploads..." -ForegroundColor Yellow
docker run --rm `
    -v firefly-finance_firefly_iii_upload:/data `
    -v ${BackupDir}:/backup `
    alpine tar czf /backup/firefly-upload-$Timestamp.tar.gz -C /data .

# Restart containers
Write-Host "Restarting containers..." -ForegroundColor Yellow
docker compose up -d

# Cleanup old backups (keep last 30)
Write-Host "Cleaning up old backups..." -ForegroundColor Yellow
Get-ChildItem $BackupDir -Filter "firefly-*.tar.gz" | 
    Sort-Object LastWriteTime -Descending | 
    Select-Object -Skip 30 | 
    Remove-Item -Force

Write-Host "Backup complete: $BackupFile" -ForegroundColor Green
Write-Host "Location: $BackupDir" -ForegroundColor Green
