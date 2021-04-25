function a = smax0(b,c)

    a = b;
    inx = a<0;
    a(inx) = c * a(inx);

    % c = 0.01;





  % %a = max(b, 0);
  % % a = b;
  % % return
% % 
% 
% if nargin==2
    % %a = 0.5*(b + sabs(b,c));
    % a = max(b, 0);
    % return
% end
% 
% if nargin==3
    % a = true;
    % return
% end
% 
  % a = ones(size(b));
  % inx = b<0;
  % a(inx) = 0.05;
% 
% 
    % % a = b - (1/c);
    % % inx = a<0;
    % % if any(inx)
        % % a(inx) = (1/c)*(exp(c*a(inx))-1);
    % % end
    % % a = a + (1/c);

end
