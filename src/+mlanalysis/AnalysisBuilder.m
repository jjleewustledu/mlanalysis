classdef AnalysisBuilder 
	%% ANALYSISBUILDER is a builder design pattern for imaging analysis objects%  Version $Revision$ was created $Date$ by $Author$,  
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id$ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties (Dependent)
        left
        right
        
        grey
        white
        
 		aca
        mca
        pca
        cerebellar
        
        bankssts
        caudalanteriorcingulate
        caudalmiddlefrontal
        cuneus
        entorhinal
        fusiform
        inferiorparietal
        inferiortemporal
        isthmuscingulate
        lateraloccipital
        lateralorbitofrontal
        lingual
        medialorbitofrontal
        middletemporal
        parahippocampal
        paracentral
        parsopercularis
        parsorbitalis
        parstriangularis
        pericalcarine
        postcentral
        posteriorcingulate
        precentral
        precuneus
        rostralanteriorcingulate
        rostralmiddlefrontal
        superiorfrontal
        superiorparietal
        superiortemporal
        supramarginal
        frontalpole
        temporalpole
        transversetemporal
        insula
        
        oef
        cmro
        flow
 	end 

	methods 
        function lr = sampling(regions, metric)
            regions = this.ensureOrthogonal(ensureCell(regions));
            lr = [lroi rroi];
        end
        function reg = talairach(this, idx)
        end
        function reg = harvardOxford(this)
        end
        
 		function this = AnalysisBuilder() 
 			%% ANALYSISBUILDER 
 			%  Usage:  prefer using static creation methods 
 		end % AnalysisBuilder (ctor) 
    end 
    
    %% PRIVATE
    
    methods (Access = 'private')
        function regs = ensureOrthogonal(this, regs)
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

