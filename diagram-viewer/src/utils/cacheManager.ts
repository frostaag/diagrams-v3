// Cache management utilities for the diagram viewer

export const clearBrowserCache = () => {
  // Clear service worker cache if available
  if ('serviceWorker' in navigator && 'caches' in window) {
    caches.keys().then(cacheNames => {
      cacheNames.forEach(cacheName => {
        caches.delete(cacheName);
      });
    });
  }
  
  // Clear localStorage
  try {
    localStorage.clear();
  } catch (e) {
    console.warn('Could not clear localStorage:', e);
  }
  
  // Clear sessionStorage
  try {
    sessionStorage.clear();
  } catch (e) {
    console.warn('Could not clear sessionStorage:', e);
  }
};

export const forceRefresh = () => {
  // Clear cache first
  clearBrowserCache();
  
  // Add a timestamp to force refresh
  const url = new URL(window.location.href);
  url.searchParams.set('_refresh', Date.now().toString());
  window.location.href = url.toString();
};

export const addCacheBustingToUrl = (url: string): string => {
  const separator = url.includes('?') ? '&' : '?';
  return `${url}${separator}v=${Date.now()}`;
};
