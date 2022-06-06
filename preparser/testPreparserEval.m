

%% Test

clear

s = struct( );
for i = 1 : 1000
    name = extractAfter(tempname('.'), 2);
    s.(name) = rand;
end

p = parser.Preparser();

names = keys(s);
numNames = numel(names);
expn = repmat("", 1, 1000);
for i = 1 : numel(expn)
    expn(i) = names(randi(numNames)) + "+" + names(randi(numNames));
end

z = nan(1, numel(expn));
for i= 1 : numel(expn)
    z(i) = parser.Preparser.eval(expn(i), s, p);
end
