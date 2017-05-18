library(tidyverse)
library(knitr)

## 3.1 Branch predictor

benchmark <- c("LONG-SPEC2K6-00",
               "LONG-SPEC2K6-02",
               "LONG-SPEC2K6-03",
               "LONG-SPEC2K6-04",
               "LONG-SPEC2K6-06",
               "LONG-SPEC2K6-07",
               "LONG-SPEC2K6-11",
               "LONG-SPEC2K6-12",
               "SHORT-FP-1",
               "SHORT-FP-2",
               "SHORT-FP-5",
               "SHORT-INT-5",
               "SHORT-MM-1",
               "SHORT-MM-3",
               "SHORT-MM-5",
               "SHORT-SERV-1",
               "SHORT-SERV-3")

# Shorter benchmark names
benchmark <- c("L00",
               "L02",
               "L03",
               "L04",
               "L06",
               "L07",
               "L11",
               "L12",
               "SF1",
               "SF2",
               "SF5",
               "SI5",
               "SM1",
               "SM3",
               "SM5",
               "SS1",
               "SS3")

gshare <-  c(3.974,
             5.176,
             5.658,
             10.739,
             4.160,
             4.160,
             3.929,
             12.844,
             3.479,
             1.061,
             0.788,
             0.438,
             9.172,
             4.267,
             5.651,
             3.646,
             5.870)

tournament <- c(3.433,
                5.228,
                5.631,
                10.654,
                3.132,
                3.132,
                3.901,
                12.887,
                3.498,
                1.027,
                0.787,
                0.417,
                8.462,
                4.341,
                4.449,
                2.214,
                4.378)

df <- data.frame(benchmark, gshare, tournament) %>%
  gather(predictor, miss_per_1k_inst, c(gshare, tournament))

ggplot(data=df, aes(x=benchmark,
                    y=miss_per_1k_inst,
                    fill=predictor)) +
  geom_col(position='dodge') +
  scale_fill_discrete(name="Predictor") +
  scale_x_discrete(name="Trace") +
  ylab("Mispredictions per 1000 instructions")
ggsave("branchpredictors.png")

kable(group_by(df, predictor) %>%
      summarize(avg=mean(miss_per_1k_inst)))
