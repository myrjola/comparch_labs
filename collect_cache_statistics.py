# Lab1 exercise 3.
#
# Setups the cache and runs the benchmark. You should have the benchmark
# breakpointed to the magic breakpoint in your Simics configuration. Run with
# something like:
#
# ./simics -stall -no-stc -c vortex.conf -no-win -q -p collect_cache_statistics.py

conf.cpu0_0.instruction_fetch_mode = "instruction-cache-access-trace"

#
# 4Kbyte cache, random replacement policy
#
cache = pre_conf_object('cache', 'g-cache')
cache.cpus = [conf.cpu0_0]
cache.config_line_number = 128
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

print "Lines used: %d" % conf.cache.config_line_size
print "Read hit rate: %f" % (1 - conf.cache.stat_data_read_miss / float(conf.cache.stat_data_read))

run_command("exit")
