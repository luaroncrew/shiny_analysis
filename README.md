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

Le projet Tradestats consiste en la realisation d'une application R Shiny qui sera par la suite publiee et donc accessible sur internet via Shinyapps.io.  
Nous avons realise plusieurs documents pour repondre au sujet, nous pouvons trouver sur GitHub (espace de partage de documents) un document qui explique comment a ete realise le projet, avec les specifications techniques, le fichier brut contenant le code creant l'application Shiny, un Document R.Markdown retracant la source de donnees, les informations presentes dans le jeu de donnees, quelques indicateurs statistiques et plusieurs graphiques presents dans l'application. Tout ceci dans l'objectif de repondre a la problematique posee.  

## La problematique  

Nous avons decide de centrer notre projet sur l'etude de la blockchain, les transactions associees a ses echanges et les traders concernes.  
C'est pourquoi nous avons decide de poser la problematique suivante : Quelles sont les habitudes des traders sur la blockchain ?  
Pour mieux comprendre le comportement des personnes sur la bourse et voir s'il y a un modele particulier utilise par les traders ou des transactions phares.  
Pour repondre a cette question, nous avons developpe une application R Shiny basee sur des donnees extraites elles-memes de la blockchain.  

## Les elements du repository 

Nous pouvons trouver dans le repository de GitHub plusieurs fichiers qui ont tous servit a la creation de l'application R Shiny.  
D'abord il y a le README qui correspond a la documentation technique et utilisateur pour mieux comprendre comment utiliser l'application et avoir une explication du fonctionnement et des methodes utilisees pour sa creation.   
Il y a aussi les fichiers source qui contiennet les donnees utilisees pour faire les analyses graphiques et statistiques.  
Nous avons aussi place le code brut commente du R Shiny avec ses modifications.  
Ainsi qu'un document permettant de comprendre le projet, les donnees, le but de l'analyse avant d'ouvrir l'application Shiny.  

## La connexion a la base de donnees

Afin de connecter l'application R Shiny a une base de donnees, nous avons importe nos donnees CSV dans un systeme de gestion de base de donnees. Nous avons choisi SQLite pour realise cette partie. Une fois la base creee, nous l'avons inseree dans le code de l'application au sein d'une boucle if. Ainsi, comme la base de donnees est presente en local, il est impossible d'ouvrir l'application si la personne ne possede pas la base dans un server cloud. La boucle if permet de tester cette possibilite et de l'inclure ou non dans le code. Si aucune base correspondante n'est trouvee, l'application se connectera au fichier CSV presents dans le dossier data/final de GitHub.

## L'application  

Notre application se presente sous la forme de plusieurs volets se concentrant chacun sur un theme particulier, ce qui nous permettra apres de fournir des conclusions et repondre a la problematique.  
Nous pouvons y voir le nom du projet en haut a gauche, puis dans un premier temps un rappel de la problematique. Ensuite, sur la gauche, nous trouvons la fenetre qui permettra de naviguer entre les differents volets qui contiennent les graphiques et analyses. Trois volets sont presents, un focus sur les analyses journalières, sur les symboles, sur les transactions realisees avec leur volume, les habitudes des traders.  

## L'utilisation de Tradestats  

Pour bien utiliser l'application, il faut d'abord prendre connaissance de la problematique, puis suivre l'ordre des differents volets en cliquant dessus pour voir les analyses, les graphiques et tableaux presents dans chacun d'entre eux. Les filtres presents servent a voir en details les donnees afin d'axer l'analyse sur une dimension particuliere.  

## Les conclusions a faire ressortir  

Dans les differents volets, les graphiques et statistiques presents apportent des reponses en lien avec la problematique pour finaliser la reponse attendue sur les habitudes des traders sur la blockchain.  
Le focus sur les symboles utilises nous montre que pour une majorite des transactions, le meme symbole est utilise, ainsi, nous pouvons identifier une premiere habitude des traders et un choix distinct entre les differents symboles.   
Le focus sur les transactions realisees nous montre que chacune est differente que ce soit par rapport au trader concerne, au volume, au prix, il n'y en a pas deux identiques.  
Le focus sur les habitudes des traders illustre le fait que beaucoup de transactions representent un volume entre 0 et 200 dollars. Pour une transaction, l'argent deplace est de faible volume, tres peu sont superieures a 900 dollars.   

Ainsi nous pouvons en conclure que chaque transaction est differente, il n'y a pas forcement de schemas qui se repete, mais des tendances s'observent tout de meme, ou du moins sur le jeu de donnees etudie.

