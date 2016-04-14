#!/usr/bin/env python3

import csv
from pymarc import MARCReader

marcfile = "MARCDATA.MRC"

with open(marcfile, 'rb') as fh:
    reader = MARCReader(fh)
    for record in reader:
        author = record.author()
        title = record.title()
        year = record.pubyear()
        print(author, title, year)
        print(record)
