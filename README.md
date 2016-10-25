# LEMON-sqz

Pre-processing techniques and algorithms for robust, scalable community detection

To use codes, first run `compile.m` from project home directory `/`.
The LEMON codes require installation of CVX convex optimization software.
To check codes are working (and interfacing properly with CVX), after compiling run `run_tests.m` from home directory.


## Codes for algorithms

* `lemon_simple.m` MATLAB implementation of our simplified version, LEMONeasy -- using adaptive PPR subgraph extraction, and 3-walk diffusion instead of L1-norm LEMON vector.
* `lemon_original.m` MATLAB implementation of the original LEMON algorithm, as described in [ Li, He, Bindel, Hopcroft, WWW 2015 ].
* `MOVgrow.m` and `local_fiedler.m` -- implements the locally biased Fiedler vector from [ Mahoney, Orecchia Vishnoi  JMLR 2012 ].
* `hkgrow_mex.cpp` and `hkgrow1.m` are adapted from [ Kloster & Gleich KDD 2014 ]
	* compute both the heat kernel diffusion and its set of best conductance.
* `pprgrow_mex.cc` and `pprgrow.m` are adapted from [ Gleich & Seshadhri KDD 2012 ]
	* adapted to output both the personalized pagerank diffusion and its set of best conductance.
* `pprvec_mex.cc` and `hkvec_mex.cpp` are the push operations for ppr and hk, stripped down to compute simply a single sparse diffusion vectors (not any community info)

### Our pre-processing techniques

* `subgraph_extraction` -- given input graph and seed, this attempts to extract a medium-sized cluster with high recall. Details discussed in paper.
* `seed_aug.m` -- given input graph and seed, this attempts to find `k` ground truth nodes related to the seed, with high precision. (`k` is an input parameter, default to 3).

### Utility codes

* `sparse_k_walk.m` -- wrapper for computing (A_bar)^k * seed_vector without having to pre-process the adjacency matrix A to get A_bar.
* `sweepcut_mex.cpp` and wrapper `sweepcut.m` -- fast implementation of the sweepcut procedure, with options for specifying the range of nodes to be swept over.
* `cut_cond.m` -- sparse method to obtain conductance and other statistics of an input set of nodes.

## Datasets

See the paper for sources of the datasets and how they were pre-processed.

* `usps3nn` and `usps10nn` are k-nearest-neighbors graphs constructed from the USPS hand-written digits datasets. These .mat files also contain the ground-truth class label for each node (each node represents an image of a digit, 0 through 9).
* SNAP datasets:
	* `youtube`
	* `lj`
	* `dblp`
	* `amazon`
	* `friendster`
	* `orkut`
* `senate_ccs` is a temporal graph of all US senators who served in the first 110 US senates. Every such senator is a single node.
* `cora_ccs` -- from LINQS. The communities are a partitioning of the 2,708 graph nodes into 7 communities. (We symmetrized the graph and removed self-loops and isolated nodes to get to 2,708.)
* `citeseer_ccs` -- from LINQS. The communities are a partitioning of the 3,264 graph nodes into 6 communities. (We symmetrized the graph and removed self-loops and isolated nodes to get to 3,264.)
