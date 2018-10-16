% Reset the currently used unit of measurement to the unit specified at
% object construction 
function obj = resetUnit(obj)
    % Resets the PhysicalQuantity's unit of measurement to the one that 
    % was used in the original definition of the PhysicalQuantity. 
    %
    % Example: 
    %
    % L = Length(4, 'meters')  % a Length object
    % L.changeUnit('inches')   % L now expresses itself in inches
    % L = L('foot')            % L now expresses itself in feet
    %
    % L.resetUnit()            % now, L will show itself in meters again
    %
    % See also changeUnit.            
    obj.current_unit = obj.given_unit; 
end
