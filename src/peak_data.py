#!/usr/bin/python
import csv

def count_tag_types(selected_tags):
    counts = dict()

    counts['NarrowPeak'] = len(filter(lambda x: x['peak']=='NarrowPeak' and x['read_count'] >= 50, selected_tags))
    counts['BroadWithPeak'] = len(filter(lambda x: x['peak']=='BroadWithPeak', selected_tags))
    counts['WeakPeak'] = len(filter(lambda x: x['peak']=='WeakPeak', selected_tags))

    return counts

def load_tags(filename, nucs_upstream, tss_upstream=2000, tss_downstream=1000):
    pos_tags = {}
    neg_tags = {}

    with open(filename, 'rb') as csvfile:
        reader = csv.reader(csvfile, delimiter=',', quotechar="\"")

        reader.next() # ignore header
        for row in reader:
            entry = {}

            strand = str(row[1])
            start_pos = int(row[2])
            end_pos = int(row[3])
            mode = int(row[5])
            initiation_region = [mode - tss_upstream, mode + tss_downstream]
            chr_id = str(row[0])
            shape = str(row[7])
            read_count = int(row[4])
	    trx_id = str(row[9])
	    promoter_start = mode - nucs_upstream
	    
	    if (promoter_start > 0):
	    	tss_id = str(trx_id + "_" + chr_id + "_" + str(promoter_start) + "_0")

	        entry['tss_id'] = tss_id
            	entry['strand'] = strand
            	entry['start_pos'] = int(start_pos)
            	entry['end_pos'] = int(end_pos)
            	entry['mode'] = int(mode)
            	entry['init_region'] = initiation_region
            	entry['chr_id'] = chr_id
            	entry['peak'] = shape
            	entry['read_count'] = int(read_count)

            	if (strand == '+'): # forward strand
                     pos_tags[tss_id] = entry
                else: # reverse
                     neg_tags[tss_id] = entry

    return (pos_tags, neg_tags)

def load_tags_capped(filename, tss_upstream=2000, tss_downstream=1000):
    pos_tags = {}
    neg_tags = {}

    with open(filename, 'rb') as csvfile:
        reader = csv.reader(csvfile, delimiter=',', quotechar="\"")

        reader.next() # ignore header
        for row in reader:
            entry = {}

            tss_id = str(row[13])
            strand = str(row[1])
            start_pos = int(row[2])
            end_pos = int(row[3])
            mode = int(row[5])
            initiation_region = [mode - tss_upstream, mode + tss_downstream]
            chr_id = str(row[0])
            shape = str(row[7])
            read_count = int(row[4])

            entry['tss_id'] = tss_id
            entry['strand'] = strand
            entry['start_pos'] = int(start_pos)
            entry['end_pos'] = int(end_pos)
            entry['mode'] = int(mode)
            entry['init_region'] = initiation_region
            entry['chr_id'] = chr_id
            entry['peak'] = shape
            entry['read_count'] = int(read_count)

            if (strand == '+'): # forward strand
                pos_tags[tss_id] = entry
            else: # reverse
                neg_tags[tss_id] = entry

    return (pos_tags, neg_tags)
