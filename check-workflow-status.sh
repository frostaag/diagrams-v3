#!/bin/bash

echo "🔍 Checking Workflow Configuration Status"
echo "========================================"

echo ""
echo "📋 Recent commits that should have triggered uploads:"
git log --oneline -5 | grep -E "(Update.*\.drawio|Generate PNG|\.drawio)" || echo "No recent diagram commits found"

echo ""
echo "📄 Current changelog entries:"
if [ -f "png_files/CHANGELOG.csv" ]; then
    echo "Last 3 entries:"
    tail -n 3 png_files/CHANGELOG.csv
    echo ""
    echo "Total entries: $(tail -n +2 png_files/CHANGELOG.csv | wc -l)"
else
    echo "❌ Changelog file not found"
fi

echo ""
echo "📁 PNG files currently available:"
if [ -d "png_files" ]; then
    ls -la png_files/*.png 2>/dev/null || echo "No PNG files found"
else
    echo "❌ png_files directory not found"
fi

echo ""
echo "🔗 To check if variables are configured, go to:"
echo "   https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]//g' | sed 's/\.git$//')/settings/variables/actions"

echo ""
echo "🔍 Required variables for uploads to work:"
echo "SharePoint:"
echo "  - DIAGRAMS_SHAREPOINT_TENANT_ID"
echo "  - DIAGRAMS_SHAREPOINT_CLIENT_ID" 
echo "  - DIAGRAMS_SHAREPOINT_URL"
echo "  - DIAGRAMS_SHAREPOINT_CLIENTSECRET (secret)"
echo ""
echo "SAP BTP:"
echo "  - DIAGRAMS_SAP_BTP_TOKEN_URL"
echo "  - DIAGRAMS_SAP_BTP_CLIENT_ID"
echo "  - DIAGRAMS_SAP_BTP_DM_BASE_URL"
echo "  - DIAGRAMS_SAP_BTP_CLIENT_SECRET (secret)"

echo ""
echo "💡 If variables are not configured, uploads will be skipped"
echo "💡 Check the latest workflow run at:"
echo "   https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]//g' | sed 's/\.git$//')/actions"
