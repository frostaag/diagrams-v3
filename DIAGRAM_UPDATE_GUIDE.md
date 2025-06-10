# 🔄 How to Update Your Diagram Viewer

## Automatic Updates (Recommended)

I've created an automated script that will handle everything for you!

### When you add new diagrams:

1. **Add your new PNG files to the `png_files/` folder** (following the naming convention: `x.y.description.png`)

2. **Run the update script:**
   ```bash
   ./update-diagrams.sh
   ```

3. **That's it!** The script will:
   - ✅ Copy new PNG files to the viewer
   - ✅ Automatically detect all diagram files
   - ✅ Update the file list in the code
   - ✅ Build the updated application
   - ✅ Deploy to GitHub Pages
   - ✅ Commit and push all changes

Your live site will be updated in 1-2 minutes!

## What the Script Does Automatically

- 📁 **Syncs PNG files** - Copies any new files from `png_files/` to the viewer
- 🔍 **Auto-detects diagrams** - Scans for all PNG files automatically
- 📝 **Updates code** - Modifies the diagram parser with the current file list
- 🏗️ **Builds application** - Creates the production version
- 🚀 **Deploys to GitHub** - Updates the live site
- 📤 **Commits changes** - Saves everything to your repository

## Manual Method (if needed)

If you prefer to do it manually:

1. Add PNG files to `png_files/`
2. Copy them: `cp png_files/*.png diagram-viewer/public/png_files/`
3. Update `diagram-viewer/src/utils/diagramParser.ts` with new filenames
4. Build: `cd diagram-viewer && npm run build`
5. Deploy: `./deploy-github-pages.sh`
6. Copy: `cd .. && cp -r diagram-viewer/gh-pages-deploy/* ./`
7. Commit: `git add . && git commit -m "Update diagrams" && git push`

## Naming Convention Reminder

Your PNG files should follow this pattern:
- `x.y.description.png`
- Where:
  - `x` = Topic (0: Multi Technology, 1: Cloud, 2: Network, 3: SAP)
  - `y` = Detail Level (1: High Level, 2: Detailed, 3: Very Detailed)
  - `description` = Human-readable name

Examples:
- `3.1. SAP Overview.png`
- `0.2.Multi-Cloud Strategy.png`
- `2.3.Network Security Details.png`

## Live Site

Your updated diagrams will appear at:
🌐 **https://frostaag.github.io/diagrams-v3/**

The update process takes about 1-2 minutes from running the script to seeing changes live!
