#!/bin/bash

set -euo pipefail

echo "🔍 Validating Diagrams V3 Configuration"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in the right directory
if [[ ! -f ".github/workflows/diagrams.yml" ]]; then
    print_error "Not in the diagrams-v3 directory. Please run this script from the project root."
    exit 1
fi

print_step "Checking local setup..."

# Check directories
if [[ -d "drawio_files" ]]; then
    print_success "drawio_files directory exists"
else
    print_error "drawio_files directory missing"
fi

if [[ -d "png_files" ]]; then
    print_success "png_files directory exists"
else
    print_warning "png_files directory missing (will be created automatically)"
    mkdir -p png_files
fi

# Check for sample files
drawio_count=$(find drawio_files -name "*.drawio" -type f 2>/dev/null | wc -l)
if [[ $drawio_count -gt 0 ]]; then
    print_success "Found $drawio_count .drawio file(s)"
    find drawio_files -name "*.drawio" -type f | while read -r file; do
        echo "  • $(basename "$file")"
    done
else
    print_warning "No .drawio files found in drawio_files/"
fi

print_step "Checking git configuration..."

if git status >/dev/null 2>&1; then
    print_success "Git repository initialized"
    
    if git remote get-url origin >/dev/null 2>&1; then
        origin_url=$(git remote get-url origin)
        print_success "GitHub remote configured: $origin_url"
    else
        print_warning "No GitHub remote configured"
    fi
else
    print_error "Not in a git repository"
fi

print_step "Checking GitHub Actions workflow..."

if [[ -f ".github/workflows/diagrams.yml" ]]; then
    print_success "Workflow file exists"
    
    # Check for required variables in workflow
    if grep -q "DIAGRAMS_SHAREPOINT_TENANT_ID" .github/workflows/diagrams.yml; then
        print_success "SharePoint variables referenced in workflow"
    else
        print_warning "SharePoint variables not found in workflow"
    fi
else
    print_error "Workflow file missing"
fi

echo ""
echo "🔧 Configuration Checklist for GitHub"
echo "===================================="
echo ""
echo "Before the workflow will work, ensure these are configured in your GitHub repository:"
echo ""
echo "Repository Variables (Settings → Secrets and variables → Actions → Variables):"
echo "  □ DIAGRAMS_SHAREPOINT_TENANT_ID"
echo "  □ DIAGRAMS_SHAREPOINT_CLIENT_ID"
echo "  □ DIAGRAMS_SHAREPOINT_DRIVE_ID"
echo "  □ DIAGRAMS_TEAMS_WEBHOOK (optional)"
echo ""
echo "Repository Secrets (Settings → Secrets and variables → Actions → Secrets):"
echo "  □ DIAGRAMS_SHAREPOINT_CLIENTSECRET"
echo ""

if [[ $drawio_count -eq 0 ]]; then
    echo "⚠️  Add some .drawio files to drawio_files/ to test the workflow"
fi

echo ""
echo "📖 For detailed setup instructions, see SETUP.md"
echo ""
print_success "Validation complete!"
