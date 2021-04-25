clear all; close all
%m = Model('newHC4iris4.txt', 'Growth', true);
%m = Model('newHC4iris4_exDemA.txt', 'Growth', true);% funkcni T verze
%m = Model('block_27.txt', 'Growth', true);% funkcni T verze
p = struct;
%% first round
p.xN=1.5;2;1.5;
p.xPB=-0.07;0.037;10*0.0089;
p.c=0.2;0.53;0.7;0.75;
p.xFCV2MV=0.93;0.89;

%param;

%p.N = 1.5;2;1.5;
%p.PWORLD = 1;
%p.OW = 1;
%p.AT = 1;

m = Model('block_27.model', 'Growth', true,'assign',p);% funkcni T verze
%m = Model('core.txt', 'Growth', true);

%$$$$$
m.ONVSHR = 0.4;

%$$$$$
m=steady( ...
    m,'saveas','blocs.txt','fixlevel',{} ...
    , 'exogenize', {'ONVSHR'}, 'endogenize', {'AON2'} ...
);
chksstate(m); 
m=solve(m);

%% second round

p.xN = real(m.N);
p.c=1/(1+real(m.OG)/real(m.OT));
p.xPB = real(m.NOBSHR) + real(m.GTRNFSHR);
p.xFCV2MV=real(m.GDPFCV)/real(m.GDPMV);
p.LAMT=0.03;
p.dotPWORLD_SS = 0.07;

%param

m = Model('block_27.model', 'Growth', true,'assign',p);% funkcni T verze
%m = Model('core.txt', 'Growth', true);

%$$$$$
m.ONVSHR = 0.4;

%$$$$$
m=steady( ...
    m,'saveas','blocs.txt','fixlevel',{} ...
    , 'exogenize', {'ONVSHR'}, 'endogenize', {'AON2'} ...
);
chksstate(m); 
m=solve(m);

%% Shocks
% 1. ON
dd=sstatedb(m, 1:10);
%%%%%!!!!!dd.SHK_ON=0.01;
dd.SHK_ON(1)=0.01;
s=simulate(m,dd,1:50);
[s.ON, dd.ON s.ON-dd.ON]

return

%% 2. OT
dd=sstatedb(m, 1:10);
%%%%%!!!!!dd.SHK_OT=0.01;
dd.SHK_OT(1)=0.01;
s=simulate(m,dd,1:50);
[s.OT dd.OT s.OT-dd.OT]



return
%%
%% reporting of the sttate for shares
listVar = get(m,'xnames');

a = contains(listVar,'SHR');
list = listVar(a);
    
fid=fopen('shares.txt','w')
fprintf('%15s %10s\n','Variable', 'SSTATE')

for ii=1:length(list)

fprintf('%15s %10.2f\n',list{ii}, m.(list{ii}))

end

fprintf('%15s %10.2f\n','UR', m.UR)
fprintf('%15s %10.2f\n','N1659SHRN', m.N1659SHRN_SS)
fprintf('%15s %10.2f\n','NGE60SHRN', m.NGE60SHRN_SS)
fprintf('%15s %10.2f\n','LFPR', m.LFPR/100)
fprintf('%15s %10.2f\n','LGSHRN', m.LGSHRN_SS)
fprintf('%15s %10.2f\n','OGNWVSHR', m.OGNWVSHR_SS)
fprintf('%15s %10.2f\n','GENWSHR', m.GENWSHR_SS)
fprintf('%15s %10.2f\n','IHGVSHR', m.IHGVSHR_SS)
fprintf('%15s %10.2f\n','GTRABRSHR', m.GTRABRSHR_SS)
fprintf('%15s %10.2f\n','BPTRNESHR', m.BPTRNESHR_SS)
fprintf('%15s %10.2f\n','GREVABRSHR', m.GREVABRSHR_SS)
fprintf('%15s %10.2f\n','GTTISHR', m.GTTISHR_SS)
fprintf('%15s %10.2f\n','GKRESTSHR', m.GKRESTSHR_SS)
fprintf('%15s %10.2f\n','YFNPOSHR', m.YFNPOSHR_SS)
fprintf('%15s %10.2f\n','DSVSHRT', m.DSVSHRT_SS)

fclose(fid);
%%
fprintf('%15s\n','Most Important Calibrated Steady States');

fprintf('%15s %10s %10s\n','Variable', '_SS', 'SSTATE')

list={'CONSVSHR','GVSHR','ITVSHR','INVSHR','IGVSHR','IHPVSHR','IHGVSHR','DSVSHR',...
    'NTSVSHR','UR','GBORPSHR','GNDTSHR','BPSHR','ONVSHR','LNSHR'};

for ii=1:length(list)

fprintf('%15s %10.2f %10.2f\n',list{ii}, m.([list{ii} '_SS']),m.(list{ii}));

end

%%
fprintf('\n');

fprintf('%15s\n','Other Important Not-Calibrated Steady States');

fprintf('%15s %10s\n','Variable',  'Value')

list={'LFPR','RGTYPEX','RGDI','LGSHRN_SS','ACONS2','DEPT','DEPN','DSVSHR','BPTRNESHR','AON2','AN','AWT1'};

for ii=1:length(list)

fprintf('%15s %10.2f\n',list{ii},m.(list{ii}));

end

%return
%%

fprintf('%15s\n','All Steady States');

fprintf('%15s %10s %10s\n','Variable', '_SS', 'SSTATE')

list=get(m,'pNames');
ind=contains(list,'_SS');   
ind=find(ind);
for ii=ind

fprintf('%15s %10.2f %10.2f\n',list{ii}(1:end-3), m.(list{ii}),m.(list{ii}(1:end-3)));

end


return
%% Calibration
% Targets
t=struct();
t.CONSVSHR=0.65;
t.NPOBSHR = 0.02;
t.GNDTSHR=1.00;
t.OTVSHR=0.77;
t.LTSHR = 0.6;
t.OTSHR = 0.7;
t.NTSVSHR=-0.37;
t.GVSHR = 0.28;
t.DSVSHR = 0.04;
t.UR= 0.31;


o=struct();

%% Step 1
% Assumptions:
auxlist={'YFNPOSHR_SS','YCTREPSHR_SS','BPTRNESHR_SS','YCUSHR_SS','xGVSHR',...
        'DEPSHR_SS','GREVOSHR_SS','GREVABRSHR_SS','GTYCSHR_SS','GKREVSHR_SS','GTRKTSHR_SS','GKRESTSHR_SS'};
for ii=1:length(auxlist)
m.(auxlist{ii})=m.(auxlist{ii});
end
% Targeted values:
m.xCONSVSHR=t.CONSVSHR;
m.xPB = t.NPOBSHR;

%Outputs:
m.ACONS2=dbeval(m,'xCONSVSHR/(1+YFNPOSHR_SS-YCTREPSHR_SS+BPTRNESHR_SS-YCUSHR_SS-xGVSHR-xPB-DEPSHR_SS+GREVOSHR_SS+GREVABRSHR_SS+GTYCSHR_SS+GKREVSHR_SS-GTRKTSHR_SS-GKRESTSHR_SS)');
o.ACONS2=m.ACONS2;

%% Step 2 
% Assumptions
auxlist={'RIGV','IHGVSHR_SS','RISMGV'};
for ii=1:length(auxlist)
m.(auxlist{ii})=m.(auxlist{ii});
end
% Targeted values:
m.xD=t.GNDTSHR;

%outputs
m.xGBORPSHR = dbeval(m,'-(xPB-RIGV-IHGVSHR_SS-RISMGV)');
m.RGDI= log(dbeval(m,'((exp(LAMT+LAMT))-(xGBORPSHR)*exp(LAMT+LAMT)/xD)*100'));
o.RGDI=m.RGDI;

%% Step 3
% Assumptions
auxlist={'BETAT','ALPHAT','APOT1','APIT1','APIT2','DEPT','RRSAT','AWT4'};
for ii=1:length(auxlist)
m.(auxlist{ii})=m.(auxlist{ii});
end
% Target values:
m.xOTVSHR=t.OTVSHR;
m.xLTSHR = t.LTSHR;
m.OTSHR = t.OTSHR;

c=m.OTSHR;% but in loop with a through Y/L. We should reverse engineer through various SHR assumptions%approximation of otvshr through LG shr: 1-LGSHRN_SS*N1659SHRN_SS*1.5;%N=1.5;
a=c*m.APIT2+1-m.APIT2;
mju=exp(m.APOT1);
lambda=exp(m.APIT1)/(mju^(1-m.APIT2));
gamma=m.AWT4;

% Outputs:
m.xLSHRT=dbeval(m,'(1/xOTVSHR-1)/(1/xLTSHR-1)');
omega=dbeval(m,'(xLSHRT/(BETAT/(ALPHAT*lambda*(DEPT+RRSAT/100)))^(BETAT*(gamma-1)/(1-gamma*a*BETAT)))^(1/((1-a*BETAT)/(1-gamma*a*BETAT)))');
m.AWT1=log(m.omega);
o.AWT1=m.AWT1;

%% Step 4
% Assumptions:

% Target Values:
m.xNTSVSHR=t.NTSVSHR;
m.xGVSHR = t.GVSHR;
m.DSVSHR = t.DSVSHR;

%Outputs
m.DSVSHRT_SS=dbeval(m,'DSVSHR/xOTVSHR');
m.xIVSHR=dbeval(m,'1-xCONSVSHR-xGVSHR-DSVSHR-xNTSVSHR');
o.DSVSHRT_SS=m.DSVSHRT_SS;

%% Step 5
% Assumptions
auxlist={'RIGV','AIHP1','GTESHR_SS','GSUBSHR_SS'};
for ii=1:length(auxlist)
m.(auxlist{ii})=m.(auxlist{ii});
end
% Target values:
m.xIVSHR;

% Outputs:
m.xFCV2MV=dbeval(m,'(1-GTESHR_SS*xCONSVSHR)/(1-GSUBSHR_SS)');
m.xITVSHRT=dbeval(m,'(xIVSHR-(RIGV+AIHP1))/(xOTVSHR*xFCV2MV)');
aux=dbeval(m,'BETAT*(gamma*(1-a)+gamma*a*ALPHAT)/(1-gamma*a*BETAT)');
aux2= dbeval(m,'(xITVSHRT3/(lambda^(1-ALPHAT-aux)*omega^(1-a+a*ALPHAT+a*aux)*(BETAT/ALPHAT)^(ALPHAT+aux)))^(1/(-ALPHAT-aux))');
m.DEPT=aux2-m.RRSAT/100;       
o.DEPT=m.DEPT;

%% Step 6
% Assumptions
auxlist={'LFPR','N','N1659SHRN_SS','xY'};
for ii=1:length(auxlist)
m.(auxlist{ii})=m.(auxlist{ii});
end
% Target values:
m.xUR=t.UR;

% Outputs
m.xY2L=dbeval(m,'omega^(a*BETAT/(1-gamma*a*BETAT))*(BETAT/ALPHAT)^(BETAT/(1-gamma*a*BETAT))*(lambda*(DEPT+RRSAT/100))^(-BETAT/(1-gamma*a*BETAT))');
m.LGSHRN_SS=dbeval(m,'(1-xY/(N1659SHRN_SS*xN*LFPR/100)*(xY2L)^(-1)-xUR)*(LFPR/100)');
% or
m.xY=dbeval(m,'(N1659SHRN_SS*xN*LFPR/100)*(1-LGSHRN_SS/(LFPR/100)-xUR)/(xY2L)^(-1)');
m.AOT1=log(m.xY)
o.LGSHRN_SS=m.LGSHRN_SS;
o.AOT1 = m.AOT1;
%% Check
param;

p.N = 1.5;2;1.5;
p.PWORLD = 1;
p.OW = 1;
p.AT = 1;

list=fieldnames(o);
for ii=1:length(list)
    p.(list{ii})=o.(list{ii});
end

m = Model('block_27.txt', 'Growth', true,'assign',p);% funkcni T verze
%m = Model('core.txt', 'Growth', true);
m=steady(m,'saveas','blocs.txt','fixlevel',{});
chksstate(m); 
m=solve(m);

%% reporting of the sttate for shares
listVar = get(m,'xnames');

a = contains(listVar,'SHR');
list = listVar(a);
    
fid=fopen('shares.txt','w')
fprintf('%15s %10s\n','Variable', 'SSTATE')

for ii=1:length(list)

fprintf('%15s %10.2f\n',list{ii}, m.(list{ii}))

end

fprintf('%15s %10.2f\n','UR', m.UR)
fprintf('%15s %10.2f\n','N1659SHRN', m.N1659SHRN_SS)
fprintf('%15s %10.2f\n','NGE60SHRN', m.NGE60SHRN_SS)
fprintf('%15s %10.2f\n','LFPR', m.LFPR/100)
fprintf('%15s %10.2f\n','LGSHRN', m.LGSHRN_SS)
fprintf('%15s %10.2f\n','OGNWVSHR', m.OGNWVSHR_SS)
fprintf('%15s %10.2f\n','GENWSHR', m.GENWSHR_SS)
fprintf('%15s %10.2f\n','IHGVSHR', m.IHGVSHR_SS)
fprintf('%15s %10.2f\n','GTRABRSHR', m.GTRABRSHR_SS)
fprintf('%15s %10.2f\n','BPTRNESHR', m.BPTRNESHR_SS)
fprintf('%15s %10.2f\n','GREVABRSHR', m.GREVABRSHR_SS)
fprintf('%15s %10.2f\n','GTTISHR', m.GTTISHR_SS)
fprintf('%15s %10.2f\n','GKRESTSHR', m.GKRESTSHR_SS)
fprintf('%15s %10.2f\n','YFNPOSHR', m.YFNPOSHR_SS)
fprintf('%15s %10.2f\n','DSVSHRT', m.DSVSHRT_SS)

fclose(fid);

%% report analytical predictions

listpred={   'xY', 'OT',...         
            'xN','N',...
            'xLSHRT','LSHRT',...
            'xY2L','LPRT',...
            'xPIT','PIT',...
            'xPOT','POT',...
            'xWT','WT',...
            'xPK','PKT',...
            'xW2PK','RFPT',...
            'xITVSHRT','ITVSHRT',...
            'xY2K','OT/IT',...
            'xLTSHR','LTSHR',...
            'xOTVSHR','OTVSHR',...
            'xUR','UR',...
            'xPB','NOBSHR+GTRNFSHR',...
            'xIVSHR','IVSHR'...
            'xGVSHR','GVSHR'...
            'xCONSVSHR','CONSVSHR'...
            'xFCV2MV','GDPFCV/GDPMV'...
            'xNTSVSHR','NTSVSHR'...
            'xD','GNDTSHR'};
%         'c','1/(1+real(m.OG)/real(m.OT))',...
%            'xITVSHRT2','ITVSHRT',...
fprintf('%10s %10s %10s %10s\n','Predictor','Pred Value', 'Var Value','Variable')

for ii=1:2:length(listpred)
aux=dbeval(m,['real(' listpred{ii+1} ')'] );
fprintf('%10s %10.2f %10.2f %10s\n',listpred{ii}, m.(listpred{ii}),aux,listpred{ii+1})
    
end

fprintf('\n')
tlist=fieldnames(t);
fprintf('%10s %10s %10s\n','Variable','Target','Actual')

for ii=1:length(tlist)
fprintf('%10s %10.2f %10.2f\n',tlist{ii}, t.(tlist{ii}),m.(tlist{ii}))
end


return
%% Try Calculate Steady State
m=steady(m,'saveas','blocs.txt','fixlevel',{});
%m=steady(m,'saveas','blocs.txt','fixlevel',{'GTRNF','ST','WG'});%,'fixlevel',{'POG','YFNPO'})
chksstate(m); 
m=solve(m);
return
% logList = split(fileread('logs.txt'));
% logList(startsWith(logList, '%')) = [ ];
% m = changeLogStatus(m, true, logList);
% m = steady(m, 'SaveAs', 'blazer.model');
m.YFNPO = 0.5; %to have remittances positive and in logs
%m.YFNPOSHR = 0.5592;
m.GTRNF = 0.2; %to have remittances positive and in logs
%m.BPRESR =1; % to make CA (BPR) reasonable (in % of GDPMV)
m.NGE60=0.13;% to fix positive NLE15
m.N=5;% to fix positive NLE15
m.N1659=2.8; % to fix positive unemployment
%m.KT = 30; % needed for some stupid numerics
%m.KN=10;
m.ST = 0.1; %to be reasonable
m.GKREST = 0.1; % to be reasonable
m.BPRESSHR = 10/100; % to be reasonable
m.GTTI=.1; %to be reasonable
%m.LG=0.01; % to be in proportion to other sectors
%m.PWORLD = 0.57;
%m.GNP =4.1136
m.OW=1;
%m.GKREV=0.1;% to be reasonable
%m.POG=1;
%m.IHGV=0.1;
m.GTYSIW=0.06;
m.GTYPER=0.03;
m.GTRABR=0.06;
m.GTRN = 0.13;
m.YPO=0.23;
m.GTYP=0.5;
m.GTYSIB=0.5;
m.GTYC=0.5;
m.GTY=1.5;
m.OGNW=0.1;
m.GTRN=0.01;
m.PWORLD=1;
%m.WN=1;
m.WG=1;
m.AT=0.5;
%m=steady(m,'saveas','blocs.txt','fixlevel',{'GTRNF','ST'})
%chksstate(m);
m.WG=1;
m.WT=1;
m.RIGV=0.01;
m.APIN1=0;
m.AIHP1=0.05;0.03;
m.N=1;
m.AT=3;3;0.5;
%m.AN=4;7;
%m.DELN=0.8;
m.DELT=0.3;0.2;0.8;
%m.POG=m.PON;
m.AWT1=0.7;
%m.IN=2;
m=steady(m,'saveas','blocs.txt','fixlevel',{});
%m=steady(m,'saveas','blocs.txt','fixlevel',{'GTRNF','ST','WG'});%,'fixlevel',{'POG','YFNPO'})
chksstate(m); 
m=solve(m);
return
m.LG=0.1; % homotopy
m.GREVABR=0.1; % to be reasonable
%m.GTRABR=0.1;0.5; %homotopy
m.GTTI=0.1 % homotopy
%m.AIONC = 0.38; %needed for homothopy convergence
%m.AIONG = 0.07;%needed for homothopy convergence
%m.AOT1 = log(423298);
m.BPTRNE=0.1; % st small and reasonable
m.OA=0.1; % st small and reasonable
%m.LA=0.1;% st small and reasonable
m.KA=2;% st small and reasonable
m.RGENW=0.1;%st small and reasonable
m.OGNW=0.1;%st small and reasonable
m=steady(m,'saveas','blocs.txt','fixlevel',{'GTRNF','ST'});%,'fixlevel',{'YFNPO'})
chksstate(m); 
m=solve(m);
get(m,'sstate')

% reporting of the sttate for shares
listVar = get(m,'xnames');

a = contains(listVar,'SHR');
list = listVar(a);
    
fid=fopen('shares.txt','w')
fprintf('%15s %10s\n','Variable', 'SSTATE')

for ii=1:length(list)

fprintf('%15s %10.2f\n',list{ii}, m.(list{ii}))

end

fclose(fid);
return
%% how far sstate from data
% d = databank.fromCSV('HC4.csv');
% d=dbload('HC4.csv');
% list=get(m,'xnames') - {'AT','ISHRT','CONSHR','DSSHR'};
% fprintf('%15s %10s\n','Variable', 'Difference')
% for ii=1:length(list);
%     fprintf('%15s %10.2f\n',[list{ii}], (d.(list{ii})(yy(1998))-m.(list{ii}))/d.(list{ii})(yy(1998)))
% end
%% simulation
d=dbload('newHC4.csv');
list=get(m,'required');
d.AT=tseries;
sdate=yy(2000);
 d.AT(yy(1995):sdate)=real(m.AT);
 d.BPRESSHR=tseries;
 d.BPRESSHR(yy(1995):sdate)=real(m.BPRESSHR);
 d.GTRNF=tseries;
 d.GTRNF(yy(1995):sdate)=real(m.GTRNF);
 d.GREVABR=tseries;
 d.GREVABR(yy(1995):sdate)=real(m.GREVABR);
 d.IHGV=tseries;
 d.IHGV(yy(1995):sdate)=real(m.IHGV);
dd=d;
% for ii=1:length(list)
%     dd.([list{ii}(5:end-5) ])=tseries;
%    
%     %dd.([list{ii}(5:end-5) ])(yy(1998))=real(m.([list{ii}(5:end-5)]));
% dd.([list{ii}(5:end-5) ])(yy(1998))=d.([list{ii}(5:end-5) ])(yy(1998))/d.([list{ii}(5:end-5) ])(yy(1995));
% end
 %d=zerodb(m,yy(1998));
 %d=sstatedb(m,yy(1998))+d;
%d=sstatedb(m,yy(1990):yy(1999));
s=simulate(m,dd,sdate:yy(2005));
return
%% Run Block-Recursive Analysis (Separately from Steady State)

blazer(m, 'SaveAs', 'blocks.txt');


%% Try Run a Simulation 

d = databank.fromCSV('HC4.csv')


s = simulate(m, d, yy(1999):yy(2003), ...
    'PrependInput', true, ...
    'Method', 'Period', ...
    'Solver', {'IRIS-Newton', 'MaxFunctionEvaluations', 100000, 'MaxIterations', 100000} ...
);
%%
list=get(m,'xnames');
fprintf('%15s %10s\n','Variable', 'Value')
for ii=1:length(list)
b.(['dot_' list{ii}])=100*(s.(list{ii})/s.(list{ii}){-1}-1);
fprintf('%15s %10.2f\n',['dot_' list{ii}], b.(['dot_' list{ii}])(yy(1999)))
end
return
%%
% LHS minus RHS in 1999
discrepancy1999 = lhsmrhs(m, d, yy(1999));
equations = string(get(m, 'Equations'));

% Sort in descending order
[discrepancy1999, sort] = sort(abs(discrepancy1999), 'descend');
equations = equations(sort);

% Print table
t = table(discrepancy1999, equations)

% Write to XLSX file
writetable(t, 'Discrepancy1999.xlsx');

%%
return
list=list-{'COFIN','DSA','GNF','IGVCSF','IGVCSFDP','IGVCSFEC'}
for ii=2:length(list)
if d.(list{ii})(yy(1998))==0
    d.(list{ii})=m.(list{ii});
else
    d.(list{ii})=d.(list{ii})/d.(list{ii})(yy(1998)); 
end
end
% list=get(m,'xnames');%{'WTDOT'  'NTSVR' 'WNDOT' 'WNADOT' 'GNPDOT' 'BPR'};
% for ii=1:length(list)
%     d.(list{ii})=tseries;
%     d.(list{ii})=m.(list{ii}); 
% end

