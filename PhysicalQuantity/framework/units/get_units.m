function varargout = get_units(which_one)
    
    % Instantiating the units may take some time, therefore, do it only once and
    % save as a persistent variable to improve upon performance. 
    persistent All_Units    
    persistent All_Units_Concatenated
    if isempty(All_Units)   
        
        % TODO: (Rody) use file cache when the framework's finished, for
        % performance reasons
        
        % Bind all outputs from all function defined in this directory 
        % to a structure
        [pth, fn,ex] = fileparts(which(mfilename()));
        
        ls = dir(pth);        
        ls = {ls.name};        
        ls = ls(~ismember(ls, {'.','..',[fn ex]}));
        
        All_Units = struct();        
        for ii = 1:numel(ls)            
            [~,ufn] = fileparts(ls{ii});
            str     = lower([ufn(1),...
                            regexprep(ufn(2:end),...
                                      '([A-Z]{1})([^A-Z]+)',...
                                      '_$1$2')]);                                 
            All_Units.(str) = eval(ufn);
        end
        
    end
    
    % No argument - print list and return 
    fn = fieldnames(All_Units);
    if nargin == 0                
        fprintf(1, 'Available units:\n%s',...
                sprintf('  - %s\n', fn{:}));
        return; 
    end
    
    % Checks
    assert(nargin==1 && nargout<=1,...
           [mfilename ':argument_count'],...
           '%s() only takes 1 argument, and returns 1 argument.',...
           mfilename);
        
    assert(ischar(which_one) && isvector(which_one),...
           [mfilename ':invalid_input_argument'],...
           'The input argument to %s() must be a character array.',...
           mfilename);       
    
    assert(any( strcmp([fn; 'all_units'], which_one) ),...
           [mfilename ':name_not_found'],...
           'No units called ''%s'' registered in %s().',...
           which_one, mfilename);
    
    % Return desired slice
    switch which_one
        
        case 'all_units'
            if isempty(All_Units_Concatenated)
                u = [];
                for ii = 1:numel(fn)
                    u = [u; All_Units.(fn{ii}).getAllUnits()]; end %#ok<AGROW>
                All_Units_Concatenated = u;
            end
            units = All_Units_Concatenated;
            
        otherwise
            % Simply index and return the result
            units = All_Units.(which_one);
    end
    
    varargout{1} = units;
    
end
