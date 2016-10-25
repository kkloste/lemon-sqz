function all_values = get_all_values_seedwise(data_names, alg_tags, stat_names, load_dir )
  all_values = zeros( length(data_names), length(alg_tags), length(stat_names), 3);
  for which_dat=1:length(data_names),
      dat_name = data_names{which_dat};
      for which_alg=1:length(alg_tags),
          alg_name = alg_tags{which_alg};

          load( [load_dir, dat_name, '-', alg_name, '-gtc-recovery.mat'] );

          for which_stat=1:length(stat_names),
              cell_stat = eval(['clus_stats.', stat_names{which_stat} ]);
              full_stat = [];
              for j=1:length(cell_stat),
                  this_data = cell_stat{j};
                  this_data( find( isnan(this_data) ) ) = 0;
                  full_stat = [ full_stat; this_data ];
              end
              [lb, ub] = semistd( full_stat );
              all_values(which_dat,which_alg,which_stat,:) = [ mean(full_stat), lb, ub ];
          end
      end
  end

end
