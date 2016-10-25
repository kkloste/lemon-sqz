% Check if datasets have communities that are connected

clear; clc;

% Directories for adjacency / community info
load_dir = '../data_big/';
save_dir = '../data_big/data_cc/';

files =  dir([load_dir, '*.mat']);

for j = 1:length(files),
    tic;
    load( [ load_dir, files(j).name ] );
    fname = files(j).name;
    fname = fname( 1: end -4 );
    timet = toc; fprintf('Load %s  done,  %f\n', fname, timet);

    % RUN EXPERIMENT
    tic;
    n = size(C,1);
    num_comms = size(C,2);
    
    rows = [];
    cols = [];
    which_comm = 1;
    for ind=1:num_comms,
        inds = find(C(:,ind));
        Asub = A(inds,inds);
        [num_cc, conn_comps] = graphconncomp(Asub);
        if num_cc == 1,
            rows = [rows; inds];
            cols = [cols; which_comm*ones(length(inds),1)];
                which_comm = which_comm + 1;
        elseif num_cc > 1,
            for which_cc=1:num_cc,
                sub_inds = find(conn_comps == which_cc);
                rows = [rows; inds(sub_inds)];
                cols = [cols; which_comm*ones(length(sub_inds),1)];
                which_comm = which_comm + 1;
            end
        end
    end
        fprintf(' max r %f   max c %f   n %d   c %d    num_comm %d \n', max(rows), max(cols), n, which_comm-1, num_comms);
        C = sparse( rows, cols, 1, n, which_comm-1);
    save( [save_dir, fname,'_ccs.mat'], 'A', 'C', '-v7.3');
end
