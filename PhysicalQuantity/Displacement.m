classdef Displacement < Length
    % Alias for 'Length'              
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Displacement(varargin)
            obj = obj@Length(varargin{:});
        end        
    end 
end
