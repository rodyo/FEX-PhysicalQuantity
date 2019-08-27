classdef Duration < Time
% Alias for 'Time'      
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Duration(varargin)
            obj = obj@Time(varargin{:}); end 
    end 
    
end
