classdef ControlData < mlsurfer.SurferData
	%% CONTROLDATA  
    %  See also:  usage examples in mlanalysis.MoyamoyaPaper

	%  $Revision$
 	%  was created 05-Nov-2017 18:12:13 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/Local/src/mlcvl/mlanalysis/src/+mlanalysis.
 	%% It was developed on Matlab 9.3.0.713579 (R2017b) for MACI64.  Copyright 2017 John Joowon Lee.
 	
	properties (Constant)
        cvsInMNIPath = fullfile(getenv('FREESURFER_HOME'), 'subjects', 'cvs_avg35_inMNI152', '')
    end
    
    properties
        aparcAsegIC
        
        hemis = {'lh' 'rh'};
        ids   = {11101:11175 12101:12175}; % constrained by this.territory
    end
    
    properties (Dependent)
        oefAltMat
        sessions % N = 15
    end

    methods % GET
        function g = get.oefAltMat(this)
            g = sprintf('ControlData_histOefIndex_101010fwhh_oefVec_%s.mat', this.territory);
        end
        function g = get.sessions(this)
            g = this.sessions_;
        end
    end
    
    methods 
        function aver = cerebellarOef(this, sessionPth)
            pwd0 = pushd(sessionPth);
            
            import mlfourd.*;
            aparc = this.aparcAsegIC.niftid; 
            aparc.img = double(aparc.img == 7 | aparc.img == 8 | aparc.img == 46 | aparc.img == 47);
            oefnq = NIfTId.load(fullfile(sessionPth, 'fsl', 'oefnq_default_101010fwhh_on_MNI152_T1_1mm_brain.nii.gz'));
            maskoef = oefnq.clone;
            maskoef.img = double(maskoef.img > 0 & maskoef.img < 1);
            maskoef.img = double(maskoef.img) .* double(aparc.img);
            %maskoef.view(fullfile(this.subjectsDir, 'MNI152_T1_1mm_brain.nii.gz'));
            
            aver = mean(oefnq.img(maskoef.img == 1));
            
            popd(pwd0);
        end	  
        function [oefVec,oefStr,h1] = histOefIndex(this, varargin)
            % oefVec has sessions with hemispheres within
            
            pwd0 = pushd(this.subjectsDir);
            oefVec = [];
            for s = 1:length(this.sessions)
                
                oefStr(s) = this.oefIndex(fullfile(this.subjectsDir, this.sessions{s}, ''), varargin{:});  %#ok<AGROW>
                
                for h = 1:2
                    if (true)
                        ids_ = oefStr(s).ids{h};
                        parcVec = [];
                        for iparc = 1:length(ids_)
                            if (oefStr(s).map.isKey(ids_(iparc)))
                                parcVec = [parcVec oefStr(s).map(ids_(iparc))]; %#ok<AGROW>
                            end
                        end
                        oefVec = [oefVec parcVec]; %#ok<AGROW>
                    end
                    stats{s,h} = struct('mean', mean(parcVec), 'std', std(parcVec));
                    this.statsPrintf(stats{s,h}, s, h);
                end
            end
            save(this.oefAltMat, '*');
            popd(pwd0);
            
            h1 = histogram(oefVec);             
            h1.Normalization = 'probability';
            h1.BinWidth = 0.01;
            
            mu = mean(oefVec);
            sigma = std(oefVec);
            fprintf('ControlData.histOefIndex:  mu->%g, sigma->%g, median->%g, max(oefVec)->%g\n', ...
                mu, sigma, median(oefVec), max(oefVec));
            
%             y = min(oefVec):(max(oefVec) - min(oefVec))/100:max(oefVec);
%             f = 130*exp(-(y-mu).^2./(2*sigma^2));
%             hold on
%             plot(y, f, 'LineWidth', 1.5);
%             hold off

%             run(mlanalysis_unittest.Test_ControlData, 'test_histOefIndex')
%             Running mlanalysis_unittest.Test_ControlData
% m = mean(oefVec)
%    0.994670199222035
% s = std(oefVec)
%    0.109412178248884
% ci = [m - 2*s, m + 2*s]
%    0.775845842724268   1.213494555719802
        end
        function statsPrintf(this, stats, s, h)
            fprintf('%s:  stats(%s, %s):  mean  %4.2f  std  %4.2f\n', ...
                this.territory, this.sessions{s}, this.hemis{h}, stats.mean, stats.std);
        end
        function oi = oefIndex(this, varargin)
            % OEFINDEX calls ParcellationSegments.asMaps to find valid keys for parcs/segs.
            % @param file oefnq_default_101010fwhh_on_MNI152_T1_1mm_brain.nii.gz with listing of valid parcs/segs.
            % @return oi.imagingContext:  for oefIndex mapped to this.aparcAsegIC
            %         oi.map:  keys -> session string
            %         oi.mapsHemis:  {session session}
            %         oi.ids:  {region_ids region_ids}
            
            ip = inputParser;
            addRequired(ip, 'sessionPath', @isdir);
            addOptional(ip, 'paramOefnq', 'oefnq_default_101010fwhh_on_MNI152_T1_1mm_brain', @ischar);
            parse(ip, varargin{:})
            
            import mlsurfer.*;
            aparcAsegNN  = this.aparcAsegIC.numericalNiftid;
            aparcZerosNN = aparcAsegNN.zeros;
            oefCereb = this.cerebellarOef(ip.Results.sessionPath);
            oefMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
            oefMapsHemis = {[] []};
            for h = 1:2
                % containers.Map
                oefMap = ParcellationSegments.asMap( ...
                    ip.Results.paramOefnq, this.hemis{h}, ...
                    'Territory',   this.territory, ...
                    'SessionPath', ip.Results.sessionPath);        
                for ii = 1:length(this.ids{h})                    
                    if (oefMap.isKey(this.ids{h}(ii)))
                        ratio = oefMap(this.ids{h}(ii)) / oefCereb;
                        oefMap(this.ids{h}(ii)) = ratio;
                        oefMapsHemis{h} = [oefMapsHemis{h} ratio];
                        if (~isempty(ratio) && ~isnan(ratio))
                            aparcZerosNN.img(aparcAsegNN.img == this.ids{h}(ii)) = ratio;                        
                        end
                    end
                end
                oefMapsHemis{h} = mean(oefMapsHemis{h});
            end
            aparcZerosNN.fqfileprefix = fullfile(ip.Results.sessionPath, 'fsl', 'oefnq_default_101010fwhh_on_MNI152_T1_1mm_brain_ControlData');
            oi.imagingContext = mlfourd.ImagingContext(aparcZerosNN);
            oi.map = oefMap;
            oi.mapsHemis = oefMapsHemis;
            oi.ids = this.ids;
        end
        
 		function this = ControlData(varargin)
 			%% CONTROLDATA
 			%  Usage:  this = ControlData()

 			this = this@mlsurfer.SurferData(varargin{:});
            
            this.subjectsDir = '/Volumes/SeagateBP4/cvl/controls/pet';
            dt = mlsystem.DirTool(fullfile(this.subjectsDir, 'p*'));
            this.sessions_ = dt.dns; 
            %copyfile(fullfile(this.cvsInMNIPath, 'mri', 'aparc.a2009s+aseg.mgz'), this.subjectsDir);
            this.aparcAsegIC = mlfourd.ImagingContext( ...
                fullfile(this.subjectsDir, 'aparcAseg_on_MNI152_T1_1mm.nii.gz'));
            inst = mlsurfer.SurferRegistry.instance;
            inst.statsSuffix = '_on_fsanatomical.stats';
 		end
    end 
    
    %% PRIVATE
    
    properties (Access = private)
        sessions_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

