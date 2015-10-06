classdef Test_TerritoryGlmDirector < matlab.unittest.TestCase 
	%% TEST_TERRITORYGLMDIRECTOR  

	%  Usage:  >> results = run(mlanalysis_unittest.Test_TerritoryGlmDirector)
 	%          >> result  = run(mlanalysis_unittest.Test_TerritoryGlmDirector, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 

	properties 
        sessionPathLocal = '/Volumes/InnominateHD3/cvl/np755/mm01-020_p7377_2009feb5';
 		testObj 
 	end 

	methods (Test) 
 		function test_createModel(this) 
            mdl = this.testObj.createModel;
            this.assertNotEmpty(mdl);
 			disp(mdl);
 		end 
 	end 

 	methods (TestClassSetup) 
 		function setupTerritoryGlmDirector(this) 
            import mlanalysis.*;
            pwd0 = pwd;
            cd(this.sessionPathLocal);
 			this.testObj = TerritoryGlmDirector( ...
                           ThicknessGlmDirector( ...
                               Np755GlmDirector('SessionPath', this.sessionPathLocal, 'Territory', 'mca'))); 
            cd(pwd0);
 		end 
 	end 

 	methods (TestClassTeardown) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

