# Cache Improvements for Diagram Viewer

This document outlines the comprehensive cache-busting improvements implemented to address the aggressive caching issues that required users to open incognito windows or clear cache to see updates.

## Issues Addressed

- **Aggressive Browser Caching**: Users had to clear cache or use incognito mode to see updated diagrams
- **Stale API Data**: The `diagrams.json` API was being cached, preventing new diagrams from appearing
- **Image Caching**: PNG diagram files were being cached indefinitely
- **App Bundle Caching**: JavaScript and CSS files weren't updating properly

## Implemented Solutions

### 1. HTML Meta Tags for Cache Control

**File**: `diagram-viewer/index.html`

Added cache control meta tags to prevent browser caching of the main HTML file:

```html
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
```

### 2. React Query Configuration

**File**: `diagram-viewer/src/main.tsx`

Configured React Query to disable caching and always fetch fresh data:

```typescript
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 0, // Always consider data stale
      gcTime: 0, // Don't cache data (garbage collection time)
      retry: 1,
      refetchOnMount: true,
      refetchOnWindowFocus: true,
      refetchOnReconnect: true,
    },
  },
});
```

### 3. API Fetch Cache Busting

**File**: `diagram-viewer/src/utils/diagramParser.ts`

Added timestamp-based cache busting and cache control headers to API requests:

```typescript
const timestamp = new Date().getTime();
const response = await fetch(`./api/diagrams.json?v=${timestamp}`, {
  headers: {
    'Cache-Control': 'no-cache, no-store, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0'
  }
});
```

### 4. Image Path Cache Busting

**File**: `diagram-viewer/src/utils/diagramParser.ts`

Added timestamp parameters to diagram image URLs:

```typescript
const timestamp = new Date().getTime();
return {
  // ... other properties
  path: `./png_files/${encodeURIComponent(filename)}?v=${timestamp}`
};
```

### 5. Build-time Asset Versioning

**File**: `diagram-viewer/vite.config.ts`

Configured Vite to add hashes to all built assets for automatic cache busting:

```typescript
build: {
  rollupOptions: {
    output: {
      assetFileNames: (assetInfo) => {
        const info = assetInfo.name!.split('.');
        const ext = info[info.length - 1];
        if (/png|jpe?g|svg|gif|tiff|bmp|ico/i.test(ext)) {
          return `assets/[name]-[hash][extname]`;
        }
        return `assets/[name]-[hash][extname]`;
      },
      chunkFileNames: 'assets/[name]-[hash].js',
      entryFileNames: 'assets/[name]-[hash].js',
    },
  },
}
```

### 6. Server-side Cache Headers

**File**: `diagram-viewer/public/.htaccess`

Added Apache configuration for cache control headers:

```apache
# Disable caching for HTML files and API endpoints
<FilesMatch "\.(html|json)$">
    Header set Cache-Control "no-cache, no-store, must-revalidate"
    Header set Pragma "no-cache"
    Header set Expires "0"
</FilesMatch>

# Short cache for images (1 hour) to allow for updates
<FilesMatch "\.(png|jpg|jpeg|gif|svg|ico)$">
    Header set Cache-Control "public, max-age=3600"
</FilesMatch>
```

### 7. Manual Refresh Functionality

**Files**: 
- `diagram-viewer/src/utils/cacheManager.ts`
- `diagram-viewer/src/App.tsx`

Created cache management utilities and added a refresh button:

```typescript
// Cache management utilities
export const clearBrowserCache = () => {
  if ('serviceWorker' in navigator && 'caches' in window) {
    caches.keys().then(cacheNames => {
      cacheNames.forEach(cacheName => {
        caches.delete(cacheName);
      });
    });
  }
  localStorage.clear();
  sessionStorage.clear();
};

export const forceRefresh = () => {
  clearBrowserCache();
  const url = new URL(window.location.href);
  url.searchParams.set('_refresh', Date.now().toString());
  window.location.href = url.toString();
};
```

Added refresh button in the header with spinning animation during refresh.

### 8. Download Path Handling

**File**: `diagram-viewer/src/components/DiagramModal.tsx`

Updated download functionality to remove cache-busting parameters:

```typescript
const handleDownload = () => {
  const link = document.createElement('a');
  // Remove cache busting parameter for download
  const cleanPath = diagram.path.split('?')[0];
  link.href = cleanPath;
  link.download = diagram.filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
```

## Benefits

1. **Immediate Updates**: Users will see new diagrams immediately without cache clearing
2. **Fresh API Data**: The diagrams.json API is always fetched fresh
3. **Updated Images**: Diagram images are fetched with cache-busting parameters
4. **Manual Control**: Users can manually refresh using the refresh button
5. **Balanced Caching**: Static assets are still cached appropriately for performance
6. **Cross-browser Support**: Works across different browsers and environments

## Usage

### For Users
- The app will automatically fetch fresh data on every visit
- Use the refresh button (↻) in the header to force a complete refresh
- No more need for incognito mode or manual cache clearing

### For Developers
- The cache management utilities can be imported and used elsewhere if needed
- The `.htaccess` file will work on Apache servers
- Vite automatically handles build-time cache busting

## Testing

To verify cache improvements:

1. Deploy new diagrams
2. Visit the app normally (not incognito)
3. New diagrams should appear immediately
4. Use browser dev tools to verify cache headers
5. Test the manual refresh button functionality

## Notes

- The cache improvements are balanced to maintain performance while ensuring freshness
- Images have a 1-hour cache on the server side to reduce server load while allowing updates
- JavaScript and CSS assets are cached for 1 day but include hashes for automatic invalidation
- The manual refresh is a fallback option for users who want to ensure they have the absolute latest data
