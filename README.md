# Firefly III Finance Tracker

Self-hosted personal finance manager using Docker and PostgreSQL.

## Prerequisites

- Docker Desktop installed and running
- Git installed
- Windows 10/11 or macOS

## Installation

### 1. Clone Repository

```bash
git clone https://github.com/YOUR-USERNAME/firefly-finance.git
cd firefly-finance
```

### 2. Configure Environment Files

Either do it manually by renaming the example files or run the commands below based on the OS.

#### Windows (PowerShell)
```powershell
Copy-Item .env.example .env
Copy-Item .db.env.example .db.env
```

#### macOS/Linux
```bash
cp .env.example .env
cp .db.env.example .db.env
```

### 3. Generate Application Key

Use https://www.lastpass.com/features/password-generator to create the key. Make sure it only contains alphanumeric characters (A-Z, a-z, 0-9) and is exactly 32 characters long.

### 4. Edit Configuration Files

Open `.env` file and update:

- APP_KEY: Paste the generated key from step 3
- DB_PASSWORD: Create a strong password (16+ characters)
- APP_URL: Change if using custom port (default: http://localhost)

Open `.db.env` file and update:

- POSTGRES_PASSWORD: Use the SAME password from .env DB_PASSWORD

Both passwords must match exactly.

### 5. Customize Port (Optional)

Default port is 80. To change:

Edit `docker-compose.yml`, find:
ports:
  - 80:8080

Change to your preferred port:
ports:
  - xxxx:8080

Then update APP_URL in `.env` to match:
APP_URL=http://localhost:xxxx

### 6. Start Firefly III

```bash
docker compose up -d
```

Wait 10-20 seconds for initialization to complete. Check section "Daily Usage" if issues arise.

### 7. Access Application

Open browser and navigate to:
- Default: http://localhost
- Custom port: http://localhost:YOUR_PORT

### 8. Create Admin Account

On first access:
1. Fill in registration form
2. Use a real or fake email address (email disabled by default)
3. Create strong password (16+ characters)
4. Click Register

This account becomes the admin.

### 9. Enable Two-Factor Authentication

After login:
1. Click your email (top right)
2. Go to Profile
3. Navigate to Security tab
4. Enable Two-Factor Authentication
5. Scan QR code with authenticator app
6. Save backup codes securely

### 10. Set Production Mode

Edit `.env` file and change:
APP_ENV=production

Restart containers:
docker compose down
docker compose up -d

## Daily Usage

### Start Containers
```bash
docker compose up -d
```

### Stop Containers
```bash
docker compose down
```

### View Logs
```bash
docker compose logs app
```

### Check Status
```bash
docker compose ps
```

## Backup

### Automated Backup (Windows Only)

The `backup.ps1` script creates backups in `./Backups` folder.

Manual backup:
```bash
.\backup.ps1
```

Automated schedule (Windows Task Scheduler):
1. Backup before shutdown
2. Weekly backup: Sunday 2 PM

Script automatically:
- Stops containers safely
- Backs up database and uploads
- Restarts containers
- Keeps last 30 backups

### Manual Backup (Any OS)

Stop containers:
```bash
docker compose down
```

Backup database:
```bash
docker run --rm -v firefly-finance_firefly_iii_db:/data -v $(pwd)/Backups:/backup alpine tar czf /backup/db-backup.tar.gz -C /data .
```

Backup uploads:
```bash
docker run --rm -v firefly-finance_firefly_iii_upload:/data -v $(pwd)/Backups:/backup alpine tar czf /backup/upload-backup.tar.gz -C /data .
```

Restart containers:
```bash
docker compose up -d
```

### Restore from Backup

Stop containers:
```bash
docker compose down
```

Remove old volumes:
```bash
docker volume rm firefly-finance_firefly_iii_db
docker volume rm firefly-finance_firefly_iii_upload
```

Restore database:
```bash
docker run --rm -v firefly-finance_firefly_iii_db:/data -v $(pwd)/Backups:/backup alpine tar xzf /backup/db-backup.tar.gz -C /data
```

Restore uploads:
```bash
docker run --rm -v firefly-finance_firefly_iii_upload:/data -v $(pwd)/Backups:/backup alpine tar xzf /backup/upload-backup.tar.gz -C /data
```

Restart:
```bash
docker compose up -d
```

## Updating Firefly III

Pull latest images:
```bash
docker compose pull
```

Restart with new version:
```bash
docker compose up -d
```

Your data persists in Docker volumes across updates.

## Troubleshooting

### Cannot access application

Check containers are running:
```bash
docker compose ps
```

Both containers should show "Up" status.

### Database connection error

Verify passwords match in `.env` and `.db.env` files.

### Port already in use

Change port in docker-compose.yml and APP_URL in .env file.

### APP_KEY error

Ensure APP_KEY is exactly 32 characters AND contains only alphanumeric characters (A-Z, a-z, 0-9).

## Security Notes

- Never commit `.env` or `.db.env` files to version control
- Use strong passwords (16+ characters minimum)
- Enable 2FA immediately after registration
- Set APP_ENV=production for live use
- Keep Docker and Firefly III images updated
- Backup regularly
- Data stored locally in Docker volumes only

## File Structure

firefly-finance/
├── .env                    # Local config (never commit)
├── .db.env                 # Local DB config (never commit)
├── .env.example            # Config template
├── .db.env.example         # DB config template
├── docker-compose.yml      # Docker configuration
├── backup.ps1              # Backup script (Windows)
├── Backups/                # Backup storage (never commit)
└── README.md               # This file

## Documentation

Official Firefly III documentation: https://docs.firefly-iii.org/

## License

Firefly III is open source software licensed under the AGPL-3.0 license.