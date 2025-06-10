#!/bin/bash

# Auto-update diagram viewer when new PNG files are added
echo "🔄 Auto-updating SAP Diagram Viewer..."

# Step 1: Copy any new PNG files to the diagram viewer
echo "📁 Copying new PNG files..."
cp png_files/*.png diagram-viewer/public/png_files/ 2>/dev/null || echo "No new PNG files to copy"

# Step 2: Scan for all PNG files and update the parser
echo "🔍 Scanning for PNG files..."
cd diagram-viewer

# Generate the updated file list
echo "📝 Updating diagram parser with current files..."
PNG_FILES=$(ls public/png_files/*.png 2>/dev/null | xargs -n 1 basename | grep -v "CHANGELOG.csv" | sort)

# Create the new knownFiles array
NEW_KNOWN_FILES="  const knownFiles = ["
while IFS= read -r file; do
    if [ ! -z "$file" ]; then
        NEW_KNOWN_FILES="$NEW_KNOWN_FILES
    '$file',"
    fi
done <<< "$PNG_FILES"
NEW_KNOWN_FILES="$NEW_KNOWN_FILES
  ];"

# Update the parser file
sed -i.bak '/const knownFiles = \[/,/\];/c\
'"$NEW_KNOWN_FILES"'' src/utils/diagramParser.ts

echo "✅ Updated parser with $(echo "$PNG_FILES" | wc -l | tr -d ' ') diagram files"

# Step 3: Build the updated application
echo "🏗️ Building updated application..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed. Aborting update."
    exit 1
fi

# Step 4: Deploy the updated files
echo "🚀 Deploying updated files..."
./deploy-github-pages.sh > /dev/null 2>&1

# Step 5: Copy to repository root
cd ..
cp -r diagram-viewer/gh-pages-deploy/* ./

# Step 6: Commit and push changes
echo "📤 Committing and pushing changes..."
git add .
git commit -m "Auto-update diagrams: $(date '+%Y-%m-%d %H:%M')"
git push origin main

echo ""
echo "🎉 Diagram viewer updated successfully!"
echo "🌐 Live site: https://frostaag.github.io/diagrams-v3/"
echo ""
echo "Updated diagrams:"
echo "$PNG_FILES" | sed 's/^/  - /'
