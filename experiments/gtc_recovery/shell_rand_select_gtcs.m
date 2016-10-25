function shell_rand_select_gtcs(varargin )
% shell_rand_select_gtcs( varargin )
%
% Before calling this, be sure to add paths to the algorithm(s)
% that this script calls.
%
% VARARGIN INPUTS:
%   'fname'         - name of file; default set to 'senate'
%   'fsuffix'       - suffix for filename; default set to ''
%   'load_dir'      - directory of fname  (default '../../data')
%   'save_dir'      - directory to save results in (default './results')
%   'num_comms'     - number comms to use; default = 100

%%
% PARAMETERS
%%
p = inputParser;
p.addOptional('fname', 'cora') ;
p.addOptional('fsuffix', '_ccs') ;
p.addOptional('load_dir', '../../data/') ;
p.addOptional('save_dir', './gtc_rand_data/') ;
p.addOptional('num_comms', 100) ;
p.parse(varargin{:});

fname = p.Results.fname;
load_dir = p.Results.load_dir;
save_dir = p.Results.save_dir;
fsuffix = p.Results.fsuffix;
NUM_RAND_COMMS = p.Results.num_comms;
% LOAD GROUND TRUTH INFORMATION
load( [load_dir, fname, fsuffix, '.mat'] );

[C_rand_inds, rand_comm_stats] = rand_select_gtcs( A, C, NUM_RAND_COMMS ) ;
fprintf('\nDone with %s \n\n ', fname );

save( [ save_dir, fname, '-rand-comms.mat'], 'rand_comm_stats', 'C_rand_inds','-v7.3');

end % END OUTER FUNCTION
