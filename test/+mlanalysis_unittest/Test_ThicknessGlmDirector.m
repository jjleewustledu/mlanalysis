classdef Test_ThicknessGlmDirector < matlab.unittest.TestCase 
	%% TEST_THICKNESSGLMDIRECTOR  

	%  Usage:  >> results = run(mlanalysis_unittest.Test_ThicknessGlmDirector)
 	%          >> result  = run(mlanalysis_unittest.Test_ThicknessGlmDirector, 'test_dt')
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
        sessionPathLocal = '/Volumes/PassportStudio2/cvl/np755/mm01-020_p7377_2009feb5';
 	end 

	methods (Test) 
        function test_CBF(this)
            disp(this.testObj.createOnePredictorModel('CBF'))
        end
        function test_CBV(this)
            disp(this.testObj.createOnePredictorModel('CBV'))
        end
        function test_MTT(this)
            disp(this.testObj.createOnePredictorModel('MTT'))
        end
        function test_t0(this)
            disp(this.testObj.createOnePredictorModel('t0'))
        end
        function test_alpha(this)
            disp(this.testObj.createOnePredictorModel('alpha'))
        end
        function test_beta(this)
            disp(this.testObj.createOnePredictorModel('beta'))
        end
        function test_gamma(this)
            disp(this.testObj.createOnePredictorModel('gamma'))
        end
        function test_adc(this)
            disp(this.testObj.createOnePredictorModel('adc'))
        end
        function test_dwi(this)
            disp(this.testObj.createOnePredictorModel('dwi'))
        end
        function test_oef(this)
            disp(this.testObj.createOnePredictorModel('oef'))
        end
        function test_ho(this)
            disp(this.testObj.createOnePredictorModel('ho'))
        end
        function test_oo(this)
            disp(this.testObj.createOnePredictorModel('oo'))
        end
        function test_oc(this)
            disp(this.testObj.createOnePredictorModel('oc'))
        end
        function test_tauHo(this)
            disp(this.testObj.createOnePredictorModel('tauHo'))
        end
        function test_tauOo(this)
            disp(this.testObj.createOnePredictorModel('tauOo'))
        end
 		function test_createModel(this)
            mdl = this.testObj.createModel;
            this.assertNotEmpty(mdl);
 			disp(mdl);
        end 
 	end 

 	methods (TestClassSetup) 
 		function setupThicknessGlmDirector(this) 
            pwd0 = pwd;
            cd(this.sessionPathLocal);
            this.testObj = mlanalysis.ThicknessGlmDirector.factory('SessionPath', this.sessionPathLocal);
            cd(pwd0);
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

