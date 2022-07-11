function s = steadyFunc(s)

    % [gamma, sigma] -> [a, k, c, y]

    s.a = 1;
    s.k = ( (1-s.sigma)*s.a )^(1/(1-s.gamma));
    s.c = s.sigma/(1 - s.sigma) * s.k;
    s.y = s.c + s.k;

    s.obs_k = s.k;
    s.obs_c = s.c;

end%

