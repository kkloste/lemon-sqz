# Datasets

Datasets here were pre-processed as described in the paper.

For example, many communities in the original versions of datasets induced subgraphs that were not connected.
The versions of the datasets contained in `/data/` end in `_ccs` to indicate that they have been processed to ensure the graph is connected and individual communities induce connected subgraphs. We obtained these by iterating through each ground truth community and extracting its different connected components.
If a single community is split into multiple different connected components, then we consider each of those connected components to be their own ground truth community.
