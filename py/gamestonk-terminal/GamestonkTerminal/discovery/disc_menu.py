import config_terminal as cfg
import argparse
from discovery import alpha_vantage_api
from discovery import yahoo_finance_api
from discovery import finviz_api
from discovery import short_interest_api
from discovery import seeking_alpha_api
from discovery import fidelity_api
from discovery import simply_wallst_api
from discovery import spachero_api
from discovery import unusual_whales_api


# -----------------------------------------------------------------------------------------------------------------------
def print_discovery():
    """ Print help """

    print("\nDiscovery Mode:") 
    print("   help          show this discovery menu again")
    print("   q             quit this menu, and shows back to main menu")
    print("   quit          quit to abandon program")
    print("")
    print("   map           S&P500 index stocks map [Finviz]")
    print("   sectors       show sectors performance [Alpha Vantage]")
    print("   gainers       show latest top gainers [Yahoo Finance]")
    print("   orders        orders by Fidelity Customers [Fidelity]")
    print("   up_earnings   upcoming earnings release dates [Seeking Alpha]")
    print("   high_short    show top high short interest stocks of over 20% ratio [www.highshortinterest.com]")
    print("   low_float     show low float stocks under 10M shares float [www.lowfloat.com]")
    print("   simply_wallst Simply Wall St. research data [Simply Wall St.]")
    print("   spachero      great website for SPACs research [SpacHero]")
    print("   uwhales       good website for SPACs research [UnusualWhales]")
    print("")
    return


# ---------------------------------------------------- MENU ----------------------------------------------------
def disc_menu():

    # Add list of arguments that the discovery parser accepts
    disc_parser = argparse.ArgumentParser(prog='discovery', add_help=False)
    disc_parser.add_argument('cmd', choices=['help', 'q', 'quit',
                                             'map', 'sectors', 'gainers', 'spacs', 'orders', 'spachero',
                                             'high_short', 'low_float', 'up_earnings', 'simply_wallst', 
                                             'uwhales'])

    print_discovery()

    # Loop forever and ever
    while True:
        # Get input command from user
        as_input = input('> ')
        
        # Parse fundamental analysis command of the list of possible commands
        try:
            (ns_known_args, l_args) = disc_parser.parse_known_args(as_input.split())

        except SystemExit:
            print("The command selected doesn't exist\n")
            continue
            
        if ns_known_args.cmd == 'help':
            print_discovery()

        elif ns_known_args.cmd == 'q':
            # Just leave the DISC menu
            return False

        elif ns_known_args.cmd == 'quit':
            # Abandon the program
            return True

        # --------------------------------------------------- FINVIZ ---------------------------------------------------
        elif ns_known_args.cmd == 'map':
            finviz_api.map_sp500(l_args)
        
        # ------------------------------------------------ ALPHA VANTAGE -----------------------------------------------
        elif ns_known_args.cmd == 'sectors':
            alpha_vantage_api.sectors(l_args)
        
        # ------------------------------------------------ YAHOO FINANCE ------------------------------------------------
        elif ns_known_args.cmd == 'gainers':
            yahoo_finance_api.gainers(l_args)

        # -------------------------------------------------- SPACHERO --------------------------------------------------
        elif ns_known_args.cmd == 'spachero':
            spachero_api.spachero(l_args)

        # -------------------------------------------------- UNUSUAL WHALES --------------------------------------------------
        elif ns_known_args.cmd == 'uwhales':
            unusual_whales_api.unusual_whales(l_args)

        # --------------------------------------------------- FIDELITY ---------------------------------------------------
        elif ns_known_args.cmd == 'orders':
            fidelity_api.orders(l_args)

        # ------------------------------------------------ SIMPLY WALL ST ------------------------------------------------
        elif ns_known_args.cmd == 'simply_wallst':
            simply_wallst_api.simply_wallst(l_args)

        # ------------------------------------------------ SEEKING ALPHA ------------------------------------------------
        elif ns_known_args.cmd == 'up_earnings':
            seeking_alpha_api.earnings_release_dates(l_args)

        # ------------------------------------------------ SHORT_INTEREST ------------------------------------------------
        elif ns_known_args.cmd == 'high_short':
            short_interest_api.high_short_interest(l_args)
        
        elif ns_known_args.cmd == 'low_float':
            short_interest_api.low_float(l_args)

        # ------------------------------------------------------------------------------------------------------------
        else:
            print("Command not recognized!")