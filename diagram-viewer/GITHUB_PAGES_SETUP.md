# GitHub Pages Setup Guide

Follow these steps to deploy your SAP Diagram Viewer to GitHub Pages:

## Step 1: Push the GitHub Actions Workflow

The workflow has been created in the root `.github/workflows/deploy-diagram-viewer.yml` file. 
Commit and push it:

```bash
git add .github/workflows/deploy-diagram-viewer.yml
git commit -m "Add GitHub Pages deployment workflow for diagram viewer"
git push origin main
```

## Step 2: Enable GitHub Pages Manually

**IMPORTANT: Pages must be enabled manually first!**

1. Go to your repository **Settings** → **Pages**
2. Under **Source**, select **GitHub Actions**
3. Click **Save**

## Step 3: Enable Required Permissions

1. Still in repository settings, go to **Actions** → **General**
2. Scroll down to **Workflow permissions**
3. Select **Read and write permissions**
4. Check **Allow GitHub Actions to create and approve pull requests**
5. Click **Save**

## Step 4: Run the Workflow

Now the workflow can deploy to the enabled Pages:

1. Go to the **Actions** tab in your repository
2. Click on **Deploy Diagram Viewer to GitHub Pages** workflow
3. Click **Run workflow** → **Run workflow**

## Step 4: Verify Deployment

After the workflow completes successfully:

1. Go to repository **Settings** → **Pages**
2. You should see Pages is now enabled with **GitHub Actions** as the source
3. Your site URL will be displayed: `https://yourusername.github.io/repository-name`

## Expected Timeline

- Initial setup: 2-3 minutes
- Subsequent deployments: 1-2 minutes
- The workflow runs automatically on changes to the `diagram-viewer/` folder

## Troubleshooting

### If the workflow fails with "Pages not enabled":
1. Make sure you've set the workflow permissions (Step 2)
2. Ensure your repository is public (or you have GitHub Pro for private repos)
3. The workflow will automatically enable Pages with the `enablement: true` parameter

### If images don't load:
1. Verify PNG files are in `diagram-viewer/public/png_files/` directory
2. Check that the file list in `src/utils/diagramParser.ts` matches your actual files

### Manual Pages Setup (if needed):
If the automatic enablement doesn't work:
1. Go to Settings → Pages
2. Select **GitHub Actions** as the source
3. Re-run the workflow

## Updating the Site

The workflow triggers automatically when you:
- Add new PNG files to `diagram-viewer/public/png_files/`
- Update any code in the `diagram-viewer/` folder
- Push changes to the main branch

## Next Steps After Deployment

1. Test all functionality on the live site
2. Add the live URL to your repository description
3. Share the link in your GitHub profile README
4. Add more diagrams following the naming convention (x.y.description.png)

## Adding New Diagrams

1. Copy PNG files to `diagram-viewer/public/png_files/`
2. Update the `knownFiles` array in `diagram-viewer/src/utils/diagramParser.ts`
3. Commit and push - the site updates automatically!
