# Configuration Guide - Diagrams Automation System

## Overview
This guide explains how to configure all the variables and secrets needed for the complete diagrams automation system, including SharePoint integration, SAP BTP Document Management, and Teams notifications.

## Required Configuration

### GitHub Repository Variables (Organization Level)

Set these variables in your GitHub organization settings under "Variables":

#### Teams Notifications
```
DIAGRAMS_TEAMS_NOTIFICATION_WEBHOOK
```
- **Description**: Microsoft Teams webhook URL for notifications
- **Value**: Your Teams channel webhook URL
- **Example**: `https://outlook.office.com/webhook/...`
- **Required**: Optional (notifications won't work without it)

#### SharePoint Integration
```
DIAGRAMS_SHAREPOINT_TENANT_ID
DIAGRAMS_SHAREPOINT_CLIENT_ID  
DIAGRAMS_SHAREPOINT_URL
DIAGRAMS_SHAREPOINT_DRIVE_ID
```
- **DIAGRAMS_SHAREPOINT_TENANT_ID**: Your Azure AD tenant ID
- **DIAGRAMS_SHAREPOINT_CLIENT_ID**: Azure app registration client ID
- **DIAGRAMS_SHAREPOINT_URL**: SharePoint site URL (e.g., `https://company.sharepoint.com/sites/sitename`)
- **DIAGRAMS_SHAREPOINT_DRIVE_ID**: SharePoint drive ID (optional, will auto-discover if not set)

#### SAP BTP Document Management
```
DIAGRAMS_SAP_BTP_TOKEN_URL
DIAGRAMS_SAP_BTP_CLIENT_ID
DIAGRAMS_SAP_BTP_DM_BASE_URL
DIAGRAMS_SAP_BTP_REPOSITORY_ID
```
- **DIAGRAMS_SAP_BTP_TOKEN_URL**: OAuth2 token endpoint for SAP BTP
- **DIAGRAMS_SAP_BTP_CLIENT_ID**: OAuth2 client ID for SAP BTP
- **DIAGRAMS_SAP_BTP_DM_BASE_URL**: Document Management API base URL
- **DIAGRAMS_SAP_BTP_REPOSITORY_ID**: Repository ID (optional, uses default if not set)

**Example SAP BTP URLs:**
- Token URL: `https://your-subdomain.authentication.eu10.hana.ondemand.com/oauth/token`
- DM Base URL: `https://api-sdm-di.cfapps.eu10.hana.ondemand.com/v2`

### GitHub Repository Secrets

Set these secrets in your GitHub repository settings under "Secrets and variables":

#### SharePoint Integration
```
DIAGRAMS_SHAREPOINT_CLIENTSECRET
```
- **Description**: Azure app registration client secret
- **Value**: The secret value from your Azure app registration

#### SAP BTP Document Management  
```
DIAGRAMS_SAP_BTP_CLIENT_SECRET
```
- **Description**: OAuth2 client secret for SAP BTP
- **Value**: The client secret from your SAP BTP service key

## Setup Instructions

### 1. Teams Notifications Setup

1. **Create Teams Webhook:**
   - Go to your Teams channel
   - Click "..." → "Connectors" → "Incoming Webhook"
   - Configure webhook with a name like "Diagrams Automation"
   - Copy the webhook URL

2. **Configure GitHub Variable:**
   ```
   Variable: DIAGRAMS_TEAMS_NOTIFICATION_WEBHOOK
   Value: [Your webhook URL]
   ```

### 2. SharePoint Integration Setup

1. **Create Azure App Registration:**
   - Go to Azure Portal → Azure Active Directory → App registrations
   - Create new registration with name like "Diagrams Automation"
   - Note the Application (client) ID and Directory (tenant) ID
   - Create a client secret under "Certificates & secrets"

2. **Grant SharePoint Permissions:**
   - In the app registration, go to "API permissions"
   - Add Microsoft Graph permissions:
     - `Sites.ReadWrite.All` (Application permission)
     - `Files.ReadWrite.All` (Application permission)
   - Grant admin consent

3. **Configure GitHub Variables:**
   ```
   DIAGRAMS_SHAREPOINT_TENANT_ID: [Your tenant ID]
   DIAGRAMS_SHAREPOINT_CLIENT_ID: [Your app client ID]
   DIAGRAMS_SHAREPOINT_URL: https://company.sharepoint.com/sites/sitename
   ```

4. **Configure GitHub Secret:**
   ```
   DIAGRAMS_SHAREPOINT_CLIENTSECRET: [Your app client secret]
   ```

### 3. SAP BTP Document Management Setup

1. **Create SAP BTP Service Instance:**
   - In SAP BTP cockpit, create a service instance of "Document Management Service, Integration Option"
   - Create a service key for the instance
   - Note the OAuth2 credentials from the service key

2. **Extract Configuration from Service Key:**
   From your service key JSON, extract:
   - `token_url` → Use for DIAGRAMS_SAP_BTP_TOKEN_URL  
   - `clientid` → Use for DIAGRAMS_SAP_BTP_CLIENT_ID
   - `clientsecret` → Use for DIAGRAMS_SAP_BTP_CLIENT_SECRET
   - `url` → Use for DIAGRAMS_SAP_BTP_DM_BASE_URL

3. **Configure GitHub Variables:**
   ```
   DIAGRAMS_SAP_BTP_TOKEN_URL: [token_url from service key]
   DIAGRAMS_SAP_BTP_CLIENT_ID: [clientid from service key]
   DIAGRAMS_SAP_BTP_DM_BASE_URL: [url from service key]
   ```

4. **Configure GitHub Secret:**
   ```
   DIAGRAMS_SAP_BTP_CLIENT_SECRET: [clientsecret from service key]
   ```

## File Naming Convention

All diagram files must follow this naming pattern: `x.y.z`

- **x** = Technology Stack ID:
  - `0` = Multi-tech / Cross-platform
  - `1` = Cloud (Microsoft/Google)  
  - `2` = Network architecture
  - `3` = SAP systems

- **y** = Detail Level:
  - `1` = High-level overview (broad, strategic view)
  - `2` = Intermediate detail (balanced technical depth)
  - `3` = Detailed technical (comprehensive, implementation-focused)

- **z** = Plain text description (use spaces, be descriptive)

### Examples:
- `1.1.Azure Cloud Strategy Overview.drawio`
- `3.2.SAP S4HANA Integration Architecture.drawio`  
- `2.3.Network Security Implementation Details.drawio`

## Workflow Behavior

### Automatic Processing
When you save a `.drawio` file to the `drawio_files/` folder:

1. **File Detection**: Workflow detects new/changed diagram files
2. **PNG Conversion**: Converts `.drawio` files to high-quality PNG images
3. **Version Management**: Automatically increments version numbers
4. **Changelog Update**: Updates `CHANGELOG.csv` with processing details
5. **SharePoint Upload**: Uploads changelog to SharePoint (if configured)
6. **SAP BTP Upload**: Uploads PNG files to SAP Document Management (if configured)
7. **Teams Notification**: Sends notification with diagram details (if configured)

### File Locations
- **Source**: `drawio_files/your-diagram.drawio`
- **Generated PNG**: `png_files/your-diagram.png`
- **Changelog**: `png_files/CHANGELOG.csv`
- **SharePoint**: `SharePoint Site/Diagrams/Diagrams_Changelog.csv`
- **SAP BTP**: `Document Management/Diagrams/your-diagram.png`

## Troubleshooting

### Common Issues

**Teams notifications not received:**
- Check webhook URL is correct and active
- Verify `DIAGRAMS_TEAMS_NOTIFICATION_WEBHOOK` variable is set
- Check GitHub Actions logs for HTTP errors

**SharePoint upload fails:**
- Verify Azure app has correct permissions
- Check tenant ID and client ID are correct
- Ensure client secret is not expired
- Verify SharePoint URL format

**SAP BTP upload fails:**
- Check service key is valid and not expired
- Verify token URL and client credentials
- Ensure Document Management service is accessible
- Check base URL format includes version (e.g., `/v2`)

**PNG files not generated:**
- Check `.drawio` files are in `drawio_files/` folder
- Verify file naming follows `x.y.z` convention
- Check GitHub Actions logs for conversion errors

### Debug Information

The workflow provides extensive debug logging. Check GitHub Actions logs for:
- Configuration status for each integration
- HTTP response codes and error messages
- File processing details
- Authentication status

### Support Contacts

For issues with:
- **GitHub Workflow**: Check repository issues or contact maintainer
- **SharePoint Integration**: Contact your Azure/Office 365 administrator  
- **SAP BTP Integration**: Contact your SAP BTP administrator
- **Teams Notifications**: Contact your Teams administrator

## Security Considerations

### Secrets Management
- Never commit secrets to Git repository
- Use GitHub secrets for sensitive values (passwords, client secrets)
- Use GitHub variables for non-sensitive configuration (URLs, IDs)
- Regularly rotate client secrets and service keys

### Permissions
- Grant minimum required permissions to Azure app registrations
- Use dedicated service accounts for SAP BTP integration
- Regularly review and audit access permissions
- Monitor authentication logs for suspicious activity

---

*Last updated: January 2025*
*For the diagrams-v3 repository automation system*
