classdef MoyamoyaPaper < mlsurfer.SurferData 
	%% MOYAMOYAPAPER is under rapid prototyping  
    %  Limit OEF Ratio to [0.7 1.5] to avoid artifacts.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 
 	 

	properties 
        cerebellar_stats_filename = '/Volumes/SeagateBP4/cvl/np755/cerebellar_oefnq_statistics_2015oct12.mat'
        age_filename              = '/Volumes/SeagateBP4/cvl/np755/ageAtPresentation_2017dec15.mat'
        sex_filename              = '/Volumes/SeagateBP4/cvl/np755/subjectsSex_2017dec15.mat'
        sessions                  = { ...
            'mm01-001_p7663_2010jun23' ...
            'mm01-003_p7243_2008may21' ...
            'mm01-004_p7605_2010apr5'  ...
            'mm01-005_p7270_2008jun18' ...
            'mm01-006_p7260_2008jun9'  ...
            'mm01-007_p7686_2010aug20' ...
            'mm01-009_p7660_2010jun22' ...
            'mm01-011_p7795_2011mar8'  ...
            'mm01-012_p7414_2009apr27' ...
            'mm01-017_p7309_2008aug20' ...
            'mm01-018_p7507_2009oct21' ...
            'mm01-019_p7510_2009oct26' ...
            'mm01-020_p7377_2009feb5'  ...
            'mm01-021_p7413_2009apr24' ...
            'mm01-022_p7653_2010jun15' ...
            'mm01-025_p7470_2009aug10' ...
            'mm01-028_p7542_2009dec17' ...
            'mm01-029_p7577_2010mar1'  ...
            'mm01-030_p7604_2010apr2'  ...
            'mm01-031_p7610_2010apr7'  ...
            'mm01-032_p7624_2010apr28' ...
            'mm01-033_p7629_2010may5'  ...
            'mm01-034_p7630_2010may5'  ...
            'mm01-037_p7671_2010jul19' ...
            'mm01-038_p7684_2010aug18' ...
            'mm01-039_p7716_2010oct21' ...
            'mm01-041_p7719_2010oct21' ...
            'mm01-043_p7740_2010nov22' ...
            'mm01-044_p7773_2011jan28' ...
            'mm01-046_p7819_2011apr19' ...
            'mm01-048_p7880_2011aug10' ...
            'mm02-001_p7146_2008jan4'  ...
            'mm02-003_p7475_2009aug24' ...
            'mm03-001_p7229_2008apr28' ...
            'mm06-005_p7766_2011jan14' } % defective alignments:  01-012, 01-025; fixed 2017nov19
        exclusionLabel = 'Colin'
        modelLabel = 'oefsubj'
        theHemis = {'L' 'R'}
        distrib = 'Normal'
        link = 'identity'
        diaryStats = ''
    end 
    
    properties (Dependent)
        exclusions
        oefAltMat
        oefMat
        tdMat
        tMat
        cMat
        inclusions
        model
    end
    
    methods % GET
        function g = get.exclusions(this)
            switch (this.exclusionLabel)
                case 'Colin'
                    g = { '' 'L' 'R' '' '' '' 'R' '' '' 'L' '' '' '' 'L' 'R' 'L' 'L' '' 'L' '' '' '' '' 'L' 'R' '' '' 'R' '' '' '' 'L' '' '' '' };
                case 'orig'
                    g = { '' 'L' 'R' '' '' '' 'R' '' '' 'L' '' '' '' 'L' 'R' 'L' 'L' '' 'L' '' '' '' '' 'L' ''  '' '' 'R' '' '' '' 'L' '' '' '' };
                case 'noexcl'
                    g = { '' ''  ''  '' '' '' ''  '' '' ''  '' '' '' ''  ''  ''  ''  '' ''  '' '' '' '' ''  ''  '' '' ''  '' '' '' ''  '' '' '' };
                otherwise
                    error('mlanalysis:unsupportedSwitchCase', ...
                        'MoyamoyaPaper.get.exlucsions');
            end
        end
        function g = get.oefAltMat(this)
            g = sprintf('MoyamoyaPaper_histOefIndex_161616fwhh_oefVec_%s_%s_%s.mat', this.exclusionLabel, this.territory, this.statistic);
        end
        function g = get.oefMat(this)
            g = sprintf('MoyamoyaPaper_histOefIndex_737363fwhh_oefVec_%s_%s_%s.mat', this.exclusionLabel, this.territory, this.statistic);
        end
        function g = get.tdMat(this)
            g = sprintf('MoyamoyaPaper_histThicknessDiff_%s_%s_%s.mat', this.exclusionLabel, this.territory, this.statistic);
        end
        function g = get.tMat(this)
            g = sprintf('MoyamoyaPaper_histThickness_%s_%s_%s.mat', this.exclusionLabel, this.territory, this.statistic);
        end
        function g = get.cMat(this)
            g = sprintf('MoyamoyaPaper_categories_cVec_%s_%s_%s.mat', this.exclusionLabel, this.territory, this.statistic);
        end
        function g = get.inclusions(this)
            g = cellfun(@(x) isempty(x), this.exclusions);
        end
        function g = get.model(this)
            switch (this.modelLabel)
                case 'fixed'
                    g = 'thickd ~ 1 + sex + age + oef';
                case '1subj'
                    g = 'thickd ~ 1 + sex + age + oef + (1|subj)';
                case 'oefsubj'
                    g = 'thickd ~ 1 + sex + age + oef + (1 + oef|subj)';
                otherwise
                    error('mlanalysis:unsupportedSwitchcase', 'MoyamoyaPaper.get.model');
            end
        end
    end

	methods (Static)
        
        function buildThickness(sessPth)
            vrctb = mlsurfer.VolumeRoiCorticalThicknessBuilder('sessionpath', sessPth);
            vrctb.buildThickness;
        end
        function visitIdSegstats(sessPth)
            %% VISITIDSEGSTATS
            %  @param session_path
            %  @return results of mri_segstats:  oo_sumt_737353fwhh_on_T1.stats, ho_sumt_737353fwhh_on_T1
            import mlfourd.* mlanalysis.*;
            niiFilenames = {'oo_sumt_737353fwhh_on_T1' 'ho_sumt_737353fwhh_on_T1'};
            hemis        = {'lh' 'rh'};
            dt = mlsystem.DirTool(fullfile(sessPth, 'fsl', '*o_sumt_737353fwhh_on_T1.stats'));
            if (0 == length(dt)) %#ok<ISMT>
                for n = 1:2
                    bldr.fslPath = fullfile(sessPth, 'fsl', '');
                    bldr.mriPath = fullfile(sessPth, 'mri', '');
                        bldr.product = NIfTId.load(fullfile(bldr.fslPath, niiFilenames{n}));
                        for h = 1:2
                            MoyamoyaPaper.visitIdSegstats_(bldr, hemis{h});
                        end
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
            tracers = { 'oo' 'ho' };  
            MoyamoyaPaper.flirt_(sessPth, tracers);
        end
        function flirt_(sessPth, tracers)
            pnum = str2pnum(sessPth);
            if (~lexist(sprintf('%s/mri/T1.nii.gz', sessPth), 'file'))
                mlbash(sprintf('mri_convert %s/mri/T1.mgz %s/mri/T1.nii.gz', sessPth, sessPth));
            end
            for t = 1:length(tracers)
                mlbash(sprintf( ...
                    ['/usr/local/fsl/bin/flirt ' ...
                     '-in   %s/ECAT_EXACT/pet/%s%s1_frames/%s%s1_sumt_737353fwhh.nii.gz ' ...
                     '-ref  %s/mri/T1.nii.gz ' ...
                     '-out  %s/fsl/%s_sumt_737353fwhh_on_T1.nii.gz ' ...
                     '-omat %s/fsl/%s_sumt_737353fwhh_on_T1.mat ' ...
                     '-bins 256 -cost mutualinfo ' ...
                     '-searchrx -90 90 -searchry -90 90 -searchrz -90 90 ' ...
                     '-dof 6 -interp trilinear'], ...
                     sessPth, pnum, tracers{t}, pnum, tracers{t}, sessPth, sessPth, tracers{t}, sessPth, tracers{t})); % normmi mutualinfo corratio
                 mlbash(sprintf('fsleyes %s/mri/T1.nii.gz %s/fsl/%s_sumt_737353fwhh_on_T1.nii.gz', sessPth, sessPth, tracers{t}));
            end
        end
        
        function visualizeOefnq
            dt = mlsystem.DirTool('mm0*');
            assert(dt.length > 0);
            for d = 1:dt.length
                try
                    pwd0 = pushd(fullfile(dt.fqdns{d}, 'fsl', ''));
                    mlbash(sprintf('freeview oefnq_default_161616fwhh_on_t1_default_on_fsanatomical.mgz ../mri/aparc.a2009s+aseg.mgz'));
                    popd(pwd0);
                catch ME
                    handwarning(ME);
                end
            end
        end       
        function [x,y,ids,sess] = plotOefratio2Dsa(terr)
            this = mlanalysis.MoyamoyaPaper('Parameter', 'thickness', 'Territory', terr);
            [oefratio,ids_,sess_] = this.cohortOefratio;
            [dsa,ids,sess]        = this.cohortDsa;

            oefratioSubject  = cellfun(@mean, oefratio)';
            dsaSubject = cellfun(@mean, dsa)';
            
            inclusions = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ];
            oefratioSubject  = oefratioSubject( inclusions == 1);
            dsaSubject = dsaSubject(inclusions == 1);
            
            this.plot(oefratioSubject, dsaSubject, this.territory);
            cftool(oefratioSubject, dsaSubject);
            x = oefratioSubject;
            y = dsaSubject;            
        end    
        function [x,y,ids,sess] = plotOefratio2Thickness(terr)
            this = mlanalysis.MoyamoyaPaper('Parameter', 'thickness', 'Territory', terr);
            [oefratio,ids_,sess_] = this.cohortOefratio;
            [thickness,ids,sess]  = this.cohortThickness;

            oefratioSubject  = cellfun(@mean, oefratio)';
            thicknessSubject = cellfun(@mean, thickness)';
            
            oefratioSubject  = oefratioSubject( this.inclusions == 1);
            thicknessSubject = thicknessSubject(this.inclusions == 1);
            
            this.plot(oefratioSubject, thicknessSubject, this.territory);
            %cftool(oefratioSubject, thicknessSubject);
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
            mlsurfer.SurferRegistry.instance('initialize');
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'exclusionLabel', this.exclusionLabel, @ischar);
            addParameter(ip, 'modelLabel', this.modelLabel, @ischar);
            parse(ip, varargin{:});
            
            this.exclusionLabel = ip.Results.exclusionLabel;
            this.modelLabel = ip.Results.modelLabel;
        end
        
        function plot(~, X1, Y1, varargin)
            
            ip = inputParser;
            addRequired(ip, 'X1', @isnumeric);
            addRequired(ip, 'Y1', @isnumeric);
            addOptional(ip, 'terr', 'ACA + MCA', @ischar);
            parse(ip, X1, Y1, varargin{:});
            
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
            plot(X1,Y1,'MarkerSize',8,'Marker','.','LineStyle','none');

            % Create xlabel
            xlabel(sprintf('OEF Ratio (%s)', ip.Results.terr),'FontSize',16);

            % Create ylabel
            ylabel('Thickness (mm)','FontSize',16);

            % Create title
            %title(sprintf('30 patients, %s territory', ip.Results.terr), 'FontSize',16);
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
        function scatter(~, X1, Y1, varargin)
            
            ip = inputParser;
            addRequired(ip, 'X1', @isnumeric);
            addRequired(ip, 'Y1', @isnumeric);
            addParameter(ip, 'terr', '', @ischar);
            addParameter(ip, 'category', []);
            addParameter(ip, 'response', 'Thickness (mm)');
            parse(ip, X1, Y1, varargin{:});
            
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
            if (~isempty(ip.Results.category))
                scatter(X1,Y1,8,ip.Results.category, 'filled');
                colorbar; %('TickLabels', {'3' '6' '9' '12' '15' '18' '21' '24' '27' '30'});
            else
                plot(X1,Y1,'MarkerSize',8,'Marker','.','LineStyle','none');
            end

            % Create xlabel
            xlabel('OEF Ratio','FontSize',16,'FontWeight','bold');

            % Create ylabel
            ylabel(ip.Results.response,'FontSize',16,'FontWeight','bold');

            % Create title
            %title(sprintf('30 patients, %s territory', ip.Results.terr), 'FontSize',16);
        end    
        function scatter2(~, X1, Y1, varargin)
            
            ip = inputParser;
            addRequired(ip, 'X1', @isnumeric);
            addRequired(ip, 'Y1', @isnumeric);
            addParameter(ip, 'terr', '', @ischar);
            addParameter(ip, 'category', []);
            addParameter(ip, 'response', 'Thickness (mm)');
            addParameter(ip, 'size', 200, @isnumeric);
            parse(ip, X1, Y1, varargin{:});
            
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
            if (~isempty(ip.Results.category))
                scatter(X1,Y1,ip.Results.size,ip.Results.category);
                colorbar; %('TickLabels', {'3' '6' '9' '12' '15' '18' '21' '24' '27' '30'});
            else
                plot(X1,Y1,'MarkerSize',8,'Marker','.','LineStyle','none');
            end

            % Create xlabel
            xlabel('OEF Ratio', 'FontSize',16,'FontWeight','bold');

            % Create ylabel
            ylabel(ip.Results.response,'FontSize',16,'FontWeight','bold');

            % Create title
            %title(sprintf('30 patients, %s territory', ip.Results.terr), 'FontSize',16);
        end    
        
        function [cVec,cStr] = categories(this, varargin)
            ip = inputParser;
            addOptional(ip, 'kind', '', @ischar);
            parse(ip, varargin{:});
            
            switch (ip.Results.kind)
                case 'territory'                     
                    [cVec,cStr] = this.categorizeByTerritory;
                otherwise
                    [cVec,cStr] = this.categorizeBySessions;
            end
        end
        function [cVec,cStr] = categorizeByTerritory(this)
            % @return cVec has circulatory territories (ACA, MCA, PCA) with sessions & hemispheres within
            
            pwd0 = pushd(this.subjectsDir);
            cVec = [];
            terrs = {'aca' 'mca' 'pca'};
            for t = 1:length(terrs)
                for s = 1:length(this.sessions)

                    s2IC = mlsurfer.Stats2ImagingContext( ...
                        'sessionPath', fullfile(this.subjectsDir, this.sessions{s}), ...
                        'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                        'territory', terrs{t}, ...
                        'statistic', this.statistic);
                    cStr(s) = s2IC.category; %#ok<AGROW>

                    len = max(length(cStr(s).ids{1}), length(cStr(s).ids{2}));                
                    for h = 1:2
                        if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                            ids_ = cStr(s).ids{h};
                            for iparc = 1:len
                                if (cStr(s).map.isKey(ids_(iparc)))
                                    cVec = [cVec t]; %#ok<AGROW>
                                end
                            end
                        end
                    end
                end
            end
            this.territory = 'aca_mca_pca';
            save(this.cMat, 'c*');
            popd(pwd0);
        end
        function [cVec,cStr] = categorizeBySessions(this)
            % cVec has sessions with hemispheres within
            
            pwd0 = pushd(this.subjectsDir);
            cVec = [];
            for s = 1:length(this.sessions)
                
                s2IC = mlsurfer.Stats2ImagingContext( ...
                    'sessionPath', fullfile(this.subjectsDir, this.sessions{s}), ...
                    'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                    'territory', this.territory, ...
                    'statistic', this.statistic);
                cStr(s) = s2IC.category; %#ok<AGROW>
                
                len = max(length(cStr(s).ids{1}), length(cStr(s).ids{2}));                
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        ids_ = cStr(s).ids{h};
                        for iparc = 1:len
                            if (cStr(s).map.isKey(ids_(iparc)))
                                cVec = [cVec s]; %#ok<AGROW>
                            end
                        end
                    end
                end
            end
            save(this.cMat, 'c*');
            popd(pwd0);
        end
        
        function [oefVec,oefStr,h1] = histOefIndex(this, varargin)
            % oefVec has sessions with hemispheres within
            
            pwd0 = pushd(this.subjectsDir);
            oefVec = [];
            if (~isempty(this.diaryStats))
                diary([this.diaryStats 'histOefIndex']);
            end
            stats = cell(length(this.sessions), 2);
            for s = 1:length(this.sessions)
                
                s2IC = mlsurfer.Stats2ImagingContext( ...
                    'sessionPath', fullfile(this.subjectsDir, this.sessions{s}), ...
                    'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                    'territory', this.territory, ...
                    'statistic', this.statistic);                
                oefStr(s) = s2IC.oefIndex(varargin{:});  %#ok<AGROW>
                
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        ids_ = oefStr(s).ids{h};
                        parcVec = [];
                        for iparc = 1:length(ids_)
                            if (oefStr(s).map.isKey(ids_(iparc)))
                                parcVec = [parcVec oefStr(s).map(ids_(iparc))]; %#ok<AGROW>
                            end
                        end
                        oefVec = [oefVec parcVec]; %#ok<AGROW>
                    end
                    stats{s,h} = struct('mean',mean(parcVec), 'std', std(parcVec), 'max', max(parcVec));
                    this.statsPrintf(stats{s,h}, s, h);
                end
            end
            save(this.oefMat);
            h1 = histogram(oefVec);
            h1.Normalization = 'probability';
            h1.BinWidth = 0.01;
            popd(pwd0);
            diary off
            
            % [mM -2*sdM+mM 2*sdM+mM]
            % 1.076158575470095   0.805454787086135   1.346862363854055
        end
        function [tdVec,tdStr] = histThicknessDiff(this)
            % tdVec has sessions with hemispheres within
            
            pwd0 = pushd(this.subjectsDir);
            tdVec = [];
            for s = 1:length(this.sessions)            
                
                s2IC = mlsurfer.Stats2ImagingContext( ...
                    'sessionPath', fullfile(this.subjectsDir, this.sessions{s}), ...
                    'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                    'territory', this.territory, ...
                    'statistic', this.statistic);
                tdStr(s) = s2IC.thicknessDiff; %#ok<AGROW>
                
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        ids_ = tdStr(s).ids{h};
                        for iparc = 1:length(ids_)
                            if (tdStr(s).map.isKey(ids_(iparc)))
                                tdVec = [tdVec tdStr(s).map(ids_(iparc))]; %#ok<AGROW>
                            end
                        end
                    end
                end
            end            
            save(this.tdMat, 'td*');
            histogram(tdVec);
            popd(pwd0);
        end
        function [tVec,tStr] = histThickness(this)
            % tdVec has sessions with hemispheres within
            
            pwd0 = pushd(this.subjectsDir);
            tVec = [];
            if (~isempty(this.diaryStats))
                diary([this.diaryStats 'histThickness']);
            end
            stats = cell(length(this.sessions), 2);
            for s = 1:length(this.sessions)            
                
                s2IC = mlsurfer.Stats2ImagingContext( ...
                    'sessionPath', fullfile(this.subjectsDir, this.sessions{s}), ...
                    'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                    'territory', this.territory, ...
                    'statistic', this.statistic);
                tStr(s) = s2IC.thickness; %#ok<AGROW>
                
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        ids_ = tStr(s).ids{h};
                        parcVec = [];
                        for iparc = 1:length(ids_)
                            if (tStr(s).map.isKey(ids_(iparc)))
                                parcVec = [parcVec tStr(s).map(ids_(iparc))]; %#ok<AGROW>
                            end
                        end
                        tVec = [tVec parcVec]; %#ok<AGROW>
                    end
                    stats{s,h} = struct('mean', mean(parcVec), 'std', std(parcVec));
                    %this.statsPrintf(stats{s,h}, s, h);
                end
            end            
            save(this.tMat);
            histogram(tVec);
            popd(pwd0);
            diary off
            
            % [mT -2*sdT+mT 2*sdT+mT] 
            %  2.488187134502925   1.565144239983369   3.411230029022482
        end
        function histThicknessIndex(this)
            pwd0 = pushd(this.subjectsDir);
            tiVec = [];
            for s = 1:length(this.sessions)
                if (isempty(this.exclusions{s}))              

                    s2IC = mlsurfer.Stats2ImagingContext( ...
                        'sessionPath', fullfile(this.subjectsDir, this.sessions{s}), ...
                        'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                        'territory', this.territory, ...
                        'statistic', this.statistic);
                    pStr = s2IC.thicknessIndex;
                    
                    for lft = 1:length(pStr.ids{1})
                        if (pStr.map.isKey(pStr.ids{1}(lft)))
                            tiVec = [tiVec pStr.map(pStr.ids{1}(lft))]; %#ok<AGROW>
                        end
                    end
                    for rgt = 1:length(pStr.ids{2})
                        if (pStr.map.isKey(pStr.ids{2}(rgt)))
                            tiVec = [tiVec pStr.map(pStr.ids{2}(rgt))]; %#ok<AGROW>
                        end
                    end
                end
            end            
            save(sprintf('MoyamoyaPaper_histThicknessIndex_%s.mat', datestr(now,30)), 'tiVec');
            histogram(tiVec);
            popd(pwd0);
        end
        function histParam(this, param)
            assert(ischar(param));
            pwd0 = pushd(this.subjectsDir);
            pVec = [];
            for s = 1:length(this.sessions)
                if (isempty(this.exclusions{s}))              

                    s2IC = mlsurfer.Stats2ImagingContext( ...
                        'sessionPath', fullfile(this.subjectsDir, this.sessions{s}), ...
                        'aparcAseg', 'aparc.a2009s+aseg.mgz', ...
                        'territory', this.territory, ...
                        'statistic', this.statistic);
                    pStr = s2IC.aParameter(param);
                    
                    for lft = 1:length(pStr.ids{1})
                        if (pStr.map.isKey(pStr.ids{1}(lft)))
                            pVec = [pVec pStr.map(pStr.ids{1}(lft))]; %#ok<AGROW>
                        end
                    end
                    for rgt = 1:length(pStr.ids{2})
                        if (pStr.map.isKey(pStr.ids{2}(rgt)))
                            pVec = [pVec pStr.map(pStr.ids{2}(rgt))]; %#ok<AGROW>
                        end
                    end
                end
            end            
            save(sprintf('MoyamoyaPaper_histParam_%s_%s.mat', param, datestr(now,30)), 'pVec', 'pStr');
            histogram(pVec);
            popd(pwd0);
        end
        
        function fitglmeOefIndex2Thickness(this)
            % plot freesurfer regions ~3036
            
            diaryFile = sprintf('fitglmeOefIndex2Thickness_glme_%s_%s_%s.log', ...
                this.territory, this.exclusionLabel, this.modelLabel);
            deleteExisting(diaryFile);
            
            load(this.oefMat, 'oefStr', 'oefVec');
            load(this.tMat, 'tStr', 'tVec');
            if (lexist(this.cMat, 'file'))
                load(this.cMat, 'cStr', 'cVec');
            else
                cVec = this.categories;
            end
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            subjectsSex = double(strcmp('Male', subjectsSex));            
            age = [];
            sex = [];
            for s = 1:length(this.sessions)   
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        age = [age repelem(ageAtPresentation(s), length(oefStr(s).map.keys))];
                        sex = [sex repelem(subjectsSex(s),       length(oefStr(s).map.keys))];
                    end
                end
            end
            
            rng     = 0.7 < oefVec & oefVec ~= 1 & oefVec < 1.5;
            fprintf('fitglmeOefIndex2ThicknessDiff:  discarding %g regions\n', length(oefVec) - sum(rng)); 
            fprintf('fitglmeOefIndex2ThicknessDiff:  discarding fraction %g of regions\n', 1-sum(rng)/length(oefVec)); 
            oefVec2 = oefVec(rng)';
            tVec2   = tVec(rng)';
            cVec2   = cVec(rng)';
            age     = age(rng)'; 
            sex     = sex(rng)';
            assert(length(oefVec2) == length(tVec2));
            assert(length(tVec2)   == length(cVec2));
            assert(length(cVec2)   == length(age));
            assert(length(age)     == length(sex));
            this.scatter(oefVec2, tVec2, 'category', cVec2, 'response', 'Thickness (mm)');  
            this.scatter(oefVec2, age,   'category', cVec2, 'response', 'Age (years)');  
            this.scatter(oefVec2, sex,   'category', cVec2, 'response', 'Sex');    
            tbl     = table(oefVec2, age, sex, num2str(cVec2), tVec2);
            tbl.Properties.VariableNames = {'oef' 'age' 'sex' 'subj' 'thickd'};
            summary(tbl)
            glme    = fitglme(tbl, this.model, 'Link', this.link, 'Distribution', this.distrib)
            %'thickd ~ 1 + age + sex + oef + (1 + oef|subj)'
            [psi,dispersion,statsCP] = covarianceParameters(glme);
            for s = 1:length(psi)
                disp(psi{s})
            end
            disp(dispersion);
            for s = 1:length(statsCP)
                disp(statsCP{s})
            end
            [~,~,statsFE] = fixedEffects(glme)
            [~,~,statsRE] = randomEffects(glme)
            figure;
            plotResiduals(glme, 'fitted', 'ResidualType', 'Pearson')
            save(sprintf('fitglmeOefIndex2Thickness_glme_%s_%s_%s.mat', ...
                this.territory, this.exclusionLabel, this.modelLabel)); 
            diary off
        end 
        function fitglmeOefIndex2Thickness2(this)
            % plot hemispheres ~51
            
            diaryFile = sprintf('fitglmeOefIndex2Thickness2_glme2_%s_%s_%s.log', ...
                this.territory, this.exclusionLabel, this.modelLabel);
            deleteExisting(diaryFile);
            diary(diaryFile); 
            
            load(this.oefMat, 'oefStr', 'oefVec');
            load(this.tMat, 'tStr', 'tVec');
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            subjectsSex = double(strcmp('Male', subjectsSex));
            age = [];
            sex = [];
            for s = 1:length(this.sessions)   
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        age = [age ageAtPresentation(s)];
                        sex = [sex subjectsSex(s)];
                    end
                end
            end
            
            oefVec2 = [];
            tVec2   = [];
            cVec2   = [];
            oefVec_ = {[] []};
            tVec_   = {[] []};
            for s = 1:length(this.sessions)
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        oefVec2 = [oefVec2 oefStr(s).mapsHemis{h}];
                          tVec2 = [  tVec2   tStr(s).mapsHemis{h}];
                          cVec2 = [  cVec2        s];
                    end
                    oefVec_{h} = [oefVec_{h} oefStr(s).mapsHemis{h}];
                      tVec_{h} =   [tVec_{h}   tStr(s).mapsHemis{h}];
                end
            end
            writetable(table(this.sessions', tVec_{1}', oefVec_{1}', tVec_{2}', oefVec_{2}'), ...
                sprintf('fitglmeOefIndex2Thickness2_%s_%s.xlsx', this.territory, this.exclusionLabel));
            
            rng     = 0.7 < oefVec2 & oefVec2 < 1.6;
            %fprintf('fitglmeOefIndex2Thickness2:  discarding %g hemispheres\n', length(oefVec2) - sum(rng)); % 2
            %fprintf('fitglmeOefIndex2Thickness2:  discarding fraction %g of hemispheres\n', 1-sum(rng)/length(oefVec2)); % 0.0384615
            oefVec2 = oefVec2(rng)';
            tVec2   = tVec2(rng)';
            cVec2   = cVec2(rng)';
            age     = age(rng)';
            sex     = sex(rng)';
            assert(length(oefVec2) == length(tVec2));
            assert(length(tVec2)   == length(cVec2));
            assert(length(cVec2)   == length(age));
            assert(length(age)     == length(sex));
            this.scatter2(oefVec2, tVec2, 'category', cVec2, 'size', 200, 'response', 'Thickness (mm)'); 
            this.scatter2(oefVec2, age,   'category', cVec2, 'size', 200, 'response', 'Age (years)');  
            this.scatter2(oefVec2, sex,   'category', cVec2, 'size', 200, 'response', 'Sex');    
            tbl     = table(oefVec2, age, sex, cVec2, tVec2);
            tbl.Properties.VariableNames = {'oef' 'age' 'sex' 'subj' 'thickd'};
            summary(tbl)            
            glme2   = fitglme(tbl, this.model, 'Link', this.link, 'Distribution', this.distrib)            
            [psi,dispersion,statsCP] = covarianceParameters(glme2);
            for s = 1:length(psi)
                disp(psi{s})
            end
            disp(dispersion);
            for s = 1:length(statsCP)
                disp(statsCP{s})
            end
            [~,~,statsFE] = fixedEffects(glme2)
            [~,~,statsRE] = randomEffects(glme2)
            %figure;
            %plotResiduals(glme2, 'fitted', 'ResidualType', 'Pearson')
            save(sprintf('fitglmeOefIndex2Thickness2_glme2_%s_%s_%s.mat', ...
                this.territory, this.exclusionLabel, this.modelLabel)); 
            diary off
        end   
        function fitglmeOefIndex2Thickness3(this)
            % plot patients ~30
            
            diaryFile = sprintf('fitglmeOefIndex2Thickness3_glme3_%s_%s_%s.log', ...
                this.territory, this.exclusionLabel, this.modelLabel);
            deleteExisting(diaryFile);
            diary(diaryFile); 
            
            load(this.oefMat, 'oefStr', 'oefVec');
            load(this.tMat, 'tStr', 'tVec');
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            subjectsSex = double(strcmp('Male', subjectsSex));
            age = [];
            sex = [];
            for s = 1:length(this.sessions)   
                age = [age ageAtPresentation(s)];
                sex = [sex subjectsSex(s)];
            end
            
            oefVec2 = [];
            tVec2   = [];
            cVec2   = [];
            for s = 1:length(this.sessions)
                oefVecH = [];
                tVecH   = [];
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        oefVecH = [oefVecH oefStr(s).mapsHemis{h}];
                        tVecH   = [  tVecH   tStr(s).mapsHemis{h}];
                    end
                end
                oefVec2 = [oefVec2 mean(oefVecH)];
                tVec2   = [  tVec2 mean(  tVecH)];
                cVec2   = [  cVec2             s];
            end
            writetable(table(this.sessions', tVec2', oefVec2'), ...
                sprintf('fitglmeOefIndex2Thickness3_%s_%s.xlsx', this.territory, this.exclusionLabel));
            
            %rng     = 0.7 < oefVec2 & oefVec2 < 1.6;
            %fprintf('fitglmeOefIndex2Thickness3:  discarding %g hemispheres\n', length(oefVec2) - sum(rng)); % 2
            %fprintf('fitglmeOefIndex2Thickness3:  discarding fraction %g of hemispheres\n', 1-sum(rng)/length(oefVec2)); % 0.0384615
            oefVec2 = oefVec2';
            tVec2   = tVec2';
            cVec2   = cVec2';
            age     = age';
            sex     = sex';
            assert(length(oefVec2) == length(tVec2));
            assert(length(tVec2)   == length(cVec2));
            assert(length(cVec2)   == length(age));
            assert(length(age)     == length(sex));
            this.scatter2(oefVec2, tVec2, 'category', cVec2, 'size', 200, 'response', 'Thickness (mm)'); 
            this.scatter2(oefVec2, age,   'category', cVec2, 'size', 200, 'response', 'Age (years)');  
            this.scatter2(oefVec2, sex,   'category', cVec2, 'size', 200, 'response', 'Sex'); 
            tbl     = table(oefVec2, age, sex, cVec2, tVec2);
            tbl.Properties.VariableNames = {'oef' 'age' 'sex' 'subj' 'thickd'};
            summary(tbl)            
            glme2   = fitglme(tbl, this.model, 'Link', this.link, 'Distribution', this.distrib)            
            [psi,dispersion,statsCP] = covarianceParameters(glme2);
            for s = 1:length(psi)
                disp(psi{s})
            end
            disp(dispersion);
            for s = 1:length(statsCP)
                disp(statsCP{s})
            end
            [~,~,statsFE] = fixedEffects(glme2)
            [~,~,statsRE] = randomEffects(glme2)
            %figure;
            %plotResiduals(glme2, 'fitted', 'ResidualType', 'Pearson')
            save(sprintf('fitglmeOefIndex2Thickness3_glme3_%s_%s_%s.mat', ...
                this.territory, this.exclusionLabel, this.modelLabel)); 
            diary off
        end   
        function fitglmOefIndex2Thickness2(this)
            % plot hemispheres ~51
            
            diary(sprintf('fitglmOefIndex2Thickness2_glm2_%s_%s_%s.log', ...
                this.territory, this.exclusionLabel, this.modelLabel)); 
            
            load(this.oefMat, 'oefStr', 'oefVec');
            load(this.tMat, 'tStr', 'tVec');
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            subjectsSex = double(strcmp('Male', subjectsSex));
            age = [];
            sex = [];
            for s = 1:length(this.sessions)   
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        age = [age repelem(ageAtPresentation(s), 2)];
                        sex = [sex repelem(subjectsSex(s),       2)];
                    end
                end
            end
            
            oefVec2 = [];
            tVec2   = [];
            cVec2   = [];
            oefVec_ = {[] []};
            tVec_   = {[] []};
            for s = 1:length(this.sessions)
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        oefVec2 = [oefVec2 oefStr(s).mapsHemis{h}];
                        tVec2   = [  tVec2   tStr(s).mapsHemis{h}];
                        cVec2   = [  cVec2        s];
                    end
                    oefVec_{h} = [oefVec_{h} oefStr(s).mapsHemis{h}];
                    tVec_{h}  = [tVec_{h}    tStr(s).mapsHemis{h}];
                end
            end
            writetable(table(this.sessions', tVec_{1}', oefVec_{1}', tVec_{2}', oefVec_{2}'), ...
                sprintf('fitglmeOefIndex2Thickness2_%s_%s.xlsx', this.territory, this.exclusionLabel));
            
            rng     = 0.7 < oefVec2 & oefVec2 < 1.6;
            fprintf('fitglmeOefIndex2ThicknessDiff2:  discarding %g hemispheres\n', length(oefVec2) - sum(rng)); % 2
            fprintf('fitglmeOefIndex2ThicknessDiff2:  discarding fraction %g of hemispheres\n', 1-sum(rng)/length(oefVec2)); % 0.0384615
            oefVec2 = oefVec2(rng)';
            tVec2   = tVec2(rng)';
            cVec2   = cVec2(rng)';
            age     = age(rng)';
            sex     = sex(rng)';
            assert(length(oefVec2) == length(tVec2));
            assert(length(tVec2)   == length(cVec2));
            assert(length(cVec2)   == length(age));
            assert(length(age)     == length(sex));
            this.scatter2(oefVec2, tVec2, 'category', cVec2, 'size', 200);  
            this.scatter2(age,     tVec2, 'category', cVec2, 'size', 200);  
            %tbl     = table(oefVec2, age, sex, tVec2);
            %tbl.Properties.VariableNames = {'oef' 'age' 'sex' 'thickd'};
            tbl     = table(oefVec2, age, tVec2);
            tbl.Properties.VariableNames = {'oef' 'age' 'thickd'};
            summary(tbl)            
            glm2    = fitglm(tbl, 'linear')            
            coefCI(glm2)
            %plotDiagnostics(glm2, 'leverage')
            
            
            save(sprintf('fitglmOefIndex2Thickness2_glm2_%s_%s_%s.mat', ...
                this.territory, this.exclusionLabel, this.modelLabel)); 
            diary off
        end   
        function fitglmeOefIndex2ThicknessDiff(this)
            % plot freesurfer regions ~2958
            load(this.oefMat, 'oef*');
            load(this.tdMat, 't*');
            if (lexist(this.cMat, 'file'))
                load(this.cMat, 'c*');
            else
                cVec = this.categories;
            end
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            subjectsSex = double(strcmp('Male', subjectsSex));            
            age = [];
            sex = [];
            for s = 1:length(this.sessions)   
                for h = 1:2            
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        age = [age repelem(ageAtPresentation(s), length(oefStr(s).map.keys))];
                        sex = [sex repelem(subjectsSex(s),       length(oefStr(s).map.keys))];
                    end
                end
            end
            
            rng    = 0.5 < oefVec & oefVec ~= 1 & oefVec < 1.5;
            fprintf('fitglmeOefIndex2ThicknessDiff:  discarding %g regions\n', length(oefVec) - sum(rng)); % 13
            fprintf('fitglmeOefIndex2ThicknessDiff:  discarding fraction %g of regions\n', 1-sum(rng)/length(oefVec)); % 0.00431034
            oefVec2 = oefVec(rng)';
            tdVec2  = tdVec(rng)';
            cVec2   = cVec(rng)';
            age     = age(rng)'; 
            sex     = sex(rng)';
            assert(length(oefVec2) == length(tdVec2));
            assert(length(tdVec2)  == length(cVec2));
            assert(length(cVec2)   == length(age));
            assert(length(age)     == length(sex));
            this.scatter(oefVec2, tdVec2, 'category', cVec2);    
            tbl     = table(oefVec2, age, sex, cVec2, tdVec2);
            tbl.Properties.VariableNames = {'oef' 'age' 'sex' 'subj' 'thickd'};
            summary(tbl)
            glme    = fitglme(tbl, this.model, 'Link', this.link, 'Distribution', this.distrib)
            [psi,dispersion,statsCP] = covarianceParameters(glme)
            [~,~,statsFE] = fixedEffects(glme)
            [~,~,statsRE] = randomEffects(glme)
            figure;
            plotResiduals(glme, 'fitted', 'ResidualType', 'Pearson')
            save(sprintf('fitglmeOefIndex2ThicknessDiff_glme_%s_%s.mat', this.territory, this.exclusionLabel));         
        end   
        function fitglmeOefIndex2ThicknessDiff2(this)
            % plot hemispheres ~51
            
            load(this.oefMat, 'oef*');
            load(this.tdMat, 't*');
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            subjectsSex = double(strcmp('Male', subjectsSex));
            age = [];
            sex = [];
            for s = 1:length(this.sessions)   
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        age = [age repelem(ageAtPresentation(s), 2)];
                        sex = [sex repelem(subjectsSex(s),       2)];
                    end
                end
            end
            
            oefVec2 = [];
            tdVec2  = [];
            cVec2   = [];
            oefVec_ = {[] []};
            tdVec_   = {[] []};
            for s = 1:length(this.sessions)
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        oefVec2 = [oefVec2 oefStr(s).mapsHemis{h}];
                        tdVec2  = [ tdVec2  tdStr(s).mapsHemis{h}];
                        cVec2   = [  cVec2        s];
                    end
                    oefVec_{h} = [oefVec_{h} oefStr(s).mapsHemis{h}];
                    tdVec_{h}  = [tdVec_{h}    tStr(s).mapsHemis{h}];
                end
            end
            
            writetable(table(this.sessions', tdVec_{1}', oefVec_{1}', tdVec_{2}', oefVec_{2}'), 'plotOefIndex2ThicknessAlt2.xlsx');
            
            rng    = 0.7 < oefVec2 & oefVec2 < 1.6;
            fprintf('fitglmeOefIndex2ThicknessDiff2:  discarding %g hemispheres\n', length(oefVec2) - sum(rng)); % 2
            fprintf('fitglmeOefIndex2ThicknessDiff2:  discarding fraction %g of hemispheres\n', 1-sum(rng)/length(oefVec2)); % 0.0384615
            oefVec2 = oefVec2(rng)';
            tdVec2  = tdVec2(rng)';
            cVec2   = cVec2(rng)';
            age     = age(rng)';
            sex     = sex(rng)';
            assert(length(oefVec2) == length(tdVec2));
            assert(length(tdVec2)  == length(cVec2));
            assert(length(cVec2)   == length(age));
            assert(length(age)     == length(sex));
            this.scatter2(oefVec2, tdVec2, 'category', cVec2, 'size', 200);  
            tbl     = table(oefVec2, age, sex, cVec2, tdVec2);
            tbl.Properties.VariableNames = {'oef' 'age' 'sex' 'subj' 'thickd'};
            summary(tbl)
            mdl     = fitglme(tbl, this.model, 'Link', this.link, 'Distribution', this.distrib)
            save(sprintf('fitglmeOefIndex2Thickness2_glme_%s_%s.mat', this.territory, this.exclusionLabel)); 
        end   
        function fitglmeOefIndex2ThicknessDiff3(this)
            % plot patients ~30
            
            load(this.oefMat, 'oef*');
            load(this.tdMat, 't*');
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            subjectsSex = double(strcmp('Male', subjectsSex));
            age2 = ageAtPresentation';
            sex2 = subjectsSex';
            
            oefVec2 = [];
            tdVec2  = [];
            cVec2   = [];
            for s = 1:length(this.sessions)
                meanOef = [];
                meanTd  = [];
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        meanOef = [meanOef oefStr(s).mapsHemis{h}];
                        meanTd  = [meanTd   tdStr(s).mapsHemis{h}];                        
                    end
                end
                oefVec2 = [oefVec2 mean(meanOef)];
                tdVec2  = [tdVec2  mean(meanTd)];
                cVec2   = [cVec2   s];
            end
            rng = 0.7 < oefVec2 & oefVec2 < 1.6;
            fprintf('fitglmeOefIndex2ThicknessDiff3:  discarding %g patients\n', length(oefVec2) - sum(rng)); % 1
            fprintf('fitglmeOefIndex2ThicknessDiff3:  discarding fraction %g of patients\n', 1-sum(rng)/length(oefVec2)); % 0.033333
            oefVec2 = oefVec2(rng)';
            tdVec2  = tdVec2(rng)';
            cVec2   = cVec2(rng)';
            age2    = age2(rng)'; 
            sex2    = sex2(rng)';
            this.scatter2(oefVec2, tdVec2, 'category', cVec2, 'size', 400);  
            tbl     = table(oefVec2, age2, sex2, cVec2, tdVec2);
            tbl.Properties.VariableNames = {'oef' 'age' 'sex' 'subj' 'thickd'};
            summary(tbl)
            mdl     = fitglme(tbl, this.model, 'Link', this.link, 'Distribution', this.distrib)
            save(sprintf('fitglmeOefIndex2Thickness3_glme_%s_%s.mat', this.territory, this.exclusionLabel)); 
        end 
        
        function plotOefIndex2ThicknessDiff(this)
            % plot freesurfer regions ~2958
            load(this.oefMat, 'oef*');
            load(this.tdMat, 'td*');
            if (lexist(this.cMat, 'file'))
                load(this.cMat, 'c*');
            else
                cVec = this.categories;
            end
            rng = oefVec < 1.6;
            fprintf('plotOefIndex2ThicknessDiff:  discarding %g regions\n', length(oefVec) - sum(rng)); % 8
            fprintf('plotOefIndex2ThicknessDiff:  discarding fraction %g of regions\n', 1-sum(rng)/length(oefVec)); % 0.00270453
            x = oefVec(outliers);
            y = tdVec(outliers);
            this.scatter(oefVec(rng), tdVec(rng), 'category', cVec(rng)); 
            mdl = fitlm(x, y)         
        end    
        function plotOefIndex2ThicknessDiff_territory(this)
            % plot freesurfer regions ~2958, color by territory
            load(this.oefMat, 'oef*');
            load(this.tdMat, 'td*');
            this.territory = 'aca_mca_pca';
            if (lexist(this.cMat, 'file'))
                load(this.cMat, 'c*');
            else
                cVec = this.categories('territory');
            end
            rng = oefVec < 1.6;
            fprintf('plotOefIndex2ThicknessDiff:  discarding %g regions\n', length(oefVec) - sum(rng)); % 8
            fprintf('plotOefIndex2ThicknessDiff:  discarding fraction %g of regions\n', 1-sum(rng)/length(oefVec)); % 0.00270453
            this.scatter(oefVec(rng), tdVec(rng), 'category', cVec(rng));      
        end     
        function plotOefIndex2ThicknessDiff2(this)
            % plot hemispheres ~51
            
            load(this.oefMat, 'oef*');
            load(this.tdMat, 'td*');
            load(this.age_filename, 'ageAtPresentation');
            load(this.sex_filename, 'subjectsSex');
            
            oefVec2 = [];
            tdVec2  = [];
            cVec2   = [];
            for s = 1:length(this.sessions)
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        oefVec2 = [oefVec2 oefStr(s).mapsHemis{h} ];
                        tdVec2  = [ tdVec2  tdStr(s).mapsHemis{h} ];
                        cVec2   = [  cVec2        s];
                    end
                end
            end
            outliers = oefVec2 < 0.9;
            x = oefVec2(outliers);
            y = tdVec2(outliers);
            this.scatter2(oefVec2, tdVec2, 'category', cVec2, 'size', 200);  
            mdl = fitlm(x, y)    
        end   
        function plotOefIndex2ThicknessDiff3(this)
            % plot patients ~30
            
            load(this.oefMat, 'oef*');
            load(this.tdMat, 'td*');
            
            oefVec2 = [];
            tdVec2  = [];
            cVec2   = [];
            for s = 1:length(this.sessions)
                meanOef = [];
                meanTd  = [];
                for h = 1:2
                    if (~strcmp(this.exclusions{s}, this.theHemis{h}))
                        meanOef = [meanOef oefStr(s).mapsHemis{h}];
                        meanTd  = [meanTd   tdStr(s).mapsHemis{h}];
                        
                    end
                end
                oefVec2 = [oefVec2 mean(meanOef)];
                tdVec2  = [tdVec2  mean(meanTd)];
                cVec2   = [cVec2 s];
            end
            outliers = oefVec2 > 0.95 & oefVec2 < 1.2;
            x = oefVec2(outliers);
            y = tdVec2(outliers);
            this.scatter2(x, y, 'category', cVec2(outliers), 'size', 400);  
            mdl = fitlm(x, y)
        end 
        
        function inflatedViewThickness(~, varargin)
            % mm-01-{020, 028, 033}
            
            ip = inputParser;
            addParameter(ip, 'sessionPath', pwd, @isdir);
            addParameter(ip, 'hemis', 'lh', @ischar);
            parse(ip, varargin{:});
            h = ip.Results.hemis;
            
            pwd0 = pushd(ip.Results.sessionPath);
            mlbash(['freeview -f ' ...
                'surf/lh.inflated:overlay=lh.thickness:overlay_threshold=0.1,3::name=inflated_thickness_lh:visible=1 ' ...
                'surf/rh.inflated:overlay=rh.thickness:overlay_threshold=0.1,3::name=inflated_thickness_rh:visible=1 ' ...
                '--viewport 3d']);
            
            %mlbash(sprintf(['freeview -f ' ...
                %'surf/%s.inflated:overlay=%s.thickness:overlay_threshold=0.1,3::name=inflated_thickness:visible=1 ' ...
                %'--viewport 3d'], h, h, h, h));
            
                %'surf/%s.inflated:visible=0 ' ...
                %'surf/%s.pial:annot=aparc.annot:name=pial_aparc:visible=0 ' ...
                %'surf/%s.pial:annot=aparc.a2009s.annot:name=pial_aparc_des:visible=0 ' ...                
                %'surf/%s.white:visible=0 ' ...
                %'surf/%s.pial ' ...
                %, h, h, h
            popd(pwd0);
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

        function statsPrintf(this, stats, s, h)
            if (strcmp(this.territory, 'all_aca_mca') || strcmp(this.territory, 'mca_max'))
                fprintf('%s:  stats(%s, %s):  mean  %4.2f  std  %4.2f  max  %4.2f\n', ...
                    this.territory, this.sessions{s}, this.theHemis{h}, stats.mean, stats.std, stats.max);            
            end
        end
        function peaksPrintf(this, stats, s, h)
            if (strcmp(this.territory, 'all_aca_mca') || strcmp(this.territory, 'mca_max'))
                fprintf('%s:  stats(%s, %s):  mean  %4.2f  peak  %4.2f\n', ...
                    this.territory, this.sessions{s}, this.theHemis{h}, stats.mean, stats.peak);            
            end
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

