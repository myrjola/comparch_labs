library(ggplot2)
library(dplyr)
library(sitools)
library(scales)
library(tidyr)

## 3.2

df <- read.csv('../cache_statistics_excercise3-2.csv')

df <- df %>%
  mutate(cache_size=cache_lines * config_line_size) %>%
  mutate(inst_hit_rate=1-stat_inst_fetch_miss/stat_inst_fetch) %>%
  mutate(total_accesses=stat_data_read + stat_data_write + stat_inst_fetch) %>%
  mutate(total_misses=stat_data_read_miss + stat_data_write_miss + stat_inst_fetch_miss) %>%
  mutate(config_assoc=as.factor(config_assoc)) %>%
  mutate(hit_rate=1-total_misses/total_accesses) %>%
  mutate(hit_rate_percentage=percent(hit_rate)) %>%
  mutate(read_hit_rate_percentage=percent(read_hit_rate)) %>%
  mutate(inst_hit_rate_percentage=percent(inst_hit_rate)) %>%
  mutate(write_hit_rate_percentage=percent(write_hit_rate))

df %>%
  filter(config_line_number ==  128) %>%
  filter(config_assoc ==  1) %>%
  arrange(desc(hit_rate)) %>%
  select(Benchmark=benchmark,
         "Inst hit rate"=inst_hit_rate_percentage,
         "Read hit rate"=read_hit_rate_percentage,
         "Write hit rate"=write_hit_rate_percentage,
         "Hit rate"=hit_rate_percentage)

## 3.3

breaks <- c(4e3, 16e3, 6e4, 4e5, 2e6, 8e6, 33e6)

ggplot(data=df,
       aes(x=cache_size,
           y=hit_rate,
           group=interaction(benchmark, config_assoc),
           shape=config_assoc,
           colour=benchmark)) +
  geom_line() +
  scale_x_log10(breaks=breaks, labels={function (x) f2si(x, unit='B')}) +
  ylab("Hit rate") +
  xlab("Cache size (bytes)") +
  scale_colour_discrete(name="Benchmark") +
  scale_shape_discrete(name="Associativity") +
  geom_point(size=1, fill="white")
ggsave("working_set_size.png", width=5, height=8)


## 3.4

minimal_cache <- read.csv('../cache_statistics_excercise3-4.csv')
minimal_cache <- minimal_cache %>%
  mutate(data_read_hit_rate=1-data_read_miss/data_read) %>%
  mutate(data_write_hit_rate=1-data_write_miss/data_write) %>%
  mutate(inst_fetch_hit_rate=1-inst_fetch_miss/inst_fetch)
minimal_cache <- gather(minimal_cache, variable, hit_rate,
                        c(data_write_hit_rate,
                          data_read_hit_rate,
                          inst_fetch_hit_rate))
select(minimal_cache, benchmark, line_size, variable, hit_rate)

minimal_cache <- mutate(minimal_cache,
                        line_size=as.factor(line_size),
                        access_type=as.factor(variable))

levels(minimal_cache$access_type) <- c("Read", "Write", "Instruction")

ggplot(data=minimal_cache, aes(x=benchmark,
                               y=hit_rate,
                               fill=line_size)) +
  geom_col(position='dodge') +
  scale_y_continuous(labels=percent, limits=c(0,1)) +
  scale_fill_discrete(name="Line size (bytes)") +
  xlab("Benchmark") +
  ylab("Hit rate") +
  facet_wrap(~access_type)
ggsave("minimal_line_size.png", scale=1.3)

## 3.5

cache_hierarchy <- read.csv('../cache_statistics_excercise3-5.csv')

cache_hierarchy_before_gather <- cache_hierarchy %>%
  mutate(ic.hit_rate=1-ic.stat_inst_fetch_miss/ic.stat_inst_fetch,
         dc.hit_rate=1-(dc.stat_data_read_miss+dc.stat_data_write_miss)/(dc.stat_data_read + dc.stat_data_write),
         lev2c.total_misses=lev2c.stat_data_read_miss+lev2c.stat_data_write_miss+lev2c.stat_inst_fetch_miss,
         lev2c.total_transactions=lev2c.stat_data_read+lev2c.stat_data_write+lev2c.stat_inst_fetch,
         lev2c.miss_rate=lev2c.total_misses/lev2c.total_transactions,
         lev2c.hit_rate=1-lev2c.miss_rate,
         lev2c.cache_size=lev2c.config_line_number*lev2c.config_line_size,
         lev1c.miss_rate=(ic.stat_inst_fetch_miss+dc.stat_data_read_miss+dc.stat_data_write_miss)/(dc.stat_data_read + dc.stat_data_write + ic.stat_inst_fetch),
         lev1c.hit_rate=1-lev1c.miss_rate,
         average_memory_access_time=lev1c.hit_rate*3 + lev1c.miss_rate*(lev2c.hit_rate*10 + lev2c.miss_rate*200))

cache_hierarchy <- gather(cache_hierarchy_before_gather, variable, hit_rate,
                          c(ic.hit_rate,
                            dc.hit_rate,
                            lev2c.hit_rate))

cache_hierarchy <- mutate(cache_hierarchy,
                          lev2c.cache_size=as.factor(lev2c.cache_size),
                          cache_type=as.factor(variable))

levels(cache_hierarchy$cache_type) <- c("L1 data cache",
                                        "L1 instruction cache",
                                        "L2 cache")


select(cache_hierarchy, benchmark, lev2c.cache_size, variable, hit_rate)

ggplot(data=cache_hierarchy, aes(x=benchmark,
                               y=hit_rate,
                               fill=lev2c.cache_size)) +
  geom_col(position='dodge') +
  scale_y_continuous(labels=percent, limits=c(0,1)) +
  scale_fill_discrete(name="L2 cache size (bytes)",
                      labels=c('8 kiB', '500 kiB', '1 MiB')) +
  xlab("Benchmark") +
  ylab("Hit rate") +
  facet_wrap(~cache_type)
ggsave("cache_hierarchy.png", scale=1.3)

## Horrible violation of DRY for 3.5 step 3
group_by(cache_hierarchy_before_gather, lev2c.cache_size) %>%
  summarize_at(vars(contains("stat_")),
               sum) %>%
  mutate(ic.hit_rate=1-ic.stat_inst_fetch_miss/ic.stat_inst_fetch,
         dc.hit_rate=1-(dc.stat_data_read_miss+dc.stat_data_write_miss)/(dc.stat_data_read + dc.stat_data_write),
         lev2c.total_misses=lev2c.stat_data_read_miss+lev2c.stat_data_write_miss+lev2c.stat_inst_fetch_miss,
         lev2c.total_transactions=lev2c.stat_data_read+lev2c.stat_data_write+lev2c.stat_inst_fetch,
         lev2c.miss_rate=lev2c.total_misses/lev2c.total_transactions,
         lev2c.hit_rate=1-lev2c.miss_rate,
         lev1c.miss_rate=(ic.stat_inst_fetch_miss+dc.stat_data_read_miss+dc.stat_data_write_miss)/(dc.stat_data_read + dc.stat_data_write + ic.stat_inst_fetch),
         lev1c.hit_rate=1-lev1c.miss_rate,
         average_memory_access_time=format(round(3 + lev1c.miss_rate*(10 + lev2c.miss_rate*200), 4), nsmall=4),
         cache_size=c("8 kiB", "500 kiB", "1 MiB")) %>%
  select("L2 cache size"=cache_size, "Average memory access time (cycles)"=average_memory_access_time)

## 4.4

mesi_stats <- read.csv('../cache_statistics_exercise4-4.csv')

cache_stats44 <- gather(mesi_stats, variable, hit_rate,
                        c(l1.read, l1.write, l1.instruction,
                          l2.read, l2.write, l2.instruction)) %>%
  mutate(l1size=ordered(cache_stats44$l1size, levels=c("8 kiB", "64 kiB")),
         miss_rate=(100-hit_rate)/100)


ggplot(data=cache_stats44, aes(x=variable,
                               y=miss_rate,
                               fill=l1size)) +
  geom_col(position='dodge') +
  scale_y_continuous(labels=percent) +
  scale_fill_discrete(name="L1 cache size (bytes)") +
  scale_x_discrete(name="Access type",
                   labels=c("L1 inst", "L1 read", "L1 write",
                            "L2 inst", "L2 read", "L2 write")) +
  ylab("Miss rate")
ggsave("multithreaded_caches.png")

mesi_stats <- gather(mesi_stats, variable, stat, c(exclusive.to.shared, Invalidate)) %>%
  mutate(l1size=ordered(l1size, levels=c("8 kiB", "64 kiB")),
         variable=gsub("exclusive.to.shared", "Exclusive to shared", variable))

ggplot(data=mesi_stats, aes(x=variable,
                            y=stat,
                            fill=l1size)) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black")) +
  geom_col(position='dodge') +
  scale_y_continuous(breaks=mesi_stats$stat) +
  scale_fill_discrete(name="L1 cache size (bytes)") +
  ylab("L1 MESI statistics (mean count)")
ggsave("multithreaded_caches_mesi.png")
