# coding: interpy

import sys, os, re

dates = sys.argv[1:]
for date in dates:
    rescount = 0
    overdueonecount = 0
    overduetencount = 0
    invoicecount = 0
    print date
    noticesdir = "notices/" + date + "/"
    notices = os.listdir(noticesdir)
    for filename in notices:
        with open(noticesdir + filename, 'r') as textfile:
            contents = textfile.read()
            if re.search('Reservation Notice:', contents):
                rescount += 1
            elif re.search('First Overdue Notice:', contents):
                overdueonecount += 1
            elif re.search('10-day Overdue Notice:', contents):
                overduetencount += 1
            elif re.search('Long Overdue Notice:', contents):
                invoicecount += 1
    print "Totals for #{date}:\nReservations: #{rescount}\nFirst Overdues: #{overdueonecount}\n10-day Overdues: #{overduetencount}\nInvoices: #{invoicecount}\n------"