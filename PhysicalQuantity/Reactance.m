classdef Reactance < Resistance
% In the context of simple units, this is just an alias for 'Resistance'
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Reactance(varargin)
            obj = obj@Resistance(varargin{:}); end 
    end 
    
end
