function [threshold,fitFractionCorrect,paramsValues] = singleThresholdExtraction(stimLevels,fractionCorrect,criterionFraction,numTrials,fitStimLevels)
% [threshold,fitFractionCorrect,paramsValues] = singleThresholdExtraction(stimLevels,fractionCorrect,criterionFraction,numTrials,fitStimLevels)
% 
% Fits a cumulative Weibull to the data variable and returns
% the threshold at the criterion as well as the parameters needed to plot the
% fitted curve. 
%
% Note that this function requires and makes use of Palamedes Toolbox 1.8
%
% Inputs:
%   stimLevels   -  A N-vector representing stimuli levels corresponding to the data.
%
%   fractionCorrect -  A N-vector of [0-1] fractions that represent performance on a task.
%
%   criterionFraction -  Fraction correct at which to find a threshold.
%
%   numTrials - Scalar, number of trials run for each stimulus level (assumed same for all levels).
%
% xd  6/21/16 wrote it

%% Set some parameters for the curve fitting
paramsFree     = [1 1 0 0];
numPos = round(numTrials*fractionCorrect);
outOfNum       = repmat(numTrials,1,length(fractionCorrect));
PF             = @PAL_Weibull;

%% Some optimization settings for the fit
options             = optimset('fminsearch');
options.TolFun      = 1e-09;
options.MaxFunEvals = 10000*100;
options.MaxIter     = 500*100;
options.Display     = 'off';

%% Fit the data to a curve
%
% Try starting the search at each stimulus level and keep the best.
for ii = 1:length(stimLevels)
    paramsEstimate = [stimLevels(ii) 2 0.5 0];
    [paramsValuesAll{ii},LLAll(ii)] = PAL_PFML_Fit(stimLevels(:), numPos(:), outOfNum(:), ...
        paramsEstimate, paramsFree, PF, 'SearchOptions', options);
    thresholdAll(ii) = PF(paramsValuesAll{ii}, criterionFraction, 'inverse');
end
[~,bestIndex] = max(LLAll);
bestII = bestIndex(1);
paramsValues = paramsValuesAll{bestII};
threshold = thresholdAll(bestII);

if (threshold > 1 | ~isreal(threshold) | isinf(threshold))
    threshold = NaN;
end
fitFractionCorrect = PF(paramsValues,fitStimLevels);

end

