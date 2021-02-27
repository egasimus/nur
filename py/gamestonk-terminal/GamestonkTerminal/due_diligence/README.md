# DUE DILIGENCE

This menu aims to help in due-diligence of a pre-loaded stock, and the usage of the following commands along with an example will be exploited below.

  * [news](#news)
    - latest news of the company [Finviz]
  * [red](#red)
    - gets due diligence from another user's post [Reddit]
  * [analyst](#analyst)
    - analyst prices and ratings of the company [Finviz] 
  * [rating](#rating)
    - rating of the company from strong sell to strong buy [FMP]
  * [pt](#pt)
    - price targets over time [Business Insider] 
  * [est](#est)
    - quarter and year analysts earnings estimates [Business Insider]
  * [ins](#ins)
    - insider activity over time [Business Insider]
  * [insider](#insider)
    - insider trading of the company [Finviz]
  * [sec](#sec)
    - SEC filings [Market Watch]
  * [short](#short)
    - short interest [Quandl]
  * [warnings](#warnings)
    - company warnings according to Sean Seah book [Market Watch]

## news <a name="news"></a>
```
news [-n N_NUM]
```
Prints latest news about company, including title and web link. [Source: Finviz]
  * -n : Number of latest news being printed. Default 5.

<img width="939" alt="news" src="https://user-images.githubusercontent.com/25267873/108609254-a8572600-73c4-11eb-9497-75530c50e82c.png">


## red <a name="red"></a>
```
usage: red [-l N_LIMIT] [-d N_DAYS] [-a]
```
Print top stock's due diligence from other users. [Source: Reddit]
  * -l : limit of posts to retrieve
  * -d : number of prior days to look for
  * -a : "search through all flairs (apart from Yolo and Meme). Default False (i.e. use flairs: DD, technical analysis, Catalyst, News, Advice, Chart)

<img width="950" alt="red" src="https://user-images.githubusercontent.com/25267873/108609417-a2ae1000-73c5-11eb-8f3c-54c76b418e14.png">


## analyst <a name="analyst"></a>
```
usage: analyst 
```
Print analyst prices and ratings of the company. The following fields are expected: date, analyst, category, price from, price to, and rating. [Source: Finviz]

<img width="938" alt="analyst" src="https://user-images.githubusercontent.com/25267873/108609253-a8572600-73c4-11eb-9629-6c192fc2907c.png">


## rating <a name="rating"></a>
```
usage: rating
```
Based on specific ratios, prints information whether the company is a (strong) buy, neutral or a (strong) sell. The following fields are expected: P/B, ROA, DCF, P/E, ROE, and D/E. [Source: Financial Modeling Prep]
<img width="922" alt="rating" src="https://user-images.githubusercontent.com/25267873/108609444-d0935480-73c5-11eb-9f14-4fefa67f41ee.png">


## pt <a name="pt"></a>
```
usage: pt [-n N_NUM]
```
Prints price target from analysts. [Source: Business Insider]
  * -n : number of latest price targets from analysts to print. Default 10.

![pt](https://user-images.githubusercontent.com/25267873/108609888-fec66380-73c8-11eb-8c2f-04ceaac6f3f5.png)

<img width="940" alt="pt2" src="https://user-images.githubusercontent.com/25267873/108609914-3af9c400-73c9-11eb-8820-0abfa9e57119.png">


## est <a name="est"></a>
```
usage: est
```
Yearly estimates and quarter earnings/revenues [Source: Business Insider]

<img width="933" alt="est" src="https://user-images.githubusercontent.com/25267873/108609498-3089fb00-73c6-11eb-991d-656d69beb685.png">


## ins <a name="ins"></a>
```
usage: ins [-n N_NUM]
```
Prints insider activity over time [Source: Business Insider]
  * -n : number of latest insider activity. Default 10.

![ins](https://user-images.githubusercontent.com/25267873/108609248-a725f900-73c4-11eb-9442-1ba3a0bf45ba.png)
<img width="935" alt="ins2" src="https://user-images.githubusercontent.com/25267873/108609249-a7be8f80-73c4-11eb-8685-1cddbed5421e.png">


## insider <a name="insider"></a>
```
usage: insider [-n N_NUM]
```
Prints information about inside traders. The following fields are expected: Date, Relationship, Transaction, #Shares, Cost, Value ($), #Shares Total, Insider Trading, SEC Form 4. [Source: Finviz]
  * -n : number of latest inside traders. Default 5.

<img width="937" alt="insider" src="https://user-images.githubusercontent.com/25267873/108609258-a9885300-73c4-11eb-971e-ce84ee9dd94b.png">


## sec <a name="sec"></a>
```
usage: sec [-n N_NUM]
```
Prints SEC filings of the company. The following fields are expected: Filing Date, Document Date, Type, Category, Amended, and Link. [Source: Market Watch]
  * -n : number of latest SEC filings. Default 5.

<img width="967" alt="sec" src="https://user-images.githubusercontent.com/25267873/108609256-a8efbc80-73c4-11eb-97cc-3c819aebc795.png">


## short <a name="short"></a>
```
usage: short [-n] [-d N_DAYS]
```
Plots the short interest of a stock. This corresponds to the number of shares that have been sold short but have not yet been covered or closed out. [Source: Quandl]
  * -n : data from NYSE flag. Default False (i.e. NASDAQ).
  * -d : number of latest days to print data. Default 10.
                                     
![short](https://user-images.githubusercontent.com/25267873/108609247-a68d6280-73c4-11eb-80b3-b8effa6988f1.png)
<img width="967" alt="short2" src="https://user-images.githubusercontent.com/25267873/108609259-a9885300-73c4-11eb-9f37-64b78746cec3.png">


## warnings <a name="warnings"></a>
```
usage: warnings [-i] [-d]
```
Sean Seah warnings. Check: Consistent historical earnings per share; Consistently high return on equity; Consistently high return on assets; 5x Net Income > Long-Term Debt; and Interest coverage ratio more than 3. See https://www.drwealth.com/gone-fishing-with-buffett-by-sean-seah/comment-page-1/. [Source: Market Watch]
  * -i : provide more information about Sean Seah warning rules. Default False.
  * -d : print insights into warnings calculation. Default False.                        

<img width="927" alt="warnings" src="https://user-images.githubusercontent.com/25267873/108609497-2ec03780-73c6-11eb-8577-d5da80dae213.png">
