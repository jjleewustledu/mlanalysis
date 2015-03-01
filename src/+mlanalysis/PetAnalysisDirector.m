classdef PetAnalysisDirector < mlanalysis.AnalysisDirector
	%% PETANALYSISDIRECTOR  director to an analysis builder design pattern
	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
        analysisBuilder
    end

    methods (Static)
        function this = createFromSessionPath(spth)
            import mlanalysis.*;
            this = PetAnalysisDirector( ...
                AnalysisBuilder.createFromSessionPath(spth));
        end
    end
    
	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function lr = mcaOefSampling(this)
        end
 		function lr = pcaOefSampling(this) 
        end
 		function lr = cerebellarOefSampling(this) 
        end
 		function lr = mcaCmroSampling(this) 
        end
 		function lr = pcaCmroSampling(this) 
        end
 		function lr = cerebellarCmroSampling(this) 
        end        
 		function lr = mcaFlowSampling(this) 
        end
 		function lr = pcaFlowSampling(this) 
        end
 		function lr = cerebellarFlowSampling(this) 
        end
    end
    
    methods (Access = 'protected')
 		function this = PetAnalysisDirector(varargin) 
 			%% PETANALYSISDIRECTOR prefers creation methods 
 			%  Usage:  this = PetAnalysisDirector(analysis_builder) 

 			this = this@mlanalysis.AnalysisDirector(varargin{:}); 
 		end %  ctor 
        function lr = sampling(this, region, metric)
            assert(isfield(this.analysisBuilder, region));
            assert(isfield(this.analysisBuilder, metric));
            lr = this.analysisBuilder.sampling(region, metric);
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

