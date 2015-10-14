classdef Np755GlmDirector < mlanalysis.Np755GlmDirectorComponent
	%% NP755GLMDIRECTOR aggregates imaging data from study np755 for GLM:  dsa, thickness, diffusion, bolus-tracking, O15-PET.
    %  Data arrays are generated from containers.Map returned by mlsurfer.DatasetMap.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 
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

	methods %% GET/SET
        function v  = get.dsa(this)
            v = this.map2vec(this.dsaMap_);
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
    
    methods (Static)
        function       freeviewFsanatomical
            error('mlanalysis:notImplemented', 'GlmDirector.freeviewFsanatomical');
        end
        function       slicesdir
            import mlanalysis.* mlsurfer.*;
            fprintf('GlmDirector.slicesdir:  working in filesystem location %s\n', pwd);
            try
                [~,~] = mlfsl.FslVisitor.slicesdir( ...
                        ['*_on_' SurferFilesystem.T1_FILEPREFIX '*.nii.gz'], ...
                        struct('p', [SurferFilesystem.T1_FILEPREFIX '.nii.gz'])); 
            catch ME
                handexcept(ME, sprintf('GlmDirector.slicesdir:\n%s%s\n', 'mlfsl.FslVisitor.slicesdir:\n', r)); 
            end
            dt = mlsystem.DirTools(['*' SurferFilesystem.T1_FILEPREFIX '*.nii.gz']);
            assert(dt.length > 0, 'GlmDirector.slicesdir:  found no NIfTI files\n');
        end
        function val = z(val)
            val1 =  val(~isnan(val));
            val  = (val - mean(val1))/std(val1);
        end
    end
    
	methods        
        function ds  = theDataset(this) %#ok<MANU>
            ds = dataset([]);
            error('mlanalysis:missingRequiredOverride', 'Np755GlmDirector.theDataset');
        end
        function ds  = theDatasetOnePredictor(~, pred)
            ds = dataset([]);            
            error('mlanalysis:missingRequiredOverride', 'Np755GlmDirector.theDatasetOnePredictor pred->%s', pred);
        end
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
        
 		function this = Np755GlmDirector(varargin) 
 			%% NP755GLMDIRECTOR 
 			%  Usage:  this = Np755GlmDirector('SessionPath', aSessionPath, 'Territory', aTerritory) 
 			
            p = inputParser;
            addParameter(p, 'SessionPath', pwd, ...
                              @(x) lexist(x, 'dir') && ~lstrfind(x, {'fsl' 'mri' 'surf' 'perfusion_4dfp'}));
            addParameter(p, 'Territory', 'all', ...
                              @(x) lstrfind(x, mlsurfer.Parcellations.TERRITORIES));
            parse(p, varargin{:});            
            
            this = this.mapDsa(p);
            this = this.mapThickness(p);
            this = this.mapDiffusion(p);
            this = this.mapBolusTracking(p);
            this = this.mapO15(p);
            this = this.matchAllKeys;
        end 
    end
    
    %% PROTECTED
    
    properties (Access = 'protected')
        dsaMap_
        thicknessMap_
        thicknessStdMap_
        cvsMap_
        adcMap_
        dwiMap_
        CBFMap_
        CBVMap_
        MTTMap_
        t0Map_
        alphaMap_
        betaMap_
        gammaMap_
        hoMap_
        ooMap_
        oohoMap_
        ocMap_
        hoPcaMap_
        ooPcaMap_
        oohoPcaMap_
        
        dsaPca_
        thicknessPca_
        thicknessStdPca_
        cvsPca_
        adcPca_
        dwiPca_
        CBFPca_
        CBVPca_
        MTTPca_
        t0Pca_
        alphaPca_
        betaPca_
        gammaPca_
        hoPca_
        ooPca_
        oohoPca_
        ocPca_
        hoPcaPca_
        ooPcaPca_
        oohoPcaPca_
        
    end
    
    methods (Access = 'protected')
        function        checkIdenticalKeys(~, m, m2)
            assert(length(m) == length(m2));
            kys = m.keys; kys2 = m2.keys;
            for k = 1:length(m)
                assert(kys{k} == kys2{k});
            end
        end
        function m    = matchKeys(~, m, m2)
            assert(length(m2) >= length(m));
            if (   length(m2) == length(m))
                return; end
            
            keys = m2.keys;
            mtmp = containers.Map('KeyType', 'double', 'ValueType', 'any');
            for k = 1:length(keys)
                if (m.isKey(keys{k}))
                    mtmp(keys{k}) = m(keys{k});
                else
                    mtmp(keys{k}) = nan;
                end
            end
            m = mtmp;
        end
        function v    = map2vec(~, m)
            assert(isa(m, 'containers.Map'));
            v = cell2mat(m.values)';
        end
        function m    = map2mean(~, m)
            assert(isa(m, 'containers.Map'));
            m = mean(cell2mat(m.values));
        end
        
        function this = mapDsa(this, p)
            import mlsurfer.*;            
            this.dsaMap_ = DatasetMap.asMap('dsa', 'SessionPath', p.Results.SessionPath);
        end
        function this = mapThickness(this, p)
            try
                import mlsurfer.*;
                this.thicknessMap_    = DatasetMap.asMap('thickness',    'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.thicknessPca_    = DatasetMap.asMap('thickness',    'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.thicknessStdMap_ = DatasetMap.asMap('thicknessStd', 'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.thicknessStdPca_ = DatasetMap.asMap('thicknessStd', 'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.cvsMap_          = DatasetMap.asMap('cvs',          'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.cvsPca_          = DatasetMap.asMap('cvs',          'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
            catch ME                
                handwarning(ME, sprintf('no thickness data\n'));
                this.noThickness_ = true;
            end
        end
        function this = mapDiffusion(this, p)
            if (lexist(fullfile( ...
                    p.Results.SessionPath, 'fsl', 'dwi_default.nii.gz')));
                try
                    import mlsurfer.*;
                    this.adcMap_ = DatasetMap.asMap('adc_default',         'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                    this.adcPca_ = DatasetMap.asMap('adc_default',         'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                    this.dwiMap_ = DatasetMap.asMap('dwi_default_meanvol', 'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                    this.dwiPca_ = DatasetMap.asMap('dwi_default_meanvol', 'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                catch ME 
                    handwarning(ME, sprintf('no diffusion data\n'));
                    this.noDiffusion_ = true;
                end
            else
                this.noDiffusion_ = true;
            end
        end
        function this = mapBolusTracking(this, p)
            try
                import mlsurfer.*;
                this.CBFMap_   = DatasetMap.asMap('CBF',   'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.CBFPca_   = DatasetMap.asMap('CBF',   'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.CBVMap_   = DatasetMap.asMap('CBV',   'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.CBVPca_   = DatasetMap.asMap('CBV',   'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.MTTMap_   = DatasetMap.asMap('MTT',   'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.MTTPca_   = DatasetMap.asMap('MTT',   'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.t0Map_    = DatasetMap.asMap('t0',    'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.t0Pca_    = DatasetMap.asMap('t0',    'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.alphaMap_ = DatasetMap.asMap('alpha', 'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.alphaPca_ = DatasetMap.asMap('alpha', 'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.betaMap_  = DatasetMap.asMap('beta',  'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.betaPca_  = DatasetMap.asMap('beta',  'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.gammaMap_ = DatasetMap.asMap('gamma', 'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.gammaPca_ = DatasetMap.asMap('gamma', 'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
            catch ME 
                handwarning(ME, sprintf('no perfusion data\n'));
                this.noPerfusion_ = true;
            end
        end
        function this = mapO15(this, p)
            try
                import mlpet.* mlsurfer.*;
                this.hoMap_   = DatasetMap.asMap(PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX,   ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.hoPca_   = DatasetMap.asMap(PETSegstatsBuilder.HO_MEANVOL_FILEPREFIX,   ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.ooMap_   = DatasetMap.asMap(PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX,   ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.ooPca_   = DatasetMap.asMap(PETSegstatsBuilder.OO_MEANVOL_FILEPREFIX,   ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                this.oohoMap_ = DatasetMap.asMap(PETSegstatsBuilder.OEFNQ_FILEPREFIX, ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                this.oohoPca_ = DatasetMap.asMap(PETSegstatsBuilder.OEFNQ_FILEPREFIX, ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                try
                    this.ocMap_ = DatasetMap.asMap(PETSegstatsBuilder.OC_FILEPREFIX, ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', p.Results.Territory);
                    this.ocPca_ = DatasetMap.asMap(PETSegstatsBuilder.OC_FILEPREFIX, ...
                                                'SessionPath', p.Results.SessionPath, 'Territory', 'pca_min');
                catch ME 
                    handwarning(ME, sprintf('no carbon monoxide data\n'));
                    this.noCarbonMonoxide_ = true;
                end
            catch ME 
                handwarning(ME, sprintf('no PET data\n'));
                this.noPET_ = true;
                this.noCarbonMonoxide_ = true;
            end
        end
        
        function this = matchAllKeys(this)
            this = this.matchDsaKeys;
            this = this.matchThicknessKeys;
            this = this.matchDiffusionKeys;
            this = this.matchBolusTrackingKeys;
            this = this.matchO15Keys;
        end
        function this = matchDsaKeys(this)
            this.dsaMap_ = this.matchKeys(this.dsaMap_, this.dsaMap_);
        end
        function this = matchThicknessKeys(this)
            try
                this.thicknessMap_    = this.matchKeys(this.thicknessMap_,    this.dsaMap_);
                this.thicknessStdMap_ = this.matchKeys(this.thicknessStdMap_, this.dsaMap_);
                this.cvsMap_          = this.matchKeys(this.cvsMap_,          this.dsaMap_);
            catch ME
            end
        end
        function this = matchDiffusionKeys(this)
            try
                this.adcMap_ = this.matchKeys(this.adcMap_, this.dsaMap_);
                this.dwiMap_ = this.matchKeys(this.dwiMap_, this.dsaMap_);
            catch ME %#ok<*NASGU>
            end
        end
        function this = matchBolusTrackingKeys(this)
            try
                this.CBFMap_   = this.matchKeys(this.CBFMap_,   this.dsaMap_);
                this.CBVMap_   = this.matchKeys(this.CBVMap_,   this.dsaMap_);
                this.MTTMap_   = this.matchKeys(this.MTTMap_,   this.dsaMap_);
                this.t0Map_    = this.matchKeys(this.t0Map_,    this.dsaMap_);
                this.alphaMap_ = this.matchKeys(this.alphaMap_, this.dsaMap_);
                this.betaMap_  = this.matchKeys(this.betaMap_,  this.dsaMap_);
                this.gammaMap_ = this.matchKeys(this.gammaMap_, this.dsaMap_);
            catch ME
            end  
        end
        function this = matchO15Keys(this)
            try
                this.hoMap_   = this.matchKeys(this.hoMap_,   this.dsaMap_);
                this.ooMap_   = this.matchKeys(this.ooMap_,   this.dsaMap_);
                this.oohoMap_ = this.matchKeys(this.oohoMap_, this.dsaMap_);
                try
                    this.ocMap_ = this.matchKeys(this.ocMap_, this.dsaMap_);
                catch ME
                end
            catch ME
            end
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

