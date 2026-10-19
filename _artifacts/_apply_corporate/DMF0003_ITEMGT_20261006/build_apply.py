"""[E20261006-ITEMGT] PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST — 품목 원천을 뷰 → 임시테이블로 (AS-IS [E20260720-000270] 의도대로)

배경 (사용자 결정 2026-10-06 "TO-BE 에서 394행을 똑바로 수정하고, 이에 따라 제대로 동작하도록 보완"):
  AS-IS 운영 DMF0003_SAVE_MKT_FCST [E20260720-000270] 은 품목 원천을 뷰 DM_MST_ITEM_SINGLE_V 에서
  #TEMP_DM_MST_ITEM_SINGLE_V_ALL 로 바꿨으나, 적재 조건(L394)이 구분자 '^' 가 붙은 @p_division_id 와 비교돼 항상 0건이다.
  같은 날 앞서 넣은 [E20261006-ASISPARITY](그 0건 동작에 맞춘 비활성 8곳)를 걷어내고, 임시테이블을 올바른 사업부 값으로 적재한다.

방식: 지금 DB 원문(ALL_SOURCE) 위의 외과적 치환 (고유 매칭 assert).
  ① ASISPARITY 가드 8곳 + 설명 주석 3줄 제거 → 결과가 10-02 20:31:56 원문(md5 BASE_MD5)과 같아야 함
  ② 임시테이블 4종 초기화 DELETE 추가           (AS-IS #002)
  ③ 입력 적재 직후 ORI → A/B → V_ALL 3단 적재 추가 (AS-IS #004, 사업부 = 저장 대상 행의 사업부)
  ④ 저장 멤버 안 뷰 참조 6곳 → GT_DMF3_ITEM_SINGLE_V_ALL (AS-IS #009·#015·#023~026)

  python build_apply.py ddl      # 01_DDL_GT_DMF3_ITEM_SINGLE.sql 실행 (임시테이블 4종 · 인덱스 · 권한 · 시노님)
  python build_apply.py build    # 02_PKG_DMF0003_BODY.sql 생성만 (DB 변경 없음)
  python build_apply.py apply    # FRESH-GATE 후 적용 + 검증
"""
import sys, os, re, hashlib, json, datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0003"
TYP = "PACKAGE BODY"
MARK = "[E20261006-ITEMGT]"
OLD_MARK = "[E20261006-ASISPARITY]"
OLD_GUARD_IF = " AND 1 = 0 /* " + OLD_MARK + " */ THEN"
OLD_GUARD_SQL = "      AND  1 = 0  /* " + OLD_MARK + " */"
BASE_MD5 = "869b25fc452af7d9df4d2c73d675794d"   # ASISPARITY 적용 전 원문 (LAST_DDL 2026-10-02 20:31:56) — DMF0003_ASISPARITY_20261006/_fresh_state.json
VIEW = "SCM_MGR.DM_MST_ITEM_SINGLE_V"
GT_ALL = "SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL"
GTS = ["GT_DMF3_ITEM_SINGLE_ORI", "GT_DMF3_ITEM_SINGLE_A", "GT_DMF3_ITEM_SINGLE_B", "GT_DMF3_ITEM_SINGLE_V_ALL"]
LOAD_START = "    -- " + MARK + " 품목 원천 임시테이블 적재 (START)"
LOAD_END = "    -- " + MARK + " 품목 원천 임시테이블 적재 (END)"

INIT_BLOCK = """    /* """ + MARK + """ 품목 원천 임시테이블 4종 — 세션 유지형이라 앞 요청 잔존분을 비운다 (AS-IS [E20260720-000270] 사전 DROP 대응) */
    DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_ORI;
    DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_A;
    DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_B;
    DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL;"""

LOAD_BLOCK = LOAD_START + """
    --   AS-IS [E20260720-000270]_DP 입력시 문제 발생 件 : 뷰 DM_MST_ITEM_SINGLE_V 대신 SCM_MST_ITEM_SN(사업부 · ACTIVE_FLAG='Y')을
    --   ORI → A(품목별) / B(품목 앞 12자리별) → V_ALL 로 나눠 적재해 쓴다. 뷰와 달리 활성 품목만 담는다.
    --   AS-IS 운영본은 적재 조건이 구분자 '^' 가 붙은 @p_division_id 와 비교돼 0건이 되므로(L394),
    --   TO-BE 는 저장 대상 행의 사업부(GT_DMF3_RESULTS.V_DIVISION_ID)로 적재한다. (사용자 결정 2026-10-06)
    INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_ORI
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
    , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
         , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
         , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    FROM   SCM_MGR.SCM_MST_ITEM_SN
    WHERE  DIVISION_ID IN ( SELECT V_DIVISION_ID FROM SCM_MGR.GT_DMF3_RESULTS GROUP BY V_DIVISION_ID )
      AND  ACTIVE_FLAG = 'Y';

    INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_A
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)
         , MAX(T1.ITEM_CLASS)
         , MAX(T1.ITEM_CLASS_NAME)
         , MAX(T1.NICK_NAME)
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END)
               WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END
         , MAX(T1.MATERIAL_CLASS_NAME)
         , MAX(T1.ITEM_UOM)
         , MAX(T1.SPEC)
         , MAX(T1.MDM_PROJECT_NAME)
         , MAX(T1.MIN_CAPACITY)
         , MAX(T1.ACTIVE_FLAG)
         , MAX(T1.ENERGE)
         , MAX(T1.CELL_QUANTITY)
         , MAX(T1.SCP_EXTRA_SPEC)
    FROM   SCM_MGR.GT_DMF3_ITEM_SINGLE_ORI T1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

    INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_B
    ( DIVISION_ID, ITEM_ID
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)
         , MAX(FORECAST_INFO_PRODUCT_GROUP)
         , MAX(FORECAST_INFO_CELL_MODEL)
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)
         , MAX(FORECAST_INFO_SPEC)
         , MAX(FORECAST_INFOR_VERSION)
         , MAX(CELL_TYPE)
    FROM   SCM_MGR.GT_DMF3_ITEM_SINGLE_ORI
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

    INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_V_ALL
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
    , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID, T1.ITEM_ID
         , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
         , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
         , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
         , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_DMF3_ITEM_SINGLE_A T1
    JOIN   SCM_MGR.GT_DMF3_ITEM_SINGLE_B T2
      ON   T1.DIVISION_ID            = T2.DIVISION_ID
     AND   SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
           , T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
           , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
           , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
           , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
           , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC;
""" + LOAD_END


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def md5(s):
    return hashlib.md5(s.encode("utf-8")).hexdigest()


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "status": status, "md5": md5(src), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def one(lines, lo, hi, pred, what):
    hit = [i for i in range(lo, hi) if pred(lines[i])]
    assert len(hit) == 1, f"{what}: 매칭 {len(hit)}건 (1건이어야 함) — 원문이 바뀌었거나 이미 반영됨"
    return hit[0]


def unguard(src):
    """ASISPARITY 삽입분(가드 8 + 주석 3)만 제거 → 10-02 원문과 같아야 한다"""
    assert src.count(OLD_MARK) == 11, f"ASISPARITY 표시 {src.count(OLD_MARK)}건 (11건이어야 함)"
    out, n_note, n_sql, n_if = [], 0, 0, 0
    for l in src.split("\n"):
        if l.strip().startswith("-- " + OLD_MARK):
            n_note += 1
            continue
        if l.startswith(OLD_GUARD_SQL):
            n_sql += 1
            continue
        if OLD_GUARD_IF in l:
            l = l.replace(OLD_GUARD_IF, " THEN", 1)
            n_if += 1
        out.append(l)
    res = "\n".join(out)
    assert (n_note, n_sql, n_if) == (3, 4, 4), (n_note, n_sql, n_if)
    assert OLD_MARK not in res
    assert md5(res) == BASE_MD5, "가드 제거 결과가 10-02 20:31:56 원문과 다름 — 그 사이 다른 변경이 있음"
    return res


def member_range(lines):
    lo = one(lines, 0, len(lines), lambda l: l.startswith("  PROCEDURE P_DMF0003_SAVE_MKT_FCST"), "SAVE 멤버 시작")
    hi = one(lines, 0, len(lines), lambda l: re.match(r"\s*PROCEDURE P_DMF0003_CAR_FCST_EXCEL_UPLOAD\b", l) is not None, "다음 멤버 시작")
    assert lo < hi
    return lo, hi


def transform(src):
    assert MARK not in src, "이미 반영됨"
    base = unguard(src)
    lines = base.split("\n")
    lo, hi = member_range(lines)

    # ④ 뷰 참조 6곳 → 임시테이블 (줄 수 변화 없음 — 먼저 수행)
    pat = re.compile(r"\bSCM_MGR\.DM_MST_ITEM_SINGLE_V\b")
    hits = [i for i in range(lo, hi) if pat.search(lines[i])]
    want = ["FROM  SCM_MGR.DM_MST_ITEM_SINGLE_V T2", "JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V C"] + ["JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM"] * 4
    assert [lines[i].strip() for i in hits] == want, [lines[i].strip() for i in hits]
    for i in hits:
        lines[i] = pat.sub(GT_ALL, lines[i].rstrip()) + "  /* " + MARK + " 뷰 DM_MST_ITEM_SINGLE_V → 임시테이블 */"

    # ③ 3단 적재 — 입력 적재(FORALL) 뒤 첫 오류 분기 다음
    f = one(lines, lo, hi, lambda l: l.strip() == "FORALL I IN 1..L_INS_CNT", "입력 적재 FORALL")
    j = next(i for i in range(f, f + 60) if lines[i].strip() == "IF V_INVALID THEN")
    assert lines[j + 1].strip() == "GOTO ERR_RTN;" and lines[j + 2].strip() == "END IF;" and lines[j + 3].strip() == "", lines[j:j + 4]
    # ② 초기화 DELETE
    d = one(lines, lo, hi, lambda l: l.strip() == "DELETE FROM SCM_MGR.GT_DMF3_ITEM_SINGLE_V;", "초기화 구간")
    assert d < f < j
    # 뒤에서부터 삽입 (앞 인덱스 보존)
    lines[j + 3:j + 3] = [""] + LOAD_BLOCK.split("\n")
    lines[d + 1:d + 1] = INIT_BLOCK.split("\n")

    out = "\n".join(lines)
    lo2, hi2 = member_range(out.split("\n"))
    body = "\n".join(out.split("\n")[lo2:hi2])
    assert not pat.search(body), "저장 멤버에 뷰 참조 잔존"
    assert body.count(GT_ALL) == 6 + 2, body.count(GT_ALL)          # 치환 6 + 초기화 1 + 적재 1
    assert out.count(MARK) == 6 + 1 + 2, out.count(MARK)
    assert len(out.split("\n")) == len(base.split("\n")) + len(INIT_BLOCK.split("\n")) + 1 + len(LOAD_BLOCK.split("\n"))
    return base, out


def stamp(cur_state):
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    return f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={cur_state['last_ddl']} FETCHED={now} DB=ZIOUI1\n"


def run_ddl():
    txt = open(os.path.join(HERE, "01_DDL_GT_DMF3_ITEM_SINGLE.sql"), encoding="utf-8").read()
    blocks = [b[b.index("DECLARE"):].strip() for b in re.split(r"^/\s*$", txt, flags=re.M) if "DECLARE" in b]   # '/' 단독 줄로 구분된 PL/SQL 블록
    assert len(blocks) == 3, len(blocks)
    with connect() as con:
        cur = con.cursor()
        for b in blocks:
            cur.execute(b)
        cur.execute("SELECT table_name, temporary, duration FROM all_tables WHERE owner='SCM_MGR' AND table_name IN (%s) ORDER BY 1" % ",".join("'%s'" % g for g in GTS))
        print("tables", cur.fetchall())
        cur.execute("SELECT index_name, table_name FROM all_indexes WHERE owner='SCM_MGR' AND table_name LIKE 'GT_DMF3_ITEM_SINGLE%'")
        print("indexes", cur.fetchall())
        cur.execute("SELECT table_name, COUNT(*) FROM all_tab_privs WHERE table_schema='SCM_MGR' AND grantee='SCMP_APP' AND table_name IN (%s) GROUP BY table_name ORDER BY 1" % ",".join("'%s'" % g for g in GTS))
        print("grants", cur.fetchall())
        cur.execute("SELECT synonym_name FROM all_synonyms WHERE owner='SCMP_APP' AND synonym_name IN (%s) ORDER BY 1" % ",".join("'%s'" % g for g in GTS))
        print("synonyms", [r[0] for r in cur.fetchall()])


def build(cur):
    cur_state = read_source(cur)
    base, new = transform(cur_state["src"])
    with open(os.path.join(HERE, "00_BACKUP_PKG_DMF0003_BODY.sql"), "w", encoding="utf-8", newline="\n") as f:
        f.write(f"-- 적용 직전 DB 원문 (LAST_DDL {cur_state['last_ddl']} · md5 {cur_state['md5']})\n" + ddl_text(cur_state["src"]) + "/\n")
    with open(os.path.join(HERE, "_unguarded_base_body.txt"), "w", encoding="utf-8", newline="\n") as f:
        f.write(base)
    with open(os.path.join(HERE, "02_PKG_DMF0003_BODY.sql"), "w", encoding="utf-8", newline="\n") as f:
        f.write(stamp(cur_state) + "-- " + MARK + " 품목 원천 뷰 → 임시테이블 (AS-IS [E20260720-000270] 의도대로) · ASISPARITY 가드 제거\n" + ddl_text(new) + "/\n")
    print("BUILD current", cur_state["last_ddl"], cur_state["md5"], "| lines", len(cur_state["src"].split("\n")), "→", len(new.split("\n")))
    return cur_state, new


def apply():
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name IN (%s)" % ",".join("'%s'" % g for g in GTS))
        assert cur.fetchone()[0] == 4, "임시테이블 4종이 없음 — 먼저 `python build_apply.py ddl`"
        cur_state, new = build(cur)
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 방금 읽은 기준본
        now = read_source(cur)
        if now["md5"] != cur_state["md5"] or now["last_ddl"] != cur_state["last_ddl"]:
            sys.exit("FRESH-GATE FAIL: 착수 후 DB 원문 변경 — 중단")
        print("FRESH-GATE PASS", now["last_ddl"], now["md5"])
        cur.execute(ddl_text(new).rstrip())
        after = read_source(cur)
        cur.execute("SELECT line, position, text FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=PKG)
        errs = cur.fetchall()
        cur.execute("SELECT object_name, object_type FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' "
                    "AND object_name IN (SELECT name FROM all_dependencies WHERE referenced_owner='SCM_MGR' AND referenced_name=:n)", n=PKG)
        inv = cur.fetchall()
        print("AFTER", after["last_ddl"], after["status"], "errors", errs, "same_as_built", after["src"].rstrip() == new.rstrip(),
              "dependent_invalid", inv)
        json.dump({"before": {k: cur_state[k] for k in ("last_ddl", "md5")}, "after": {k: after[k] for k in ("last_ddl", "status", "md5")},
                   "errors": [list(e) for e in errs], "dependent_invalid": [list(i) for i in inv],
                   "same_as_built": after["src"].rstrip() == new.rstrip()},
                  open(os.path.join(HERE, "_apply_result.json"), "w", encoding="utf-8"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    if sys.argv[1:] == ["apply"]:
        apply()
    elif sys.argv[1:] == ["ddl"]:
        run_ddl()
    else:
        with connect() as con:
            build(con.cursor())
