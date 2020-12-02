library(tidyverse)

"inputs/2020/01.txt" %>%
read_csv(col_names=FALSE) %>%
mutate(X2=X1) %>%
expand(X1, X2) %>%
mutate(p1=X1 + X2) %>%
filter(p1==2020) %>%
slice(1) %>%
mutate(product=X1 * X2) %>%
pull(product)

"inputs/2020/01.txt" %>%
read_csv(col_names=FALSE) %>%
mutate(X2=X1, X3=X1) %>%
expand(X1, X2, X3) %>%
mutate(p2=X1 + X2 + X3) %>%
filter(p2==2020) %>%
slice(1) %>%
mutate(product=X1 * X2 * X3) %>%
pull(product)
