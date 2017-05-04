# Lab1 exercise 3.
#
# Setups the cache and runs the benchmark. You should have the benchmark
# breakpointed to the magic breakpoint in your Simics configuration. Run with
# something like:
#
# ./simics -stall -no-stc -c vortex.conf -no-win -q -p collect_cache_statistics.py

import os
import csv

conf.cpu0_0.instruction_fetch_mode = "instruction-cache-access-trace"

# Read environment variables
cache_lines = int(os.environ.get('CACHE_LINES') or 128)
associativity = int(os.environ.get('ASSOC') or 1)
benchmark = os.environ.get('BENCHMARK') or 'unknown'

#
# 4Kbyte cache, random replacement policy
#
cache = pre_conf_object('cache', 'g-cache')
cache.cpus = [conf.cpu0_0]
cache.config_line_number = cache_lines
cache.config_line_size = 32
cache.config_assoc = associativity
cache.config_virtual_index = 0
cache.config_virtual_tag = 0
cache.config_replacement_policy = 'random'
cache.penalty_read = 0
cache.penalty_write = 0
cache.penalty_read_next = 0
cache.penalty_write_next = 0

SIM_add_configuration([cache], None)

conf.phys_mem.timing_model = conf.cache

run_command("continue 100000000")
run_command("cache.reset-statistics")
run_command("continue 1000000")

print "Lines used: %d" % conf.cache.config_line_number
read_hit_rate = (1 - conf.cache.stat_data_read_miss / float(conf.cache.stat_data_read))
print "Read hit rate: %f" % read_hit_rate
write_hit_rate = (1 - conf.cache.stat_data_write_miss / float(conf.cache.stat_data_write))
print "Write hit rate: %f" % write_hit_rate

# Some useful attributes to get from the cache
attrs = ['stat_inst_fetch',
         'penalty_write_next',
         'config_write_allocate',
         'config_line_number',
         'config_write_back',
         'stat_lost_stall_cycles',
         'access_count',
         'penalty_read_next',
         'config_replacement_policy',
         'stat_inst_fetch_miss',
         'stat_uc_data_read',
         'config_line_size',
         'stat_data_read_miss',
         'penalty_read',
         'stat_data_write',
         'stat_copy_back',
         'stat_transaction',
         'stat_dev_data_read',
         'stat_uc_inst_fetch',
         'stat_uc_data_write',
         'stat_data_write_miss',
         'stat_data_read',
         'penalty_write',
         'config_assoc']

statistics = [getattr(conf.cache, attr) for attr in attrs]

filepath = 'cache_statistics_excercise3.csv'
new_file_created =  not os.path.exists(filepath)
csvfile = open(filepath, 'a')
writer = csv.writer(csvfile)
if new_file_created:
    # Write the header to newly created files
    writer.writerow(['benchmark', 'cache_lines', 'read_hit_rate', 'write_hit_rate'] + attrs)
writer.writerow([benchmark, cache_lines, read_hit_rate, write_hit_rate] + statistics)
csvfile.close()

run_command("exit")
