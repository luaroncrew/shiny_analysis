transactions = read.csv('transactions.csv')
token_ids = read.csv('token_ids.csv')
symbols = read.csv('symbols.csv')
prices = read.csv('prices.csv')


# join the token_symbol for token_in
analysis_dataframe = merge(
  x = transactions,
  y = symbols,
  by.x = "token_in_address",
  by.y = "token_address",
  all.x = TRUE
  )

names(analysis_dataframe)[length(names(analysis_dataframe))]= 'token_in_symbol'

# join the token_symbol for token_out
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = symbols,
  by.x = "token_out_address",
  by.y = "token_address",
  all.x = TRUE
)


names(analysis_dataframe)[length(names(analysis_dataframe))]= 'token_out_symbol'

names(analysis_dataframe)[7] = 'decimals_token_in'
analysis_dataframe[9] = NULL

# making all symbols lowercase
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

analysis_dataframe$token_id.x = NULL
names(analysis_dataframe)[10] = 'token_in_id'


analysis_dataframe = merge(
  x = analysis_dataframe,
  y = prices,
  by.x = c('token_in_id', 'day'),
  by.y = c('token_id_coingecko', 'day'),
  all.x = TRUE
)

# remove all the NULL values
analysis_dataframe <- na.omit(analysis_dataframe) 

# remove doubled swaps
analysis_dataframe = unique(analysis_dataframe[c(
  "receipt_id",
  "token_in_name",
  "token_in_symbol",
  ""
)])

analysis_dataframe$token_symbol

analysis_dataframe = merge(
  x = analysis_dataframe,
  y = 
)


data = read.csv('faucet.csv')
