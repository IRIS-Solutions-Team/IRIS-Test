function a = smax0(b,c)
  %a = max(b, 0);

  a = 0.5*(b + sabs(b,c));

    % a = b - (1/c);
    % inx = a<0;
    % if any(inx)
        % a(inx) = (1/c)*(exp(c*a(inx))-1);
    % end
    % a = a + (1/c);

end
