classdef (Enumeration) SiMultipliersShort < double
    enumeration
        Z     (1e+21)
        E     (1e+18)
        P     (1e+15)
        T     (1e+12)
        G     (1e+09)
        M     (1e+06)
        k     (1e+03)
        h     (1e+02) % generally avoided
        da    (1e+01) % generally avoided
        none  (1e+00) % <not actually part of the SI prefixes>
        d     (1e-01) % generally avoided
        c     (1e-02) % generally avoided, except for meters
        m     (1e-03)
        u     (1e-06) % variant spelling for 'micro'
        mu    (1e-06) % variant spelling for 'micro'
        n     (1e-09)
        p     (1e-12)
        f     (1e-15)
        a     (1e-18)
        z     (1e-21)
        y     (1e-24)
    end
    
    methods
        
        % Convert to string. This is already implemented natively, however, 
        % we need to make a single exception. In MATLAB, you either don't 
        % implement the char() method (automatic) or implement it for all 
        % enumerated properties. So, we do that here:
        function str = char(obj)            
            switch (obj)
                case SiMultipliersShort.Z   , str = 'Z';
                case SiMultipliersShort.E   , str = 'E';
                case SiMultipliersShort.P   , str = 'P';
                case SiMultipliersShort.T   , str = 'T';
                case SiMultipliersShort.G   , str = 'G';
                case SiMultipliersShort.M   , str = 'M';
                case SiMultipliersShort.k   , str = 'k';
                case SiMultipliersShort.h   , str = 'h';
                case SiMultipliersShort.da  , str = 'da';
                case SiMultipliersShort.none, str = '';   % <--------------
                case SiMultipliersShort.d   , str = 'd';
                case SiMultipliersShort.c   , str = 'c';
                case SiMultipliersShort.m   , str = 'm';
                case SiMultipliersShort.u   , str = char(956); % <---------
                case SiMultipliersShort.mu  , str = char(956); % <---------
                case SiMultipliersShort.n   , str = 'n';
                case SiMultipliersShort.p   , str = 'p';
                case SiMultipliersShort.f   , str = 'f';
                case SiMultipliersShort.a   , str = 'a';
                case SiMultipliersShort.z   , str = 'z';
                case SiMultipliersShort.y   , str = 'y';
            end
        end
        
        
        % Convert the short representation to long representation
        function si = SiMultipliersLong(obj) 
            if isempty(obj)
                si = [];
            else
                si(numel(obj)) = SiMultipliersShort.none;
                for ii = 1:numel(obj)
                    s_long = enumeration('SiMultipliersLong');
                    si(ii) = s_long( double(s_long) == double(obj(ii)) );
                end
            end
        end
        
    end
    
end
