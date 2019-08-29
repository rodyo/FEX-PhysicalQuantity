classdef Vector < Position    
% Alias for Position   
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Vector(varargin)
            obj = obj@Position(varargin{:}); end 
    end    
    
end
