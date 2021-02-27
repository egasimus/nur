from alpha_vantage.fundamentaldata import FundamentalData
import config_terminal as cfg
import argparse
from helper_funcs import *
import pandas as pd
import json
import requests
from pandas.io.json import json_normalize


# ---------------------------------------------------- OVERVIEW ----------------------------------------------------
def overview(l_args, s_ticker):
    parser = argparse.ArgumentParser(prog='overview', 
                                     description="""Prints an overview about the company. The following fields are expected: 
                                     Symbol, Asset type, Name, Description, Exchange, Currency, Country, Sector, Industry, 
                                     Address, Full time employees, Fiscal year end, Latest quarter, Market capitalization, 
                                     EBITDA, PE ratio, PEG ratio, Book value, Dividend per share, Dividend yield, EPS, 
                                     Revenue per share TTM, Profit margin, Operating margin TTM, Return on assets TTM, 
                                     Return on equity TTM, Revenue TTM, Gross profit TTM, Diluted EPS TTM, Quarterly earnings growth YOY, 
                                     Quarterly revenue growth YOY, Analyst target price, Trailing PE, Forward PE, 
                                     Price to sales ratio TTM, Price to book ratio, EV to revenue, EV to EBITDA, Beta, 52 week high, 
                                     52 week low, 50 day moving average, 200 day moving average, Shares outstanding, Shares float, 
                                     Shares short, Shares short prior month, Short ratio, Short percent outstanding, Short percent float, 
                                     Percent insiders, Percent institutions, Forward annual dividend rate, Forward annual dividend yield, 
                                     Payout ratio, Dividend date, Ex dividend date, Last split factor, and Last split date. 
                                     [Source: Alpha Vantage]""")
        
    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        # Request OVERVIEW data from Alpha Vantage API
        s_req = f"https://www.alphavantage.co/query?function=OVERVIEW&symbol={s_ticker}&apikey={cfg.API_KEY_ALPHAVANTAGE}"      
        result = requests.get(s_req, stream=True)
        
        # If the returned data was successful
        if result.status_code == 200:
            # Parse json data to dataframe
            df_fa = json_normalize(result.json())
            # Keep json data sorting in dataframe
            df_fa = df_fa[list(result.json().keys())].T
            df_fa = df_fa.applymap(lambda x: long_number_format(x))
            df_fa.index = [''.join(' ' + char if char.isupper() else char.strip() for char in idx).strip() for idx in df_fa.index.tolist()]
            df_fa.index = [s_val.capitalize() for s_val in df_fa.index]
            df_fa = df_fa.rename(index={"E b i t d a":"EBITDA",
                                        "P e ratio":"PE ratio",
                                        "P e g ratio":"PEG ratio",
                                        "E p s":"EPS",
                                        "Revenue per share t t m":"Revenue per share TTM",
                                        "Operating margin t t m":"Operating margin TTM",
                                        "Return on assets t t m":"Return on assets TTM",
                                        "Return on equity t t m":"Return on equity TTM",
                                        "Revenue t t m":"Revenue TTM",
                                        "Gross profit t t m":"Gross profit TTM",
                                        "Diluted e p s t t m":"Diluted EPS TTM",
                                        "Quarterly earnings growth y o y":"Quarterly earnings growth YOY",
                                        "Quarterly revenue growth y o y":"Quarterly revenue growth YOY",
                                        "Trailing p e":"Trailing PE",
                                        "Forward p e":"Forward PE",
                                        "Price to sales ratio t t m":"Price to sales ratio TTM",
                                        "E v to revenue":"EV to revenue",
                                        "E v to e b i t d a":"EV to EBITDA"})

            pd.set_option('display.max_colwidth', -1)
            
            print(df_fa.drop(index=['Description']).to_string(header=False))
            print(f"Description: {df_fa.loc['Description'][0]}")
            print("")
        else:
            print(f"Error: {result.status_code}")
        print("")

    except:
        print("")
        return


# ------------------------------------------------------ KEY ------------------------------------------------------
def key(l_args, s_ticker):
    parser = argparse.ArgumentParser(prog='key', 
                                     description="""Gives main key metrics about the company (it's a subset of the 
                                     Overview data from Alpha Vantage API). The following fields are expected: 
                                     Market capitalization, EBITDA, EPS, PE ratio, PEG ratio, Price to book ratio, 
                                     Return on equity TTM, Payout ratio, Price to sales ratio TTM, Dividend yield, 
                                     50 day moving average, Analyst target price, Beta [Source: Alpha Vantage API]""")
        
    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        # Request OVERVIEW data
        s_req = f"https://www.alphavantage.co/query?function=OVERVIEW&symbol={s_ticker}&apikey={cfg.API_KEY_ALPHAVANTAGE}"
        result = requests.get(s_req, stream=True)
        
        # If the returned data was successful
        if result.status_code == 200:
            df_fa = json_normalize(result.json())
            df_fa = df_fa[list(result.json().keys())].T

            df_fa = df_fa.applymap(lambda x: long_number_format(x))
            df_fa.index = [''.join(' ' + char if char.isupper() else char.strip() for char in idx).strip() for idx in df_fa.index.tolist()]
            df_fa.index = [s_val.capitalize() for s_val in df_fa.index]
            df_fa = df_fa.rename(index={"E b i t d a":"EBITDA",
                                        "P e ratio":"PE ratio",
                                        "P e g ratio":"PEG ratio",
                                        "E p s":"EPS",
                                        "Return on equity t t m":"Return on equity TTM",
                                        "Price to sales ratio t t m":"Price to sales ratio TTM"})
            as_key_metrics = ["Market capitalization", "EBITDA", "EPS", "PE ratio", "PEG ratio", "Price to book ratio",
                        "Return on equity TTM", "Payout ratio", "Price to sales ratio TTM", "Dividend yield", 
                        "50 day moving average", "Analyst target price", "Beta"]
            print(df_fa.loc[as_key_metrics].to_string(header=False))
            print("")
        else:
            print(f"Error: {result.status_code}")

        print("")

    except:
        print("")
        return


# ---------------------------------------------------- INCOME_STATEMENT ----------------------------------------------------
def income_statement(l_args, s_ticker):
    parser = argparse.ArgumentParser(prog='incom', 
                                     description="""Prints a complete income statement over time. This can be either quarterly 
                                     or annually. The following fields are expected: Accepted date, Cost and expenses, Cost of 
                                     revenue, Depreciation and amortization, Ebitda, Ebitdaratio, Eps, Epsdiluted, Filling date, 
                                     Final link, General and administrative expenses, Gross profit, Gross profit ratio, Income 
                                     before tax, Income before tax ratio, Income tax expense, Interest expense, Link, Net income, 
                                     Net income ratio, Operating expenses, Operating income, Operating income ratio, Other expenses, 
                                     Period, Research and development expenses, Revenue, Selling and marketing expenses, Total other 
                                     income expenses net, Weighted average shs out, Weighted average shs out dil [Source: Alpha Vantage]""")

    parser.add_argument('-n', "--num", action="store", dest="n_num", type=check_positive, default=1, 
                        help='Number of latest years/quarters.')
    parser.add_argument('-q', "--quarter", action="store_true", default=False, dest="b_quarter", 
                        help='Quarter fundamental data flag.')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        if ns_parser.n_num == 1:
            pd.set_option('display.max_colwidth', -1)
        else:
            pd.options.display.max_colwidth = 40

        fd = FundamentalData(key=cfg.API_KEY_ALPHAVANTAGE, output_format='pandas')
        if ns_parser.b_quarter:
            df_fa, d_fd_metadata = fd.get_income_statement_quarterly(symbol=s_ticker)
        else:
            df_fa, d_fd_metadata = fd.get_income_statement_annual(symbol=s_ticker)

        df_fa = df_fa.set_index('fiscalDateEnding')
        df_fa = df_fa.head(n=ns_parser.n_num).T
        df_fa = df_fa.mask(df_fa.astype(object).eq(ns_parser.n_num*['None'])).dropna()
        df_fa = df_fa.mask(df_fa.astype(object).eq(ns_parser.n_num*['0'])).dropna()
        df_fa = df_fa.applymap(lambda x: long_number_format(x))
        df_fa.index = [''.join(' ' + char if char.isupper() else char.strip() for char in idx).strip() for idx in df_fa.index.tolist()]
        df_fa.index = [s_val.capitalize() for s_val in df_fa.index]
        df_fa.columns.name = "Fiscal Date Ending"
        print(df_fa)

        print("")

    except:
        print("")
        return
    

# ---------------------------------------------------- BALANCE_SHEET ----------------------------------------------------
def balance_sheet(l_args, s_ticker):
    parser = argparse.ArgumentParser(prog='balance', 
                                     description="""Prints a complete balance sheet statement over time. This can be 
                                     either quarterly or annually. The following fields are expected: Accepted date, 
                                     Account payables, Accumulated other comprehensive income loss, Cash and cash 
                                     equivalents, Cash and short term investments, Common stock, Deferred revenue, 
                                     Deferred revenue non current, Deferred tax liabilities non current, Filling date, 
                                     Final link, Goodwill, Goodwill and intangible assets, Intangible assets, Inventory, 
                                     Link, Long term debt, Long term investments, Net debt, Net receivables, Other assets, 
                                     Other current assets, Other current liabilities, Other liabilities, Other non current 
                                     assets, Other non current liabilities, Othertotal stockholders equity, Period, Property 
                                     plant equipment net, Retained earnings, Short term debt, Short term investments, Tax assets, 
                                     Tax payables, Total assets, Total current assets, Total current liabilities, Total debt, 
                                     Total investments, Total liabilities, Total liabilities and stockholders equity, Total 
                                     non current assets, Total non current liabilities, and Total stockholders equity. 
                                     [Source: Alpha Vantage]""")

    parser.add_argument('-n', "--num", action="store", dest="n_num", type=check_positive, default=1, 
                        help='Number of latest years/quarters.')
    parser.add_argument('-q', "--quarter", action="store_true", default=False, dest="b_quarter", 
                        help='Quarter fundamental data flag.')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        if ns_parser.n_num == 1:
            pd.set_option('display.max_colwidth', -1)
        else:
            pd.options.display.max_colwidth = 40

        fd = FundamentalData(key=cfg.API_KEY_ALPHAVANTAGE, output_format='pandas')
        if ns_parser.b_quarter:
            df_fa, d_fd_metadata = fd.get_balance_sheet_quarterly(symbol=s_ticker)
        else:
            df_fa, d_fd_metadata = fd.get_balance_sheet_annual(symbol=s_ticker)

        df_fa = df_fa.set_index('fiscalDateEnding')
        df_fa = df_fa.head(n=ns_parser.n_num).T
        df_fa = df_fa.mask(df_fa.astype(object).eq(ns_parser.n_num*['None'])).dropna()
        df_fa = df_fa.mask(df_fa.astype(object).eq(ns_parser.n_num*['0'])).dropna()
        df_fa = df_fa.applymap(lambda x: long_number_format(x))
        df_fa.index = [''.join(' ' + char if char.isupper() else char.strip() for char in idx).strip() for idx in df_fa.index.tolist()]
        df_fa.index = [s_val.capitalize() for s_val in df_fa.index]
        df_fa.columns.name = "Fiscal Date Ending"
        print(df_fa)

        print("")

    except:
        print("")
        return
    

# ---------------------------------------------------- CASH_FLOW ----------------------------------------------------
def cash_flow(l_args, s_ticker):
    parser = argparse.ArgumentParser(prog='cash', 
                                     description="""Prints a complete cash flow statement over time. This can be either 
                                     quarterly or annually. The following fields are expected: Accepted date, Accounts payables, 
                                     Accounts receivables, Acquisitions net, Capital expenditure, Cash at beginning of period, 
                                     Cash at end of period, Change in working capital, Common stock issued, Common stock repurchased, 
                                     Debt repayment, Deferred income tax, Depreciation and amortization, Dividends paid, 
                                     Effect of forex changes on cash, Filling date, Final link, Free cash flow, Inventory, 
                                     Investments in property plant and equipment, Link, Net cash provided by operating activities, 
                                     Net cash used for investing activites, Net cash used provided by financing activities, Net 
                                     change in cash, Net income, Operating cash flow, Other financing activites, Other investing 
                                     activites, Other non cash items, Other working capital, Period, Purchases of investments, 
                                     Sales maturities of investments, Stock based compensation. [Source: Alpha Vantage]""")

    parser.add_argument('-n', "--num", action="store", dest="n_num", type=check_positive, default=1, 
                        help='Number of latest years/quarters.')
    parser.add_argument('-q', "--quarter", action="store_true", default=False, dest="b_quarter", 
                        help='Quarter fundamental data flag.')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        if ns_parser.n_num == 1:
            pd.set_option('display.max_colwidth', -1)
        else:
            pd.options.display.max_colwidth = 40

        fd = FundamentalData(key=cfg.API_KEY_ALPHAVANTAGE, output_format='pandas')
        if ns_parser.b_quarter:
            df_fa, d_fd_metadata = fd.get_cash_flow_quarterly(symbol=s_ticker)
        else:
            df_fa, d_fd_metadata = fd.get_cash_flow_annual(symbol=s_ticker)

        df_fa = df_fa.set_index('fiscalDateEnding')
        df_fa = df_fa.head(n=ns_parser.n_num).T
        df_fa = df_fa.mask(df_fa.astype(object).eq(ns_parser.n_num*['None'])).dropna()
        df_fa = df_fa.mask(df_fa.astype(object).eq(ns_parser.n_num*['0'])).dropna()
        df_fa = df_fa.applymap(lambda x: long_number_format(x))
        df_fa.index = [''.join(' ' + char if char.isupper() else char.strip() for char in idx).strip() for idx in df_fa.index.tolist()]
        df_fa.index = [s_val.capitalize() for s_val in df_fa.index]
        df_fa.columns.name = "Fiscal Date Ending"
        print(df_fa)

        print("")
        
    except:
        print("")
        return


# ---------------------------------------------------- EARNINGS ----------------------------------------------------
def earnings(l_args, s_ticker):
    parser = argparse.ArgumentParser(prog='earnings', 
                                     description="""Print earnings dates and reported EPS of the company. 
                                     The following fields are expected: Fiscal Date Ending and Reported EPS.
                                     [Source: Alpha Vantage]""")

    parser.add_argument('-q', "--quarter", action="store_true", default=False, dest="b_quarter", help='Quarter fundamental data flag.')
    parser.add_argument('-n', "--num", action="store", dest="n_num", type=check_positive, default=5, help='Number of latest info')
        
    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        if ns_parser.n_num == 1:
            pd.set_option('display.max_colwidth', -1)
        else:
            pd.options.display.max_colwidth = 40

        # Request EARNINGS data from Alpha Vantage API
        s_req = f"https://www.alphavantage.co/query?function=EARNINGS&symbol={s_ticker}&apikey={cfg.API_KEY_FINANCIALMODELINGPREP}"      
        result = requests.get(s_req, stream=True)
        
        # If the returned data was successful
        if result.status_code == 200:
            df_fa = json_normalize(result.json())
            if ns_parser.b_quarter:
                df_fa = pd.DataFrame(df_fa['quarterlyEarnings'][0])
                df_fa = df_fa[["fiscalDateEnding", "reportedDate", "reportedEPS", "estimatedEPS", "surprise", "surprisePercentage"]]
                df_fa = df_fa.rename(columns={"fiscalDateEnding":"Fiscal Date Ending",
                                            "reportedEPS":"Reported EPS",
                                            "estimatedEPS":"Estimated EPS",
                                            "reportedDate":"Reported Date",
                                            "surprise":"Surprise",
                                            "surprisePercentage":"Suprise Percentage"})
            else:
                df_fa = pd.DataFrame(df_fa['annualEarnings'][0])
                df_fa = df_fa.rename(columns={"fiscalDateEnding":"Fiscal Date Ending",
                                            "reportedEPS":"Reported EPS"})

            print(df_fa.head(n=ns_parser.n_num).T.to_string(header=False))
            print("")
        else:
            print(f"Error: {result.status_code}")

        print("")
        
    except:
        print("")
        return
