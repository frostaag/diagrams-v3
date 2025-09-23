# Diagram ID System Documentation

## 🎯 **Overview**

This document describes the automatic diagram ID assignment system that provides unique, stable identifiers for all diagrams while maintaining your existing naming conventions.

## 🆔 **ID System Design**

### **ID Format**
- **Pattern**: `001_original_filename.drawio`
- **Structure**: `{3-digit-ID}_{your-original-filename}`
- **Examples**:
  - `001_3.1. SAP Task Center.drawio`
  - `002_0.2. FRoSTA Azure.drawio`
  - `003_3.2. Business Partner - Seeburger connection.drawio`

### **Key Benefits**
- ✅ **Stable IDs**: Never change, even if you rename files
- ✅ **Automatic Assignment**: No manual work required
- ✅ **Preserves Your Naming**: Original `3.1.`, `0.2.` structure intact
- ✅ **Easy Lookup**: Search by ID (001, 002, etc.)
- ✅ **Backward Compatible**: Works with existing workflows

## 🚀 **How It Works**

### **For You (Zero Changes Required)**
1. **Create diagrams** as usual: `4.1. New Process Architecture.drawio`
2. **Save normally** in `drawio_files/` folder
3. **System automatically** assigns next ID and renames to `012_4.1. New Process Architecture.drawio`
4. **Everything else** works as before

### **Automatic Workflow Process**
```mermaid
graph TD
    A[You save: "4.1. New Process.drawio"] --> B[GitHub Workflow Detects New File]
    B --> C[Auto-assign next ID: 012]
    C --> D[Rename: "012_4.1. New Process.drawio"]
    D --> E[Update Registry]
    E --> F[Generate PNG: "012_4.1. New Process.png"]
    F --> G[Update Viewer with ID Display]
```

## 📋 **Registry System**

### **diagram-registry.json Structure**
```json
{
  "nextId": 12,
  "version": "1.0",
  "lastUpdated": "2024-06-27T13:00:00Z",
  "mappings": {
    "001": {
      "id": "001",
      "originalName": "3.1. SAP Task Center.drawio",
      "currentDrawioFile": "001_3.1. SAP Task Center.drawio",
      "currentPngFile": "001_3.1. SAP Task Center.png",
      "title": "SAP Task Center",
      "topic": 3,
      "level": 1,
      "created": "2024-01-01T00:00:00Z",
      "lastModified": "2024-06-27T13:00:00Z",
      "status": "active"
    }
  }
}
```

### **Registry Features**
- **Tracks all diagram IDs** and their current filenames
- **Maintains history** of file changes
- **Auto-updates** when files are renamed
- **Provides metadata** for each diagram

## 🔍 **Viewer Integration**

### **ID Display Features**
- **ID Badges**: Prominent blue badges showing "ID-001" on each diagram card
- **Search by ID**: Type "001" to find specific diagrams
- **Original Name Display**: Shows clean name without ID prefix
- **Easy Reference**: Copy/share diagram IDs for communication

### **Search Capabilities**
- **By ID**: `001`, `002`, `003`
- **By Description**: `SAP Task Center`
- **By Original Name**: `3.1. SAP Task Center`
- **By Filename**: Full filename search

## 🛠️ **Management Tools**

### **Manual ID Assignment Script**
```bash
# Run to assign IDs to existing files
./assign-diagram-ids.sh
```

### **Workflow Integration**
- **Automatic**: New files get IDs automatically via GitHub Actions
- **Registry Updates**: Maintains sync between files and registry
- **Error Handling**: Graceful handling of rename operations

## 📊 **Current ID Assignments**

| ID  | Original Name | Current File | Topic | Level |
|-----|---------------|--------------|-------|-------|
| 001 | 0.1. Monitoring Proposed Strategy | 001_0.1. Monitoring Proposed Strategy.drawio | Multi-tech | 1 |
| 002 | 0.2. FRoSTA Azure | 002_0.2. FRoSTA Azure.drawio | Multi-tech | 2 |
| 003 | 0.2. Seeburger Setup Over VPN | 003_0.2. Seeburger Setup Over VPN.drawio | Multi-tech | 2 |
| 004 | 0.2.External User Identity Provision Idea | 004_0.2.External User Identity Provision Idea.drawio | Multi-tech | 2 |
| 005 | 3.1. SAP Task Center | 005_3.1. SAP Task Center.drawio | SAP | 1 |
| 006 | 3.1.SAP BTP and Cloud | 006_3.1.SAP BTP and Cloud.drawio | SAP | 1 |
| 007 | 3.1.SAP Cloud Simplified | 007_3.1.SAP Cloud Simplified.drawio | SAP | 1 |
| 008 | 3.1.User Provisioning Strategy | 008_3.1.User Provisioning Strategy.drawio | SAP | 1 |
| 009 | 3.2.Business Partner - Seeburger connection | 009_3.2.Business Partner - Seeburger connection.drawio | SAP | 2 |
| 010 | 3.2.MyTime - Connection SAP-ATOSS | 010_3.2.MyTime - Connection SAP-ATOSS.drawio | SAP | 2 |
| 011 | 3.3. Workzone and Mobile Start | 011_3.3. Workzone and Mobile Start.drawio | SAP | 3 |

**Next Available ID**: 012

## 🔄 **File Operation Examples**

### **Creating New Diagram**
```bash
# You create:
drawio_files/4.1. New Authentication Flow.drawio

# System automatically renames to:
drawio_files/012_4.1. New Authentication Flow.drawio

# Registry updated with ID 012
# PNG generated as: 012_4.1. New Authentication Flow.png
```

### **Renaming Existing Diagram**
```bash
# You rename:
001_3.1. SAP Task Center.drawio
# to:
001_3.1. SAP Task Center Updated.drawio

# Registry automatically updates:
# - currentDrawioFile: "001_3.1. SAP Task Center Updated.drawio"
# - lastModified: current timestamp
# - ID 001 remains the same
```

### **SBPA Integration**
When requesting diagram changes via the "New Diagram Request" button:
- **Include diagram ID** in your request (e.g., "Please update diagram ID-005")
- **Clear identification** of which diagram needs changes
- **Workflow tracks** changes by ID

## 🚨 **Important Notes**

### **ID Persistence**
- **IDs NEVER change** once assigned
- **File renames** don't affect IDs
- **Registry maintains** complete history

### **Workflow Compatibility**
- **Existing workflows** continue to work
- **PNG generation** works with ID-prefixed files
- **Viewer displays** both IDs and clean names

### **Backup & Recovery**
- **Registry file** should be backed up
- **Lost registry** can be regenerated from existing files
- **IDs persist** in filenames even if registry is lost

## 🔧 **Troubleshooting**

### **Missing IDs**
```bash
# Check which files need IDs
./assign-diagram-ids.sh

# Force assignment to all files
git push  # Triggers automatic ID assignment
```

### **Registry Sync Issues**
```bash
# Regenerate registry from current files
./assign-diagram-ids.sh

# Commit and push changes
git add . && git commit -m "Sync registry" && git push
```

### **Viewer Not Showing IDs**
1. **Check registry exists**: `diagram-viewer/public/diagram-registry.json`
2. **Hard refresh browser**: Ctrl+F5
3. **Check console**: F12 → Console for errors

## 📈 **Future Enhancements**

### **Planned Features**
- **ID-based URL routing**: Direct links to diagrams by ID
- **Change history tracking**: Full audit trail of diagram changes
- **Bulk operations**: Rename/organize multiple diagrams by ID
- **API endpoints**: REST API for external integrations

### **Advanced Search**
- **Filter by ID range**: Show diagrams 001-010
- **Sort by ID**: Chronological order by creation
- **Export ID mappings**: CSV/JSON export for external tools

## ✅ **Implementation Status**

- ✅ **Registry system** created and populated
- ✅ **Automatic ID assignment** workflow integrated
- ✅ **Viewer UI updates** with ID display
- ✅ **Search functionality** enhanced for IDs
- ✅ **File management** tools created
- ✅ **Documentation** comprehensive and complete

The diagram ID system is now fully operational and ready for use!
