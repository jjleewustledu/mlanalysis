classdef Test_DsaGlmDirector < matlab.unittest.TestCase 
	%% TEST_DSAGLMDIRECTOR  

	%  Usage:  >> results = run(mlanalysis_unittest.Test_DsaGlmDirector)
 	%          >> result  = run(mlanalysis_unittest.Test_DsaGlmDirector, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 

	properties 
 		testObj 
        sessionPathLocal = '/Volumes/InnominateHD3/cvl/np797/mm01-000_p7395_2009mar12';
 	end 

	methods (Test) 
 		function test_CBF(this)
            mdl = this.testObj.createOnePredictorModel('CBF');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_CBV(this)
            mdl = this.testObj.createOnePredictorModel('CBV');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_MTT(this)
            mdl = this.testObj.createOnePredictorModel('MTT');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_t0(this)
            mdl = this.testObj.createOnePredictorModel('t0');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_alpha(this)
            mdl = this.testObj.createOnePredictorModel('alpha');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_beta(this)
            mdl = this.testObj.createOnePredictorModel('beta');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_gamma(this)
            mdl = this.testObj.createOnePredictorModel('gamma');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_adc(this)
            mdl = this.testObj.createOnePredictorModel('adc');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_dwi(this)
            mdl = this.testObj.createOnePredictorModel('dwi');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_oef(this)
            mdl = this.testObj.createOnePredictorModel('oef');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_ho(this)
            mdl = this.testObj.createOnePredictorModel('ho');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_oo(this)
            mdl = this.testObj.createOnePredictorModel('oo');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_oc(this)
            mdl = this.testObj.createOnePredictorModel('oc');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_tauHo(this)
            mdl = this.testObj.createOnePredictorModel('tauHo');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
        function test_tauOo(this)
            mdl = this.testObj.createOnePredictorModel('tauOo');
            this.assertNotEmpty(mdl);
            disp(mdl);
        end
 		function test_createModel(this) 
            mdl = this.testObj.createModel;
            this.assertNotEmpty(mdl);
            disp(mdl);
 		end  
 	end 

 	methods (TestClassSetup) 
 		function setupDsaGlmDirector(this) 
            pwd0 = pwd;
            cd(this.sessionPathLocal);
            fprintf('Working Session:  %s\n', this.sessionPathLocal);
            this.testObj = mlanalysis.DsaGlmDirector('SessionPath', this.sessionPathLocal);
            cd(pwd0);
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

