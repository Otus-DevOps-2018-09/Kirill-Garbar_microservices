#!/usr/bin/env python
""" Reads inventory from terraform/stage environment.

This is an example of how we can get dynamic inventory, using `terraform output` command for env `stage`.
"""

import argparse
import json
import subprocess
from pathlib import Path


def read_ips():
    wd = (Path(__file__).parent / '..' / 'terraform' / 'stage').resolve()
    rv = subprocess.check_output(['terraform', 'output', '-json'], cwd=wd)
    return json.loads(rv)


def fmt_inventory(ips):
    return {
        'app': [
            ips['app_external_ip']['value']
        ],
        'db': [
            ips['db_external_ip']['value']
        ],
    }


def read_inventory():
    ips = read_ips()
    return fmt_inventory(ips)


def parse_cli():
    parser = argparse.ArgumentParser()
    parser.add_argument('--list', action='store_true')
    parser.add_argument('--host', action='store')
    return parser.parse_args()


def main():
    rv = ''

    args = parse_cli()
    if args.host:
        rv = "{}"
    elif args.list:
        rv = read_inventory()

    print(json.dumps(rv, indent=2))


if __name__ == '__main__':
    main()
