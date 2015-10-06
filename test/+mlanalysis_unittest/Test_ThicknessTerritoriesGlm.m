classdef Test_ThicknessTerritoriesGlm < matlab.unittest.TestCase 
	%% TEST_THICKNESSTERRITORIESGLM  

	%  Usage:  >> results = run(mlanalysis_unittest.Test_ThicknessTerritoriesGlm)
 	%          >> result  = run(mlanalysis_unittest.Test_ThicknessTerritoriesGlm, 'test_dt')
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
        studyPath = '/Volumes/PassportStudio2/cvl/np755'
        exclusions2 = [ ...
            0     0     0     0     0     0     0     0     0     1 ...
            0     0     0     0     0     0     0     0     0     0 ...
            1     0     0     1     1     0     1     0     1     0 ...
            0     0     0     0     0     0     0     0     1     0 ...
            0     0     0     0     0     0     1     0     0     0 ...
            0     0     0     0     0     0     0     0     0     0]'
 	end 

	methods (Test) 
 		function test_createStudyModel4(this) 
 			[mdl,ds,ttg] = mlanalysis.ThicknessTerritoriesGlm.createStudyModel4( ...
                'Exclusions', this.exclusions2, 'Territory', 'all_aca_mca', 'StudyPath', this.studyPath,'Statistic', 'mean');
            disp(mdl)
            disp(ds)
            disp(ttg)
 		end 
 	end 

 	methods (TestClassSetup) 
 		function setupThicknessTerritoriesGlm(this) 
            cd(this.studyPath);
 			%this.testObj = mlanalysis.ThicknessTerritoriesGlm( ...
            %    'Exclusions', this.exclusions2, 'Territory', 'all_aca_mca', 'StudyPath', this.studyPath,'Statistic', 'mean'); 
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

