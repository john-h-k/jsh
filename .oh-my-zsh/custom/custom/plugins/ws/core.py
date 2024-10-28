#!/usr/bin/env python3

import argparse

parser = argparse.ArgumentParser(
    prog = "ws",
    description "work-status utility"
)

subparser = parser.add_subparsers()

pr = subparser.add_parser("pr")

local = subparser.add_parser("local")

clock = subparser.add_parser("clock")