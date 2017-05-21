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
               "LONG-SPEC2K6-13",
               "LONG-SPEC2K6-14",
               "LONG-SPEC2K6-15",
               "LONG-SPEC2K6-17",
               "LONG-SPEC2K6-18",
               "LONG-SPEC2K6-19",
               "SHORT-FP-1",
               "SHORT-FP-2",
               "SHORT-FP-5",
               "SHORT-INT-5",
               "SHORT-MM-1",
               "SHORT-MM-3",
               "SHORT-MM-4",
               "SHORT-MM-5",
               "SHORT-SERV-1",
               "SHORT-SERV-3",
               "SHORT-SERV-4",
               "SHORT-SERV-5",
               "AMEAN")

gshare <- c(3.974,
            5.176,
            5.658,
    	      10.739,
            4.160,
            4.160,
            3.929,
    	      12.844,
            9.880,
            4.687,
            2.648,
            5.464,
            1.525,
            2.599,
            3.479,
            1.061,
            0.788,
            0.438,
            9.172,
            4.267,
            1.811,
            5.651,
            3.646,
            5.870,
            5.324,
            5.208,
            4.775)

gshare_local2bit <- c(4.016,
                      5.410,
                      5.829,
                      10.723,
                      3.288,
                      3.288,
                      3.894,
                      12.911,
                      10.053,
                      5.124,
                      2.477,
                      5.977,
                      1.476,
                      2.500,
                      3.724,
                      1.051,
                      0.787,
                      0.437,
                      8.526,
                      4.375,
                      1.751,
                      4.719,
                      2.520,
                      4.582,
                      3.539,
                      3.520,
                      4.481)

adaptive2level_local2bit <- c(9.645,
                              20.658,
                              7.535,
                              22.786,
                              12.619,
                              12.619,
                              33.737,
                              13.430,
                              27.312,
                              22.574,
                              10.488,
                              24.048,
                              2.578,
                              4.283,
                              5.906,
                              4.425,
                              16.404,
                              0.886,
                              11.814,
                              10.119,
                              3.142,
                              8.499,
                              6.484,
                              9.099,
                              7.308,
                              7.367,
                              12.145)

df <- data.frame(benchmark, gshare, adaptive2level_local2bit,
                 gshare_local2bit) %>%
  gather(predictor, miss_per_1k_inst,
         c(gshare, gshare_local2bit, adaptive2level_local2bit))


ggplot(data=df, aes(x=benchmark,
                    y=miss_per_1k_inst,
                    fill=predictor)) +
  geom_col(position='dodge') +
  scale_fill_discrete(name="Predictor",
                      labels=c("Adaptive 2-level + local 2-bit",
                               "Gshare",
                               "Gshare + local 2-bit")) +
  scale_x_discrete(name="Trace") +
  ylab("Mispredictions per 1000 instructions") +
  theme(axis.text.x=element_text(angle=90, hjust=1))
ggsave("branchpredictors.png")

kable(group_by(df, predictor) %>%
      summarize(avg=mean(miss_per_1k_inst)))
