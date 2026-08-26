# -*- coding: utf-8 -*-
"""[E20260825-81AUTH] GET_ADMIN_GROUP_MEASURE — DMF0082 81 계열 권한 행 시딩.

원천 = AS-IS 동일 룩업의 SEGMENT2='DMF0003' 30행 (dictionary-first: division 기준은 언제나 AS-IS).
- MKT_FCST 30행: AS-IS 값 그대로 승계 (SCP Planner TUE 시간창 6종 / 타 그룹 A4='SCP Planner' 그룹 잠금)
- LOC 24행: 40 패턴 준용 (ADMIN / DM ADMIN / DM Planner / SCM PI Admin — 사용자 확정 2026-08-25)
- 82 제외 (조회 전용 현행 유지 — 사용자 확정)

멱등 MERGE, ON 키 = PK 실측 (LOOKUP_TYPE, SEGMENT1~5). 감사컬럼 'admin'.
NOT NULL/DEFAULT 실측: LOOKUP_TYPE·S1~S5·VALID_YN·CREATION_DATE·LAST_UPDATE_DATE = NOT NULL → 전부 명시.
"""
import io
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
APPLY = "--apply" in sys.argv

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── 원천 실측: AS-IS DMF0003 30행 (기대 카운트 고정 — 다르면 중단) ─────────────
cur.execute("""
    SELECT SEGMENT1, SEGMENT3, SEGMENT4, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, DISPLAY_SEQ
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    SEGMENT2 = 'DMF0003' AND VALID_YN = 'Y'
    ORDER  BY SEGMENT3, SEGMENT1""")
src = cur.fetchall()
assert len(src) == 30, "원천 행수 %d != 30 — 원천이 변했다, 중단" % len(src)
divs = sorted({r[1] for r in src})
assert divs == ["81", "81_HD", "81_HG", "81_HM", "81_ST", "81_UC"], divs

rows = []
# 1) MKT_FCST 30행 — AS-IS 원값 그대로 (SEGMENT2 만 DMF0082 로)
for s1, s3, s4, a1, a2, a3, a4, seq in src:
    rows.append((s1, s3, s4, a1, a2, a3, a4, seq,
                 "E20260825-81AUTH (AS-IS DMF0003 %s 승계)" % s3))
# 2) LOC 24행 — 40 패턴 준용 4그룹 (요일/시간/LIMIT 없음)
LOC_GROUPS = ["ADMIN", "DM ADMIN", "DM Planner", "SCM PI Admin"]
for s3 in divs:
    seq = next(r[7] for r in src if r[1] == s3)
    for s1 in LOC_GROUPS:
        rows.append((s1, s3, "LOC", None, None, None, None, seq,
                     "E20260825-81AUTH LOC 40패턴 준용"))

print("시딩 대상 %d행 (MKT_FCST 30 + LOC 24)" % len(rows))

MERGE = """
MERGE INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
USING (SELECT 'GET_ADMIN_GROUP_MEASURE' LOOKUP_TYPE, :s1 SEGMENT1, 'DMF0082' SEGMENT2,
              :s3 SEGMENT3, :s4 SEGMENT4, '-' SEGMENT5 FROM DUAL) S
ON (T.LOOKUP_TYPE = S.LOOKUP_TYPE AND T.SEGMENT1 = S.SEGMENT1 AND T.SEGMENT2 = S.SEGMENT2
    AND T.SEGMENT3 = S.SEGMENT3 AND T.SEGMENT4 = S.SEGMENT4 AND T.SEGMENT5 = S.SEGMENT5)
WHEN MATCHED THEN UPDATE SET
    T.ATTRIBUTE1 = :a1, T.ATTRIBUTE2 = :a2, T.ATTRIBUTE3 = :a3, T.ATTRIBUTE4 = :a4,
    T.DISPLAY_SEQ = :seq, T.VALID_YN = 'Y', T.DESCRIPTION = :descr,
    T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
     DISPLAY_SEQ, VALID_YN, DESCRIPTION,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('GET_ADMIN_GROUP_MEASURE', :s1, 'DMF0082', :s3, :s4, '-',
        :seq, 'Y', :descr, :a1, :a2, :a3, :a4,
        'admin', SYSDATE, 'admin', SYSDATE)
"""

# 이관용 SQL 파일 동시 산출 (실행 SQL 과 동일 값 — 클라우드 패키지 동봉)
def lit(v):
    return "NULL" if v is None else "'" + str(v).replace("'", "''") + "'"

sql_lines = ["-- [E20260825-81AUTH] GET_ADMIN_GROUP_MEASURE DMF0082 81 계열 시딩 (54행 멱등 MERGE)",
             "-- 원천: 동일 룩업 SEGMENT2='DMF0003' 30행 (AS-IS) + LOC 40패턴 준용 24행", ""]
for s1, s3, s4, a1, a2, a3, a4, seq, descr in rows:
    stmt = MERGE
    for k, v in (("(:s1)", lit(s1)), (":s1", lit(s1)), (":s3", lit(s3)), (":s4", lit(s4)),
                 (":a1", lit(a1)), (":a2", lit(a2)), (":a3", lit(a3)), (":a4", lit(a4)),
                 (":seq", str(seq) if seq is not None else "NULL"), (":descr", lit(descr))):
        stmt = stmt.replace(k, v)
    sql_lines.append(stmt.strip() + ";\n")
(HERE / "01_LOOKUP_81AUTH.sql").write_text("\n".join(sql_lines), encoding="utf-8")
print("이관 SQL 산출: 01_LOOKUP_81AUTH.sql")

if not APPLY:
    print("(dry) DB 미적용 — --apply 로 실행")
    con.close(); sys.exit(0)

# 적용 전 백업 (기존 DMF0082 축 전체)
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0082'""")
before = cur.fetchone()[0]

n_ins = n_upd = 0
for s1, s3, s4, a1, a2, a3, a4, seq, descr in rows:
    cur.execute(MERGE, dict(s1=s1, s3=s3, s4=s4, a1=a1, a2=a2, a3=a3, a4=a4, seq=seq, descr=descr))
con.commit()

cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0082'""")
after = cur.fetchone()[0]
print("적용 완료: DMF0082 축 %d → %d행 (기대 %d)" % (before, after, before + 54))
assert after == before + 54, "행수 불일치 — 확인 필요"

cur.execute("""SELECT SEGMENT3, SEGMENT4, COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0082' AND SEGMENT3 LIKE '81%'
               GROUP BY SEGMENT3, SEGMENT4 ORDER BY 1, 2""")
for r in cur:
    print("   %-6s %-9s %d행" % r)
con.close()
