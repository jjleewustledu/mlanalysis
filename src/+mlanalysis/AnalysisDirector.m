classdef AnalysisDirector 
	%% ANALYSISDIRECTOR works with a builder design pattern for data analysis%  Version $Revision$ was created $Date$ by $Author$,  
 	%  last modified $LastChangedDate$ and checked into svn repository $URL$ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id$ 
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad) 

	properties 
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, ... 
 		%       Constant, Dependent, Hidden, Transient) 
 	end 

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function this = AnalysisDirector() 
 			%% ANALYSISDIRECTOR 
 			%  Usage:  prefer static creation methods 
 		end % AnalysisDirector (ctor) 
 		function afun() 
 			%% AFUN  
 			%  Usage:   
 		end % afun 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

