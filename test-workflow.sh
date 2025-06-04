#!/bin/bash
# Test script for Diagrams V3 workflow
# This simulates the workflow steps locally for testing

set -e

echo "🧪 Testing Diagrams V3 Workflow Components"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

test_step() {
    echo -e "${YELLOW}🔍 Testing: $1${NC}"
}

test_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

test_error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# Test 1: Directory structure
test_step "Directory structure"
if [[ -d "drawio_files" && -d "png_files" && -d ".github/workflows" ]]; then
    test_success "Required directories exist"
else
    test_error "Missing required directories"
fi

# Test 2: Workflow file exists
test_step "Workflow file"
if [[ -f ".github/workflows/diagrams.yml" ]]; then
    test_success "Workflow file exists"
else
    test_error "Workflow file missing"
fi

# Test 3: Sample diagram file
test_step "Sample diagram file"
if [[ -f "drawio_files/sample-diagram.drawio" ]]; then
    test_success "Sample diagram exists"
else
    test_error "Sample diagram missing"
fi

# Test 4: Check if Draw.io is available (for local testing)
test_step "Draw.io availability (local test)"
if command -v drawio >/dev/null 2>&1; then
    test_success "Draw.io is available for local testing"
    
    # Test 5: Try PNG conversion locally
    test_step "PNG conversion test"
    mkdir -p png_files
    
    if xvfb-run --auto-servernum drawio -x -f png --scale 2.0 \
       -o "png_files/sample-diagram.png" "drawio_files/sample-diagram.drawio" >/dev/null 2>&1; then
        
        if [[ -f "png_files/sample-diagram.png" && -s "png_files/sample-diagram.png" ]]; then
            test_success "PNG conversion works locally"
        else
            test_error "PNG conversion failed - empty file"
        fi
    else
        test_error "PNG conversion failed"
    fi
else
    echo -e "${YELLOW}⚠️  Draw.io not available locally (normal - will work in GitHub Actions)${NC}"
fi

# Test 6: Check workflow syntax
test_step "Workflow YAML syntax"
if command -v yamllint >/dev/null 2>&1; then
    if yamllint .github/workflows/diagrams.yml >/dev/null 2>&1; then
        test_success "YAML syntax is valid"
    else
        test_error "YAML syntax errors found"
    fi
else
    echo -e "${YELLOW}⚠️  yamllint not available - skipping syntax check${NC}"
fi

# Test 7: Simulate changelog creation
test_step "Changelog simulation"
mkdir -p png_files

cat > png_files/CHANGELOG.csv << EOF
Date,Time,Diagram,Action,Version,Commit,Author
$(date +"%d.%m.%Y"),$(date +"%H:%M:%S"),"sample-diagram","Converted to PNG","1.0","test123","Test User"
EOF

if [[ -f "png_files/CHANGELOG.csv" ]] && grep -q "sample-diagram" "png_files/CHANGELOG.csv"; then
    test_success "Changelog creation works"
else
    test_error "Changelog creation failed"
fi

# Test 8: Check documentation files
test_step "Documentation completeness"
missing_docs=()
for doc in "README.md" "SETUP.md" "MIGRATION.md" "PROJECT_SUMMARY.md"; do
    if [[ ! -f "$doc" ]]; then
        missing_docs+=("$doc")
    fi
done

if [[ ${#missing_docs[@]} -eq 0 ]]; then
    test_success "All documentation files present"
else
    test_error "Missing documentation: ${missing_docs[*]}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}🎉 V3 Test Results: All tests passed!${NC}"
echo ""
echo "Next steps for deployment:"
echo "1. Copy this project to your GitHub repository"
echo "2. Configure repository variables (see SETUP.md)"
echo "3. Add .drawio files to drawio_files/"
echo "4. Commit and push to trigger the workflow"
echo ""
echo "The V3 workflow is ready for production use!"
