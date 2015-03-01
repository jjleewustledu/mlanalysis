classdef ParcellationsGlmDirector 
	%% PARCELLATIONSGLMDIRECTOR   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$  	 
 
    properties
        territory = 'all';
    end
        
	properties (Dependent)
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
        function v  = get.dsa(this)
            if (isempty(this.dsa_))
                lh = mlsurfer.ParcellationSegments.asDouble('dsa', 'lh', 'Territory', this.territory);
                rh = mlsurfer.ParcellationSegments.asDouble('dsa', 'rh', 'Territory', this.territory);
                this.dsa_ = [lh; rh];
            end
            v = this.dsa_;
        end
        function v  = get.thicknessAbsolute(this)
            v = this.map2vec(this.thicknessMap_);
        end
        function v  = get.thicknessDelta(this)
            v = (this.map2vec(this.thicknessMap_) - this.map2vec(this.cvsMap_)); 
            v = this.z(v);
        end
        function v  = get.thicknessCOV(this)
            v = (this.map2vec(this.thicknessMap_) - this.map2vec(this.cvsMap_)) ./ ...
                 this.map2vec(this.thicknessStdMap_);
            v = this.z(v);
        end
        function v  = get.adc(this)
            if (this.noDiffusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.adcMap_);
            v = this.z(v);
        end
        function v  = get.dwi(this)
            if (this.noDiffusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.dwiMap_) ./ this.map2mean(this.dwiPca_);
            v = this.z(v);
        end
        function v  = get.CBF(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.CBFMap_) ./ this.map2mean(this.CBFPca_);
            v = this.z(v);
        end
        function v  = get.CBV(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.CBVMap_);
            v = this.z(v);
        end
        function v  = get.MTT(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.MTTMap_);
            v = this.z(v);
        end
        function v  = get.t0(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.t0Map_) ./ this.map2mean(this.t0Pca_);
            v = this.z(v);
        end
        function v  = get.alpha(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.alphaMap_);
            v = this.z(v);
        end
        function v  = get.invAlpha(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = 1 ./ this.alpha;
            v = this.z(v);
        end
        function v  = get.beta(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.betaMap_);
            v = this.z(v);
        end
        function v  = get.invBeta(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = 1 ./ this.beta;
            v = this.z(v);
        end
        function v  = get.gamma(this)
            if (this.noPerfusion_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.gammaMap_);
            v = this.z(v);
        end
        function v  = get.ho(this)
            if (this.noPET_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.hoMap_) ./ this.map2mean(this.hoPca_);
            v = this.z(v);
        end
        function v  = get.invHo(this)
            if (this.noPET_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2mean(this.hoPca_) ./ this.map2vec(this.hoMap_);
            v = this.z(v);
        end
        function v  = get.oo(this)
            if (this.noPET_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.ooMap_) ./ this.map2mean(this.ooPca_);
            v = this.z(v);
        end
        function v  = get.oef(this)  
            if (this.noPET_)
                v = nan(length(this.segIds), 1);
                return
            end          
            v = this.map2vec(this.oohoMap_) ./ this.map2mean(this.oohoPca_);
            % v = this.z(v);
        end
        function v  = get.segIds(this)
            v = cell2mat(this.dsaMap_.keys)';
        end
        function v  = get.tauHo(this)
            if (this.noPET_ || this.noCarbonMonoxide_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.oc ./ this.ho;
            v = this.z(v);
        end
        function v  = get.tauOo(this)
            if (this.noPET_ || this.noCarbonMonoxide_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.oc ./ this.oo;
            v = this.z(v);
        end
        function v  = get.oc(this)
            if (this.noPET_ || this.noCarbonMonoxide_)
                v = nan(length(this.segIds), 1);
                return
            end
            v = this.map2vec(this.ocMap_) ./ this.map2mean(this.ocPca_);
            v = this.z(v);
        end
    end
   
	methods 
 		function this = ParcellationsGlmDirector(varargin) 
 			%% PARCELLATIONSGLMDIRECTOR 
 			%  Usage:  this = ParcellationsGlmDirector() 

 		end 
    end 
    
    %% PRIVATE
    
    properties
        dsa_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

