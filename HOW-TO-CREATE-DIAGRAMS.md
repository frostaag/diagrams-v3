# How to Create Diagrams - Team Guide

## Overview
This guide explains how to create and manage diagrams using Draw.io with our automated GitHub workflow. All diagrams will be automatically converted to PNG files and uploaded to SharePoint when you commit them to the repository.

## Getting Started

### Prerequisites
- GitHub account with access to this repository
- Basic understanding of Git/GitHub workflow
- Access to draw.io (free online tool)

### Step-by-Step Process

#### 1. Access Draw.io
- Go to [draw.io](https://app.diagrams.net/) or [diagrams.net](https://www.diagrams.net/)
- Choose "GitHub" as your storage option when prompted
- Authenticate with your GitHub account
- Select this repository (`diagrams-v3`)

#### 2. File Naming Convention
**IMPORTANT:** All diagram files must follow this naming pattern: `x.y.z`

Where:
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

#### Examples of Good File Names:
- `1.1.Azure Cloud Strategy Overview.drawio`
- `2.3.Network Security Implementation Details.drawio`
- `3.2.SAP S4HANA Integration Architecture.drawio`
- `0.1.Enterprise Technology Landscape.drawio`

#### 3. Creating Your Diagram

1. **Start a New Diagram:**
   - Click "Create New Diagram"
   - Choose a template or start blank
   - Set the diagram name using our naming convention

2. **Design Your Diagram:**
   - Use appropriate shapes and connectors
   - Keep diagrams clean and readable
   - Add clear labels and descriptions
   - Use consistent colors and styling

3. **Save to GitHub:**
   - Click "File" → "Save As"
   - Choose "GitHub" as the location
   - Navigate to the `drawio_files/` folder
   - Use the correct naming convention
   - Add a meaningful commit message

#### 4. What Happens Next (Automatic)

Once you save/commit your diagram:

1. **Automatic Processing:**
   - GitHub workflow detects your new/changed diagram
   - Converts .drawio file to high-quality PNG
   - Updates the changelog with version tracking
   - Uploads files to SharePoint
   - Sends Teams notification

2. **File Locations:**
   - Original: `drawio_files/your-diagram.drawio`
   - Generated PNG: `png_files/your-diagram.png`
   - Changelog: `png_files/CHANGELOG.csv`

3. **Version Control:**
   - Each update automatically increments version numbers
   - Major changes (new features): x.0 → (x+1).0
   - Minor updates (modifications): x.y → x.(y+1)

## Best Practices

### Diagram Design
- **Keep it simple:** Focus on key components and relationships
- **Use standard symbols:** Stick to common architectural symbols
- **Label everything:** Every component should have a clear name
- **Group related items:** Use containers or colors to group related elements
- **Show data flow:** Use arrows to indicate direction and flow

### File Organization
- **One concept per diagram:** Don't try to show everything in one diagram
- **Progressive detail:** Start with level 1 (overview), then create level 2/3 for details
- **Consistent naming:** Always follow the x.y.z convention
- **Meaningful descriptions:** Make the 'z' part descriptive and searchable

### Version Management
- **Small, frequent updates:** Make incremental improvements
- **Clear commit messages:** Explain what changed and why
- **Review before saving:** Double-check your diagram before committing

## Troubleshooting

### Common Issues

**File not processing:**
- Check file name follows x.y.z convention exactly
- Ensure file is saved in `drawio_files/` folder
- Verify file extension is `.drawio`

**PNG not generated:**
- Wait 2-3 minutes for processing to complete
- Check GitHub Actions tab for any errors
- Verify the workflow completed successfully

**Teams notification not received:**
- Notifications are sent after processing completes
- Check if Teams webhook is configured properly
- Look for notifications in the configured Teams channel

### Getting Help
- Check the GitHub Actions log for detailed error messages
- Review the CHANGELOG.csv for processing history
- Contact the repository maintainer for technical issues

## Teams Integration

### Notifications
You'll receive automatic Teams notifications when:
- ✅ Diagrams are successfully processed
- ❌ Processing fails
- 📊 Multiple diagrams are updated in one commit

### Notification Details Include:
- Diagram name and author
- Processing status and file counts
- Commit information and links
- Direct links to view results

## SharePoint Integration

### Automatic Uploads
- Changelog automatically uploaded to SharePoint
- Files organized in "Diagrams" folder
- Maintains version history
- Accessible through configured SharePoint site

### File Structure in SharePoint:
```
SharePoint Site/
└── Diagrams/
    └── Diagrams_Changelog.csv
```

## FAQ

**Q: Can I edit existing diagrams?**
A: Yes! Just open the .drawio file from GitHub in draw.io, make changes, and save. The system will automatically increment the version.

**Q: What if I make a mistake in the file name?**
A: You can rename files in GitHub or draw.io. The system will process the renamed file as a new version.

**Q: Can I create diagrams offline?**
A: Yes, you can use draw.io desktop app, but you'll need to manually upload files to the `drawio_files/` folder in GitHub.

**Q: How do I know my diagram was processed successfully?**
A: Check for:
- Teams notification (if configured)
- New PNG file appears in `png_files/` folder
- Entry added to CHANGELOG.csv

**Q: Can I collaborate on diagrams?**
A: Yes! Multiple people can edit the same diagram file. Use Git's collaboration features and clear commit messages.

## Support

For technical issues or questions:
1. Check GitHub Actions logs first
2. Review this guide
3. Contact repository maintainer
4. Submit issues through GitHub Issues

---

*Last updated: January 2025*
*Repository: diagrams-v3*
