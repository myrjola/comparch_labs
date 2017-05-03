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
benchmark = os.environ.get('BENCHMARK') or 'unknown'

#
# 4Kbyte cache, random replacement policy
#
cache = pre_conf_object('cache', 'g-cache')
cache.cpus = [conf.cpu0_0]
cache.config_line_number = cache_lines
cache.config_line_size = 32
cache.config_assoc = 1
cache.config_virtual_index = 0
cache.config_virtual_tag = 0
cache.config_replacement_policy = 'random'
cache.penalty_read = 0
cache.penalty_write = 0
cache.penalty_read_next = 0
cache.penalty_write_next = 0

SIM_add_configuration([cache], None)

conf.phys_mem.timing_model = conf.cache

run_command("continue 100000")
run_command("cache.reset-statistics")
run_command("continue 10000")


print "Lines used: %d" % conf.cache.config_line_number
read_hit_rate = (1 - conf.cache.stat_data_read_miss / float(conf.cache.stat_data_read))
print "Read hit rate: %f" % read_hit_rate

csvfile = open('cache_statistics_excercise3.csv', 'a')
writer = csv.writer(csvfile)
writer.writerow([benchmark, cache_lines, read_hit_rate])
csvfile.close()

run_command("exit")
