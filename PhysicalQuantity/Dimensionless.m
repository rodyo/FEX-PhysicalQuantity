classdef Dimensionless < PhysicalQuantityInterface

    %% Properties
    
    properties (Constant)        
        %                               L M t C T I N ii
        dimensions = PhysicalDimension([0 0 0 0 0 0 0 0 ]);
        units      = get_units('no_units');        
    end
    
    
    %% Methods
    
    % Class basics
    methods 
        
        % Constructor
        function obj = Dimensionless(varargin)   
            
            % Call super
            obj = obj@PhysicalQuantityInterface(varargin{:});
            
            % These are basically all equal to the '[-]' "unit"
            [obj.given_unit]   = deal(Dimensionless.units.base_unit);
            [obj.current_unit] = deal(Dimensionless.units.base_unit);
            
        end
        
    end
    
    % rand() method - for things like rand(1,3,'Dimensionless')
    methods (Static)
        function R = rand(varargin)
            R = Dimensionless(rand(varargin{:})); end
    end
        
end
