classdef Test_ControlData < matlab.unittest.TestCase
	%% TEST_CONTROLDATA 

	%  Usage:  >> results = run(mlanalysis_unittest.Test_ControlData)
 	%          >> result  = run(mlanalysis_unittest.Test_ControlData, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 05-Nov-2017 18:12:13 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlanalysis/test/+mlanalysis_unittest.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties
        pwd0
 		testObj 
        subjectsDir = '/Volumes/SeagateBP4/cvl/controls/pet'
        workingPath = '/Volumes/SeagateBP4/cvl/controls/pet/p5165' % mm01-028_p7542_2009dec17 %mm01-020_p7377_2009feb5
        territory = 'mca_max'
        hemi = 'rh'
 	end

	methods (Test)
		function test_afun(this)
 			import mlanalysis.*;
 			this.assumeEqual(1,1);
 			this.verifyEqual(1,1);
 			this.assertEqual(1,1);
 		end
        function test_histOefIndex(this)
            this.testObj.histOefIndex;
        end        
	end

 	methods (TestClassSetup)
		function setupControlData(this)
 			import mlanalysis.*;
            setenv('SUBJECTS_DIR', this.subjectsDir);
            this.pwd0 = pushd(this.subjectsDir);
            this.testObj_ = ControlData( ...
                'subjectsDir', this.subjectsDir, ...
                'Parameter', 'oefnq_default_101010fwhh_on_MNI152_T1_1mm_brain', ...
                'Territory', this.territory);
            this.addTeardown(@this.popd);
 		end
	end

 	methods (TestMethodSetup)
		function setupControlDataTest(this)
 			this.testObj = this.testObj_;
 			this.addTeardown(@this.cleanFiles);
 		end
	end
    
    methods
        function popd(this)
            popd(this.pwd0);
        end
    end
    
    %% PRIVATE

	properties (Access = private)
 		testObj_
 	end

	methods (Access = private)
		function cleanFiles(this)
 		end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

