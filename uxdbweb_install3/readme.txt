UXDB_WEB安装步骤：
1.执行initwebdb.sh初始化webserver需要使用的数据库uxdbwebdb
	a.选择是否初始化uxdbwebdb数据库
	b.选择是否启动uxdbwebdb数据库
2.修改配置文件:uxwebconfig.json
	a.修改uxdb.servername：uxdbwebdb数据库的IP地址
	b.修改uxdb.port：uxdbwebdb数据库的端口
3.执行install.sh安装uxdbweb
4.执行createuser.sh在uxdbwebdb中创建uxdbwebuser用户，需要输入uxdbwebdb数据库的密码
5.uxdbweb成功安装，并且uxdbwebdb数据库成功启动后，执行start_web.sh启动uxdbweb server

UXDB_WEB卸载步骤：
执行uninstall.sh文件即可--提示：只删除uxdbweb和nodejs