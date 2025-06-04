# Teams Notification Setup Guide

## Overview
This guide explains how to configure Microsoft Teams notifications for the Draw.io to PNG workflow.

## Prerequisites
- Microsoft Teams admin access or ability to create webhooks
- GitHub repository admin access

## Step 1: Create Teams Webhook

### Option A: Using Teams (Recommended)
1. **Open Microsoft Teams**
2. **Navigate to the channel** where you want to receive notifications
3. **Click the three dots (...)** next to the channel name
4. **Select "Connectors"**
5. **Find "Incoming Webhook"** and click "Configure"
6. **Provide a name** (e.g., "Draw.io Diagrams")
7. **Upload an icon** (optional)
8. **Click "Create"**
9. **Copy the webhook URL** (starts with `https://outlook.office.com/webhook/...`)

### Option B: Using Power Automate
1. **Go to** [Power Automate](https://make.powerautomate.com/)
2. **Create a new flow** with "When an HTTP request is received" trigger
3. **Add "Post message in a chat or channel" action**
4. **Configure to post to your desired Teams channel**
5. **Copy the HTTP POST URL**

## Step 2: Configure GitHub Repository

1. **Go to your GitHub repository**
2. **Navigate to** Settings → Secrets and variables → Variables
3. **Click "New repository variable"**
4. **Set the following:**
   - **Name:** `DIAGRAMS_TEAMS_WEBHOOK`
   - **Value:** Your webhook URL from Step 1

## Step 3: Test the Configuration

1. **Run the workflow** by making a change to a .drawio file
2. **Check the workflow logs** for Teams notification status
3. **Verify the message appears** in your Teams channel

## Expected Notification Format

The Teams notification will include:
- **Status**: ✅ Success or ❌ Failed
- **Files Processed**: Number of diagrams converted
- **Files Failed**: Number of conversion failures
- **Workflow Run**: GitHub Actions run number
- **Branch**: Git branch name
- **Action Button**: Link to view the workflow run details

## Troubleshooting

### Webhook Not Configured
If you see this message in the logs:
```
⚠️ Teams webhook not configured (DIAGRAMS_TEAMS_WEBHOOK variable missing)
```

**Solution**: Follow Step 2 above to add the repository variable.

### HTTP Error Codes
- **400 Bad Request**: Invalid JSON payload or webhook URL
- **401 Unauthorized**: Webhook URL is invalid or expired
- **404 Not Found**: Webhook endpoint doesn't exist
- **429 Too Many Requests**: Rate limit exceeded

### Webhook URL Format
Ensure your webhook URL follows one of these patterns:
- Teams: `https://outlook.office.com/webhook/...`
- Power Automate: `https://prod-XX.westus2.logic.azure.com/...`

## Security Notes

- ✅ The webhook URL is stored as a repository variable (visible to collaborators)
- ✅ No sensitive data is sent in the notification
- ✅ The workflow only sends summary information
- ⚠️ Keep the webhook URL secure - don't share it publicly

## Advanced Configuration

### Custom Message Format
To customize the notification message, modify the JSON payload in `.github/workflows/diagrams.yml`:

```bash
-d "{
  \"@type\": \"MessageCard\",
  \"title\": \"Your Custom Title\",
  \"text\": \"Your custom message\",
  ...
}"
```

### Multiple Webhooks
To send notifications to multiple Teams channels:
1. Create additional repository variables (e.g., `DIAGRAMS_TEAMS_WEBHOOK_2`)
2. Modify the workflow to loop through multiple webhooks

## Testing

You can test the Teams integration by:
1. Running `./trigger-workflow-test.sh`
2. Manually triggering the workflow from GitHub Actions
3. Making any change to a .drawio file and pushing it

The notification should appear in your Teams channel within a few seconds of the workflow completing.
