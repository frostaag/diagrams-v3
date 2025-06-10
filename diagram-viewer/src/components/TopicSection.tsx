import { Diagram, DiagramTopic, TOPIC_LABELS, TOPIC_COLORS } from '@/types/diagram';
import { DiagramCard } from './DiagramCard';
import { cn } from '@/lib/utils';
import { ChevronDown, ChevronRight } from 'lucide-react';
import { useState } from 'react';

interface TopicSectionProps {
  topic: DiagramTopic;
  diagrams: Diagram[];
  onDiagramClick: (diagram: Diagram) => void;
}

export function TopicSection({ topic, diagrams, onDiagramClick }: TopicSectionProps) {
  const [isExpanded, setIsExpanded] = useState(true);
  
  return (
    <div className="mb-8">
      <div
        className="flex items-center gap-3 mb-4 cursor-pointer"
        onClick={() => setIsExpanded(!isExpanded)}
      >
        {isExpanded ? (
          <ChevronDown className="w-5 h-5 text-gray-600" />
        ) : (
          <ChevronRight className="w-5 h-5 text-gray-600" />
        )}
        
        <h2 className="text-2xl font-bold text-gray-900">
          {TOPIC_LABELS[topic]}
        </h2>
        
        <span className={cn(
          "inline-flex items-center px-3 py-1 rounded-full text-sm font-medium",
          TOPIC_COLORS[topic]
        )}>
          {diagrams.length} diagram{diagrams.length !== 1 ? 's' : ''}
        </span>
      </div>
      
      {isExpanded && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {diagrams.map((diagram) => (
            <DiagramCard
              key={diagram.filename}
              diagram={diagram}
              onClick={onDiagramClick}
            />
          ))}
        </div>
      )}
    </div>
  );
}
