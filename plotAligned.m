
function varargout = plotAligned(range, lhs, rhs, alignAround)
    yyaxis left
    hl = plot(range, lhs);
    al = gca();
    local_resetVerticalLimits(al, alignAround);
    grid on

    yyaxis right
    hr = plot(range, rhs);
    ar = gca();
    local_resetVerticalLimits(ar, alignAround);
    grid on

    if nargout>0
        varargout = {hl, hr, al, ar};
    end
end%


function local_resetVerticalLimits(a, alignAround)
    yLim = get(a, 'yLim');
    halfHeight = max(abs(yLim - alignAround));
    set(a, 'yLim', [alignAround-halfHeight, alignAround+halfHeight], 'yLimMode', 'manual');
end%

