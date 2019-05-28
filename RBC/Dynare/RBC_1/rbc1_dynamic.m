function [residual, g1, g2, g3] = rbc1_dynamic(y, x, params, steady_state, it_)
%
% Status : Computes dynamic model for Dynare
%
% Inputs :
%   y         [#dynamic variables by 1] double    vector of endogenous variables in the order stored
%                                                 in M_.lead_lag_incidence; see the Manual
%   x         [nperiods by M_.exo_nbr] double     matrix of exogenous variables (in declaration order)
%                                                 for all simulation periods
%   steady_state  [M_.endo_nbr by 1] double       vector of steady state values
%   params    [M_.param_nbr by 1] double          vector of parameter values in declaration order
%   it_       scalar double                       time period for exogenous variables for which to evaluate the model
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the dynamic model equations in order of 
%                                          declaration of the equations.
%                                          Dynare may prepend auxiliary equations, see M_.aux_vars
%   g1        [M_.endo_nbr by #dynamic variables] double    Jacobian matrix of the dynamic model equations;
%                                                           rows: equations in order of declaration
%                                                           columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g2        [M_.endo_nbr by (#dynamic variables)^2] double   Hessian matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g3        [M_.endo_nbr by (#dynamic variables)^3] double   Third order derivative matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

%
% Model equations
%

residual = zeros(11, 1);
T15 = params(1)*1/exp(y(14));
T24 = params(4)*exp(y(5))^(params(4)-1)*exp(y(16));
T28 = exp(y(15))^(1-params(4));
T32 = 1+T24*T28-params(3);
T49 = exp(y(1))^params(4);
T52 = exp(y(7))^(-params(4));
T62 = exp(y(7))^(1-params(4));
T76 = params(4)*exp(y(3))/exp(y(1));
lhs =1/exp(y(4));
rhs =T15*T32;
residual(1)= lhs-rhs;
lhs =exp(y(4))*params(2)/(1-exp(y(7)));
rhs =exp(y(9));
residual(2)= lhs-rhs;
lhs =exp(y(9));
rhs =(1-params(4))*exp(y(13))*T49*T52;
residual(3)= lhs-rhs;
lhs =exp(y(4))+exp(y(6));
rhs =exp(y(3));
residual(4)= lhs-rhs;
lhs =exp(y(3));
rhs =exp(y(13))*T49*T62;
residual(5)= lhs-rhs;
lhs =exp(y(6));
rhs =exp(y(5))-exp(y(1))*(1-params(3));
residual(6)= lhs-rhs;
lhs =exp(y(8));
rhs =exp(y(3))/exp(y(7));
residual(7)= lhs-rhs;
lhs =exp(y(11));
rhs =1+T76-params(3);
residual(8)= lhs-rhs;
lhs =exp(y(10));
rhs =T76;
residual(9)= lhs-rhs;
lhs =1/exp(y(4));
rhs =T15*exp(y(12));
residual(10)= lhs-rhs;
lhs =y(13);
rhs =params(5)*y(2)+x(it_, 1);
residual(11)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(11, 17);

  %
  % Jacobian matrix
  %

T108 = exp(y(1))*getPowerDeriv(exp(y(1)),params(4),1);
T120 = (-((-(exp(y(1))*params(4)*exp(y(3))))/(exp(y(1))*exp(y(1)))));
  g1(1,4)=(-exp(y(4)))/(exp(y(4))*exp(y(4)));
  g1(1,14)=(-(T32*params(1)*(-exp(y(14)))/(exp(y(14))*exp(y(14)))));
  g1(1,5)=(-(T15*T28*exp(y(16))*params(4)*exp(y(5))*getPowerDeriv(exp(y(5)),params(4)-1,1)));
  g1(1,15)=(-(T15*T24*exp(y(15))*getPowerDeriv(exp(y(15)),1-params(4),1)));
  g1(1,16)=(-(T15*T24*T28));
  g1(2,4)=exp(y(4))*params(2)/(1-exp(y(7)));
  g1(2,7)=(-(exp(y(4))*params(2)*(-exp(y(7)))))/((1-exp(y(7)))*(1-exp(y(7))));
  g1(2,9)=(-exp(y(9)));
  g1(3,1)=(-(T52*(1-params(4))*exp(y(13))*T108));
  g1(3,7)=(-((1-params(4))*exp(y(13))*T49*exp(y(7))*getPowerDeriv(exp(y(7)),(-params(4)),1)));
  g1(3,9)=exp(y(9));
  g1(3,13)=(-((1-params(4))*exp(y(13))*T49*T52));
  g1(4,3)=(-exp(y(3)));
  g1(4,4)=exp(y(4));
  g1(4,6)=exp(y(6));
  g1(5,3)=exp(y(3));
  g1(5,1)=(-(T62*exp(y(13))*T108));
  g1(5,7)=(-(exp(y(13))*T49*exp(y(7))*getPowerDeriv(exp(y(7)),1-params(4),1)));
  g1(5,13)=(-(exp(y(13))*T49*T62));
  g1(6,1)=exp(y(1))*(1-params(3));
  g1(6,5)=(-exp(y(5)));
  g1(6,6)=exp(y(6));
  g1(7,3)=(-(exp(y(3))/exp(y(7))));
  g1(7,7)=(-((-(exp(y(7))*exp(y(3))))/(exp(y(7))*exp(y(7)))));
  g1(7,8)=exp(y(8));
  g1(8,3)=(-T76);
  g1(8,1)=T120;
  g1(8,11)=exp(y(11));
  g1(9,3)=(-T76);
  g1(9,1)=T120;
  g1(9,10)=exp(y(10));
  g1(10,4)=(-exp(y(4)))/(exp(y(4))*exp(y(4)));
  g1(10,14)=(-(exp(y(12))*params(1)*(-exp(y(14)))/(exp(y(14))*exp(y(14)))));
  g1(10,12)=(-(T15*exp(y(12))));
  g1(11,2)=(-params(5));
  g1(11,13)=1;
  g1(11,17)=(-1);

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],11,289);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],11,4913);
end
end
end
end
