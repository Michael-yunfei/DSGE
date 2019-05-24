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

T65 = params(1)*(-1)/(y(7)*y(7));
T68 = getPowerDeriv(y(1),params(4),1);
T77 = params(4)*exp(y(9))*getPowerDeriv(y(4),params(4)-1,1);
T78 = T24*T77;
T84 = getPowerDeriv(y(5),(-params(4)),1);
T87 = getPowerDeriv(y(5),1-params(4),1);
T90 = getPowerDeriv(y(8),1-params(4),1);
T91 = T21*T90;
  g1(1,3)=(-1)/(y(3)*y(3));
  g1(1,7)=(-(T28*T65));
  g1(1,4)=(-(T13*T78));
  g1(1,8)=(-(T13*T91));
  g1(1,9)=(-(T13*T21*T24));
  g1(2,3)=params(2)/(1-y(5));
  g1(2,1)=(-(T43*(1-params(4))*exp(y(6))*T68));
  g1(2,5)=y(3)*params(2)/((1-y(5))*(1-y(5)))-(1-params(4))*exp(y(6))*T40*T84;
  g1(2,6)=(-((1-params(4))*exp(y(6))*T40*T43));
  g1(3,3)=1;
  g1(3,1)=(-(1-params(3)))-T51*exp(y(6))*T68;
  g1(3,4)=1;
  g1(3,5)=(-(exp(y(6))*T40*T87));
  g1(3,6)=(-(exp(y(6))*T40*T51));
  g1(4,2)=(-params(5));
  g1(4,6)=1;
  g1(4,10)=(-1);

if nargout >= 3,
  %
  % Hessian matrix
  %

  v2 = zeros(37,3);
T128 = getPowerDeriv(y(1),params(4),2);
  v2(1,1)=1;
  v2(1,2)=23;
  v2(1,3)=(y(3)+y(3))/(y(3)*y(3)*y(3)*y(3));
  v2(2,1)=1;
  v2(2,2)=67;
  v2(2,3)=(-(T28*params(1)*(y(7)+y(7))/(y(7)*y(7)*y(7)*y(7))));
  v2(3,1)=1;
  v2(3,2)=37;
  v2(3,3)=(-(T65*T78));
  v2(4,1)=1;
  v2(4,2)=64;
  v2(4,3)=  v2(3,3);
  v2(5,1)=1;
  v2(5,2)=34;
  v2(5,3)=(-(T13*T24*params(4)*exp(y(9))*getPowerDeriv(y(4),params(4)-1,2)));
  v2(6,1)=1;
  v2(6,2)=77;
  v2(6,3)=(-(T65*T91));
  v2(7,1)=1;
  v2(7,2)=68;
  v2(7,3)=  v2(6,3);
  v2(8,1)=1;
  v2(8,2)=74;
  v2(8,3)=(-(T13*T77*T90));
  v2(9,1)=1;
  v2(9,2)=38;
  v2(9,3)=  v2(8,3);
  v2(10,1)=1;
  v2(10,2)=78;
  v2(10,3)=(-(T13*T21*getPowerDeriv(y(8),1-params(4),2)));
  v2(11,1)=1;
  v2(11,2)=87;
  v2(11,3)=(-(T21*T24*T65));
  v2(12,1)=1;
  v2(12,2)=69;
  v2(12,3)=  v2(11,3);
  v2(13,1)=1;
  v2(13,2)=84;
  v2(13,3)=(-(T13*T78));
  v2(14,1)=1;
  v2(14,2)=39;
  v2(14,3)=  v2(13,3);
  v2(15,1)=1;
  v2(15,2)=88;
  v2(15,3)=(-(T13*T91));
  v2(16,1)=1;
  v2(16,2)=79;
  v2(16,3)=  v2(15,3);
  v2(17,1)=1;
  v2(17,2)=89;
  v2(17,3)=(-(T13*T21*T24));
  v2(18,1)=2;
  v2(18,2)=1;
  v2(18,3)=(-(T43*(1-params(4))*exp(y(6))*T128));
  v2(19,1)=2;
  v2(19,2)=43;
  v2(19,3)=params(2)/((1-y(5))*(1-y(5)));
  v2(20,1)=2;
  v2(20,2)=25;
  v2(20,3)=  v2(19,3);
  v2(21,1)=2;
  v2(21,2)=41;
  v2(21,3)=(-((1-params(4))*exp(y(6))*T68*T84));
  v2(22,1)=2;
  v2(22,2)=5;
  v2(22,3)=  v2(21,3);
  v2(23,1)=2;
  v2(23,2)=45;
  v2(23,3)=(-(y(3)*params(2)*((-(1-y(5)))-(1-y(5)))))/((1-y(5))*(1-y(5))*(1-y(5))*(1-y(5)))-(1-params(4))*exp(y(6))*T40*getPowerDeriv(y(5),(-params(4)),2);
  v2(24,1)=2;
  v2(24,2)=51;
  v2(24,3)=(-(T43*(1-params(4))*exp(y(6))*T68));
  v2(25,1)=2;
  v2(25,2)=6;
  v2(25,3)=  v2(24,3);
  v2(26,1)=2;
  v2(26,2)=55;
  v2(26,3)=(-((1-params(4))*exp(y(6))*T40*T84));
  v2(27,1)=2;
  v2(27,2)=46;
  v2(27,3)=  v2(26,3);
  v2(28,1)=2;
  v2(28,2)=56;
  v2(28,3)=(-((1-params(4))*exp(y(6))*T40*T43));
  v2(29,1)=3;
  v2(29,2)=1;
  v2(29,3)=(-(T51*exp(y(6))*T128));
  v2(30,1)=3;
  v2(30,2)=41;
  v2(30,3)=(-(exp(y(6))*T68*T87));
  v2(31,1)=3;
  v2(31,2)=5;
  v2(31,3)=  v2(30,3);
  v2(32,1)=3;
  v2(32,2)=45;
  v2(32,3)=(-(exp(y(6))*T40*getPowerDeriv(y(5),1-params(4),2)));
  v2(33,1)=3;
  v2(33,2)=51;
  v2(33,3)=(-(T51*exp(y(6))*T68));
  v2(34,1)=3;
  v2(34,2)=6;
  v2(34,3)=  v2(33,3);
  v2(35,1)=3;
  v2(35,2)=55;
  v2(35,3)=(-(exp(y(6))*T40*T87));
  v2(36,1)=3;
  v2(36,2)=46;
  v2(36,3)=  v2(35,3);
  v2(37,1)=3;
  v2(37,2)=56;
  v2(37,3)=(-(exp(y(6))*T40*T51));
  g2 = sparse(v2(:,1),v2(:,2),v2(:,3),4,100);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],4,1000);
end
end
end
end
