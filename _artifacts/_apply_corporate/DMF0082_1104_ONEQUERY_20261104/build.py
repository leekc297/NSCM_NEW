# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] 2-A 빌더 — DB 원문(PKG_DMF0082_1104 BODY) 재조회 → GET_MAIN_DATA 만 새 구조로 교체 → 컴파일

  python build.py build            # DB 원문 조회(FRESH) → 01_PKG_DMF0082_1104_BODY.sql 생성 (적용 안 함)
  python build.py apply            # build 후 FRESH-GATE(원본 PKG_DMF0082 BODY LAST_DDL 불변 확인) → PKG_DMF0082_1104 BODY 교체 → ALL_ERRORS
  python build.py restore          # 00_BACKUP(복제 직후 원문) 으로 PKG_DMF0082_1104 BODY 원복

구조 (main.sql 줄 = BODY 8행부터 센 GET_MAIN_DATA 내부 줄):
  [1..233 선언부] + 추가 변수 + [234..256] + S0 + [298..480] + [481..492]
  IF V_ONEQ_CURRENT THEN [562..605 날짜] S1 [1117..1151 선행축소 DELETE] S2 [4309..4418 C_TITLE] [5038..5053 PV 가드] S3
  ELSE [493..5337 원문] [5368..5375 O_RC4]
  END IF; [5339..5366 O_RC2·3] [5377..5537 O_RC5·결과·예외]
"""
import sys, os, json, re, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import oneq_blocks as B
import oneq_s3 as S3
import oneq_2b as B2
import oneq_split as SP
STAGE = os.environ.get("ONEQ_STAGE", "2A")      # 2A = Current 새 경로 + 버전 원문 블록 / 2B = 전 경로 새 구조

PKG, OWNER = "PKG_DMF0082_1104", "SCM_MGR"
F_BAK = os.path.join(HERE, "00_BACKUP_PKG_DMF0082_1104_BODY.sql")
F_NEW = os.path.join(HERE, "01_PKG_DMF0082_1104_BODY.sql" if STAGE == "2A" else "02_PKG_DMF0082_1104_BODY_2B.sql")
F_PROC = os.path.join(HERE, "_new_GET_MAIN_DATA.sql" if STAGE == "2A" else "_new_GET_MAIN_DATA_2B.sql")
HEAD = 'PROCEDURE P_DMF0082_GET_MAIN_DATA'
NEXT = 'PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO'
ORIG_BODY_DDL = "2026-11-04 14:48:42"     # 복제 기준 원본 PKG_DMF0082 BODY LAST_DDL (plan §3)


def conn():
    cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); return cx, cx.cursor()


def fetch(c, name):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=OWNER, n=name)
    return ''.join(r[0] or '' for r in c.fetchall())


def ddl(c, name, typ='PACKAGE BODY'):
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=name, t=typ)
    return c.fetchone()


def L(lines, a, b):
    """main.sql 1-based [a..b] 구간 (lines 는 GET_MAIN_DATA 텍스트의 줄 리스트, 0-based)"""
    return "\n".join(lines[a - 1:b])


def assemble(body):
    i0 = body.index(HEAD); i1 = body.index(NEXT)
    proc = body[i0:i1]
    lines = proc.split("\n")
    assert lines[0].startswith(HEAD) and len(lines) >= 5537, len(lines)
    # 앵커 검증 (원문이 바뀌면 조립 금지)
    anchors = {234: 'BEGIN', 257: 'DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;', 298: '', 481: '',
               493: 'DELETE FROM SCM_MGR.GT_DMF0082_T_VERSION;', 562: '-- [DATE ROOT FIX 2026-07-12]', 605: 'END IF;',
               1117: '/* [E20261014-DMF0082RLXPRE]', 1151: 'END IF;', 4309: '-- C_TITLE', 4418: 'END;',
               5038: '-- =====', 5053: 'END IF;', 5337: 'DBMS_LOB.FREETEMPORARY(V_QTY_SUM);', 5339: '-- =====',
               5366: 'FROM   DUAL;', 5368: '-- =====', 5375: 'ORDER BY MEASURE;', 5377: '-- =====', 5537: 'END P_DMF0082_GET_MAIN_DATA;'}
    for ln, txt in anchors.items():
        assert lines[ln - 1].strip().startswith(txt), f"앵커 불일치 L{ln}: {lines[ln-1].strip()[:60]!r} ≠ {txt!r}"
    decl_extra = """
    -- [E20261104-DMF0082ONEQUERY] 2-A: Current 전용 3문장 경로 선택 플래그 (버전 조회는 원문 경로)
    V_ONEQ_CURRENT      BOOLEAN := FALSE;
    V_VERLOOP_CNT       PLS_INTEGER := 0;   -- [E20261105-DMF0082ONEQUERY-VERLOOP] S2-L FCST_C/PRICE_C 버전별 적재 루프 횟수
"""
    out = []
    out.append(L(lines, 1, 233)); out.append(decl_extra.rstrip("\n"))
    out.append(L(lines, 234, 256))
    out.append(B.s0_param_token().rstrip("\n"))
    out.append(L(lines, 298, 492))
    if STAGE == "2A":
        out.append("""
    /* [E20261104-DMF0082ONEQUERY] 경로 선택 — 버전 문자열에 SP/MF/SF 가 없고 Current 가 있으면 새 3문장 경로 (원문 IF 게이트와 같은 판정식) */
    V_ONEQ_CURRENT := (p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%')
                      AND p_version_type NOT LIKE '%SP%' AND p_version_type NOT LIKE '%MF%' AND p_version_type NOT LIKE '%SF%';

    IF V_ONEQ_CURRENT THEN
    /* ── Current 경로: T_VERSION 적재 없음(원문 L495 IF 미충족) · V_CUTOFF 기본값(원문 L530 NVL) ── */
    V_CUTOFF_FROM := '00000000';
    V_CUTOFF_TO   := '99999999';
""".rstrip("\n"))
    else:
        out.append("""
    /* [E20261104-DMF0082ONEQUERY] 2-B — 전 경로 새 구조. 순수 Current 요청은 S2-CUR(사업부별) · 버전 포함 요청은 S2-ALL(사업부별 · Current+MF+SF+SP arm) */
    V_ONEQ_CURRENT := (p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%')
                      AND p_version_type NOT LIKE '%SP%' AND p_version_type NOT LIKE '%MF%' AND p_version_type NOT LIKE '%SF%';
""".rstrip("\n"))
        out.append(L(lines, 493, 541))       # T_VERSION GTT 적재(원문 IF 게이트) + V_CUTOFF — 원문 그대로 (룩업 GTT)
    out.append(L(lines, 562, 605))
    out.append(B.s1_site_item().rstrip("\n"))
    out.append(L(lines, 1117, 1151))
    if STAGE == "2A":
        s2_loads, _ = SP.split_s2(B.s2_fcst_n_price_current('81'))
        out.append("    /* [E20261104-DMF0082ONEQUERY] S2-L 룩업 GTT 적재 (WS · SELECT_MEASURE · LAST_DATA_SETUP) — 10-09 SHARED 고정 통계를 쓰기 위해 CTE 대신 GTT 유지 */")
        out.append(s2_loads.rstrip("\n"))
        out.append("    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;   -- L1441")
        out.append("    /* [E20261104-DMF0082ONEQUERY] S2 — 사업부별 정적 INSERT 1개만 실행 (원문 L1449 IF 분기와 동일 · 바인드 술어 FILTER 미단락 누수 방지) */")
        for cond, dv in (("IF p_division_id LIKE '81%' THEN", '81'), ("ELSIF p_division_id = '82' THEN", '82'), ("ELSE", '40')):
            _, ins = SP.split_s2(B.s2_fcst_n_price_current(dv))
            out.append("    " + cond)
            out.append(ins.replace("    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n", f"    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-{dv} */\n", 1).rstrip("\n"))
        out.append("    END IF;")
        out.append(L(lines, 4210, 4307))      # 중복제거 · qty_yn · 고아 — 원문 그대로
    else:
        s2_loads, _ = SP.split_s2(B2.s2_fcst_n_price_all('81'))
        out.append("    /* [E20261104-DMF0082ONEQUERY] S2-L 룩업 GTT 적재 (WS · SELECT_MEASURE · LAST_DATA_SETUP · FCST_C · PRICE_C) — 10-09 SHARED 고정 통계를 쓰기 위해 CTE 대신 GTT 유지 · FCST_C/PRICE_C 는 T_VERSION 버전별 FOR 루프 적재(11-05 VERLOOP · T_VERSION 비면 0회 · 원문 L1344~1432 는 T_VERSION 조인 카티션 1행 추정→NL 457s) */")
        out.append(s2_loads.rstrip("\n"))
        out.append("    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;   -- L1441")
        out.append("    /* [E20261104-DMF0082ONEQUERY] S2 — 사업부별 정적 INSERT 1개만 실행 · 순수 Current = CUR 변형(2-A 와 동일) / 버전 포함 = ALL 변형(Current arm G_CUR 게이트 + MF/SF/SP arm VER GTT 조인) */")
        out.append("    IF V_ONEQ_CURRENT THEN")
        for cond, dv in (("IF p_division_id LIKE '81%' THEN", '81'), ("ELSIF p_division_id = '82' THEN", '82'), ("ELSE", '40')):
            _, ins = SP.split_s2(B.s2_fcst_n_price_current(dv))
            out.append("    " + cond)
            out.append(ins.replace("    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n", f"    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-{dv} */\n", 1).rstrip("\n"))
        out.append("    END IF;")
        out.append("    ELSE")
        for cond, dv in (("IF p_division_id LIKE '81%' THEN", '81'), ("ELSIF p_division_id = '82' THEN", '82'), ("ELSE", '40')):
            _, ins = SP.split_s2(B2.s2_fcst_n_price_all(dv))
            out.append("    " + cond)
            out.append(ins.replace("    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE\n", f"    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE  /* S2-ALL-{dv} */\n", 1).rstrip("\n"))
        out.append("    END IF;")
        out.append("    END IF;  -- V_ONEQ_CURRENT")
        out.append(L(lines, 4210, 4307))      # 중복제거 · qty_yn · 고아 — 원문 그대로
    out.append(L(lines, 4309, 4418))
    out.append(L(lines, 5038, 5053))
    out.append(S3.S3_PLSQL.rstrip("\n"))
    if STAGE == "2A":
        out.append("""
    ELSE
    /* ── 버전(MF/SF/SP·복수) 경로: 원문 L493~5337 그대로 (2-B 에서 새 구조로 교체 예정) ── */""")
        out.append(L(lines, 493, 5337))
        out.append(L(lines, 5368, 5375))
        out.append("    END IF;  -- V_ONEQ_CURRENT")
    out.append(L(lines, 5339, 5366))
    out.append(L(lines, 5377, 5537))
    newproc = "\n".join(out) + "\n\n"
    return body[:i0] + newproc + body[i1:], proc


def build(c):
    now = ddl(c, PKG)
    if not os.path.exists(F_BAK):
        body = fetch(c, PKG)
        open(F_BAK, 'w', encoding='utf-8', newline='\n').write(body)
        print('backup saved', F_BAK, len(body))
    else:
        # 조립 원문 = 복제 직후 백업(= 원본 PKG_DMF0082 16:00 사본). 라이브 1104 는 이미 교체본일 수 있다.
        body = open(F_BAK, encoding='utf-8', newline='\n').read()
        print('source = backup', F_BAK, len(body))
    newbody, oldproc = assemble(body)
    open(F_PROC, 'w', encoding='utf-8', newline='\n').write(newbody[newbody.index(HEAD):newbody.index(NEXT)])
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} BODY LAST_DDL={now[0]} FETCHED={datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} (24h)\n"
    head_note = ("-- [E20261104-DMF0082ONEQUERY] 2-A Current 경로 3문장 (S0/S1/S2/S3) · 버전 경로 원문 유지\n" if STAGE == "2A"
                 else "-- [E20261104-DMF0082ONEQUERY] 2-B 전 경로 3문장 (S0/S1/S2-CUR|S2-ALL/S3) · 버전 경로 원문 블록 제거\n")
    open(F_NEW, 'w', encoding='utf-8', newline='\n').write(stamp + head_note + "CREATE OR REPLACE " + newbody.rstrip() + "\n/\n")
    print('built', F_NEW, 'body chars', len(newbody), 'old proc lines', oldproc.count("\n"), 'new proc lines', newbody[newbody.index(HEAD):newbody.index(NEXT)].count("\n"))
    return newbody


def compile_body(c, body):
    c.execute("CREATE OR REPLACE " + body)
    c.execute("SELECT LINE, POSITION, SUBSTR(TEXT,1,300) FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", o=OWNER, n=PKG)
    return c.fetchall()


if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'build'
    cx, c = conn()
    c.execute("SELECT sys_context('USERENV','SERVICE_NAME'), sys_context('USERENV','SERVER_HOST') FROM DUAL"); print('DB', c.fetchone())
    if cmd == 'build':
        build(c)
    elif cmd == 'apply':
        od = ddl(c, 'PKG_DMF0082')
        assert od[0] == ORIG_BODY_DDL, f"FRESH-GATE: 원본 PKG_DMF0082 BODY LAST_DDL {od[0]} ≠ {ORIG_BODY_DDL} — 타 작업자 변경, 1104 재동기화 필요"
        newbody = build(c)
        errs = compile_body(c, newbody)
        print('ERRORS', len(errs))
        for e in errs: print('  ', e)
        print('OBJ', ddl(c, PKG), ddl(c, PKG, 'PACKAGE'))
    elif cmd == 'restore':
        body = open(F_BAK, encoding='utf-8', newline='\n').read()
        errs = compile_body(c, body); print('restored ERRORS', len(errs), ddl(c, PKG))
    cx.close()
