function [errorEstimation] = bhattacharyya_gaussian_error_empirical(bhattacharyyaDistance)
%BHATTACHARYYA_GAUSSIAN_ERROR_EMPIRICAL - Estimate the classification error based on bhattacharyya distance
%
%   Syntax:  [errorEstimation] = bhattacharryya_gaussian_error_empirical(bhattacharyyaDistance)
%
%   Inputs:
%       bhattacharyyaDistance - The bhattacharyya distance [positive scalar]
%
%   Outputs:
%       errorEstimation - error estimation of classification error [scalar \in (0, 0.5)]
%
%   References:
%     [1] Chulhee Lee and Euisun Choi, “Bayes error evaluation of the gaussian ml classifier,” Geo-
%      science and Remote Sensing, IEEE Transactions on, vol. 38, no. 3, pp. 1471–1475, 2000.
% 
%   TODO:
%       Better doc of bhattacharyya
%       Add test
%       Add Examples

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if bhattacharyyaDistance < 3.095  && bhattacharyyaDistance > 0.03
    % from [1] this function is only valid for bhattacharyyaDistance < 3
    % from practiacal use, this function if also out of bound wrong close to 0
    % when out of bound we use the lower bound so the function look smooth, we use 3.095 to make a smoother function between 3 and 3.1
    errorEstimation = 40.219 - 70.019*bhattacharyyaDistance + 63.578*bhattacharyyaDistance^2 - ...
        32.766*bhattacharyyaDistance^3 + 8.7172*bhattacharyyaDistance^4 - 0.91875*bhattacharyyaDistance^5;
    errorEstimation = errorEstimation/100;
else % use the lower bound
    [errorEstimation, ~] = bhattacharyya_gaussian_error_bounds(bhattacharyyaDistance);
end