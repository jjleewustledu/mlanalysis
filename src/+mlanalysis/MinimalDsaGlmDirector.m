classdef MinimalDsaGlmDirector < mlanalysis.Np755GlmDirector
	%% MINIMALDSAGLMDIRECTOR   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 
    
    methods (Static)
        function [mdl,ds]  = createStudyModel(studyPth)         
            if (~exist('studyPth', 'var'))
                studyPth = pwd; end
            ds  = mlanalysis.DsaGlmDirector.theStudyDataset(studyPth);
            mdl = GeneralizedLinearModel.fit(ds,            'linear', ...
                                            'Distribution', 'binomial', ...
                                            'link',         'logit', ...
                                            'DispersionFlag', true);
        end
        function ds = theStudyDataset(studyPth)   
            cd(studyPth);
            thicknessCOV = [];
            t0 = [];
            alpha = [];
            beta = [];
            oef = [];
            ho = [];
            oo = [];
            dsa = [];
            dt = mlfourd.DirTools('mm0*');
            for d = 1:length(dt.fqdns)
                try
                    cd(dt.fqdns{d});
                    fprintf('DsaGlmDirector.theStudyDataset is working in %s\n', dt.fqdns{d});
                    dgd  = mlanalysis.DsaGlmDirector('SessionPath', dt.fqdns{d});
                    thicknessCOV = [ thicknessCOV; dgd.thicknessCOV ]; %#ok<*AGROW>
                    t0 = [ t0; dgd.t0 ];
                    alpha = [ alpha; dgd.alpha ];
                    beta = [ beta; dgd.beta ];
                    oef = [ oef; dgd.oef ];
                    ho = [ ho; dgd.ho ];
                    oo = [ oo; dgd.tauHo ];
                    dsa = [ dsa; dgd.dsa ];
                catch ME
                    fprintf('%s\n', ME.message(1:160));
                end
            end 
            ds = dataset(thicknessCOV, ...
                         t0, ...
                         alpha, ...
                         beta, ...
                         oef, ...
                         ho, ...
                         oo, ...
                         dsa);     
            ds.Properties.VarNames    = {'thicknessCOV' 't0' 'alpha' 'beta' 'oef' 'ho' 'oo' 'dsa'};  
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end
    end
    
    methods
        function mdl  = createModel(this)
            mdl = GeneralizedLinearModel.fit( ...
                      this.theDataset, 'linear', ...
                                       'Distribution', 'binomial', ...
                                       'link',         'logit', ...
                                       'DispersionFlag', true);
        end
        function mdl  = createOnePredictorModel(this, predictor)
            mdl = GeneralizedLinearModel.fit( ...
                      this.theDatasetOnePredictor(predictor), 'linear', ...
                                       'Distribution', 'binomial', ...
                                       'link',         'logit');
        end
        function ds = theDatasetOnePredictor(this, pr)
            ds = dataset(this.(pr), ...
                         this.dsa);     
            ds.Properties.VarNames    = {pr 'dsa'};  
            ds.Properties.Description =  'logit(dsa) <- eps + c_1 predictor';
        end
        
 		function ds = theDataset(this) 
            if (this.noThickness_)
                error('mlanalysis:missingData', 'DsaGlmDirector.get.theDataset:   no thickness data');
            end        
            if (this.noPerfusion_)
                error('mlanalysis:missingData', 'DsaGlmDirector.get.theDataset:   no thickness data');
            end  
            ds = dataset(this.thicknessCOV, ...
                         this.t0, ...
                         this.alpha, ...
                         this.beta, ...
                         this.oef, ...
                         this.ho, ...
                         this.oo, ...
                         this.dsa);     
            ds.Properties.VarNames    = {'thicknessCOV' 't0' 'alpha' 'beta' 'oef' 'ho' 'oo' 'dsa'};  
            ds.Properties.Description =  'logit(dsa) <- Sum_j c_j predictors_j';
        end 
        
 		function this = MinimalDsaGlmDirector(varargin) 
 			%% DSAGLMDIRECTOR 
 			%  Usage:  this = DsaGlmDirector()	
            
            this = this@mlanalysis.Np755GlmDirector(varargin{:});
 		end 
    end 
    


	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

