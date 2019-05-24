function [residual, g1, g2, g3] = rbc0_static(y, x, params)
%
% Status : Computes static model for Dynare
%
% Inputs : 
%   y         [M_.endo_nbr by 1] double    vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1] double     vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1] double   vector of parameter values in declaration order
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the static model equations 
%                                          in order of declaration of the equations.
%                                          Dynare may prepend or append auxiliary equations, see M_.aux_vars
%   g1        [M_.endo_nbr by M_.endo_nbr] double    Jacobian matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%   g2        [M_.endo_nbr by (M_.endo_nbr)^2] double   Hessian matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%   g3        [M_.endo_nbr by (M_.endo_nbr)^3] double   Third derivatives matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

residual = zeros( 4, 1);

%
% Model equations
%

T11 = 1/y(1)*params(1);
T19 = params(4)*exp(y(4))*y(2)^(params(4)-1);
T22 = y(3)^(1-params(4));
T26 = 1+T19*T22-params(3);
T34 = y(2)^params(4);
T37 = y(3)^(-params(4));
lhs =1/y(1);
rhs =T11*T26;
residual(1)= lhs-rhs;
lhs =y(1)*params(2)/(1-y(3));
rhs =exp(y(4))*(1-params(4))*T34*T37;
residual(2)= lhs-rhs;
lhs =y(1)+y(2)-y(2)*(1-params(3));
rhs =T22*exp(y(4))*T34;
residual(3)= lhs-rhs;
lhs =y(4);
rhs =y(4)*params(5)+x(1);
residual(4)= lhs-rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
if nargout >= 2,
  g1 = zeros(4, 4);

  %
  % Jacobian matrix
  %

T63 = getPowerDeriv(y(2),params(4),1);
T71 = getPowerDeriv(y(3),1-params(4),1);
  g1(1,1)=(-1)/(y(1)*y(1))-T26*params(1)*(-1)/(y(1)*y(1));
  g1(1,2)=(-(T11*T22*params(4)*exp(y(4))*getPowerDeriv(y(2),params(4)-1,1)));
  g1(1,3)=(-(T11*T19*T71));
  g1(1,4)=(-(T11*T19*T22));
  g1(2,1)=params(2)/(1-y(3));
  g1(2,2)=(-(T37*exp(y(4))*(1-params(4))*T63));
  g1(2,3)=y(1)*params(2)/((1-y(3))*(1-y(3)))-exp(y(4))*(1-params(4))*T34*getPowerDeriv(y(3),(-params(4)),1);
  g1(2,4)=(-(exp(y(4))*(1-params(4))*T34*T37));
  g1(3,1)=1;
  g1(3,2)=1-(1-params(3))-T22*exp(y(4))*T63;
  g1(3,3)=(-(exp(y(4))*T34*T71));
  g1(3,4)=(-(T22*exp(y(4))*T34));
  g1(4,4)=1-params(5);
  if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
  end
if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],4,16);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],4,64);
end
end
end
end
