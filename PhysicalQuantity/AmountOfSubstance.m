classdef AmountOfSubstance < PhysicalQuantityInterface
    
    properties (Constant)
        dimensions = SiBaseUnit.N.dimensions
        units      = get_units('amount_of_substance_units') 
    end
        
    % Dummy constructor - needed until R2017b
    methods
        function obj = AmountOfSubstance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:}); end 
    end 
    
    % rand() method - for things like rand(1,3,'AmountOfSubstance')
    methods (Static)
        function R = rand(varargin)
            R = AmountOfSubstance(rand(varargin{:}), 'mol'); end
    end    
    
end
