beginning.path <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/'
dashboard.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Dashboard Tab/'
downloadFiles.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Download Files Tab/'
monthlyExpander.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Monthly Expander Tab/'
searchPerssonel.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Search Personnel Tab/'

# The list of valid books
books <<- list("The Iliad" = "WordCloud txt files/iliad",
               "The Odyssey" = "WordCloud txt files/odyssey",
               "Beowulf" = "WordCloud txt files/beowulf",
               "Romeo and Juliet" = "WordCloud txt files/romeo")

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {
      # Careful not to let just any name slip in here; a
      # malicious user could manipulate this value.
      if (!(book %in% books))
            stop("Unknown book")
      
      text <- readLines(sprintf("./%s.txt", book),
                        encoding="UTF-8")
      
      myCorpus = Corpus(VectorSource(text))
      myCorpus = tm_map(myCorpus, content_transformer(tolower))
      myCorpus = tm_map(myCorpus, removePunctuation)
      myCorpus = tm_map(myCorpus, removeNumbers)
      myCorpus = tm_map(myCorpus, removeWords,
                        c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
      
      myDTM = TermDocumentMatrix(myCorpus,
                                 control = list(minWordLength = 1))
      
      m = as.matrix(myDTM)
      
      sort(rowSums(m), decreasing = TRUE)
})

