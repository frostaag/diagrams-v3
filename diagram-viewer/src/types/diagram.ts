export interface Diagram {
  filename: string;
  topic: DiagramTopic;
  level: DiagramLevel;
  description: string;
  path: string;
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
