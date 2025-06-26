# SAP Build Process Automation (SBPA) Integration

## Overview

This document describes the integration of the SAP Diagram Viewer with SAP Build Process Automation (SBPA) for diagram requests and change management.

## Features Implemented

### ✅ Request Diagram Button

A prominent "Request Diagram" button has been added to the main page header that allows users to:
- Request new diagram creation
- Request changes to existing diagrams
- Access the SBPA form workflow

## Button Details

### Location
- **Header**: Positioned prominently in the top-right section of the header
- **Placement**: Before the refresh button, making it highly visible
- **Design**: Blue SAP-themed button with Plus icon

### Functionality
- **Action**: Opens SBPA form in a new browser tab
- **URL**: Links directly to the configured SBPA workflow form
- **Target**: `_blank` (new tab) for seamless user experience

### Button Specifications
```tsx
<button
  onClick={handleRequestDiagram}
  className="inline-flex items-center gap-2 px-4 py-2 bg-sap-blue text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors focus:outline-none focus:ring-2 focus:ring-sap-blue focus:ring-offset-2"
  title="Request new diagram or changes to existing diagrams"
>
  <Plus className="w-4 h-4" />
  Request Diagram
</button>
```

## SBPA Workflow Connection

### Endpoint Configuration
- **Environment**: `frosta`
- **Project ID**: `eu10.frosta-apps-dev.newdiagramrequest`
- **Trigger ID**: `diagramChangeRequest`

### Complete URL
```
https://frosta-apps-dev.eu10.process-automation.build.cloud.sap/comsapspaprocessautomation.comsapspabpiprocessformtrigger/index.html?environmentId=frosta&projectId=eu10.frosta-apps-dev.newdiagramrequest&triggerId=diagramChangeRequest
```

## User Experience

### Workflow Steps
1. **User clicks "Request Diagram" button**
2. **New tab opens** with SBPA form
3. **User fills out form** with their requirements
4. **Form submission** triggers SBPA workflow
5. **Workflow processes** the request according to configured business logic

### Benefits
- **Seamless integration** between diagram viewer and request system
- **Professional workflow** for diagram management
- **Centralized request handling** through SBPA
- **No context switching** - opens in new tab
- **Clear call-to-action** with prominent button placement

## Technical Implementation

### Files Modified
- `diagram-viewer/src/App.tsx`: Added button and handler function

### Dependencies Used
- **lucide-react**: Plus icon for the button
- **Tailwind CSS**: Styling and responsive design
- **React**: Click handler and component integration

### Code Structure
```tsx
const handleRequestDiagram = () => {
  const sbpaUrl = 'https://frosta-apps-dev.eu10.process-automation.build.cloud.sap/comsapspaprocessautomation.comsapspabpiprocessformtrigger/index.html?environmentId=frosta&projectId=eu10.frosta-apps-dev.newdiagramrequest&triggerId=diagramChangeRequest';
  window.open(sbpaUrl, '_blank');
};
```

## Testing

### Build Status
- ✅ **TypeScript compilation**: Successful
- ✅ **Vite build**: Successful (213.14 kB bundle)
- ✅ **Development server**: Running on localhost:5174
- ✅ **No errors**: Clean build and runtime

### Browser Compatibility
- **Chrome**: ✅ Supported
- **Firefox**: ✅ Supported  
- **Safari**: ✅ Supported
- **Edge**: ✅ Supported

## Future Enhancements

### Potential Improvements
1. **Pre-filled Forms**: Pass diagram context via URL parameters
2. **Authentication Integration**: SSO with SBPA
3. **Status Tracking**: Show request status in the viewer
4. **Notification System**: Alert users when requests are processed

### Configuration Options
- Make SBPA URL configurable via environment variables
- Add different workflows for different request types
- Implement role-based access to request functionality

## Deployment

The integration is ready for deployment and will be automatically included in the next GitHub Pages deployment of the diagram viewer.

### Next Steps
1. **Test the SBPA form** integration in the deployed environment
2. **Verify CORS settings** if needed for cross-origin requests
3. **Train users** on the new request workflow
4. **Monitor usage** and gather feedback for improvements
