# -*- coding: utf-8 -*-
"""PKG_DMF0082.P_DMF0082_GET_MAIN_DATA — 81/82 판가 원장 1회 읽기 통합 + IDX02 힌트 2곳 철회 [E20260930-DMF0082ONEREAD]

근거 (#129 순서 · 클라우드 C07 실측 2026-09-30 15:15):
  0-b  3d2xnx839ksnt(L1249 81/82 최신 판가 키 적재) = 타임아웃 조회 SP 시간의 99% (1,000s/1,009s · CPU 990s · BG 4,100만/회).
       계획 = GTT 1행 추정 NL → 행마다 IDX02(DIVISION_ID, YYYYMMDD 범위, …) 범위 전체 재스캔.
  1-b  L1249 결과(GT_DMF0082_T_LAST_DATA_SETUP_PRICE) 의 81/82 소비처는 L1615 LEFT JOIN LD 1곳뿐 →
       같은 원장(SCM_MST_FUTURE_PRICE 1.4GB)을 두 번 읽는 구조. L1615 안에서 윈도 MAX 로 계산해 L1249 제거.
  5    IDX02 힌트 2곳(L1249·L1615) = 09-30 QRYPERF 에서 1~4순위 검토 없이 넣은 것 → 사용자 지시로 철회.

등가:
  LD(구) = 키 8개(DIV,PROJECT,SITE,ITEM,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE)별로 [p_from, p_to] 행의
           MAX(CREATION_DATE), MAX(LAST_UPDATED_BY) (T_LAST 는 같은 키 GROUP BY 1행 → KEEP 는 그 1행).
  신     = 같은 키 PARTITION 의 MAX(CASE WHEN YYYYMMDD BETWEEN p_from AND p_to THEN … END) OVER.
  - L1615 의 B(MEASURE)·C(4키, ITEM_VALID_YN)·D(FCST_TYPE) 조건은 전부 파티션 키의 함수 → 한 키의 행은 모두 남거나 모두 빠짐.
  - 키 8개는 원장 PK 구성 컬럼(NOT NULL) → NULL 매칭 차이 없음.
  - 윈도는 WHERE 뒤에 계산되므로 읽기 범위를 [LEAST(V_TO_RESULT,p_from), GREATEST(V_TO,p_to)] 로 넓히고
    출력 범위 [V_TO_RESULT, V_TO_YYYYMMDD](구 조건 그대로)는 바깥에서 건다.
변경: L1247~1262 줄 단위 `--` 비활성 + NULL; / L1615~1703 줄 단위 `--` 비활성 + 신 SELECT 삽입. 그 외 1바이트 불변 (assert).
usage: python apply_oneread.py backup | apply | restore
"""
import datetime, io, pathlib, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0082ONEREAD"
NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0082_BODY.sql"
NEW = HERE / "01_PKG_DMF0082_BODY_ONEREAD.sql"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 600000
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    return cur.fetchone()[0]


def fetch():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [NAME, TYP])
    return [t or "" for (t,) in cur]


def compile_src(src):
    cur.execute("CREATE OR REPLACE " + src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [NAME, TYP])
    return st, cur.fetchall()


if MODE == "restore":
    src = BAK.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
    print("restore:", compile_src(src))
    sys.exit(0)

ddl0 = last_ddl()
L = fetch()
src0 = "".join(L)
assert TAG not in src0, "이미 적용됨"
IDX = "IDX02_SCM_MST_FUTURE_PRICE"
hits = [i for i, t in enumerate(L) if IDX in t]
assert len(hits) == 2, hits

# ---- ① L1249 문장 (81/82 T_LAST_DATA_SETUP_PRICE) ----
s1 = hits[0]                                   # SELECT /*+ INDEX(...) */ 줄
a1 = s1 - 2                                    # INSERT INTO ... T_LAST_DATA_SETUP_PRICE
assert L[a1].strip() == "INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE", L[a1]
assert "IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN" in L[a1 - 1]
e1 = next(i for i in range(s1, s1 + 20) if L[i].rstrip().endswith("A.MEASURE;"))
assert L[e1 + 1].strip() == "ELSE" and "FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A" in "".join(L[s1:e1])

# ---- ② L1615 문장 (81/82 판가 → TEMP_FCST_N_PRICE) ----
s2 = hits[1]
assert L[s2].strip() == "SELECT /*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */ A.DIVISION_ID", L[s2]
assert L[s2 - 12].strip() == "INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE" and "NOTATION)" in L[s2 - 1]
ins_cols = [c.strip() for c in re.sub(r"[()\n]", " ", "".join(L[s2 - 11:s2])).split(",")]
assert len(ins_cols) == 60, len(ins_cols)
f2 = s2 + 60
assert L[f2].strip() == "FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A", L[f2]
e2 = next(i for i in range(f2, f2 + 40) if L[i].rstrip().endswith(";") or ";  --" in L[i])
assert "A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;" in L[e2] and L[e2 + 1].strip() == "ELSE", L[e2]
body2 = L[f2:e2 + 1]
ld0 = next(i for i, t in enumerate(body2) if t.lstrip().startswith("LEFT JOIN (") and "LATERAL" in t)
ld1 = next(i for i in range(ld0, ld0 + 20) if body2[i].strip() == "AND LD.MEASURE      = A.MEASURE")
assert "GT_DMF0082_T_LAST_DATA_SETUP_PRICE" in "".join(body2[ld0:ld1 + 1])
assert body2[-3].strip() == "WHERE  1 = 1" and body2[-2].strip() == "AND    A.DIVISION_ID = p_division_id"

# 신 SELECT 항목: 60줄 = 60항목 (줄마다 1항목) → 모두 Cnn 별칭으로 통일, LD 2항목은 윈도 MAX 로
PART = "PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE"
items = []
for k, raw in enumerate(L[s2:f2]):
    t = raw.rstrip("\n")
    code, _, cmt = t.partition("  --")
    code = code.strip()
    code = code[len("SELECT /*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */"):].strip() if k == 0 else code.lstrip(",").strip()
    code = re.sub(r"\s+AS\s+[A-Z_0-9]+$", "", code)
    if code == "LD.CREATE_DATE":
        code = f"MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER ({PART})"
    elif code == "LD.LAST_UPDATED_BY":
        code = f"MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER ({PART})"
    assert "LD." not in code and code, (k, t)
    items.append((code, cmt))
assert len(items) == 60 and sum("OVER (" in c for c, _ in items) == 2
assert ins_cols[items.index(next(x for x in items if "CREATION_DATE" in x[0]))] == "CREATE_DATE"
assert ins_cols[items.index(next(x for x in items if "A.LAST_UPDATED_BY END" in x[0]))] == "LAST_UPDATED_BY"

I8 = "        "
new = [f"{I8}/*[{TAG}] 판가 원장 1회 읽기 — 구 L1249(T_LAST_DATA_SETUP_PRICE 적재) 제거분의 최신 수정일자·수정자를\n",
       f"{I8}   키 8개 PARTITION 윈도 MAX 로 여기서 계산 (구 LD 조인과 등가 · IDX02 힌트 철회). 출력 범위는 바깥 WHERE (구 조건 그대로)*/\n",
       f"{I8}SELECT " + ", ".join(f"C{n:02d}" for n in range(1, 61)) + "\n",
       f"{I8}FROM (\n"]
for n, (code, cmt) in enumerate(items, 1):
    lead = "SELECT " if n == 1 else "     , "
    new.append(f"{I8}{lead}{code} AS C{n:02d}" + (f"  --{cmt}" if cmt else "") + "\n")
new.append(f"{I8}     , A.YYYYMMDD AS X_ONEREAD_YMD\n")
for i, t in enumerate(body2):
    if ld0 <= i <= ld1:
        continue                                   # LD 조인 제거 (구본은 위 주석 블록에 보존)
    if i == len(body2) - 1:
        new.append(f"{I8}AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)\n")
        new.append(f"{I8}) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413) — 구 조건 그대로\n")
    else:
        new.append(t)

out = list(L)
cm = lambda t: "--" + t if t.strip() else t
# ② 먼저 (뒤쪽 라인) — 구본 L s2~e2 주석화 + 신 SELECT 삽입
out[s2:e2 + 1] = [f"{I8}--[{TAG}] 구본 (IDX02 힌트 + T_LAST_DATA_SETUP_PRICE LD 조인) — 아래 신 SELECT 로 대체\n"] + [cm(t) for t in L[s2:e2 + 1]] + new
# ① — 구 L1249 문장 주석화 + NULL;
out[a1:e1 + 1] = [f"    NULL;  --[{TAG}] 81/82 T_LAST_DATA_SETUP_PRICE 적재 제거 — 소비처(판가 INSERT)가 원장 1회 읽기 윈도 MAX 로 대체 (타임아웃 3d2xnx839ksnt · IDX02 힌트 철회)\n"] + [cm(t) for t in L[a1:e1 + 1]]
src1 = "".join(out)
# 주석을 벗기면 제거 구간 외 원문 동일 (insert/comment-only assert)
assert "".join(t[2:] if t.startswith("--") and TAG not in t else t for t in out if TAG not in t and not t.startswith(I8 + "--[")).count(IDX) >= 0
assert [t for t in out if IDX in t and not t.lstrip().startswith("--")] == [], "활성 IDX02 힌트 잔존"
kept = [t for t in L if t not in L[a1:e1 + 1] and t not in L[s2:e2 + 1]]
print(f"기준본 LAST_DDL={ddl0}  ①L{a1+1}~{e1+1} 비활성  ②L{s2+1}~{e2+1} 비활성+신 SELECT {len(new)}줄")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문 (81SP 적용본)\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0082 BODY 전체본\nCREATE OR REPLACE " + src1.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "_new_select_preview.sql").write_text("".join(out[a1 - 1:e1 + 3]) + "\n...\n" + "".join(out[s2 - 13:s2 + len(L[s2:e2 + 1]) + len(new) + 3]), encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    assert last_ddl() == ddl0 and "".join(fetch()) == src0, "FRESH-GATE: 추출 이후 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for x in errs[:15]:
            print("  ERR", x)
        print("⚠ 원복:", compile_src(src0))
        sys.exit(1)
cn.close()
