#!/bin/bash

# Trigger SAP BTP Document Management Upload Workflow
echo "🚀 Triggering SAP BTP Document Management Upload Workflow"
echo "========================================================"

# Check if GitHub CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed"
    echo "ℹ️ Install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI"
    echo "ℹ️ Run: gh auth login"
    exit 1
fi

# Get repository info
repo_info=$(gh repo view --json owner,name 2>/dev/null)
if [[ $? -ne 0 ]]; then
    echo "❌ Not in a GitHub repository or unable to access repository"
    exit 1
fi

owner=$(echo "$repo_info" | jq -r '.owner.login')
repo_name=$(echo "$repo_info" | jq -r '.name')

echo "📋 Repository: $owner/$repo_name"
echo ""

# Ask user for upload mode
echo "📤 SAP BTP Upload Options:"
echo "1. Upload all PNG files"
echo "2. Upload recent files only (default)"
echo ""
read -p "Choose option (1/2) [2]: " choice

case "$choice" in
    "1")
        upload_all="true"
        mode_description="all PNG files"
        ;;
    ""|"2")
        upload_all="false"
        mode_description="recent files only"
        ;;
    *)
        echo "❌ Invalid choice. Using default (recent files only)"
        upload_all="false"
        mode_description="recent files only"
        ;;
esac

echo ""
echo "🔄 Triggering workflow with mode: $mode_description"

# Trigger the workflow
response=$(gh workflow run sap-btp-upload.yml -f upload_all="$upload_all" 2>&1)

if [[ $? -eq 0 ]]; then
    echo "✅ Workflow triggered successfully!"
    echo ""
    echo "🔍 To view the workflow run:"
    echo "   gh run list --workflow=sap-btp-upload.yml"
    echo "   or"
    echo "   gh run watch (to watch the latest run)"
    echo ""
    echo "📊 Upload mode: $mode_description"
    
    # Wait a moment and try to get the run ID
    sleep 2
    latest_run=$(gh run list --workflow=sap-btp-upload.yml --limit=1 --json databaseId,status,conclusion,url 2>/dev/null)
    
    if [[ -n "$latest_run" ]]; then
        run_id=$(echo "$latest_run" | jq -r '.[0].databaseId')
        run_status=$(echo "$latest_run" | jq -r '.[0].status')
        run_url=$(echo "$latest_run" | jq -r '.[0].url')
        
        echo "🆔 Run ID: $run_id"
        echo "📊 Status: $run_status"
        echo "🔗 URL: $run_url"
        echo ""
        echo "💡 To watch this run: gh run watch $run_id"
    fi
else
    echo "❌ Failed to trigger workflow"
    echo "Error: $response"
    echo ""
    echo "🔧 Possible reasons:"
    echo "   • Workflow file doesn't exist: .github/workflows/sap-btp-upload.yml"
    echo "   • No permissions to trigger workflows"
    echo "   • GitHub CLI authentication issues"
    echo ""
    echo "🔍 Debug commands:"
    echo "   gh workflow list (to see available workflows)"
    echo "   gh auth status (to check authentication)"
fi
