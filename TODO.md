# TODO

## Document DigitalOcean MySQL Configuration on Wiki

We disabled `sql_require_primary_key` on the DigitalOcean managed MySQL database to support Rails 2.3 HABTM (has_and_belongs_to_many) join tables which don't have primary keys.

### What was changed

Disabled `sql_require_primary_key` via DigitalOcean API:

```bash
doctl databases configuration update 8532c635-e177-4c1f-a4af-abff72294cfe --engine mysql --config-json '{"sql_require_primary_key": false}'
```

### Why

The `roles_users` join table (for the `Role has_and_belongs_to_many :users` relationship) doesn't have a primary key. Rails 2.3 HABTM doesn't support primary keys on join tables, but DigitalOcean's default MySQL 8.0 configuration requires them for replication purposes.

### Affected tables

| Table | Purpose | Notes |
|-------|---------|-------|
| `roles_users` | User role assignments (HABTM join table) | Small, rarely updated |
| `schema_info` | Legacy Rails 1.x migration tracking | Not used at runtime, may exist in old backups |
| `schema_migrations` | Rails migration version tracking | Only written during deploys |

### Implications

- **Single-node cluster**: No impact
- **Multi-node cluster**: Potential replication lag on updates/deletes to tables without PKs, since MySQL must do full table scans to identify rows. Risk is minimal for `roles_users` due to its small size and infrequent updates.

### How to revert

1. Add a primary key to `roles_users`:
   ```sql
   ALTER TABLE roles_users ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
   ```

2. Re-enable the requirement:
   ```bash
   doctl databases configuration update 8532c635-e177-4c1f-a4af-abff72294cfe --engine mysql --config-json '{"sql_require_primary_key": true}'
   ```

3. Optionally, convert the HABTM to `has_many :through` in the Rails models for a cleaner long-term solution.
