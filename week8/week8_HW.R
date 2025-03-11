########problem1

library(tidyverse)
mylog10pmodel <- function(mal3){
  out=anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data=mal3))
  myF=-pf(out[3,3]/out[4,3],out[3,1],out[4,1],lower.tail=FALSE,
            log.p=TRUE)/log(10)
  myF
}

mal = read_tsv("allhaps.malathion.200kb.txt.gz")
# select the first position in the genome
mal2= mal %>%
  filter(chr == "chrX")
pos10=sample(mal2$pos,10)
mal3 = mal %>%
  filter(chr == "chrX") %>%
  filter(pos %in% pos10)
levels(as.factor(mal3$pool))
levels(as.factor(mal3$founder))	
mal3 = mal3 %>% mutate(treat=str_sub(pool,2,2))
mal4 = mal3 %>%
  group_by(chr, pos) %>%
  nest()
myresult1 = mal3 %>%
  group_by(chr, pos) %>%
  nest()%>%
  mutate(logp_interaction = map_dbl(data, mylog10pmodel))%>%
  select(-data)

write_tsv(myresult1,"problem1table.txt")

########problem2
mylog10pmodel2 <- function(mal3){
  out=anova(lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data=mal3))
  myF = -pf(out[1,3]/out[2,3],out[1,1],out[2,1],lower.tail=FALSE,
            log.p=TRUE)/log(10)
  myF
}
myresult2 = mal3 %>%
  group_by(chr, pos) %>%
  nest()%>%
  mutate(logp_independent = map_dbl(data, mylog10pmodel2))%>%
  select(-data)
write_tsv(myresult1,"problem2table.txt")

###########problem3
mergedata = myresult1 %>% left_join(myresult2, by=c("chr","pos"))
mergedata_onetibble = mergedata %>%
  group_by(chr, pos) %>%
  nest()
write_rds(mergedata_onetibble,"problem3_merge.rds")
