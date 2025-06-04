# Draw.io Files Processing V3 - Ultra Simplified

This is a **completely redesigned and ultra-simplified** workflow for processing Draw.io diagram files. V3 focuses on the core requirements with maximum simplicity and reliability.

## ✨ What V3 Does (Simple & Clean)

1. **🔄 Converts Draw.io to PNG** - Automatically converts .drawio files to PNG on commit
2. **📋 Updates Changelog** - Tracks all changes in a simple CSV format
3. **☁️ Uploads to SharePoint** - Sends changelog to SharePoint using repository variables
4. **📢 Teams Notifications** - Sends processing results to Microsoft Teams

## 🚀 Key Simplifications in V3

- **No complex ID assignment** - Files keep their original names
- **No version tracking files** - Simple version 1.0 for all entries
- **No separate scripts** - Everything in one workflow file
- **No cleanup logic** - Clean, straightforward processing
- **Unified job structure** - Process and notify in separate jobs

## 📁 Project Structure

```
drawio_files/          # Your Draw.io files (.drawio)
png_files/             # Generated PNG files
├── CHANGELOG.csv      # Simple processing log
└── *.png              # Converted diagrams
.github/workflows/
└── diagrams.yml       # Single workflow file
```

## 🔧 Setup Requirements

### Repository Variables (Required)
- `DIAGRAMS_SHAREPOINT_TENANT_ID` - Your Azure tenant ID
- `DIAGRAMS_SHAREPOINT_CLIENT_ID` - SharePoint app client ID  
- `DIAGRAMS_SHAREPOINT_DRIVE_ID` - SharePoint drive ID

### Repository Secrets (Required)
- `DIAGRAMS_SHAREPOINT_CLIENTSECRET` - SharePoint app client secret

### Optional (Teams Notifications)
- `DIAGRAMS_TEAMS_WEBHOOK` - Teams webhook URL (repository variable)

## 🚀 Quick Deployment

### Option 1: Automated Deployment Script
```bash
# Clone the repository
git clone https://github.com/your-username/diagrams-v3.git
cd diagrams-v3

# Run the deployment script
./deploy-to-github.sh
```

The script will:
- Check your git configuration
- Commit any uncommitted changes
- Add GitHub remote (if not exists)
- Push to GitHub
- Provide next steps for configuration

### Option 2: Manual Setup
1. Create a new GitHub repository
2. Clone this repository locally
3. Add your GitHub remote: `git remote add origin <your-repo-url>`
4. Push: `git push -u origin main`
5. Configure repository variables and secrets (see SETUP.md)

### Validation & Troubleshooting
```bash
# Validate your configuration
./validate-config.sh
```

This script checks:
- Directory structure
- Git configuration
- Workflow file validity
- Provides configuration checklist

## 🎯 How It Works

### 1. File Detection
- Triggered on commits to `drawio_files/**/*.drawio`
- Uses Git to detect changed files
- Processes all files on first run

### 2. PNG Conversion
- Uses Draw.io v26.2.2 for conversion
- 2.0x scale for high quality
- Simple success/failure tracking

### 3. Changelog Format
```csv
Date,Time,Diagram,Action,Version,Commit,Author
03.06.2025,14:30:15,"my-diagram","Converted to PNG","1.0","abc123","Lucas Dreger"
```

### 4. SharePoint Upload
- Uploads to: `/Diagrams/Diagrams_Changelog.csv`
- Uses Microsoft Graph API
- Automatic retry with continue-on-error

### 5. Teams Notification
- Separate job that runs after processing
- Shows success/failure status
- Includes file count and workflow link

## 🔄 Workflow Trigger Options

### Automatic (Recommended)
```bash
# Just commit your .drawio files
git add drawio_files/my-diagram.drawio
git commit -m "Add new diagram"
git push
```

### Manual Trigger
1. Go to **Actions** tab in GitHub
2. Select **Draw.io to PNG Processing V3**
3. Click **Run workflow**

## 📊 Monitoring

### GitHub Actions
- Check the **Actions** tab for workflow runs
- View detailed logs for each step
- Monitor processing statistics

### SharePoint
- Changelog automatically uploaded to SharePoint
- Available at: `Documents/Diagrams/Diagrams_Changelog.csv`

### Teams (Optional)
- Real-time notifications on processing status
- Includes links to workflow runs
- Shows file processing counts

## 🛠️ Configuration

All configuration is embedded in the workflow file with sensible defaults:

```yaml
env:
  DRAWIO_VERSION: "26.2.2"  # Draw.io version to use
```

PNG conversion settings are hardcoded for simplicity:
- **Scale**: 2.0x (high quality)
- **Format**: PNG
- **Quality**: Maximum

## 🔄 Migration from V2

V3 is a complete rewrite with simplified approach:

### Key Changes
- ❌ **Removed**: Complex ID assignment system
- ❌ **Removed**: Version tracking files (.versions, .counter)
- ❌ **Removed**: Separate shell scripts
- ❌ **Removed**: Duplicate cleanup logic
- ❌ **Removed**: Complex error handling
- ✅ **Added**: Simplified two-job workflow (process + notify)
- ✅ **Added**: Streamlined changelog format
- ✅ **Added**: Direct SharePoint integration in workflow

### What Stays the Same
- ✅ Draw.io file detection and conversion
- ✅ SharePoint upload functionality  
- ✅ Teams notifications
- ✅ Changelog tracking
- ✅ Repository variables/secrets usage

## 🎯 Use Cases

**Perfect for:**
- Simple diagram processing workflows
- Teams that want reliable PNG generation
- Projects that need SharePoint integration
- Minimal maintenance overhead

**Consider V2 if you need:**
- Complex versioning schemes
- File ID assignment logic
- Advanced error recovery
- Custom processing scripts

## 🚦 Troubleshooting

### Common Issues

1. **No PNGs generated**
   - Check if .drawio files are valid
   - Verify workflow triggered correctly
   - Review Actions logs for errors

2. **SharePoint upload fails**
   - Verify all repository variables are set
   - Check client secret is valid
   - Ensure drive ID is correct

3. **Teams notifications not working**
   - Verify webhook URL is set in repository variables
   - Check webhook is active in Teams

### Debug Steps

1. **Check workflow logs**
   ```
   Actions → Latest run → View details
   ```

2. **Verify file changes**
   ```bash
   git log --oneline -- drawio_files/
   ```

3. **Test SharePoint access**
   - Verify tenant/client IDs in repository settings
   - Check app permissions in Azure

## 📈 Performance

- **Typical processing time**: 2-3 minutes per workflow run
- **Concurrent processing**: Files processed sequentially for reliability
- **Resource usage**: Standard GitHub Actions runner
- **Rate limits**: Respects GitHub and SharePoint API limits

## 🤝 Contributing

V3 prioritizes simplicity over features:

1. Keep the single workflow file approach
2. Avoid adding external dependencies
3. Maintain the simple changelog format
4. Test changes with sample .drawio files
5. Update documentation for any changes

---

**Version**: 3.0  
**Status**: Production Ready  
**Philosophy**: Simplicity over complexity  
**Last Updated**: June 2025
