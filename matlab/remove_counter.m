function remove_counter(cnt, maxCnt)

if nargin == 2
    nDigits = ceil(log10(max(1,abs(maxCnt)+1)));
    nErase = 2*nDigits + 1;
else
    nDigits = ceil(log10(max(1,abs(cnt)+1)));
    nErase = nDigits;
end

for i = 1:nErase+1 % there is one space added on purpose
    fprintf('\b')
end