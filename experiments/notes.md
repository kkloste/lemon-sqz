# Notes on Experiments

* The times in any experiment running `MOVgrow` ignore the time for pre-computing `lambda2` and the degrees matrix.
Except: when `subgraph_extraction` is used, the times do account for those pre-computations.

* `MOVgrow` with subgraph extraction failed on a specific case in Youtube -- the backslash linear solve inside of `MOVgrow` came across a singular system. Specific community 418, member 11 (global graph index is 40517). It turns out that after subgraph extraction the subgraph is essentially a star graph, and the seed is one of the pendant nodes -- I haven't determined yet what exactly causes the singularity.
