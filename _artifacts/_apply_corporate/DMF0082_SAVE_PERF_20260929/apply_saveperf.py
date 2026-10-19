"""DMF0082 화면 저장(P_DMF0082_SAVE_MAIN_DATA) 파싱 루프 선형화 [E20260929-DMF0082SAVEPERF]

사용자 요청 (2026-09-29) :
  "로컬에서 대용량 저장 시 15분 소요 ... 저장 로직에 문제가 없으니 문제가 추가로 발생하지 않는걸 전제로 저장 시 속도개선 요소를 찾아서 보완"

실측 (32,240행 저장 21:37:06~21:51:29 = 863s, SCM_SYS_LOG_BATCH + V$SQL + ASH) :
  파싱 루프 148s                       ← 이번 수정 대상 (로직 낭비: 행마다 CLOB 17개 잔여 재할당 = O(n²) + 행마다 자율트랜잭션 로그)
  판가 MERGE 163s / 수요 MERGE 35s      ← 신규 행 INSERT 의 인덱스 갱신(ASH: PK·IDX07 단일블록 읽기) — 실변경분이라 불가피
  FUTURE_PRICE DELETE 323s             ← 대상 행이 흩어진 테이블 블록 읽기(ASH 293s = 테이블). UPDATE 로 바꿔도 같은 블록을 읽음
  매출계획 금액 PR 160s                 ← 공용 PR(배치·타 화면 9곳 공유) — 범위 밖
  (이번 저장의 판가 96,720행 중 값 동일 0건 — 변경분만 반영 방식은 이득 없음)

수정 (P_DMF0082_SAVE_MAIN_DATA 한정 외과 치환 · 파싱 결과 동일) :
  P1 선언부 : 필드별 읽기 위치 17종 + 지역 함수 f_next_token(CLOB, 위치) — DBMS_LOB.INSTR/SUBSTR 로 '^' 사이 토큰을 위치 이동만으로 추출
  P2 루프   : INSTR/SUBSTR 17행 + 잔여 문자열 재할당 17행 → f_next_token 17행 (TRIM·INSERT 이하 원문 그대로)
  P3 루프   : 행별 로그(A00E) 제거 → 루프 종료 후 요약 1행(A00E, 처리 행수)
  P4 헤더 이력 1행
  동일성 : GTT 벤치 32,240행(빈 토큰 포함) OLD/NEW GT_PRDM1_T_MAIN 적재 결과 17컬럼 완전 일치 · OLD 189.3s → NEW 8.2s
  차이 1건 : OLD 는 끝 공백 토큰('AB ')에서 잔여 계산이 RTRIM 길이로 어긋나 이후 토큰이 밀림 — NEW 는 정상.
            실데이터 끝 공백 키 0건(SELLING_PRICE / CFM_MKT_DEMAND_PLAN / MKT_FCST 81) 확인 → 실사용 동작 차이 없음.
usage: python apply_saveperf.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

TAG = "E20260929-DMF0082SAVEPERF"
PKG, TYP = "PKG_DMF0082", "PACKAGE BODY"
SAVE_BEG, SAVE_END = "PROCEDURE P_DMF0082_SAVE_MAIN_DATA", "END P_DMF0082_SAVE_MAIN_DATA;"
F = [  # (토큰 변수, CLOB 홀더, 위치 변수)
    ("v_active_flag", "v_p_active_flag", "v_pos_active_flag"),
    ("v_p_division_id_val", "v_p_division_id", "v_pos_division_id"),
    ("v_project_code", "v_p_project_code", "v_pos_project_code"),
    ("v_end_customer", "v_p_end_customer", "v_pos_end_customer"),
    ("v_scm_site_id", "v_p_scm_site_id", "v_pos_scm_site_id"),
    ("v_item_id", "v_p_item_id", "v_pos_item_id"),
    ("v_dom_exp", "v_p_dom_exp", "v_pos_dom_exp"),
    ("v_fcst_type", "v_p_fcst_type", "v_pos_fcst_type"),
    ("v_incoterms", "v_p_incoterms", "v_pos_incoterms"),
    ("v_measure", "v_p_measure", "v_pos_measure"),
    ("v_plant_site_id", "v_p_plant_site_id", "v_pos_plant_site_id"),
    ("v_cell_prod_site_id", "v_p_cell_prod_site_id", "v_pos_cell_prod_site_id"),
    ("v_yyyymmdd", "v_p_yyyymmdd", "v_pos_yyyymmdd"),
    ("v_currency", "v_p_currency", "v_pos_currency"),
    ("v_qty_str", "v_p_qty", "v_pos_qty"),
    ("v_p_created_by_val", "v_p_created_by_raw", "v_pos_created_by"),
    ("v_as_from_site", "v_p_as_from_site_raw", "v_pos_as_from_site"),
]


def fetch(cur):
    # FRESH-GATE: 항상 DB 에서 새로 읽은 원문 기준 (ALL_SOURCE)
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=PKG, t=TYP)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text):
    head, rest = text.split("\n", 1)
    head = re.sub(r'(?i)^\s*PACKAGE\s+BODY\s+"?\w+"?', f'CREATE OR REPLACE PACKAGE BODY SCM_MGR."{PKG}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def one(seg, old, new, what):
    n = seg.count(old)
    assert n == 1, f"{what} 앵커 {n}회 (기대 1)"
    return seg.replace(old, new)


def patch(src):
    b = src.index(SAVE_BEG)
    e = src.index(SAVE_END, b)
    seg = src[b:e]
    # P1 선언부 — 지역 함수는 항목 선언 뒤·BEGIN 앞
    decl = "".join(f"    {pv:<26s}NUMBER := 1;\n" for _, _, pv in F)
    seg = one(seg, "    -- validation용 카운트\n    v_cnt_check         NUMBER;\n\nBEGIN\n",
              "    -- validation용 카운트\n    v_cnt_check         NUMBER;\n\n"
              f"    --[{TAG}] '^' 파싱 읽기 위치 (필드별). 잔여 문자열을 매 행 다시 잘라 쓰던 방식(O(n²))을 위치 이동으로 대체\n"
              + decl +
              "\n"
              f"    --[{TAG}] p_pos 부터 다음 '^' 직전까지를 돌려주고 p_pos 를 '^' 다음으로 옮긴다.\n"
              "    --  '^' 가 더 없으면(목록 소진) NULL 을 돌려주고 p_pos 는 그대로 — 종전(INSTR=0 → SUBSTR(...,1,-1)=NULL)과 동일.\n"
              "    --  빈 토큰('^^')은 NULL — 종전과 동일. 종전과 다른 점: 끝 공백 토큰('AB ^')에서 종전은 RTRIM 길이로 잔여를\n"
              "    --  잘라 다음 토큰이 밀렸으나 여기서는 정상 분리된다(실데이터 끝 공백 키 0건 확인 2026-09-29).\n"
              "    FUNCTION f_next_token(p_src IN CLOB, p_pos IN OUT NUMBER) RETURN VARCHAR2 IS\n"
              "        n_idx  NUMBER := DBMS_LOB.INSTR(p_src, '^', p_pos);\n"
              "        v_tok  VARCHAR2(4000 CHAR);\n"
              "    BEGIN\n"
              "        IF n_idx > p_pos THEN\n"
              "            v_tok := DBMS_LOB.SUBSTR(p_src, n_idx - p_pos, p_pos);\n"
              "        END IF;\n"
              "        IF n_idx > 0 THEN\n"
              "            p_pos := n_idx + 1;\n"
              "        END IF;\n"
              "        RETURN v_tok;\n"
              "    END f_next_token;\n\nBEGIN\n", "P1")
    # P2 루프 본문 — 첫 INSTR 행 ~ 마지막 잔여 재할당 행
    s0 = seg.index("            v_index_active_flag       := INSTR(v_p_active_flag,       '^');")
    tail_line = "            v_p_as_from_site_raw  := SUBSTR(v_p_as_from_site_raw,  LENGTH(RTRIM(v_as_from_site)            || '^') + 1, LENGTH(RTRIM(v_p_as_from_site_raw)));  --[E20260805-AFS]\n"
    assert seg.count(tail_line) == 1, "P2 끝 앵커"
    s1 = seg.index(tail_line) + len(tail_line)
    old_block = seg[s0:s1]
    assert old_block.count(":= INSTR(") == 17 and old_block.count(":= SUBSTR(") == 34, "P2 구간 구성 이상"
    new_block = (f"            --[{TAG}] 토큰 추출 = 위치 이동 (종전 INSTR/SUBSTR 17행 + 잔여 재할당 17행 대체)\n"
                 + "".join(f"            {tv:<20s}:= f_next_token({hv}, {pv});\n" for tv, hv, pv in F))
    seg = seg[:s0] + new_block + seg[s1:]
    # P3 행별 로그 제거 + 루프 뒤 요약 1행
    seg = one(seg,
              "            BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,\n"
              "                '■ : A00E--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(v_idx), '', SYSDATE,\n"
              "                v_created_by,\n"
              "                V_PROC_INPUT, NULL, NULL, NULL); END;\n",
              f"            --[{TAG}] 행별 A00E 로그 제거(행마다 자율 트랜잭션 1회) → 루프 종료 후 요약 1행\n", "P3a")
    seg = one(seg,
              "            , '', '', '', '', '', '', '', '', '', v_as_from_site, '', '' );\n\n        END LOOP;\n",
              "            , '', '', '', '', '', '', '', '', '', v_as_from_site, '', '' );\n\n        END LOOP;\n\n"
              f"        --[{TAG}] 파싱 요약 로그 (종전 행별 A00E 대체)\n"
              "        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,\n"
              "            '■ : A00E--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(v_idx - 1), '', SYSDATE,\n"
              "            v_created_by,\n"
              "            V_PROC_INPUT, NULL, NULL, NULL); END;\n", "P3b")
    # P4 헤더 이력
    seg = one(seg, " *                          + 40 전파 PR 호출 직전 명시 COMMIT(저장 본체 원자 확정).\n",
              " *                          + 40 전파 PR 호출 직전 명시 COMMIT(저장 본체 원자 확정).\n"
              f" * 2026.09.29	admin		[{TAG}] '^' 파싱 루프 선형화(위치 이동 f_next_token) + 행별 A00E 로그 → 요약 1행\n"
              " *                          (32,240행 파싱 GTT 벤치 189s → 8s, 적재 결과 동일).\n", "P4")
    return src[:b] + seg + src[e:]


def status(cur):
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=PKG, t=TYP)
    return cur.fetchone()


def main():
    mode = sys.argv[1]
    asis, tobe = HERE / "00_BACKUP_ASIS" / f"{PKG}_BODY.PRE_SAVEPERF.sql", HERE / "01_APPLY" / f"{PKG}_BODY.SAVEPERF.sql"
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL"); assert cur.fetchone()[0].upper() == "ZIOUI1", "대상 DB 가 ZIOUI1 아님"
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 반영"
        patched = patch(src)
        stamp = (f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={status(cur)[1]} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\n"
                 f"-- [{TAG}] DMF0082 SAVE '^' 파싱 루프 선형화\nSET DEFINE OFF\nSET SQLBLANKLINES ON\n")
        asis.parent.mkdir(parents=True, exist_ok=True); tobe.parent.mkdir(parents=True, exist_ok=True)
        asis.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        tobe.write_text(stamp + ddl(patched).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print("backup ok", status(cur))
    elif mode == "apply":
        # FRESH-GATE: 적용 직전 DB 원문 == 백업본
        assert ddl(fetch(cur)).rstrip() == body_of(asis), "FRESH-GATE 실패: 백업 이후 변경 — 중단"
        cur.execute(body_of(tobe))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t AND ATTRIBUTE='ERROR' ORDER BY SEQUENCE", n=PKG, t=TYP)
        errs = cur.fetchall()
        print(TYP, status(cur), "errors", len(errs), "applied==TOBE", ddl(fetch(cur)).rstrip() == body_of(tobe))
        for x in errs[:10]: print("  ", x)
        if errs: sys.exit("컴파일 오류 — restore 로 원복 필요")
    elif mode == "restore":
        cur.execute(body_of(asis)); print("restored", status(cur))


if __name__ == "__main__":
    main()
