#! /usr/bin/env python
# __author__: Yixuan Li
# __email__: yli@cs.cornell.edu

import csv
import glob, os
data_dir = '../data/facebook-ego/'
out_dir = '../data/facebook-ego/formatted/'
file_list = glob.glob(data_dir+"*.circles")

if not os.path.exists(out_dir):
	os.makedirs(out_dir)
for circle_file in file_list:
	node_id = circle_file.split('/')[-1].split('.')[0]
	with open(circle_file) as fin:
		print "file opened"
		content = fin.readlines()
		# get the list of membership count in each circle
		count = [len(node_list.split('\t'))-1 for node_list in content]
		paddle_max = max(count)
		data = []
		for node_list in content:
			node_list = node_list[:-1]
			ids = node_list.split('\t')[1:]
			ids = [int(x)+1 for x in ids]
			ids += (paddle_max - len(ids)) * [0]
			data.append(ids)
		# write csv
		with open(out_dir+node_id+'.csv', 'wb') as fout:
			a = csv.writer(fout, delimiter=',')
			a.writerows(data)
			print "csv written"


