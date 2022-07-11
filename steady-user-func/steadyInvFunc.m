function s = steadyInvFunc(s)

    % [k, gamma] -> [a, sigma, c, y]
    s.k = real(s.k);

    s.a = 1;
    s.sigma = 1 - s.k^(1-s.gamma) / s.a;
    s.c = s.sigma/(1 - s.sigma) * s.k;
    s.y = s.c + s.k;

    s.obs_k = s.k;
    s.obs_c = s.c;

end%

