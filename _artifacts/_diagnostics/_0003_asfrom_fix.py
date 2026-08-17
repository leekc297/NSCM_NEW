#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 — AS_FROM_SITE(ATTRIBUTE10) 저장 키 정정 + 오늘 분리행 데이터 보완.

사용자 확정(2026-08-15): "NULL 일때 NULL 로 처리해주세요."

원인 (실측):
  저장 L10577~10580 이 주석은 "지워준다" 인데 실제로는 `'-'` 를 넣는다.
      UPDATE GT_DMF3_RESULTS SET V_ATTRIBUTE10 = '-' WHERE V_SCM_SITE_ID = V_ATTRIBUTE10;
  원장 실태: DM_PLN_MKT_FCST   ATTRIBUTE10 NULL 1,375,177 / '-' 6
             DM_PLN_MKT_FCST_C              NULL 10,071,376 / '-' 2
  ⇒ NULL 이 정본. `'-'` 는 오늘 저장분뿐이고, 조회는 기존 NULL 행을 읽으므로 화면에서 2행으로 갈린다.

조치
  ① 저장 정정 — `'-'` → `NULL`
  ② 데이터 보완 — 오늘 생긴 `'-'` 행을 NULL 로 되돌린다 (PK 충돌 사전 검증 후)
"""
import io, re, sys, json, pathlib, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0003_ASFROMSITE_20260815")
OUT.mkdir(parents=True, exist_ok=True)
LEDGERS = ['DM_PLN_MKT_FCST', 'DM_PLN_MKT_FCST_C',
           'DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C']

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

# ── 0) GT_DMF3_RESULTS.V_ATTRIBUTE10 NULL 허용 확인 ────────────────────────
cur.execute("""SELECT NULLABLE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='GT_DMF3_RESULTS' AND COLUMN_NAME='V_ATTRIBUTE10'""")
r = cur.fetchone()
print(f"[전제] GT_DMF3_RESULTS.V_ATTRIBUTE10 NULLABLE={r[0] if r else '(컬럼 없음)'}")
assert r and r[0] == 'Y', "NULL 불가 컬럼 — 정정 방식 재검토 필요"

# ── 1) '-' 를 쓰는 다른 지점이 있는지 전수 확인 ────────────────────────────
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
writers = [m.group(0).strip() for m in
           re.finditer(r"[^\n]*V_ATTRIBUTE10\s*=\s*'[^']*'[^\n]*", body)]
print(f"\n[전수] V_ATTRIBUTE10 에 리터럴 대입하는 구문 {len(writers)}곳")
for w in writers:
    print(f"   {' '.join(w.split())[:110]}")

# ── 2) SP 정정 ────────────────────────────────────────────────────────────
# ⚠ 이 패키지 원문은 **CRLF** 개행이다 — LF 기준 고정 문자열은 매칭되지 않는다(2026-08-15 실패).
#   개행을 정규식으로 흡수해 치환한다.
PAT = re.compile("[ \t]*UPDATE\s+SCM_MGR\.GT_DMF3_RESULTS\s+A\s*\r?\n" "[ \t]*SET\s+V_ATTRIBUTE10\s*=\s*'-'\s*\r?\n" "[ \t]*WHERE\s+V_SCM_SITE_ID\s*=\s*V_ATTRIBUTE10;")
NEW = """    /* ⭐ [E20260815-ASFROMNULL] 사용자 확정 2026-08-15: "NULL 일때 NULL 로 처리".
       바로 위 주석이 "Attribute10 을 지워준다" 인데 구현은 `'-'` 를 넣고 있었다.
       원장 실태 = NULL 이 정본(DM_PLN_MKT_FCST NULL 1,375,177 vs '-' 6 — '-' 는 오늘 저장분뿐).
       조회는 기존 NULL 행을 읽으므로, `'-'` 로 저장되면 **동일 정적항목이 AS_FROM_SITE 만 다른
       2행으로 갈라져** 화면에 중복 표시된다(2026-08-15 사용자 캡처).
       MSSQL 원본의 `ISNULL(...,'')` 이 변환 과정에서 `'-'` 로 바뀐 계보. */
    UPDATE SCM_MGR.GT_DMF3_RESULTS A
    SET    V_ATTRIBUTE10 = NULL
    WHERE  V_SCM_SITE_ID = V_ATTRIBUTE10;"""

n = len(PAT.findall(body))
print(f"\n[anchor] 저장 정정 대상 {n}곳")
assert n == 1, f"앵커 {n}회"
(OUT / "00_BACKUP_PKG_DMF0003_BODY.sql").write_text(
    "-- AS_FROM_SITE 정정 전 백업\nSET DEFINE OFF\nCREATE OR REPLACE " + body.rstrip() + "\n/\n",
    encoding="utf-8")
body2 = PAT.sub(lambda _: NEW, body, count=1)
(OUT / "01_PKG_DMF0003_BODY_ASFROM_NULL.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body2.rstrip() + "\n/\nSHOW ERRORS\n", encoding="utf-8")

# ── 3) 데이터 보완 — 대상 행 백업 + PK 충돌 검증 ──────────────────────────
print("\n=== 데이터 보완 대상 ===")
backup = {}
plan = []
for t in LEDGERS:
    cur.execute(f"SELECT COUNT(*) FROM {t} WHERE ATTRIBUTE10 = '-'")
    cnt = cur.fetchone()[0]
    if not cnt:
        print(f"   {t:<32} 0건 — 대상 없음")
        continue
    # PK 목록
    cur.execute("""SELECT cc.COLUMN_NAME FROM ALL_CONSTRAINTS k
                   JOIN ALL_CONS_COLUMNS cc ON k.OWNER=cc.OWNER AND k.CONSTRAINT_NAME=cc.CONSTRAINT_NAME
                   WHERE k.OWNER='SCM_MGR' AND k.TABLE_NAME=:1 AND k.CONSTRAINT_TYPE='P'
                   ORDER BY cc.POSITION""", [t])
    pk = [x[0] for x in cur.fetchall()]
    # ATTRIBUTE10 이 PK 에 없으면 NULL 로 바꿔도 PK 충돌 자체가 불가
    in_pk = 'ATTRIBUTE10' in pk
    on = " AND ".join(f"B.{c} = A.{c}" for c in pk if c != 'ATTRIBUTE10')
    cur.execute(f"""SELECT COUNT(*) FROM {t} A
                    WHERE A.ATTRIBUTE10 = '-'
                    AND EXISTS (SELECT 1 FROM {t} B
                                WHERE {on} AND B.ATTRIBUTE10 IS NULL)""")
    clash = cur.fetchone()[0]
    print(f"   {t:<32} '-'={cnt}건  ATTRIBUTE10∈PK={in_pk}  NULL짝(충돌후보)={clash}")
    # 원본 백업
    cur.execute(f"SELECT * FROM {t} WHERE ATTRIBUTE10 = '-'")
    cols = [c[0] for c in cur.description]
    backup[t] = {"columns": cols,
                 "rows": [[str(v) if v is not None else None for v in row] for row in cur.fetchall()]}
    plan.append((t, cnt, clash, in_pk))

stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
(OUT / f"02_BACKUP_ROWS_{stamp}.json").write_text(
    json.dumps(backup, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
print(f"\n[백업] 대상 행 원본 → 02_BACKUP_ROWS_{stamp}.json")

blocked = [t for t, c, cl, _ in plan if cl]
if blocked:
    print(f"\n⛔ NULL 짝이 있어 UPDATE 시 PK 충돌 가능: {blocked} — 중단하고 사용자 확인 필요")
    sys.exit(1)

# ── 4) 적용 ───────────────────────────────────────────────────────────────
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
cur.execute("CREATE OR REPLACE " + body2.rstrip())
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0003'")
e = cur.fetchone()[0]
print(f"\n[SP 배포] errors={e}")
assert e == 0, "컴파일 오류 — 데이터 변경 중단"

sqls = []
for t, cnt, _, _ in plan:
    cur.execute(f"UPDATE {t} SET ATTRIBUTE10 = NULL WHERE ATTRIBUTE10 = '-'")
    print(f"   [데이터] {t:<32} {cur.rowcount}건 → NULL")
    sqls.append(f"UPDATE {t} SET ATTRIBUTE10 = NULL WHERE ATTRIBUTE10 = '-';")
con.commit()
(OUT / "03_DATA_FIX.sql").write_text(
    "-- 오늘 저장으로 생긴 ATTRIBUTE10='-' 행을 NULL 로 환원\n"
    "-- PK 충돌 없음 실측 확인 후 적용 (NULL 짝 0건)\n"
    + "\n".join(sqls) + "\nCOMMIT;\n", encoding="utf-8")

print("\n=== 적용 후 검증 ===")
for t in LEDGERS:
    cur.execute(f"""SELECT SUM(CASE WHEN ATTRIBUTE10='-' THEN 1 ELSE 0 END),
                           SUM(CASE WHEN ATTRIBUTE10 IS NULL THEN 1 ELSE 0 END), COUNT(*)
                    FROM {t}""")
    a, b, c = [x or 0 for x in cur.fetchone()]
    print(f"   {t:<32} '-'={a}  NULL={b:,}  / {c:,}")
con.close()
