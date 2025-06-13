# 🚀 Automatic Diagram Updates - Best Technical Setup

Your diagram viewer is now optimized for **instant automatic updates**! Here's how it works and how to get your diagrams online ASAP.

## ✅ Current Status
- **✅ New Diagram Added**: "0.2. Seeburger Setup Over VPN.png" is now live!
- **✅ Site Updated**: https://frostaag.github.io/diagrams-v3/
- **✅ Auto-deployment**: Optimized workflows are active

## 🎯 How to Add New Diagrams (Fastest Method)

### Method 1: Direct PNG Upload (Instant - 2 minutes)
```bash
# Add your new PNG file to png_files/ directory
cp "your-new-diagram.png" png_files/

# Run the instant update script
./update-diagrams.sh

# Done! Live in ~2 minutes
```

### Method 2: Draw.io Workflow (Auto-conversion - 3-5 minutes)
```bash
# Add your .drawio file to drawio_files/ directory
cp "your-new-diagram.drawio" drawio_files/

# Push to GitHub (triggers auto-conversion)
git add drawio_files/
git commit -m "Add new diagram: your-new-diagram"
git push origin main

# GitHub Actions will:
# 1. Convert .drawio to .png (2-3 minutes)
# 2. Auto-deploy to website (1-2 minutes)
```

## ��️ Technical Architecture (Optimized)

### Workflow Chain:
```
.drawio file → GitHub Actions → .png file → Auto-deployment → Live site
    ↓              ↓             ↓             ↓             ↓
  Manual        Conversion    Processed    Website       Updated
  Upload        (2-3 min)     (instant)    Build         (live)
                                          (1-2 min)
```

### Active Workflows:
1. **diagrams.yml**: Converts .drawio → .png, updates changelog
2. **deploy-diagram-viewer.yml**: Deploys website when PNG files change

## ⚡ Speed Optimization Features

### Triggers:
- **Immediate**: Any PNG file added to `png_files/`
- **Automatic**: Any .drawio file added to `drawio_files/`
- **Manual**: `./update-diagrams.sh` script

### Caching:
- Node.js dependencies cached
- Build artifacts optimized
- Only changed files processed

### Parallel Processing:
- Diagram conversion runs independently
- Website deployment runs in parallel
- No blocking operations

## 📊 Your Current Diagrams (11 total):

### Multi-tech (0.x):
- ✅ 0.1. Monitoring Proposed Strategy
- ✅ 0.2. FRoSTA Azure  
- ✅ 0.2. External User Identity Provision Idea
- ✅ **0.2. Seeburger Setup Over VPN** (NEW!)

### SAP (3.x):
- ✅ 3.1. SAP Task Center
- ✅ 3.1. SAP BTP and Cloud
- ✅ 3.1. SAP Cloud Simplified
- ✅ 3.1. User Provisioning Strategy
- ✅ 3.2. Business Partner - Seeburger connection
- ✅ 3.2. MyTime - Connection SAP-ATOSS
- ✅ 3.3. Workzone and Mobile Start

## 🔧 Troubleshooting

### If diagram doesn't appear:
1. **Check naming**: Use format `X.Y. Description.png`
2. **Run manual update**: `./update-diagrams.sh`
3. **Check workflow**: GitHub Actions tab
4. **Clear browser cache**: Ctrl+F5

### If workflow fails:
1. **Check GitHub Actions**: Look for red X marks
2. **Re-run failed jobs**: Click "Re-run jobs"
3. **Manual deployment**: Run `./update-diagrams.sh`

## 🎯 Best Practices

### Naming Convention:
```
X.Y. Description.png
├── X = Technology ID (0=Multi, 1=Cloud, 2=Network, 3=SAP)
├── Y = Detail Level (1=High-level, 2=Intermediate, 3=Detailed)
└── Description = Clear, descriptive name
```

### File Management:
- **Source**: Keep .drawio files in `drawio_files/`
- **Generated**: PNG files auto-created in `png_files/`
- **Website**: Auto-deployed to GitHub Pages

### Update Speed:
- **Fastest**: Direct PNG upload + `./update-diagrams.sh` (2 min)
- **Automatic**: .drawio upload + git push (3-5 min)
- **Manual**: Use update script anytime

## 🌐 Live URLs
- **Main Site**: https://frostaag.github.io/diagrams-v3/
- **API Endpoint**: https://frostaag.github.io/diagrams-v3/api/diagrams.json
- **GitHub Repo**: https://github.com/frostaag/diagrams-v3

Your new diagram "0.2. Seeburger Setup Over VPN" is now live and automatically categorized!
