function [X, Y] = gaussian_clusters(mus, sigmas, nPointsPerClusters, match)
%GAUSSIAN_CLUSTERS - Creates a dataset of point according to each mean and
%covariance
%
%   Syntax:  [X, Y] = gaussian_clusters(mus, sigmas, nPointsPerClusters, match)
%
%   Inputs:
%       mus - Means for each cluster [matrix (1 x nFeatures x nClusters)]
%       sigmas - Covariances for each clusters [matrix (nFeatures x nFeatures x nClusters)]
%       nPointsPerClusters - Number of point to generate per cluster
%       match - If true use mvnrnd2 (default) else use mvnrnd [boolean (Any non-zero value will be taken as 1)]
%
%   Outputs:
%       X - Observations [matrix (nPointsPerClusters * nClusters x nFeatures)]
%       Y - Labels number [vector (nPointsPerClusters * nClusters)]
%
%   Examples:
%       mus(1, :, 1) = [10, 10];
%       mus(1, :, 2) = [-10, -10];
%       sigmas(:, :, 1) = [2, 0; 0, 2];
%       sigmas(:, :, 2) = [5, 4; 4, 5];
%       [X, Y] = gaussian_clusters(mus, sigmas, 500);
%       scatter(X(:,1), X(:,2), 30, Y)
%
%   TODO:
%       Check Input Arguments
%
%   Other m-files required: mvnrnd2
%   MAT-files required: mvnrnd (requires the Statistics Toolbox)

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if nargin < 4
    match = true;
end

[~, nFeatures, nClusters] = size(mus);

X = zeros(nPointsPerClusters * nClusters, nFeatures);
Y = zeros(nPointsPerClusters * nClusters, 1);
for iCluster = 1:nClusters
    indices_start = nPointsPerClusters * (iCluster - 1);
    indices = (indices_start + 1) : (indices_start + nPointsPerClusters);
    mu = mus(1, :, iCluster);
    sigma = sigmas(:, :, iCluster);
    if match
        X(indices, :) = mvnrnd2(mu, sigma, nPointsPerClusters);
    else
        X(indices, :) = mvnrnd(mu, sigma, nPointsPerClusters);
    end
    Y(indices, 1) = iCluster;
end