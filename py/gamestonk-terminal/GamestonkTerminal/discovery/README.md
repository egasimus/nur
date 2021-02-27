# DISCOVER STOCKS

This menu aims to discover new stocks, and the usage of the following commands along with an example will be exploited below.

  * [map](#map)    
    - S&P500 index stocks map [Finviz]
  * [sectors](#sectors)       
    - show sectors performance [Alpha Vantage]
  * [gainers](#gainers)
    - show latest top gainers [Yahoo Finance]
  * [orders](#orders)
    - orders by Fidelity Customers [Fidelity]
  * [up_earnings](#up_earnings)
    - upcoming earnings release dates [Seeking Alpha]
  * [high_short](#high_short)   
    - show top high short interest stocks of over 20% ratio [www.highshortinterest.com]
  * [low_float](#low_float)
    - show low float stocks under 10M shares float [www.lowfloat.com]
  * [simply_wallst](#simply_wallst)            
    - Simply Wall St. research data [Simply Wall St.]
  * [spachero](#spachero)
    - great website for SPACs research [SpacHero]
  * [uwhales](#uwhales)
    - good website for SPACs research [UnusualWhales]

## map <a name="map"></a>

```
usage: map [-p {1d,1w,1m,3m,6m,1y}] [-t {sp500,world,full,etf}]
```
Performance index stocks map categorized by sectors and industries. Size represents market cap. Opens web-browser. [Source: Finviz]
  * -p : Performance period. Default 1 day.
  * -t : Map filter type. Default S&P500.

![map_filter](https://user-images.githubusercontent.com/25267873/108570986-032a4800-7307-11eb-8c8d-f62409c11e06.png)


## sectors <a name="sectors"></a>
```
usage: sectors
```
Real-time and historical sector performances calculated from S&P500 incumbents. Pops plot in terminal. [Source: Alpha Vantage]

![sectors](https://user-images.githubusercontent.com/25267873/108572267-d297dd80-7309-11eb-863b-20cfe3012c30.png)


## gainers <a name="gainers"></a>
```
usage: gainers [-n {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24}]
```
Print up to 25 top ticker gainers in terminal. [Source: Yahoo Finance]
  * -n : Number of the top gainers stocks to retrieve. Default 5.

<img width="935" alt="Captura de ecrã 2021-02-20, às 11 46 09" src="https://user-images.githubusercontent.com/25267873/108594319-46b99c00-7371-11eb-877e-ef75d3ba472b.png">


## orders <a name="orders"></a>
```
usage: orders [-n N_NUM]
```
Orders by Fidelity customers. Information shown in the table below is based on the volume of orders entered on the "as of" date shown. Securities identified are not recommended or endorsed by Fidelity and are displayed for informational purposes only. [Source: Fidelity]
  * -n : Number of top ordered stocks to be printed. Default 10.

<img width="945" alt="Captura de ecrã 2021-02-20, às 11 45 43" src="https://user-images.githubusercontent.com/25267873/108594318-45886f00-7371-11eb-919f-fd1bce6d4001.png">


## up_earnings <a name="up_earnings"></a>
```
usage: up_earnings [-p N_PAGES] [-n N_NUM]
```
Print upcoming earnings release dates. [Source: Seeking Alpha]
  * -p : Number of pages to read upcoming earnings from in Seeking Alpha website. Default 10.
  * -n : Number of upcoming earnings release dates to print. Default 3.

<img width="933" alt="Captura de ecrã 2021-02-20, às 11 45 24" src="https://user-images.githubusercontent.com/25267873/108594317-45886f00-7371-11eb-85e6-03d839d421b3.png">


## high_short <a name="high_short"></a>
```
usage: high_short [-n N_NUM]
```
Print top stocks being more heavily shorted. HighShortInterest.com provides a convenient sorted database of stocks which have a short interest of over 20 percent. Additional key data such as the float, number of outstanding shares, and company industry is displayed. Data is presented for the Nasdaq Stock Market, the New York Stock Exchange, and the American Stock Exchange. Stocks with high short interest are often very volatile and are well known for making explosive upside moves (known as a short squeeze). [Source: www.highshortinterest.com]
  * -n : Number of top stocks to print

<img width="940" alt="Captura de ecrã 2021-02-20, às 11 45 02" src="https://user-images.githubusercontent.com/25267873/108594316-45886f00-7371-11eb-8ded-94fbe28ac84c.png">


## low_float <a name="low_float"></a>
```
usage: low_float [-n N_NUM]
```
Print top stocks with lowest float. LowFloat.com provides a convenient sorted database of stocks which have a float of under 10 million shares. Additional key data such as the number of outstanding shares, short interest, and company industry is displayed. Data is presented for the Nasdaq Stock Market, the New York Stock Exchange, the American Stock Exchange, and the Over the Counter Bulletin Board. [Source: www.lowfloat.com]
  * -n : Number of top stocks to print

<img width="942" alt="Captura de ecrã 2021-02-20, às 11 44 39" src="https://user-images.githubusercontent.com/25267873/108594315-44efd880-7371-11eb-9be7-7ae02999fd09.png">


## simply_wallst <a name="simply_wallst"></a>
```
usage: simply_wallst [-i {any,automobiles,banks,capital-goods,commercial-services,consumer-durables,consumer-services,diversified-financials,energy,consumer-retailing,food-beverage-tobacco,healthcare,household,insurance,materials,media,pharmaceuticals-biotech,real-estate,retail,semiconductors,software,tech,telecom,transportation,utilities}]
```
Simply Wall Street Research. Opens web browser. Although this does not require an API key, it requires a subscription to the website by the user (there's a 14 days free trial). [Source: Simply Wall St.]
  * -i : Industry of interest

<img width="1200" alt="sw" src="https://user-images.githubusercontent.com/25267873/108576534-dfbac980-7315-11eb-9350-254fb9b64773.png">


## spachero <a name="spachero"></a>
```
usage: spachero
```
Great website for SPACs research. [Source: www.spachero.com]

<img width="1265" alt="Captura de ecrã 2021-02-20, às 01 12 14" src="https://user-images.githubusercontent.com/25267873/108577430-f282cd80-7318-11eb-888b-82dcf90d4f32.png">


## uwhales <a name="uwhales"></a>
```
usage: uwhales
```
Good website for SPACs research. [Source: www.unusualwhales.com]

<img width="1247" alt="Captura de ecrã 2021-02-20, às 11 38 54" src="https://user-images.githubusercontent.com/25267873/108594176-47056780-7370-11eb-8f2d-5972c8634974.png">

