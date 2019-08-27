function h = plot(obj, varargin)
    
    old_format = get(0, 'format');
    OC = onCleanup(@()format(old_format));
    
    format('short');    
    [val1, unitstr1] = obj.getDisplayedUnit();
    format(old_format);
    
    
    
    if isa(varargin{1}, 'PhysicalQuantityInterface')
        [val2, unitstr2] = varargin{1}.getDisplayedUnit(); 
        varargin = varargin(2:end);
    else
        % TODO: (Rody Oldenhuis) PROPER 1-arg plot()
        val2=varargin{1};
        varargin = varargin(2:end);
        
    end
    
    h = plot(val1,val2, varargin{:});
    axs = gca();
    axs.XTickLabel = strcat(axs.XTickLabel, {' '}, unitstr1);
        
    
end
