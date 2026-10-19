import sys,hashlib,oracledb
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
u,p,d=conn_info(); c=oracledb.connect(user=u,password=p,dsn=d).cursor()
c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' ORDER BY LINE")
t="".join(r[0] for r in c).replace("\r\n","\n"); print(sys.argv[1],"md5",hashlib.md5(t.encode()).hexdigest())
