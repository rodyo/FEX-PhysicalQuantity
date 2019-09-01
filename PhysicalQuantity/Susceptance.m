classdef Susceptance < Conductance
% In the context of simple units, this is just an alias for 'Conductance'
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Susceptance(varargin)
            obj = obj@Conductance(varargin{:}); end 
    end 
    
end
