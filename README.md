# LEMON-sqz

Pre-processing techniques and algorithms for robust, scalable community detection

## Codes for diffusions

* `lemon_original.m` MATLAB implementation of the original LEMON algorithm, as described in [ Li, He, Bindel, Hopcroft, WWW 2015 ].
* `lemon_simple.m` MATLAB implementation of our simplified version of LEMON -- using PPR subgraph extraction, and 3-walk diffusion instead of L1-norm LEMON vector.
* `local_fiedler.m` -- implements the locally biased Fiedler vector from [ Mahoney, Orecchia Vishnoi  JMLR 2012 ].
* `hkgrow_mex.cpp` and `hkgrow1.m` are adapted from [ Kloster & Gleich KDD 2014 ]
	* compute both the heat kernel diffusion and its set of best conductance.
* `pprgrow_mex.cc` and `pprgrow.m` are adapted from [ Gleich & Seshadhri KDD 2012 ]
	* adapted to output both the personalized pagerank diffusion and its set of best conductance.
* `pprvec_mex.cc` and `hkvec_mex.cpp` are the push operations for ppr and hk, stripped down to compute simply a single sparse diffusion vectors (not any community info)

* `sparse_k_walk.m` -- wrapper for computing (A_bar)^k * seed_vector without having to pre-process the adjacency matrix A to get A_bar.


# OLD NOTES

External code: (check the .m file for MEX code usage)

### Experiment codes


### Other code:
* `test_lemon.m` confirms that `lemon_original.m` and `lemon_new.m` produce the same vector.
* `test_local_fiedler.m` checks that the function is outputting the correct vector, and that it satisfies the constraints of the optimization problem that define the MOV vector.
* `test_hkgrow_mex.m` checks that the code for hkgrow is producing the correct vector.

# Datasets

* `usps3nn` and `usps10nn` are k-nearest-neighbors graphs constructed from the USPS hand-written digits datasets. These .mat files also contain the ground-truth class label for each node (each node represents an image of a digit, 0 through 9).
* SNAP datasets:
	* `youtube`
	* `lj`
	* `dblp`
	* `amazon`
	* `friendster`
	* `orkut`
* `senate_ccs` is a temporal graph of all US senators who served in the first 110 US senates. Every such senator is a single node. Produce edges as follows: For each of the 110 terms, take the set of senators from that term and connect them using 3-nearest-neighbors according to voting pattern similarity. The final dataset is the union of those graphs. A single term of a senate might be considered a ground-truth community in a sense -- though I might have to dig up party affiliation (republican / democrat) for more refined ground truth structure.
* `cora_ccs` -- from LINQS. The communities are a partitioning of the 2,708 graph nodes into 7 communities. (We symmetrized the graph and removed self-loops and isolated nodes to get to 2,708.)
* `citeseer_ccs` -- from LINQS. The communities are a partitioning of the 3,264 graph nodes into 6 communities. (We symmetrized the graph and removed self-loops and isolated nodes to get to 3,264.)
