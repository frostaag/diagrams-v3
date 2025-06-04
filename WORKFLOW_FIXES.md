# Draw.io Workflow Fixes - V3

## 🐛 Issues Identified

Based on the GitHub Actions log analysis, the workflow was failing due to several issues:

1. **File Detection Problem**: The workflow wasn't detecting .drawio files for processing
2. **Command Syntax Issues**: Incorrect draw.io CLI parameters
3. **Missing Debug Information**: No visibility into what was happening during execution
4. **Teams Notification Logic**: Only ran when specific variables were set
5. **SharePoint Upload**: Missing error handling and feedback

## ✅ Fixes Applied

### 1. Enhanced File Detection Logic

**Problem**: The git diff command wasn't finding changed files properly, especially on first runs or manual triggers.

**Solution**: Implemented a robust fallback system:
```bash
# Check git diff for changes
if git rev-parse --verify HEAD^ >/dev/null 2>&1; then
  changed_files=$(git diff --name-only --diff-filter=AM HEAD^ HEAD -- "drawio_files/**/*.drawio")
fi

# Fallback 1: Process all files if no changes detected
if [[ -z "$changed_files" ]]; then
  changed_files=$(find drawio_files -name "*.drawio" -type f)
fi

# Fallback 2: Handle manual workflow dispatch
if [[ -z "$changed_files" && "${{ github.event_name }}" == "workflow_dispatch" ]]; then
  changed_files=$(find drawio_files -name "*.drawio" -type f)
fi
```

### 2. Fixed Draw.io Command Syntax

**Problem**: Using incorrect command-line parameters for draw.io export.

**Solution**: Updated to use the correct short-form parameters:
```bash
# Before (incorrect)
drawio --export --format png --scale 2 --output "$png_file" "$file"

# After (correct)
drawio -x -f png -s 2.0 -o "$png_file" "$file"
```

### 3. Added Comprehensive Debug Logging

**Problem**: No visibility into the conversion process.

**Solution**: Added detailed logging throughout the workflow:
- 🔍 Debug messages for file detection
- 📊 File processing status
- ✅/❌ Success/failure indicators with file sizes
- 📄 Changelog content preview
- 📁 Directory listings for verification

### 4. Improved Teams Notification Logic

**Problem**: Teams notifications only ran when webhook variable was configured.

**Solution**: 
- Notification job now always runs (`if: always()`)
- Graceful handling when webhook is not configured
- Better error messages and status reporting
- Added more detailed facts (processed count, failed count, branch name)

### 5. Enhanced Error Handling

**Problem**: Limited error handling and recovery.

**Solution**:
- Added `continue-on-error: true` for optional steps
- Better file existence checks
- Comprehensive error logging
- Separate tracking of processed vs failed files

### 6. Improved Xvfb Configuration

**Problem**: Basic xvfb setup might not work reliably.

**Solution**: Enhanced xvfb with proper screen configuration:
```bash
xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" drawio ...
```

## 🧪 Testing

Created `trigger-workflow-test.sh` script to easily test the workflow:

```bash
./trigger-workflow-test.sh
```

This script:
1. Updates a .drawio file timestamp
2. Commits and pushes the change
3. Provides monitoring instructions
4. Lists expected outcomes

## 📋 Expected Workflow Behavior

### Successful Run Should:
1. **Setup Phase**: Install draw.io and dependencies
2. **Detection Phase**: Find .drawio files to process (with debug output)
3. **Conversion Phase**: Convert files to PNG with progress updates
4. **Verification Phase**: Check file sizes and validate outputs
5. **Commit Phase**: Add generated files to repository
6. **Upload Phase**: Send changelog to SharePoint (if configured)
7. **Notification Phase**: Send Teams notification with summary

### Debug Output Will Show:
- 🔍 File detection process
- 📊 List of files to process
- 🔄 Individual file conversion status
- ✅ Success confirmations with file sizes
- ❌ Error messages with specific failure reasons
- 📄 Changelog content preview

## 🔧 Configuration Requirements

### Required Variables (Repository Settings > Variables):
- None (workflow runs without external configuration)

### Optional Variables for Enhanced Features:
- `DIAGRAMS_TEAMS_WEBHOOK`: Teams webhook URL for notifications
- `DIAGRAMS_SHAREPOINT_TENANT_ID`: SharePoint tenant ID
- `DIAGRAMS_SHAREPOINT_CLIENT_ID`: SharePoint application ID
- `DIAGRAMS_SHAREPOINT_DRIVE_ID`: SharePoint drive ID

### Required Secrets (Repository Settings > Secrets):
- `DIAGRAMS_SHAREPOINT_CLIENTSECRET`: SharePoint application secret

## 🎯 Next Steps

1. **Test the fixes**:
   ```bash
   ./trigger-workflow-test.sh
   ```

2. **Monitor the workflow** in GitHub Actions to verify:
   - PNG files are generated in `png_files/` directory
   - Changelog is updated with new entries
   - Files are committed back to repository
   - Teams notification is sent (if configured)

3. **Configure optional integrations** (Teams, SharePoint) if needed

4. **Verify generated PNG files** have correct content and quality

## 🔍 Troubleshooting

If issues persist, check the workflow logs for:
- **File detection**: Look for "Debug: Found all files" messages
- **Conversion errors**: Check for draw.io command output
- **Permission issues**: Verify repository has write permissions
- **Network issues**: Check SharePoint/Teams connectivity

The enhanced logging will provide clear indicators of where any problems occur.
