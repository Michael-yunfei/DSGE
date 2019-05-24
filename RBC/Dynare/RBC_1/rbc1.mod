%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic RBC Model 
%(Approximation in logs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------
% 0. Housekeeping (close all graphic windows)
%----------------------------------------------------------------

%clear all;
close all;
%clc;


%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var ly lc lk li lh ly_l lw Rk Rs Rf z;
varexo e;

parameters beta chi delta alpha rho;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
% 
% U(c,n) = log(c) + chi*log(1-n)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[param,ss] = calibration;

alpha = param(1);
beta = param(2);
delta = param(3);
chi = param(4);
 
rho     = 0.95;  
sigma   = 0.01;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model; 
  
  //Consumption Euler equation
  (1/exp(lc)) = beta*(1/exp(lc(+1)))*(1+alpha*(exp(lk)^(alpha-1))*exp(z(+1))*exp(lh(+1))^(1-alpha)-delta);

// Labor supply
 chi*exp(lc)/(1-exp(lh)) = exp(lw);

// Labor demand
 exp(lw) = exp(z)*(1-alpha)*exp(lk(-1))^alpha*exp(lh)^(-alpha);

//Resource constraint
  exp(lc)+exp(li) = exp(ly);

//Production function
  exp(ly) = exp(z)*(exp(lk(-1))^alpha)*(exp(lh))^(1-alpha);

//Capital accumulation equation
  exp(li) = exp(lk)-(1-delta)*exp(lk(-1));

//Labor productivity
  exp(ly_l) = exp(ly)/exp(lh);

//Stock return
 exp(Rs) = alpha*exp(ly)/exp(lk(-1))+1-delta;

//Capital rental rate
 exp(Rk) = alpha*exp(ly)/exp(lk(-1));

//Riskfree rate
 (1/exp(lc)) = beta*(1/exp(lc(+1)))*exp(Rf);

//TFP shock
  z = rho*z(-1)+e;

end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

initval;
  lk = log(ss(1));
  lc = log(ss(2));
  lh = log(ss(3));  
  li = log(ss(4));
  ly = log(ss(5));
  lw=log(ss(6));
  Rk=log(ss(7));
  Rs=log(ss(8));
  Rf=log(ss(9));
  ly_l = ly-lh;
  z = 0; 
end;

shocks;
var e = sigma^2;
end;

steady;

check;

stoch_simul(hp_filter = 1600, order = 1);

%----------------------------------------------------------------
% 5. Some Results
%----------------------------------------------------------------

statistic1 = 100*sqrt(diag(oo_.var(1:10,1:10)));
dyntable('standard deviations in %',strvcat('VARIABLE','REL. S.D.'),M_.endo_names(1:10,:),statistic1,10,8,2);

statistic2 = sqrt(diag(oo_.var(1:10,1:10)))/sqrt(diag(oo_.var(1,1)));
dyntable('Relative standard deviations in %',strvcat('VARIABLE','REL. S.D.'),M_.endo_names(1:10,:),statistic2,10,8,2);