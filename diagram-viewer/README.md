# SAP Diagram Viewer

A SAP Fiori-inspired web application for organizing and displaying diagram files with automatic categorization based on naming conventions.

## Features

- **Automatic Organization**: Diagrams are automatically categorized based on filename patterns
- **SAP Fiori Design**: Clean, professional interface following SAP design principles
- **Responsive Layout**: Works seamlessly on desktop and mobile devices
- **Search Functionality**: Find diagrams quickly using the search bar
- **Modal View**: Click any diagram to view it in full size with download options
- **Collapsible Sections**: Organize diagrams by topic with expandable/collapsible sections

## Naming Convention

The application expects diagram files to follow this naming pattern:
```
x.y.description.png
```

Where:
- **x** = Topic (0: Multi Technology, 1: Cloud, 2: Network, 3: SAP)
- **y** = Detail Level (1: High Level, 2: Detailed, 3: Very Detailed)
- **description** = Human-readable description of the diagram

### Examples:
- `3.1. SAP Task Center.png`
- `0.2.External User Identity Provision Idea.png`
- `3.2.Business Partner - Seeburger connection.png`

## Technology Stack

- **React 18** - UI framework
- **TypeScript** - Type safety
- **Vite** - Build tool and dev server
- **Tailwind CSS** - Styling
- **TanStack Query** - Data fetching and state management
- **Lucide React** - Icons

## Getting Started

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Add your PNG files:**
   - Place your diagram PNG files in the `public/png_files/` directory
   - Follow the naming convention described above

3. **Update the file list:**
   - Edit `src/utils/diagramParser.ts`
   - Add your new filenames to the `knownFiles` array

4. **Start the development server:**
   ```bash
   npm run dev
   ```

5. **Build for production:**
   ```bash
   npm run build
   ```

## Project Structure

```
diagram-viewer/
├── public/
│   └── png_files/          # Diagram PNG files
├── src/
│   ├── components/         # React components
│   │   ├── DiagramCard.tsx
│   │   ├── DiagramModal.tsx
│   │   └── TopicSection.tsx
│   ├── types/              # TypeScript type definitions
│   │   └── diagram.ts
│   ├── utils/              # Utility functions
│   │   └── diagramParser.ts
│   ├── lib/                # Shared libraries
│   │   └── utils.ts
│   ├── App.tsx             # Main application component
│   ├── main.tsx           # Application entry point
│   └── index.css          # Global styles
├── package.json
├── vite.config.ts
└── tailwind.config.js
```

## Customization

### Adding New Topics
1. Update the `DiagramTopic` enum in `src/types/diagram.ts`
2. Add corresponding labels in `TOPIC_LABELS`
3. Add colors in `TOPIC_COLORS`

### Adding New Detail Levels
1. Update the `DiagramLevel` enum in `src/types/diagram.ts`
2. Add corresponding labels in `LEVEL_LABELS`

### Styling
- Modify SAP colors in `tailwind.config.js`
- Update component styles in `src/index.css`
- Customize component-specific styles in individual component files

## Automatic Updates

The application automatically updates when:
- New PNG files are added to the `public/png_files/` directory
- Existing files are removed
- Files are renamed (as long as they follow the naming convention)

Simply update the `knownFiles` array in `diagramParser.ts` when adding or removing files.

## Deployment

The application can be deployed to any static hosting service:

1. Build the production version:
   ```bash
   npm run build
   ```

2. Deploy the `dist/` folder to your hosting service

Popular hosting options:
- GitHub Pages
- Netlify
- Vercel
- AWS S3 + CloudFront

## Browser Support

- Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile browsers (iOS Safari, Chrome Mobile)
- Responsive design works on all screen sizes
