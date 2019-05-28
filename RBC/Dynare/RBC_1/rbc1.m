%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

if isoctave || matlab_ver_less_than('8.6')
    clear all
else
    clearvars -global
    clear_persistent_variables(fileparts(which('dynare')), false)
end
tic0 = tic;
% Save empty dates and dseries objects in memory.
dates('initialize');
dseries('initialize');
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'rbc1';
M_.dynare_version = '4.5.6';
oo_.dynare_version = '4.5.6';
options_.dynare_version = '4.5.6';
%
% Some global variables initialization
%
global_initialization;
diary off;
diary('rbc1.log');
M_.exo_names = 'e';
M_.exo_names_tex = 'e';
M_.exo_names_long = 'e';
M_.endo_names = 'ly';
M_.endo_names_tex = 'ly';
M_.endo_names_long = 'ly';
M_.endo_names = char(M_.endo_names, 'lc');
M_.endo_names_tex = char(M_.endo_names_tex, 'lc');
M_.endo_names_long = char(M_.endo_names_long, 'lc');
M_.endo_names = char(M_.endo_names, 'lk');
M_.endo_names_tex = char(M_.endo_names_tex, 'lk');
M_.endo_names_long = char(M_.endo_names_long, 'lk');
M_.endo_names = char(M_.endo_names, 'li');
M_.endo_names_tex = char(M_.endo_names_tex, 'li');
M_.endo_names_long = char(M_.endo_names_long, 'li');
M_.endo_names = char(M_.endo_names, 'lh');
M_.endo_names_tex = char(M_.endo_names_tex, 'lh');
M_.endo_names_long = char(M_.endo_names_long, 'lh');
M_.endo_names = char(M_.endo_names, 'ly_l');
M_.endo_names_tex = char(M_.endo_names_tex, 'ly\_l');
M_.endo_names_long = char(M_.endo_names_long, 'ly_l');
M_.endo_names = char(M_.endo_names, 'lw');
M_.endo_names_tex = char(M_.endo_names_tex, 'lw');
M_.endo_names_long = char(M_.endo_names_long, 'lw');
M_.endo_names = char(M_.endo_names, 'Rk');
M_.endo_names_tex = char(M_.endo_names_tex, 'Rk');
M_.endo_names_long = char(M_.endo_names_long, 'Rk');
M_.endo_names = char(M_.endo_names, 'Rs');
M_.endo_names_tex = char(M_.endo_names_tex, 'Rs');
M_.endo_names_long = char(M_.endo_names_long, 'Rs');
M_.endo_names = char(M_.endo_names, 'Rf');
M_.endo_names_tex = char(M_.endo_names_tex, 'Rf');
M_.endo_names_long = char(M_.endo_names_long, 'Rf');
M_.endo_names = char(M_.endo_names, 'z');
M_.endo_names_tex = char(M_.endo_names_tex, 'z');
M_.endo_names_long = char(M_.endo_names_long, 'z');
M_.endo_partitions = struct();
M_.param_names = 'beta';
M_.param_names_tex = 'beta';
M_.param_names_long = 'beta';
M_.param_names = char(M_.param_names, 'chi');
M_.param_names_tex = char(M_.param_names_tex, 'chi');
M_.param_names_long = char(M_.param_names_long, 'chi');
M_.param_names = char(M_.param_names, 'delta');
M_.param_names_tex = char(M_.param_names_tex, 'delta');
M_.param_names_long = char(M_.param_names_long, 'delta');
M_.param_names = char(M_.param_names, 'alpha');
M_.param_names_tex = char(M_.param_names_tex, 'alpha');
M_.param_names_long = char(M_.param_names_long, 'alpha');
M_.param_names = char(M_.param_names, 'rho');
M_.param_names_tex = char(M_.param_names_tex, 'rho');
M_.param_names_long = char(M_.param_names_long, 'rho');
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 1;
M_.endo_nbr = 11;
M_.param_nbr = 5;
M_.orig_endo_nbr = 11;
M_.aux_vars = [];
M_.Sigma_e = zeros(1, 1);
M_.Correlation_matrix = eye(1, 1);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = 1;
M_.det_shocks = [];
options_.block=0;
options_.bytecode=0;
options_.use_dll=0;
M_.hessian_eq_zero = 1;
erase_compiled_function('rbc1_static');
erase_compiled_function('rbc1_dynamic');
M_.orig_eq_nbr = 11;
M_.eq_nbr = 11;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./' M_.fname '_set_auxiliary_variables.m'], 'file') == 2;
M_.lead_lag_incidence = [
 0 3 0;
 0 4 14;
 1 5 0;
 0 6 0;
 0 7 15;
 0 8 0;
 0 9 0;
 0 10 0;
 0 11 0;
 0 12 0;
 2 13 16;]';
M_.nstatic = 7;
M_.nfwrd   = 2;
M_.npred   = 1;
M_.nboth   = 1;
M_.nsfwrd   = 3;
M_.nspred   = 2;
M_.ndynamic   = 4;
M_.equations_tags = {
};
M_.static_and_dynamic_models_differ = 0;
M_.exo_names_orig_ord = [1:1];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(11, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(1, 1);
M_.params = NaN(5, 1);
M_.NNZDerivatives = [37; -1; -1];
close all;
[param,ss] = calibration;
M_.params( 4 ) = param(1);
alpha = M_.params( 4 );
M_.params( 1 ) = param(2);
beta = M_.params( 1 );
M_.params( 3 ) = param(3);
delta = M_.params( 3 );
M_.params( 2 ) = param(4);
chi = M_.params( 2 );
M_.params( 5 ) = 0.95;
rho = M_.params( 5 );
sigma   = 0.01;
%
% INITVAL instructions
%
options_.initval_file = 0;
oo_.steady_state( 3 ) = log(ss(1));
oo_.steady_state( 2 ) = log(ss(2));
oo_.steady_state( 5 ) = log(ss(3));
oo_.steady_state( 4 ) = log(ss(4));
oo_.steady_state( 1 ) = log(ss(5));
oo_.steady_state( 7 ) = log(ss(6));
oo_.steady_state( 8 ) = log(ss(7));
oo_.steady_state( 9 ) = log(ss(8));
oo_.steady_state( 10 ) = log(ss(9));
oo_.steady_state( 6 ) = oo_.steady_state(1)-oo_.steady_state(5);
oo_.steady_state( 11 ) = 0;
if M_.exo_nbr > 0
	oo_.exo_simul = ones(M_.maximum_lag,1)*oo_.exo_steady_state';
end
if M_.exo_det_nbr > 0
	oo_.exo_det_simul = ones(M_.maximum_lag,1)*oo_.exo_det_steady_state';
end
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = sigma^2;
steady;
oo_.dr.eigval = check(M_,options_,oo_);
options_.hp_filter = 1600;
options_.order = 1;
var_list_ = char();
info = stoch_simul(var_list_);
statistic1 = 100*sqrt(diag(oo_.var(1:10,1:10)));
dyntable('standard deviations in %',strvcat('VARIABLE','REL. S.D.'),M_.endo_names(1:10,:),statistic1,10,8,2);
statistic2 = sqrt(diag(oo_.var(1:10,1:10)))/sqrt(diag(oo_.var(1,1)));
dyntable('Relative standard deviations in %',strvcat('VARIABLE','REL. S.D.'),M_.endo_names(1:10,:),statistic2,10,8,2);
save('rbc1_results.mat', 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save('rbc1_results.mat', 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save('rbc1_results.mat', 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save('rbc1_results.mat', 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save('rbc1_results.mat', 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save('rbc1_results.mat', 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save('rbc1_results.mat', 'oo_recursive_', '-append');
end


disp(['Total computing time : ' dynsec2hms(toc(tic0)) ]);
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
diary off
