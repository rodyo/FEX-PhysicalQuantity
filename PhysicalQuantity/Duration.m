classdef Duration < Time
    % Alias for 'Time'      
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = Duration(varargin)
            obj = obj@Time(varargin{:});
        end        
    end 
end
