classdef Test_TerritoryGlmDirector < MyTestCase
	%% TEST_TERRITORYGLMDIRECTOR  

	%  Usage:  >> runtests tests_dir  
	%          >> runtests mlanalysis.Test_TerritoryGlmDirector % in . or the matlab path 
	%          >> runtests mlanalysis.Test_TerritoryGlmDirector:test_nameoffunc 
	%          >> runtests(mlanalysis.Test_TerritoryGlmDirector, Test_Class2, Test_Class3, ...) 
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
 		function test_createModel(this) 
 			disp(this.tgd.createModel);
 		end 
 		function this = Test_TerritoryGlmDirector(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            import mlanalysis.*;
            this.tgd = TerritoryGlmDirector( ...
                           ThicknessGlmDirector( ...
                               Np755GlmDirector('SessionPath', this.sessionPathLocal, 'Territory', 'mca')));                
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

