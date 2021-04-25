
clear
% load gpm202008_model.mat m
% load gpm_model.mat m
% load gpm_model_2.mat m
load gpm_model_10.mat m

load gpm_smoothed_db_ngood.mat

d = fore.mean;
m = differentiate(m);

%{
d = steadydb(m, 1:40);
d.SHK_YY_EZ(1:4) = -6;
d.SHK_YY_US(1:4) = -6;
%}

for n = keys(d)
    if isa(d.(n), "tseries")
        d.(n) = Series(d.(n));
    end
end

startDate = qq(2020, 3);

shka = databank.filter(d, "Name", Rxp("^SHKA_.*"));
%{
shk = databank.filter(d, "Name", Rxp("^SHK_.*"));

dd = databank.copy(d, "SourceNames", shka);

d1 = databank.clip(d, -Inf, startDate);

names = databank.filter(d1, "ClassFilter", "Series");
names(startsWith(names, ["SHK_", "SHKA_"])) = [ ];
d1 = databank.apply(d1, @(x) fillMissing(x, -Inf:startDate+20+8, "previous"), "InputNames", names);
d1 = databank.copy(dd, "TargetDb", d1, "SourceNames", shka);

% m = setBounds(m, "RS_EZ", m.rs_floor_EZ, "RS_JP", m.rs_floor_JP);
%}

p = Plan.forModel(m, startDate+(0:20), "DefaultAnticipationStatus", false);
p = anticipate(p, true, shka);

shocks = databank.copy(d, "sourceNames", get(m, "eList"));
shocks = databank.clip(shocks, -Inf, startDate+3);
d = databank.copy(shocks, "sourceNames", get(m, "eList"), "targetDb", d);

disp Simulate==============

s1 = simulate(m, d, startDate+(0:20), "method", "stacked", "blocks", ~true ...
    , "solver", {"iris-newton", "skipJacobUpdate", 2, "functionTolerance", 1e-12, "functionNorm", Inf} ...
    , "initial", "firstOrder" ...
    , "plan", p ...
);
return

for k = 1 : 20
    d2 = databank.clip(d, -Inf, startDate+k);
    d2 = databank.copy(d2, "TargetDb", dd);

% s1 = databank.apply(s1, @(x) fillMissing(x, -Inf:startDate+k+20, "previous"), "InputNames", names);

    disp Simulate==============
    s2 = simulate(m, s1, startDate+k+(0:20-k), "method", "stacked", "blocks", ~true ...
        , "solver", {"iris-newton", "skipJacobUpdate", 2, "functionTolerance", 1e-10} ...
        , "initial", "data" ...
    );

    s1 = s2;
end
