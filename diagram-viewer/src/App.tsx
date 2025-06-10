import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { getDiagramList, groupDiagramsByTopic } from '@/utils/diagramParser';
import { Diagram, DiagramTopic } from '@/types/diagram';
import { TopicSection } from '@/components/TopicSection';
import { DiagramModal } from '@/components/DiagramModal';
import { Search, Folder } from 'lucide-react';

function App() {
  const [selectedDiagram, setSelectedDiagram] = useState<Diagram | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);

  const { data: diagrams = [], isLoading, error } = useQuery({
    queryKey: ['diagrams'],
    queryFn: getDiagramList
  });

  const filteredDiagrams = diagrams.filter(diagram =>
    diagram.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
    diagram.filename.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const groupedDiagrams = groupDiagramsByTopic(filteredDiagrams);

  const handleDiagramClick = (diagram: Diagram) => {
    setSelectedDiagram(diagram);
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setSelectedDiagram(null);
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-sap-light-gray flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-sap-blue mx-auto mb-4"></div>
          <p className="text-gray-600">Loading diagrams...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-sap-light-gray flex items-center justify-center">
        <div className="text-center text-red-600">
          <p>Error loading diagrams</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-sap-light-gray">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-sap-blue rounded-lg">
                <Folder className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">
                  SAP Diagram Viewer
                </h1>
                <p className="text-sm text-gray-600">
                  {diagrams.length} diagrams available
                </p>
              </div>
            </div>

            {/* Search */}
            <div className="relative max-w-md w-full">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Search className="h-5 w-5 text-gray-400" />
              </div>
              <input
                type="text"
                placeholder="Search diagrams..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-sap-blue focus:border-sap-blue"
              />
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {filteredDiagrams.length === 0 ? (
          <div className="text-center py-12">
            <Search className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <p className="text-gray-600">
              {searchTerm ? 'No diagrams match your search.' : 'No diagrams found.'}
            </p>
          </div>
        ) : (
          <>
            {/* Topic Sections */}
            {Object.values(DiagramTopic)
              .filter(topic => typeof topic === 'number')
              .map(topic => {
                const topicDiagrams = groupedDiagrams.get(topic as DiagramTopic);
                if (!topicDiagrams || topicDiagrams.length === 0) return null;
                
                return (
                  <TopicSection
                    key={topic}
                    topic={topic as DiagramTopic}
                    diagrams={topicDiagrams}
                    onDiagramClick={handleDiagramClick}
                  />
                );
              })}
          </>
        )}
      </main>

      {/* Modal */}
      <DiagramModal
        diagram={selectedDiagram}
        isOpen={isModalOpen}
        onClose={handleCloseModal}
      />
    </div>
  );
}

export default App;
