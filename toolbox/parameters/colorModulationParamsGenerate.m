function colorModulationParams = colorModulationParamsGenerate(varargin)
% colorModulationParams = colorModulationParamsGenerate(varargin)
%
% Generate parameters for a color modulation.
%
% Key/value pairs
%   'modulationType' - String (default 'monitor') Type of color modulation
%     'monitor' - Specify properties of a modulatoin on a monitor
%     'AO' - Specify parameters of adaptive optics rig stimulus
%
% If modulationType is 'monitor', these are the parameters:
%   contrast - Contrast specfied relative to coneContrasts.
%              Can be a vector of contrasts.
%   coneContrasts - Color direction of grating in cone contrast space
%                   Can be a 3 by N matrix of contrast directions.
%
% If modulationType is 'AO', these are the parameters
%   spotWavelengthNm - Vector of wavelengths of light superimposed
%     in the background.
%   spotCornealPowerUW - Vector of corneal irradiance for
%     spot at full power, less any light leakage, units of UW/cm2.

% Parse input
p = inputParser; p.KeepUnmatched = true;
p.addParameter('modulationType','monitor',@ischar);
p.parse(varargin{:});

colorModulationParams.type = 'ColorModulation';
colorModulationParams.modulationType = p.Results.modulationType;

switch (colorModulationParams.modulationType )
    case 'monitor'
        colorModulationParams.contrast = 1;
        colorModulationParams.coneContrasts = [0.05 -0.05 0]';
        colorModulationParams.startWl = 380;
        colorModulationParams.endWl = 780;
        colorModulationParams.deltaWl = 4;
    case 'AO'
        colorModulationParams.startWl = 550;
        colorModulationParams.endWl = 830;
        colorModulationParams.deltaWl = 10;
        colorModulationParams.spotWavelengthNm = 680;
        colorModulationParams.spotCornealPowerUW = 20;
        colorModulationParams.contrast = 1;
    otherwise
        error('Unknown modulation type specified');
end


