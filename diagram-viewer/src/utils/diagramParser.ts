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
  
  return {
    filename,
    topic,
    level,
    description: description.trim(),
    path: `/png_files/${filename}`
  };
}

export function getDiagramList(): Promise<Diagram[]> {
  // In a real implementation, this would scan the png_files directory
  // For now, we'll return the known diagrams
  const knownFiles = [
    '0.1. Monitoring Proposed Strategy.png',
    '0.1.System Monitoring Idea.png',
    '0.2. FRoSTA Azure.png',
    '0.2.External User Identity Provision Idea.png',
    '3.1. SAP Task Center.png',
    '3.1.SAP BTP and Cloud.png',
    '3.1.SAP Cloud Simplified.png',
    '3.1.User Provisioning Strategy.png',
    '3.2.Business Partner - Seeburger connection.png',
    '3.2.MyTime - Connection SAP-ATOSS.png',
    '3.3. Workzone and Mobile Start.png'
  ];
  
  const diagrams = knownFiles
    .map(parseDiagramFilename)
    .filter((diagram): diagram is Diagram => diagram !== null);
  
  return Promise.resolve(diagrams);
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
