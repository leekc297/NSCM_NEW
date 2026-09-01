import sys, os, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
OUT = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0074_D4D5_20260827"; os.makedirs(OUT, exist_ok=True)
u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def src(t):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE=:t ORDER BY LINE", t=t)
    return [r[0] for r in cur.fetchall()]

spec, body = src("PACKAGE"), src("PACKAGE BODY")
ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
open(os.path.join(OUT, f"BACKUP_PKG_DMF0074_{ts}.sql"), "w", encoding="utf-8").write(
    "CREATE OR REPLACE " + "".join(spec) + "\n/\nCREATE OR REPLACE " + "".join(body) + "\n/\n")
if "E20260827-D4-NOLOADGUARD" in "".join(body):
    print("already applied — abort"); sys.exit(0)
L = body[:]
def ln(i): return " ".join(L[i - 1].split())   # 공백 정규화 (원문 들여쓰기/정렬 무관)
# ---- anchors ----
assert ln(927) == "V_COUNT PLS_INTEGER;", ln(927)
assert "MESSAGE_TEXT = 'Invalid Sales Plan Waterfall MODEL.'" in ln(1750), ln(1750)
assert ln(1748).strip().startswith("UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW"), ln(1748)
assert "Sales Site 체크" in ln(1842), ln(1842)
assert ln(1841).strip().startswith("/* ####"), ln(1841)
assert "V_LOG_TYPE := 'C23';" in ln(1900), ln(1900)
assert ln(1905).strip().startswith("------"), ln(1905)
assert ln(3937).strip() == "END IF;" and ln(3939).strip() == "COMMIT;", (ln(3937), ln(3939))
assert "OPEN O_RESULT_CURSOR FOR" in ln(3950) and "'0' AS CODE, 'SUCCESS' AS MSG" in ln(3951)
S = "@#@#@#"
guard = [
"        /* [E20260827-D4-NOLOADGUARD] P_MODE>0 인데 실제로 아무것도 적재하지 않았으면 SUCCESS 를 돌려주지 않는다.\n",
"           1) 검증 오류 잔존(V_COUNT>0) -> IF 블록을 통째로 건너뛰므로 원장 delta 0 인데 CODE='0' 이 나가던 결함(D4).\n",
"           2) 적재 후보(Metal Link=Y, Exception<>Y, Key 1종 이상)가 있는데 이력 적재 0건 -> 조인 붕괴 = 허위 성공.\n",
"           (Metal Link=N 만 있는 파일은 후보 0 이라 종전대로 SUCCESS/EVENT=0 -- 설계상 적재 대상 없음)\n",
"           DMF0014 '허위성공 차단 (2)' 와 동일 계보. */\n",
"        IF NVL(P_MODE, 0) > 0 THEN\n",
"            IF NVL(V_COUNT, 0) > 0 THEN\n",
"                OPEN O_RESULT_CURSOR FOR\n",
"                SELECT '-1' AS CODE\n",
"                     , 'ERR_RTN: - Validation errors remain (' || V_COUNT || ' rows) - nothing loaded' AS MSG\n",
"                     , 'NOLOAD_ERRORS' AS EVENT\n",
"                  FROM DUAL;\n",
"                RETURN;\n",
"            END IF;\n",
"            SELECT COUNT(*)\n",
"              INTO V_LOAD_CAND\n",
"              FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD\n",
"             WHERE UPPER(METAL_LINK_YN) = 'Y'\n",
"               AND NVL(UPPER(METAL_EXCEPTION_YN), 'N') <> 'Y'\n",
"               AND (   APPLY_PRICE_TYPE_CODE1 IS NOT NULL OR APPLY_PRICE_TYPE_CODE2 IS NOT NULL OR APPLY_PRICE_TYPE_CODE3 IS NOT NULL\n",
"                    OR APPLY_PRICE_TYPE_CODE4 IS NOT NULL OR APPLY_PRICE_TYPE_CODE5 IS NOT NULL OR APPLY_PRICE_TYPE_CODE6 IS NOT NULL\n",
"                    OR APPLY_PRICE_TYPE_CODE7 IS NOT NULL );\n",
"            IF V_LOAD_CAND > 0 AND NVL(N_LOG_COUNT, 0) = 0 THEN\n",
"                OPEN O_RESULT_CURSOR FOR\n",
"                SELECT '-1' AS CODE\n",
"                     , 'ERR_RTN: - Save verify failed (candidates=' || V_LOAD_CAND || ', loaded=0)' AS MSG\n",
"                     , 'SAVE_VERIFY' AS EVENT\n",
"                  FROM DUAL;\n",
"                RETURN;\n",
"            END IF;\n",
"        END IF;\n",
"\n",
]
L[3949:3949] = guard                       # before OPEN ... SUCCESS (line 3950)
blk = L[1840:1905]                          # C21~C23 lines 1841..1905
del L[1840:1905]
marker = [
"        /* [E20260827-D5-ORDER] Sales Site(C21)/Currency(C22)/FCST type(C23) 단건 검증을 C19(Sales Plan Waterfall 조합 검증) 앞으로 이동.\n",
"           C19 가 Site/Currency/FCST type 을 조인 키로 포함해 먼저 걸리면 구체 메시지가 'Invalid Sales Plan Waterfall MODEL.' 로 가려졌다(D5, TC14~16).\n",
"           AS-IS(MSSQL DMF0074_EXCEL_UPLOAD) 도 C19 선행이었으나 사용자 안내 목적의 순서 정정(2026-08-27 사용자 요청). 판정 조건은 무변경. */\n",
]
L[1747:1747] = marker + blk                 # before C19 UPDATE (line 1748)
L[927:927] = ["   V_LOAD_CAND        PLS_INTEGER := 0; /* [E20260827-D4-NOLOADGUARD] 적재 후보 행수 */\n"]
new_body = "".join(L)
assert new_body.count("[E20260827-D4-NOLOADGUARD]") == 2 and new_body.count("[E20260827-D5-ORDER]") == 1
import re
def pos(tag):
    m = re.search(r"V_LOG_TYPE\s*:=\s*'%s';" % tag, new_body); assert m, tag; return m.start()
assert pos("C21") < pos("C19") and pos("C22") < pos("C19") and pos("C23") < pos("C19")
assert pos("C18") < pos("C21") and pos("C19") < pos("C20") < pos("C24")
assert len(L) == len(body) + len(guard) + len(marker) + 1
open(os.path.join(OUT, "PREVIEW_PKG_DMF0074_BODY.sql"), "w", encoding="utf-8").write("CREATE OR REPLACE " + new_body + "\n/\n")
print("preview written:", os.path.join(OUT, "PREVIEW_PKG_DMF0074_BODY.sql"), "lines", len(L))
if "--apply" not in sys.argv:
    print("preview-only (배포는 ora.py exec PREVIEW_PKG_DMF0074_BODY.sql 로 수행)"); sys.exit(0)
cur.execute("CREATE OR REPLACE " + new_body)
cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE")
errs = cur.fetchall(); print("compile errors:", len(errs)); [print("  ", e) for e in errs[:10]]
cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074'"); print(cur.fetchall())
cur.execute("SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY' AND (TEXT LIKE '%V_LOG_TYPE := ''C19'';%' OR TEXT LIKE '%V_LOG_TYPE := ''C21'';%' OR TEXT LIKE '%V_LOG_TYPE := ''C23'';%' OR TEXT LIKE '%E20260827-D%') ORDER BY LINE")
for r in cur.fetchall(): print("  L%d %s" % (r[0], r[1].strip()[:110]))
