function p = parammvtpdf(X, mu, sigma, nu)
%PARAM_MVTPDF

cor = corrcov(sigma); %doesn't not need to be done as it it done in mvtpdf but just to make it obvious 
tranformed_X = (X-repmat(mu,size(X,1), 1))/sqrt(sigma);
p = mvtpdf(tranformed_X, cor, nu) / sqrt(det(sigma));


