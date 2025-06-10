# Diagrams Automation System V3

Automated Draw.io to PNG conversion with enterprise integrations for SharePoint, SAP BTP Document Management, and Teams notifications.

## 🚀 Features

- **Automatic PNG Conversion**: Convert Draw.io files to high-quality PNG images
- **Smart File Detection**: Only processes changed files for efficiency
- **Version Management**: Automatic version incrementing with changelog tracking
- **SharePoint Integration**: Upload changelog to SharePoint document libraries
- **SAP BTP Integration**: Upload PNG files to SAP Document Management Service
- **Teams Notifications**: Rich notifications with diagram details and links
- **Naming Convention**: Structured file naming for technology stacks and detail levels

## 📁 Repository Structure

```
diagrams-v3/
├── .github/workflows/
│   └── diagrams.yml           # Main workflow automation
├── drawio_files/              # Source .drawio files (input)
│   └── [x.y.description].drawio
├── png_files/                 # Generated PNG files (output)
│   ├── [x.y.description].png
│   └── CHANGELOG.csv         # Processing history
├── HOW-TO-CREATE-DIAGRAMS.md # Team guide for creating diagrams
├── CONFIGURATION-GUIDE.md    # Complete setup instructions
├── TEAMS_SETUP.md            # Teams integration guide
└── README.md                 # This file
```

## 🎯 Quick Start

### For Diagram Creators

1. **Create Diagram**: Use [draw.io](https://app.diagrams.net/) connected to this GitHub repository
2. **Follow Naming**: Use pattern `x.y.description.drawio` (see [naming guide](HOW-TO-CREATE-DIAGRAMS.md))
3. **Save to Repository**: Save files in the `drawio_files/` folder
4. **Automatic Processing**: Workflow automatically converts to PNG and manages versions

### For Administrators

1. **Configure Variables**: Set up GitHub organization variables (see [Configuration Guide](CONFIGURATION-GUIDE.md))
2. **Set Secrets**: Add required secrets for integrations
3. **Test Workflow**: Create a test diagram to verify all integrations work
4. **Train Team**: Share the [How-To Guide](HOW-TO-CREATE-DIAGRAMS.md) with your team

## 📋 File Naming Convention

**Pattern**: `x.y.description.drawio`

### Technology Stack IDs (x):
- `0` = Multi-tech / Cross-platform
- `1` = Cloud (Microsoft/Google)
- `2` = Network architecture  
- `3` = SAP systems

### Detail Levels (y):
- `1` = High-level overview
- `2` = Intermediate detail
- `3` = Detailed technical

### Examples:
- `1.1.Azure Cloud Strategy Overview.drawio`
- `3.2.SAP S4HANA Integration Architecture.drawio`
- `2.3.Network Security Implementation Details.drawio`

## 🔧 Configuration Required

### GitHub Variables (Organization Level)
```
DIAGRAMS_TEAMS_NOTIFICATION_WEBHOOK     # Teams webhook URL
DIAGRAMS_SHAREPOINT_TENANT_ID           # Azure AD tenant ID
DIAGRAMS_SHAREPOINT_CLIENT_ID           # Azure app client ID
DIAGRAMS_SHAREPOINT_URL                 # SharePoint site URL
DIAGRAMS_SAP_BTP_TOKEN_URL              # SAP BTP OAuth token URL
DIAGRAMS_SAP_BTP_CLIENT_ID              # SAP BTP client ID
DIAGRAMS_SAP_BTP_DM_BASE_URL            # SAP Document Management API URL
```

### GitHub Secrets (Repository Level)
```
DIAGRAMS_SHAREPOINT_CLIENTSECRET        # Azure app client secret
DIAGRAMS_SAP_BTP_CLIENT_SECRET          # SAP BTP client secret
```

## 🔄 Workflow Process

When you save a `.drawio` file:

1. **🔍 Detection**: GitHub Actions detects new/changed diagram files
2. **🎨 Conversion**: Converts `.drawio` to high-quality PNG (2x scale)
3. **📊 Versioning**: Automatically increments version numbers
4. **📝 Changelog**: Updates processing history with metadata
5. **☁️ SharePoint**: Uploads changelog to SharePoint (if configured)
6. **🔗 SAP BTP**: Uploads PNG files to Document Management (if configured)
7. **📢 Teams**: Sends rich notification with diagram details (if configured)
8. **💾 Commit**: Commits all generated files back to repository

## 📖 Documentation

- **[How to Create Diagrams](HOW-TO-CREATE-DIAGRAMS.md)**: Complete guide for team members
- **[Configuration Guide](CONFIGURATION-GUIDE.md)**: Setup instructions for all integrations
- **[Teams Setup](TEAMS_SETUP.md)**: Specific guidance for Teams notifications

## 🔧 Integrations

### Microsoft Teams
- Rich notifications with diagram details
- Success/failure status with file counts
- Direct links to workflow runs and commits
- Parsed diagram names showing technology and detail level

### SharePoint
- Automatic changelog upload to designated folder
- Creates "Diagrams" folder if it doesn't exist
- Supports both site-specific and drive-specific uploads
- Comprehensive error handling with multiple fallback methods

### SAP BTP Document Management
- PNG file upload to structured folder hierarchy
- Automatic folder creation for organization
- OAuth2 authentication with service keys
- Metadata inclusion for searchability

## 🚦 Status Indicators

The workflow provides detailed status information:

- ✅ **Success**: All files processed successfully
- ⚠️ **Partial**: Some files processed, some failed
- ❌ **Failed**: No files processed successfully
- 📊 **Counts**: Number of files processed vs failed

## 🔐 Security

- Uses GitHub secrets for sensitive credentials
- OAuth2 authentication for external services
- Minimum required permissions for integrations
- No secrets exposed in logs or workflow outputs

## 🐛 Troubleshooting

### Common Issues

**Files not processing:**
- Check file naming follows `x.y.description.drawio` pattern
- Ensure files are in `drawio_files/` folder
- Verify file actually changed in the commit

**Integration failures:**
- Check GitHub Actions logs for detailed error messages
- Verify all required variables and secrets are set
- Confirm external service credentials are valid

**Teams notifications not received:**
- Verify webhook URL is correct and active
- Check Teams channel allows webhook connectors

### Debug Information

The workflow provides extensive logging:
- Configuration status for each integration
- File processing details and timings
- HTTP response codes and error messages
- Authentication and authorization status

## 📊 Example Output

### Generated Files
```
png_files/
├── 1.1.Azure Cloud Strategy Overview.png
├── 3.2.SAP S4HANA Integration Architecture.png
└── CHANGELOG.csv
```

### Changelog Entry
```csv
Date,Time,Diagram,Action,Version,Commit,Author,CommitMessage
06.01.2025,14:30:15,"1.1.Azure Cloud Strategy Overview","Converted to PNG","1.0","a1b2c3d","John Doe","Added new cloud architecture diagram"
```

### Teams Notification
```
📊 Draw.io Processing Complete
Status: ✅ Success - Successfully processed 1 diagram(s)

📋 Processing Details
👤 Author: John Doe
📝 Commit: a1b2c3d
💬 Message: Added new cloud architecture diagram
📊 Diagram: 📊 Azure Cloud Strategy Overview (Cloud, High-level)
✅ Processed: 1
❌ Failed: 0
🔄 Run: #42
```

## 🤝 Contributing

1. Test changes with the manual workflow dispatch first
2. Follow the established naming convention
3. Update documentation if adding new features
4. Ensure all integrations continue to work

## 📄 License

This project is designed for enterprise use with draw.io diagrams automation.

---

**Version**: 3.0  
**Last Updated**: January 2025  
**Compatibility**: GitHub Actions, Draw.io, SharePoint, SAP BTP, Microsoft Teams
