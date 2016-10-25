function make_plots( all_values, use_names, alg_names, plot_title, stat_names, image_dir, plot_name )
  for which_stat=1:size(all_values, 3),
      clf
      sample_stat = squeeze(all_values(:,:,which_stat,1));
      stat_Lbound = squeeze(all_values(:,:,which_stat,2));
      stat_Ubound = squeeze(all_values(:,:,which_stat,3));
      %[1 4 8; 2 5 9; 3 6 10];
      h = bar(sample_stat);
      set(h,'BarWidth',1);    % The bars will now touch each other
      set(gca,'YGrid','on')
      set(gca,'GridLineStyle','-')
      set(gca,'XTicklabel',use_names)
      ylabel(stat_names{which_stat});
      % set(get(gca,'YLabel'),'String','U')
      lh = legend(alg_names);
      set(lh,'Location','BestOutside','Orientation','horizontal')
      hold on;
      numgroups = size(sample_stat, 1);
      numbars = size(sample_stat, 2);
      groupwidth = min(0.8, numbars/(numbars+1.5));
      for i = 1:numbars
            % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
            x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
            % Aligning error bar with individual bar
            errorbar(x, sample_stat(:,i), stat_Lbound(:,i), stat_Ubound(:,i), 'k.');
      end
      if strcmp( stat_names{which_stat},  'runtimes'),
        set(gca,'yscale','log');
      end
      if which_stat == 1,
          title( plot_title );
      end
      set_figure_size([6,2]);
      xlim( [0.5 length(use_names)+0.5] );
      print(gcf,[ image_dir, plot_name, '-', stat_names{which_stat}, '.png'],'-dpng');

  end
end
