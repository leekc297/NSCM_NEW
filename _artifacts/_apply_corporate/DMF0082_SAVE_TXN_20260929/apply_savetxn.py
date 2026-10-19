"""DMF0082 화면 저장(P_DMF0082_SAVE_MAIN_DATA) 대용량 한도 해제 + 저장 본체 트랜잭션 원자화 [E20260929-DMF0082SAVETXN]

사용자 요청 (2026-09-29) :
  "DMF0082 의 대용량 저장 시 트랜잭션이 한번에 모아서 넘기는지 확인" → 점검 보고 → "네 보완 진행해주세요"

점검 결과 (사내 ZIOUI1 실측) :
  ① FE→BE→SP 1회 호출(분할 없음). 단 SP IN 17종이 VARCHAR2 → PL/SQL 한도 32,767B 초과 시 ORA-06502 로 저장 전체 실패
     (실측: 32,767 OK / 32,768 ORA-06502). 실키 길이 기준 약 1,000~2,000 (행×일자) 에서 막힘.
  ② PRESERVE ROWS GTT 대상 DBMS_STATS.GATHER/SET/DELETE_TABLE_STATS 는 **암묵 COMMIT** (실측: LOCAL_TRANSACTION_ID 소멸,
     이후 ROLLBACK 무효). 40 경로의 첫 영구 DML(RMA→RTF_SYS_RP DELETE/INSERT) 뒤에 GATHER 3건이 있어,
     이후 판가·수요 MERGE 에서 런타임 오류 시 RTF_SYS_RP 변경만 확정되는 부분저장 창이 존재.

수정 (PKG_DMF0082 PACKAGE + PACKAGE BODY, P_DMF0082_SAVE_MAIN_DATA 한정 외과 치환) :
  S1 SPEC  : SAVE IN 17종 VARCHAR2 → CLOB
  B1 BODY  : 동일 17종 VARCHAR2 → CLOB (파싱 홀더는 [E20260901-SAVECLOB] 로 이미 CLOB)
  B2 BODY  : V_PROC_INPUT 로그용 SUBSTR(p_x,1,50) → DBMS_LOB.SUBSTR(p_x,50,1) (VARCHAR2 반환 명시)
  B3 BODY  : 첫 영구 DML 이후 GATHER 3건 주석 처리 (GT_PRDM1_TEMP_EXCH 1 / GT_PRDM1_T_MAIN 2)
  B4 BODY  : GTT 초기화 직후(첫 영구 DML 이전 — COMMIT 무해 구간) GT_PRDM1_TEMP_EXCH 세션 잔존 통계 삭제
             → optimizer_dynamic_sampling=2(L12100 기설정) 가 실표본으로 추정. GT_PRDM1_T_MAIN 은 L12318 수집분 유지.
  B5 BODY  : 40 경로 CFM→MKT_FCST 전파 호출 직전 명시 COMMIT (1단계 = 저장 본체 원자 확정)
             사유: 전파 PR 과 그 안의 공용 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(배치 JOB 공유, DBMS_STATS 26회)가
             내부에서 커밋하므로 원래도 이 지점에서 확정되고 있었다(TRUNCATE L15479). 경계를 명시해 본체 원자성을 보장.
  B6 BODY  : 헤더 변경 이력 1행
  M1 META  : SCM_ADM_PROC_M 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA' IN 17행 DATA_TP_CD VARCHAR → CLOB
             (BE BaseService.makeProcedure L377 CLOB IN 바인딩 — 사내 191개 프로시저 선례)

영향 없음 : FE payload 키 동일 / BE 무변경 / PKG_DMF0082 외부 의존 객체 0 / Excel Upload 저장(P_DMF0082_EXCEL_UPLOAD)은 영구 DML
            (L6237 MERGE·L6277 _H) 이 최종 COMMIT 직전에 몰려 있고 행을 '^' 가 아닌 업로드 테이블로 받아 대상 아님.
usage: python apply_savetxn.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

TAG = "E20260929-DMF0082SAVETXN"
PKG = "PKG_DMF0082"
PROC = "PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA"
SAVE_BEG, SAVE_END = "PROCEDURE P_DMF0082_SAVE_MAIN_DATA", "END P_DMF0082_SAVE_MAIN_DATA;"
PARAMS = ["p_active_flag", "p_division_id", "p_project_code", "p_end_customer", "p_scm_site_id", "p_item_id",
          "p_dom_exp", "p_fcst_type", "p_incoterms", "p_measure", "p_plant_site_id", "p_cell_prod_site_id",
          "p_yyyymmdd", "p_currency", "p_qty", "p_created_by", "p_as_from_site"]
COLS = ["activeFlag", "divisionId", "projectCode", "endCustomer", "scmSiteId", "itemId", "domExp", "fcstType",
        "incoterms", "measure", "plantSite", "cellProdSiteId", "yyyymmdd", "currency", "qty", "createdBy", "asFromSite"]


def fetch(cur, typ):
    # FRESH-GATE: 항상 DB 에서 새로 읽은 원문 기준 (ALL_SOURCE)
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=PKG, t=typ)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text, typ):
    head, rest = text.split("\n", 1)
    kw = "PACKAGE\\s+BODY" if typ == "PACKAGE BODY" else "PACKAGE"
    head = re.sub(rf'(?i)^\s*{kw}\s+"?\w+"?', f'CREATE OR REPLACE {typ} SCM_MGR."{PKG}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def one(seg, old, new, what):
    n = seg.count(old)
    assert n == 1, f"{what} 앵커 {n}회 (기대 1)"
    return seg.replace(old, new)


def patch_spec(src):
    b = src.index(SAVE_BEG)
    e = src.index("O_RESULT_CURSOR OUT SYS_REFCURSOR );", b)
    seg = src[b:e]
    for p in PARAMS:
        seg = one(seg, f"{p} IN VARCHAR2", f"{p} IN CLOB", f"SPEC {p}")
    seg = f"--[{TAG}] '^' bulk IN 17종 VARCHAR2→CLOB (32,767B 한도 해제)\n    " + seg
    return src[:b] + seg + src[e:]


def patch_body(src):
    b = src.index(SAVE_BEG)
    e = src.index(SAVE_END, b)
    seg = src[b:e]
    # B1 파라미터 선언
    hdr_end = seg.index("O_RESULT_CURSOR       OUT SYS_REFCURSOR")
    hdr = seg[:hdr_end]
    for p in PARAMS:
        pat = re.compile(rf"(\b{p}\s+IN\s+)VARCHAR2\b")
        assert len(pat.findall(hdr)) == 1, f"B1 {p} 선언 매칭 != 1"
        hdr = pat.sub(r"\1CLOB", hdr, count=1)
    hdr = one(hdr, "  , p_as_from_site        IN CLOB DEFAULT NULL",
              f"  , p_as_from_site        IN CLOB DEFAULT NULL  --[{TAG}] IN 17종 CLOB (32,767B 한도 해제)", "B1 주석")
    seg = hdr + seg[hdr_end:]
    # B2 로그 입력 요약 — CLOB SUBSTR 은 CLOB 을 돌려주므로 VARCHAR2 반환 함수로 명시
    for p in PARAMS[:16]:
        seg = one(seg, f"VALUE SUBSTR({p}, 1, 50)", f"VALUE DBMS_LOB.SUBSTR({p}, 50, 1)", f"B2 {p}")
    # B4 세션 잔존 통계 삭제 (첫 영구 DML 이전)
    seg = one(seg, "    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2;\n",
              "    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2;\n"
              f"    --[{TAG}] 아래(첫 영구 DML 이후) GT_PRDM1_TEMP_EXCH 통계수집을 제거했으므로 이전 호출의 세션 통계가 남지 않게\n"
              "    --  여기서 지운다 → optimizer_dynamic_sampling=2 가 실표본으로 추정. DBMS_STATS 는 암묵 COMMIT 이지만\n"
              "    --  이 지점은 영구 테이블 DML 이전이라 무해하다.\n"
              "    DBMS_STATS.DELETE_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCH');\n", "B4")
    # B3 첫 영구 DML(RTF_SYS_RP) 이후 GATHER 3건
    r_beg = seg.index("-- 16. 40 Validation 필요 대상 :  RMA 인 경우에 RTF를 MKT_FCST와 동일하게 생성 (START)")
    r_end = seg.index("'MERGE INTO DM_PLN_CFM_SELLING_PRICE START'", r_beg)
    mid = seg[r_beg:r_end]
    g = re.compile(r"^([ \t]*)(DBMS_STATS\.GATHER_TABLE_STATS\(OWNNAME => 'SCM_MGR', TABNAME => '(GT_PRDM1_T_MAIN|GT_PRDM1_TEMP_EXCH)'\);)[ \t]*$", re.M)
    hits = g.findall(mid)
    assert [h[2] for h in hits] == ["GT_PRDM1_TEMP_EXCH", "GT_PRDM1_T_MAIN", "GT_PRDM1_T_MAIN"], f"B3 매칭 {hits}"
    mid = g.sub(lambda m: f"{m.group(1)}NULL;  --[{TAG}] 암묵 COMMIT 차단(영구 DML 이후): {m.group(2)}", mid)
    assert "DBMS_STATS" not in mid.replace(f"--[{TAG}] 암묵 COMMIT 차단(영구 DML 이후): DBMS_STATS", ""), "B3 잔존 DBMS_STATS"
    seg = seg[:r_beg] + mid + seg[r_end:]
    # B5 1단계 확정 경계
    seg = one(seg, "    IF v_is_81 = 'N' THEN\n        P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);\n    END IF;\n",
              "    IF v_is_81 = 'N' THEN\n"
              f"        --[{TAG}] 1단계(저장 본체: RTF_SYS_RP·판가·수요·_H) 원자 확정. 아래 전파 PR 과 그 안의 공용\n"
              "        --  PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(배치 JOB 공유, DBMS_STATS 다수)가 내부에서 커밋하므로 원래도\n"
              "        --  여기서 확정되고 있었다(전파 PR 첫 TRUNCATE). 경계를 명시해 본체가 쪼개져 확정되지 않게 한다.\n"
              "        COMMIT;\n"
              "        P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);\n    END IF;\n", "B5")
    # B6 헤더 이력
    seg = one(seg, " *                          V81-11 신규 차단 가드 완화(AS FROM SITE 전달 시 허용) + 81 MERGE UPDATE 에 ATTRIBUTE10 조건부 갱신.\n",
              " *                          V81-11 신규 차단 가드 완화(AS FROM SITE 전달 시 허용) + 81 MERGE UPDATE 에 ATTRIBUTE10 조건부 갱신.\n"
              f" * 2026.09.29	admin		[{TAG}] IN 17종 CLOB(32,767B 한도 해제) + 영구 DML 이후 DBMS_STATS(암묵 COMMIT) 제거\n"
              " *                          + 40 전파 PR 호출 직전 명시 COMMIT(저장 본체 원자 확정).\n", "B6")
    return src[:b] + seg + src[e:]


def paths(typ):
    k = "SPEC" if typ == "PACKAGE" else "BODY"
    return HERE / "00_BACKUP_ASIS" / f"{PKG}_{k}.PRE_SAVETXN.sql", HERE / "01_APPLY" / f"{PKG}_{k}.SAVETXN.sql"


def status(cur, typ):
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=PKG, t=typ)
    return cur.fetchone()


def procm(cur):
    cur.execute("SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=PROC)
    return cur.fetchall()


PROCM_SQL = ("UPDATE SCM_MGR.SCM_ADM_PROC_M\n   SET DATA_TP_CD = 'CLOB', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE\n"
             f" WHERE PROC_NM = '{PROC}'\n   AND COL_TP_CD = 'IN'\n   AND COL_NM IN ({', '.join(repr(c) for c in COLS)})")


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1", "대상 DB 가 ZIOUI1 아님"
    targets = [("PACKAGE", patch_spec), ("PACKAGE BODY", patch_body)]
    if mode == "backup":
        for typ, fn in targets:
            src = fetch(cur, typ)
            assert TAG not in src, f"{typ} 이미 반영"
            patched = fn(src)
            asis, tobe = paths(typ)
            stamp = (f"-- SOURCE-FRESH: SCM_MGR.{PKG} {typ} LAST_DDL={status(cur, typ)[1]} "
                     f"FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\n"
                     f"-- [{TAG}] DMF0082 SAVE IN CLOB + 저장 본체 트랜잭션 원자화\n"
                     "SET DEFINE OFF\nSET SQLBLANKLINES ON\n")
            asis.parent.mkdir(parents=True, exist_ok=True); tobe.parent.mkdir(parents=True, exist_ok=True)
            asis.write_text(stamp + ddl(src, typ).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
            tobe.write_text(stamp + ddl(patched, typ).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
            print(typ, "backup ok", status(cur, typ))
        rows = procm(cur)
        (HERE / "00_BACKUP_ASIS" / "SCM_ADM_PROC_M.PRE_SAVETXN.txt").write_text(
            "\n".join("\t".join(map(str, r)) for r in rows) + "\n", encoding="utf-8")
        (HERE / "01_APPLY" / "02_SCM_ADM_PROC_M.SAVETXN.sql").write_text(
            f"-- [{TAG}] SAVE IN 17종 CLOB 바인딩 (멱등 — 재실행 무해)\n{PROCM_SQL};\nCOMMIT;\n", encoding="utf-8", newline="\n")
        (HERE / "99_RESTORE_SCM_ADM_PROC_M.sql").write_text(
            f"-- [{TAG}] 원복: SAVE IN 17종 VARCHAR 복귀\n" + PROCM_SQL.replace("'CLOB'", "'VARCHAR'") + ";\nCOMMIT;\n",
            encoding="utf-8", newline="\n")
        print("PROC_M backup", len(rows), "rows")
    elif mode == "apply":
        for typ, _ in targets:
            asis, tobe = paths(typ)
            # FRESH-GATE: 적용 직전 DB 원문 == 백업본
            assert ddl(fetch(cur, typ), typ).rstrip() == body_of(asis), f"FRESH-GATE 실패: {typ} 백업 이후 변경 — 중단"
        before = open(HERE / "00_BACKUP_ASIS" / "SCM_ADM_PROC_M.PRE_SAVETXN.txt", encoding="utf-8").read()
        now = "\n".join("\t".join(map(str, r)) for r in procm(cur)) + "\n"
        assert now == before, "FRESH-GATE 실패: PROC_M 백업 이후 변경 — 중단"
        for typ, _ in targets:
            asis, tobe = paths(typ)
            cur.execute(body_of(tobe))
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=PKG, t=typ)
            errs = cur.fetchall()
            print(typ, status(cur, typ), "errors", len(errs), "applied==TOBE", ddl(fetch(cur, typ), typ).rstrip() == body_of(tobe))
            for x in errs[:10]: print("  ", x)
            if errs: sys.exit("컴파일 오류 — restore 로 원복 필요")
        cur.execute(PROCM_SQL); n = cur.rowcount; assert n == 17, f"PROC_M 갱신 {n}행 (기대 17)"
        con.commit(); print("PROC_M updated", n)
        for r in procm(cur): print("  ", r)
    elif mode == "restore":
        for typ, _ in targets:
            asis, _t = paths(typ)
            cur.execute(body_of(asis)); print(typ, "restored", status(cur, typ))
        cur.execute(PROCM_SQL.replace("'CLOB'", "'VARCHAR'")); con.commit(); print("PROC_M restored", cur.rowcount)


if __name__ == "__main__":
    main()
