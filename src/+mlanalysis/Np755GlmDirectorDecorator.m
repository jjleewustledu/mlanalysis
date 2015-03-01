classdef Np755GlmDirectorDecorator < mlanalysis.Np755GlmDirectorComponent 
	%% NP755GLMDIRECTORDECORATOR maintains a reference to a component object,
    %  forwarding requests to the component object.   
    %  Maintains an interface consistent with the component's interface.
    %  Subclasses may optionally perform additional operations before/after forwarding requests.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 
    
    properties
 		 dsa
         thicknessAbsolute
         thicknessCOV
         thicknessDelta
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
         ho
         invHo
         oo
         oef
         segIds
         tauHo
         tauOo
         oc
    end 
    
    methods %% GET
        function g = get.dsa(this)
            g = this.component_.dsa;
        end
        function g = get.thicknessAbsolute(this)
            g = this.component_.thicknessAbsolute;
        end
        function g = get.thicknessCOV(this)
            g = this.component_.thicknessCOV;
        end
        function g = get.thicknessDelta(this)
            g = this.component_.thicknessDelta;
        end
        function g = get.adc(this)
            g = this.component_.adc;
        end
        function g = get.dwi(this)
            g = this.component_.dwi;
        end
        function g = get.CBF(this)
            g = this.component_.CBF;
        end
        function g = get.CBV(this)
            g = this.component_.CBV;
        end
        function g = get.MTT(this)
            g = this.component_.MTT;
        end
        function g = get.t0(this)
            g = this.component_.t0;
        end
        function g = get.alpha(this)
            g = this.component_.alpha;
        end
        function g = get.invAlpha(this)
            g = this.component_.invAlpha;
        end
        function g = get.beta(this)
            g = this.component_.beta;
        end
        function g = get.invBeta(this)
            g = this.component_.invBeta;
        end
        function g = get.gamma(this)
            g = this.component_.gamma;
        end
        function g = get.ho(this)
            g = this.component_.ho;
        end
        function g = get.invHo(this)
            g = this.component_.invHo;
        end
        function g = get.oo(this)
            g = this.component_.oo;
        end
        function g = get.oef(this)
            g = this.component_.oef;
        end
        function g = get.segIds(this)
            g = this.component_.segIds;
        end
        function g = get.tauHo(this)
            g = this.component_.tauHo;
        end
        function g = get.tauOo(this)
            g = this.component_.tauOo;
        end
        function g = get.oc(this)
            g = this.component_.oc;
        end
    end
    
	methods  		 
        function ds  = theDatasetOnePredictor(this)
            ds = this.component_.theDatasetOnePredictor;
        end
        function ds  = theDataset(this)
            ds = this.component_.theDataset;
        end
        function mdl = createOnePredictorModel(this, predictor)
            mdl = this.component_.createOnePredictorModel(predictor);
        end
        function mdl = createModel(this)
            mdl = this.component_.createModel;
        end
        
 		function this = Np755GlmDirectorDecorator(varargin) 
 			%% GLMDIRECTORDECORATOR 
            %  Usage:  obj = GlmDirectorDecorator([aGlmDirector])
            %                                      ^ default is a GlmDirector
            
            p = inputParser;
            addOptional(p, 'cmp', mlanalysis.Np755GlmDirector, @(x) isa(x, 'mlanalysis.Np755GlmDirectorComponent'));
            parse(p, varargin{:});
            
            this.component_ = p.Results.cmp;
 		end 
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        component_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

