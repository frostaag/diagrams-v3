# GitHub Pages Setup Guide

Follow these steps to deploy your SAP Diagram Viewer to GitHub Pages:

## Step 1: Push the GitHub Actions Workflow

Make sure to commit and push the `.github/workflows/deploy.yml` file I just created:

```bash
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Pages deployment workflow"
git push origin main
```

## Step 2: Enable GitHub Pages in Repository Settings

1. Go to your GitHub repository on github.com
2. Click on the **Settings** tab (top navigation)
3. Scroll down to **Pages** in the left sidebar
4. Click on **Pages**

## Step 3: Configure GitHub Pages Source

In the Pages settings:

1. Under **Source**, select **GitHub Actions** (not the default "Deploy from a branch")
2. This will enable the workflow we created to automatically deploy your site

## Step 4: Enable Required Permissions

1. Still in your repository settings, go to **Actions** → **General**
2. Scroll down to **Workflow permissions**
3. Select **Read and write permissions**
4. Check **Allow GitHub Actions to create and approve pull requests**
5. Click **Save**

## Step 5: Trigger the Deployment

The deployment will automatically trigger when you:
- Push to the `main` branch
- Or manually trigger it from the Actions tab

To trigger it now:
1. Go to the **Actions** tab in your repository
2. Click on **Deploy to GitHub Pages** workflow
3. Click **Run workflow** → **Run workflow**

## Step 6: Access Your Site

Once the workflow completes successfully:
- Your site will be available at: `https://yourusername.github.io/repository-name`
- You can find the exact URL in the Pages settings or in the workflow results

## Expected Timeline

- Initial setup: 2-3 minutes
- Subsequent deployments: 1-2 minutes
- The workflow runs automatically on every push to main

## Troubleshooting

### If the workflow fails:
1. Check the Actions tab for error details
2. Ensure all permissions are set correctly
3. Make sure the repository is public (or you have GitHub Pro for private repos)

### If images don't load:
1. Verify PNG files are in `public/png_files/` directory
2. Check that the file list in `src/utils/diagramParser.ts` matches your actual files

### Custom Domain (Optional):
1. In Pages settings, you can add a custom domain
2. Create a `CNAME` file in the `public/` directory with your domain name

## Updating the Site

Every time you:
- Add new PNG files
- Update the code
- Push to the main branch

The site will automatically rebuild and deploy with your changes!

## Next Steps After Deployment

1. Test all functionality on the live site
2. Add the live URL to your repository description
3. Share the link in your GitHub profile README
4. Consider adding more diagrams following the naming convention
