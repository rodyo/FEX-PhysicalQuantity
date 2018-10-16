classdef Vertex < Position    
    % Alias for Position  
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Vertex(varargin)
            obj = obj@Position(varargin{:});
        end        
    end    
end
