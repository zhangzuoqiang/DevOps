#!/usr/bin/evn python
import dns.resolver

domain = raw_input('Please input an domain:')
#A = dns.resolver.query(domain,'A')
cname = dns.resolver.query(domain,'CNAME')

#for i in A.response.answer:
#	for j in i.items:
#   		print j.address

for i in cname.response.answer:
	for j in i.items:
		print j.to_text()   		