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
        "sap-tile p-4 h-48 flex flex-col justify-between relative",
        "hover:scale-105 transform transition-transform duration-200"
      )}
      onClick={() => onClick(diagram)}
    >
      {/* ID Badge */}
      {diagram.id && (
        <div className="absolute top-2 right-2 bg-gradient-to-r from-blue-600 to-blue-700 text-white text-xs font-bold px-2 py-1 rounded-md shadow-sm">
          ID-{diagram.id}
        </div>
      )}
      
      <div className="flex-1">
        <h3 className="font-semibold text-gray-900 mb-2 line-clamp-2 pr-16">
          {diagram.id ? `${diagram.description}` : diagram.description}
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
          {diagram.originalName || diagram.filename}
        </div>
        {diagram.id && (
          <div className="text-xs text-blue-600 font-medium mt-1">
            Diagram ID: {diagram.id}
          </div>
        )}
      </div>
    </div>
  );
}
