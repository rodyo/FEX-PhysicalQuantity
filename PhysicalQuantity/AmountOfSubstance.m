classdef AmountOfSubstance < PhysicalQuantityInterface
    
    properties (Constant)
        dimensions = SiBaseUnit.N.dimensions
        units      = get_units('amount_of_substance_units') 
    end
        
    % Dummy constructor - needed until R2017b. If you're on a newer version
    % than that, this whole methods block can be safely removed.
    methods
        function obj = AmountOfSubstance(varargin)
            obj = obj@PhysicalQuantityInterface(varargin{:});
        end        
    end 
    
end
