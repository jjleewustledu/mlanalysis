classdef Test_DsaGlmDirector < MyTestCase 
	%% TEST_DSAGLMDIRECTOR  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlanalysis.Test_DsaGlmDirector % in . or the matlab path 
	%          >> runtests mlanalysis.Test_DsaGlmDirector:test_nameoffunc 
	%          >> runtests(mlanalysis.Test_DsaGlmDirector, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 	
	properties 
 		 sessionPathLocal = '/Volumes/PassportStudio/cvl/np755/wu029_p7395_2009mar12';
         dgd
 	end 

	methods 
        function test_CBF(this)
            mdl = this.dgd.createOnePredictorModel('CBF')
        end
        function test_CBV(this)
            mdl = this.dgd.createOnePredictorModel('CBV')
        end
        function test_MTT(this)
            mdl = this.dgd.createOnePredictorModel('MTT')
        end
        function test_t0(this)
            mdl = this.dgd.createOnePredictorModel('t0')
        end
        function test_alpha(this)
            mdl = this.dgd.createOnePredictorModel('alpha')
        end
        function test_beta(this)
            mdl = this.dgd.createOnePredictorModel('beta')
        end
        function test_gamma(this)
            mdl = this.dgd.createOnePredictorModel('gamma')
        end
        function test_adc(this)
            mdl = this.dgd.createOnePredictorModel('adc')
        end
        function test_dwi(this)
            mdl = this.dgd.createOnePredictorModel('dwi')
        end
        function test_oef(this)
            mdl = this.dgd.createOnePredictorModel('oef')
        end
        function test_ho(this)
            mdl = this.dgd.createOnePredictorModel('ho')
        end
        function test_oo(this)
            mdl = this.dgd.createOnePredictorModel('oo')
        end
        function test_oc(this)
            mdl = this.dgd.createOnePredictorModel('oc')
        end
        function test_tauHo(this)
            mdl = this.dgd.createOnePredictorModel('tauHo')
        end
        function test_tauOo(this)
            mdl = this.dgd.createOnePredictorModel('tauOo')
        end
 		function test_createModel(this) 
            mdl = this.dgd.createModel
 		end 
 		function this = Test_DsaGlmDirector(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            cd(this.sessionPathLocal);
            fprintf('Working Session:  %s\n', this.sessionPathLocal);
            this.dgd = mlanalysis.DsaGlmDirector('SessionPath', this.sessionPathLocal);
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

