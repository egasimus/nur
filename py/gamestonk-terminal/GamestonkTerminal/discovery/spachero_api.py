import argparse
import webbrowser

# ---------------------------------------------------- SPACHERO ----------------------------------------------------
def spachero(l_args):
    parser = argparse.ArgumentParser(prog='spachero', 
                                     description='''Great website for SPACs research. [Source: www.spachero.com]''')

    try:
        (ns_parser, l_unknown_args) = parser.parse_known_args(l_args)
    
        if l_unknown_args:
            print(f"The following args couldn't be interpreted: {l_unknown_args}")

        webbrowser.open(f"https://www.spachero.com")
        print("")

    except SystemExit:
        print("")
        return