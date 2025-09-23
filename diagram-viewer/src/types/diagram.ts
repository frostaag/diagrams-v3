export interface Diagram {
  id?: string; // 3-digit ID (001, 002, etc.)
  filename: string;
  topic: DiagramTopic;
  level: DiagramLevel;
  description: string;
  path: string;
  originalName?: string; // Name without ID prefix
}

export interface DiagramRegistry {
  nextId: number;
  version: string;
  created: string;
  lastUpdated: string;
  mappings: { [id: string]: DiagramMapping };
}

export interface DiagramMapping {
  id: string;
  originalName: string;
  currentDrawioFile: string;
  currentPngFile: string;
  title: string;
  topic: number;
  level: number;
  created: string;
  lastModified: string;
  status: 'active' | 'inactive' | 'archived';
}

export enum DiagramTopic {
  MULTI_TECH = 0,
  CLOUD = 1,
  NETWORK = 2,
  SAP = 3
}

export enum DiagramLevel {
  BROAD = 1,
  DETAILED = 2,
  VERY_DETAILED = 3
}

export const TOPIC_LABELS = {
  [DiagramTopic.MULTI_TECH]: 'Multi Technology',
  [DiagramTopic.CLOUD]: 'Cloud',
  [DiagramTopic.NETWORK]: 'Network',
  [DiagramTopic.SAP]: 'SAP'
};

export const LEVEL_LABELS = {
  [DiagramLevel.BROAD]: 'High Level',
  [DiagramLevel.DETAILED]: 'Detailed',
  [DiagramLevel.VERY_DETAILED]: 'Very Detailed'
};

export const TOPIC_COLORS = {
  [DiagramTopic.MULTI_TECH]: 'bg-purple-100 text-purple-800',
  [DiagramTopic.CLOUD]: 'bg-blue-100 text-blue-800',
  [DiagramTopic.NETWORK]: 'bg-green-100 text-green-800',
  [DiagramTopic.SAP]: 'bg-sap-light-blue text-sap-dark-blue'
};
