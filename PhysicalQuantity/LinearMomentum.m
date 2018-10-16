classdef LinearMomentum < Momentum
    % Alias for Momentum
    
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = LinearMomentum(varargin)
            obj = obj@Momentum(varargin{:});
        end        
    end
        
end
