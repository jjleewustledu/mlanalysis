classdef Test_ThicknessGlmDirector < MyTestCase 
	%% TEST_THICKNESSGLMDIRECTOR  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlanalysis.Test_ThicknessGlmDirector % in . or the matlab path 
	%          >> runtests mlanalysis.Test_ThicknessGlmDirector:test_nameoffunc 
	%          >> runtests(mlanalysis.Test_ThicknessGlmDirector, Test_Class2, Test_Class3, ...) 
	%  See also:  package xunit 

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 

	properties 
 		 sessionPathLocal = '/Volumes/PassportStudio/cvl/np755/mm01-020_p7377_2009feb5';
         tgd
 	end 

	methods 
        function test_CBF(this)
            disp(this.tgd.createOnePredictorModel('CBF'))
        end
        function test_CBV(this)
            disp(this.tgd.createOnePredictorModel('CBV'))
        end
        function test_MTT(this)
            disp(this.tgd.createOnePredictorModel('MTT'))
        end
        function test_t0(this)
            disp(this.tgd.createOnePredictorModel('t0'))
        end
        function test_alpha(this)
            disp(this.tgd.createOnePredictorModel('alpha'))
        end
        function test_beta(this)
            disp(this.tgd.createOnePredictorModel('beta'))
        end
        function test_gamma(this)
            disp(this.tgd.createOnePredictorModel('gamma'))
        end
        function test_adc(this)
            disp(this.tgd.createOnePredictorModel('adc'))
        end
        function test_dwi(this)
            disp(this.tgd.createOnePredictorModel('dwi'))
        end
        function test_oef(this)
            disp(this.tgd.createOnePredictorModel('oef'))
        end
        function test_ho(this)
            disp(this.tgd.createOnePredictorModel('ho'))
        end
        function test_oo(this)
            disp(this.tgd.createOnePredictorModel('oo'))
        end
        function test_oc(this)
            disp(this.tgd.createOnePredictorModel('oc'))
        end
        function test_tauHo(this)
            disp(this.tgd.createOnePredictorModel('tauHo'))
        end
        function test_tauOo(this)
            disp(this.tgd.createOnePredictorModel('tauOo'))
        end
 		function test_createModel(this) 
            disp(this.tgd.createModel)
 		end 
 		function this = Test_ThicknessGlmDirector(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            cd(this.sessionPathLocal);
            fprintf('Working Session:  %s\n', this.sessionPathLocal);
            this.tgd = mlanalysis.ThicknessGlmDirector.factory('SessionPath', this.sessionPathLocal);
            assertPropertiesNotEmpty(this.tgd);
 		end 
    end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

