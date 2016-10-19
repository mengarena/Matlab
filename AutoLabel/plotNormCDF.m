function plotNormCDF(u,s)
mu = u;
sigma = s;
x = (mu -  5*sigma) : (sigma / 100) : (mu + 5*sigma);
cdfNormal = normcdf(x, mu, sigma);
plot(x,cdfNormal)
end
