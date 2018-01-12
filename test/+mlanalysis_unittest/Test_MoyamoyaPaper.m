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
        pwd0
 		testObj 
        subjectsDir = '/Volumes/SeagateBP4/cvl/np755'
        workingPath = '/Volumes/SeagateBP4/cvl/np755/mm01-006_p7260_2008jun9'
        % demonstrate exclusions:  
        % mm01-028_p7542_2009dec17 mm01-006_p7260_2008jun9
        % demonstrate inclusions by rand selection:
        % mm01-006_p7260_2008jun9 mm01-034_p7630_2010may5 mm02-001_p7146_2008jan4 mm03-001_p7229_2008apr28
        territory = 'mca_max' % 'all' 'all_aca_mca' 'mca_max' 'aca' 'pca'
        statistic = 'mean'
        exclusionLabel = 'Colin'
        modelLabel = 'oefsubj' % 'fixed' '1subj' 'oefsubj'
        hemi = 'lh'
 	end 

	methods (Test) 
        function test_ttest2(this)
            C = load('/Volumes/SeagateBP4/cvl/controls/pet/ControlData_histOefIndex_101010fwhh_oefVec_mca_max.mat');            
            M = load('/Volumes/SeagateBP4/cvl/np755/MoyamoyaPaper_histOefIndex_737363fwhh_oefVec_Colin_mca_max_mean.mat');
            [h,p,ci,stats] = ttest2(M.oefVec, C.oefVec, 'Vartype', 'unequal', 'Tail', 'both')
        end
        function test_visitIdSegstats(this)
            for s = 1:length(this.testObj.sessions)
                this.testObj.visitIdSegstats( ...
                    fullfile(this.subjectsDir, this.testObj.sessions{s}));
            end
        end
        function test_checkAlignments(this)
            sesss = this.testObj.sessions;
            for s = 1:length(sesss)
                pushd(fullfile(this.subjectsDir, sesss{s}, 'fsl', ''));
                fprintf('test_checkAlignments is checking %s\n', pwd);
                mlbash('freeview all_737353fwhh_on_T1.nii.gz ../mri/T1.mgz');
                popd(this.pwd0);
            end
        end
        function test_diaryStats(this)
            terrs = {'mca_max'}; % 'aca_max' 'pca_max' 'aca_min' 'mca_min' 'pca_min'
            for t = 1:length(terrs)
                this.testObj.territory = terrs{t};
                this.testObj.diaryStats = ['diary_' terrs{t}];
                this.testObj.histOefIndex;
                this.testObj.histThickness;
            end
        end
        function test_prepareDataOnFilesystem(this)
            terrs = {'mca_max'}; % 'all' 'mca_max' 'all_aca_mca' 'aca_max' 'pca_max' 'aca_min' 'mca_min' 'pca_min'
            for t = 1:length(terrs)
                this.testObj.territory = terrs{t};
                this.testObj.categories;
                this.testObj.histOefIndex;
                this.testObj.histThickness;
            end
        end
        function test_categories(this)
            this.testObj.categories;
        end
        function test_peakOefIndex(this)
            this.testObj.peakOefIndex;
        end
        function test_histOefIndex(this)
            this.testObj.histOefIndex; %('oo', 'ho', 'ICFileprefix', 'oefIndex_737353fwhh_on_T1');
        end
        function test_histOefIndexAndControls(this)
            run(mlanalysis_unittest.Test_ControlData, 'test_histOefIndex'); 
            % mca_max:  ControlData.histOefIndex:  mu->0.99467, sigma->0.109412, median->0.979237, max(oefVec)->1.60595
            hold on
            this.testObj.histOefIndex; %('oo', 'ho', 'ICFileprefix', 'oefIndex_737353fwhh_on_T1');
            hold off
        end
        function test_histThickness(this)
            this.testObj.histThickness;
        end
        function test_histThicknessDiff(this)
            this.testObj.histThicknessDiff;
        end
        function test_fitglmeOefIndex2Thickness(this)
            this.testObj.fitglmeOefIndex2Thickness;
        end
        function test_fitglmeOefIndex2Thickness2(this)
 			this.testObj = mlanalysis.MoyamoyaPaper( ...
                'subjectsDir', this.subjectsDir, ...
                'Territory', this.territory, ...
                'statistic', this.statistic, ...
                'exclusionLabel', this.exclusionLabel, ...
                'modelLabel', '1subj');
            this.testObj.fitglmeOefIndex2Thickness2;
        end
        function test_fitglmeOefIndex2Thickness3(this)
 			this.testObj = mlanalysis.MoyamoyaPaper( ...
                'subjectsDir', this.subjectsDir, ...
                'Territory', this.territory, ...
                'statistic', this.statistic, ...
                'exclusionLabel', this.exclusionLabel, ...
                'modelLabel', '1subj');
            this.testObj.fitglmeOefIndex2Thickness3;
        end
        function test_fitglmOefIndex2Thickness2(this)
 			this.testObj = mlanalysis.MoyamoyaPaper( ...
                'subjectsDir', this.subjectsDir, ...
                'Territory', 'mca_max', ...
                'statistic', this.statistic, ...
                'exclusionLabel', this.exclusionLabel, ...
                'modelLabel', 'oefage');
            this.testObj.fitglmOefIndex2Thickness2;
        end
        function test_fitglmeOefIndex2ThicknessDiff(this)
            this.testObj.fitglmeOefIndex2ThicknessDiff;
        end
        function test_fitglmeOefIndex2ThicknessDiff2(this)
            this.testObj.fitglmeOefIndex2ThicknessDiff2;
        end
        function test_scatterHemis(this)
        end
        function test_scatterBrains(this)
        end
        function test_thicknessIndexViz(this)
        end
        function test_oefIndexViz(this)
            this.testObj.oefIndexViz('sessionPath', this.workingPath);
        end
        function test_inflatedViewThickness(this)            
            this.testObj.inflatedViewThickness('sessionPath', this.workingPath, 'hemis', this.hemi);
        end
        % See also:  mlsurfer_unittest.Test_Stats2ImagingContext.test_oefRatioImagingContext
 		function test_visualizeOefnq(this) 
            pwd1 = pushd(this.subjectsDir);
            this.testObj.visualizeOefnq;
            popd(pwd1);
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
            setenv('SUBJECTS_DIR', this.subjectsDir);
            setenv('VERBOSITY', '0');
            this.pwd0 = pushd(this.subjectsDir);
 			this.testObj = mlanalysis.MoyamoyaPaper( ...
                'subjectsDir', this.subjectsDir, ...
                'Territory', this.territory, ...
                'statistic', this.statistic, ...
                'exclusionLabel', this.exclusionLabel, ...
                'modelLabel', this.modelLabel);
            this.addTeardown(@this.popd);
 		end 
 	end 

 	methods (TestClassTeardown) 
    end 
    
    methods
        function popd(this)
            popd(this.pwd0);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
 end 

