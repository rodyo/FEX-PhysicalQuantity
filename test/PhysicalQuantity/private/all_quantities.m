% Get all types to test 
function quantities = all_quantities()    
    % All M-files in '..' define a type, EXCEPT Contents.m    
	fpth = get_quantities_dir();
    qtys = dir(fullfile(fpth,'*.m'));
    [~,types] = cellfun(@fileparts,{qtys.name}','UniformOutput', false);
    quantities = types(~strcmp(types,'Contents'));    
    
    % TODO: (Rody Oldenhuis) also make exception for Epoch() until that's
    % finished:
    quantities = quantities(~strcmp(quantities,'Epoch'));
    
end
