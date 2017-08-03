#!/usr/bin/env python

import sys
import numpy
import interval_scheduling 
import peak_data

def write_locs(positions, peak_type, read_count):
    for v in positions:
        if (peak_type is not None and v['peak'] != peak_type) or v['read_count'] < read_count:
            continue
        print "%s\t%s\t%s\t%d" % (v['tss_id'], v['chr_id'], v['strand'], v['mode']) 


if __name__ == "__main__":
    if len(sys.argv) < 5:
        print "Usage: peak_make_negatives.py [FILE] [PEAK_TYPE] [MIN_READ_COUNT] [nucs_upstream]"
        sys.exit(1)

    peak_type = sys.argv[2]
    read_count = int(sys.argv[3])
    nucs_upstream = int(sys.argv[4])

    if (peak_type.lower() == 'all'):
        peak_type = None

    fwd_tags, rev_tags = peak_data.load_tags(sys.argv[1], nucs_upstream)
    good_pos = interval_scheduling.do_interval_scheduling(fwd_tags.values())
    good_rev = interval_scheduling.do_interval_scheduling(rev_tags.values())
    
    # Count Tags
    orig_fwd   = peak_data.count_tag_types(fwd_tags.values())
    orig_rev   = peak_data.count_tag_types(rev_tags.values())
    fwd_counts = peak_data.count_tag_types(good_pos)
    rev_counts = peak_data.count_tag_types(good_rev)

    #print "Good Pos: "+str(len(good_pos))
    #print "Good Neg: "+str(len(good_rev))

    write_locs(good_pos, peak_type, read_count)
    write_locs(good_rev, peak_type, read_count)

    #for v in good_pos:
    #    if v['peak'] != 'NarrowPeak' or v['read_count'] < 50:
    #        continue
    #    print v['tss_id']

    #for v in good_rev:
    #    if v['peak'] != 'NarrowPeak' or v['read_count'] < 50:
    #        continue

    #    print v['tss_id']
    #print "Orig Forward counts: "+str(orig_fwd)
    #print "Orig Reverse counts: "+str(orig_rev)

    #print "Forward counts: "+str(fwd_counts)
    #print "Reverse counts: "+str(rev_counts)

