function [opts] = optss()
clear opts
opts.mu = 2^12;
opts.beta = 2^6;
opts.mu0 = 2^4;                      % trigger continuation shceme
opts.beta0 = 2^-2;                   % trigger continuation shceme
opts.maxcnt = 10;
opts.tol_inn = 1e-3;
opts.tol = 1E-3;                      %change ie-6 to ie-3
opts.maxit = 300;                     %change 300 to 80
end

