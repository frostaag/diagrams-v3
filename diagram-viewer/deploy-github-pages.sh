#!/bin/bash

# Deploy to GitHub Pages script
echo "🚀 Building and deploying SAP Diagram Viewer to GitHub Pages..."

# Build the project
echo "📦 Building project..."
npm run build

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "❌ Build failed. Aborting deployment."
    exit 1
fi

echo "✅ Build successful!"

# Create deployment directory
echo "📁 Preparing deployment files..."
rm -rf gh-pages-deploy
mkdir gh-pages-deploy
cp -r dist/* gh-pages-deploy/

# Copy PNG files to ensure they're available
cp -r public/png_files gh-pages-deploy/

echo "🎯 Deployment files ready in gh-pages-deploy/ directory"
echo ""
echo "Next steps:"
echo "1. Create a new repository on GitHub for your diagram viewer"
echo "2. Enable GitHub Pages in repository settings"
echo "3. Upload the contents of gh-pages-deploy/ to your repository"
echo "4. Your diagram viewer will be available at: https://username.github.io/repository-name"
echo ""
echo "Or use GitHub CLI to deploy:"
echo "  cd gh-pages-deploy"
echo "  git init"
echo "  git add ."
echo "  git commit -m 'Deploy SAP Diagram Viewer'"
echo "  git branch -M main"
echo "  git remote add origin https://github.com/username/repository-name.git"
echo "  git push -u origin main"
