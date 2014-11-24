#!/usr/bin/python
import smtplib
import string

HOST = "mail.winupon.com"
SUBJECT ="Test email from python smtplib"
TO = "hzchenkj@163.com"
FROM = "chenkj@winupon.com" 
text = "Python rules them all!"
BODY = string.join((
		"From: %s" % FROM ,
		"To: %s" % TO,
		"Subject: %s" % SUBJECT,
		"",
		text 
	),"\r\n")
server = smtplib.SMTP()
server.connect(HOST,"25")
server.starttls()
server.login("chenkj@winupon.com","***")
server.sendmail(FROM,[TO],BODY)
server.quit()