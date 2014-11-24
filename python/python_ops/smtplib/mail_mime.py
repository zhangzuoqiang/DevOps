#coding: utf-8
import smtplib
from email.mime.text import MIMEText

HOST = "mail.winupon.com"
SUBJECT=u"官网流量数据报表 by Python"
#TO = "29002908@qq.com"
TO ="xu_jinyang@163.com"
#TO = "182182928@qq.com"
#TO = "hzchenkj@163.com"
FROM = "chenkj@winupon.com" 
msg = MIMEText("""
<table width="800" border="0" cellspacing="0" cellpadding="4">
<tr>
	<td bgcolor="#CECFAD" height="20" style="font-size:14px">* 官网数据 <a href="monitor.domain.com"> 更多 >></a></td>
</tr> 
<tr>
	<td bgcolor="#EFEBDE" height="100" style="font-size:13px">
	1)日访问量:<font color=red>152433</font> <br/>
	  访问次数 :545122 页面浏览量 :504Mb<br/>
	access counts: 23651 page :45123 <br/>
	2)状态码信息 <br/>
	&nbsp;&nbsp;500:105 404:3264 503:214<br/> 
	3)访客浏览量信息  <br/>
	&nbsp;&nbsp;IE:50% firefox:10% chrome:30% other:10%<br/> 
	4)页面信息 <br>
	&nbsp;&nbsp;/index.php 42153<br/>
	&nbsp;&nbsp;/view.php 21451<br/>
	&nbsp;&nbsp;/login.php 5112<br/>
	</td>
</tr> 
</table>""","html","utf-8")
msg['Subject'] = SUBJECT
msg['From'] = FROM
msg['To'] = TO 
try:
	server = smtplib.SMTP()
	server.connect(HOST,"25")
	server.starttls()
	server.login("chenkj@winupon.com","***")
	server.sendmail(FROM,[TO],msg.as_string())
	server.quit()
	print "邮件发送成功！！！"
except Exception,e:
	print " Faild:" + str(e)		
