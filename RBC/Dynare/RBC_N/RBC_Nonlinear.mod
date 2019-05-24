% A Benchmark RBC model: Nonlinearized version
% Zhiwei Xu, Advanced Macro Topics, SJTU
%==========================================================================

var Ct Yt Kt Nt It Wt Rt At ; % define the varibles appear in dynamic system

%==========================================================================

varexo e_at; % define the exogenous technology shock

%==========================================================================
% initialize the deep parameters
% Since we will define original system in the "model" module, we have to define
% all the parameters presented in the model, even though some of them do not matter
% for the log-linearized system.

parameters alpha beta del rho_a sig_a n_ss an; 

alpha=.4; % capital share in production function
beta =.99;  % subjective discounting rate
del  =.025;  % depreciation rate
rho_a=.97; % AR(1) coefficient of production technolgoy process
sig_a=.0072; % standard error of the tech shock
n_ss = .33; % steady-state labor

% compute the accurate steady state according to the lecture notes
KY  = alpha*beta/(1-beta*(1-del));
IY  = del*KY;
CY  = 1-IY;
an  = (1-n_ss)/n_ss/CY*(1-alpha);
K_ss= (1/KY)^(1/(alpha-1))*n_ss;
Y_ss= K_ss/KY;
C_ss= Y_ss*CY;
I_ss= Y_ss*IY;
W_ss= (1-alpha)*Y_ss/n_ss;
R_ss= alpha*Y_ss/K_ss;

%==========================================================================

model; % declare the full dynamic system, here we define the non-linear system.
an/(1-exp(Nt))=1/exp(Ct)*exp(Wt); % labor market equilibrium

1/exp(Ct)=beta/exp(Ct(+1))*(exp(Rt(+1))+1-del); % Euler eqution for capital stock

exp(Ct)+exp(It)=exp(Yt); % resource constraint

exp(Kt)=(1-del)*exp(Kt(-1))+exp(It); % capital accumulation 

exp(Yt)=exp(At+alpha*Kt(-1)+(1-alpha)*Nt); % production function

exp(Wt) = (1-alpha)*exp(Yt-Nt);  % labor demand

exp(Rt) = alpha*exp(Yt-Kt(-1)); % capital demand

At=rho_a*At(-1)+e_at; %tech shock

end;

%==========================================================================
% Input the initial guess of steady-state. To guarantee that Dynare can solve the steady state,
% we simply set the initial guess of steady state to be the solution. Notice that variables we define
% in the "model" module are in the log form, therefore we need to take log on the steady state we compute
% in the "parameter" module.
initval;
Yt=log(Y_ss);
Ct=log(C_ss);
Kt=log(K_ss);
It=log(I_ss);
Nt=log(n_ss);
Wt=log(W_ss);
Rt=log(R_ss);
At=0;
end;

%==========================================================================
% declare the exogenous shock
shocks; 

var e_at; stderr sig_a; % define the std of A shock

end;

steady; % report the steady state, in log-linearized case, all variables are zero
check;  % compute the eigenvalues and check the Blanchard-Kahn condition
%==========================================================================

stoch_simul(periods=0,order=1,nograph,hp_filter=1600,irf=40,
            conditional_variance_decomposition=[1,4,8,12,40]); 

% some notes:
% hp_filter=1600,
% use first order Taylor expansion around the steady state
% calculate the HP-fiNtered theoretical moments
% plot 40 periods impulse response

% if you want get simulated data, say 10000, then set: periods=10000;
% if you do not want to show the figures, then set: nograph
% ...............................results, then set: noprint

% if you want to compute the conditional variance decomposition, then
% set: conditional_variance_decomposition=[1 4 8 16 40]
% note that to use this option, you have to set periods=0;

% for other options, please refer to the manual page 33-34

% when do conditional variance decomposition, you have to set periods=0;



% plot IRF
figure
subplot(4,2,1)
plot(1:40,Ct_e_at,'LineWidth',2);title('Ct');grid on; xlim([1,40])
subplot(4,2,2)
plot(1:40,It_e_at,'LineWidth',2);title('It');grid on; xlim([1,40])
subplot(4,2,3)
plot(1:40,Yt_e_at,'LineWidth',2);title('Yt');grid on; xlim([1,40])
subplot(4,2,4)
plot(1:40,Nt_e_at,'LineWidth',2);title('Nt');grid on; xlim([1,40])
subplot(4,2,5)
plot(1:40,Rt_e_at,'LineWidth',2);title('Rt');grid on; xlim([1,40])
subplot(4,2,6)
plot(1:40,Wt_e_at,'LineWidth',2);title('Wt');grid on; xlim([1,40])
subplot(4,2,7)
plot(1:40,Kt_e_at,'LineWidth',2);title('Kt');grid on; xlim([1,40])
subplot(4,2,8)
plot(1:40,At_e_at,'LineWidth',2);title('At');grid on; xlim([1,40])

% read the output
% Dynare saves all results in a mat file with name "rbc_results.mat"
% all outputs are saved in a struct variable oo_
  % simulated series are in "oo_endo_simul" and "oo_exo_simul"
  % coefficient matrices for decision rules are in "oo_.dr_ghx" and "oo_.dr_ghu"
  % to get the correct decision rule: you have to re-order
  %  oo_.dr.ghx(oo_.dr.inv_order_var,:)
  % impulse responses functions are in "oo_irfs"
  % var-cov matrix is in "oo_.autocorr"

%print -depsc2 RBC_Fig1.eps

%close all
delete *_dynamic.m
delete *_static.m
delete *_variables.m
%delete *_results.mat
delete RBC_Nonlinear.m
delete *.asv
delete *~
%rmdir('RBC_Nonlinear','s')