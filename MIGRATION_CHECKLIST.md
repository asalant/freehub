# DigitalOcean Migration Checklist

## Before DNS Cutover

- [x] **Email delivery** - Switched from `sendmail` to Resend SMTP. API key in `RESEND_API_KEY` env var. DNS records pending verification by domain admin.
- [x] **Error logging** - Moved Hoptoad API key to `HOPTOAD_API_KEY` env var. Airbrake account still active.
- [x] **Web analytics** - GA4 already configured, removed old Universal Analytics code
- [x] **Update footer branding** - Removed EngineYard references from footer
- [x] **Verify DO automated backups** - Daily backups enabled with 7-day retention
- [ ] **DO notifications** - Add freehub@bikekitchen.org as recipient for DigitalOcean alerts

## Performance (Before Go-Live)

- [x] **Homepage N+1 queries** - Replaced per-org queries with single `active` scope using SQL aggregation and correlated subquery. Added composite index on `visits(person_id, arrived_at)`. Upgraded DB to Premium AMD 2GB. Homepage: 30s+ → ~1.9s.
- [x] **Review other slow pages** if any

## DNS Cutover

- [ ] **Add custom domains** in App Platform settings:
  - Production: `freehub.bikekitchen.org`
  - Staging: `freehub-staging.bikekitchen.org`
- [ ] **Update DNS** to point to DigitalOcean CNAMEs
- [ ] **SSL** - Verify certs are provisioned (App Platform handles this automatically via Let's Encrypt)

## After Migration Verified

- [ ] **Shut down Engine Yard**
- [ ] **Archive staging app** when not actively testing (save costs)
- [ ] **Uptime monitoring** - Create uptime check and down alert:
  ```bash
  doctl monitoring uptime create freehub-production \
    --target https://freehub.bikekitchen.org \
    --type https \
    --regions us_east,us_west
  # Use the check ID from the output:
  doctl monitoring uptime alert create <check-id> \
    --name "Freehub Down" \
    --type down_global \
    --period 2m \
    --emails "freehub@bikekitchen.org"
  ```
- [ ] **Archive backup to S3** - Set up weekly backup archive to S3 for longer retention
- [ ] **HA database** - Consider adding standby mysql instance for high availability

