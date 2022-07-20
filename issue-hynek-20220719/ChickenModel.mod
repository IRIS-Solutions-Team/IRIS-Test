!variables
C
I
Y
K
N
W
PrK
A
Lamda

!parameters
Beta
Gamma
Sigma
Delta
rho
dA_ss


!shocks
epsilon_dA

!equations 

N = 1;

Lamda = C^(-Sigma);

Lamda = Beta*Lamda{+1}*[(1-Delta)+PrK{+1}];

%C+I = N*W +PrK*K{-1};
K = (1-Delta)*K{-1}+I;

Y = (A*N)^Gamma*K{-1}^(1-Gamma);

Gamma*Y = W*N;

(1-Gamma)*Y = PrK*K{-1};

log(A/A{-1})= rho*log(A{-1}/A{-2})+(1-rho)*log(dA_ss)+epsilon_dA;

Y = C+I;

!log_variables

C
I
Y
K
N
W
PrK
A
Lamda




