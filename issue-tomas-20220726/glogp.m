function [mu, sigma, nu, low, high] = glogp(varargin)

if nargin>=5
    high = varargin{5};
else
    high = 1;
end

if nargin>=4
    low = varargin{4};
else
    low = 0;
end

inxSwap = high<low;
if any(inxSwap(:))
    [low(inxSwap), high(inxSwap)] = deal(high(inxSwap), low(inxSwap));
end

if nargin>=3
    nu = varargin{3};
else
    nu = 0;
end

if nargin>=2
    sigma = abs(varargin{2});
else
    sigma = 1;
end

if nargin>=1
    mu = varargin{1};
else
    mu = 0;
end

end%

