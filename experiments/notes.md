# Notes on Experiments

* The times in any experiment running `MOVgrow` ignore the time for pre-computing `lambda2` and the degrees matrix.
Except: when `subgraph_extraction` is used, the times do account for those pre-computations.

* `MOVgrow` with subgraph extraction failed on a specific case in Youtube -- the backslash linear solve inside of `MOVgrow` came across a singular system. Specific community 418, member 11 (global graph index is 40517). It turns out that after subgraph extraction the subgraph is essentially a star graph, and the seed is one of the pendant nodes -- I haven't determined yet what exactly causes the singularity.


## LEMON Coefficient experiment

```
data    c_1             c_2             c_3             % of time max(c_2,c_3)/c_1 < 0.05
cite    1.0000          0.0025          -0.0000         0.98876
cora    1.0000          0.0104          0.0000          0.97959
sen     1.0000          -0.0825         0.0538          0.90909
us10    1.0000          0.0000          0.0000          1.00000
us3     1.0000          0.0096          0.0000          0.98990
dblp    1.0000          -0.0001         0.0002          0.99900
lj      1.0000          0.0059          0.0000          0.98354
yout    1.0000          0.0059          0.0000          0.98422
```
