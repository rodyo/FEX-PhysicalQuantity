classdef LinearMomentum < Momentum
% Alias for Momentum
    
    % Dummy constructor - needed until R2017b
    methods
        function obj = LinearMomentum(varargin)
            obj = obj@Momentum(varargin{:}); end 
    end
    
end
