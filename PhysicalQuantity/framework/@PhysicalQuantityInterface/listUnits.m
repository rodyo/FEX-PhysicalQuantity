% List all supported units of measurement 
function varargout = listUnits(obj)
    % List all available units of measurement for this PhysicalQuantity.
    % 
    % May be called with either 0 or 1 output argument. If no output
    % argument is requested, then a simple list of (long),(short) name 
    % pairs is pretty-printed. With an output argument, that same list 
    % is returned as a cell array.
    %
    % See also changeUnit, resetUnit.
    nargoutchk(0,1);
    
    subclass = class(obj);

    if isempty(obj.units)
        if nargout==0
            fprintf(1, 'A%s ''%s'' has no associated units of measurement.\n',...
                    get_suffix(subclass), subclass);
        else
            varargout{1} = [];
        end
        return; 
    end

    allunits = obj.units.getAllUnits();
    [ln, I]  = sort({allunits.long_name});
    sn       = {allunits.short_name};
    allunits = [ln; sn(I)];
    
    % Make exception for Mass ('kg' is the SI base unit, while 'g' is the base unit used 
    % internally for easier implementation) 
    if isa(obj, 'Mass')        
        allunits(strcmp(allunits,'gram')) = {'kilogram'};
        allunits(strcmp(allunits,'g'))    = {'kg'};
    end
        
    if nargout==0
        fprintf(1, '%s supports the following units of measurement:\n%s',...
                subclass,...
                sprintf('  - %s (%s)\n', allunits{:}));
    else
        varargout{1} = allunits';
    end
    
end
