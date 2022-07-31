function [mu, sigma, nu, low, high] = xglogp(variant, varargin)

if numel(varargin)>=5
    high = varargin{5};
else
    high = 1;
end

if numel(varargin)>=4
    low = varargin{4};
else
    low = 0;
end

inxSwap = high<low;
if any(inxSwap(:))
    [low(inxSwap), high(inxSwap)] = deal(high(inxSwap), low(inxSwap));
end

if numel(varargin)>=3
    nu = varargin{3};
else
    nu = 0;
end

if numel(varargin)>=2
    sigma = abs(varargin{2});
else
    sigma = 1;
end

if isempty(varargin)
    mu = 0;
end

switch variant
    case 0
        if isempty(varargin)
            mu = 0;
        else
            mu = varargin{1};
        end
    case 1
        if isempty(varargin)
            y0 = 0.5;
        else
            y0 = varargin{1};
        end
        low = y0 + low;
        high = y0 + high;
        mu = sigma .* log( ((y0-low)./(high-low)) .^ (-1./exp(nu)) - 1 );
    otherwise
        error("Invalid parametrization variant for xglog.");
end

end%

