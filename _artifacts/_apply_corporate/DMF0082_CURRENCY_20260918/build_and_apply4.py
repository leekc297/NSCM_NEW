# -*- coding: utf-8 -*-
"""
DMF0082 — 숨긴 저장키 컬럼이 그리드 행을 가르는 회귀 보완 (KEYCOL 그레인 오염)

결함
  최종 커서는 PIVOT 이므로 SELECT 목록(V_COLUMN)에 남은 **모든 컬럼이 행 그레인**이다.

    AS-IS : @V_COLUMN = C_TITLE(계정 컬럼설정) + NOTATION            → 숨긴 컬럼은 그레인 아님
    TO-BE : V_COLUMN  = C_TITLE + NOTATION
                        + [E20260822-KEYCOL] 저장 키 12컬럼 **무조건 추가**

  그래서 사용자가 Column Setting 에서 숨긴 컬럼(예: Cell Prod Site)이라도
  TO-BE 는 그레인에 남아 **AS-IS 에는 없는 행분리**가 난다.

실증
  · 클라우드 (Cell Prod Site 를 **표시**하는 계정) — 40 / Huapu_CN_CGU / MCSS22531-B3 / NT
      NJ01-A 61행(20260106~20270201) + HQ06-A 1행(20260531, -1350) → 2줄
      이 계정은 C_TITLE 에 CELL_PROD_SITE_ID 가 있으므로 **AS-IS 도 2줄** → 현행 유지가 맞다.
  · 사내 ZIOUI1 (Cell Prod Site 를 **숨긴** minyonglee1) — DIV 40
      KRW/LOC/MKT_FCST/SCM_FCST 각 12 업무키, RTF_SYS_RP 11 업무키가 CELL_PROD_SITE_ID 로 분리.
      AS-IS 라면 숨긴 컬럼이라 1줄인데 TO-BE 는 2줄 → **회귀**.

보완
  MF_SP 적재 완료 후, **C_TITLE 에 없는(=화면에 숨긴) KEYCOL 컬럼**에 한해
  업무키 단위 대표값으로 통일해 그레인에서 빠지게 한다.

    · 대상 판정 = SCM_MST_TITLESET_USER('C') 에 그 컬럼이 없을 때만
      → 표시 중인 계정은 **손대지 않는다** (AS-IS 파리티 유지)
    · 대표값 = 계획 구간(BUCKET_KEY >= V_TO_RESULT) 우선, 그중 최신.
      편집 대상이 계획 구간이므로 저장 키로도 이 값이 맞다.
    · 업무키 = DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID,
               DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE (양변 NVL 정규화)
    · 값이 1종뿐인 업무키는 어차피 변화 없음(멱등).

  CURRENCY 는 앞선 보완(CURRCELLPROD/CURRSITEITEM/CURRNULLKEY)이 이미 키 단위로 채우므로
  여기서 다시 건드리지 않는다. PLANT_SITE_ID / END_CUSTOMER 는 arm 간 불일치 실측 0건이라 제외.
"""
import re
import sys
import pathlib
import datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent

BIZ = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
       "DOM_EXP", "FCST_TYPE", "INCOTERMS", "PLANT_SITE_ID", "MEASURE"]

ANCHOR = """    -- ====================================================================================================
    -- [FIX 2026-07-22] 최종 동적 SQL — AS-IS(L5965~6085) 5분기 파리티 복원"""

PATCH = """    -- ====================================================================================================
    -- [E20260918-KEYCOLGRAIN] 숨긴 저장키 컬럼이 행을 가르지 않게 대표값 통일
    --
    --   최종 커서는 PIVOT 이라 V_COLUMN 에 남은 모든 컬럼이 행 그레인이 된다.
    --     AS-IS : @V_COLUMN = C_TITLE + NOTATION           → 숨긴 컬럼은 그레인 아님
    --     TO-BE : + [E20260822-KEYCOL] 저장 키 12컬럼 강제 추가
    --   그래서 Column Setting 에서 숨긴 컬럼이어도 TO-BE 만 행이 갈린다(AS-IS 부재 회귀).
    --   실측(ZIOUI1 2026-09-18, Cell Prod Site 를 숨긴 계정 / DIV 40):
    --     KRW·LOC·MKT_FCST·SCM_FCST 각 12 업무키, RTF_SYS_RP 11 업무키가 CELL_PROD_SITE_ID 로 2줄.
    --   반대로 그 컬럼을 **표시**하는 계정은 AS-IS 도 2줄이므로 건드리면 안 된다
    --     (클라우드 실측: 40/Huapu_CN_CGU/MCSS22531-B3 — NJ01-A 61행 + HQ06-A 1행(20260531) = AS-IS 파리티).
    --
    --   따라서 **C_TITLE 에 없을 때만** 업무키 단위 대표값으로 통일한다.
    --   대표값 = 계획 구간 우선·최신 (편집·저장 대상이 계획 구간이므로 저장 키로도 이 값이 맞다).
    -- ====================================================================================================
    SELECT COUNT(*)
      INTO V_USER_COL_CNT
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID = VA_PROGRAM_ID
       AND U.SHEET_NAME = VA_SHEET_NAME
       AND U.USER_ID    = p_created_by
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
       AND U.COLUMN_NAME = 'CELL_PROD_SITE_ID';

    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만 (표시 중이면 AS-IS 파리티 유지)
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
                   SELECT {biz_nvl_sel}
                        , MAX(CELL_PROD_SITE_ID) KEEP (DENSE_RANK LAST
                              ORDER BY CASE WHEN BUCKET_KEY >= V_TO_RESULT THEN 1 ELSE 0 END
                                     , BUCKET_KEY) AS REP_CELL_PROD
                   FROM   SCM_MGR.GT_DMF0082_MF_SP
                   WHERE  CELL_PROD_SITE_ID IS NOT NULL
                   GROUP BY {biz_nvl_grp}
                   HAVING COUNT(DISTINCT CELL_PROD_SITE_ID) > 1
               ) S
        ON ( {biz_on} )
        WHEN MATCHED THEN UPDATE SET T.CELL_PROD_SITE_ID = S.REP_CELL_PROD
        WHERE  NVL(T.CELL_PROD_SITE_ID, '~') <> S.REP_CELL_PROD;
    END IF;

""" + ANCHOR

PATCH = PATCH.format(
    biz_nvl_sel="\n                        , ".join(
        "NVL({0}, '~') AS {0}".format(c) for c in BIZ),
    biz_nvl_grp="\n                        , ".join("NVL({0}, '~')".format(c) for c in BIZ),
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

    if "[E20260918-KEYCOLGRAIN]" in body:
        print("이미 적용되어 있음 — 중단"); raise SystemExit(0)
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
