import { useState } from 'react';
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { getDiagramList, groupDiagramsByTopic } from '@/utils/diagramParser';
import { Diagram, DiagramTopic } from '@/types/diagram';
import { TopicSection } from '@/components/TopicSection';
import { DiagramModal } from '@/components/DiagramModal';
import { forceRefresh } from '@/utils/cacheManager';
import { Search, Folder, RefreshCw, Plus } from 'lucide-react';

function App() {
  const [selectedDiagram, setSelectedDiagram] = useState<Diagram | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);

  const queryClient = useQueryClient();

  const { data: diagrams = [], isLoading, error } = useQuery({
    queryKey: ['diagrams'],
    queryFn: getDiagramList
  });

  const handleRefresh = async () => {
    setIsRefreshing(true);
    
    // Invalidate and refetch the diagrams query
    await queryClient.invalidateQueries({ queryKey: ['diagrams'] });
    
    // Force refresh the entire page as fallback
    setTimeout(() => {
      forceRefresh();
    }, 1000);
  };

  const filteredDiagrams = diagrams.filter(diagram =>
    diagram.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
    diagram.filename.toLowerCase().includes(searchTerm.toLowerCase()) ||
    (diagram.id && diagram.id.includes(searchTerm)) ||
    (diagram.originalName && diagram.originalName.toLowerCase().includes(searchTerm.toLowerCase()))
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

  const handleRequestDiagram = () => {
    const sbpaUrl = 'https://frosta-apps-dev.eu10.process-automation.build.cloud.sap/comsapspaprocessautomation.comsapspabpiprocessformtrigger/index.html?environmentId=frosta&projectId=eu10.frosta-apps-dev.newdiagramrequest&triggerId=diagramChangeRequest';
    window.open(sbpaUrl, '_blank');
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

            <div className="flex items-center gap-4">
              {/* Request Diagram Button */}
              <button
                onClick={handleRequestDiagram}
                className="group relative inline-flex items-center gap-3 px-6 py-3 whitespace-nowrap bg-gradient-to-r from-blue-500 via-blue-600 to-blue-700 text-white text-sm font-semibold rounded-xl shadow-lg hover:shadow-xl hover:from-blue-600 hover:via-blue-700 hover:to-blue-800 transform hover:scale-105 transition-all duration-200 focus:outline-none focus:ring-4 focus:ring-blue-300 focus:ring-opacity-50 border border-blue-400 hover:border-blue-300"
                title="Request new diagram or changes to existing diagrams"
              >
                <div className="flex items-center justify-center w-5 h-5 bg-white bg-opacity-25 rounded-full group-hover:bg-opacity-40 transition-all duration-200">
                  <Plus className="w-3 h-3" />
                </div>
                <span className="font-semibold text-white">New Diagram Request</span>
                <div className="absolute inset-0 rounded-xl bg-gradient-to-r from-white to-transparent opacity-0 group-hover:opacity-15 transition-opacity duration-200"></div>
              </button>

              {/* Refresh Button */}
              <button
                onClick={handleRefresh}
                disabled={isRefreshing}
                className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                title="Refresh diagrams and clear cache"
              >
                <RefreshCw className={`w-5 h-5 ${isRefreshing ? 'animate-spin' : ''}`} />
              </button>

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
