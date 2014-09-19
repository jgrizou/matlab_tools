function add_counter(cnt, maxCnt)

if nargin == 2
    nDigits = ceil(log10(max(1,abs(maxCnt)+1)));
    str = ['%', num2str(nDigits), 'd/%', num2str(nDigits), 'd ']; % there is one space in the end on purpose
    fprintf(str, cnt, maxCnt);
else
    nDigits = ceil(log10(max(1,abs(cnt)+1)));
    str = ['%', num2str(nDigits), 'd ']; % there is one space in the end on purpose
    fprintf(str, cnt);
end

