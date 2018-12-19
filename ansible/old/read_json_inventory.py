#!/usr/bin/env python
import argparse
import os


def read_inventory():
    file_name = os.path.join(os.path.dirname(__file__), 'inventory.json')
    with open(file_name) as f:
        return f.read()


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

    print(rv)


if __name__ == '__main__':
    main()
