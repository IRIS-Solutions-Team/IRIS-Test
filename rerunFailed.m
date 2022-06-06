function out = rerunFailed(in)

fileNames = string.empty(1, 0);
for test = reshape(in([in.Failed]), 1, []);
    fileNames(end+1) = string(test.Details.DiagnosticRecord.Stack(end).file);
end

fileNames = unique(fileNames, "stable");
out = [];
for n = fileNames
    out = [out, runtests(n)];
end

end%

