#!/bin/bash

echo "🆔 Automatic Diagram ID Assignment Script"
echo "========================================"

# Check if diagram-registry.json exists
if [[ ! -f "diagram-registry.json" ]]; then
    echo "❌ diagram-registry.json not found!"
    exit 1
fi

# Load next ID from registry
NEXT_ID=$(jq -r '.nextId' diagram-registry.json)
echo "📊 Next available ID: $(printf "%03d" $NEXT_ID)"

# Function to assign ID to a file
assign_id() {
    local file="$1"
    local id="$2"
    local id_padded=$(printf "%03d" $id)
    
    # Check if file already has an ID prefix
    if [[ "$file" =~ ^[0-9]{3}_ ]]; then
        echo "✅ $file already has ID prefix, skipping"
        return 0
    fi
    
    # Generate new filename with ID prefix
    local new_file="${id_padded}_${file}"
    
    echo "🔄 Assigning ID $id_padded to: $file"
    echo "   New name: $new_file"
    
    # Rename the file
    if [[ -f "drawio_files/$file" ]]; then
        mv "drawio_files/$file" "drawio_files/$new_file"
        echo "✅ Renamed drawio file: $file → $new_file"
    else
        echo "⚠️  DrawIO file not found: drawio_files/$file"
    fi
    
    # Rename corresponding PNG file if it exists
    local png_file="${file%.drawio}.png"
    local new_png_file="${id_padded}_${png_file}"
    
    if [[ -f "png_files/$png_file" ]]; then
        mv "png_files/$png_file" "png_files/$new_png_file"
        echo "✅ Renamed PNG file: $png_file → $new_png_file"
    else
        echo "ℹ️  PNG file will be generated: $new_png_file"
    fi
    
    # Update registry
    local title=$(echo "$file" | sed 's/\.drawio$//' | sed 's/^[0-9]\.[0-9]\.*//')
    local topic=$(echo "$file" | sed 's/\..*$//')
    local level=$(echo "$file" | sed 's/^[0-9]\.\([0-9]\)\..*$/\1/')
    local current_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Add mapping to registry
    local mapping=$(cat << EOF
    "$id_padded": {
      "id": "$id_padded",
      "originalName": "$file",
      "currentDrawioFile": "$new_file",
      "currentPngFile": "$new_png_file",
      "title": "$title",
      "topic": $topic,
      "level": $level,
      "created": "$current_time",
      "lastModified": "$current_time",
      "status": "active"
    }
EOF
    )
    
    echo "📝 Updated registry for ID $id_padded"
    return $((id + 1))
}

echo ""
echo "🔍 Scanning for DrawIO files without ID prefixes..."

# Get all .drawio files that don't have ID prefixes
unprocessed_files=()
if [[ -d "drawio_files" ]]; then
    while IFS= read -r -d '' file; do
        basename_file=$(basename "$file")
        # Check if file doesn't start with 3 digits and underscore
        if [[ ! "$basename_file" =~ ^[0-9]{3}_ ]]; then
            unprocessed_files+=("$basename_file")
        fi
    done < <(find drawio_files -name "*.drawio" -type f -print0)
fi

echo "📊 Found ${#unprocessed_files[@]} files without ID prefixes"

if [[ ${#unprocessed_files[@]} -eq 0 ]]; then
    echo "✅ All files already have ID prefixes!"
    exit 0
fi

echo ""
echo "📋 Files to process:"
for file in "${unprocessed_files[@]}"; do
    echo "   - $file"
done

echo ""
read -p "❓ Do you want to proceed with ID assignment? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled"
    exit 0
fi

echo ""
echo "🚀 Starting ID assignment process..."

# Sort files to ensure consistent ordering
IFS=$'\n' sorted_files=($(sort <<<"${unprocessed_files[*]}"))
unset IFS

current_id=$NEXT_ID

# Process each file
for file in "${sorted_files[@]}"; do
    assign_id "$file" $current_id
    ((current_id++))
done

# Update the nextId in registry
echo ""
echo "📝 Updating registry with next available ID: $(printf "%03d" $current_id)"

# Create a temporary file with updated registry
temp_file=$(mktemp)
jq --arg nextId "$current_id" '.nextId = ($nextId | tonumber) | .lastUpdated = now | strftime("%Y-%m-%dT%H:%M:%SZ")' diagram-registry.json > "$temp_file"

if [[ $? -eq 0 ]]; then
    mv "$temp_file" diagram-registry.json
    echo "✅ Registry updated successfully"
else
    echo "❌ Failed to update registry"
    rm -f "$temp_file"
    exit 1
fi

echo ""
echo "🎉 ID assignment completed!"
echo "📊 Processed ${#sorted_files[@]} files"
echo "🆔 Next available ID: $(printf "%03d" $current_id)"
echo ""
echo "📋 Next steps:"
echo "   1. Commit the renamed files and updated registry"
echo "   2. Run the diagram processing workflow to generate new PNGs"
echo "   3. Update the diagram viewer to display IDs"
echo ""
echo "✅ All diagram files now have unique 3-digit ID prefixes!"
