function [residual, g1, g2, g3] = rbc1_static(y, x, params)
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

residual = zeros( 11, 1);

%
% Model equations
%

T12 = 1/exp(y(2))*params(1);
T21 = params(4)*exp(y(3))^(params(4)-1)*exp(y(11));
T25 = exp(y(5))^(1-params(4));
T29 = 1+T21*T25-params(3);
T40 = exp(y(3))^params(4);
T43 = exp(y(5))^(-params(4));
T66 = params(4)*exp(y(1))/exp(y(3));
lhs =1/exp(y(2));
rhs =T12*T29;
residual(1)= lhs-rhs;
lhs =exp(y(2))*params(2)/(1-exp(y(5)));
rhs =exp(y(7));
residual(2)= lhs-rhs;
lhs =exp(y(7));
rhs =exp(y(11))*(1-params(4))*T40*T43;
residual(3)= lhs-rhs;
lhs =exp(y(2))+exp(y(4));
rhs =exp(y(1));
residual(4)= lhs-rhs;
lhs =exp(y(1));
rhs =T25*exp(y(11))*T40;
residual(5)= lhs-rhs;
lhs =exp(y(4));
rhs =exp(y(3))-exp(y(3))*(1-params(3));
residual(6)= lhs-rhs;
lhs =exp(y(6));
rhs =exp(y(1))/exp(y(5));
residual(7)= lhs-rhs;
lhs =exp(y(9));
rhs =1+T66-params(3);
residual(8)= lhs-rhs;
lhs =exp(y(8));
rhs =T66;
residual(9)= lhs-rhs;
lhs =1/exp(y(2));
rhs =T12*exp(y(10));
residual(10)= lhs-rhs;
lhs =y(11);
rhs =y(11)*params(5)+x(1);
residual(11)= lhs-rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
if nargout >= 2,
  g1 = zeros(11, 11);

  %
  % Jacobian matrix
  %

T87 = (-exp(y(2)))/(exp(y(2))*exp(y(2)));
T101 = exp(y(3))*getPowerDeriv(exp(y(3)),params(4),1);
T113 = (-((-(exp(y(3))*params(4)*exp(y(1))))/(exp(y(3))*exp(y(3)))));
T115 = exp(y(5))*getPowerDeriv(exp(y(5)),1-params(4),1);
  g1(1,2)=T87-T29*params(1)*T87;
  g1(1,3)=(-(T12*T25*exp(y(11))*params(4)*exp(y(3))*getPowerDeriv(exp(y(3)),params(4)-1,1)));
  g1(1,5)=(-(T12*T21*T115));
  g1(1,11)=(-(T12*T21*T25));
  g1(2,2)=exp(y(2))*params(2)/(1-exp(y(5)));
  g1(2,5)=(-(exp(y(2))*params(2)*(-exp(y(5)))))/((1-exp(y(5)))*(1-exp(y(5))));
  g1(2,7)=(-exp(y(7)));
  g1(3,3)=(-(T43*exp(y(11))*(1-params(4))*T101));
  g1(3,5)=(-(exp(y(11))*(1-params(4))*T40*exp(y(5))*getPowerDeriv(exp(y(5)),(-params(4)),1)));
  g1(3,7)=exp(y(7));
  g1(3,11)=(-(exp(y(11))*(1-params(4))*T40*T43));
  g1(4,1)=(-exp(y(1)));
  g1(4,2)=exp(y(2));
  g1(4,4)=exp(y(4));
  g1(5,1)=exp(y(1));
  g1(5,3)=(-(T25*exp(y(11))*T101));
  g1(5,5)=(-(exp(y(11))*T40*T115));
  g1(5,11)=(-(T25*exp(y(11))*T40));
  g1(6,3)=(-(exp(y(3))-exp(y(3))*(1-params(3))));
  g1(6,4)=exp(y(4));
  g1(7,1)=(-(exp(y(1))/exp(y(5))));
  g1(7,5)=(-((-(exp(y(5))*exp(y(1))))/(exp(y(5))*exp(y(5)))));
  g1(7,6)=exp(y(6));
  g1(8,1)=(-T66);
  g1(8,3)=T113;
  g1(8,9)=exp(y(9));
  g1(9,1)=(-T66);
  g1(9,3)=T113;
  g1(9,8)=exp(y(8));
  g1(10,2)=T87-exp(y(10))*params(1)*T87;
  g1(10,10)=(-(T12*exp(y(10))));
  g1(11,11)=1-params(5);
  if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
  end
if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],11,121);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],11,1331);
end
end
end
end
