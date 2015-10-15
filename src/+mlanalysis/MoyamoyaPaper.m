classdef MoyamoyaPaper < mlsurfer.SurferData 
	%% MOYAMOYAPAPER is under rapid prototyping  

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 
 	 

	properties 
        cerebellar_stats_filename = '/Volumes/SeagateBP4/cvl/np755/cerebellar_oefnq_statistics_2015oct12.mat'
        age_filename              = '/Volumes/SeagateBP4/cvl/np755/ageAtPresentation.mat'
        sex_filename              = '/Volumes/SeagateBP4/cvl/np755/subjectsSex.mat'
 	end 

	methods (Static)
        function visitIdSegstats(sessPth)
            import mlfourd.* mlanalysis.*;
            niiFilenames = {'oo_sumt_737353fwhh_on_T1' 'ho_sumt_737353fwhh_on_T1'};
            hemis        = {'lh' 'rh'};
            for n = 1:2
                bldr.fslPath = fullfile(sessPth, 'fsl', '');
                bldr.mriPath = fullfile(sessPth, 'mri', '');
                bldr.product = NIfTId.load(fullfile(bldr.fslPath, niiFilenames{n}));
                for h = 1:2
                    MoyamoyaPaper.visitIdSegstats_(bldr, hemis{h});
                end
            end
        end
        function visitIdSegstats_(bldr, hemi)
            import mlsurfer.* mlanalysis.*;
            cd(bldr.fslPath);
            opts2              = Mri_segstatsOptions;
            opts2.seg          = fullfile(bldr.mriPath, 'aparc.a2009s+aseg.mgz');
            opts2.ctab_default = true;
            opts2.id           = MoyamoyaPaper.idsAparcA2009s(hemi);
            opts2.i            = bldr.product.fqfilename;
            opts2.sum          = fullfile(bldr.fslPath, [hemi '_' bldr.product.fileprefix '.stats']);            
            mlbash(sprintf('mri_segstats %s', char(opts2)));
        end
        function num = idsAparcA2009s(hemi)
            num = nan; %#ok<NASGU>
            switch (hemi)
                case 'lh'
                    num = 11100 + (1:75);
                    num = [7 8 num]; % add cerebellum
                case 'rh'
                    num = 12100 + (1:75);
                    num = [46 47 num]; % add cerebellum
                otherwise
                    error('mlanalysis:unsupportedParamValue', 'MoyamoyaPaper.idsAparcA2009s.hemi->%s', hemi);
            end
        end
        
        function registerPET(sessPth)
            import mlanalysis.*;
            if (lexist( ...
                    fullfile(sessPth, 'ECAT_EXACT', '962_4dfp', [str2pnum(sessPth) 'oc1.nii.gz'])))
                MoyamoyaPaper.registerPET4(sessPth);
            else
                MoyamoyaPaper.registerPET3(sessPth);
            end
        end        
        function registerPET4(sessPth)
            import mlfourd.* mlanalysis.*;
            
            pwd0 = pwd;
            cd(fullfile(sessPth, 'ECAT_EXACT', '962_4dfp', ''));
            pnum = str2pnum(sessPth);
            ho = NIfTId.load([pnum 'ho1_sumt']);
            oo = NIfTId.load([pnum 'oo1_sumt']);
            oc = NIfTId.load([pnum 'oc1']);
            tr = NIfTId.load([pnum 'tr1']);
            
            all = MoyamoyaPaper.combinePET([pnum 'all'], ho, oo, oc, tr);            
            all.save
            
            PPS = [7.31 7.31 5.33];
            bho = BlurringNIfTId(ho, 'blur', PPS);
            boo = BlurringNIfTId(oo, 'blur', PPS);
            boc = BlurringNIfTId(oc, 'blur', PPS);
            btr = BlurringNIfTId(tr, 'blur', PPS);
            bho.save
            boo.save
            boc.save
            btr.save
            
            ball = MoyamoyaPaper.combinePET([pnum 'all_737353fwhh'], bho, boo, boc, btr);
            ball.save

            cd(pwd0);
        end
        function registerPET3(sessPth)
            import mlfourd.* mlanalysis.*;
            
            pwd0 = pwd;
            cd(fullfile(sessPth, 'ECAT_EXACT', '962_4dfp', ''));
            pnum = str2pnum(sessPth);
            ho = NIfTId.load([pnum 'ho1_sumt']);
            oo = NIfTId.load([pnum 'oo1_sumt']);
            tr = NIfTId.load([pnum 'tr1']);
            
            all = MoyamoyaPaper.combinePET([pnum 'all'], ho, oo, tr);            
            all.save
            
            PPS = [7.31 7.31 5.33];
            bho = BlurringNIfTId(ho, 'blur', PPS);
            boo = BlurringNIfTId(oo, 'blur', PPS);
            btr = BlurringNIfTId(tr, 'blur', PPS);
            bho.save
            boo.save
            btr.save
            
            ball = MoyamoyaPaper.combinePET([pnum 'all_737353fwhh'], bho, boo, btr);
            ball.save

            cd(pwd0);
        end
        function flirt(sessPth)
            import mlanalysis.*;
            if (lexist( ...
                    fullfile(sessPth, 'ECAT_EXACT', '962_4dfp', [str2pnum(sessPth) 'oc1.nii.gz'])))
                tracers = {'ho' 'oo' 'oc' 'tr'};
                ext = {'_sumt' '_sumt' '' ''};
                MoyamoyaPaper.flirt_(sessPth, tracers, ext, 1);
            else
                tracers = {'ho' 'oo' 'tr'};
                ext = {'_sumt' '_sumt' ''};
                MoyamoyaPaper.flirt_(sessPth, tracers, ext, 1);
            end
        end
        function flirt_(sessPth, tracers, ext, sid)
            pnum = str2pnum(sessPth);
            mlbash(sprintf('mri_convert %s/mri/T1.mgz %s/mri/T1.nii.gz', sessPth, sessPth));
            mlbash(sprintf( ...
                ['/usr/local/fsl/bin/flirt ' ...
                 '-in   %s/ECAT_EXACT/962_4dfp/%sall_737353fwhh.nii.gz ' ...
                 '-ref  %s/mri/T1.nii.gz ' ...
                 '-out  %s/fsl/all_737353fwhh_on_T1.nii.gz ' ...
                 '-omat %s/fsl/all_737353fwhh_on_T1.mat ' ...
                 '-bins 256 -cost normmi ' ...
                 '-searchrx -90 90 -searchry -90 90 -searchrz -90 90 ' ...
                 '-dof 6 -interp trilinear'], ...
                 sessPth, pnum, sessPth, sessPth, sessPth));
             for t = 1:length(tracers)
                 mlbash(sprintf( ...
                     ['/usr/local/fsl/bin/flirt ' ...
                      '-in %s/ECAT_EXACT/962_4dfp/%s%s%i%s_737353fwhh.nii.gz ' ...
                      '-applyxfm -init %s/fsl/all_737353fwhh_on_T1.mat ' ...
                      '-out %s/fsl/%s%s_737353fwhh_on_T1.nii.gz ' ...
                      '-paddingsize 0.0 -interp trilinear ' ...
                      '-ref %s/mri/T1.nii.gz'], ...
                      sessPth, pnum, tracers{t}, sid, ext{t}, sessPth, sessPth, tracers{t}, ext{t}, sessPth));
             end
        end
        
        function visualizeOefnq
            dt = mlsystem.DirTool('mm0*');
            assert(dt.length > 0);
            for d = 1:dt.length
                cd(fullfile(dt.fqdns{d}, 'fsl', ''));
                mlbash(sprintf('freeview oefnq_default_161616fwhh_on_t1_default_on_fsanatomical.mgz ../mri/aparc.a2009s+aseg.mgz'));
            end
        end
        function [x,y,ids,sess] = plotOefratio2Thickness(terr)
            this = mlanalysis.MoyamoyaPaper('Parameter', 'thickness', 'Territory', terr);
            oefratio             = this.cohortOefratio;
            [thickness,ids,sess] = this.cohortThickness;

            oefratioSubject  = cellfun(@mean, oefratio)';
            thicknessSubject = cellfun(@mean, thickness)';
            
            inclusions = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ];
            oefratioSubject  = oefratioSubject( inclusions == 1);
            thicknessSubject = thicknessSubject(inclusions == 1);
            
            this.plot(oefratioSubject, thicknessSubject, this.territory);
            cftool(oefratioSubject, thicknessSubject);
            x = oefratioSubject;
            y = thicknessSubject;            
        end        
        function [x,y] = plotAge2Thickness(terr)       
            this = mlanalysis.MoyamoyaPaper('Parameter', 'thickness', 'Territory', terr);
            th = this.cohortThickness;            
            thSubject = cellfun(@mean, th)';            
            load(this.age_filename);
            
            this.plot(ageAtPresentation, thSubject, this.territory);
            cftool(ageAtPresentation, thSubject);
            x = ageAtPresentation;
            y = thSubject;
            
%             Nids = length(ids);
%             Nsess = length(sess);
%             ageAtPresentationLarge = nan(Nids*Nsess,1);
%             for d = 1:Nsess
%                 ageAtPresentationLarge((d-1)*Nids+1:d*Nids) = ageAtPresentation(d); 
%             end
        end       
        function [x,y] = plotSex2Thickness(terr) 
            this = mlanalysis.MoyamoyaPaper('Parameter', 'thickness', 'Territory', terr);
            th = this.cohortThickness;            
            thSubject = cellfun(@mean, th)';
            load(this.sex_filename);
            
            isFemale = subjectsSex == 'Female';
            this.plot(isFemale, thSubject, this.territory);
            x = isFemale;
            y = thSubject;
            
%             Nids = length(ids);
%             Nsess = length(sess);
%             subjectsSexLarge = nan(Nids*Nsess,1);
%             for d = 1:Nsess
%                 for ids = 1:Nids
%                     subjectsSexLarge{(d-1)*Nids+ids} = subjectsSex{d}; %#ok<USENS>
%                 end
%             end
        end
        function [aver,sd] = cerebellarOef(sessionPth)
            pwd0 = pwd;
            cd(sessionPth);
            
            import mlfourd.*;
            aparc = NIfTId.load(fullfile('mri', 'aparc.a2009s+aseg.mgz'));
            aparc.img = double(aparc.img == 7 | aparc.img == 8 | aparc.img == 46 | aparc.img == 47);
            oefnq = NIfTId.load(fullfile(sessionPth, 'fsl', 'oefnq_default_161616fwhh_on_t1_default_on_fsanatomical.mgz'));
            maskoef = oefnq.clone;
            maskoef.img = double(maskoef.img > eps & maskoef.img < 1);
            maskoef.img = maskoef.img .* aparc.img;
            maskoef.freeview;
            
            aver = mean(oefnq.img(maskoef.img == 1));
            sd  = std( oefnq.img(maskoef.img == 1));
            
            cd(pwd0);
        end
    end 
    
    methods
        function this = MoyamoyaPaper(varargin)
            this = this@mlsurfer.SurferData(varargin{:});
        end
        function plot(~, X1, Y1, terr)
            %% PLOT(X1, Y1, territory)
            %  X1:  vector of x data
            %  Y1:  vector of y data

            %  Auto-generated by MATLAB on 13-Oct-2015 15:45:41

            % Create figure
            figure1 = figure;

            % Create axes
            axes1 = axes('Parent',figure1,'FontSize',14);
            box(axes1,'on');
            hold(axes1,'on');

            % Create plot
            plot(X1,Y1,'MarkerSize',10,'Marker','o','LineStyle','none');

            % Create xlabel
            xlabel(sprintf('OEF(%s) / OEF(cerebellum)', upper(terr)),'FontSize',15.4);

            % Create ylabel
            ylabel('thickness / mm','FontSize',15.4);

            % Create title
            title(sprintf('30 patients, %s territory', upper(terr)), 'FontSize',15.4);
        end        
        function plotLinRegress(this, X1, Y1, terr)
            %CREATEFIGURE(X1, Y1)
            %  X1:  vector of x data
            %  Y1:  vector of y data

            %  Auto-generated by MATLAB on 13-Oct-2015 16:19:46

            % Create figure
            figure1 = figure;

            % Create axes
            axes1 = axes('Parent',figure1,'FontSize',14,'Position',[0.13 0.5675 0.775 0.3575]);
            %% Uncomment the following line to preserve the X-limits of the axes
            % xlim(axes1,[0.7 1.4]);
            box(axes1,'on');
            hold(axes1,'on');

            % Create plot
            plot1 = plot(X1,Y1,'Parent',axes1,'DisplayName','data1','MarkerSize',10,'Marker','o','LineStyle','none');

            % Get xdata from plot
            xdata1 = get(plot1, 'xdata');
            % Get ydata from plot
            ydata1 = get(plot1, 'ydata');
            % Make sure data are column vectors
            xdata1 = xdata1(:);
            ydata1 = ydata1(:);


            % Remove NaN values and warn
            nanMask1 = isnan(xdata1(:)) | isnan(ydata1(:));
            if any(nanMask1)
                warning('GeneratedCode:IgnoringNaNs', ...
                    'Data points with NaN coordinates will be ignored.');
                xdata1(nanMask1) = [];
                ydata1(nanMask1) = [];
            end

            % Find x values for plotting the fit based on xlim
            axesLimits1 = xlim(axes1);
            xplot1 = linspace(axesLimits1(1), axesLimits1(2));

            % Prepare for plotting residuals
            set(axes1,'position',[0.1300    0.5811    0.7750    0.3439]);
            residAxes1 = axes('position', [0.1300    0.1100    0.7750    0.3439], ...
                'parent', gcf);
            savedResids1 = zeros(length(xdata1), 1);
            % Sort residuals
            [sortedXdata1, xInd1] = sort(xdata1);

            % Preallocate for "Show equations" coefficients
            coeffs1 = cell(1,1);


            fitResults1 = polyfit(xdata1, ydata1, 1);
            % Evaluate polynomial
            yplot1 = polyval(fitResults1, xplot1);

            % Save type of fit for "Show norm of residuals" and "Show equations"
            fittypesArray1(1) = 2;

            % Calculate and save residuals - evaluate using original xdata
            Yfit1 = polyval(fitResults1, xdata1);
            resid1 = ydata1 - Yfit1(:);
            savedResids1(:,1) = resid1(xInd1);
            savedNormResids1(1) = norm(resid1);

            % Save coefficients for "Show Equation"
            coeffs1{1} = fitResults1;

            % Plot the fit
            fitLine1 = plot(xplot1,yplot1,'DisplayName','   linear','Tag','linear','Parent',axes1,'Color',[0.929 0.694 0.125]);

            % Set new line in proper position
            this.setLineOrder(axes1, fitLine1, plot1);            

            % Create xlabel
            xlabel(sprintf('OEF(%s) / OEF(cerebellum)', upper(terr(1:3))),'FontSize',15.4);

            % Create ylabel
            ylabel('thickness / mm','FontSize',15.4);

            % Create title
            title(sprintf('30 patients, maximal %s territory', upper(terr(1:3))), 'FontSize',15.4);

            % Create legend
            legend(axes1,'show');
            
            % Plot residuals in a bar plot
            residPlot1 = bar(residAxes1, sortedXdata1, savedResids1);
            % Set colors to match fit lines
            set(residPlot1(1), 'facecolor', [0.929 0.694 0.125],'edgecolor', [0.929 0.694 0.125]);
            % Set residual plot axis title
            % set(get(residAxes1, 'title'),'string','residuals');

            % "Show norm of residuals" was selected
            this.showNormOfResiduals(residAxes1, fittypesArray1, savedNormResids1);

            % "Show equations" was selected
            this.showEquations(fittypesArray1, coeffs1, 3, axes1);
        end
    end
    
    %% PRIVATE
    
    methods (Static, Access = 'private')
        function all = combinePET(filePrefix, varargin)
            all = varargin{1}.clone;
            all.fileprefix = filePrefix;
            all.img = varargin{1}.img/sum(sum(sum(varargin{1}.img)));
            for i = 2:length(varargin)
                all.img = all.img + varargin{i}.img/sum(sum(sum(varargin{i}.img)));
            end
        end
    end
    
    methods (Access = 'private')
        %-------------------------------------------------------------------------%
        function setLineOrder(this, axesh1, newLine1, associatedLine1)
            %SETLINEORDER(AXESH1,NEWLINE1,ASSOCIATEDLINE1)
            %  Set line order
            %  AXESH1:  axes
            %  NEWLINE1:  new line
            %  ASSOCIATEDLINE1:  associated line

            % Get the axes children
            hChildren = get(axesh1,'Children');
            % Remove the new line
            hChildren(hChildren==newLine1) = [];
            % Get the index to the associatedLine
            lineIndex = find(hChildren==associatedLine1);
            % Reorder lines so the new line appears with associated data
            hNewChildren = [hChildren(1:lineIndex-1);newLine1;hChildren(lineIndex:end)];
            % Set the children:
            set(axesh1,'Children',hNewChildren);
        end

        %-------------------------------------------------------------------------%
        function showNormOfResiduals(this, residaxes1, fittypes1, normResids1)
            %SHOWNORMOFRESIDUALS(RESIDAXES1,FITTYPES1,NORMRESIDS1)
            %  Show norm of residuals
            %  RESIDAXES1:  axes for residuals
            %  FITTYPES1:  types of fits
            %  NORMRESIDS1:  norm of residuals

            txt = cell(length(fittypes1) ,1);
            for i = 1:length(fittypes1)
                txt{i,:} = this.getResidString(fittypes1(i),normResids1(i));
            end
            % Save current axis units; then set to normalized
            axesunits = get(residaxes1,'units');
            set(residaxes1,'units','normalized');
            text(.05,.95,txt,'parent',residaxes1, ...
                'verticalalignment','top','units','normalized');
            % Reset units
            set(residaxes1,'units',axesunits);
        end

        %-------------------------------------------------------------------------%
        function [s1] = getResidString(this, fittype1, normResid1)
            %GETRESIDSTRING(FITTYPE1,NORMRESID1)
            %  Get "Show norm of residuals" string
            %  FITTYPE1:  type of fit
            %  NORMRESID1:  norm of residuals

            % Get the string from the message catalog.
            switch fittype1
                case 0
                    s1 = getString(message('MATLAB:graph2d:bfit:ResidualDisplaySplineNorm'));
                case 1
                    s1 = getString(message('MATLAB:graph2d:bfit:ResidualDisplayShapepreservingNorm'));
                case 2
                    s1 = getString(message('MATLAB:graph2d:bfit:ResidualDisplayLinearNorm', num2str(normResid1)));
                case 3
                    s1 = getString(message('MATLAB:graph2d:bfit:ResidualDisplayQuadraticNorm', num2str(normResid1)));
                case 4
                    s1 = getString(message('MATLAB:graph2d:bfit:ResidualDisplayCubicNorm', num2str(normResid1)));
                otherwise
                    s1 = getString(message('MATLAB:graph2d:bfit:ResidualDisplayNthDegreeNorm', fittype1-1, num2str(normResid1)));
            end
        end

        %-------------------------------------------------------------------------%
        function showEquations(this, fittypes1, coeffs1, digits1, axesh1)
            %SHOWEQUATIONS(FITTYPES1,COEFFS1,DIGITS1,AXESH1)
            %  Show equations
            %  FITTYPES1:  types of fits
            %  COEFFS1:  coefficients
            %  DIGITS1:  number of significant digits
            %  AXESH1:  axes

            n = length(fittypes1);
            txt = cell(length(n + 1) ,1);
            txt{1,:} = ' ';
            for i = 1:n
                txt{i + 1,:} = this.getEquationString(fittypes1(i),coeffs1{i},digits1,axesh1);
            end
            text(.05,.95,txt,'parent',axesh1, ...
                'verticalalignment','top','units','normalized');
        end

        %-------------------------------------------------------------------------%
        function [s1] = getEquationString(this, fittype1, coeffs1, digits1, axesh1)
            %GETEQUATIONSTRING(FITTYPE1,COEFFS1,DIGITS1,AXESH1)
            %  Get show equation string
            %  FITTYPE1:  type of fit
            %  COEFFS1:  coefficients
            %  DIGITS1:  number of significant digits
            %  AXESH1:  axes

            if isequal(fittype1, 0)
                s1 = 'Cubic spline interpolant';
            elseif isequal(fittype1, 1)
                s1 = 'Shape-preserving interpolant';
            else
                op = '+-';
                format1 = ['%s %0.',num2str(digits1),'g*x^{%s} %s'];
                format2 = ['%s %0.',num2str(digits1),'g'];
                xl = get(axesh1, 'xlim');
                fit =  fittype1 - 1;
                s1 = sprintf('y =');
                th = text(xl*[.95;.05],1,s1,'parent',axesh1, 'vis','off');
                if abs(coeffs1(1) < 0)
                    s1 = [s1 ' -'];
                end
                for i = 1:fit
                    sl = length(s1);
                    if ~isequal(coeffs1(i),0) % if exactly zero, skip it
                        s1 = sprintf(format1,s1,abs(coeffs1(i)),num2str(fit+1-i), op((coeffs1(i+1)<0)+1));
                    end
                    if (i==fit) && ~isequal(coeffs1(i),0)
                        s1(end-5:end-2) = []; % change x^1 to x.
                    end
                    set(th,'string',s1);
                    et = get(th,'extent');
                    if et(1)+et(3) > xl(2)
                        s1 = [s1(1:sl) sprintf('\n     ') s1(sl+1:end)];
                    end
                end
                if ~isequal(coeffs1(fit+1),0)
                    sl = length(s1);
                    s1 = sprintf(format2,s1,abs(coeffs1(fit+1)));
                    set(th,'string',s1);
                    et = get(th,'extent');
                    if et(1)+et(3) > xl(2)
                        s1 = [s1(1:sl) sprintf('\n     ') s1(sl+1:end)];
                    end
                end
                delete(th);
                % Delete last "+"
                if isequal(s1(end),'+')
                    s1(end-1:end) = []; % There is always a space before the +.
                end
                if length(s1) == 3
                    s1 = sprintf(format2,s1,0);
                end
            end
        end

    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

