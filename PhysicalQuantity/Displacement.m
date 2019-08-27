classdef Displacement < Length
% Alias for 'Length'              
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Displacement(varargin)
            obj = obj@Length(varargin{:}); end 
    end 
    
end
