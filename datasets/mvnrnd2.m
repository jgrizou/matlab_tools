function r = mvnrnd2(mu,sigma,num,covnorm)
%MVNRND2 Random vectors from the multivariate normal distribution.
%   R = MVNRND2(MU,SIGMA,NUM) returns a NUM-by-D matrix R of multivariate
%   normal random vectors whose mean and covariance matrix match the given
%   input parameters, MU (1-D vector) and SIGMA (D-by-D matrix) 
%
%   [...] = MVNRND2(...,COVNORM) determines normalization for covariance
%           0 : Normalizes by NUM-1. This makes cov(R) the best unbiased 
%               estimate of the covariance matrix (Default)
%           1 : Normalizes by NUM and produces the second moment matrix of
%               the observations about their mean.
%
%   MU      :  Either a 1-by-D row vector, or a scalar across dimensions.
%   SIGMA   :  Either a D-by-D positive semi-definite matrix, or 
%              1-by-D row vector of a diagonal matrix, or 
%              scalar representing that value along the diagonal.
%   NUM     :  Positive integer at least D+1 in value.
%   COVNORM :  0 or 1 (Any non-zero value will be taken as 1)
%
%   Note: This is different from the MVNRND function in the Statistics
%   Toolbox, as that samples from a multivariate normal distribution with
%   mean MU and covariance SIGMA. The sampled mean and covariance may be
%   different from the given inputs. This functions finds a collection of 
%   multivariate normal random vectors whose mean and covariance
%   match the given input parameters, MU and SIGMA. 
%
%   Example 1:
%     Find 5 numbers from the univariate normal distribution that have
%     mean 50 and sample variance of 2. Show output and test output to
%     determine if answer is valid.
%       r=mvnrnd2(50,2,5), mean(r), cov(r)
%
%   Example 2:
%     Find 1000 bivariate normal random vectors with mean [1 2] and 
%     second-moment matrix of [2 .3; .3 2]. Test output to determine if 
%     answer is valid.
%        r=mvnrnd2([1 2],[2 .3; .3 2],1000,1); mean(r), cov(r,1)
%
%   Example 3:
%     Find 1e6 multivariate normal random vectors of dimension 5 with mean 
%     [5 -4 3 -2 1], with variances [1 2 3 4 5] and that are uncorrelated. 
%     Test output to determine if answer is valid.
%        r=mvnrnd2([5 -4 3 -2 1],[1 2 3 4 5],1e6); mean(r), cov(r)
%
%   Example 4:
%      (This example requires the Statistics Toolbox)
%      MVNRND in the Statistics Toolbox samples from a multivariate
%      distribution with the given input parameters. MVNRND2 finds
%      a collection of multivariate normal random vectors whose mean and
%      covariance match the given input parameters, MU and SIGMA. 
%      Show both results for the same input.
%         r=mvnrnd([0 -3],[2 .3; .3 1],10); mean(r), cov(r)
%         r2=mvnrnd2([0 -3],[2 .3; .3 1],10); mean(r2), cov(r2)
%

%   Mike Sheppard
%   MIT Lincoln Laboratory
%   michael.sheppard@ll.mit.edu
%   Last Modified: 9-Feb-2012


%%Check Input Arguments
%----------------------
if nargin < 2 || isempty(mu) || isempty(sigma)
    error(message('mvnrnd2:TooFewInputs'));
elseif ndims(mu) > 2
    error(message('mvnrnd2:BadMu'));
elseif ndims(sigma) > 2
    error(message('mvnrnd2:BadSigma'));
end
if nargin==2
    num=1;
    covnorm=false;
end
if nargin==3
    covnorm=false;
end
covnorm=(covnorm>0); %Turn into logical



%%Error Checking
%---------------
if ~isvector(mu)
    error('mvnrnd2:InputSizeMismatch',...
        'MU must be a row vector');
else
    mu=(mu(:))'; %row vector
end
[n,d] = size(mu);
if isscalar(sigma)
    %Assume scalar is same across diagonal
    sigma=sigma.*ones(n,d);
end
sz = size(sigma);
if sz(1)==1 && sz(2)>1
    % Just the diagonal of Sigma has been passed in.
    sz(1) = sz(2);
    sigma=diag(sigma);
end
%If mean vector is singular, assume across all dimensions
if isscalar(mu)
    mu=mu.*ones(1,sz(1));
    [n,d] = size(mu);
end
% Make sure sigma is the right size
if sz(1) ~= sz(2)
    error('mvnrnd2:BadCovariance',...
        'SIGMA must be a row vector or a square matrix.');
elseif ~isequal(sz, [d d])
    error('mvnrnd2:InputSizeMismatch',...
        ['SIGMA must be a square matrix with size equal to the '...
        'number of columns in MU, or a row vector with length '...
        'equal to the number of columns in MU, or a non-negative scalar.']);
end
if ~(all(isfinite(mu(:)))&&all(isfinite(sigma(:)))&&all(isfinite(num(:))))
   error('mvnrnd2:BadInput',...
   'Inputs must be numeric and finite');
end
%Check to see if symmetric positive semi-definite
sym_test=isequal(sigma,sigma.');
pos_semi_test=all(eig((sigma+sigma')/2)>=0);
if ~(sym_test&&pos_semi_test)
    error('mvnrnd2:BadCovariance',...
        'SIGMA must be a symmetric positive semi-definite matrix.');
end
%Make sure enough points to construct output
if num~=floor(num)
   error('mvnrnd2:BadNUM',...
    'NUM must integer valued');
end
if num<(d+1)
    error('mvnrnd2:BadNUM',...
        'NUM must be at least D+1 in number, one more than size of SIGMA, DxD');
end



%%Algorithm
%----------
if all(sigma(:)==0)
    %No variability, all outputs are the same
    z=repmat(mu,num,1);
else
    %Construct random unit normal variables to be rescaled to desired
    %sample mean and sample covariance
    z=randn(num,d);
    c1=chol(sigma);
    %In theory should only take one iteration, however due to numerical
    %round-off the process might need to be iterated a couple time for
    %accuracy.
    tol1=10*eps; error1=Inf; %Tolerance for mean
    tol2=10*eps; error2=Inf; %Tolerance for covariance
    count=1; maxcount=100;   %Maximum iterations
    while (error1>tol1)&&(error2>tol2)&&(count<maxcount)
        c2=chol(cov(z,covnorm)); 
        z=z*(c2\c1);                   %Normalize covariance
        z=bsxfun(@plus,z,-mean(z)+mu); %Normalize mean
        %Determine errors and increase count
        error1=norm(mean(z)-mu);
        error2=norm(cov(z,covnorm)-sigma);
        count=count+1;
    end
    
end

r=z; %return iterated computed values as output variable

end