# Packages
library("janeaustenr")
library("dplyr")
library("tidytext")
library("ggplot2")

texts_austen <- austen_books()

# Pride and Prejudice
words_book <- texts_austen %>% unnest_tokens(word, text) %>% group_by(book) %>% count(book, word, sort = TRUE)

# Most important words in the text "Pride and Prejudice"
books_tf_idf <- words_book %>% bind_tf_idf(word, book, n)

pride_tf_idf <- books_tf_idf %>% filter(book == 'Pride & Prejudice')

# Plotting graph
words_book_graph <- pride_tf_idf %>%
  slice_max(tf_idf, n = 15) %>%
  mutate(word = reorder(word, tf_idf))

words_book_graph %>% ggplot(aes(tf_idf, word, fill = book)) +
  geom_col(show.legend = FALSE) +
  labs(x = "tf_idf", y = NULL) +
  facet_wrap(~book, ncol = 2, scales = "free")
