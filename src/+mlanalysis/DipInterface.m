classdef DipInterface  
	%% DIPINTERFACE   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 
	methods (Abstract) 
        dip_image(this)
        dipshow(this)
        dipmax(this)
        dipmean(this)
        dipmedian(this)
        dipmin(this)
        dipprod(this)
        dipstd(this)
        dipsum(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

