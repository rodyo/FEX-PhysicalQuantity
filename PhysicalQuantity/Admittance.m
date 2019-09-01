classdef Admittance < Conductance
% Alias for 'Conductance', but with special handling of real and imag
        
    % Dummy constructor - needed until R2017b
    methods
        function obj = Admittance(varargin)
            obj = obj@Conductance(varargin{:}); end 
    end
    
    methods
        
        function J = imag(obj)
            J = Susceptance(imag(obj.value), 'S'); end 
        
        function R = real(obj)
            R = Conductance(real(obj.value), 'S'); end 
        
    end
    
end
