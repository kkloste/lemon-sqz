%% LOAD DATASET
clear; clc;
load_dir = './results/';

data_names = { 'citeseer', 'cora', 'senate', 'usps-10nn', 'usps-3nn', 'dblp', 'lj', 'youtube'};
use_names = { 'cite', 'cora', 'sen', 'us10', 'us3', 'dblp', 'lj', 'yout'};
all_data = cell( length(data_names),1 );

for which_file=1:length(data_names),
    filename = [ data_names{which_file}, '-lem-coeffs.mat'];
    load([load_dir, filename]);

    data = squeeze( which_coeffs( :, 1, 2, : ) );

    datmax = max(data')';
    max_inds = find( data(:,1) == datmax );
    data = data(max_inds,:);

    datmax = max(data')';
    data_normalized = spdiags( 1./datmax, 0, size(data,1), size(data,1) )*data;

    all_data{which_file} = data_normalized;
end

%% coefficient analysis

clf; hold all;
coeff_weights = [];
group = [];

for j=1:length(data_names),
    this_dataset_full = all_data{j};
      fprintf(' %s \t %.4f \t %.4f \t %.4f \t %.5f \n',  use_names{j} , mean(this_dataset_full),...
      numel( find( max( abs( this_dataset_full(:,2:3))' )' < 0.05)  )/size(this_dataset_full, 1 )  );
end
