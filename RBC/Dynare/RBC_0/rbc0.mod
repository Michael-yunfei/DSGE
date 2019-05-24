% Basic RBC Model 
% Linearization in level
%
% 
%----------------------------------------------------------------
% 0. Housekeeping (close all graphic windows)
%----------------------------------------------------------------

close all;


%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var c k n z;
varexo e;

parameters beta chi delta alpha rho;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
% 
% U(c,n) = log(c) + chi*log(1-n)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%load parameterfile
%set_param_value('rho',rho)

alpha   = 0.33;
beta    = 0.99;
delta   = 0.023;
chi     = 1.75;  
sigma   = 0.01;
rho     =0.95;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model; 
//(1) Euler equation
  (1/c) = beta*(1/c(+1))*(1+alpha*exp(z(+1))*k^(alpha-1)*n(+1)^(1-alpha)-delta);
//(2) Consumption/leisure choice 
 chi*c/(1-n) = exp(z)*(1-alpha)*k(-1)^alpha*n^(-alpha);
//(3) Resource constraint
   c +k - (1-delta)*k(-1) = exp(z)*k(-1)^alpha*n^(1-alpha); 
//(4) Technology shock
  z = rho*z(-1)+e;
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
  k = 9;
  c = 0.76;
  n = 0.3;
  z = 0; 
  e = 0;
end;

shocks;
var e = sigma^2;
end;

steady;

check;

stoch_simul(hp_filter = 1600);

%----------------------------------------------------------------
% 5. Some Results
%----------------------------------------------------------------

%statistic1 = 100*sqrt(diag(oo_.var(1:6,1:6)))./oo_.mean(1:6);
%dyntable('Relative standard deviations in %',strvcat('VARIABLE','REL. S.D.'),M_.endo_names(1:6,:),statistic1,10,8,4);
