classdef Enthalpy < Energy
% Alias for 'Energy'              
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = Enthalpy(varargin)
            obj@Energy(varargin{:}); end 
    end 
    
end
