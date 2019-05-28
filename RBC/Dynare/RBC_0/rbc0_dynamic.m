function [residual, g1, g2, g3] = rbc0_dynamic(y, x, params, steady_state, it_)
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

residual = zeros(4, 1);
T13 = params(1)*1/y(7);
T21 = params(4)*exp(y(9))*y(4)^(params(4)-1);
T24 = y(8)^(1-params(4));
T28 = 1+T21*T24-params(3);
T40 = y(1)^params(4);
T43 = y(5)^(-params(4));
T51 = y(5)^(1-params(4));
lhs =1/y(3);
rhs =T13*T28;
residual(1)= lhs-rhs;
lhs =y(3)*params(2)/(1-y(5));
rhs =(1-params(4))*exp(y(6))*T40*T43;
residual(2)= lhs-rhs;
lhs =y(3)+y(4)-y(1)*(1-params(3));
rhs =exp(y(6))*T40*T51;
residual(3)= lhs-rhs;
lhs =y(6);
rhs =params(5)*y(2)+x(it_, 1);
residual(4)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(4, 10);

  %
  % Jacobian matrix
  %

T68 = getPowerDeriv(y(1),params(4),1);
  g1(1,3)=(-1)/(y(3)*y(3));
  g1(1,7)=(-(T28*params(1)*(-1)/(y(7)*y(7))));
  g1(1,4)=(-(T13*T24*params(4)*exp(y(9))*getPowerDeriv(y(4),params(4)-1,1)));
  g1(1,8)=(-(T13*T21*getPowerDeriv(y(8),1-params(4),1)));
  g1(1,9)=(-(T13*T21*T24));
  g1(2,3)=params(2)/(1-y(5));
  g1(2,1)=(-(T43*(1-params(4))*exp(y(6))*T68));
  g1(2,5)=y(3)*params(2)/((1-y(5))*(1-y(5)))-(1-params(4))*exp(y(6))*T40*getPowerDeriv(y(5),(-params(4)),1);
  g1(2,6)=(-((1-params(4))*exp(y(6))*T40*T43));
  g1(3,3)=1;
  g1(3,1)=(-(1-params(3)))-T51*exp(y(6))*T68;
  g1(3,4)=1;
  g1(3,5)=(-(exp(y(6))*T40*getPowerDeriv(y(5),1-params(4),1)));
  g1(3,6)=(-(exp(y(6))*T40*T51));
  g1(4,2)=(-params(5));
  g1(4,6)=1;
  g1(4,10)=(-1);

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],4,100);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],4,1000);
end
end
end
end
