"""Script to build the documentation.

This script builds the tex documents in the doc directory

Example:

    python doc.build.py --stdout

Help:

    python doc.build.py --help

Contact:
                                 __/|__
                                /_/_/_/  
            www.dlr.de/sy/en      |/ DLR

Copyright (C) 2019-... DLR Lightweight Systems
"""

import argparse
import logging as log
import os
from pathlib import Path
import platform
import subprocess
import sys
import textwrap

from os import path
    
def main(argv):

    # Parse the CLI arguments
    args = parse_cli(sys.argv[1:])

    # Config logger
    log.basicConfig(
        format='%(asctime)s %(levelname)s: %(message)s',
        datefmt='%d.%m.%y %H:%M:%S',
        level=args.loglevel.upper(),
    )
    
    # Get the config
    log.debug('Preparations')
    abspath = os.path.dirname(os.path.abspath(__file__))
    docpath = os.path.normpath(os.path.join(abspath, args.path))

    if not os.path.isdir(docpath):
        raise Exception(docpath + ' is not a valid path or does not exist')

    log.info('Working on: ' + docpath)
    
    # Get stuff for using the cmd
    delimiter = assigndelimiter()

    # traverse root directory, and list directories as dirs and files as files
    for root, dirs, files in os.walk(docpath):
        #path = root.split(os.sep)
        # Traverse files
        for file in files:

            # Check for tex files
            if Path(file).suffix != '.tex':
                continue

            log.debug('Found tex file: ' + file)

            # Change the directory
            curfil = os.path.join(root,file)
            curdir = os.path.dirname(curfil)

            # We assume that the files are not that large
            if not 'arara' in open(curfil).read():
                continue

            log.debug('Found arara command')

            # Command
            log.info('Running for ' + file)
            cmd = 'cd ' + curdir + delimiter + 'arara -w ' + file
            completedProcess = subprocess.run(cmd, capture_output=True, universal_newlines=True, shell=True)
            exitcode = completedProcess.returncode
            success = (exitcode == 0)

            if args.stdout:
                print('STDOUT:')
                print(completedProcess.stdout)

            if args.stderr:
                print('STDERR:')
                print(completedProcess.stderr)

            if not success:
                raise Exception('Something went wrong with ' + file + '. Exitcode: ' + str(exitcode))

def assigndelimiter():
    os = platform.system()
    match os:
        case 'Windows':
            return ' & '
        case 'Linux':
            return ' ; '
        case _:
            raise ValueError(os + " not supported yet.")
    

def parse_cli(args):
    parser = argparse.ArgumentParser(
        prog='doc.build.py',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description='Build documentation',
        epilog=textwrap.dedent('''\
         Contact:   https://github.com/raedma/stmlatex
                    
                                         __/|__
                                        /_/_/_/  
                    www.dlr.de/sy/en      |/ DLR
 
         Copyright (C) 2019-... DLR Lightweight Systems
         '''),
        allow_abbrev=False
    )
    parser.add_argument('-p', '--path', type=str, default='..\\doc', help='The path to the doc folder')
    parser.add_argument('--stdout', action='store_true', help='Flag whether to print the STDOUT')
    parser.add_argument('--stderr', action='store_true', help='Flag whether to print the STDERR')
    parser.add_argument('-log','--loglevel',choices=log._nameToLevel.keys(),default='warning',help='Provide logging level. Example --loglevel debug, default=warning' )
    return parser.parse_args(args)
    
if __name__ == "__main__":
    
    # check python version
    if not sys.version_info > (3,9):
        print('This script requires python 3.10 or higher')
        print('Exit script')
        sys.exit()
        
    main(sys.argv[1:])