function disp(obj)
        
    old_format = get(0,'Format');
    OC         = onCleanup(@()format(get(0,'Format')));
    format short
        
    obj = obj(:);
        
    X = char([obj.x]');
    Y = char([obj.y]');
    Z = char([obj.z]');
        
	disp( strcat({'[ '}, X, {'   '}, Y, {'   '}, Z, {' ]'}) );
    
    format(old_format);
    
end
