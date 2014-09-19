function r = dirichletrnd(a, m)
%DIRICHLETRND
r = gamrnd(repmat(a,m,1),1,m,length(a));
r = r(:,1:end-1) ./ repmat(sum(r,2),1,length(a)-1);