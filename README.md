# Technical overview

This project is built using blockchain data and R with Shiny package for web applications

## Prerequisities

- Git 
- R + Rstudio [check here](https://larmarange.github.io/analyse-R/installation-de-R-et-RStudio.html)
- curiosity ^_^

## Run the project on localhost

Clone the project using git by executing 

``` git clone https://github.com/luaroncrew/shiny_analysis.git ```

Open the project in Rstudio by doint ``` new project -> existing directory -> <local repo root> ```

then you have to install all the required libraries to run the project.

Run the ``` requirements.R ``` file to install all the libraries and add them to the environment

Then open the ``` app.R ``` file and click on the "run app" button

The project will be accessible on ``` http://127.0.0.1:<port> ``` using any explorers

## Data sources overview
All data used in this project can be found in ``` data/raw ``` directory
Some very interesting details about data extraction can be found in the Rmd files of this project

### transactions.csv
source: NEAR blockchain
The data source for this file is NEAR blockchain. 
To extract the data from the blockchain we used the NEAR indexer (an sql database connected directly to the blockchain),
the specifications and the indexer's code can be found [here](https://github.com/near/near-indexer-for-explorer)
With a simple sql query and a transformation on Python we could get this data.

### symbols.csv
source: REF.Finance - the biggest financial application in the ecosystem
This data is the result of the GET api call on 

``` https://api.stats.ref.finance/api/ft ```

### prices.csv
source: Coingecko

This data is the result of multiple api calls on merged in csv using python:

```Python
token_data = []
# joining the token address, number of decimals, its id on Coingecko if the token is present there
for address in unique_token_addresses:
    token_symbol = None
    token_decimals = None
    token_id = None
    for coin in near_coins:
        if coin['token_account_id'] == address:
            token_symbol = coin['symbol']
            token_decimals = coin['decimals']
    for available_coin in coin_list:
        if available_coin['symbol'].lower() == token_symbol.lower():
            token_id = available_coin['id']

    if token_symbol is None or token_id is None or token_decimals is None:
        continue

    token_data.append({
        'id': token_id,
        'address': address,
        'decimals': token_decimals
    })

# variable names we are going to have in the export
export_headers = [
    'price_usd',
    'token_address',
    'token_id_coingecko',
    'decimals',
    'day'
]

tokens_prices.writerow(export_headers)

# requesting the Coingecko api to get the price data for each token for each day
# time.sleep() to avoid exceeding the api limits
for token in token_data:
    for day in unique_days:
        day = day.replace('-22', '-2022')
        time.sleep(2)
        history = requests.get(
            f'https://api.coingecko.com/api/v3/coins/{token["id"]}/history?date={day}'
        ).json()
        # if we get all the data we need from the request, adding the token data to export
        if history.get('market_data'):
            market_data = history['market_data']
            if market_data.get('current_price'):
                current_price = market_data['current_price']
                if current_price.get('usd'):
                    usd_price = current_price['usd']
                    row = [
                        usd_price,
                        token["address"],
                        token["id"],
                        token["decimals"],
                        day
                    ]
                    tokens_prices.writerow(row)

export_file.close()
```
### token-ids.csv
Source: Coingecko

request on api: ``` /coins/list ```


# Document fonctionnel utilisateur

## Le projet  

Le projet Tradestats consiste en la rÃ©alisation d'une application R Shiny qui sera par la suite publiÃ©e et donc accessible sur internet via Shinyapps.io.  
Nous avons rÃ©alisÃ© plusieurs documents pour rÃ©pondre au sujet, nous pouvons trouver sur GitHub (espace de partage de documents) un document qui explique comment Ã  Ã©tÃ© rÃ©alisÃ© le projet, avec les spÃ©cifications techniques, le fichier brut contenant le code crÃ©ant l'application Shiny, un Document R.Markdown retraÃ§ant la source de donnÃ©es, les informations prÃ©sentes dans le jeu de donnÃ©es, quelques indicateurs statistiques et plusieurs graphiques prÃ©sents dans l'application. Tout ceci dans l'objectif de rÃ©pondre Ã  la problÃ©matique posÃ©e.  

## La problÃ©matique  

Nous avons dÃ©cidÃ© de centrer notre projet sur l'Ã©tude de la blockchain, les transactions associÃ©es Ã  ses Ã©changes et les traders concernÃ©s.  
C'est pourquoi nous avons dÃ©cidÃ© de poser la problÃ©matique suivante Â« Quelles sont les habitudes des traders sur la blockchain ? Â» pour mieux comprendre le comportement des personnes sur la bourse et voir s'il y a un modÃ¨le particulier utilisÃ© par les traders ou des transactions phares.  
Pour rÃ©pondre Ã  cette question, nous avons dÃ©veloppÃ© une application R Shiny basÃ©e sur des donnÃ©es extraites elles-mÃªmes de la blockchain.  

## Les éléments du repository 

Nous pouvons trouver dans le repository de GitHub plusieurs fichiers qui ont tous servit à la création de l'application R Shiny.  
D'abord il y a le README qui correspond à la document technique et utilisateur pour mieux comprendre comment utiliser l'application et avoir une explication du fonctionnement et des méthodes utilisées pour sa création.   
Il y a aussi les fichiers source qui contiennet les données utilisées pour faire les analyses graphiques et statistiques.  
Nous avons aussi placé le code brut commenté du R Shiny avec ces modifications.  
Ainsi qu'un document permettant de comprendre le projet, les données, le but de l'analyse avant d'ouvrir l'application Shiny.  

## L'application  

Notre application se prÃ©sente sous la forme de plusieurs volets se concentrant chacun sur un thÃ¨me particulier, ce qui nous permettra aprÃ¨s de fournir des conclusions et rÃ©pondre Ã  la problÃ©matique.  
Nous pouvons y voir le nom du projet en haut Ã  gauche, puis dans un premier temps un rappel de la problÃ©matique. Ensuite, sur la gauche, nous trouvons la fenÃªtre qui permettra de naviguer entre les diffÃ©rents volets qui contiennent les graphiques et analyses. Trois volets sont prÃ©sents, un focus sur les symboles utilisÃ©s, les transactions rÃ©alisÃ©es, les habitudes des traders.  

## L'utilisation de Tradestats  

Pour bien utiliser l'application, il faut d'abord prendre connaissance de la problÃ©matique, puis suivre l'ordre des diffÃ©rents volets en cliquant dessus pour voir les analyses, les graphiques et tableaux prÃ©sents dans chacun d'entre eux. Les filtres prÃ©sents servent Ã  voir en dÃ©tails les donnÃ©es afin d'axer l'analyse sur une dimension particuliÃ¨re.  

## Les conclusions Ã  faire ressortir  

Dans les diffÃ©rents volets, les graphiques et statistiques prÃ©sents apportent des rÃ©ponses en lien avec la problÃ©matique pour finaliser la rÃ©ponse attendue sur les habitudes des traders sur la blockchain.  
Le focus sur les symboles utilisÃ©s nous montre que pour une majoritÃ© des transactions, le mÃªme symbole est utilisÃ©, ainsi, nous pouvons identifier une premiÃ¨re habitude des traders et un choix distinct entre les diffÃ©rents symboles.   
Le focus sur les transactions rÃ©alisÃ©es nous montre que  
Le focus sur les habitudes des traders illustre le fait que beaucoup de transactions reprÃ©sentent un volume entre 0 et 200 dollars. Pour une transaction, l'argent dÃ©placÃ© est de faible volume, trÃ¨s peu sont supÃ©rieures Ã  900 dollars.   

