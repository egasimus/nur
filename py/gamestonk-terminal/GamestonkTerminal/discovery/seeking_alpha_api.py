import argparse
from bs4 import BeautifulSoup
import requests
import pandas as pd
from helper_funcs import *


# ------------------------------------------------ EARNINGS_RELEASE_DATES -------------------------------------------------
def earnings_release_dates(l_args):
    parser = argparse.ArgumentParser(prog='up_earnings', 
                                     description='''Upcoming earnings release dates. [Source: Seeking Alpha]''')
    
    parser.add_argument('-p', "--pages", action="store", dest="n_pages", type=check_positive, default=10, 
                        help='Number of pages to read upcoming earnings from in Seeking Alpha website.')
    parser.add_argument('-n', "--num", action="store", dest="n_num", type=check_positive, default=3, 
                        help='Number of upcoming earnings release dates to print')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}")

        l_earnings = list()
        for idx in range(0, ns_parser.n_pages):
            if idx == 0:
                url_next_earnings = f"https://seekingalpha.com/earnings/earnings-calendar"
            else:
                url_next_earnings = f"https://seekingalpha.com/earnings/earnings-calendar/{idx+1}"
            text_soup_earnings = BeautifulSoup(requests.get(url_next_earnings).text, "lxml")
            
            for bs_stock in text_soup_earnings.findAll('tr', {'data-exchange': 'NASDAQ'}):
                l_stock = list()
                for stock in bs_stock.contents[:3]:
                    l_stock.append(stock.text)
                l_earnings.append(l_stock)
                
        df_earnings = pd.DataFrame(l_earnings, columns=['Ticker', 'Name', 'Date'])
        df_earnings['Date'] = pd.to_datetime(df_earnings['Date'])
        df_earnings = df_earnings.set_index('Date')

        pd.set_option('display.max_colwidth', -1)
        for n_days, earning_date in enumerate(df_earnings.index.unique()):
            if n_days > (ns_parser.n_num-1):
                break
                
            print(f"Earning Release on {earning_date.date()}")
            print("----------------------------------------------")
            print(df_earnings[earning_date == df_earnings.index][['Ticker', 'Name']].to_string(index=False, header=False))
            print("")

    except SystemExit:
        print("")
        return
