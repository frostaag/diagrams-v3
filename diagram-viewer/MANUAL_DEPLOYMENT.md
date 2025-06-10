# Manual GitHub Pages Deployment Guide

Since the automated GitHub Actions approach is having issues, let's deploy manually. This is actually simpler and more reliable!

## Option 1: Manual Upload (Recommended)

### Step 1: Build the Project Locally

```bash
cd diagram-viewer
npm run build
```

### Step 2: Prepare Deployment Files

```bash
# Run the deployment script
./deploy-github-pages.sh
```

This creates a `gh-pages-deploy/` folder with all the files ready for GitHub Pages.

### Step 3: Enable GitHub Pages

1. Go to your repository on GitHub
2. Settings → Pages
3. Source: Select **"Deploy from a branch"**
4. Branch: Select **"main"** (or create a new `gh-pages` branch)
5. Folder: Select **"/ (root)"** if using main, or **"/ (root)"** if using gh-pages branch

### Step 4: Upload Files

**Option A: Using GitHub Web Interface**
1. Go to your repository on GitHub
2. Create a new branch called `gh-pages` (or use main)
3. Upload all files from `gh-pages-deploy/` folder to the repository root
4. Commit the changes

**Option B: Using Git Commands**
```bash
cd diagram-viewer
# After running the build script
cd gh-pages-deploy
git init
git add .
git commit -m "Deploy SAP Diagram Viewer"
git branch -M gh-pages
git remote add origin https://github.com/yourusername/your-repo-name.git
git push -u origin gh-pages
```

Then go to Settings → Pages and select the `gh-pages` branch.

## Option 2: Simple Manual Process

### Step 1: Build and Copy Files

```bash
cd diagram-viewer
npm run build
```

### Step 2: Copy Built Files to Repository Root

```bash
# Copy the built files to your repository root
cp -r dist/* ../
cp -r public/png_files ../
```

### Step 3: Commit and Push

```bash
cd ..
git add .
git commit -m "Deploy diagram viewer"
git push origin main
```

### Step 4: Enable Pages

1. Repository Settings → Pages
2. Source: "Deploy from a branch"
3. Branch: "main"
4. Folder: "/ (root)"

## Option 3: Using the Deploy Script

I've created a deployment script that makes this easier:

```bash
cd diagram-viewer
chmod +x deploy-github-pages.sh
./deploy-github-pages.sh
```

This will create a `gh-pages-deploy/` folder with everything ready. Then:

1. Create a `gh-pages` branch in your repository
2. Upload the contents of `gh-pages-deploy/` to that branch
3. Enable Pages from the `gh-pages` branch

## Which Option to Choose?

- **Option 1** is best if you want to keep your diagram viewer separate from your main code
- **Option 2** is simplest if you want everything in your main branch
- **Option 3** uses the automated script but manual upload

## Expected Result

Your site will be available at:
`https://yourusername.github.io/repository-name`

## Updating Later

When you add new diagrams:
1. Add PNG files to `diagram-viewer/public/png_files/`
2. Update `diagram-viewer/src/utils/diagramParser.ts` with new filenames
3. Run the build and deployment process again
4. Upload/push the new files

This manual approach is often more reliable than automated workflows!
