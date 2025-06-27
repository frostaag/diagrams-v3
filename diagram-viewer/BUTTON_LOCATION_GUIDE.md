# "Request Diagram" Button Location Guide

## Where to Find the Button

The "Request Diagram" button is located in the **header** of the SAP Diagram Viewer page.

### Visual Layout
```
┌─────────────────────────────────────────────────────────────────────────────┐
│ Header (White background)                                                   │
│ ┌─────────────────┐                   ┌──────────────────────────────────┐ │
│ │ 📁 SAP Diagram  │                   │ [Request Diagram] [🔄] [Search] │ │
│ │    Viewer       │                   │                                  │ │
│ │ XX diagrams     │                   │                                  │ │
│ └─────────────────┘                   └──────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Exact Location
- **Position**: Top-right area of the header
- **Color**: Blue button (SAP blue theme)
- **Icon**: Plus (+) symbol
- **Text**: "Request Diagram"
- **Before**: Refresh button (circular arrow icon)
- **After**: Search input field

### What It Looks Like
```
┌─────────────────┐
│ + Request       │  ← This is the button
│   Diagram       │
└─────────────────┘
```

## If You Don't See the Button

### Check These Things:

1. **Browser Cache**: Hard refresh the page (Ctrl+F5 or Cmd+Shift+R)
2. **Development vs Production**: 
   - Development: `http://localhost:5174`
   - Production: Your GitHub Pages URL
3. **Screen Size**: On smaller screens, the header might wrap or hide elements
4. **Browser Console**: Check for any JavaScript errors

### Troubleshooting Steps:

1. **Refresh the page** completely
2. **Check browser console** (F12 → Console tab) for errors
3. **Verify URL**: Make sure you're on the correct page
4. **Try different browser** if issues persist

### Expected Behavior:
- **Hover**: Button should change to slightly darker blue
- **Click**: Should open a new tab with the SBPA form
- **URL**: Should navigate to the SAP Build Process Automation form

## Development Server

If testing locally, make sure the development server is running:
```bash
cd diagram-viewer
npm run dev
```
Then visit: `http://localhost:5174`

The button should be clearly visible in the header area immediately when the page loads.
