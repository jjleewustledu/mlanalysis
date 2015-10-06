% +MLANALYSIS
%
% Files
%   AnalysisBuilder                 - is a builder design pattern for imaging analysis objects%  Version $Revision$ was created $Date$ by $Author$,  
%   AnalysisDirector                - works with a builder design pattern for data analysis%  Version $Revision$ was created $Date$ by $Author$,  
%   ControlsThicknessTerritoriesGlm - performs GLM to regress thicknesses, averaged over vascular territories, 
%   DipInterface                    - 
%   DsaGlmDirector                  - implements builder/director design patterns to do GLM analysis
%   GlmDirector                     - is the concrete component in a decorator design pattern;
%   GlmDirectorComponent            - 
%   GlmDirectorDecorator            - maintains a reference to a component object,
%   MinimalDsaGlmDirector           - 
%   MoyamoyaPaper                   - 
%   Np755GlmDirector                - aggregates imaging data from study np755 for GLM:  dsa, thickness, diffusion, bolus-tracking, O15-PET.
%   Np755GlmDirectorComponent       - 
%   Np755GlmDirectorDecorator       - maintains a reference to a component object,
%   NumericalInterface              - facilitates overriding Matlab numerical operators using bsxfun

%   PetAnalysisDirector             - director to an analysis builder design pattern
%   Reporter                        - accumulates string-data
%   SummaryTable                    - is a builder pattern for reporting results
%   TerritoryGlmDirector            - averages freesurfer ROIs into territories for use with GLM director classes
%   ThicknessGlmDirector            - implements decorator design patterns for GLM analysis
%   ThicknessTerritoriesGlm         - performs GLM to regress thicknesses, averaged over vascular territories, onto predictors
