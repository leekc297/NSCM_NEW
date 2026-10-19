# -*- coding: utf-8 -*-
"""DMF0074 Excel Upload — 광물 KEY 명칭→코드 정규화 보완 [E20260918-KEYNAMETOCODE]

근거 (2026-09-18 실측):
 - 조회 SP  P_DMF0074_GET_METAL_LINK_PRICE L414~420 : METAL_KEY_*.SEGMENT4(명칭) 출력
 - 업로드   P_DMF0074_EXCEL_UPLOAD        L1381~   : LUP.SEGMENT3(코드) 만 통과
 - AS-IS    dbo.DMF0074_GET_METAL_LINK_PRICE L739~ / dbo.DMF0074_EXCEL_UPLOAD L499 동일 비대칭
 - LOOKUP 'METAL_KEY_VALUE' 58건 : DIV+METAL 내 SEGMENT4 유일(모호 0) · SEGMENT3↔SEGMENT4 값 충돌 0
   → 명칭·코드 양쪽 수용이 무손실로 성립

적용 지점 : SCM_ADM_EXCEL_UPLOAD (원본 스테이징) 1곳.
           검증(P_MODE=0)은 여기서 GTT 로 복사되고, 저장(P_MODE=1, L2681)은 이 표를 직접 읽으므로
           이 1곳만 정규화하면 검증·저장이 함께 코드 기준으로 정렬된다.
"""
import datetime
import difflib
import pathlib
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

HERE = pathlib.Path(__file__).resolve().parent
MARKER = "[E20260918-KEYNAMETOCODE]"
ANCHOR = "    -- @p_mode = 0 이면 Validation"

# slot -> (LOOKUP SEGMENT2 리터럴, 검증 블록 라인)  ※ SP 검증 블록의 리터럴과 글자 단위 동일해야 함
METALS = [("Ni", 1), ("Co", 2), ("Li2Co3", 3), ("LIOH", 4), ("Al", 5), ("Mn", 6), ("Cu", 7)]


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def fetch_body(cur):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR'
                    AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    return "".join(r[0] for r in cur)


def last_ddl(cur):
    cur.execute("""SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                    AND OBJECT_NAME='PKG_DMF0074' AND OBJECT_TYPE='PACKAGE BODY'""")
    return cur.fetchone()


def set_expr(attr_no, seg2, indent):
    """ATTRIBUTE{n} 을 '명칭이면 코드로, 이미 코드면 그대로' 로 치환하는 SET 식."""
    a = "ATTRIBUTE{}".format(attr_no)
    p = " " * indent
    return (
        "{p}, T.{a} = NVL( (SELECT MIN(L.SEGMENT3)\n"
        "{p}                  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L\n"
        "{p}                 WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'\n"
        "{p}                   AND L.VALID_YN    = 'Y'\n"
        "{p}                   AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)\n"
        "{p}                   AND L.SEGMENT2    = '{s}'\n"
        "{p}                   AND L.SEGMENT4    = T.{a}                      --명칭(화면 표시값)\n"
        "{p}                   AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선\n"
        "{p}                                     FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2\n"
        "{p}                                    WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'\n"
        "{p}                                      AND L2.VALID_YN    = 'Y'\n"
        "{p}                                      AND L2.SEGMENT1    = L.SEGMENT1\n"
        "{p}                                      AND L2.SEGMENT2    = L.SEGMENT2\n"
        "{p}                                      AND L2.SEGMENT3    = T.{a})\n"
        "{p}                 ), T.{a})\n"
    ).format(p=p, a=a, s=seg2)


def build_block():
    out = []
    out.append("""
    /* #################################################### */
    /* {m} 광물 KEY 명칭 → 코드 정규화                     */
    /*                                                                                      */
    /* 조회 SP(P_DMF0074_GET_METAL_LINK_PRICE)는 METAL_KEY_*.SEGMENT4(명칭)를 내려주는데,     */
    /* 업로드 검증(Invalid KEY CODE)·적재는 SEGMENT3(코드)만 받는다. 그래서 화면/엑셀        */
    /* 다운로드에서 본 명칭(예: DIV 81 Ni = 'LME')을 그대로 올리면 전건이 반려된다.          */
    /* AS-IS(dbo.DMF0074_EXCEL_UPLOAD L499)도 코드만 받아 동일 제약이었으나, 사용자가        */
    /* 코드를 외워 입력할 수 없으므로 명칭 입력을 수용하도록 보완한다.                        */
    /*                                                                                      */
    /* 무손실 근거 (LOOKUP 'METAL_KEY_VALUE' 58건 실측, 2026-09-18)                          */
    /*   - DIV+METAL 내 SEGMENT4(명칭) 유일  → 명칭→코드 매핑 모호 0건                       */
    /*   - SEGMENT3(코드) 와 SEGMENT4(명칭) 의 값 충돌 0건 → 양쪽 수용 시 오인식 없음         */
    /* 이미 코드로 입력된 값은 NOT EXISTS 가드로 그대로 두고(코드 우선),                      */
    /* 명칭·코드 어느 쪽도 아닌 값은 손대지 않아 기존 'Invalid KEY CODE' 가 정상 발생한다.    */
    /*                                                                                      */
    /* 적재 위치 : 검증(P_MODE=0)은 여기서 GT_DM74_TMP_EXCEL_UPLOAD_RAW 로 복사되고,          */
    /*             저장(P_MODE=1)은 SCM_ADM_EXCEL_UPLOAD 를 직접 읽으므로(본 BODY L2681),     */
    /*             원본 스테이징 1곳만 정규화하면 검증·저장이 함께 코드 기준으로 정렬된다.    */
    /* 컬럼 위치 : 40 사업부 = ATTRIBUTE12~18 / 그 외 = ATTRIBUTE14~20 (SCM_ADM_EXCEL_COLUMNS */
    /*             DMF0074_40 53토큰 · DMF0074 55토큰 실측)                                  */
    /* #################################################### */
""".format(m=MARKER))

    for div_cond, base, tag in (("=", 12, "40 사업부 (Key_Ni~Key_Cu = ATTRIBUTE12~18)"),
                                ("<>", 14, "그 외 사업부 (Key_Ni~Key_Cu = ATTRIBUTE14~20)")):
        out.append("    --{}\n".format(tag))
        out.append("    UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD T\n")
        out.append("       SET T.LAST_UPDATE_DATE = T.LAST_UPDATE_DATE\n")
        for seg2, slot in METALS:
            out.append(set_expr(base + slot - 1, seg2, 11))
        out.append("     WHERE T.PROGRAM_ID   LIKE V_PROGRAM_ID || '%'\n")
        out.append("       AND T.SHEET_NAME    = V_SHEET_NAME\n")
        out.append("       AND T.CREATED_BY    = P_CREATED_BY\n")
        out.append("       AND TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE\n")
        out.append("       AND NVL(T.UPLOAD_STATUS_CODE,'X') NOT IN ('@TITLE','SKIP')\n")
        out.append("       AND T.ATTRIBUTE1 {} '40';\n".format(div_cond))
        out.append("""
    ------------------------------------------------------------------------
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'B0';
    V_LOG_MESSAGE := '########## {m} KEY NAME -> CODE ({t}) ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ------------------------------------------------------------------------
""".format(m=MARKER, t="DIV 40" if div_cond == "=" else "DIV NOT 40"))
    return "".join(out)


def main():
    db = conn()
    cur = db.cursor()

    # ---- FRESH-GATE (hook #152) : 적용 직전 원문 재조회 ----
    ddl0 = last_ddl(cur)
    body = fetch_body(cur)
    print("SOURCE-FRESH  PKG_DMF0074 BODY  LAST_DDL={} STATUS={} lines={}".format(
        ddl0[0], ddl0[1], body.count("\n") + 1))

    snap = HERE / "_pre_PKG_DMF0074_BODY.sql"
    snap.write_text(body, encoding="utf-8")
    print("  원문 백업 → {}".format(snap.name))

    if MARKER in body:
        print("  ! 이미 마커 존재 — 재적용 중단")
        return 2

    n = body.count(ANCHOR)
    print("  앵커 출현 = {}".format(n))
    if n != 1:
        print("  ! 앵커가 유일하지 않음 — 중단")
        return 3

    block = build_block()
    new = body.replace(ANCHOR, block + ANCHOR)

    diff = list(difflib.unified_diff(body.split("\n"), new.split("\n"),
                                     "before", "after", n=2, lineterm=""))
    print("  diff {}줄 / 추가 {}줄".format(
        len(diff), sum(1 for d in diff if d.startswith("+") and not d.startswith("+++"))))
    (HERE / "_patch.diff").write_text("\n".join(diff), encoding="utf-8")
    (HERE / "01_PKG_DMF0074_BODY.sql").write_text(
        "CREATE OR REPLACE " + new.lstrip() + "\n/\n", encoding="utf-8")

    # ---- FRESH-GATE 2 : 적용 직전 재확인 ----
    ddl1 = last_ddl(cur)
    if ddl1[0] != ddl0[0]:
        print("  ! LAST_DDL 변동 {} -> {} — 타 작업자 덮어쓰기. 중단".format(ddl0[0], ddl1[0]))
        return 4

    cur.execute("CREATE OR REPLACE " + new.lstrip())
    print("  적용 완료")

    cur.execute("""SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                    AND OBJECT_NAME='PKG_DMF0074' AND OBJECT_TYPE='PACKAGE BODY'""")
    st = cur.fetchone()
    print("  STATUS={} LAST_DDL={}".format(st[0], st[1]))

    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' ORDER BY SEQUENCE""")
    errs = cur.fetchall()
    for e in errs:
        print("   ERR L{} P{} {}".format(e[0], e[1], e[2]))
    if errs:
        return 5

    after = fetch_body(cur)
    print("  마커 반영 = {} / 적용후 lines={}".format(MARKER in after, after.count("\n") + 1))
    db.commit()
    print("DONE {}".format(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
    return 0


if __name__ == "__main__":
    sys.exit(main())
