classdef ThicknessGlmDirector < mlanalysis.Np755GlmDirectorDecorator
    %% THICKNESSGLMDIRECTOR implements decorator design patterns for GLM analysis
    %  that regress cortical thickness onto predictor variables.
    %  Usage:   % from the session path:
    %           tgd = ThicknessGlmDirector
    %           tgd.createModel
    %           % from the study path:
    %           [glmModel, dataset] = ThicknessGlmDirector.createStudyModel

    %  $Revision$
    %  was created $Date$
    %  by $Author$,
    %  last modified $LastChangedDate$
    %  and checked into repository $URL$,
    %  developed on Matlab 8.1.0.604 (R2013a)
    %  $Id$
    
    properties 
        thicknessMetric
        thicknessLabel
    end
    
    methods %% SET/GET
        function m = get.thicknessMetric(this)
            m = this.thicknessAbsolute;
        end
        function l = get.thicknessLabel(this) %#ok<MANU>
            l = 'thicknessAbsolute';
        end
    end
    
    methods (Static)
        function tgd = factory(varargin)
            %% FACTORY returns a Np755GlmDirector decorated with ThicknessGlmDirector
            %  Usage:   tgd = ThicknessGlmDirector.factory([varargin for Np755GlmDirector])
            
            import mlanalysis.*;
            tgd = ThicknessGlmDirector( ...
                      Np755GlmDirector(varargin{:}));                  
        end
        
        function [mdls,dss] = createStudyModels(studyPth)
            if (~exist('studyPth', 'var')); studyPth = pwd; end
            cd(studyPth);
            dt = mlsystem.DirTools('mm0*');
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('ThicknessGlmDirector.createStudyModels is working in %s\n', dt.fqdns{d});
                    tgd     = mlanalysis.ThicknessGlmDirector.factory('SessionPath', dt.fqdns{d});
                    dss(d)  = struct('session', dt.dns{d}, 'dataset', tgd.theDataset); 
                    mdls(d) = struct('session', dt.dns{d}, 'model',   tgd.createModel); 
                catch ME
                    handwarning(ME);
                end
            end 
        end
        function [mdl,ds]   = createStudyModel(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            ds  = mlanalysis.ThicknessGlmDirector.theStudyDataset(studyPth);
            mdl = GeneralizedLinearModel.fit(ds,            'linear', ...
                                            'Distribution', 'normal', ...
                                            'link',         'identity', ...
                                            'DispersionFlag', true);
        end        
        function [mdls,dss] = createOnePredictorStudyModels(studyPth)
            if (~exist('studyPth', 'var')); studyPth = pwd; end
            cd(studyPth);
            dt = mlsystem.DirTools('mm0*');
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('ThicknessGlmDirector.createOnePredictorStudyModels is working in %s\n', dt.fqdns{d});
                    tgd     = mlanalysis.ThicknessGlmDirector.factory('SessionPath', dt.fqdns{d});
                    dss(d)  = struct('session', dt.dns{d}, 'dataset', tgd.theDatasetOnePredictor('oef')); 
                    mdls(d) = struct('session', dt.dns{d}, 'model',   tgd.createOnePredictorModel('oef')); 
                catch ME
                    handwarning(ME);
                end
            end 
        end
        function [mdl,ds]   = createOnePredictorStudyModel(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            ds  = mlanalysis.ThicknessGlmDirector.theOneParameterStudyDataset(studyPth, 'oef');
            mdl = GeneralizedLinearModel.fit(ds,            'linear', ...
                                            'Distribution', 'normal', ...
                                            'link',         'identity', ...
                                            'DispersionFlag', true);
        end
        
        function      dispStudyModels(mdls)
            for m = 1:length(mdls)
                fprintf('\n\n\n%s\n\n\n', mdls(m).session); disp(mdls(m).model); end
        end
        function ds = theStudyDataset(studyPth)
            cd(studyPth);
            dwi = [];
            t0 = [];
            alpha = [];
            beta = [];
            oef = [];
            ho = [];
            tauHo = [];
            oc = [];
            dsa = [];
            thicknessAbsolute = [];
            dt = mlsystem.DirTools('mm0*');
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('ThicknessGlmDirector.theStudyDataset is working in %s\n', dt.fqdns{d});
                    tgd  = mlanalysis.ThicknessGlmDirector.factory('SessionPath', dt.fqdns{d});
                    dwi = [ dwi; tgd.dwi ];
                    t0 = [ t0; tgd.t0 ];
                    alpha = [ alpha; tgd.alpha ];
                    beta = [ beta; tgd.beta ];
                    oef = [ oef; tgd.oef ];
                    ho = [ ho; tgd.ho ];
                    tauHo = [ tauHo; tgd.tauHo ];
                    oc = [ oc; tgd.oc ];
                    dsa = [ dsa; tgd.dsa ];
                    thicknessAbsolute = [ thicknessAbsolute; tgd.thicknessAbsolute ]; %#ok<*AGROW>
                catch ME
                    fprintf('%s\n', ME.message(1:160));
                end
            end 
            ds = dataset(dwi, ... 
                         t0, ...
                         alpha, ...
                         beta, ...
                         oef, ...
                         ho, ...
                         tauHo, ...
                         oc, ...
                         thicknessAbsolute);     
            ds.Properties.VarNames    = {'dwi' 't0' 'alpha' 'beta' 'oef' 'ho' 'tauHo' 'oc' 'thicknessAbsolute'};  
            ds.Properties.Description =  'logit(thickness) <- Sum_j c_j predictors_j + eps';
        end
        function ds = theOneParameterStudyDataset(studyPth, predictor)
            cd(studyPth);
            assert(ischar(predictor));
            pred = [];
            thicknessAbsolute = [];
            dt = mlsystem.DirTools('mm0*');
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('ThicknessGlmDirector.theStudyDataset is working in %s\n', dt.fqdns{d});
                    tgd  = mlanalysis.ThicknessGlmDirector.factory('SessionPath', dt.fqdns{d});
                    pred = [ pred; tgd.(predictor) ];
                    thicknessAbsolute = [ thicknessAbsolute; tgd.thicknessAbsolute ]; %#ok<*AGROW>
                catch ME
                    fprintf('%s\n', ME.message(1:160));
                end
            end 
            ds = dataset(pred, ...
                         thicknessAbsolute);     
            ds.Properties.VarNames    = {predictor 'thicknessAbsolute'};  
            ds.Properties.Description =  ['thickness <- ' predictor ' + eps'];
        end
    end
 	 	
    methods
        function mdl = createModel(this)
            mdl = GeneralizedLinearModel.fit( ...
                      this.theDataset, 'linear', ...
                                       'Distribution',  'normal', ...
                                       'link',          'identity', ...
                                       'DispersionFlag', true);
        end
        function mdl = createOnePredictorModel(this, pred)
            mdl = GeneralizedLinearModel.fit( ...
                      this.theDatasetOnePredictor(pred), 'linear', ...
                                                         'Distribution',  'normal', ...
                                                         'link',          'identity', ...
                                                         'DispersionFlag', true);
        end        
 		function ds  = theDataset(this)
            if (this.noThickness_)
                error('mlanalysis:missingData', ...
                      'ThicknessGlmDirector.theDataset:   no thickness data');
            end
            if (this.noDiffusion_)
                if (this.noPerfusion_)
                    if (this.noCarbonMonoxide_)
                        ds = this.theDatasetNoDiffNoPerfNoCO;
                        return
                    end
                    ds = this.theDatasetNoDiffNoPerf;
                    return
                end   
                ds = this.theDatasetNoDiff;
                return
            end            
            if (this.noPerfusion_)
                if (this.noCarbonMonoxide_)
                    ds = this.theDatasetNoPerfNoCO;
                    return
                end
                ds = this.theDatasetNoPerf;
                return
            end
            if (this.noCarbonMonoxide_)
                ds = this.theDatasetNoCO;
                return
            end
            
            ds = dataset(this.dwi, ... 
                         this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.thicknessMetric);     
            ds.Properties.VarNames    = { 'dwi' 't0' 'alpha' 'beta' 'oef' 'ho' 'tauHo' 'oc' this.thicknessLabel };  
            ds.Properties.Description = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
        end 
        function ds  = theDatasetOnePredictor(this, pred)
            if (this.noThickness_)
                error('mlanalysis:missingData', ...
                      'ThicknessGlmDirector.theDatasetOnePredictor:   no thickness data');
            end
            
            ds = dataset(this.(pred), ...
                         this.thicknessMetric);     
            ds.Properties.VarNames    = { pred this.thicknessLabel };  
            ds.Properties.Description = [ this.thicknessLabel ' <- eps + c_1 predictor' ];
        end

 		function this = ThicknessGlmDirector(varargin)
 			%% THICKNESSGLMDIRECTOR is a decorator for Np755GlmDirectorComponents
 			%  Usage:  this = ThicknessGlmDirector(a_Np755GlmDirectorComponent) 
            
            this = this@mlanalysis.Np755GlmDirectorDecorator(varargin{:});	 
 		end 
    end 
    
    %% PRIVATE 
    
    methods (Access = 'private')
        function ds  = theDatasetNoDiff(this)
            ds = dataset(this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.thicknessMetric);  
            ds.Properties.VarNames    = { 't0' 'alpha' 'beta' 'oef' 'ho' 'tauHo' 'oc' this.thicknessLabel };
            ds.Properties.Description = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
        end        
        function ds  = theDatasetNoDiffNoPerf(this)
            ds = dataset(this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.thicknessMetric);  
            ds.Properties.VarNames     = { 'oef' 'ho' 'tauHo' 'oc' this.thicknessLabel };
            ds.Properties.Description  = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
            return;
        end
        function ds  = theDatasetNoDiffNoPerfNoCO(this)
            ds = dataset(this.oef, ...
                         this.ho, ...
                         this.thicknessMetric);
            ds.Properties.VarNames    = { 'oef' 'ho' this.thicknessLabel };
            ds.Properties.Description = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
        end        
        function ds  = theDatasetNoDiffNoCO(this)
            ds = dataset(this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.thicknessMetric);  
            ds.Properties.VarNames    = { 't0' 'alpha' 'beta' 'oef' 'ho' this.thicknessLabel };
            ds.Properties.Description = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
        end                
        function ds  = theDatasetNoPerf(this)
            ds = dataset(this.dwi, ... 
                         this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.thicknessMetric);  
            ds.Properties.VarNames     = { 'dwi' 'oef' 'ho' 'tauHo' 'oc' this.thicknessLabel };
            ds.Properties.Description  = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
        end
        function ds  = theDatasetNoPerfNoCO(this)
            ds = dataset(this.dwi, ... 
                         this.oef, ...
                         this.ho, ...
                         this.thicknessMetric);  
            ds.Properties.VarNames     = { 'dwi' 'oef' 'ho' this.thicknessLabel };
            ds.Properties.Description  = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
        end        
        function ds  = theDatasetNoCO(this)
            ds = dataset(this.dwi, ... 
                         this.t0, ...                         
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.thicknessMetric);     
            ds.Properties.VarNames    = { 'dwi' 't0' 'alpha' 'beta' 'oef' 'ho' this.thicknessLabel };  
            ds.Properties.Description = [ this.thicknessLabel ' <- Sum_j c_j predictors_j + eps' ];
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

