function y = cdiff2(f, x)
h = eps( )^(1/4)*max(1, abs(x));
y =(f(x+h) - 2*f(x) + f(x-h)) ./ h.^2;
end
