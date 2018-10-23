
%% Test spy on All Frequencies

data = rand(40, 10);
n = numel(data);
pos = randi(n, 1, ceil(n/10));
data(pos) = NaN;

freq = enumeration('Frequency');
freq = freq(~isnan(freq));
for i = 1 : numel(freq)
    start = numeric.datecode(freq(i), 2000);
    x = Series(start, data);
    figure('Visible', 'Off');
    spy(x);
end

close all

