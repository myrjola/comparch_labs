
#stats = dict((a, 0) for a in conf.l1cache0.__dict__.keys() if 'stat' in a)
stats = {'data_read_hit_rate':0, 'inst_fetch_hit_rate':0, 'data_write_hit_rate':0, 'stat_mesi_invalidate':0, 'stat_mesi_modified_to_shared':0, 'stat_mesi_exclusive_to_shared':0, 'stat_lost_stall_cycles':0}
for i in range(8):
    cache = getattr(conf, 'l1cache'+str(i))
    stats['data_read_hit_rate'] += 1 - cache.stat_data_read_miss / float(cache.stat_data_read)
    stats['inst_fetch_hit_rate'] += 1 - cache.stat_inst_fetch_miss / float(cache.stat_inst_fetch)
    stats['data_write_hit_rate'] += 1 - cache.stat_data_write_miss / float(cache.stat_data_write)
    for k in [kk for kk in stats.keys() if 'mesi' in kk or 'stall' in kk]:
        stats[k] += getattr(cache, k)

for k in stats.keys():
    stats[k] /= 8.

print stats


