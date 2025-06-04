#!/bin/bash

# Script to trigger the workflow and test PNG generation
echo "🚀 Triggering Draw.io to PNG workflow test..."

# Make a small change to one of the .drawio files to trigger the workflow
echo "📝 Making a small change to trigger workflow..."

# Update the modification timestamp in the sample diagram
sed -i.bak 's/modified="[^"]*"/modified="'$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")'"/' drawio_files/sample-diagram.drawio

# Check if the change was made
if [[ $? -eq 0 ]]; then
    echo "✅ Updated sample-diagram.drawio timestamp"
else
    echo "❌ Failed to update sample-diagram.drawio"
    exit 1
fi

# Add and commit the change
echo "📦 Committing changes to trigger workflow..."
git add drawio_files/sample-diagram.drawio
git commit -m "Test: Update diagram timestamp to trigger workflow

This commit updates the modification timestamp in sample-diagram.drawio 
to trigger the automated PNG conversion workflow for testing purposes."

# Push the changes
echo "🚀 Pushing changes to trigger GitHub Actions..."
git push

echo "✅ Changes pushed successfully!"
echo ""
echo "🔍 You can monitor the workflow progress at:"
echo "   https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/actions"
echo ""
echo "⏱️  The workflow should start within a few seconds and will:"
echo "   1. 🔧 Install draw.io and dependencies"
echo "   2. 🎨 Convert .drawio files to PNG"
echo "   3. 📄 Update the changelog"
echo "   4. 💾 Commit generated files back to repository"
echo "   5. 📤 Upload changelog to SharePoint (if configured)"
echo "   6. 🔔 Send Teams notification (if configured)"
echo ""
echo "🎯 Expected outputs:"
echo "   - PNG files in png_files/ directory"
echo "   - Updated png_files/CHANGELOG.csv"
echo "   - Teams notification (if webhook configured)"
