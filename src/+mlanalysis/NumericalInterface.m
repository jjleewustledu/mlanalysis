classdef NumericalInterface
	%% NUMERICALINTERFACE facilitates overriding Matlab numerical operators using bsxfun
	
    %  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$

	methods (Abstract) 
        bsxfun(this, pfun, b)
        plus(this, b)
        minus(this, b)
        times(this, b)
        rdivide(this, b)
        ldivide(this, b)
        power(this, b)
        max(this, b)
        min(this, b)
        rem(this, b) % remainder after division
        mod(this, b)
        
        eq(this, b)
        ne(this, b)
        lt(this, b)
        le(this, b)
        gt(this, b)
        ge(this, b)
        and(this, b)
        or(this, b)
        xor(this, b)
        not(this, b)
        
        norm(this)
        abs(this)
        atan2(this, b)
        hypot(this, b)
        diff(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

