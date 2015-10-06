classdef Test_ControlsThicknessTerritoriesGlm < matlab.unittest.TestCase 
	%% TEST_CONTROLSTHICKNESSTERRITORIESGLM  

	%  Usage:  >> results = run(mlanalysis_unittest.Test_ControlsThicknessTerritoriesGlm)
 	%          >> result  = run(mlanalysis_unittest.Test_ControlsThicknessTerritoriesGlm, 'test_dt')
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
        studyPath = '/Volumes/InnominateHD3/cvl/controls/pet'
 	end 

	methods (Test) 
 		function test_createStudyModel2(this) 
 			import mlanalysis.*; 
 			[mdl,ds,ttg] = ControlsThicknessTerritoriesGlm.createStudyModel2( ...
                           'StudyPath', this.studyPath);
            disp(mdl);
            disp(ds);
            disp(ttg);
        end 
        function test_ctor(this)
            this.assertNotEmpty(this.testObj);
        end
 	end 

 	methods (TestClassSetup) 
 		function setupControlsThicknessTerritoriesGlm(this) 
 			this.testObj = mlanalysis.ControlsThicknessTerritoriesGlm('StudyPath', this.studyPath); 
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

