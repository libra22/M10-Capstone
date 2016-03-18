setwd("C:/Users/BPM/Downloads/DataScience/Assignment/M10-Capstone")

library(tm)
library(SnowballC)
library(RWeka)
library(ggplot2)

#reading files
datatwitter <-readLines(conn <-file("./data/en_US.twitter.txt",encoding="UTF-8"))
close(conn)
datablog <- readLines(conn <-file("./data/en_US.blogs.txt",encoding="UTF-8"))
close(conn)
datanews <- readLines(conn <-file("./data/en_US.news.txt","rb",encoding="UTF-8"))
close(conn)

#calc and display basic info like file size, object size and number of lines.
file.info("./data/en_US.twitter.txt")$size/1024/1000
file.info("./data/en_US.blogs.txt")$size/1024/1000
file.info("./data/en_US.news.txt")$size/1024/1000

twtinfo <- c(format(file.info("./data/en_US.twitter.txt")$size/1024/1000,digits=6),format(object.size(datatwitter),units="auto"),prettyNum(length(datatwitter),big.mark = ",",width=7))
bloginfo <- c(format(file.info("./data/en_US.blogs.txt")$size/1024/1000,digits=6),format(object.size(datablog),units="auto"),prettyNum(length(datablog),big.mark = ",",width=8))
newsinfo <- c(format(file.info("./data/en_US.news.txt")$size/1024/1000,digits=6),format(object.size(datanews),units="auto"),prettyNum(length(datanews),big.mark = ",",width=7))
datainfo <- rbind(twtinfo, bloginfo,newsinfo)

rownames(datainfo) <- c("Twitter", "Blogs", "News")
colnames(datainfo) <- c("File Size (MB)", "Object Size", "Lines")

datainfo

twordcount <- sum(sapply(gregexpr("\\S+",datatwitter),length)) ## capital S
bwordcount <- sum(sapply(gregexpr("\\S+",datablog),length)) ## capital S
nwordcount <- sum(sapply(gregexpr("\\S+",datanews),length)) ## capital S



#identify longest line
twtcount <- nchar(datatwitter) #count number of char per line
tmax <- which.max(twtcount)
nchar(datatwitter[tmax])
blogcount <- nchar(datablog)
bmax <- which.max(blogcount)
nchar(datablog[bmax])
newscount <- nchar(datanews)
nmax <- which.max(newscount)
nchar(datanews[nmax])

#num of words in longest line
sum(sapply(gregexpr("\\S+",datablog[bmax]),length)) #number of words in the longest line
sum(sapply(gregexpr("\\S+",datanews[nmax]),length)) #number of words in the longest line
sum(sapply(gregexpr("\\S+",datatwitter[tmax]),length)) #number of words in the longest line


#remove weird characters
cleanedtwt <- sapply(datatwitter,function(x) iconv (enc2utf8(x),sub="byte"))
cleanedblog <- sapply(datablog,function(x) iconv (enc2utf8(x),sub="byte"))
cleanednews <- sapply(datanews,function(x) iconv (enc2utf8(x),sub="byte"))


#write cleaned files for reuse.
writeLines(cleanedtwt,conn <-file("./data/cleanedtwitter.txt",encoding="UTF-8"))
close(conn)
writeLines(cleanedblog,conn <-file("./data/cleanedblog.txt",encoding="UTF-8"))
close(conn)
writeLines(cleanednews,conn <-file("./data/cleanednews.txt",encoding="UTF-8"))
close(conn)

alldata <- c(cleanedtwt,cleanedblog,cleanednews)
save(alldata,file="alldata.RData")

load("alldata.RData")

#read clean files
datatwitterclean <-readLines(conn <-file("./data/cleanedtwitter.txt",encoding="UTF-8"))
close(conn)
datanewsclean <-readLines(conn <-file("./data/cleanednews.txt",encoding="UTF-8"))
close(conn)
datablogclean <-readLines(conn <-file("./data/cleanedblog.txt",encoding="UTF-8"))
close(conn)

summary(datatwitterclean)
datatwitter[167155]
datatwitterclean[167155]


#create sample
set.seed(1234)
sampletwt <- sample(cleanedtwt,10000)
sampleblog <- sample(cleanedblog,10000)
samplenews <- sample(cleanednews,10000)



#cleaning
library(tm)
twt.vec <- VectorSource(sampletwt)
twt.corpus <- Corpus(twt.vec)
twt.corpus <- tm_map(twt.corpus,tolower)
twt.corpus <- tm_map(twt.corpus,removePunctuation)
twt.corpus <- tm_map(twt.corpus,removeNumbers)
twt.corpus <- tm_map(twt.corpus,stripWhitespace)
twt.corpus <- tm_map(twt.corpus,PlainTextDocument)

library(wordcloud)
wordcloud(twt.corpus,max.words = 200, random.color = TRUE, random.order = TRUE, colors = brewer.pal(12,"Set3"))

