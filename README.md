# relevant-terms

Playing around with common patterns in texts. Looks at the frequency of patterns like 'X in the Y', where X and Y can be any word not common enough.

## Howto use?

```
min_frequence_word_interest=2
max_frequency_noise_word=2
max_gram_length=7
freq = Frequency.new(lines_of_text,min_frequence_word_interest,max_frequency_noise_word, max_gram_length)
```
