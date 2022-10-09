transactions = read.csv('data/raw/transactions.csv')
token_ids = read.csv('data/raw/token_ids.csv')
symbols = read.csv('data/raw/symbols.csv')
prices = read.csv('data/raw/prices.csv')


# join the token_symbol for token_in
analysis_dataframe = merge(
  x = transactions,
  y = symbols,
  by.x = "token_in_address",
  by.y = "token_address",
  all.x = TRUE
  )

# rename the column
names(analysis_dataframe)[length(names(analysis_dataframe))]= 'token_in_symbol'

# join the token_symbol for token_out
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = symbols,
  by.x = "token_out_address",
  by.y = "token_address",
  all.x = TRUE
)

# rename the column
names(analysis_dataframe)[length(names(analysis_dataframe))] = 'token_out_symbol'

# rename another column
names(analysis_dataframe)[7] = 'decimals_token_in'
analysis_dataframe[9] = NULL

# making all symbols lowercase for merging
ech = analysis_dataframe$token_in_symbol
lower = tolower(ech)
analysis_dataframe$token_in_symbol = lower
ech = analysis_dataframe$token_out_symbol
lower = tolower(ech)
analysis_dataframe$token_out_symbol = lower


# join the token_id for token_in_symbol
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = token_ids,
  by.x = "token_in_symbol",
  by.y = "token_symbol",
  all.x = TRUE,
  all.y = FALSE
)


# being given the id, get the price at a day
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = token_ids,
  by.x = "token_in_symbol",
  by.y = "token_symbol",
  all.x = TRUE
)

# delete useless column after merge and rename one
analysis_dataframe$token_id.x = NULL
names(analysis_dataframe)[10] = 'token_in_id'

# merge with prices by day
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = prices,
  by.x = c('token_in_id', 'day'),
  by.y = c('token_id_coingecko', 'day'),
  all.x = TRUE
)

# remove all the NULL values
analysis_dataframe = na.omit(analysis_dataframe) 

# remove doubled entries
analysis_dataframe = unique(analysis_dataframe)

# calculate volumes being given all the merged information
analysis_dataframe$volume = (analysis_dataframe$amount_in / (10 ** analysis_dataframe$decimals_token_in)) * analysis_dataframe$price_usd

write.csv(analysis_dataframe,"data/final/swap_operations.csv", row.names = TRUE)
