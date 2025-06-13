import { Diagram, DiagramTopic, DiagramLevel } from '@/types/diagram';

export function parseDiagramFilename(filename: string): Diagram | null {
  // Remove .png extension
  const nameWithoutExt = filename.replace('.png', '');
  
  // Parse pattern: x.y.description or x.y. description
  const match = nameWithoutExt.match(/^(\d)\.(\d)\.?\s*(.+)$/);
  
  if (!match) {
    console.warn(`Could not parse diagram filename: ${filename}`);
    return null;
  }
  
  const [, topicStr, levelStr, description] = match;
  const topic = parseInt(topicStr) as DiagramTopic;
  const level = parseInt(levelStr) as DiagramLevel;
  
  // Validate topic and level
  if (!Object.values(DiagramTopic).includes(topic) || !Object.values(DiagramLevel).includes(level)) {
    console.warn(`Invalid topic (${topic}) or level (${level}) in filename: ${filename}`);
    return null;
  }
  
  // Add cache busting timestamp to image path
  const timestamp = new Date().getTime();
  return {
    filename,
    topic,
    level,
    description: description.trim(),
    path: `./png_files/${encodeURIComponent(filename)}?v=${timestamp}`
  };
}

export async function getDiagramList(): Promise<Diagram[]> {
  try {
    // Add cache busting with timestamp to ensure fresh data
    const timestamp = new Date().getTime();
    const response = await fetch(`./api/diagrams.json?v=${timestamp}`, {
      headers: {
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0'
      }
    });
    
    if (!response.ok) {
      throw new Error(`Failed to fetch diagrams: ${response.status}`);
    }
    
    const data = await response.json();
    const availableFiles = data.diagrams || [];
    
    console.log('Loaded diagrams:', availableFiles);
    
    const diagrams = availableFiles
      .map((filename: string) => parseDiagramFilename(filename))
      .filter((diagram: Diagram | null): diagram is Diagram => diagram !== null);
    
    return diagrams;
  } catch (error) {
    console.error('Error loading diagrams:', error);
    
    // Fallback to empty array if API fails
    return [];
  }
}

export function groupDiagramsByTopic(diagrams: Diagram[]): Map<DiagramTopic, Diagram[]> {
  const grouped = new Map<DiagramTopic, Diagram[]>();
  
  diagrams.forEach(diagram => {
    if (!grouped.has(diagram.topic)) {
      grouped.set(diagram.topic, []);
    }
    grouped.get(diagram.topic)!.push(diagram);
  });
  
  // Sort diagrams within each topic by level then description
  grouped.forEach(diagramList => {
    diagramList.sort((a, b) => {
      if (a.level !== b.level) {
        return a.level - b.level;
      }
      return a.description.localeCompare(b.description);
    });
  });
  
  return grouped;
}
