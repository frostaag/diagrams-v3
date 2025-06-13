import { Diagram, TOPIC_LABELS, LEVEL_LABELS } from '@/types/diagram';
import { X, Download, ExternalLink } from 'lucide-react';

interface DiagramModalProps {
  diagram: Diagram | null;
  isOpen: boolean;
  onClose: () => void;
}

export function DiagramModal({ diagram, isOpen, onClose }: DiagramModalProps) {
  if (!isOpen || !diagram) return null;

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

  const handleOpenInNewTab = () => {
    // Use the cache-busted path for viewing
    window.open(diagram.path, '_blank');
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-black bg-opacity-50"
        onClick={onClose}
      />
      
      {/* Modal */}
      <div className="relative bg-white rounded-lg shadow-xl max-w-6xl max-h-[90vh] w-full mx-4 flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b">
          <div className="flex-1">
            <h2 className="text-xl font-semibold text-gray-900 mb-2">
              {diagram.description}
            </h2>
            <div className="flex items-center gap-4 text-sm text-gray-600">
              <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                {TOPIC_LABELS[diagram.topic]}
              </span>
              <span className="bg-gray-100 text-gray-800 px-2 py-1 rounded-full">
                Level {diagram.level} - {LEVEL_LABELS[diagram.level]}
              </span>
            </div>
          </div>
          
          <div className="flex items-center gap-2 ml-4">
            <button
              onClick={handleDownload}
              className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
              title="Download"
            >
              <Download className="w-5 h-5" />
            </button>
            
            <button
              onClick={handleOpenInNewTab}
              className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
              title="Open in new tab"
            >
              <ExternalLink className="w-5 h-5" />
            </button>
            
            <button
              onClick={onClose}
              className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>
        
        {/* Image */}
        <div className="flex-1 p-6 overflow-auto">
          <div className="flex justify-center">
            <img
              src={diagram.path}
              alt={diagram.description}
              className="max-w-full h-auto rounded-lg shadow-sm"
              style={{ maxHeight: 'calc(90vh - 200px)' }}
            />
          </div>
        </div>
      </div>
    </div>
  );
}
