classdef Point < Position    
% Alias for Position   
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Point(varargin)
            obj = obj@Position(varargin{:}); end 
    end    
    
end
