# 사내 BODY 현재 원문 vs 기준 파일(00_BACKUP / 01 적용본) 대조
import sys; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
C = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPD_20261027"
u,p,d = conn_info(); cur = oracledb.connect(user=u,password=p,dsn=d).cursor()
cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0082' AND type='PACKAGE BODY' ORDER BY line"); now = "".join(r[0] for r in cur).rstrip()
def body(f):
    t = open(C + "\\" + f, encoding="utf-8").read().split("\n", 1)[1].rstrip()
    return t[:-1].rstrip()[len("CREATE OR REPLACE "):]
print("== 00_BACKUP(수정 전 원문)", now == body("00_BACKUP_PKG_DMF0082_BODY.sql"), "| == 01(사내 적용본)", now == body("01_PKG_DMF0082_BODY.sql"), "| marker", now.count("E20261027-DMF0082LASTUPD"))
