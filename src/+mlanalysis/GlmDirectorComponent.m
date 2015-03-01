classdef GlmDirectorComponent  
	%% GLMDIRECTORCOMPONENT 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    properties (Constant)
        T1_FILEPREFIX = mlsurfer.SurferBuilderPrototype.T1_FILEPREFIX;
    end

	methods (Abstract)
        ds  = theDatasetOnePredictor(this)
        ds  = theDataset(this)
        mdl = createOnePredictorModel(this, predictor)
 		mdl = createModel(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

