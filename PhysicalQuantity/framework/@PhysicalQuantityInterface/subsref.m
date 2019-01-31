% Shorthand for obj.changeUnit('desired_unit', true);
%
% See also changeUnit.    
function varargout = subsref(obj, S, varargin)
    try            
        % Capture deliberately abusive calls
        assert(isstruct(S) && all(ismember(fieldnames(S), {'type' 'subs'})),...
               [mfilename('class') ':invalid_substruct'],...
               'Invalid indexing operation.');

        % We ONLY overload indexing with a string; anything else gets
        % delegated to the built-in method.                
        if strcmp(S(1).type, '()') && ...
                iscell(S(1).subs) && ~isempty(S(1).subs) && numel(S(1).subs)==1 && ...
                (( ischar(S(1).subs{1}) && isvector(S(1).subs) ) || ...
                   isstring(S(1).subs{1}) )
            
            narginchk(2,2);
            nargoutchk(0,1);
            varargout{1}  = obj.changeUnit(S(1).subs{1}, true);

        % (the built-in subsref)
        else
            [varargout{1:nargout}] = builtin('subsref',...
                                             obj, S,...
                                             varargin{:});
        end

    catch ME
        throwAsCaller(ME);
    end
end
