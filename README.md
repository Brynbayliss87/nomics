# Nomics Api

## How to run
To start clone the app and then either run
`thin -R config.ru start` to start the server locally
or to run using docker `docker-compose build` then `docker-compose up`
this was built running on ruby 2.7.2

## Endpoints

This application surfaces two endpoints:

`GET /currencies`

Which returns a list of of the specified currencies

it takes the following query string parameters:

| Name | Type | Description | Example |
| ---- | ---- | ----------- | ------- |
| tickers | Comma separated array | The list of desired currencies (required) | `?tickers=BTC,ETH` |
| fields  | Comma separated array| A list of the desired returned fields (optional) | `?fields=name,price,max_supply` |
| convert  | String | A fiat currency e.g USD, GBP from which to return the desired currencies price (optional) | `?convert=GBP`|

`GET /comparative_dollar_prices`

Which returns the value of one currency compared to another, in relation to their dollar value

it takes the following query string parameters:

| Name | Type | Description | Example |
| ---- | ---- | ----------- | ------- |
| from | String | The currency to convert from (required) | `?from=BTC` |
| to  | String | The currency to convert to (required) | `?to=ETH` |

so `GET /comparative_dollar_prices?from=BTC&toETH` will return the percentage 1
ETH compares to 1 BTC in comparison to their USD values

