classdef Np755GlmDirectorComponent  
	%% NP755GLMDIRECTORCOMPONENT 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    properties (Abstract)
 		 dsa
         thicknessAbsolute
         thicknessDelta
         %thicknessStd
         thicknessCOV
         adc
         dwi
         CBF
         CBV
         MTT
         t0
         alpha
         invAlpha
         beta
         invBeta
         gamma
         ho
         invHo
         oo
         oef
         segIds
         tauHo
         tauOo
         oc
 	end 

	methods (Abstract)
        ds  = theDatasetOnePredictor(this)
        ds  = theDataset(this)
        mdl = createOnePredictorModel(this, predictor)
 		mdl = createModel(this)
 	end 

    properties (Access = 'protected')        
        noDiffusion_      = false;
        noPerfusion_      = false;
        noThickness_      = false;
        noPET_            = false;
        noCarbonMonoxide_ = false;
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

