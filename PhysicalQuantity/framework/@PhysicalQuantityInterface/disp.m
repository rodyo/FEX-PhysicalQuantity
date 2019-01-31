function disp(obj)  
  
    dispstr = cell(numel(obj),1);
    for ii = 1:numel(obj)

        % Abbreviation
        O = obj(ii);
        
        % Make exceptions for the genericclass and invalid objects
        if isa(O,O.genericclass)
            % NOTE: (Rody Oldenhuis) evalc() is the only possible way in MATLAB
            % to capture command-line output. It is done here to automatically
            % comply with the current format/locale settings
            dispstr{ii} = evalc(['disp([''<< intermediate quantity ('' ',...
                                 'char(O.intermediate_dimensions) '') >>''])']);
            dispstr{ii} = regexprep(dispstr{ii}, newline(), '');        
        else
            [converted,...
             dispname] = obj.getDisplayedUnit(); %#ok<ASGLU> (used in evalc)

            % NOTE: (Rody Oldenhuis) evalc() is the only way in MATLAB to
            % capture arbitrary command line output in a variabe. It is used
            % here to automatically convert the value to a string, respecting 
            % the current FORMAT setting, locale, etc. 
            dispval = strrep(evalc('disp(converted);'), newline, '');

            % Final display string
            dispstr{ii} = sprintf('%s %s%s',...
                                  dispval,...                                  
                                  dispname);
        end     

    end
    
    % This is an array with the correct strings in the correct shape
    dispstr = reshape(dispstr, size(obj)); 
     
    % We're going to use disp() on a cellstring that has been formed by disp().
    % That means, the leading spaces will be doubled. Remove the largest common
    % number of leading spaces
    rmspaces = min(cellfun(@(x)find(~isspace(x),1,'first'), dispstr(:)))-1;
    dispstr  = regexprep(dispstr, ['^\s{' int2str(rmspaces) '}'], '');
    
    % The sizes tend to be different for different precisions. Make them 
    % all equal to eachother again
    minlen  = max(cellfun('prodofsize', dispstr(:)));
    dispstr = cellfun(@(x) sprintf(['%' int2str(minlen) 's'],x),...
                      dispstr,...
                      'UniformOutput', false);%#ok<NASGU> (used in evalc)
    
    % Let MATLAB do most of the work. It's not perfect for multi-dimensional
    % arrays, but otherwise we'd also have to overload the display() function...    
    str = evalc('disp(dispstr);');
    str = regexprep(str, '''', ' ');
    str = regexprep(str, '(:', [inputname(1) '(:']);
    disp(str);
    
end
