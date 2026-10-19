"""[E20261006-ASISDELTA] JSON_TABLE 의미 사전 확인 (조회 전용 — DB 변경 없음)

저장 SP 에 넣을 컬럼 정의가 아래 5가지 입력에서 기대대로 동작하는지 DUAL 로 확인한다.
  키 없음 / 키 있고 null / 키 있고 빈문자 / 앞뒤 공백 / 숫자형
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

SQL = """
SELECT JT.SCM_SITE_ID
     , '[' || TRIM(JT.DISTRIBUTION_CHANNEL) || ']' AS DC
     , '[' || TRIM(JT.ATTRIBUTE5) || ']'           AS A5
     , JT.HAS_DISTRIBUTION_CHANNEL                AS HAS_DC
     , JT.HAS_ATTRIBUTE5                          AS HAS_A5
  FROM JSON_TABLE(:d, '$[*]'
       COLUMNS (
             SCM_SITE_ID              VARCHAR2(100)  PATH '$."SCM_SITE_ID"' NULL ON EMPTY NULL ON ERROR
           , DISTRIBUTION_CHANNEL     VARCHAR2(600)  PATH '$."DISTRIBUTION_CHANNEL"' NULL ON EMPTY NULL ON ERROR
           , ATTRIBUTE5               VARCHAR2(600)  PATH '$."ATTRIBUTE5"' NULL ON EMPTY NULL ON ERROR
           , HAS_DISTRIBUTION_CHANNEL NUMBER(1)      EXISTS PATH '$."DISTRIBUTION_CHANNEL"'
           , HAS_ATTRIBUTE5           NUMBER(1)      EXISTS PATH '$."ATTRIBUTE5"'
       )) JT
"""
DATA = ('[{"SCM_SITE_ID":"1_ABSENT"}'
        ',{"SCM_SITE_ID":"2_NULL","DISTRIBUTION_CHANNEL":null,"ATTRIBUTE5":null}'
        ',{"SCM_SITE_ID":"3_EMPTY","DISTRIBUTION_CHANNEL":"","ATTRIBUTE5":""}'
        ',{"SCM_SITE_ID":"4_SPACE","DISTRIBUTION_CHANNEL":"  50 ","ATTRIBUTE5":" 7  "}'
        ',{"SCM_SITE_ID":"5_NUMBER","DISTRIBUTION_CHANNEL":50,"ATTRIBUTE5":0}]')
EXPECT = {"1_ABSENT": ("[]", "[]", 0, 0), "2_NULL": ("[]", "[]", 1, 1), "3_EMPTY": ("[]", "[]", 1, 1),
          "4_SPACE": ("[50]", "[7]", 1, 1), "5_NUMBER": ("[50]", "[0]", 1, 1)}

if __name__ == "__main__":
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.setinputsizes(d=oracledb.DB_TYPE_CLOB)
        cur.execute(SQL, d=DATA)
        ok = True
        for r in cur:
            good = tuple(r[1:]) == EXPECT[r[0]]
            ok &= good
            print("PASS" if good else "FAIL", r, "기대", EXPECT[r[0]])
        print("결과:", "PASS" if ok else "FAIL")
        sys.exit(0 if ok else 1)
