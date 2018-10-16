classdef Epoch 
    
    %% properties
    
    properties (SetAccess = immutable)
        
        t (1,1) datetime = datetime(now())
        
    end
    
    
    %% methods
    
    % Class basics
    methods
        function obj = Epoch(varargin)
            
            datetime(varargin);
            
        end        
    end
    
    % Operator overloads
    methods
    end
    
end
