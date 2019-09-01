classdef Impedance < Resistance
% Alias for 'Resistance', but with special handling of real and imag
        
    % Dummy constructor - needed until R2017b
    methods
        function obj = Impedance(varargin)
            obj = obj@Resistance(varargin{:}); end 
    end
    
    methods
        
        function J = imag(obj)
            J = Reactance(imag(obj.value), 'Ohm'); end 
        
        function R = real(obj)
            R = Resistance(real(obj.value), 'Ohm'); end 
        
    end
    
end
