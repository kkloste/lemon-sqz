function run_test(test_name, compile_flag)
% INPUTS
%   test_name      - name of function you want tested
%
% MOVgrow
% prvec
% pprgrow
% hkgrow
% hkvec
%
% degpow
%
% all       - executes all test functions inside /test

  addpath ./tests ;
  addpath ./baseline_codes ;
  addpath ./util ;

if nargin < 1, test_name = 'no_name'; end
if nargin < 2, compile_flag = false; end
if compile_flag, compile; end

  switch test_name
    case 'MOVgrow'
      test_MOVgrow ;
    case 'prvec'
      test_prvec_mex ;
    case 'pprgrow'
      test_pprgrow_mex ;
    case 'hkgrow'
      test_hkgrow_mex
    case 'hkvec'
      test_hkvec_mex
    case 'degpow'
      test_sparse_degpower

    case 'all' ;

      list = dir('./tests/*.m');
      for j = 1:length(list),
        func_name = list(j).name;
	h = str2func( func_name(1:end-2) );
        h()
      end

    otherwise
      fprintf('\n Input does not match any tests.\n');
  end
