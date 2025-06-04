#!/bin/bash

set -euo pipefail

echo "🚀 Deploying Diagrams V3 to GitHub"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

print_step "Checking git status..."
if ! git status >/dev/null 2>&1; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes. Committing them now..."
    git add .
    git commit -m "Prepare for GitHub deployment"
    print_success "Changes committed"
fi

print_step "Checking if GitHub remote exists..."
if ! git remote get-url origin >/dev/null 2>&1; then
    print_warning "No GitHub remote found."
    echo ""
    echo "Please create a new repository on GitHub first, then run:"
    echo "git remote add origin https://github.com/YOUR_USERNAME/diagrams-v3.git"
    echo ""
    read -p "Enter your GitHub repository URL (e.g., https://github.com/username/diagrams-v3.git): " repo_url
    
    if [[ -n "$repo_url" ]]; then
        git remote add origin "$repo_url"
        print_success "Added GitHub remote: $repo_url"
    else
        print_error "No repository URL provided. Exiting."
        exit 1
    fi
fi

print_step "Pushing to GitHub..."
git push -u origin main

print_success "Repository deployed to GitHub!"

echo ""
echo "🔧 NEXT STEPS - Configure Repository Variables"
echo "============================================="
echo ""
echo "Go to your GitHub repository and configure these:"
echo ""
echo "1. Repository Variables (Settings → Secrets and variables → Actions → Variables):"
echo "   • DIAGRAMS_SHAREPOINT_TENANT_ID"
echo "   • DIAGRAMS_SHAREPOINT_CLIENT_ID"
echo "   • DIAGRAMS_SHAREPOINT_DRIVE_ID"
echo "   • DIAGRAMS_TEAMS_WEBHOOK (optional)"
echo ""
echo "2. Repository Secrets (Settings → Secrets and variables → Actions → Secrets):"
echo "   • DIAGRAMS_SHAREPOINT_CLIENTSECRET"
echo ""
echo "3. Test the workflow:"
echo "   • Add a .drawio file to drawio_files/"
echo "   • Commit and push"
echo "   • Check Actions tab for workflow execution"
echo ""
print_success "Setup complete! See SETUP.md for detailed configuration instructions."
