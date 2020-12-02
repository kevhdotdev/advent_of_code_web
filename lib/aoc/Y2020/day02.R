library(tidyverse)

"priv/inputs/2020/02.txt" %>%
read_csv(col_names = FALSE) %>%
separate(X1, sep="[ :-]", into=c("min", "max", "chr", "x", "password")) %>%
mutate(count = password %>% str_match_all(chr) %>% lengths) %>%
mutate(valid = (count >= as.numeric(min) & count <= as.numeric(max))) %>%
filter(valid) %>% count()

"priv/inputs/2020/02.txt" %>%
read_csv(col_names = FALSE) %>%
separate(X1, sep="[ :-]", into=c("min", "max", "chr", "x", "password")) %>%
mutate(count = password %>% str_match_all(chr) %>% lengths) %>%
mutate(valid = (count >= as.numeric(min) & count <= as.numeric(max))) %>%
filter(valid) %>% count()
