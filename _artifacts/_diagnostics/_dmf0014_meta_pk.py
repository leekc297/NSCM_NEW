#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 메타 이관 SQL 재생성 — **실측 PK 기준 행단위 DELETE+INSERT**.

⛔ 1차 산출물의 문제: DELETE 조건을 매칭 컬럼 LIKE '%DMF0014%' 로 걸었다.
   `SCM_ADM_MSG_M` 은 MSG_DESC(설명문)로 매칭됐으므로 그 조건으로 지우면
   **클라우드에서 설명문이 다른 동일 코드는 안 지워지고, 무관한 행이 지워질 수** 있다.
   ⇒ 룰(메타 스냅샷 키 = PK/논리키 **실측** 의무)대로 PK 를 딕셔너리에서 읽어 행단위로 건다.

⛔ 이관 제외 2축 (기계 스윕에는 잡히지만 이관 대상이 아님):
   · SCM_ADM_EXCEL_UPLOAD        — 업로드 **스테이징 작업데이터** (테스트 잔여 132행)
   · SCM_ADM_USER_MNU_SRCH_COND_M — 사용자 **개인 조회조건** (TITLESET_USER 와 동류)
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

A_DB = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0014_CLOUD_20260814\A_DB")
# PK 가 없는 표의 논리키 — **실측 검증 후** 명시한다(추정 금지 룰).
#   SCM_ADM_EXCEL_COLUMNS: 전체 20행 / (PROGRAM_ID,SHEET_NAME) 조합 20개 = 유일 확인 (2026-08-14)
LOGICAL_KEY = {
    "SCM_ADM_EXCEL_COLUMNS": ["PROGRAM_ID", "SHEET_NAME"],
}

EXCLUDE = {
    "SCM_ADM_EXCEL_UPLOAD":         "업로드 스테이징 작업데이터 — 이관 대상 아님",
    "SCM_ADM_USER_MNU_SRCH_COND_M": "사용자 개인 조회조건 — 이관 대상 아님",
    # ⭐ [2026-08-14 사용자 확정] LBL/MSG 는 **신규 채번분만** 이관한다.
    #   "기존 코드에 명칭을 변경하면 기존 프로그램에 다른 TEXT 로 보이는 치명적 오류가 발생한다."
    #   LBL00754~00759 6종을 클라우드 등록내역과 1:1 대조한 결과 **전부 동일**(2026-08-14 실측)
    #   → 재사용이므로 META INSERT 자체가 불요. 덮어쓰면 위험만 남고 얻는 것이 없다.
    "SCM_ADM_MSG_M":                "LBL/MSG 기존 코드 재사용 — 클라우드와 문구 동일 실측(신규 채번 0건)",
}

u, p_, d = conn_info()
con = oracledb.connect(user=u, password=p_, dsn=d)
cur = con.cursor()

# ⚠ ALL_TAB_COLUMNS 는 **뷰의 컬럼까지 포함**한다(SCM_ADM_USER_MNU_EDIT_AUTH_V 등).
#   뷰는 이관 대상이 아니고 PK 도 없어 키 게이트에 걸린다 → ALL_TABLES 조인으로 **실테이블만** 남긴다.
cur.execute("""SELECT c.TABLE_NAME, c.COLUMN_NAME FROM ALL_TAB_COLUMNS c
               JOIN ALL_TABLES t ON t.OWNER = c.OWNER AND t.TABLE_NAME = c.TABLE_NAME
               WHERE c.OWNER='SCM_MGR' AND c.TABLE_NAME LIKE 'SCM\\_ADM\\_%' ESCAPE '\\'
               AND c.DATA_TYPE IN ('VARCHAR2','CHAR','NVARCHAR2') ORDER BY c.TABLE_NAME, c.COLUMN_ID""")
pairs = cur.fetchall()
hits = {}
for tab, col in pairs:
    try:
        cur.execute(f'SELECT COUNT(*) FROM "SCM_MGR"."{tab}" WHERE "{col}" LIKE :1', ['%DMF0014%'])
        if cur.fetchone()[0]:
            hits.setdefault(tab, []).append(col)
    except Exception as ex:
        sys.exit(f"⛔ 서베이 실패 {tab}.{col}: {ex}")

def pk_of(tab):
    cur.execute("""SELECT cc.COLUMN_NAME FROM ALL_CONSTRAINTS k
                   JOIN ALL_CONS_COLUMNS cc ON k.OWNER=cc.OWNER AND k.CONSTRAINT_NAME=cc.CONSTRAINT_NAME
                   WHERE k.OWNER='SCM_MGR' AND k.TABLE_NAME=:1 AND k.CONSTRAINT_TYPE='P'
                   ORDER BY cc.POSITION""", [tab])
    return [r[0] for r in cur.fetchall()]

def lit(v):
    if v is None: return "NULL"
    if hasattr(v, "read"): v = v.read()
    if isinstance(v, (int, float)): return str(v)
    return "'" + str(v).replace("'", "''") + "'"

AUDIT = {"CREATED_BY", "LAST_UPDATED_BY"}
out, summary = [], []
for tab in sorted(hits):
    if tab in EXCLUDE:
        summary.append((tab, "제외", EXCLUDE[tab]))
        out.append(f"\n-- ⛔ {tab} — 이관 제외: {EXCLUDE[tab]}")
        continue
    pk = pk_of(tab)
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                   AND TABLE_NAME=:1 ORDER BY COLUMN_ID""", [tab])
    meta = cur.fetchall()
    allc = [c for c, _ in meta]; dt = dict(meta)
    if not pk:
        pk = LOGICAL_KEY.get(tab)
        if not pk:
            sys.exit(f"⛔ {tab} PK/논리키 미검출 — 키 추정 금지(룰). 수동 확인 필요")
    where = " OR ".join(f'"{c}" LIKE \'%DMF0014%\'' for c in hits[tab])
    cur.execute(f'SELECT {",".join(chr(34)+c+chr(34) for c in allc)} FROM "SCM_MGR"."{tab}" WHERE {where}')
    rows = cur.fetchall()
    kind = "PK" if tab not in LOGICAL_KEY else "논리키(실측)"
    summary.append((tab, f"{len(rows)}행", f"{kind}={'+'.join(pk)}"))
    out.append(f"\n-- ═══ {tab} — {len(rows)}행 / PK={'+'.join(pk)} / 매칭컬럼={','.join(hits[tab])}")
    for r in rows:
        v = dict(zip(allc, r))
        dele = " AND ".join(f"{c} = {lit(v[c])}" for c in pk)
        out.append(f"DELETE FROM {tab} WHERE {dele};")
        vals = ["'admin'" if c in AUDIT else ("SYSDATE" if dt.get(c) == "DATE" else lit(v[c])) for c in allc]
        out.append(f"INSERT INTO {tab} ({', '.join(allc)}) VALUES ({', '.join(vals)});")

hdr = ["-- DMF0014 메타 이관 — 딕셔너리 전수 스윕 + **실측 PK 기준** 행단위 DELETE+INSERT (멱등)",
       "-- 감사컬럼='admin' / 날짜=SYSDATE",
       "-- ─── 축 요약 ───"]
for t, n, note in summary:
    hdr.append(f"--   {t:<32} {n:<8} {note}")
(A_DB / "10_META_DMF0014_ALL_AXES.sql").write_text(
    "\n".join(hdr) + "\nSET DEFINE OFF\n" + "\n".join(out) + "\n\nCOMMIT;\n", encoding="utf-8")

print("[축 요약]")
for t, n, note in summary:
    print(f"   {t:<34}{n:<8}{note}")
print(f"\n[생성] 10_META_DMF0014_ALL_AXES.sql")
con.close()
