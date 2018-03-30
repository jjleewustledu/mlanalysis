classdef Test_PetAnalysisDirector < mlanalysis_xunit.Test_mlanalysis
	%% TEST_PETANALYSISDIRECTOR 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlanalysis.Test_PetAnalysisDirector % in . or the matlab path
	%          >> runtests mlanalysis.Test_PetAnalysisDirector:test_nameoffunc
	%          >> runtests(mlanalysis.Test_PetAnalysisDirector, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
 		director
    end

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        
        
        
        
        function test_mcaOefSampling(this)
            assertVectorsAlmostEqual(this.expectedMcaOefSampling, this.director.mcaOefSampling);
        end
        function test_pcaOefSampling(this)
        end
        function test_cerebellarOefSampling(this)
        end        
        function test_mcaCmroSampling(this)
        end
        function test_pcaCmroSampling(this)
        end
        function test_cerebellarCmroSampling(this)
        end
        function test_mcaFlowSampling(this)
        end
        function test_pcaFlowSampling(this)
        end
        function test_cerebellarFlowSampling(this)
        end        
 		function test_mcaCerebellarRatio(this) 
 			import mlanalysis.*; 
        end
        function test_mcaCrossCerebellarRatio(this)
 			import mlanalysis.*; 
        end 
        function test_mcaPcaRatio(this) 
 			import mlanalysis.*; 
 		end 
        function test_mcaCrossPcaRatio(this) 
 			import mlanalysis.*; 
        end
        function test_createFromSessionPath(this)
            assertTrue(isa(this.director, 'mlanalysis.PetAnalysisDirector'));
        end
        
 		function this = Test_PetAnalysisDirector(varargin) 
 			this = this@mlanalysis_xunit.Test_mlanalysis(varargin{:}); 
            import mlanalysis.*;
            this.director = PetAnalysisDirector.createFromSessionPath(this.sessionPath);
                
 		end% ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

