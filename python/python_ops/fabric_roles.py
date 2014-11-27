
env.roledefs={
	'web':['***','***'],
	'db':['***','***']
	}

@roles('web')
def webtask():
	run('/etc/init.d/nginx start')

@roles('db')
def dbtask():
	run('/etc/init.d/mysql start')

@roles('web','db')
def publictask():
	run('uptime')	

def deploy():
	execute(web)
	execute(db)
	execute(publictask)	