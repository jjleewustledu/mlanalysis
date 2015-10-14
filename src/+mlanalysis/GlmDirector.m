classdef GlmDirector < mlanalysis.GlmDirectorComponent
	%% GLMDIRECTOR is the concrete component in a decorator design pattern;
    %  additional responsibilities may be attached  

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.1.0.604 (R2013a) 
 	%  $Id$ 
 	 
    methods (Static)
        function       freeviewFsanatomical
            error('mlanalysis:notImplemented', 'GlmDirector.freeviewFsanatomical');
        end
        function       slicesdir
            import mlanalysis.* mlsurfer.*;
            fprintf('GlmDirector.slicesdir:  working in filesystem location %s\n', pwd);
            try
                [~,r] = mlfsl.FslVisitor.slicesdir( ...
                        ['*_on_' SurferFilesystem.T1_FILEPREFIX '*.nii.gz'], ...
                        struct('p', [SurferFilesystem.T1_FILEPREFIX '.nii.gz']));  %#ok<ASGLU>
            catch ME
                handexcept(ME, sprintf('GlmDirector.slicesdir:\n%s%s\n', 'mlfsl.FslVisitor.slicesdir:\n', r)); %#ok<NODEF>
            end
            dt = mlsystem.DirTools(['*' SurferFilesystem.T1_FILEPREFIX '*.nii.gz']);
            assert(dt.length > 0, 'GlmDirector.slicesdir:  found no NIfTI files\n');
        end
        function val = z(val)
            val1 = val(~isnan(val));
            val  = (val - mean(val1))/std(val1);
        end
    end
    
    methods         
    end
    
    %% PROTECTED
    
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
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

