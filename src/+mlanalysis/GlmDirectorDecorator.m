classdef GlmDirectorDecorator < mlanalysis.GlmDirectorComponent 
	%% GLMDIRECTORDECORATOR maintains a reference to a component object,
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
        
 		function this = GlmDirectorDecorator(varargin) 
 			%% GLMDIRECTORDECORATOR 
            %  Usage:  obj = GlmDirectorDecorator([aGlmDirector])
            %                                      ^ default is a GlmDirector
            
            p = inputParser;
            addOptional(p, 'cmp', mlanalysis.GlmDirector, @(x) isa(x, 'mlanalysis.GlmDirectorComponent'));
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

