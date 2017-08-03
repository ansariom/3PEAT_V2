#!/usr/bin/python

# This script will sort initiation regions (-2000 to +1000 relative to tss mode) based on end location 
# and choose non-overlapped initiation regions as good reigions

def do_interval_scheduling(tags):
    ordered = sorted(tags, key=lambda x: x['init_region'][1])

    good_tags = []
    while len(ordered) > 0:
        selected = ordered[0]
        good_tags.append(selected)

        del ordered[0]
        to_del = []
        for i in range(0,len(ordered)):
            if ordered[i]['init_region'][0] < selected['init_region'][1] and ordered[i]['chr_id'] == selected['chr_id']:
                to_del.append(i) # don't delete right away because that will change ordering
                #print >> sys.stderr, "Removing incompatible dude %s (sel %s, %s vs %s) on chrs %s,%s" % (ordered[i]['tss_id'], selected['tss_id'], str(selected['init_region']), str(ordered[i]['init_region']), selected['chr_id'], ordered[i]['chr_id'])

        for i in sorted(to_del, reverse=True):
            del ordered[i]

    #print good_tags
    return good_tags

