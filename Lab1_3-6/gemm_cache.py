# Lab1 exercise 3.
#
# Setups the cache and runs the benchmark. You should have the benchmark
# breakpointed to the magic breakpoint in your Simics configuration. Run with
# something like:
#
# ./simics -stall -no-stc -c gemm.conf -no-win -q -p gemm_cache.py

import os
import csv

conf.cpu0_0.instruction_fetch_mode = "instruction-cache-access-trace"

# Read environment variables
l1d_cache_lines = int(os.environ.get('L1D_CACHE_LINES') or 1)
l1d_cache_size = int(os.environ.get('L1D_CACHE_SIZE') or 32)
l1d_assoc = int(os.environ.get('L1D_ASSOC') or 1)
l1d_replacement_policy = os.environ.get('L1D_REPLACEMENT_POLICY') or 'lru'
l1i_cache_lines = int(os.environ.get('L1I_CACHE_LINES') or 1)
l2_cache_lines = int(os.environ.get('L2_CACHE_LINES') or 4)
l2_assoc = int(os.environ.get('L2_ASSOC') or 4)
l2_replacement_policy = os.environ.get('L2_REPLACEMENT_POLICY') or 'lru'

#
# Transaction staller for memory
#
staller = pre_conf_object('staller', 'trans-staller')
staller.stall_time = 200

lev2c = pre_conf_object('lev2c', 'g-cache')
lev2c.cpus = conf.cpu0_0
lev2c.config_line_number = l2_cache_lines
lev2c.config_line_size = 128
lev2c.config_assoc = l2_assoc
lev2c.config_virtual_index = 0
lev2c.config_virtual_tag = 0
lev2c.config_write_back = 1
lev2c.config_write_allocate = 1
lev2c.config_replacement_policy = l2_replacement_policy
lev2c.penalty_read = 10
lev2c.penalty_write = 10
lev2c.penalty_read_next = 0
lev2c.penalty_write_next = 0
lev2c.timing_model = staller

SIM_add_configuration([staller, lev2c], None)

ic = pre_conf_object('ic', 'g-cache')
ic.cpus = conf.cpu0_0
ic.config_line_number = l1i_cache_lines
ic.config_line_size = 32
ic.config_assoc = 1
ic.config_virtual_index = 0
ic.config_virtual_tag = 0
ic.config_replacement_policy = 'lru'
ic.penalty_read = 3
ic.penalty_write = 0
ic.penalty_read_next = 0
ic.penalty_write_next = 0
ic.timing_model = conf.lev2c

dc = pre_conf_object('dc', 'g-cache')
dc.cpus = conf.cpu0_0
dc.config_line_number = l1d_cache_lines
dc.config_line_size = l1d_cache_size
dc.config_assoc = l1d_assoc
dc.config_virtual_index = 0
dc.config_virtual_tag = 0
dc.config_replacement_policy = l1d_replacement_policy
dc.penalty_read = 3
dc.penalty_write = 3
dc.penalty_read_next = 0
dc.penalty_write_next = 0
dc.timing_model = conf.lev2c

#
# instruction/data splitter
#
id = pre_conf_object('id', 'id-splitter')
id.ibranch = ic
id.dbranch = dc

SIM_add_configuration([ic, dc, id], None)

conf.phys_mem.timing_model = conf.id

run_command("magic-break-enable")
run_command("continue 1") # For some reason magic breakpoint happens after one instruction.
run_command("continue 100_000_000")

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

all_caches_statistics = []

caches = ['ic', 'dc', 'lev2c']
for cache in caches:
    cache = getattr(conf, cache)
    all_caches_statistics += [getattr(cache, attr) for attr in attrs]

filepath = 'cache_statistics_exercise3-6.csv'
new_file_created =  not os.path.exists(filepath)
csvfile = open(filepath, 'a')
writer = csv.writer(csvfile)
if new_file_created:
    # Write the header to newly created files
    all_caches_headers = ["%s.%s" % (cache, attr) for cache in caches for attr in attrs]
    writer.writerow(all_caches_headers)
writer.writerow(all_caches_statistics)
csvfile.close()

run_command("exit")
