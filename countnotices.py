# coding: interpy

import sys, os, re, time, yaml, pymssql

credentialspath = os.path.abspath(os.path.dirname(__file__)) + '/credentials.yml'
credentials = open(credentialspath, "r")
destinfo = yaml.load(credentials)
dbserver = destinfo['dbserver']
dbuser = destinfo['dbuser']
dbpassword = destinfo['dbpassword']
if len(sys.argv) == 1:
    today = time.strftime("%Y") + "-" + time.strftime("%m") + "-" + time.strftime("%d")
    sys.argv.append(today)
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
            elif re.search('10 Day Overdue Notice:', contents):
                overduetencount += 1
            elif re.search('Long Overdue Invoice:', contents):
                invoicecount += 1
    totals = "Totals for #{date}:\nReservations: #{rescount}\nFirst Overdues: #{overdueonecount}\n10-day Overdues: #{overduetencount}\nInvoices: #{invoicecount}\n------"
    print totals
    try:
        conn = pymssql.connect(dbserver, dbuser, dbpassword, "vSmartNotices")
        cursor = conn.cursor()
        cursor.execute("insert into dbo.noticeRecords (noticedate, reservations, firstoverdues, tendayoverdues, invoices) values ('#{date}', #{rescount}, #{overdueonecount}, #{overduetencount}, #{invoicecount});")
        conn.commit()
        conn.close()
    except:
        print "Could not write to DB: ", sys.exc_info()
    else:
        print "Row written to DB."