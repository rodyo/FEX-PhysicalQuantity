function suffix = get_suffix(str)
    suffix = '';
    if ismember(lower(str(1)), 'aeiou')
        suffix = 'n'; end
end
