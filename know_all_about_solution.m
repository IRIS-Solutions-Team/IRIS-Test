%% Model Solution Matrices
%
% Describe and retrieve the state-space form of a solved model. IRIS uses a
% state-space form with two modifications. First, the state-space system is
% transformed so that the transition matrix is upper triangular (or more
% precisely, quasi-triangular with 1-by-1 or 2-by-2 blocks on the main
% diagonal). Second, the effect of future anticipated shocks can be
% directly computed upon request, and added to the system stored in the
% model object.

%% Clear Workspace
%
% Clear workspace, close all graphics figures, clear command window, and
% check the IRIS version.

clear
close all
clc
irisrequired 20180131

%% Load Solved Model Object
%
% Load the solved model object built in <read_model.html read_model>.

load mat/read_model.mat m;

%% First Order Solution (State Space)
%
% The function |solve( )| executed earlier in <read_model.html read_model>
% computes the first-order accurate state-space representation of the
% model. IRIS uses a transformed representation that has a number of
% advantages.
%
% $$ [x^f_t;\alpha_t] = T \alpha_{t-1} 
% + K + R_1 e_t + R_2 \, \mathrm E_t \, [e_{t+1}] + \ldots $$
%
% $$ y_t = Z \alpha_t + D + H e_t $$
%
% $$ x^b_t = U \alpha_t $$
%
% $$ \mathrm E[ e_t e_t' ] = \Omega $$
%
% * $x^f$ non-predetermined (forward-looking) variables;
% * $x^b$ predetermined (backward-looking) transition variable;
% * $e$ residuals;
% * $y$ measurement variables;
% * $\alpha$ vector of transformed pre-determined variables;
% * $T$ transition matrix; the transformed vector $\alpha$ is set up so
% that $T$ is upper quasi-triangular -- see next section.
%

[T, R, K, Z, H, D, U, Omg] = sspace(m); %#ok<ASGLU>

disp('State-space matrices');

disp('Size of T');
sizeOfT = size(T) %#ok<NOPTS>

disp('Size of R');
sizeOfR = size(R) %#ok<NOPTS>

disp('Size of K');
size(K)

disp('Size of Z');
size(Z)

disp('Covariance matrix of residuals');
Omg %#ok<NOPTS>

%% Transition Matrix
%
% The transition matrix |T| can be divided into the upper part |Tf| (which
% determines the non-predetermined variables) and the square lower part
% |Ta| (which determines the vector alpha). The matrix |Tf| is in general
% rectangular, |nf|-by-|nb|, whereas |Ta| is a sqaure matrix, |nb|-by-|nb|.
% The dynamics of the model is solely given by |Ta|; the transformation
% |alpha| is chosen so that |Ta| is always upper quasi-triangular.
%
% The number of non-predetermined (forward-looking) variables and the number
% of predetermined (backward-looking) variables (which equals the size of
% the vector $\alpha$) can be derived from the size of the matrix |T|.

nx = size(T, 1);
nb = size(T, 2);
nf = nx - nb;

disp('Size of transition matrix T')
sizeOfT %#ok<NOPTS>

disp('Length of vector x')
nx %#ok<NOPTS>

disp('Length of vector xf')
nf %#ok<NOPTS>

disp('Length of vector xb (and alpha)')
nb %#ok<NOPTS>

Tf = T(1:nf, :);
Ta = T(nf+1:end, :);

figure();
spy(Ta);
title('Nonzero entries in lower transition matrix');

disp('Unit roots in model solution')
unitRoots = get(m, 'unitRoots') %#ok<NOPTS>

nUnit = length(unitRoots);
Ta(1:nUnit, 1:nUnit)

%% Variables in State Space Vector
%
% Find out the order in which the individual variables occur in the rows
% and columns of the state-space matrices. The vector of measurement
% variables and the vector of shocks are straightforward -- they are
% ordered as they are declared in the model code (with the measurement
% shocks preceding the transition shocks). The vector of transition
% variables contain also all auxiliary lags and leads.

disp('Vector of transition variables (x)')
xvector = get(m, 'XVector') %#ok<NOPTS>

disp('Vector of measurement variables (y)')
yvector = get(m, 'YVector') %#ok<NOPTS>

disp('Vector of shocks (e)')
evector = get(m, 'EVector') %#ok<NOPTS>

%% Forward Expansion of Model Solution
%
% Forward expansion of the solution is needed in simulations or forecasts
% with future anticipated shocks. Use the function |expand( )| to calculate
% and store the expansion in the model object. Alternatively, if not
% available, the expansion is automatically added whenever the functions
% |simulate( )| or |jforecast( )| are executed with future anticipated
% shocks.

k = get(m, 'forward');

disp('Solution is now expanded t+k periods forward')
k %#ok<NOPTS>

m = expand(m, 2);

disp('Solution is now expanded t+k periods forward')
k = get(m, 'Forward') %#ok<NOPTS>

[T, R, K, Z, H, D, U, Omg] = sspace(m);

disp('Size of the matrix R before expansion')
sizeOfR %#ok<NOPTS>

disp('Size of the matrix R after expansion')
size(R)

%% Show Variables and Objects Created in This File                         

whos

