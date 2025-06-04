# Migration Guide: V2 → V3

## Overview

V3 is a **complete redesign** focused on simplicity. This guide helps you migrate from the complex V2 setup to the streamlined V3 approach.

## Key Changes Summary

| Feature | V2 | V3 |
|---------|----|----|
| **Scripts** | Multiple shell scripts | Single workflow file |
| **ID Assignment** | Complex (001), (002) system | Keep original filenames |
| **Versioning** | .versions file tracking | Simple 1.0 for all |
| **Changelog** | 9 columns | 7 simplified columns |
| **Jobs** | Single complex job | Two simple jobs (process + notify) |
| **Error Handling** | Complex fallbacks | Simple success/fail |

## Migration Steps

### 1. Backup Your Current Setup
```bash
# Backup your current diagrams-v2 
cp -r diagrams-v2 diagrams-v2-backup
```

### 2. Copy Essential Files
```bash
# Copy your .drawio files to V3
cp diagrams-v2/drawio_files/*.drawio diagrams-v3/drawio_files/

# Optional: Copy any important PNG files
cp diagrams-v2/png_files/*.png diagrams-v3/png_files/
```

### 3. Repository Settings Migration

#### Variables (Same names, same values)
✅ These stay exactly the same:
- `DIAGRAMS_SHAREPOINT_TENANT_ID`
- `DIAGRAMS_SHAREPOINT_CLIENT_ID`
- `DIAGRAMS_SHAREPOINT_DRIVE_ID`

#### Secrets (Same names, same values)
✅ These stay exactly the same:
- `DIAGRAMS_SHAREPOINT_CLIENTSECRET`

#### Optional Variables
✅ If you had Teams notifications in V2:
- `DIAGRAMS_TEAMS_WEBHOOK` (was `DIAGRAMS_TEAMS_NOTIFICATION_WEBHOOK`)

### 4. File Naming Changes

#### V2 Behavior
```
my-diagram.drawio → my-diagram (001).drawio
flowchart.drawio → flowchart (002).drawio
```

#### V3 Behavior
```
my-diagram.drawio → stays as my-diagram.drawio
flowchart.drawio → stays as flowchart.drawio
```

**Action Required**: Decide if you want to:
- **Option A**: Keep V2 names with IDs (rename files manually)
- **Option B**: Remove IDs and use clean names (V3 approach)

### 5. Changelog Format Changes

#### V2 Format (9 columns)
```csv
Date,Time,Diagram,File,Action,Commit Message,Version,Commit Hash,Author Name
```

#### V3 Format (7 columns) 
```csv
Date,Time,Diagram,Action,Version,Commit,Author
```

**Migration**: V3 starts fresh with a new changelog. Your old changelog in V2 remains unchanged.

### 6. Files No Longer Needed

These V2 files are **not used** in V3:
- `drawio_files/.counter` - No more ID assignment
- `png_files/.versions` - No more version tracking  
- `scripts/` folder - No more shell scripts
- Multiple workflow files - Single workflow only

## Migration Strategies

### Strategy 1: Clean Start (Recommended)
1. Start fresh with V3
2. Copy only `.drawio` files you want to keep
3. Use clean filenames without ID numbers
4. Let V3 create a new changelog

**Pros**: Cleanest setup, easiest to maintain
**Cons**: Lose historical changelog data

### Strategy 2: Preserve V2 Naming
1. Copy V2 files with their current names (including IDs)
2. V3 will process them as-is
3. Your filenames will look like `diagram (001).drawio`

**Pros**: Keep existing file names
**Cons**: Filenames are less clean

### Strategy 3: Parallel Operation
1. Keep V2 running
2. Set up V3 as a new repository
3. Gradually migrate files to V3
4. Disable V2 when ready

**Pros**: No disruption, gradual transition
**Cons**: Maintaining two systems temporarily

## Step-by-Step Migration

### Day 1: Setup V3
1. Create new `diagrams-v3` repository
2. Copy workflow and setup files
3. Configure repository variables/secrets
4. Test with one sample file

### Day 2: Migrate Files
1. Copy your `.drawio` files to V3
2. Decide on naming strategy
3. Make first commit to test workflow
4. Verify PNG generation and SharePoint upload

### Day 3: Switch Over
1. Update any documentation pointing to V2
2. Disable V2 workflow (rename `.github/workflows/*.yml`)
3. Archive V2 repository or folder
4. Announce V3 to your team

## Testing Your Migration

### Quick Test Checklist
- [ ] Add a `.drawio` file to `drawio_files/`
- [ ] Commit and push
- [ ] Check Actions tab - workflow runs successfully
- [ ] Verify PNG generated in `png_files/`
- [ ] Check `png_files/CHANGELOG.csv` has new entry
- [ ] Confirm changelog uploaded to SharePoint
- [ ] Test Teams notification (if configured)

### Troubleshooting Migration Issues

#### PNGs not generating
- Verify your `.drawio` files are valid
- Check workflow logs in Actions tab
- Ensure Draw.io installation step completed

#### SharePoint upload fails
- Double-check all repository variables are set
- Verify client secret is still valid
- Test permissions with Graph Explorer

#### Teams notifications missing
- Check webhook URL is set as repository variable
- Verify webhook is still active in Teams
- Ensure variable name is `DIAGRAMS_TEAMS_WEBHOOK`

## What You Gain in V3

### Simplicity
- ✅ Single workflow file instead of multiple scripts
- ✅ No complex ID assignment logic
- ✅ Simplified error handling
- ✅ Clear two-job structure (process + notify)

### Reliability  
- ✅ Fewer moving parts = fewer things to break
- ✅ Direct SharePoint integration (no separate scripts)
- ✅ Simplified changelog format
- ✅ Better job separation

### Maintainability
- ✅ Everything in one workflow file
- ✅ Clear, readable YAML
- ✅ Standard GitHub Actions patterns
- ✅ Easy to understand and modify

## What You Lose from V2

### Complexity (Good riddance!)
- ❌ No more complex version tracking
- ❌ No more ID assignment system
- ❌ No more .counter/.versions files
- ❌ No more duplicate cleanup logic

### Advanced Features (May not need them)
- ❌ No major/minor version increments
- ❌ No file ID assignment
- ❌ No advanced error recovery
- ❌ No separate processing scripts

## Need Help?

1. **Test thoroughly** in a separate repository first
2. **Keep your V2 backup** until V3 is proven working
3. **Review the SETUP.md** guide for configuration help
4. **Check Actions logs** for detailed troubleshooting

Migration is straightforward - V3's simplicity makes it much easier to set up and maintain than V2! 🚀
