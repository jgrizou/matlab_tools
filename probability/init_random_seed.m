function newSeed = init_random_seed(seed)
%INIT_RANDOM_SEED Initialize the shared random number stream
%used by rand, randi, and randn
%
%Note:
%RandStream.[get/set]DefaultStream is deprecated since version 7.12 and has been removed from version 8.1.
%Use RandStream.[get/set]GlobalStream instead.
%
%   Syntax: init_random_seed(seed)
%
%   Input:
%       seed (optional) - integer defining the seed of the random number generator
%       if not defined, use cpu time to define seed
%
%   Output:
%       newSeed - return the seed
%
%   Example:
%       init_random_seed(0)
%       rand(1,2)
%
%       ans =
%
%           0.8147    0.9058
%
%       init_random_seed(1)
%       rand(1,2)
%
%       ans =
%
%           0.4170    0.7203
%
%       init_random_seed(0)
%       rand(1,2)
%
%       ans =
%
%           0.8147    0.9058

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

vStr = version;
vNum = str2num(vStr(1));

if vNum < 8
    defaultStream = RandStream.getDefaultStream();
else
    %use rng if you have versio above 8
    defaultStream = RandStream.getGlobalStream();
end

if nargin == 0
    % Use time to define seed
    % Wait until the time changes enough to guarantee a unique seed for each call.
    seed0 = mod(floor(now*8640000),2^31-1); % traditionally this was sum(100*clock)
    for i = 1:100
        newSeed = mod(floor(now*8640000),2^31-1);
        if newSeed ~= seed0, break; end
        pause(.01); % smallest recommended interval
    end
else
   newSeed = seed; 
end

stream = RandStream(defaultStream.Type, 'Seed', newSeed);

if vNum < 8
    RandStream.setDefaultStream(stream);
else
    %use rng if you have versio above 8
    RandStream.setGlobalStream(stream);
end



