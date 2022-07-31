
function varargout = xglogc(variant, x, varargin)

if numel(varargin)>=1 && isequal(varargin{end}, 'diff')
    varargout = { true };
    return
end

if numel(varargin)>=2 && isequal(varargin{end-1}, 'diff')
    k = varargin{end};
    if ~isequal(k, 1)
        varargout = { NaN };
        return
    end
    dy = xglogd(variant, x, varargin{1:end-2});
    varargout = { dy };
    return
end

[mu, sigma, nu, low, high] = xglogp(variant, varargin{:});

nu1 = exp(nu);

z = (x - mu) ./ sigma;

y = (1 + exp(-z)) .^ (-nu1);

if any(low~=0) || any(high~=1)
    y = low + (high - low) .* y;
end

varargout = { y };

end%

