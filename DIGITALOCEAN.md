# DigitalOcean Configuration

Configuration changes required for running Freehub (Rails 2.3) on DigitalOcean.

---

### 1. App Platform Environment Variables

Set `RAILS_ENV=production` as an app-level environment variable:

1. Go to **App Platform** → your app → **Settings**
2. Under **App-Level Environment Variables**, add:
   - **Key**: `RAILS_ENV`
   - **Value**: `production`

Without this, Rails defaults to development mode and won't use the production database configuration.

---

### 2. MySQL Password Encryption (Legacy)

Changed the `freehub_app` database user to use legacy MySQL 5.x password encryption:

1. Go to **Databases** → your database cluster → **Users & Databases**
2. Find the `freehub_app` user
3. Click **More** (three dots) → **Edit Password Encryption**
4. Select **Legacy - MySQL 5.x** (`mysql_native_password`) → **Save**

**Why**: The old `mysql` gem in Rails 2.3 doesn't support MySQL 8.0's default `caching_sha2_password` authentication plugin.

**Security note**: `mysql_native_password` is less secure than `caching_sha2_password`, but is required for compatibility with older MySQL client libraries.

---

### 3. Disable sql_require_primary_key

We disabled `sql_require_primary_key` on the DigitalOcean managed MySQL database to support Rails 2.3 HABTM (has_and_belongs_to_many) join tables which don't have primary keys.

**What was changed:**

Disabled `sql_require_primary_key` via DigitalOcean API:

```bash
doctl databases configuration update af845ccd-eb8d-4f0d-99b5-2c8cffc71681 --engine mysql --config-json '{"sql_require_primary_key": false}'
```

**Why**: The `roles_users` join table (for the `Role has_and_belongs_to_many :users` relationship) doesn't have a primary key. Rails 2.3 HABTM doesn't support primary keys on join tables, but DigitalOcean's default MySQL 8.0 configuration requires them for replication purposes.

**Affected tables:**

| Table | Purpose | Notes |
|-------|---------|-------|
| `roles_users` | User role assignments (HABTM join table) | Small, rarely updated |
| `schema_info` | Legacy Rails 1.x migration tracking | Not used at runtime, may exist in old backups |
| `schema_migrations` | Rails migration version tracking | Only written during deploys |

**Implications:**

- **Single-node cluster**: No impact
- **Multi-node cluster**: Potential replication lag on updates/deletes to tables without PKs, since MySQL must do full table scans to identify rows. Risk is minimal for `roles_users` due to its small size and infrequent updates.

**How to revert:**

1. Add a primary key to `roles_users`:
   ```sql
   ALTER TABLE roles_users ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
   ```

2. Re-enable the requirement:
   ```bash
   doctl databases configuration update af845ccd-eb8d-4f0d-99b5-2c8cffc71681 --engine mysql --config-json '{"sql_require_primary_key": true}'
   ```

3. Optionally, convert the HABTM to `has_many :through` in the Rails models for a cleaner long-term solution.

---

### 4. Database Tier

Using **Premium AMD, 1 vCPU, 2GB RAM** ($36/mo) with NVMe storage. Upgraded from Regular 1 vCPU/1GB for better query performance — dedicated CPU and NVMe disk significantly improve aggregation queries across large tables.

---

### 5. Database Trusted Sources

By default, DigitalOcean managed databases block external connections. To allow developers to connect directly to the database:

1. Go to **Databases** → your database cluster → **Settings**
2. Scroll to **Trusted Sources**
3. Add the developer's IP address (find it with `curl ifconfig.me`)

**Note**: For security, avoid using "Allow all IPv4". Add specific IPs as needed.

**To connect locally**:
```bash
mysql -h db-mysql-sfo3-freehub-do-user-32369540-0.d.db.ondigitalocean.com -P 25060 -u doadmin -p --ssl-mode=REQUIRED freehub_production
```

---

## Deployment Workflow

### Overview

- **Staging** (`freehub-staging`): Auto-deploys from `master` branch
- **Production** (`freehub-production`): Manual deploy from `master` branch

### App Platform Configuration

Configure each app's deploy settings:

1. **Staging**: Settings → Component → Auto-deploy: **ON**
2. **Production**: Settings → Component → Auto-deploy: **OFF**

### Making Changes

1. **Create a feature branch** (optional for small changes):
   ```bash
   git checkout -b my-feature
   # make changes
   git commit -m "Description of changes"
   git push origin my-feature
   ```

2. **Merge to master**:
   ```bash
   git checkout master
   git merge my-feature
   git push origin master
   ```
   This automatically deploys to **staging**.

3. **Test on staging**:
   - Visit the staging app URL
   - Verify changes work correctly

4. **Deploy to production**:
   - Go to **App Platform** → `freehub-production` → **Actions** → **Deploy**
   - Or use CLI: `doctl apps create-deployment e1229281-8c8b-46ec-a930-9737caab742d`

5. **Tag the release** (for history):
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

### Tagging Conventions

Use semantic versioning: `vMAJOR.MINOR.PATCH`
- `v1.0.1` - patch: bug fixes
- `v1.1.0` - minor: new features, backwards compatible
- `v2.0.0` - major: breaking changes

List existing tags:
```bash
git tag -l
```

### Rollback

To rollback production to a previous version, redeploy a previous commit from the App Platform console under **Activity** → select a previous deployment → **Redeploy**.
