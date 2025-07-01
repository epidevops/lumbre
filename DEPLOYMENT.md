# Fly.io Deployment Guide

This guide covers deploying Lumbre to Fly.io with multiple SQLite databases.

## Database Architecture

Your app uses 4 separate SQLite databases optimized for different workloads:
- `storage/production_primary.sqlite3` - Main application data
- `storage/production_cache.sqlite3` - Rails cache (Solid Cache)
- `storage/production_queue.sqlite3` - Background jobs (Solid Queue)  
- `storage/production_cable.sqlite3` - WebSocket connections (Solid Cable)

## Quick Deployment

Use the automated deployment script:

```bash
./bin/deploy-fly
```

This script handles everything automatically:
1. Destroys existing app (if any)
2. Creates new Fly.io app
3. Creates persistent volume for SQLite databases
4. Sets Rails master key
5. Deploys the application

## Manual Deployment Steps

If you prefer manual control:

```bash
# 0. Delete existing app (optional)
fly apps destroy lumbre --yes

# 1. Create app
fly apps create lumbre

# 2. Create volume for SQLite databases  
fly volumes create lumbre_data --region iad --size 10

# 3. Set Rails master key
fly secrets set RAILS_MASTER_KEY=$(cat config/master.key)

# 4. Deploy
fly deploy
```

## What Happens During Deployment

The deployment automatically runs `fly:release` which:

1. **Creates databases** - All 4 SQLite files in `/rails/storage`
2. **Runs migrations** - Creates all tables and indexes
3. **Sets up data** - Runs `lumbre:setup` to create:
   - Admin user (admin@example.com / password)
   - Regular user (user@example.com / password)
   - Restaurant with 6-language translations
   - Store and menu items
   - Contact information
   - Feature flags and scheduling

## Post-Deployment

### Access Your Application

- **Main app**: `https://lumbre.fly.dev`
- **Admin panel**: `https://lumbre.fly.dev/admin`

### Security: Change Default Password

⚠️ **Important**: Change the default admin password immediately:

```bash
fly ssh console -C "./bin/rails console"

# In Rails console:
admin = AdminUser.first
admin.update!(password: 'your_secure_password', password_confirmation: 'your_secure_password')
```

### Development Tools (Super Admin Access)

- **Blazer** (SQL queries): `/blazer`
- **Flipper** (Feature flags): `/flipper`  
- **Jobs Dashboard**: `/jobs`
- **Exception Tracking**: `/exception-track`
- **Component Library**: `/lookbook`

## Maintenance Commands

### View Application Logs
```bash
fly logs
```

### Rails Console
```bash
fly ssh console -C "./bin/rails console"
```

### SSH into Container
```bash
fly ssh console
```

### Check Database Status
```bash
fly ssh console -C "ls -la /rails/storage"
fly ssh console -C "./bin/rails runner 'puts ActiveRecord::Base.connected?'"
```

### Re-run Data Setup
```bash
# Careful: This will create duplicate data
fly ssh console -C "rake lumbre:setup"
```

## Scaling and Performance

### Current Setup
- Single instance deployment
- Perfect for restaurant/small business applications
- Cost-effective starting point

### Monitoring
```bash
# App status
fly status

# Resource usage
fly status --all

# Machine details
fly machine list
```

### Scaling Options
```bash
# Scale memory
fly scale memory 2048

# Scale to multiple instances
fly scale count 2

# Add more regions
fly regions add sea
```

## Troubleshooting

### Database Issues
```bash
# Check database files
fly ssh console -C "ls -la /rails/storage"

# Test database connections
fly ssh console -C "./bin/rails runner 'puts [ActiveRecord::Base.connected?, Rails.cache.write(\"test\", \"works\")]'"

# Run migrations manually
fly ssh console -C "./bin/rails db:migrate"
```

### Volume Issues
```bash
# Check mounted volumes
fly ssh console -C "df -h"

# Verify volume mount point
fly ssh console -C "mount | grep rails"
```

### App Not Starting
```bash
# Check recent logs
fly logs --tail

# Check app status
fly status

# Restart app
fly machine restart
```

### Configuration Issues
```bash
# Verify secrets
fly secrets list

# Check environment
fly ssh console -C "env | grep RAILS"
```

## Backup and Recovery

### Database Backups
```bash
# Create backup
fly ssh console -C "tar -czf /tmp/backup.tar.gz /rails/storage/*.sqlite3"

# Download backup
fly ssh sftp get /tmp/backup.tar.gz ./backup.tar.gz
```

### Volume Snapshots
Fly.io provides automatic volume snapshots. Configure via:
```bash
fly volumes create lumbre_data --snapshot-retention 7
```

### Restore from Backup
```bash
# Upload backup
fly ssh sftp put ./backup.tar.gz /tmp/backup.tar.gz

# Restore
fly ssh console -C "cd /rails && tar -xzf /tmp/backup.tar.gz"
```

## Cost Optimization

### Resource Usage
- **Memory**: Start with 1GB, monitor usage
- **CPU**: Shared CPU sufficient for most use cases
- **Storage**: 10GB volume covers most restaurant needs

### Auto-scaling
```bash
# Enable auto-stop when idle
fly scale count 0:1

# Set memory limits
fly scale memory 512
```

## Advanced Configuration

### Custom Domains
```bash
# Add custom domain
fly certs create yourdomain.com

# Verify certificate
fly certs check yourdomain.com
```

### Environment Variables
```bash
# Set additional secrets
fly secrets set CUSTOM_VAR=value

# Set regular environment variables in fly.toml
```

### Health Checks
Your app includes a health check at `/up` that Fly.io monitors automatically.

## Support

- **Fly.io Docs**: https://fly.io/docs
- **Rails Logs**: `fly logs --tail`
- **Status Page**: https://status.fly.io

For issues specific to your Lumbre application, check the admin panel and logs for detailed error information.