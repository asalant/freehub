# Freehub Deployment on Digital Ocean

https://freehub.bikekitchen.org is hosted on the [DigitalOcean App Platform](https://www.digitalocean.com/products/app-platform) with a managed MySQL database.

> **Tip**: [Claude Code](https://docs.anthropic.com/en/docs/claude-code) is a helpful assistant for configuring and managing the DigitalOcean application environment.

## Overview

| Component | Service | Notes |
|-----------|---------|-------|
| **Application** | DigitalOcean App Platform | Rails 2.3 app in Docker |
| **Database** | DigitalOcean Managed MySQL 8 | Premium AMD, 2GB RAM |
| **DNS** | Bluehost | bikekitchen.org domain |
| **SSL** | DigitalOcean (Let's Encrypt) | Auto-managed, auto-renewed |
| **Email** | Resend | Transactional emails via SMTP |
| **Error Tracking** | Airbrake | Automatic error notifications |
| **Analytics** | Google Analytics (GA4) | Usage statistics |
| **Uptime Monitoring** | DigitalOcean | Alerts on downtime |

---

## DNS

DNS for `freehub.bikekitchen.org` is managed in **Bluehost** (bikekitchen.org domain).

```
freehub.bikekitchen.org          CNAME  freehub-app-s65go.ondigitalocean.app
freehub-staging.bikekitchen.org  CNAME  freehub-staging-hkbze.ondigitalocean.app
```

---

## External Services

### Email (Resend)

Transactional emails (account activation, password reset, etc.) are sent via [Resend](https://resend.com) SMTP.

- **SMTP host**: `smtp.resend.com`
- **Port**: 2587
- **Domain**: `bikekitchen.org`

The API key is configured via the `RESEND_API_KEY` environment variable.

### Error Tracking (Airbrake)

Errors are tracked by [Airbrake](https://airbrake.io) and notifications are sent to configured team members.

The API key is configured via the `AIRBRAKE_API_KEY` environment variable.

### Analytics (Google Analytics)

Usage statistics are tracked in Google Analytics (GA4). Access via the Google Analytics dashboard.

---

## DigitalOcean Configuration

### Apps

| App | URL | Auto-deploy |
|-----|-----|-------------|
| **Production** | https://freehub.bikekitchen.org | OFF (manual) |
| **Staging** | https://freehub-staging.bikekitchen.org | ON (from master) |

**Note**: Staging is archived when not in use to save costs. Archiving is free for up to 20 apps and 3 months; DigitalOcean may charge beyond that. See [Setting Up Staging](#setting-up-staging) if you need to recreate it.

### Environment Variables

Set in App Platform → Settings → App-Level Environment Variables:

| Variable | Value |
|----------|-------|
| `RAILS_ENV` | `production` |
| `SITE_URL` | `https://freehub.bikekitchen.org` |
| `AIRBRAKE_API_KEY` | *(Airbrake API key)* |
| `RESEND_API_KEY` | *(Resend SMTP API key)* |

`RAILS_ENV` is required — without it, Rails defaults to development mode.

### Database

**Tier**: Premium AMD, 1 vCPU, 2GB RAM ($36/mo) with NVMe storage.

**Connect locally** (requires your IP in Trusted Sources):
```bash
mysql -h db-mysql-sfo3-freehub-do-user-32369540-0.d.db.ondigitalocean.com \
  -P 25060 -u doadmin -p --ssl-mode=REQUIRED freehub_production
```

To add your IP to Trusted Sources:
1. Go to **Databases** → your cluster → **Settings** → **Trusted Sources**
2. Add your IP (find it with `curl ifconfig.me`)

### SSL Certificates

Managed automatically by App Platform via Let's Encrypt. Certificates auto-renew before expiration.

### Uptime Monitoring

Checks that the site is accessible and emails `freehub@bikekitchen.org` if down for 2+ minutes.

| Resource | ID |
|----------|-----|
| Uptime check | `290bf29b-2886-4c2f-bedb-eef81a150606` |
| Down alert | `f77f8306-b692-4a21-96e9-898618c437a2` |

```bash
# View status
doctl monitoring uptime get 290bf29b-2886-4c2f-bedb-eef81a150606

# List alerts
doctl monitoring uptime alert list 290bf29b-2886-4c2f-bedb-eef81a150606
```

---

## Deployment

### Making Changes

1. **Push to master** — automatically deploys to staging
   ```bash
   git checkout master
   git commit -m "Description of changes"
   git push origin master
   ```

2. **Test on staging** — verify changes work at staging URL

3. **Deploy to production**:
   - App Platform → `freehub-production` → **Actions** → **Deploy**
   - Or: `doctl apps create-deployment e1229281-8c8b-46ec-a930-9737caab742d`

4. **Tag the release**:
   ```bash
   git tag v2.0.1
   git push origin v2.0.1
   ```

### Tagging Conventions

Use semantic versioning: `vMAJOR.MINOR.PATCH`
- `v1.0.1` - patch: bug fixes
- `v1.1.0` - minor: new features, backwards compatible
- `v2.0.0` - major: breaking changes

### Rollback

In App Platform console: **Activity** → select previous deployment → **Redeploy**.

---

## Setting Up Staging

If the staging app was deleted (or auto-deleted after 3 months of being archived), follow these steps to recreate it.

### 1. Create the App

1. Go to **App Platform** → **Create App**
2. Connect to the **GitHub** repository (`asalant/freehub`)
3. Select the `master` branch
4. Enable **Autodeploy**

### 2. Configure the App

1. Set **Instance Size** to a single basic instance
2. Select the same **VPC** as production (SFO3)
3. Add the existing database:
   - Click **Add Resource** → **Database**
   - Select **Previously Created DigitalOcean Database**
   - Choose the existing cluster and select the `freehub_staging` database

### 3. Set Environment Variables

Add these app-level environment variables:

| Variable | Value |
|----------|-------|
| `RAILS_ENV` | `production` |
| `SITE_URL` | `https://freehub-staging.bikekitchen.org` |
| `AIRBRAKE_API_KEY` | *(Airbrake API key)* |
| `RESEND_API_KEY` | *(Resend SMTP API key)* |

### 4. Update DNS

After the app is created, update the CNAME in Bluehost to point to the new app URL:

```
freehub-staging.bikekitchen.org  CNAME  <new-app-name>.ondigitalocean.app
```

### 5. Add Custom Domain

1. Go to **Settings** → **Domains**
2. Add `freehub-staging.bikekitchen.org`
3. SSL certificate will be provisioned automatically

### 6. Archive When Done Testing

When not actively using staging, archive it to save costs:

**App Platform** → `freehub-staging` → **Settings** → **Archive App**

Archiving is free for up to 3 months (and up to 20 apps). DigitalOcean may charge for longer archives.

---

## Database Compatibility Notes

These settings were required for Rails 2.3 compatibility with MySQL 8.

### Legacy Password Encryption

The `freehub_app` user uses legacy MySQL 5.x password encryption (`mysql_native_password`) because the old `mysql` gem doesn't support MySQL 8.0's default `caching_sha2_password`.

To configure: **Databases** → cluster → **Users & Databases** → `freehub_app` → **Edit Password Encryption** → **Legacy - MySQL 5.x**

### Disabled sql_require_primary_key

Rails 2.3 HABTM join tables don't have primary keys, but MySQL 8 requires them by default.

```bash
doctl databases configuration update af845ccd-eb8d-4f0d-99b5-2c8cffc71681 \
  --engine mysql --config-json '{"sql_require_primary_key": false}'
```

**Affected tables:**

| Table | Purpose |
|-------|---------|
| `roles_users` | User role assignments (HABTM join table) |
| `schema_migrations` | Rails migration tracking |
