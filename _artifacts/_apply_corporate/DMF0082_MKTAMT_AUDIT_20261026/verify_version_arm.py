"""[E20261026-DMF0082-MKTAMTAUDIT] MF/SF 버전 금액 arm 2곳(본문 2742·3321) 검증 — 원천 집계 단독 실행 (조회 전용)

Current+MF/SF 실호출은 수정 전 원본에서도 MF 금액 arm 이 30분 초과(DPY-4024)라 실호출 비교 불가.
수정 내용은 원천 서브쿼리에 MAX(S.CREATION_DATE)·KEEP LAST_UPDATED_BY 를 더하고 바깥에서 A.* 로 받는 것뿐이므로,
그 원천 서브쿼리를 같은 조건으로 단독 실행해 "모든 키·일자 그룹에 값이 생기는가" 를 본다.
"""
import sys, io, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

DIV = "81"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 900000
cur = cn.cursor()
today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")

for vtype, label in (("MF_W", "MF arm (본문 2742)"), ("SF_W", "SF arm (본문 3321)")):
    # 패키지 GT_DMF0082_T_VERSION 적재식(본문 504~)과 동일 — 선택 버전 주(ISO_YYYYWW)의 SP% 버전 MAX
    cur.execute("""SELECT B.VERSION_NO
                        , (SELECT MAX(V2.VERSION_NO) FROM DM_MST_VERSION V2
                            INNER JOIN SCM_SYS_CALENDAR_M CM ON V2.YYYYMMDD = CM.BASIS_YYYYMMDD
                            WHERE V2.VERSION_TYPE LIKE 'SP%' AND V2.DIVISION_ID = B.DIVISION_ID AND CM.ISO_YYYYWW = C.ISO_YYYYWW)
                     FROM DM_MST_VERSION B INNER JOIN SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = B.YYYYMMDD
                    WHERE B.DIVISION_ID = :d AND B.VERSION_TYPE = :t
                    ORDER BY B.YYYYMMDD DESC FETCH FIRST 1 ROWS ONLY""", d=DIV, t=vtype)
    row = cur.fetchone()
    if not row:
        print(f"SKIP {label}: Division {DIV} 에 {vtype} 버전 0건 — 이 arm 은 해당 DB 에서 실행 대상 없음 "
              f"(원천 DM_PLN_SALES_PLAN_C · 집계식이 MF arm 과 동일하므로 MF 결과로 갈음)")
        continue
    ver, spver = row
    cur.execute("""
        SELECT COUNT(*) N_GROUP
             , SUM(CASE WHEN CREATE_DATE IS NOT NULL AND LAST_UPDATED_BY IS NOT NULL THEN 1 ELSE 0 END) N_FILLED
             , TO_CHAR(MAX(CREATE_DATE),'YYYY-MM-DD HH24:MI:SS'), MAX(LAST_UPDATED_BY)
        FROM ( SELECT S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                    , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                    , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD, SUM(S.QTY) AS QTY
                    , MAX(S.CREATION_DATE) AS CREATE_DATE
                    , MAX(S.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY S.CREATION_DATE) AS LAST_UPDATED_BY
               FROM   SCM_MGR.DM_PLN_SALES_PLAN_C S
               WHERE  S.DIVISION_ID = :d
               AND    S.VERSION_NO = :v
               AND    S.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
               AND    S.YYYYMMDD BETWEEN :f AND :t
               GROUP BY S.DIVISION_ID, S.VERSION_NO, S.CUTOFF_YYYYMMDD
                      , S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.DOM_EXP, S.FCST_TYPE, S.INCOTERMS
                      , S.MEASURE, S.PLANT_SITE_ID, S.YYYYMMDD )""", d=DIV, v=spver, f=FRM, t=TO)
    n, filled, mx, by = cur.fetchone()
    res = "PASS" if n == filled else "FAIL"
    print(f"{res} {label}: 버전 {ver} (SP {spver}) 기간 {FRM}~{TO} · 금액 그룹 {n} · 수정정보 채움 {filled} · 최신 {mx} {by}")
cn.close()
