classdef ThicknessTerritoriesGlm
	%% THICKNESSTERRITORIESGLM performs GLM to regress thicknesses, averaged over vascular territories, onto predictors
	 
	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 
	properties (Constant)
 		 SESSION_PATTERN    =   'mm0*'
         TERRITORY          =   'all_aca_mca'
         PREDICTORS         = { 'adc'  't0'   'alpha' 'beta' 'cbf'  'cbv'  'mtt'  'rawOef'  'oef'  'oefRatio' ...
                                'ho'   'oo'   'oc'    'sex'  'age'  'thicknessAbsolute' }
         PREDICTOR_SWITCHES = {  0 0 0 0 0 0 0 1 1 1 ...
                                 0 0 0 1 1 1 }
 	end 

    properties (Dependent)
        averaged_cereb_nqoef
        exclusions
        sessionsLength
        statistic
        studyPath
        territory
                
        session
        adc
        t0
        alpha
        beta
        cbf
        cbv
        mtt
        rawOef
        oef
        oefRatio
        ho
        oo
        oc
        sex
        age
        thicknessAbsolute
    end

    methods %% SET/GET
        function a  = get.averaged_cereb_nqoef(this)
            if (isempty(this.averaged_cereb_nqoef_))                
                load(fullfile(this.studyPath, 'ColinsAnalysis_2014feb17.mat'));
                this.averaged_cereb_nqoef_ = averaged_cereb_nqoef;
            end
            a = this.averaged_cereb_nqoef_;
        end
        function this = set.exclusions(this, exc)
            assert(islogical(exc) || isnumeric(exc));
            this.exclusions_ = exc;
        end
        function exc  = get.exclusions(this)
            if (isempty(this.exclusions_))
                this.exclusions_ = zeros(2*this.sessionsLength, 1);
            end
            assert(all([2*this.sessionsLength 1] == size(this.exclusions_)));
            exc = this.exclusions_;
        end
        function sl   = get.sessionsLength(this)
            assert(isnumeric(this.sessionsLength_));
            assert(this.sessionsLength_ > 0);
            sl = this.sessionsLength_;
        end
        function this = set.statistic(this, s)
            assert(lstrfind(s, mlanalysis.TerritoryGlmDirector.SUPPORTED_STATS));
            this.statistic_ = s;
        end
        function s    = get.statistic(this)
            s = this.statistic_;
        end
        function this = set.studyPath(this, pth)
            assert(lexist(pth, 'dir'));
            this.studyPath_ = pth;
            cd(this.studyPath_);
        end
        function pth  = get.studyPath(this)
            pth = this.studyPath_;
        end
        function this = set.territory(this, t)
            assert(ischar(t));
            assert(lstrfind(t, mlsurfer.Parcellations.TERRITORIES));
            this.territory_ = t;
        end
        function t    = get.territory(this)
            t = this.territory_;
        end        
        
        function s    = get.session(this)
            assert(2*this.sessionsLength == length(this.session_));
            s = this.session_;
        end
        function a    = get.adc(this)
            assert(2*this.sessionsLength == length(this.adc_));
            a = this.adc_;
        end
        function t    = get.t0(this)
            assert(2*this.sessionsLength == length(this.t0_));
            t = this.t0_;
        end
        function a    = get.alpha(this)
            assert(2*this.sessionsLength == length(this.alpha_));
            a = this.alpha_;
        end
        function b    = get.beta(this)
            assert(2*this.sessionsLength == length(this.beta_));
            b = this.beta_;
        end
        function c    = get.cbf(this)
            assert(2*this.sessionsLength == length(this.cbf_));
            c = this.cbf_;
        end
        function c    = get.cbv(this)
            assert(2*this.sessionsLength == length(this.cbv_));
            c = this.cbv_;
        end
        function m    = get.mtt(this)
            assert(2*this.sessionsLength == length(this.mtt_));
            m = this.mtt_;
        end
        function o    = get.rawOef(this)
            assert(2*this.sessionsLength == length(this.rawOef_));
            o = this.rawOef_;
        end
        function o    = get.oef(this)
            assert(2*this.sessionsLength == length(this.oef_));
            o = this.oef_;
        end
        function o    = get.oefRatio(this)
            assert(2*this.sessionsLength == length(this.oefRatio_));
            o = this.oefRatio_;
        end
        function h    = get.ho(this)
            assert(2*this.sessionsLength == length(this.ho_));
            h = this.ho_;
        end
        function o    = get.oo(this)
            assert(2*this.sessionsLength == length(this.oo_));
            o = this.oo_;
        end
        function o    = get.oc(this)
            assert(2*this.sessionsLength == length(this.oc_));
            o = this.oc_;
        end
        function s    = get.sex(this)
            if (isempty(this.sex_))                
                load(fullfile(this.studyPath, 'Sex.mat'));
                this.sex_ = Sex;
            end
            assert(2*this.sessionsLength == length(this.sex_));
            s = this.sex_;
        end
        function s    = get.age(this)
            if (isempty(this.age_))                
                load(fullfile(this.studyPath, 'Age_at_Presentation.mat'));
                this.age_ = Age_at_Presentation;
            end
            assert(2*this.sessionsLength == length(this.age_));
            s = this.age_;
        end
        function t    = get.thicknessAbsolute(this)
            assert(2*this.sessionsLength == length(this.thicknessAbsolute_));
            t = this.thicknessAbsolute_;
        end
    end
    
	methods (Static)
        function [mdl,ds,ttg] = createStudyModel2(varargin)
            
            import mlanalysis.*;
            ttg = ThicknessTerritoriesGlm(varargin{:});            
            ds  = ttg.theStudyDataset2;
            mdl = ThicknessTerritoriesGlm.createStudyModelFromDataset(ds);                
        end
        function [mdl,ds,ttg] = createStudyModel4(varargin)
            
            import mlanalysis.*;
            ttg = ThicknessTerritoriesGlm(varargin{:});            
            ds  = ttg.theStudyDataset4;
            mdl = ThicknessTerritoriesGlm.createStudyModelFromDataset(ds);                
        end
        function [mdl,ds,ttg] = createOnePredictorStudyModel(pred, varargin)
            
            import mlanalysis.*;            
            ttg = ThicknessTerritoriesGlm(varargin{:});            
            ds  = ttg.onePredictorStudyDataset(pred);
            mdl = ThicknessTerritoriesGlm.createStudyModelFromDataset(ds);  
        end 
        function  mdl         = createStudyModelFromDataset(ds)
            assert(isa(ds, 'dataset'));
            fprintf('ThicknessTerritoriesGlm.createModelFromDataset:  ensure that contents of the passed dataset are non-negative');
            mdl = GeneralizedLinearModel.fit(ds,            'linear', ...
                                            'Distribution', 'gamma', ...
                                            'link',         'reciprocal', ...
                                            'DispersionFlag', true);
        end         
    end
    
    methods        
        function this = ThicknessTerritoriesGlm(varargin)
            
            p = inputParser;
            addParameter(p, 'Exclusions', [],            @(x) isnumeric(x) || islogical(x));
            addParameter(p, 'StudyPath',  pwd,           @(x) lexist(x, 'dir'));
            addParameter(p, 'Territory', this.TERRITORY, @(x) lstrfind(mlsurfer.Parcellations.TERRITORIES, x));
            addParameter(p, 'Statistic', 'mean',         @(x) lstrfind(mlanalysis.TerritoryGlmDirector.SUPPORTED_STATS, x));
            parse(p, varargin{:});
            this.studyPath  = p.Results.StudyPath;
            this.territory  = p.Results.Territory;
            this.exclusions = p.Results.Exclusions;
            this.statistic  = p.Results.Statistic;
            
            import mlanalysis.*;
            dt = mlfourd.DirTools(this.SESSION_PATTERN);
            assert(dt.length > 0, 'Has the studyPath been set correctly?');
            this.sessionsLength_ = dt.length;
            this.session_ = {};
            this = this.setupDatasetSwitches;
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('ThicknessTerritoriesGlm.theStudyDataset is working in %s\n', ...
                            dt.fqdns{d});
                    
                    tgd  = TerritoryGlmDirector( ...
                          'Territory',   this.territory, ...
                          'SessionPath', dt.fqdns{d}, ...
                          'Statistic',   this.statistic);
                    this = this.accumulateDataset(tgd, 'adc'); 
                    this = this.accumulateDataset(tgd, 't0'); 
                    this = this.accumulateDataset(tgd, 'alpha'); 
                    this = this.accumulateDataset(tgd, 'beta'); 
                    this = this.accumulateDataset(tgd, 'cbf'); 
                    this = this.accumulateDataset(tgd, 'cbv'); 
                    this = this.accumulateDataset(tgd, 'mtt'); 
                    this = this.accumulateDataset(tgd, 'rawOef'); 
                    this = this.accumulateDataset(tgd, 'oef'); 
                    this = this.accumulateDataset(tgd, 'oefRatio'); 
                    this = this.accumulateDataset(tgd, 'ho'); 
                    this = this.accumulateDataset(tgd, 'oo'); 
                    this = this.accumulateDataset(tgd, 'oc'); 
                    this = this.accumulateDataset(tgd, 'thicknessAbsolute'); 
                    
                    this.session_ = [ this.session_; tgd.session; tgd.session ]; % left, right hemispheres
                catch ME
                    handexcept(ME);
                end
            end
            cd(this.studyPath);
            
            %% DO EXACTLY ONCE; KLUDGE
            %if (~isempty(this.oefRatio_))
            %    this.oefRatio_ = this.oefRatio_ ./ this.averaged_cereb_nqoef; end            
        end
        function this = accumulateDataset(this, glmDirector, datasetName)
            if (this.datasetSwitches(datasetName))
                try
                    this.([datasetName '_']) = [this.([datasetName '_']); ...
                                                glmDirector.(datasetName)];
                catch ME
                    fprintf('\nThicknessTerritoriesGlm.accumulateDataset.vname->%s\n\t%s\n', ...
                            datasetName, ME.getReport);
                    this.([datasetName '_']) = [this.([datasetName '_']); nan(2,1)];
                end
            end
        end  
        function tf   = datasetSwitches(this, ky)
            assert(~isempty( this.datasetSwitches_));
            tf = this.datasetSwitches_(ky);
        end
        function ds   = onePredictorStudyDataset(this, pred)
            assert(this.datasetSwitches(pred));
            assert(this.datasetSwitches('thicknessAbsolute'));
            
            cd(this.studyPath);           
            ds = dataset(            this.(pred)(~this.exclusions), this.thicknessAbsolute(~this.exclusions));
            ds.Properties.VarNames    = {  pred                         'thicknessAbsolute' };
            ds.Properties.Description =   '1/thickness <- Sum_j c_j predictors_j + eps';  
        end        
        function ds   = theStudyDataset2(this)
            assert(this.datasetSwitches('oefRatio'));
            assert(this.datasetSwitches('thicknessAbsolute'));
            
            cd(this.studyPath);           
            ds = dataset(             this.oefRatio(~this.exclusions), this.thicknessAbsolute(~this.exclusions));
            ds.Properties.VarNames    = { 'oefRatio'                       'thicknessAbsolute' };
            ds.Properties.Description =   '1/thickness <- Sum_j c_j predictors_j + eps';            
        end
        function ds   = theStudyDataset4(this)
            assert(this.datasetSwitches('sex'));
            assert(this.datasetSwitches('age'));
            assert(this.datasetSwitches('oefRatio'));
            assert(this.datasetSwitches('thicknessAbsolute'));
            
            cd(this.studyPath);           
            ds = dataset(             this.sex(~this.exclusions),      this.age(~this.exclusions), ... ...
                                      this.oefRatio(~this.exclusions), this.thicknessAbsolute(~this.exclusions));
            ds.Properties.VarNames    = { 'sex'                            'age' ...
                                          'oefRatio'                       'thicknessAbsolute' };
            ds.Properties.Description =   '1/thickness <- Sum_j c_j predictors_j + eps';            
        end
    end
    
    %% PRIVATE
    
    properties (Access = 'private')
        averaged_cereb_nqoef_
        datasetSwitches_
        exclusions_
        sessionsLength_
        statistic_
        studyPath_
        territory_ 
        
        session_
        adc_
        t0_
        alpha_
        beta_
        cbf_
        cbv_
        mtt_
        rawOef_
        oef_
        oefRatio_
        ho_
        oo_
        oc_
        sex_
        age_
        thicknessAbsolute_
    end

    methods (Access = 'private')        
        function this = setupDatasetSwitches(this)
            import mlanalysis.*;
            this.datasetSwitches_ = containers.Map( ...
                ThicknessTerritoriesGlm.PREDICTORS, ...
                this.values2logical(ThicknessTerritoriesGlm.PREDICTOR_SWITCHES));
        end
        function vals = values2logical(~, vals)
            assert(iscell(vals));
            for v = 1:length(vals)
                vals{v} = logical(vals{v});
            end
        end
    end
    
    %  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
end

