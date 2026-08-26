import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
sys.path.insert(0,r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info
u,p,d=conn_info(); con=oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
def q(t,sql):
    print("\n=== "+t+" ===")
    cur.execute(sql); print(" | ".join(c[0] for c in cur.description))
    for r in cur.fetchall(): print(" | ".join("" if x is None else str(x) for x in r))
q("EDIT_AUTH_V 기저 조인 행수 (GROUP BY 전) — minyonglee1/DMF0035/UNIT 40","""
SELECT AUTH.UNIT_ID, COUNT(*) BASE_ROWS, COUNT(DISTINCT GRP.USER_GR_ID) GRPS
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M GRP
  JOIN SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M AUTH ON AUTH.USER_GR_ID=GRP.USER_GR_ID AND AUTH.USER_ID=GRP.USER_ID
  JOIN SCM_MGR.SCM_ADM_MNU_M MNU ON MNU.UNIT_TP_CD=AUTH.UNIT_TP_CD
 WHERE GRP.USE_YN='Y' AND AUTH.USE_YN='Y' AND MNU.USE_YN='Y'
   AND GRP.USER_ID='minyonglee1' AND MNU.MNU_ID='DMF0035'
 GROUP BY AUTH.UNIT_ID ORDER BY 1""")
q("SCM_MST_SITE PK 유일성 확인 (div40 site 중복 여부)","""
SELECT COUNT(*) TOT, COUNT(DISTINCT DIVISION_ID||'|'||SCM_SITE_ID) UNIQ FROM SCM_MGR.SCM_MST_SITE""")
q("T_COLUMN_SETUP 별칭 'F' 사용 여부 (SP 본문 상수 인서트 기준)","""
SELECT 'F 별칭 컬럼 정의 없음(SP 본문 상수)' NOTE FROM DUAL""")
con.close()
