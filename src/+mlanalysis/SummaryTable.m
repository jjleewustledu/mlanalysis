classdef SummaryTable
	%% SUMMARYTABLE is a builder pattern for reporting results
	%  Version $Revision$ was created $Date$ by $Author$,  
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$ 
 	%  Developed on Matlab 7.14.0.739 (R2012a) 
 	%  $Id$ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
        rootTable
    end
    
    properties (Dependent)
        size
        numel
        topTables
    end

    methods (Static)
        function this = loadst(fn)
            this = load(fn, 'this');
        end % static loadst
        function this = summarize(statsInterface)
            
        end
    end
    
	methods 
        
        function sz   = get.size(this)
            sz = size(this.rootTable);
        end
        function ne   = get.numel(this)
            ne = numel(this.rootTable);
        end
        function ce   = get.topTables(this)
            ce = fieldnames(this.rootTable);
        end

        function        savest(this, fn)
            save(fn, this, '-mat');
        end % savest
        
 		function this = SummaryTable 
 			%% SUMMARYTABLE 
 			%  Usage:  prefer creation methods 
            
 		end %  ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

