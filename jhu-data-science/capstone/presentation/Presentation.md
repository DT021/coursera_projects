Autocompletion App
========================================================
author: Tyler Burleigh
date: 2019-07-28
autosize: true

**App:** https://wizzywig.shinyapps.io/TextPredictor

**Source code:** 


Why make this?
========================================================

### Problem
People spend a lot of time on mobile devices, but typing on these devices can
be a serious pain. 

### Solution
To make the experience better for users, I made an app that will predict the 
next word they're going to type, and allow them to press a button to insert this 
word into their text, rather than type it out themselves. This saves them the
time and effort of typing.


How it works
========================================================

To create this autocomplete app, I followed these steps:

1. **Collect training data.** I first obtained texts from Twitter, news sites, and blog posts. 
2. **Clean data.** I removed null lines and non-ASCII characters from the texts.
3. **Extract ngrams.** I used `quanteda` to extract ngrams (1-grams to 5-grams) from texts. 
4. **Build models.** I created predictive models by grouping ngrams and counting frequencies.
5. **Reduce models.** I reduced the models to minimize memory demands, by taking the 5% highest frequency
ngrams in each ngram set.
6. **Create algorithm.** I created a backoff algorithm that takes user input and searches
through the ngram models, starting with 5gram and working backwards until it finds a match, returning
the highest frequency ngram that did match.


How it works (continued)
========================================================

Finally, I created a Shiny app that takes user input, and uses as many 
words as it can from what they enter with the backoff model. If they enter 4 words or 
more into the text box, it tries to find a 5-gram match, returning the highest frequency ngram that matched. 
If it doesn't find a 5-gram match, it searches 4-gram, 3-gram, and 2-gram models using the last 3, 2, and 1 words entered. If it still doesn't find a match, then it picks one of the top-15 most frequently used 
unigrams at random.

The app works similar to current autocomplete features in smartphone keyboards.
As the user types, it predicts the next word and presents the user with a button
that they can press to add that predicted word to their text.



App performance
========================================================

In my own testing, I found that the app is fast and has a relatively small 
memory footprint. I used `proc.time()` to test speed, `pryr::mem_used()` to
test memory usage, and Chrome devtools to test load time.

* Average time to predict next word is 125ms
* Memory usage is 189MB
* App load time is 1.5 seconds

I think this is acceptable performance, but if necessary the app could be optimized 
even further. For example, the ngram models could be reduced further to reduce
memory usage and response time.


