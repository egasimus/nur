import argparse
import pandas_ta as ta
from helper_funcs import *
from pandas.plotting import register_matplotlib_converters
register_matplotlib_converters()
import matplotlib.pyplot as plt

# ----------------------------------------------------- CCI -----------------------------------------------------
def cci(l_args, s_ticker, s_interval, df_stock):
    parser = argparse.ArgumentParser(prog='cci', 
                                     description=""" The CCI is designed to detect beginning and ending market trends. 
                                     The range of 100 to -100 is the normal trading range. CCI values outside of this 
                                     range indicate overbought or oversold conditions. You can also look for price 
                                     divergence in the CCI. If the price is making new highs, and the CCI is not, 
                                     then a price correction is likely. """)

    parser.add_argument('-l', "--length", action="store", dest="n_length", type=check_positive, default=14, help='length')
    parser.add_argument('-s', "--scalar", action="store", dest="n_scalar", type=check_positive, default=0.015, help='scalar')
    parser.add_argument('-o', "--offset", action="store", dest="n_offset", type=check_positive, default=0, help='offset')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        # Daily
        if s_interval == "1440min":
            df_ta = ta.cci(high=df_stock['2. high'], low=df_stock['3. low'], close=df_stock['5. adjusted close'], 
                           length=ns_parser.n_length, scalar=ns_parser.n_scalar, offset=ns_parser.n_offset).dropna()
            
            plt.subplot(211)
            plt.title(f"Commodity Channel Index (CCI) on {s_ticker}")
            plt.plot(df_stock.index, df_stock['5. adjusted close'].values, 'k', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.values, 'b', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.axhspan(100, plt.gca().get_ylim()[1], facecolor='r', alpha=0.2)
            plt.axhspan(plt.gca().get_ylim()[0], -100, facecolor='g', alpha=0.2)
            plt.axhline(100, linewidth=3, color='r', ls='--')
            plt.axhline(-100, linewidth=3, color='g', ls='--')
            plt.xlabel('Time')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.gca().twinx()
            plt.ylim(plt.gca().get_ylim())
            plt.yticks([.2, .8], ('OVERSOLD', 'OVERBOUGHT'))
            plt.show()

        # Intraday 
        else:
            df_ta = ta.cci(high=df_stock['2. high'], low=df_stock['3. low'], close=df_stock['4. close'], 
                           length=ns_parser.n_length, scalar=ns_parser.n_scalar, offset=ns_parser.n_offset).dropna()
            
            plt.subplot(211)
            plt.title(f"Commodity Channel Index (CCI) on {s_ticker}")
            plt.plot(df_stock.index, df_stock['4. close'].values, 'k', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.values, 'b', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.axhspan(100, plt.gca().get_ylim()[1], facecolor='r', alpha=0.2)
            plt.axhspan(plt.gca().get_ylim()[0], -100, facecolor='g', alpha=0.2)
            plt.axhline(100, linewidth=3, color='r', ls='--')
            plt.axhline(-100, linewidth=3, color='g', ls='--')
            plt.xlabel('Time')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.gca().twinx()
            plt.ylim(plt.gca().get_ylim())
            plt.yticks([.2, .8], ('OVERSOLD', 'OVERBOUGHT'))
            plt.show()
        print("")

    except:
        print("")
    

# ----------------------------------------------------- MACD -----------------------------------------------------
def macd(l_args, s_ticker, s_interval, df_stock):
    parser = argparse.ArgumentParser(prog='macd', 
                                     description=""" The Moving Average Convergence Divergence (MACD) is the difference 
                                     between two Exponential Moving Averages. The Signal line is an Exponential Moving 
                                     Average of the MACD. \n \n The MACD signals trend changes and indicates the start 
                                     of new trend direction. High values indicate overbought conditions, low values 
                                     indicate oversold conditions. Divergence with the price indicates an end to the 
                                     current trend, especially if the MACD is at extreme high or low values. When the MACD 
                                     line crosses above the signal line a buy signal is generated. When the MACD crosses 
                                     below the signal line a sell signal is generated. To confirm the signal, the MACD 
                                     should be above zero for a buy, and below zero for a sell. """)

    parser.add_argument('-f', "--fast", action="store", dest="n_fast", type=check_positive, default=12,
                        help='The short period.')
    parser.add_argument('-s', "--slow", action="store", dest="n_slow", type=check_positive, default=26,
                        help='The long period.')
    parser.add_argument("--signal", action="store", dest="n_signal", type=check_positive, default=9,
                        help='The signal period.')
    parser.add_argument('-o', "--offset", action="store", dest="n_offset", type=check_positive, default=0,
                        help='How many periods to offset the result.')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        # Daily
        if s_interval == "1440min":
            df_ta = ta.macd(df_stock['5. adjusted close'], fast=ns_parser.n_fast, slow=ns_parser.n_slow,
                            signal=ns_parser.n_signal, offset=ns_parser.n_offset).dropna()

            plt.subplot(211)
            plt.title(f"Moving Average Convergence Divergence (MACD) on {s_ticker}")
            plt.plot(df_stock.index, df_stock['4. close'].values, 'k', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.iloc[:,0].values, 'b', lw=2)
            plt.plot(df_ta.index, df_ta.iloc[:,2].values, 'r', lw=2)
            plt.bar(df_ta.index, df_ta.iloc[:,1].values, color='g')
            plt.legend([f'MACD Line {df_ta.columns[0]}', 
                        f'Signal Line {df_ta.columns[2]}',
                        f'Histogram {df_ta.columns[1]}'])
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.xlabel('Time')
            plt.show()

        # Intraday 
        else:
            df_ta = ta.macd(df_stock['4. close'], fast=ns_parser.n_fast, slow=ns_parser.n_slow,
                            signal=ns_parser.n_signal, offset=ns_parser.n_offset).dropna()

            plt.subplot(211)
            plt.title(f"Moving Average Convergence Divergence (MACD) on {s_ticker}")
            plt.plot(df_stock.index, df_stock['4. close'].values, 'k', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.iloc[:,0].values, 'b', lw=2)
            plt.plot(df_ta.index, df_ta.iloc[:,2].values, 'r', lw=2)
            plt.bar(df_ta.index, df_ta.iloc[:,1].values, color='g')
            plt.legend([f'MACD Line {df_ta.columns[0]}', 
                        f'Signal Line {df_ta.columns[2]}',
                        f'Histogram {df_ta.columns[1]}'])
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.xlabel('Time')
            plt.show()
        print("")

    except:
        print("")
    

# ----------------------------------------------------- RSI -----------------------------------------------------
def rsi(l_args, s_ticker, s_interval, df_stock):
    parser = argparse.ArgumentParser(prog='rsi', 
                                     description=""" The Relative Strength Index (RSI) calculates a ratio of the 
                                     recent upward price movements to the absolute price movement. The RSI ranges 
                                     from 0 to 100. The RSI is interpreted as an overbought/oversold indicator when 
                                     the value is over 70/below 30. You can also look for divergence with price. If 
                                     the price is making new highs/lows, and the RSI is not, it indicates a reversal. """)

    parser.add_argument('-l', "--length", action="store", dest="n_length", type=check_positive, default=14, help='length')
    parser.add_argument('-s', "--scalar", action="store", dest="n_scalar", type=check_positive, default=100, help='scalar')
    parser.add_argument('-d', "--drift", action="store", dest="n_drift", type=check_positive, default=1, help='drift')
    parser.add_argument('-o', "--offset", action="store", dest="n_offset", type=check_positive, default=0, help='offset')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        # Daily
        if s_interval == "1440min":
            df_ta = ta.rsi(df_stock['5. adjusted close'], length=ns_parser.n_length, scalar=ns_parser.n_scalar, 
                           drift=ns_parser.n_drift, offset=ns_parser.n_offset).dropna()

            plt.subplot(211)
            plt.plot(df_stock.index, df_stock['5. adjusted close'].values, 'k', lw=2)
            plt.title(f"Relative Strength Index (RSI) on {s_ticker}")
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.values, 'b', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.axhspan(70, 100, facecolor='r', alpha=0.2)
            plt.axhspan(0, 30, facecolor='g', alpha=0.2)
            plt.axhline(70, linewidth=3, color='r', ls='--')
            plt.axhline(30, linewidth=3, color='g', ls='--')
            plt.xlabel('Time')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.ylim([0, 100])
            plt.gca().twinx()
            plt.ylim(plt.gca().get_ylim())
            plt.yticks([.15, .85], ('OVERSOLD', 'OVERBOUGHT'))
            plt.show()

        # Intraday 
        else:
            df_ta = ta.rsi(df_stock['4. close'], length=ns_parser.n_length, scalar=ns_parser.n_scalar, 
                           drift=ns_parser.n_drift, offset=ns_parser.n_offset).dropna()

            plt.subplot(211)
            plt.plot(df_stock.index, df_stock['4. close'].values, 'k', lw=2)
            plt.title(f"Relative Strength Index (RSI) on {s_ticker}")
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.values, 'b', lw=2)
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.axhspan(70, 100, facecolor='r', alpha=0.2)
            plt.axhspan(0, 30, facecolor='g', alpha=0.2)
            plt.axhline(70, linewidth=3, color='r', ls='--')
            plt.axhline(30, linewidth=3, color='g', ls='--')
            plt.xlabel('Time')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.ylim([0, 100])
            plt.gca().twinx()
            plt.ylim(plt.gca().get_ylim())
            plt.yticks([.15, .85], ('OVERSOLD', 'OVERBOUGHT'))
            plt.show()    
        print("")

    except:
        print("")


# ----------------------------------------------------- STOCH -----------------------------------------------------
def stoch(l_args, s_ticker, s_interval, df_stock):
    parser = argparse.ArgumentParser(prog='stoch', 
                                     description=""" The Stochastic Oscillator measures where the close is in relation 
                                     to the recent trading range. The values range from zero to 100. %D values over 75 
                                     indicate an overbought condition; values under 25 indicate an oversold condition. 
                                     When the Fast %D crosses above the Slow %D, it is a buy signal; when it crosses 
                                     below, it is a sell signal. The Raw %K is generally considered too erratic to use 
                                     for crossover signals. """)

    parser.add_argument('-k', "--fastkperiod", action="store", dest="n_fastkperiod", type=check_positive, default=14, 
                        help='The time period of the fastk moving average')
    parser.add_argument('-d', "--slowdperiod", action="store", dest="n_slowdperiod", type=check_positive, default=3,
                        help='TThe time period of the slowd moving average')
    parser.add_argument("--slowkperiod", action="store", dest="n_slowkperiod", type=check_positive, default=3,
                        help='The time period of the slowk moving average')
    parser.add_argument('-o', "--offset", action="store", dest="n_offset", type=check_positive, default=0, help='offset')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)

        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}\n")
            return

        # Daily
        if s_interval == "1440min":
            df_ta = ta.stoch(high=df_stock['2. high'], low=df_stock['3. low'], close=df_stock['5. adjusted close'], k=ns_parser.n_fastkperiod, 
                             d=ns_parser.n_slowdperiod, smooth_k=ns_parser.n_slowkperiod, offset=ns_parser.n_offset).dropna()
            
            plt.subplot(211)
            plt.plot(df_stock.index, df_stock['5. adjusted close'].values, 'k', lw=2)
            plt.title(f"Stochastic Relative Strength Index (STOCH RSI) on {s_ticker}")
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.iloc[:,0].values, 'k', lw=2)
            plt.plot(df_ta.index, df_ta.iloc[:,1].values, 'b', lw=2, ls='--')
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.axhspan(80, 100, facecolor='r', alpha=0.2)
            plt.axhspan(0, 20, facecolor='g', alpha=0.2)
            plt.axhline(80, linewidth=3, color='r', ls='--')
            plt.axhline(20, linewidth=3, color='g', ls='--')
            plt.legend([f'%K {df_ta.columns[0]}', f'%D {df_ta.columns[1]}'])
            plt.xlabel('Time')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.ylim([0, 100])
            plt.gca().twinx()
            plt.ylim(plt.gca().get_ylim())
            plt.yticks([.1, .9], ('OVERSOLD', 'OVERBOUGHT'))
            plt.show()

        # Intraday 
        else:
            df_ta = ta.stoch(high=df_stock['2. high'], low=df_stock['3. low'], close=df_stock['4. close'], k=ns_parser.n_fastkperiod, 
                             d=ns_parser.n_slowdperiod, smooth_k=ns_parser.n_slowkperiod, offset=ns_parser.n_offset).dropna()

            plt.subplot(211)
            plt.plot(df_stock.index, df_stock['4. close'].values, 'k', lw=2)
            plt.title(f"Stochastic Relative Strength Index (STOCH RSI) on {s_ticker}")
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.ylabel(f'Share Price ($)')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.subplot(212)
            plt.plot(df_ta.index, df_ta.iloc[:,0].values, 'k', lw=2)
            plt.plot(df_ta.index, df_ta.iloc[:,1].values, 'b', lw=2, ls='--')
            plt.xlim(df_stock.index[0], df_stock.index[-1])
            plt.axhspan(80, 100, facecolor='r', alpha=0.2)
            plt.axhspan(0, 20, facecolor='g', alpha=0.2)
            plt.axhline(80, linewidth=3, color='r', ls='--')
            plt.axhline(20, linewidth=3, color='g', ls='--')
            plt.legend([f'%K {df_ta.columns[0]}', f'%D {df_ta.columns[1]}'])
            plt.xlabel('Time')
            plt.grid(b=True, which='major', color='#666666', linestyle='-')
            plt.minorticks_on()
            plt.grid(b=True, which='minor', color='#999999', linestyle='-', alpha=0.2)
            plt.ylim([0, 100])
            plt.gca().twinx()
            plt.ylim(plt.gca().get_ylim())
            plt.yticks([.1, .9], ('OVERSOLD', 'OVERBOUGHT'))
            plt.show()
        print("")

    except:
        print("")
    