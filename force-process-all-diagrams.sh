#!/bin/bash

echo "🔧 Force Processing All Diagram Files"
echo "====================================="

echo ""
echo "📊 Current status:"
echo "Available .drawio files:"
find drawio_files -name "*.drawio" -type f | sort

echo ""
echo "Available .png files:"
ls png_files/*.png 2>/dev/null | sort || echo "No PNG files found"

echo ""
echo "🔍 Files that should have PNG versions but don't:"
missing_pngs=()

for drawio_file in drawio_files/*.drawio; do
    if [ -f "$drawio_file" ]; then
        basename=$(basename "$drawio_file" .drawio)
        png_file="png_files/${basename}.png"
        
        if [ ! -f "$png_file" ]; then
            echo "❌ Missing: $png_file (from $(basename "$drawio_file"))"
            missing_pngs+=("$drawio_file")
        else
            echo "✅ Exists: $png_file"
        fi
    fi
done

echo ""
if [ ${#missing_pngs[@]} -gt 0 ]; then
    echo "⚠️  Found ${#missing_pngs[@]} missing PNG files"
    echo ""
    echo "🚀 To fix this, we need to:"
    echo "1. Use GitHub's manual workflow dispatch to force process all files"
    echo "2. Or fix the file detection logic to handle spaces in filenames"
    echo ""
    echo "🔗 Manual workflow dispatch:"
    echo "   Go to: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]//g' | sed 's/\.git$//')/actions/workflows/diagrams.yml"
    echo "   Click 'Run workflow' button to manually trigger processing"
    echo ""
    echo "🔍 This will force process ALL .drawio files and should generate missing PNGs"
else
    echo "✅ All .drawio files have corresponding PNG versions"
fi

echo ""
echo "📋 Configuration Check:"
echo "For uploads to work, you need to configure these variables at:"
echo "https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]//g' | sed 's/\.git$//')/settings/variables/actions"
echo ""
echo "Required Variables:"
echo "🔹 SharePoint: DIAGRAMS_SHAREPOINT_TENANT_ID, DIAGRAMS_SHAREPOINT_CLIENT_ID, DIAGRAMS_SHAREPOINT_URL"
echo "🔹 SAP BTP: DIAGRAMS_SAP_BTP_TOKEN_URL, DIAGRAMS_SAP_BTP_CLIENT_ID, DIAGRAMS_SAP_BTP_DM_BASE_URL"
echo ""
echo "Required Secrets:"
echo "🔹 SharePoint: DIAGRAMS_SHAREPOINT_CLIENTSECRET"
echo "🔹 SAP BTP: DIAGRAMS_SAP_BTP_CLIENT_SECRET"
echo ""
echo "💡 If these are not configured, uploads will show as 'not configured' and be skipped"
