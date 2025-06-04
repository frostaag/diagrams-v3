# Setup Guide for Diagrams V3

## Quick Setup Checklist

### 1. Repository Variables
Go to **Settings** → **Secrets and variables** → **Actions** → **Variables**

Add these **Repository Variables**:
```
DIAGRAMS_SHAREPOINT_TENANT_ID = your-azure-tenant-id
DIAGRAMS_SHAREPOINT_CLIENT_ID = your-sharepoint-app-client-id  
DIAGRAMS_SHAREPOINT_DRIVE_ID = your-sharepoint-drive-id
DIAGRAMS_TEAMS_WEBHOOK = your-teams-webhook-url (optional)
```

### 2. Repository Secrets
Go to **Settings** → **Secrets and variables** → **Actions** → **Secrets**

Add this **Repository Secret**:
```
DIAGRAMS_SHAREPOINT_CLIENTSECRET = your-sharepoint-app-client-secret
```

### 3. Test the Setup
1. Add a `.drawio` file to the `drawio_files/` folder
2. Commit and push
3. Check the **Actions** tab for workflow execution
4. Verify PNG files are generated in `png_files/`
5. Check SharePoint for the uploaded changelog

## Getting SharePoint Values

### Tenant ID
1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **Azure Active Directory** → **Properties**
3. Copy the **Tenant ID**

### Client ID & Secret
1. In Azure Portal, go to **App registrations**
2. Create a new app or use existing one
3. Copy the **Application (client) ID**
4. Go to **Certificates & secrets** → **New client secret**
5. Copy the secret value immediately (you won't see it again)

### Drive ID
1. Go to your SharePoint site
2. Navigate to the Documents library where you want to upload
3. Use Graph Explorer or API to get the drive ID:
   ```
   GET https://graph.microsoft.com/v1.0/sites/{site-id}/drives
   ```

### App Permissions Required
In Azure Portal, for your app registration:
1. Go to **API permissions**
2. Add **Microsoft Graph** permissions:
   - `Sites.ReadWrite.All` (Application permission)
   - `Files.ReadWrite.All` (Application permission)
3. **Grant admin consent**

## Getting Teams Webhook (Optional)

1. In Microsoft Teams, go to the channel where you want notifications
2. Click **...** → **Connectors** → **Incoming Webhook**
3. Configure the webhook and copy the URL
4. Add it as `DIAGRAMS_TEAMS_WEBHOOK` repository variable

## Directory Structure After Setup

```
diagrams-v3/
├── drawio_files/
│   └── sample-diagram.drawio    # Your Draw.io files go here
├── png_files/                  # Generated automatically
│   ├── CHANGELOG.csv           # Generated automatically
│   └── *.png                   # Generated PNG files
├── .github/workflows/
│   └── diagrams.yml            # The workflow file
├── README.md                   # Main documentation
└── SETUP.md                    # This file
```

## Testing the Workflow

### Method 1: Commit a Draw.io File
```bash
# Add your .drawio file
cp your-diagram.drawio diagrams-v3/drawio_files/

# Commit and push
cd diagrams-v3
git add .
git commit -m "Add new diagram"
git push
```

### Method 2: Manual Trigger
1. Go to GitHub → **Actions** tab
2. Click **Draw.io to PNG Processing V3**
3. Click **Run workflow**
4. Click the green **Run workflow** button

## Troubleshooting

### Workflow doesn't trigger
- Check that your `.drawio` files are in the `drawio_files/` directory
- Verify the file has the `.drawio` extension
- Make sure you've committed and pushed the changes

### SharePoint upload fails
- Verify all repository variables are set correctly
- Check that the SharePoint app has proper permissions
- Ensure the drive ID is correct
- Check the client secret is still valid (they expire)

### Teams notifications not working
- Verify the webhook URL is correct
- Check that the webhook is still active in Teams
- Ensure the webhook URL is set as a repository variable (not secret)

### PNG files not generated
- Check the Actions logs for detailed error messages
- Verify your `.drawio` files are valid (can be opened in Draw.io)
- Make sure Draw.io installation completed successfully in the workflow

## Example Repository Variables Configuration

```
Name: DIAGRAMS_SHAREPOINT_TENANT_ID
Value: 12345678-1234-1234-1234-123456789012

Name: DIAGRAMS_SHAREPOINT_CLIENT_ID  
Value: 87654321-4321-4321-4321-210987654321

Name: DIAGRAMS_SHAREPOINT_DRIVE_ID
Value: b!AbCdEfGhIjKlMnOpQrStUvWxYz1234567890

Name: DIAGRAMS_TEAMS_WEBHOOK
Value: https://outlook.office.com/webhook/your-webhook-id
```

## Support

If you run into issues:

1. Check the **Actions** tab for detailed workflow logs
2. Verify all variables and secrets are set correctly  
3. Test SharePoint access using Microsoft Graph Explorer
4. Review the troubleshooting section in README.md

Happy diagramming! 🎨
