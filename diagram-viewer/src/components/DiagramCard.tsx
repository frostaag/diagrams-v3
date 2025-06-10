import { Diagram, LEVEL_LABELS } from '@/types/diagram';
import { cn } from '@/lib/utils';

interface DiagramCardProps {
  diagram: Diagram;
  onClick: (diagram: Diagram) => void;
}

export function DiagramCard({ diagram, onClick }: DiagramCardProps) {
  return (
    <div
      className={cn(
        "sap-tile p-4 h-48 flex flex-col justify-between",
        "hover:scale-105 transform transition-transform duration-200"
      )}
      onClick={() => onClick(diagram)}
    >
      <div className="flex-1">
        <h3 className="font-semibold text-gray-900 mb-2 line-clamp-2">
          {diagram.description}
        </h3>
        <div className="flex items-center gap-2 mb-2">
          <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
            Level {diagram.level}
          </span>
          <span className="text-xs text-gray-500">
            {LEVEL_LABELS[diagram.level]}
          </span>
        </div>
      </div>
      
      <div className="mt-auto">
        <div className="text-xs text-gray-400 truncate">
          {diagram.filename}
        </div>
      </div>
    </div>
  );
}
