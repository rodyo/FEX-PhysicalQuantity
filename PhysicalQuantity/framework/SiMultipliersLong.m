classdef (Enumeration) SiMultipliersLong < double
    enumeration
        zetta    (1e+21)
        exa      (1e+18)
        peta     (1e+15)
        tera     (1e+12)
        giga     (1e+09)
        mega     (1e+06)
        kilo     (1e+03)
        hecto    (1e+02) % generally avoided
        deca     (1e+01) % generally avoided
        none     (1e+00) % <not actually part of the SI prefixes>
        deci     (1e-01) % generally avoided
        centi    (1e-02) % generally avoided, except for meters
        milli    (1e-03)
        micro    (1e-06)
        nano     (1e-09)
        pico     (1e-12)
        femto    (1e-15)
        atto     (1e-18)
        zepto    (1e-21)
        yocto    (1e-24)
    end

    methods
        
        % Convert to string. This is already implemented natively, however, we
        % need to make a single exception. In MATLAB, you either don't implement 
        % the char() method (automatic) or implement it for all enumerated 
        % properties. So, we do that here:
        function str = char(obj)
            switch (obj)
                case SiMultipliersLong.zetta, str = 'zetta';
                case SiMultipliersLong.exa  , str = 'exa';
                case SiMultipliersLong.peta , str = 'peta';
                case SiMultipliersLong.tera , str = 'tera';
                case SiMultipliersLong.giga , str = 'giga';
                case SiMultipliersLong.mega , str = 'mega';
                case SiMultipliersLong.kilo , str = 'kilo';
                case SiMultipliersLong.hecto, str = 'hecto';
                case SiMultipliersLong.deca , str = 'deca';
                case SiMultipliersLong.none , str = '';    % <---- the exception
                case SiMultipliersLong.deci , str = 'deci';
                case SiMultipliersLong.centi, str = 'centi';
                case SiMultipliersLong.milli, str = 'milli';
                case SiMultipliersLong.micro, str = 'micro';
                case SiMultipliersLong.nano , str = 'nano';
                case SiMultipliersLong.pico , str = 'pico';
                case SiMultipliersLong.femto, str = 'femto';
                case SiMultipliersLong.atto , str = 'atto';
                case SiMultipliersLong.zepto, str = 'zepto';
                case SiMultipliersLong.yocto, str = 'yocto';
            end
        end
        
        % Convert the long representation to short representation
        function si = SiMultipliersShort(obj)  
            if isempty(obj)
                si = []; 
            else
                si(numel(obj)) = SiMultipliersShort.none;
                for ii = 1:numel(obj)
                    s_short = enumeration('SiMultipliersShort');
                    si(ii)  = s_short( double(s_short) == double(obj(ii)) );
                end
            end
        end
        
    end

end
