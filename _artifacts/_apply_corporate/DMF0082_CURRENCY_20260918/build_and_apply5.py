# -*- coding: utf-8 -*-
"""
DMF0082 — 숨긴 PLANT_SITE_ID 가 그리드 행을 가르는 회귀 보완 (KEYCOLGRAIN 2차)

결함
  최종 커서는 PIVOT 이라 V_COLUMN 에 남은 모든 컬럼이 행 그레인이 된다.
    AS-IS : @V_COLUMN = C_TITLE(계정 컬럼설정) + NOTATION      → 숨긴 컬럼은 그레인 아님
    TO-BE : + [E20260822-KEYCOL] 저장 키 12컬럼 **무조건 추가**
  따라서 Column Setting 에서 숨긴 컬럼이어도 TO-BE 만 행이 갈린다.

  1차 보완([E20260918-KEYCOLGRAIN])은 CELL_PROD_SITE_ID 만 다뤘다.
  그러나 **PLANT_SITE_ID 도 같은 문제를 일으킨다.**

실증 (클라우드, 2026-09-18 · 계정 minyonglee1)
  · 보이는 컬럼 13개 = CELL_PROD_SITE_ID, CURRENCY, DIVISION_ID, DOM_EXP, END_CUSTOMER,
                       FCST_TYPE, INCOTERMS, ITEM_ID, MEASURE, NICK_NAME, SCM_SITE_ID,
                       TEAM_ID, VERSION_NO
    → **PLANT_SITE_ID 는 화면에 없다.** 그런데 KEYCOL 로 그레인에는 들어간다.
  · 같은 조회의 PLANT_SITE_ID 실값 (CURRENCY 조사 §2-2 실측)
        수요·실적 행 : NULL
        단가 행      : '-'
    → 값이 갈리는데 화면에는 안 보이므로 **똑같아 보이는 2줄**이 된다.
  · 사내 ZIOUI1 은 DIV 40 의 PLANT_SITE_ID 가 전 행 '-' (NULL 0건)라 재현되지 않는다.
        DM_PLN_CFM_MKT_DEMAND_PLAN 244,124행 / DM_PLN_SALES_PLAN_RESULT 38,008행
        / DM_PLN_CFM_SELLING_PRICE 567,972행 — 전부 '-'

보완
  MF_SP 적재 후, **PLANT_SITE_ID 가 C_TITLE 에 없을 때만** 업무키 단위 대표값으로 통일한다.
    · 표시 중인 계정은 손대지 않는다 (AS-IS 파리티 유지)
    · 대표값 = 계획 구간(BUCKET_KEY >= V_TO_RESULT) 우선·최신.
      편집·저장 대상이 계획 구간이므로 저장 키로도 이 값이 맞다.
    · 업무키에서 PLANT_SITE_ID 는 빼고 CELL_PROD_SITE_ID 는 넣는다(그쪽은 1차가 담당).
    · 양변 NVL 정규화 — MERGE ON 은 NULL 이면 매칭되지 않는다(E20260918-CURRNULLKEY 와 동일 사유).
    · 값이 1종뿐인 업무키는 손대지 않음(멱등).
"""
import re
import sys
import pathlib
import datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent

# PLANT_SITE_ID 를 통일할 때의 업무키 (PLANT_SITE_ID 제외, CELL_PROD_SITE_ID 포함)
BIZ = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
       "DOM_EXP", "FCST_TYPE", "INCOTERMS", "CELL_PROD_SITE_ID", "MEASURE"]

ANCHOR = """    -- ====================================================================================================
    -- [FIX 2026-07-22] 최종 동적 SQL — AS-IS(L5965~6085) 5분기 파리티 복원"""

PATCH = """    -- ====================================================================================================
    -- [E20260918-KEYCOLGRAIN2] 숨긴 PLANT_SITE_ID 가 행을 가르지 않게 대표값 통일
    --
    --   [E20260918-KEYCOLGRAIN](CELL_PROD_SITE_ID) 과 같은 사유. PLANT_SITE_ID 도
    --   KEYCOL 로 그레인에 강제 포함되므로, 화면에서 숨긴 계정은 AS-IS 에 없는 행분리가 난다.
    --
    --   클라우드 실측(2026-09-18, minyonglee1): 보이는 컬럼 13개에 PLANT_SITE_ID 가 없는데
    --     수요·실적 행 PLANT_SITE_ID = NULL / 단가 행 = '-'
    --   → 값이 갈리는데 화면에는 안 보여 **똑같아 보이는 2줄**이 된다.
    --   사내 ZIOUI1 은 DIV 40 이 전 행 '-' (NULL 0건)라 재현되지 않는다.
    --
    --   표시 중인 계정은 손대지 않는다(AS-IS 파리티). 대표값 = 계획 구간 우선·최신.
    -- ====================================================================================================
    SELECT COUNT(*)
      INTO V_USER_COL_CNT
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = VA_PROGRAM_ID
       AND U.SHEET_NAME = VA_SHEET_NAME
       AND U.USER_ID    = p_created_by
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
       AND U.COLUMN_NAME = 'PLANT_SITE_ID';

    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
                   SELECT {biz_sel}
                        , MAX(PLANT_SITE_ID) KEEP (DENSE_RANK LAST
                              ORDER BY CASE WHEN BUCKET_KEY >= V_TO_RESULT THEN 1 ELSE 0 END
                                     , BUCKET_KEY) AS REP_PLANT_SITE
                   FROM   SCM_MGR.GT_DMF0082_MF_SP
                   WHERE  PLANT_SITE_ID IS NOT NULL
                   GROUP BY {biz_grp}
                   HAVING COUNT(DISTINCT NVL(PLANT_SITE_ID, '~')) >= 1
               ) S
        ON ( {biz_on} )
        WHEN MATCHED THEN UPDATE SET T.PLANT_SITE_ID = S.REP_PLANT_SITE
        WHERE  NVL(T.PLANT_SITE_ID, '~') <> S.REP_PLANT_SITE;
    END IF;

""" + ANCHOR

PATCH = PATCH.format(
    biz_sel="\n                        , ".join("NVL({0}, '~') AS {0}".format(c) for c in BIZ),
    biz_grp="\n                        , ".join("NVL({0}, '~')".format(c) for c in BIZ),
    biz_on="\n         AND ".join("NVL(T.{0}, '~') = S.{0}".format(c) for c in BIZ))


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


with conn() as db:
    cur = db.cursor()
    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                      AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'""")
    st, ddl = cur.fetchone()
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                    AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    body = "".join(r[0] for r in cur)
    print("SOURCE-FRESH {}  LAST_DDL={}  STATUS={}  {} lines".format(
        datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), ddl, st, body.count(chr(10)) + 1))

    if "[E20260918-KEYCOLGRAIN2]" in body:
        print("이미 적용되어 있음 — 중단"); raise SystemExit(0)
    if "[E20260918-KEYCOLGRAIN]" not in body:
        raise SystemExit("선행 보완 [E20260918-KEYCOLGRAIN] 없음 — 중단")
    n = body.count(ANCHOR)
    if n != 1:
        raise SystemExit("앵커 {}회 — 1회여야 한다. 중단".format(n))

    new = body.replace(ANCHOR, PATCH)
    (D / "01_PKG_DMF0082_BODY.sql").write_text(new, encoding="utf-8")
    print("패치본 저장 — {} lines (+{})".format(
        new.count(chr(10)) + 1, new.count(chr(10)) - body.count(chr(10))))

    cur.execute("CREATE OR REPLACE " + new.lstrip())
    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                      AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'""")
    print("적용 후 STATUS={}  LAST_DDL={}".format(*cur.fetchone()))
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' ORDER BY SEQUENCE""")
    errs = cur.fetchall()
    if errs:
        for e in errs[:10]:
            print("   L{} P{} {}".format(*e))
        raise SystemExit(1)
    print("컴파일 오류 0건")
