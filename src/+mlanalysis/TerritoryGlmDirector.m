classdef TerritoryGlmDirector 
	%% TERRITORYGLMDIRECTOR averages freesurfer ROIs into territories for use with GLM director classes

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
    
    properties (Constant)
        SUPPORTED_STATS       = { 'mean' 'median' 'std' }
    end

	properties (Dependent)
        session
        dsa
        thicknessAbsolute
        thicknessAbsoluteCvs
        thicknessDelta
        thicknessCOV
        adc
        dwi
        CBF
        CBV
        MTT
        t0
        alpha
        invAlpha
        beta
        invBeta
        gamma
        rawHo
        ho
        invHo
        rawOo
        oo
        rawOef
        oef
        oefRatio
        segIds
        tauHo
        tauOo
        oc     
        
        hoMeanvolFileprefix
        ooMeanvolFileprefix
        ocFileprefix
        oefnqFileprefix
              
        noDiffusion
        noBolusTracking
        noPET
        noCarbonMonoxide
        
        sessionPath
        studyPath
        territory
        statistic
 	end 

	methods %% GET
        function s  = get.session(this)
            [~,s] = fileparts(this.sessionPath);
        end
        function v  = get.dsa(this)
            if (isempty(this.dsa_))
                this.dsa_ = this.parameterMeans('dsa');
            end
            v = this.dsa_;
        end
        function v  = get.thicknessAbsolute(this)
            if (isempty(this.thicknessAbsolute_))
                this.thicknessAbsolute_ = this.directedParamStat('thickness');
            end
            v = this.thicknessAbsolute_;
        end
        function v  = get.thicknessAbsoluteCvs(this)
            if (isempty(this.thicknessAbsoluteCvs_))
                this.thicknessAbsoluteCvs_ = this.directedParamStat('cvs');
            end
            v = this.thicknessAbsoluteCvs_;
        end
        function v  = get.thicknessDelta(this)
            v = this.thicknessAbsolute - this.thicknessAbsoluteCvs;
        end
        function v  = get.adc(this)
            if (this.noDiffusion)
                v = nan(2, 1);
                return
            end
            if (isempty(this.adc_))
                this.adc_ = this.directedParamStat('adc_default');
            end
            v = this.adc_;
        end
        function v  = get.dwi(this)
            if (this.noDiffusion)
                v = nan(2, 1);
                return
            end
            if (isempty(this.dwi_))
                this.dwi_ = this.directedParamStat('dwi_default_meanvol');
            end
            v = this.dwi_;
        end
        function v  = get.CBF(this)
            if (this.noBolusTracking)                
                v = nan(2, 1);
                return
            end            
            if (isempty(this.CBF_))
                this.CBF_ = this.directedParamStat('CBF');
            end
            v = this.CBF_;
        end
        function v  = get.CBV(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end
            if (isempty(this.CBV_))
                this.CBV_ = this.directedParamStat('CBV');
            end
            v = this.CBV_;
        end
        function v  = get.MTT(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end
            if (isempty(this.MTT_))
                this.MTT_ = this.directedParamStat('MTT');
            end
            v = this.MTT_;
        end
        function v  = get.t0(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end            
            if (isempty(this.t0_))
                this.t0_ = this.directedParamStat('t0');
            end
            v = this.t0_;
        end
        function v  = get.alpha(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end
            if (isempty(this.alpha_))
                this.alpha_ = this.directedParamStat('alpha');
            end
            v = this.alpha_;
        end
        function v  = get.invAlpha(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end
            v = 1 ./ this.alpha;
        end
        function v  = get.beta(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end
            if (isempty(this.beta_))
                this.beta_ = this.directedParamStat('beta');
            end
            v = this.beta_;
        end
        function v  = get.invBeta(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end
            v = 1 ./ this.beta;
        end
        function v  = get.gamma(this)
            if (this.noBolusTracking)
                v = nan(2, 1);
                return
            end
            if (isempty(this.gamma_))
                this.gamma_ = this.directedParamStat('gamma');
            end
            v = this.gamma_;
        end
        function v  = get.rawHo(this)
            if (this.noPET)
                v = nan(2, 1);
                return
            end
            if (isempty(this.ho_))
                this.ho_ = this.directedParamStat(this.hoMeanvolFileprefix);
            end
            v = this.ho_;
        end
        function v  = get.ho(this)
            if (this.noPET)
                v = nan(2, 1);
                return
            end
            if (isempty(this.ho_))
                import mlsurfer.*;
                this.ho_ = this.directedParamStat(              this.hoMeanvolFileprefix);                
                this.ho_ = this.normalizeSamplingHigh(this.ho_, this.hoMeanvolFileprefix, 'pca_min');
            end
            v = this.ho_;
        end
        function v  = get.invHo(this)
            if (this.noPET)
                v = nan(2, 1);
                return
            end
            v = 1 ./ this.ho;
        end
        function v  = get.rawOo(this)
            if (this.noPET)
                v = nan(2, 1);
                return
            end
            if (isempty(this.oo_))
                this.oo_ = this.directedParamStat(this.ooMeanvolFileprefix);
            end
            v = this.oo_;
        end
        function v  = get.oo(this)
            if (this.noPET)
                v = nan(2, 1);
                return
            end
            if (isempty(this.oo_))
                import mlsurfer.*;
                this.oo_ = this.directedParamStat(              this.ooMeanvolFileprefix);
                this.oo_ = this.normalizeSamplingHigh(this.oo_, this.ooMeanvolFileprefix, 'pca_min');
            end
            v = this.oo_;
        end
        function v  = get.rawOef(this)  
            if (this.noPET)
                v = nan(2, 1);
                return
            end          
            if (isempty(this.oef_))
                this.oef_ = this.directedParamStat(this.oefnqFileprefix);
            end
            v = this.oef_;
        end
        function v  = get.oef(this)  
            v = this.rawOef;
        end
        function v  = get.oefRatio(this)  
            v = this.rawOef;
        end
        function v  = get.tauHo(this)
            if (this.noPET || this.noCarbonMonoxide)
                v = nan(2, 1);
                return
            end
            v = this.oc ./ this.ho;
        end
        function v  = get.tauOo(this)
            if (this.noPET || this.noCarbonMonoxide)
                v = nan(2, 1);
                return
            end
            v = this.oc ./ this.oo;
        end
        function v  = get.oc(this)
            if (this.noPET || this.noCarbonMonoxide)
                v = nan(2, 1);
                return
            end
            if (isempty(this.oc_))
                import mlsurfer.*;
                this.oc_ = this.directedParamStat(              this.ocFileprefix);                
                this.oc_ = this.normalizeSamplingHigh(this.oc_, this.ocFileprefix, 'pca_min');
            end
            v = this.oc_;
        end
        function tf = get.noDiffusion(this)
            tf = ~lexist(fullfile(this.sessionPath, 'fsl/dwi_default.nii.gz'), 'file');
        end
        function tf = get.noBolusTracking(this)
            tf = ~lexist(fullfile(this.sessionPath, 'fsl/ep2d_default.nii.gz'), 'file');
        end
        function tf = get.noPET(this)
            tf = ~lexist(fullfile(this.sessionPath, 'fsl', [this.oefnqFileprefix '.nii.gz']), 'file');
        end
        function tf = get.noCarbonMonoxide(this)
            tf = ~lexist(fullfile(this.sessionPath, 'fsl', [this.ocFileprefix '.nii.gz']), 'file');
        end          
        
        function sp = get.studyPath(this)
            sp = fileparts(this.sessionPath);
        end
    end
    
    methods %% SET/GET
        function this = set.hoMeanvolFileprefix(this, fp)
            assert(ischar(fp));
            this.hoMeanvolFileprefix_ = fp;
        end
        function fp   = get.hoMeanvolFileprefix(this)
            assert(~isempty(this.hoMeanvolFileprefix_), 'hoMeanvolFileprefix referenced but not assigned');
            fp = this.hoMeanvolFileprefix_;
        end
        function this = set.ooMeanvolFileprefix(this, fp)
            assert(ischar(fp));
            this.ooMeanvolFileprefix_ = fp;
        end
        function fp   = get.ooMeanvolFileprefix(this)
            assert(~isempty(this.ooMeanvolFileprefix_), 'ooMeanvolFileprefix referenced but not assigned');
            fp = this.ooMeanvolFileprefix_;
        end
        function this = set.ocFileprefix(this, fp)
            this.ocFileprefix_ = fp;
            assert(ischar(fp));
        end
        function fp   = get.ocFileprefix(this)
            assert(~isempty(this.ocFileprefix_), 'ocFileprefix referenced but not assigned');
            fp = this.ocFileprefix_;
        end
        function this = set.oefnqFileprefix(this, fp)
            assert(ischar(fp));
            this.oefnqFileprefix_ = fp;
        end
        function fp   = get.oefnqFileprefix(this)
            assert(~isempty(this.oefnqFileprefix_), 'oefnqFileprefix referenced but not assigned');
            fp = this.oefnqFileprefix_;
        end
        
        function this = set.statistic(this, s)
            assert(lstrfind(s, this.SUPPORTED_STATS));
            this.statistic_ = s;
        end
        function s    = get.statistic(this)
            s = this.statistic_;
        end
        function t    = get.territory(this)
            assert(~isempty(this.territory_));
            t = this.territory_;
        end
        function this = set.territory(this, t)
            assert(lstrfind(mlsurfer.Parcellations.TERRITORIES, t));
            this.territory_ = t;
        end
        function sp   = get.sessionPath(this)
            assert(~isempty(this.sessionPath_));
            sp = this.sessionPath_;
        end
        function this = set.sessionPath(this, sp)
            assert(lexist(sp, 'dir') && ~lstrfind(this.sessionPath_, {'fsl' 'mri' 'surf' 'perfusion_4dfp'}));
            this.sessionPath_ = sp;
        end
    end
    
	methods 
        function s    = directedParamStat(this, p)
            switch (this.statistic)
                case 'mean'
                    s = this.parameterMeans(p);
                case 'median'
                    s = this.parameterMedians(p);
                case 'std'
                    s = this.parameterStds(p);
                otherwise
                    error('mlanalysis:unsupportedParamValue', ...
                         'TerritoryGlmDirector does not support statistic %s', this.statistic);
            end
        end
 		function this = TerritoryGlmDirector(varargin) 
 			%% TERRITORYGLMDIRECTOR specifies the territory over which to average freesurfer ROIs; default is "mca" 
            
            p = inputParser;
            addParamValue(p, 'Territory',  'all',  @(x) lstrfind(x, mlsurfer.Parcellations.TERRITORIES));
            addParamValue(p, 'SessionPath', pwd,   @(x) lexist(x, 'dir'));
            addParamValue(p, 'Statistic',  'mean', @(x) lstrfind(x, mlanalysis.TerritoryGlmDirector.SUPPORTED_STATS));
            parse(p, varargin{:});
            this.territory   = p.Results.Territory;
            this.sessionPath = p.Results.SessionPath;
            this.statistic   = p.Results.Statistic;
 		end 
 	end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        dsa_
        thicknessAbsolute_
        thicknessAbsoluteCvs_
        adc_
        dwi_
        CBF_
        CBV_
        MTT_
        t0_
        alpha_
        invAlpha_
        beta_
        invBeta_
        gamma_
        ho_
        oo_
        oef_
        tauHo_
        tauOo_
        oc_        
        
        hoMeanvolFileprefix_
        ooMeanvolFileprefix_
        ocFileprefix_
        oefnqFileprefix_
        
        sessionPath_
        territory_
        statistic_ = 'mean';
    end
    
    methods (Access = 'private')
        function m = parameterMeans(this, p)   
            import mlsurfer.*;
            lh = ParcellationSegments.asMean(p, 'lh', 'Territory', this.territory, 'SessionPath', this.sessionPath);
            rh = ParcellationSegments.asMean(p, 'rh', 'Territory', this.territory, 'SessionPath', this.sessionPath);
            m  = [lh; rh];
        end
        function m = parameterMedians(this, p)   
            import mlsurfer.*;
            lh = ParcellationSegments.asMedian(p, 'lh', 'Territory', this.territory, 'SessionPath', this.sessionPath);
            rh = ParcellationSegments.asMedian(p, 'rh', 'Territory', this.territory, 'SessionPath', this.sessionPath);
            m  = [lh; rh];
        end
        function s = parameterStds(this, p)
            import mlsurfer.*;
            lh = ParcellationSegments.asStd(p, 'lh', 'Territory', this.territory, 'SessionPath', this.sessionPath);
            rh = ParcellationSegments.asStd(p, 'rh', 'Territory', this.territory, 'SessionPath', this.sessionPath);
            s  = [lh; rh];
        end
        function m = parameterCerebNormMeans(this, p)
            m  = this.parameterMeans(p);              
            m  = this.normalizeSamplingLow(m, p, 'cereb');
        end
        function m = parameterPcaNormMeans(this, p)   
            import mlsurfer.*;            
            m  = this.parameterMeans(p);              
            m  = this.normalizeSamplingLow(m, p, 'pca_min');
        end
        function v = normalizeIpsi(this, v, p, samplingTerr)
            import mlsurfer.*;
            v(1) = v(1) / ...
                   ParcellationSegments.asMean(p, 'lh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
            v(2) = v(2) / ...
                   ParcellationSegments.asMean(p, 'rh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
        end
        function v = normalizeContra(this, v, p, samplingTerr)
            import mlsurfer.*;
            v(1) = v(1) / ...
                   ParcellationSegments.asMean(p, 'rh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
            v(2) = v(2) / ...
                   ParcellationSegments.asMean(p, 'lh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
        end
        function v = normalizeMean(this, v, p, samplingTerr)
            import mlsurfer.*;
            sampling = ...
                (ParcellationSegments.asMean(p, 'lh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath) + ...
                 ParcellationSegments.asMean(p, 'rh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath))/2;
             v = v / sampling;
        end
        function v = normalizeSamplingLow(this, v, p, samplingTerr)
            import mlsurfer.*;
            lhSampl = ParcellationSegments.asMean(p, 'lh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
            rhSampl = ParcellationSegments.asMean(p, 'rh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
            if (lhSampl < rhSampl)
                v = v / lhSampl;                
            else
                v = v / rhSampl;
            end
        end
        function v = normalizeSamplingHigh(this, v, p, samplingTerr)
            import mlsurfer.*;
            lhSampl = ParcellationSegments.asMean(p, 'lh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
            rhSampl = ParcellationSegments.asMean(p, 'rh', 'Territory', samplingTerr, 'SessionPath', this.sessionPath);
            if (lhSampl > rhSampl)
                v = v / lhSampl;                
            else
                v = v / rhSampl;
            end
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

