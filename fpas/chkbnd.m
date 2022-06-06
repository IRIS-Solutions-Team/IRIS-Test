function res = chkbnd(x,low,high)
    if any(x < low) || any(x > high)
        res = inf;
    else
        res = 0;
    end
end
