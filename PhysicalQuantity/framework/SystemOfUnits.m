classdef (Enumeration) SystemOfUnits 
    enumeration
        
        % The good stuff
        metric % best!
        mks    % (same as metric. Allows one to define "metrics" that are never used in combination with multipliers)
        cgs    % ..meh
        
        % The other stuff
        astronomical
        subatomic
        dimensionless
        time
        
        % The absolutely retarded stuff        
        imperial     % I guess it makes sense in historical context...but 2018!
        us_customary % like...holy wow        
        chinese      % ...I have no words...
        mkps         % mass-kilopond-seconds. Right.
        fps          % Foot-pound-second; does it get any worse?!
        babylonian   % ...apparently, yes, yes it does get worse.
             
    end
end
