function [lowerBound, upperBound] = bhattacharyya_gaussian_error_bounds(bhattacharyyaDistance)
%BHATTACHARYYA_GAUSSIAN_ERROR_BOUNDS - Compute upper and lower bounds of
%classification error based on bhattacharyya distance
%     

%
%   Syntax:  [lowerBound, upperBound] = bhattacharryya_gaussian_bounds(bhattacharyyaDistance)
%
%   Inputs:
%       bhattacharyyaDistance - The bhattacharyya distance [positive scalar]
%
%   Outputs:
%       lowerBound - lower bound of classification error [scalar \in (0, 0.5)]
%       upperBound - upper bound of classification error [scalar \in (0, 0.5)]
%
%   References:
%     [1] K. Fukunaga, Introduction to Statistical Pattern Recognition, 2nd
%     ed. New York: Academic, 1990.
%     [2] T. Kailath, “The divergence and Bhattacharyya distance measures in
%     signal selection,” IEEE Trans. Commun. Technol., vol. CT-15, pp.
%     52–60, Jan. 1967.
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


lowerBound = 0.5 * (1 - sqrt(1 - exp(- 2 * bhattacharyyaDistance)));
upperBound = 0.5 * exp(-bhattacharyyaDistance);
