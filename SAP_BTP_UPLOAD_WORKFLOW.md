# SAP BTP Document Management Upload Workflow

This document describes the dedicated workflow for uploading PNG diagrams to SAP BTP Document Management Service.

## Overview

The `sap-btp-upload.yml` workflow is a standalone workflow specifically designed to upload PNG files from the `png_files/` directory to your SAP BTP Document Management Service. It operates independently from the main diagram processing workflow to ensure reliability and separation of concerns.

## Features

✅ **Multiple Trigger Options**
- Manual trigger with upload mode selection
- Automatic daily uploads (9 AM UTC)
- Triggered by PNG file changes

✅ **Smart Upload Logic**
- Upload all files or recent files only
- Duplicate detection and handling
- Repository-specific folder organization

✅ **Robust Authentication**
- Multiple OAuth2 authentication methods
- Comprehensive error handling and troubleshooting
- Detailed logging and debugging

✅ **Teams Integration**
- Real-time notifications with upload status
- Detailed upload statistics
- Direct links to workflow runs

## Configuration

### Required GitHub Variables

Set these in your repository: **Settings → Secrets and variables → Actions → Variables**

| Variable | Description | Example |
|----------|-------------|---------|
| `DIAGRAMS_SAP_BTP_TOKEN_URL` | OAuth2 token endpoint | `https://frosta-apps-dev.authentication.eu10.hana.ondemand.com/oauth/token` |
| `DIAGRAMS_SAP_BTP_CLIENT_ID` | OAuth2 client ID from service key | `sb-a89eef4d-1cc2-4171-a69a-19fd2b4dbaa9!b523612\|sdm-di-SDM_DI_PROD-prod!b41064` |
| `DIAGRAMS_SAP_BTP_DM_BASE_URL` | Document Management API base URL | `https://api-sdm-di.cfapps.eu10.hana.ondemand.com` |
| `DIAGRAMS_SAP_BTP_REPOSITORY_ID` | Repository ID (optional but recommended) | `06b87f25-1e4e-4dfb-8fbb-e5132d74f064` |
| `DIAGRAMS_TEAMS_NOTIFICATION_WEBHOOK` | Teams webhook URL (optional) | `https://yourcompany.webhook.office.com/webhookb2/...` |

### Required GitHub Secret

Set this in your repository: **Settings → Secrets and variables → Actions → Secrets**

| Secret | Description | Example |
|--------|-------------|---------|
| `DIAGRAMS_SAP_BTP_CLIENT_SECRET` | OAuth2 client secret from service key | `2c7ee8e5-794e-419e-96a8-01aa08ca82d5$TyiKc7U...` |

## Usage

### 1. Manual Trigger

**Option A: Using GitHub Web Interface**
1. Go to **Actions** tab in your repository
2. Select **"SAP BTP Document Management Upload"** workflow
3. Click **"Run workflow"**
4. Choose upload mode:
   - ✅ **Upload all PNG files**: Uploads every PNG in `png_files/`
   - ❌ **Upload recent files only**: Uploads files modified in last 24 hours

**Option B: Using Command Line**
```bash
# Upload all files
./trigger-sap-btp-upload.sh

# Or use GitHub CLI directly
gh workflow run sap-btp-upload.yml -f upload_all=true
gh workflow run sap-btp-upload.yml -f upload_all=false
```

### 2. Automatic Triggers

**Daily Schedule**
- Runs every day at 9 AM UTC
- Uploads files modified in the last 24 hours
- Perfect for regular maintenance and sync

**PNG File Changes**
- Triggered when PNG files are added/modified in `png_files/`
- Automatically uploads the changed files
- Ideal for immediate uploads after diagram generation

### 3. Monitoring

**Teams Notifications** (if configured)
- Real-time status updates
- Upload statistics and error reports
- Direct links to workflow runs and logs

**GitHub Actions Interface**
```bash
# View recent runs
gh run list --workflow=sap-btp-upload.yml

# Watch a specific run
gh run watch [RUN_ID]

# View logs
gh run view [RUN_ID] --log
```

## Workflow Behavior

### Upload Logic

1. **File Selection**
   - **All files mode**: Uploads every PNG in `png_files/`
   - **Recent files mode**: Uploads files modified in last 24 hours
   - **Push trigger**: Uploads files changed in the specific commit

2. **Folder Management**
   - Creates "Diagrams" folder in SAP DM if it doesn't exist
   - Uses repository-specific paths when `REPOSITORY_ID` is configured
   - Falls back to generic root access if needed

3. **File Upload Process**
   - Creates document object with metadata
   - Uploads binary PNG content
   - Provides detailed progress logging
   - Handles errors gracefully

### Status Reporting

The workflow provides comprehensive status reporting:

| Status | Description | Teams Color |
|--------|-------------|-------------|
| ✅ **Success** | All files uploaded successfully | Green |
| ⚠️ **Partial Success** | Some files uploaded, some failed | Yellow |
| ❌ **Failed** | No files could be uploaded | Red |
| 🔧 **Not Configured** | Missing required configuration | Gray |
| ℹ️ **No Files** | No files found to upload | Blue |

## Troubleshooting

### Authentication Issues

**HTTP 401 - Bad Credentials**
```
🔧 Check:
• Client ID matches service key exactly (including !|! characters)
• Client Secret is complete and correct
• No extra spaces in GitHub variables
• Credentials haven't expired
```

**HTTP 404 - Not Found**
```
🔧 Check:
• Token URL is correct for your subaccount region
• SAP BTP service is running and accessible
• Network connectivity from GitHub Actions
```

### Upload Issues

**No Files Found**
```
🔧 Check:
• png_files/ directory exists
• PNG files are present in the directory
• File permissions are correct
• Upload mode matches your intent (all vs recent)
```

**Folder Creation Failed**
```
🔧 Check:
• Repository ID is correct (if configured)
• Document Management service permissions
• API endpoint accessibility
• Existing folder conflicts
```

### Configuration Validation

Use the verification script to test your setup:

```bash
# Test credentials and API access
./verify-sap-credentials.sh

# Check configuration
./validate-config.sh
```

## Integration with Main Workflow

The SAP BTP upload workflow is designed to work alongside the main `diagrams.yml` workflow:

1. **Main workflow** (`diagrams.yml`):
   - Processes .drawio files
   - Generates PNG files
   - Commits to repository
   - Uploads to SharePoint

2. **SAP BTP workflow** (`sap-btp-upload.yml`):
   - Reads PNG files from repository
   - Uploads to SAP BTP Document Management
   - Sends Teams notifications
   - Operates independently

This separation ensures:
- ✅ Main workflow stability
- ✅ Independent error handling
- ✅ Flexible upload scheduling
- ✅ Clear responsibility separation

## Service Key Reference

Your SAP BTP Document Management service key should look like this:

```json
{
  "uri": "https://api-sdm-di.cfapps.eu10.hana.ondemand.com/",
  "uaa": {
    "clientid": "sb-[uuid]![service]|[plan]![instance]",
    "clientsecret": "[secret-with-special-chars]",
    "url": "https://[subdomain].authentication.[region].hana.ondemand.com"
  }
}
```

**GitHub Variable Mapping:**
- `uri` → `DIAGRAMS_SAP_BTP_DM_BASE_URL` (remove trailing slash)
- `uaa.clientid` → `DIAGRAMS_SAP_BTP_CLIENT_ID`
- `uaa.clientsecret` → `DIAGRAMS_SAP_BTP_CLIENT_SECRET`
- `uaa.url` + `/oauth/token` → `DIAGRAMS_SAP_BTP_TOKEN_URL`

## Support Files

- 📋 `SAP_BTP_AUTH_FIX.md` - Complete authentication troubleshooting guide
- 🔍 `verify-sap-credentials.sh` - Test credentials and API access
- 🚀 `trigger-sap-btp-upload.sh` - Easy workflow triggering
- ⚙️ `validate-config.sh` - Configuration validation

## Next Steps

1. **Configure GitHub variables** with your SAP BTP service key values
2. **Test the setup** using `./verify-sap-credentials.sh`
3. **Trigger a test upload** using `./trigger-sap-btp-upload.sh`
4. **Set up Teams notifications** (optional) for real-time updates
5. **Monitor daily uploads** to ensure automatic sync is working

The workflow is designed to be robust, informative, and easy to troubleshoot. All operations include detailed logging to help diagnose any issues quickly.
