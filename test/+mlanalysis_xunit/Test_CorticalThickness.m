classdef Test_CorticalThickness < TestCase 
	%% TEST_CORTICALTHICKNESS 
	%  Usage:  >> runtests tests_dir  
 	%          >> runtests mlpipelineTest_corticalThickness % in . or the matlab path 
 	%          >> runtests mlpipelineTest_corticalThickness:test_nameoffunc 
 	%          >> runtests(mlpipelineTest_corticalThickness, Test_Class2, Test_Class3, ...) 
 	%  See also:  package xunit	%  Version $Revision$ was created $Date$ by $Author$,  
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$ 
 	%  Developed on Matlab 7.14.0.739 (R2012a) 
 	%  $Id$ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
        testPatient
        expectedSummaryTable
        expectedSummaryTableFilename = '';
 	end 

	methods 
        
        function test_createThicknessTable_multiPatient(this)
        end
        function test_createThicknessTable_onePatientLongitudinal(this)
        end
 		function test_createThicknessTable_oneSession(this) 
 			import mlpipeline.*; 
            this.testPatient.buildCorticalThicknesses;
            assertTrue(this.expectedSummaryTable == this.testPatient.corticalThicknesses.summaryTable);
 		end % test_createThicknessTable_oneSession
        
 		function this = Test_CorticalThickness(varargin) 
            import mlpipeline.*;
 			this = this@TestCase(varargin{:}); 
            this.testPatient          = Patient;
            this.expectedSummaryTable = SummaryTable.loadst(this.expectedSummaryTableFilename);
 		end % Test_corticalThickness (ctor) 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

