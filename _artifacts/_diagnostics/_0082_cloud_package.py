#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 조회 튜닝 — 클라우드 이관 패키지 생성 (2026-08-15).

이번 변경은 **DB 단독**(FE/BE 변경 없음). 그래도 대상은 손나열이 아니라 기계 확인으로 정한다.
  ① 변경 객체 — PKG_DMF0082 BODY (4개 조치) + 신설 GTT
  ② 의존 폐포 — 패키지가 참조하는 객체 중 **클라우드에 없을 수 있는 것**을 전수 수집해 PRECHECK 로 낸다
     (룰: 이관패키지 GTT/TYPE DDL 자급 — 기존재 가정 금지)
  ③ 메타 축 — SCM_ADM_* 전 테이블에 'DMF0082' 스윕해 이번 변경으로 **메타가 바뀌었는지** 확인
"""
import io, re, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

ROOT = pathlib.Path(r"C:\Projects\NSCM")
PKG = ROOT / "_artifacts" / "_deploy_packages" / "DMF0082_PERF_CLOUD_20260815"
A_DB = PKG / "A_DB"
A_DB.mkdir(parents=True, exist_ok=True)

u, p_, d = conn_info()
con = oracledb.connect(user=u, password=p_, dsn=d)
cur = con.cursor()

def src(name, otype):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:1
                   AND TYPE=:2 ORDER BY LINE""", [name, otype])
    rows = cur.fetchall()
    return "".join(r[0] for r in rows), len(rows)

# ── ① 변경 객체 ────────────────────────────────────────────────────────────
spec, n1 = src("PKG_DMF0082", "PACKAGE")
body, n2 = src("PKG_DMF0082", "PACKAGE BODY")
assert n1 and n2, "PKG_DMF0082 원문 없음"
print(f"[변경객체] PKG_DMF0082 SPEC {n1}줄 / BODY {n2}줄")

marks = {
    "E20260815-PERF (조인순서 1차)":   body.count("E20260815-PERF]"),
    "E20260815-PERF2 (조인순서 2차)":  body.count("E20260815-PERF2]"),
    "E20260815-SENTINEL (센티널+dedup)": body.count("E20260815-SENTINEL]"),
    "E20260815-SPLIT2GTT (함수→GTT)":  body.count("E20260815-SPLIT2GTT]"),
}
print("[적용 마커 실측]")
for k, v in marks.items():
    print(f"   {k:<34} {v}곳")
assert all(v > 0 for v in marks.values()), "적용 마커 누락 — 배포본 확인 필요"

# ── ② 의존 폐포 — 패키지가 참조하는 GTT / TYPE / FUNCTION ──────────────────
gtts = sorted(set(re.findall(r"\b(GT_[A-Z0-9_]+)\b", body)))
fns  = sorted(set(re.findall(r"\b(UF_[A-Z0-9_]+|FN_[A-Z0-9_]+)\b", body, re.I)))
print(f"\n[의존] GTT {len(gtts)}개 / 함수 {len(fns)}개")

cur.execute("""SELECT TABLE_NAME, TEMPORARY FROM ALL_TABLES WHERE OWNER='SCM_MGR'
               AND TABLE_NAME IN (%s)""" % ",".join(f"'{g}'" for g in gtts))
gtt_info = {r[0]: r[1] for r in cur.fetchall()}
missing = [g for g in gtts if g not in gtt_info]
print(f"   사내 실재 GTT {len(gtt_info)} / 미발견 {len(missing)} {missing[:5]}")

# 신설 GTT DDL (이번 이관에 반드시 포함)
NEWGTT = "GT_DMF0082_PARAM_TOKEN"
cur.execute("""SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH FROM ALL_TAB_COLUMNS
               WHERE OWNER='SCM_MGR' AND TABLE_NAME=:1 ORDER BY COLUMN_ID""", [NEWGTT])
cols = cur.fetchall()
assert cols, f"{NEWGTT} 미발견"
ddl = (f"CREATE GLOBAL TEMPORARY TABLE SCM_MGR.{NEWGTT}\n( "
       + "\n, ".join(f"{c[0]:<10} {c[1]}({c[2]} CHAR)" for c in cols)
       + "\n) ON COMMIT PRESERVE ROWS;")
cur.execute("""SELECT INDEX_NAME FROM ALL_INDEXES WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME=:1""", [NEWGTT])
idxs = [r[0] for r in cur.fetchall()]
idx_ddl = "\n".join(f"CREATE INDEX SCM_MGR.{i} ON SCM_MGR.{NEWGTT} (PARAM_NM);" for i in idxs)
print(f"\n[신설 GTT] {NEWGTT} — 컬럼 {len(cols)} / 인덱스 {idxs}")

# ── ③ 메타 축 스윕 (이번 변경으로 메타가 바뀌었는지 기계 확인) ──────────────
cur.execute("""SELECT c.TABLE_NAME, c.COLUMN_NAME FROM ALL_TAB_COLUMNS c
               JOIN ALL_TABLES t ON t.OWNER=c.OWNER AND t.TABLE_NAME=c.TABLE_NAME
               WHERE c.OWNER='SCM_MGR' AND c.TABLE_NAME LIKE 'SCM\\_ADM\\_%' ESCAPE '\\'
               AND c.DATA_TYPE IN ('VARCHAR2','CHAR','NVARCHAR2')""")
pairs = cur.fetchall()
hits = {}
for tab, col in pairs:
    try:
        cur.execute(f'SELECT COUNT(*) FROM "SCM_MGR"."{tab}" WHERE "{col}" LIKE :1', ['%DMF0082%'])
        n = cur.fetchone()[0]
        if n:
            hits.setdefault(tab, []).append((col, n))
    except Exception as ex:
        sys.exit(f"⛔ 스윕 실패 {tab}.{col}: {ex}")
print(f"\n[메타 스윕] DMF0082 보유 축 {len(hits)}개 — 이번 변경은 **SP 단독**이라 메타 이관 없음")
for t in sorted(hits):
    print(f"   {t:<34}{[c for c,_ in hits[t]]}")

# ── 파일 생성 ─────────────────────────────────────────────────────────────
(A_DB / "00_PRECHECK.sql").write_text(f"""-- DMF0082 튜닝 이관 — 적용 전 의존 객체 확인 (전부 존재해야 함)
SET LINESIZE 200
SET PAGESIZE 200
PROMPT === 1) 참조 함수/타입 (없으면 패키지가 컴파일되지 않는다) ===
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME IN ('UF_FX_STRING_SPLITFORIN','T_STR_TAB','PKG_SCM_USER_MNU','FN_SCM_GET_WHERE_SQL')
 ORDER BY OBJECT_TYPE, OBJECT_NAME;

PROMPT === 2) 패키지가 참조하는 GTT ({len(gtts)}개) — 누락분은 별도 확보 필요 ===
SELECT T.TABLE_NAME, NVL(A.TEMPORARY,'(없음)') EXISTS_YN
  FROM (
{chr(10).join(f"        SELECT '{g}' AS TABLE_NAME FROM DUAL UNION ALL" for g in gtts[:-1])}
        SELECT '{gtts[-1]}' FROM DUAL) T
  LEFT JOIN ALL_TABLES A ON A.OWNER='SCM_MGR' AND A.TABLE_NAME=T.TABLE_NAME
 ORDER BY 2, 1;

PROMPT === 3) 대상 테이블 (조회 원천) ===
SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR'
 AND TABLE_NAME IN ('DM_PLN_CFM_SELLING_PRICE','DM_PLN_MKT_FCST','DM_PLN_CFM_MKT_DEMAND_PLAN',
                    'SCM_MST_FUTURE_PRICE','SCM_SYS_CALENDAR_M','DM_MST_VERSION')
 ORDER BY 1;
""", encoding="utf-8")

(A_DB / "01_DDL_GT_DMF0082_PARAM_TOKEN.sql").write_text(f"""-- ⭐ 신설 GTT — hook #129 §3.0 (테이블 함수 → GTT 선적재) 전용 토큰 보관
-- 이관 패키지 GTT DDL 자급 의무 (기존재 가정 금지). 이미 있으면 ORA-00955 로 건너뛴다.
SET DEFINE OFF
{ddl}
{idx_ddl}
""", encoding="utf-8")

(A_DB / "02_PKG_DMF0082_SPEC.sql").write_text(
    "-- 스펙 무변경분이나 본문과 세대를 맞추기 위해 동봉\nSET DEFINE OFF\n\nCREATE OR REPLACE "
    + spec.rstrip() + "\n/\nSHOW ERRORS\n", encoding="utf-8")
(A_DB / "03_PKG_DMF0082_BODY.sql").write_text(
    "-- DMF0082 조회 튜닝 4개 조치 적용본 (사내 2026-08-15)\nSET DEFINE OFF\n\nCREATE OR REPLACE "
    + body.rstrip() + "\n/\nSHOW ERRORS\n", encoding="utf-8")

(A_DB / "90_VERIFY.sql").write_text(f"""-- DMF0082 튜닝 이관 검증
SET LINESIZE 200
PROMPT === 객체 상태 (VALID 여야 함) ===
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('PKG_DMF0082','{NEWGTT}') ORDER BY 2,1;

PROMPT === 컴파일 오류 (0 이어야 함) ===
SELECT COUNT(*) ERR_CNT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082';

PROMPT === 적용 마커 4종 (각 1 이상이어야 함) ===
SELECT 'PERF(1차 조인순서)' ITEM, COUNT(*) CNT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260815-PERF]%'
UNION ALL SELECT 'PERF2(2차 조인순서)', COUNT(*) FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260815-PERF2]%'
UNION ALL SELECT 'SENTINEL(센티널+dedup)', COUNT(*) FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260815-SENTINEL]%'
UNION ALL SELECT 'SPLIT2GTT(함수→GTT)', COUNT(*) FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260815-SPLIT2GTT]%';

PROMPT === 테이블 함수 잔존 (선적재 16곳만 남아야 정상) ===
SELECT COUNT(*) SPLIT_FN_CNT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'
   AND UPPER(TEXT) LIKE '%UF_FX_STRING_SPLITFORIN%' AND LTRIM(TEXT) NOT LIKE '--%';
""", encoding="utf-8")

# 롤백
(A_DB / "99_ROLLBACK_안내.md").write_text("""# 롤백

패키지 본문만 되돌리면 된다(신설 GTT 는 남겨도 무해 — 아무도 참조하지 않게 된다).

```
사내 백업본 = _artifacts/_apply_corporate/DMF0082_PERF_20260815/00_BACKUP_PKG_DMF0082_BODY_20260815.sql
             (튜닝 착수 전 원본, 707KB)
```

클라우드에서 되돌리려면 **적용 직전 클라우드 본문을 먼저 백업**해 두고 그것으로 복원한다.
사내 백업본은 사내 세대라 클라우드와 다를 수 있다.
""", encoding="utf-8")

README = f"""# DMF0082 조회 튜닝 — 클라우드 이관 (2026-08-15)

## 적용 순서

```
A_DB/00_PRECHECK.sql                     ← 먼저 실행. 의존 객체 누락 확인
A_DB/01_DDL_GT_DMF0082_PARAM_TOKEN.sql   ← 신설 GTT (이미 있으면 ORA-00955 → 무시)
A_DB/02_PKG_DMF0082_SPEC.sql
A_DB/03_PKG_DMF0082_BODY.sql
A_DB/90_VERIFY.sql                       ← 적용 후. 전 항목 확인
```

**FE/BE 변경 없음** — 이번 이관은 DB 단독이다.

## 변경 내용 (4건)

| 마커 | 조치 | 실측 효과 |
|---|---|---|
| `E20260815-PERF` | `TEMP_FCST_N_PRICE` INSERT — `T_WS_FCST` 조인 → **EXISTS 세미조인**(곱집합 14배 제거) + `LEADING(A) USE_HASH(B) USE_HASH(C)` | **170s → 1s** |
| `E20260815-PERF2` | `T_LAST_DATA_SETUP_PRICE` INSERT — `LEADING(A) USE_HASH(C)` | **14s → 소멸** |
| `E20260815-SENTINEL` | `PLANT_SITE_ID` 센티널 통일(`NULL`/`' '`/`'-'`/`'--'`/`CHR(0)` → `'-'`) + `ROW_NUMBER` dedup(QTY 최대) | **17,482 → 7,090행** |
| `E20260815-SPLIT2GTT` | `UF_FX_String_SplitForIN` **19곳** → `GT_DMF0082_PARAM_TOKEN` 선적재 치환 | 반복 파이프라인 호출 제거 |

## 근본 원인 (공통)

GTT(`GT_DMF0082_TEMP_SITE_ITEM`)는 세션 데이터라 통계가 없어 **추정 카디널리티가 1** 로 굳는다
(실제 14,879). 그 결과 옵티마이저가 GTT 들을 `MERGE JOIN CARTESIAN` 으로 묶어 대형 테이블
(`DM_PLN_CFM_SELLING_PRICE`, div40 103만행)을 **행별 인덱스 조회**했다.

```
buffer_gets 53,643,522 / 결과 0행 / 25분 경과 후에도 미완
ASH: ON CPU 100% → latch: cache buffers chains
```

인덱스는 이미 있었다(PK). 문제는 **그 인덱스를 5,364만 번 탄 것**이다.

## 성능 실측

| 시점 | SP | fetch | 결과 |
|---|---:|---:|---:|
| 튜닝 전 | 25분 미완(강제 종료) | — | — |
| 튜닝 후 | **12.9s** | **2.6s** | **7,090행** |

## ⚠ 적용 시 주의

1. **패키지 재컴파일은 조회 세션이 없을 때** — 실행 중이면 `library cache pin` 으로 대기하다
   `ORA-04021` 로 실패한다(사내 실사고). `DDL_LOCK_TIMEOUT` 을 넉넉히 주거나 조회 종료 후 적용.
2. **`GT_DMF0082_PARAM_TOKEN` 이 없으면 패키지가 컴파일되지 않는다** — 01 을 먼저 적용할 것.
3. 센티널 dedup 은 **QTY 최대 채택**(사용자 확정 B). 값이 같은 그룹(88%)은 원값 유지,
   다른 그룹(실측 16,395)만 최대값이 남는다. ⛔ SUM 은 채택하지 않았다 — 동일 복제본이 다수라
   합산하면 그만큼 값이 부풀어 오른다.

## 메타 이관 없음 (기계 확인)

`SCM_ADM_*` 전 테이블 × 문자형 컬럼을 `'DMF0082'` 로 스윕한 결과 {len(hits)}개 축이 존재하나,
**이번 변경은 SP 본문 단독**이라 메타 행은 바뀌지 않았다. 따라서 메타 INSERT/UPDATE 없음.

```
{chr(10).join(f"   {t}" for t in sorted(hits))}
```

## 롤백

`99_ROLLBACK_안내.md` 참조. 적용 직전 **클라우드 본문을 먼저 백업**할 것.
"""
(PKG / "_README.md").write_text(README, encoding="utf-8")

lines = ["# DMF0082 튜닝 이관 파일 목록", ""]
for f in sorted(PKG.rglob("*")):
    if f.is_file():
        lines.append(f"- `{f.relative_to(PKG).as_posix()}`  ({f.stat().st_size:,} bytes)")
(PKG / "_FILELIST.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"\n[DONE] {PKG}")
for f in sorted(PKG.rglob("*")):
    if f.is_file():
        print(f"   {f.relative_to(PKG).as_posix():<44}{f.stat().st_size:>10,}")
con.close()
