# 🚀 Simple Manual Deployment Steps

Your deployment files are ready! Here are the **easiest steps** to get your diagram viewer live:

## ✅ Files Ready

The `gh-pages-deploy/` folder contains:
- `index.html` - Your main app
- `assets/` - CSS and JS files 
- `png_files/` - All your diagrams

## 🎯 Quick Deployment (Choose ONE method)

### Method 1: Use Existing Repository (Simplest)

1. **Copy files to your repository root:**
   ```bash
   cd diagram-viewer
   cp -r gh-pages-deploy/* ../
   cd ..
   ```

2. **Commit and push:**
   ```bash
   git add .
   git commit -m "Deploy SAP Diagram Viewer"
   git push origin main
   ```

3. **Enable GitHub Pages:**
   - Go to your repository on GitHub
   - Settings → Pages
   - Source: "Deploy from a branch"
   - Branch: "main"
   - Folder: "/ (root)"
   - Save

4. **Done!** Your site will be at: `https://yourusername.github.io/repository-name`

### Method 2: Create Separate gh-pages Branch

1. **Create and switch to gh-pages branch:**
   ```bash
   cd diagram-viewer/gh-pages-deploy
   git init
   git add .
   git commit -m "Deploy SAP Diagram Viewer"
   git branch -M gh-pages
   ```

2. **Push to your repository:**
   ```bash
   git remote add origin https://github.com/yourusername/your-repo-name.git
   git push -u origin gh-pages
   ```

3. **Enable GitHub Pages:**
   - Repository Settings → Pages
   - Source: "Deploy from a branch"
   - Branch: "gh-pages"
   - Folder: "/ (root)"
   - Save

## 🔧 What to Replace

Replace `yourusername` and `your-repo-name` with your actual GitHub username and repository name.

## ⏱️ Timeline

- Setup: 2 minutes
- GitHub Pages activation: 1-2 minutes
- Total: 3-4 minutes to be live!

## 🎉 Expected Result

Your SAP Diagram Viewer will be live with:
- Automatic organization by topic (Multi Technology, SAP, etc.)
- Search functionality
- Click to view diagrams in full size
- Download and open in new tab options
- Responsive design that works on all devices

## 🔄 Future Updates

When you add new diagrams:
1. Add PNG files to `diagram-viewer/public/png_files/`
2. Update file list in `diagram-viewer/src/utils/diagramParser.ts`
3. Run `./deploy-github-pages.sh` again
4. Copy/push the new files

**Choose Method 1 if you want everything in one place. Choose Method 2 if you want to keep your source code separate from the deployed site.**
