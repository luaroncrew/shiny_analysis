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

ech = analysis_dataframe['token_in_symbol'][]
analysis_dataframe['token_in_symbol'] = tolower(analysis_dataframe$token_in_symbol)

# join the token_id for token_in_symbol
analysis_dataframe = merge(
  x = analysis_dataframe,
  y = token_ids,
  by.x = "token_in_symbol",
  by.y = "token_symbol",
  all.x = TRUE
)


#


analysis_dataframe$token_symbol

analysis_dataframe = merge(
  x = analysis_dataframe,
  y = 
)


data = read.csv('faucet.csv')
