function [F1, precision, recall, Jacccard_Index] = acc_stats( true_set, guess_set )
    size_intersection = numel(intersect(true_set, guess_set));
    size_union = numel( union(true_set, guess_set) );
    precision =  size_intersection / numel(guess_set);
    recall = size_intersection / numel(true_set);
    if size_intersection ~= 0,
      F1 = 2*recall*precision/( recall + precision );
    else
      F1 = 0;
    end
    Jacccard_Index = size_intersection / size_union;
end
