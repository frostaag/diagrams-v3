#!/bin/bash

set -euo pipefail

echo "🧪 Testing Draw.io Workflow Logic Locally"
echo "========================================"

# Simulate the workflow steps
echo "📋 Step 1: Setup directories"
mkdir -p png_files

# Initialize changelog
if [[ ! -f "png_files/CHANGELOG.csv" ]]; then
    echo "Date,Time,Diagram,Action,Version,Commit,Author,CommitMessage" > png_files/CHANGELOG.csv
    echo "✅ Created changelog header"
fi

echo "📋 Step 2: Detect files"
# Get all draw.io files (simulating first run)
changed_files=$(find drawio_files -name "*.drawio" -type f 2>/dev/null || true)

if [[ -z "$changed_files" ]]; then
    echo "❌ No .drawio files found in drawio_files/"
    exit 1
fi

echo "Found files:"
echo "$changed_files"

echo "📋 Step 3: Extract git info"
current_date=$(date +"%d.%m.%Y")
current_time=$(date +"%H:%M:%S")
commit_hash=$(git log -1 --format="%h" 2>/dev/null || echo "local")
author_name=$(git log -1 --format="%an" 2>/dev/null || echo "Local User")
commit_message=$(git log -1 --format="%s" 2>/dev/null || echo "Local test")

echo "Date: $current_date"
echo "Time: $current_time"
echo "Commit: $commit_hash"
echo "Author: $author_name"
echo "Message: $commit_message"

echo "📋 Step 4: Process files (simulation)"
processed_count=0

while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    
    basename=$(basename "$file" .drawio)
    png_file="png_files/${basename}.png"
    
    echo "Processing: $basename"
    
    # Simulate conversion (create dummy PNG)
    echo "dummy png content" > "$png_file"
    
    if [[ -f "$png_file" && -s "$png_file" ]]; then
        echo "✅ Successfully simulated conversion of $basename"
        action="Converted to PNG"
        ((processed_count++))
    else
        echo "❌ Failed to create $basename"
        action="Failed - Conversion Error"
    fi
    
    # Add to changelog
    echo "${current_date},${current_time},\"${basename}\",\"${action}\",\"1.0\",\"${commit_hash}\",\"${author_name}\",\"${commit_message}\"" >> png_files/CHANGELOG.csv
    
done <<< "$changed_files"

echo "📋 Step 5: Results"
echo "Processed $processed_count files"
echo ""
echo "Changelog content:"
echo "=================="
cat png_files/CHANGELOG.csv

echo ""
echo "Generated PNG files:"
echo "==================="
ls -la png_files/*.png 2>/dev/null || echo "No PNG files found"

echo ""
echo "🎉 Local workflow test completed successfully!"
echo ""
echo "This simulates what the GitHub Actions workflow will do."
echo "The actual workflow will:"
echo "1. Use real Draw.io to convert files"
echo "2. Commit changes back to the repository"
echo "3. Upload changelog to SharePoint"
echo "4. Send Teams notification"

# Cleanup simulation files
echo ""
read -p "Delete simulation files? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f png_files/*.png
    echo "✅ Cleaned up simulation files"
fi
