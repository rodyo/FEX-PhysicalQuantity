# PhysicalQuantity

Consistent, fully automated, intuitive handling of physical units 


Can't remember how to convert feet to meters? 
Wish there was a way around the dreaded radians-versus-degrees problem?
Ever stared yourself blind on a bug that was due to inconsistent units?

Look no further. This set of tools will resolve all of those problems, 
once and for all. 

Preparations: 
- put the PhysicalQuantity and PhysicalVectorQuantity directories on the
  MATLAB search path

Example session: 

    >> L = Length(4, 'm')
    L = 
         4 meters 

    >> R = Length(2, 'ft')
    R = 
         2 feet 

    >> A = Area(L*R, 'm^2')
    A = 
         2.438400000000000e+00 square meters 

Wait...really? That can't be right. Let's see, 1 ft = 0.3048 meter, so
2 ft * 4 m = 2*0.3048 * 4 = 2.4384 ... square ... meters. Wow!

What if I try to break it?

    >> A = Area(L*L*R, 'm^2')
    Error using Area (line 13)
    Can't create 'Area' (dimensions [L]²) from a quantity with 
    dimensions [L]³. 

    >> A = Area(L*R, 'm^3')
    Error using Area (line 13)
    Dimensions implied by the given string ([L]³) are incompatible with 
    those of an Area ([L]²).

    >> tan( Area(L*R, 'm^2') )
    Can't compute the tangent() of an Area.

OK, well, that ... could actually be very useful! How's it handle angles? 

    >> theta = Angle(-1.2, 'deg')
    theta = 
        -1.200000000000000e+00 degrees 

    >> phi   = Angle(0.5, 'rad')
    phi = 
        500 milliradians 

    >> cos(theta)
    ans =
        9.997806834748455e-01  % <- yup, same as cosd(-1.2)

# Overview

In physics, a quantity's *unit* is intricately connected to the quantity 
itself. Typically, quantities with different units cannot be used in the 
same operation, without some sort of conversion between them - "you can't
add apples to oranges". 

This is not unlike data types in most programming languages. What do you 
expect to get when you divide two integers? Add a boolean to a character? 
You can't just do that without some sort of conversion. 

Therefore, it makes sense to create a data type that takes physical 
units into consideration for all operations. Preferably, this data type 
is also super-easy to use, and produces intelligible error messages when 
it's used in a physically meaningless way. 

And that is exactly what this tool set aims to provide. 


# How to use 

PysicalQuantities are constructed from scratch like this:

    Q = <quantityname>(<value>, <units>)

Take a look in the PhysicalQuantity directory for an overview of currently 
supported <quantities>. The <value> can be any numeric value (including 
sparse, complex, etc.). The <units> should be a string specifying any of 
the supported long/short unit names (see below), possibly combined by the 
following operations: 

    '*': multiply
    '/': divide
    '^': exponentiate

Example: 

    F = Force(300, 'Newton')
    r = Density(2, 'kg/m^3')

To get a list of available units: 

    >> L = Length();
    >> L.listUnits()
    Length supports the following units of measurement:
      - Chinese mile (li)
      - Parsec (pc)
      - astronomical unit (AU)
      - foot (ft)
      - furlong (fur)
      - inch (in)
      - lightyear (ly)
      - meter (m)
      - mile (mi)
      - nautical mile (n.mi)
      - smoot (smt)
      - statute mile (st.mi)
      - yard (yd)
      - Ångström (Å)
    

Conversions between compatible units are seamless: 

    >> L = Length(20, 'yards');
    >> L('meters')
    ans = 
         1.828800000000000e+01 meters 

    >> P = Length(3, 'inch');
    >> Q = Length(18, 'foot');
    >> Length( L*P/Q, 'meter' )
    ans = 
        2.54e+02 millimeters 

Operations work as expected: 

    >> L = Length(1, 'inch');
    >> t = Duration(32, 'seconds');
    >> M = Mass(18, 'lb');
    >> F = Force( M*L/t/t, 'Newton' )
    ans = 
         2.025219058242187e+02 milliNewtons 



# Note

This is a work in progress, and in its early stages. Many things will still
go incorrectly. If you observe something odd, please give me a heads up. 
Preferably, raise issue on GitHub :) Otherwise, plain ol' email will do: 

oldenhuis@gmail.com





