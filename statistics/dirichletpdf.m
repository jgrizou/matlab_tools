function p = dirichletpdf(x, a)
%DIRICHLETPDF
t1 = gammaln(sum(a))-sum(gammaln(a));
t2 = sum((repmat(a(1:end-1)-1,size(x,1),1)).*log(x),2);
t3 = (a(end)-1).*log(1-sum(x,2));
p = exp(t1 + t2 + t3);