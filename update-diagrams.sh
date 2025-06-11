#!/bin/bash

# Auto-update diagram viewer when new PNG files are added
echo "🔄 Auto-updating SAP Diagram Viewer..."

# Step 1: Copy any new PNG files to the diagram viewer
echo "📁 Copying new PNG files..."
cp png_files/*.png diagram-viewer/public/png_files/ 2>/dev/null || echo "No new PNG files to copy"

# Step 2: Scan for all PNG files and update the API
echo "🔍 Scanning for PNG files..."
cd diagram-viewer

# Generate the updated file list
echo "📝 Updating diagrams API with current files..."

# Create the new API JSON file
echo '{' > public/api/diagrams.json
echo '  "diagrams": [' >> public/api/diagrams.json

FIRST=true
for file in public/png_files/*.png; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ "$filename" != "CHANGELOG.csv" ]; then
            if [ "$FIRST" = true ]; then
                FIRST=false
            else
                echo ',' >> public/api/diagrams.json
            fi
            echo -n "    \"$filename\"" >> public/api/diagrams.json
        fi
    fi
done

echo '' >> public/api/diagrams.json
echo '  ]' >> public/api/diagrams.json
echo '}' >> public/api/diagrams.json

# Count the files for output
FILE_COUNT=$(find public/png_files/ -name "*.png" -not -name "CHANGELOG.csv" | wc -l | tr -d ' ')

echo "✅ Updated API with $FILE_COUNT diagram files"

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
