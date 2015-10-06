classdef Test_MoyamoyaPaper < matlab.unittest.TestCase 
	%% TEST_MOYAMOYAPAPER  

	%  Usage:  >> results = run(mlanalysis_unittest.Test_MoyamoyaPaper)
 	%          >> result  = run(mlanalysis_unittest.Test_MoyamoyaPaper, 'test_dt')
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
        workingPath = '/Volumes/InnominateHD3/cvl/np755/mm01-020_p7377_2009feb5'
 	end 

	methods (Test) 
        function test_CBV(this)
            disp(this.testObj.createOnePredictorModel('CBV'))
        end
 		function test_createModel(this) 
            disp(this.testObj.createModel)
        end 
 		function test_objProperties(this) 
            assertPropertiesNotEmpty(this.testObj);
        end 
        function test_ctor(this)
            disp(this.testObj)
        end
 	end 

 	methods (TestClassSetup) 
 		function setupMoyamoyaPaper(this) 
 			this.testObj = mlanalysis.MoyamoyaPaper; 
            cd(this.workingPath);
            this.testObj = mlanalysis.ThicknessGlmDirector.factory('SessionPath', this.workingPath);
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

