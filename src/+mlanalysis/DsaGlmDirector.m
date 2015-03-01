classdef DsaGlmDirector < mlanalysis.Np755GlmDirector
	%% DSAGLMDIRECTOR implements builder/director design patterns to do GLM analysis
    %  that regress DSA onto predictor variables.
    %  Usage:   from the session path:
    %           dgd = DsaGlmDirector
    %           dgd.createModel
    %           from the study path:
    %           [glmModel, dataset] = DsaGlmDirector.createStudyModel

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 
    
    methods (Static)
        function [mdls,dss] = createStudyModels(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            cd(studyPth);
            dt   = mlfourd.DirTools('mm0*');
            mdls = struct([]); 
            dss  = struct([]);
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('DsaGlmDirector.createStudyModels is working in %s\n', dt.fqdns{d});
                    dgd     = mlanalysis.DsaGlmDirector('SessionPath', dt.fqdns{d});
                    mdls(d) = struct('session', dt.dns{d}, 'model',   dgd.createModel); 
                    dss(d)  = struct('session', dt.dns{d}, 'dataset', dgd.theDataset); 
                catch ME
                    handwarning(ME);
                end
            end 
        end
        function [mdl,ds]   = createStudyModel(studyPth)
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            ds  = mlanalysis.DsaGlmDirector.theStudyDataset(studyPth);
            mdl = GeneralizedLinearModel.fit(ds,            'linear', ...
                                            'Distribution', 'binomial', ...
                                            'link',         'logit', ...
                                            'DispersionFlag', true);
        end
        function ds         = theStudyDataset(studyPth)
            cd(studyPth);
            thicknessCOV = [];
            dwi = [];
            t0 = [];
            alpha = [];
            beta = [];
            oef = [];
            ho = [];
            tauHo = [];
            oc = [];
            dsa = [];
            dt = mlfourd.DirTools('mm0*');
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('DsaGlmDirector.theStudyDataset is working in %s\n', dt.fqdns{d});
                    dgd  = mlanalysis.DsaGlmDirector('SessionPath', dt.fqdns{d});
                    thicknessCOV = [ thicknessCOV; dgd.thicknessCOV ]; %#ok<*AGROW>
                    dwi = [ dwi; dgd.dwi ];
                    t0 = [ t0; dgd.t0 ];
                    alpha = [ alpha; dgd.alpha ];
                    beta = [ beta; dgd.beta ];
                    oef = [ oef; dgd.oef ];
                    ho = [ ho; dgd.ho ];
                    tauHo = [ tauHo; dgd.tauHo ];
                    oc = [ oc; dgd.oc ];
                    dsa = [ dsa; dgd.dsa ];
                catch ME
                    fprintf('%s\n', ME.message(1:160));
                end
            end 
            ds = dataset(thicknessCOV, ...
                         dwi, ... 
                         t0, ...
                         alpha, ...
                         beta, ...
                         oef, ...
                         ho, ...
                         tauHo, ...
                         oc, ...
                         dsa);     
            ds.Properties.VarNames    = {'thicknessCOV' 'dwi' 't0' 'alpha' 'beta' 'oef' 'ho' 'tauHo' 'oc' 'dsa'};  
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end
    end
    
    methods
        function mdl = createModel(this)
            mdl = GeneralizedLinearModel.fit( ...
                      this.theDataset, 'linear', ...
                                       'Distribution', 'binomial', ...
                                       'link',         'logit', ...
                                       'DispersionFlag', true);
        end
        function mdl = createOnePredictorModel(this, predictor)
            mdl = GeneralizedLinearModel.fit( ...
                      this.theDatasetOnePredictor(predictor), 'linear', ...
                                       'Distribution', 'binomial', ...
                                       'link',         'logit');
        end
        function ds  = theDatasetOnePredictor(this, pr)
            ds = dataset(this.(pr), ...
                         this.dsa);     
            ds.Properties.VarNames    = {pr 'dsa'};  
            ds.Properties.Description =  'logit(dsa) <- eps + c_1 predictor';
        end
        
 		function ds = theDataset(this) 
            if (this.noThickness_)
                error('mlanalysis:missingData', 'DsaGlmDirector.get.theDataset:   no thickness data');
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
            
            ds = dataset(this.thicknessCOV, ...
                         this.dwi, ... 
                         this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.dsa);     
            ds.Properties.VarNames    = {'thicknessCOV' 'dwi' 't0' 'alpha' 'beta' 'oef' 'ho' 'tauHo' 'oc' 'dsa'};  
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end 
        function ds = theDatasetNoDiff(this)
            ds = dataset(this.thicknessCOV, ...
                         this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.dsa);  
            ds.Properties.VarNames    = {'thicknessCOV' 't0' 'alpha' 'beta' 'oef' 'ho' 'tauHo' 'oc' 'dsa'};
            ds.Properties.Description = 'logit(dsa) <- Sum_j c_j predictors_j';
        end        
        function ds = theDatasetNoDiffNoPerf(this)
            ds = dataset(this.thicknessCOV, ...
                         this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.dsa);  
            ds.Properties.VarNames     = {'thicknessCOV' 'oef' 'ho' 'tauHo' 'oc' 'dsa'};
            ds.Properties.Description  =  'logit(dsa) <- Sum_j c_j predictors_j';
            return;
        end
        function ds = theDatasetNoDiffNoPerfNoCO(this)
            ds = dataset(this.thicknessCOV, ...
                         this.oef, ...
                         this.ho, ...
                         this.dsa);
            ds.Properties.VarNames    = {'thicknessCOV'  'oef' 'ho' 'dsa'};
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end        
        function ds = dataSetNoDiffNoCO(this)
            ds = dataset(this.thicknessCOV, ...
                         this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.dsa);  
            ds.Properties.VarNames    = {'thicknessCOV' 't0' 'alpha' 'beta' 'oef' 'ho' 'dsa'};
            ds.Properties.Description = 'logit(dsa) <- Sum_j c_j predictors_j';
        end                
        function ds = theDatasetNoPerf(this)
            ds = dataset(this.thicknessCOV, ...
                         this.dwi, ... 
                         this.oef, ...
                         this.ho, ...
                         this.tauHo, ...
                         this.oc, ...
                         this.dsa);  
            ds.Properties.VarNames    = {'thicknessCOV' 'dwi' 'oef' 'ho' 'tauHo' 'oc' 'dsa'};
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end
        function ds = theDatasetNoPerfNoCO(this)
            ds = dataset(this.thicknessCOV, ...
                         this.dwi, ... 
                         this.oef, ...
                         this.ho, ...
                         this.dsa);  
            ds.Properties.VarNames    = {'thicknessCOV' 'dwi' 'oef' 'ho' 'dsa'};
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end        
        function ds = theDatasetNoCO(this)
            ds = dataset(this.thicknessCOV, ...
                         this.dwi, ... 
                         this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.dsa);     
            ds.Properties.VarNames    = {'thicknessCOV' 'dwi' 't0' 'alpha' 'beta' 'oef' 'ho' 'dsa'};  
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end
 		function this = DsaGlmDirector(varargin) 
 			%% DSAGLMDIRECTOR 
 			%  Usage:  this = DsaGlmDirector('SessionPath', aSessionPath) 
            
            this = this@mlanalysis.Np755GlmDirector(varargin{:});
 		end 
    end 
    

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

