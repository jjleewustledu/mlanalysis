classdef (Abstract) IModel
	%% IMODEL  

	%  $Revision$
 	%  was created 13-Dec-2017 20:14:58 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlanalysis/src/+mlanalysis.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Abstract)
        kernel
 		independentData
        dependentData  
        
        useSynthetic % let initial parameters form synthetic data
        M % noninformative prior width
        nAnneal
        nBeta
        nProposals
    end

    methods (Static, Abstract)        
        name = parameterIndexToName(this, idx)
    end
    
	methods (Abstract)
        this = estimateData(this)
        Q    = objectiveFunc(this)        
        ps   = modelParameters(this)    
        sps  = modelStdParameters(this)
        ps   = solverParameters(this)
        this = constructSyntheticKernel(this)
        this = constructKernelWithData(this)
        this = updateModel(this, solvr)
        
        plot(this)
        writetable(this)
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

