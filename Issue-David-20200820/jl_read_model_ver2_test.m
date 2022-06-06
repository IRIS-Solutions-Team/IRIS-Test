

%% Test

close
clear all
%m = Model('newHC4iris4.txt', 'Growth', true);
%m = Model('newHC4iris4_exDemA.txt', 'Growth', true);% funkcni T verze
%m = Model('block_27.txt', 'Growth', true);% funkcni T verze
p = struct();

% first round
p.xN=1.5;2;1.5;
p.xPB=-0.07;0.037;10*0.0089;
p.c=0.2;0.53;0.7;0.75;
p.xFCV2MV=0.93;0.89;

%param;

%p.N = 1.5;2;1.5;
%p.PWORLD = 1;
%p.OW = 1;
%p.AT = 1;

m = Model.fromFile('block_27.model', 'Growth', true,'assign',p);% funkcni T verze
%m = Model('core.txt', 'Growth', true);

%$$$$$
m.ONVSHR = 0.4;

%$$$$$
m=steady( ...
    m,'saveas','blocs.txt','fixlevel',{} ...
    , 'exogenize', {'ONVSHR'}, 'endogenize', {'AON2'} ...
);
checkSteady(m); 
m=solve(m);

% second round

p.xN = real(m.N);
p.c=1/(1+real(m.OG)/real(m.OT));
p.xPB = real(m.NOBSHR) + real(m.GTRNFSHR);
p.xFCV2MV=real(m.GDPFCV)/real(m.GDPMV);
p.LAMT=0.03;
p.dotPWORLD_SS = 0.07;

%param

m = Model.fromFile('block_27.model', 'Growth', true,'assign',p);% funkcni T verze
%m = Model('core.txt', 'Growth', true);

%$$$$$
m.ONVSHR = 0.4;

%$$$$$
m=steady( ...
    m,'saveas','blocs.txt','fixlevel',{} ...
    , 'exogenize', {'ONVSHR'}, 'endogenize', {'AON2'} ...
);
checkSteady(m); 
m=solve(m);

% Shocks
% 1. ON
dd=steadydb(m, 1:10);
%%%%%!!!!!dd.SHK_ON=0.01;
dd.SHK_ON(1)=0.01;
s=simulate(m,dd,1:50);
%[s.ON, dd.ON s.ON-dd.ON]


% 2. OT
dd=steadydb(m, 1:10);
%%%%%!!!!!dd.SHK_OT=0.01;
dd.SHK_OT(1)=0.01;
s=simulate(m,dd,1:50);
%[s.OT dd.OT s.OT-dd.OT]


