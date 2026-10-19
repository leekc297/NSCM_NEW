"""PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD — M0~M12 비숫자 검증 복구 + 메시지 'Invalid QTY' [E20260923-XLSUPQTY]

사용자 지시 (2026-09-23):
  "M0 - M12 까지의 동적 구간에 숫자가 아닌 문자가 들어오면 Invalid QTY 를 오류 메세지로 발생 시켜주세요.
   현재는 Oracle 오류 메세지가 발생합니다."

결함 (hook #119 oracle-null-sentinel-and-notnull-default — MSSQL `<> ''` 오역) :
  현행 조건    (NVL(ATTRIBUTE7,'') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE7,'^[+-]?\\d+\\.?\\d*$'))
  Oracle 은 '' = NULL 이라 **x <> '' 가 값과 무관하게 항상 UNKNOWN** 이다.
  ⇒ 숫자여부 체크 UPDATE 가 단 1행도 잡지 못하는 **사문(死文)**.

  사내 실증 (2026-09-23, ZIOUI1) :
      NVL('10.5210.52','') <> ''                    -> FALSE/UNKNOWN
      '10.5210.52' IS NOT NULL                      -> TRUE
      NOT REGEXP_LIKE('10.5210.52','^[+-]?\\d+\\.?\\d*$') -> TRUE  (점 2개 = 숫자 아님)
      현행 SP 조건으로 잡히는 건수 : 0   /  IS NOT NULL 정정 조건 : 1

  결과 : 비숫자 값이 검증을 통과해 저장 분기(p_mode>0)까지 흘러가고
         GT_F020_UPLOAD_MASTER_FINAL 적재의 `TO_NUMBER(TMP.LOC) > 0` 에서 **ORA-01722 invalid number**
         → 화면에 Oracle 원문 오류가 노출된다(사용자 신고).

정정 :
  ① 판정식  NVL(ATTRIBUTEn,'') <> ''   ->  TRIM(ATTRIBUTEn) IS NOT NULL
       · 진짜 빈 셀(NULL)·공백만 든 셀은 종전대로 검사 제외(TRIM('  ') = '' = NULL)
       · 정규식 대상도 TRIM(x) 로 — ' 10.52 ' 같은 전후 공백을 오류로 몰지 않는다
  ② 메시지  'Invalid NUMERIC.'  ->  'Invalid QTY [<헤더라벨>: <입력값>]'
       · 헤더 라벨 = HEADER_CONTENT 기간 토큰 M0~M12 (ATTRIBUTE7~19 와 1:1, 사내 실측 19토큰)
       · 어느 칸이 틀렸는지 화면에서 바로 보이도록 — DMF0014 검증 메시지 개정(2026-09-23)과 같은 형식.
         라벨/값이 필요 없다면 CASE 식만 'Invalid QTY' 리터럴로 되돌리면 된다.

⚠ 범위 한정 — 함께 발견했으나 **이번 조치 대상 아님**(사용자 요청 범위 밖, 동작 변경 위험) :
  같은 SP 의 `Negative Number` / `Zero Number` 체크도 동일한 `NVL(x,'') <> ''` 사문이다.
  지금 되살리면 종전까지 통과하던 0·음수 입력이 갑자기 차단된다
  (SP 머리말 정책 "LOC 값이 없을 경우 0으로 간주" 와 충돌 가능) → 보고만 하고 원문 유지.

범위 : P_DMF0082_EXCEL_UPLOAD 의 '숫자여부 체크' UPDATE 1곳. 타 프로시저·타 검증 무변경.
usage: python apply_qty.py backup | apply | restore
"""
import datetime, pathlib, re, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora, oracledb  # noqa: E402

NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
ASIS = HERE / "00_BACKUP_ASIS" / "PKG_DMF0082_BODY.PRE_XLSUPQTY.sql"
TOBE = HERE / "01_APPLY" / "PKG_DMF0082_BODY.XLSUPQTY.sql"
TAG = "E20260923-XLSUPQTY"
PROC_BEG = "PROCEDURE P_DMF0082_EXCEL_UPLOAD"
PROC_END = "END P_DMF0082_EXCEL_UPLOAD"
BLOCK_BEG = "/* 숫자여부 체크"
RE_NUM = r"'^[+-]?\d+\.?\d*$'"

# ATTRIBUTE7..19 <-> M0..M12 (HEADER_CONTENT 19토큰 중 기간 토큰 — 사내 실측 2026-09-23)
COLS = [(7 + i, f"M{i}") for i in range(13)]


def fetch(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=NAME, t=TYP)
    return "".join(r[0] for r in cur.fetchall())


def ddl(text):
    head, rest = text.split("\n", 1)
    head = re.sub(r'(?i)^\s*PACKAGE\s+BODY\s+"?\w+"?', f'CREATE OR REPLACE PACKAGE BODY SCM_MGR."{NAME}"', head, count=1)
    return head + "\n" + rest


def body_of(f):
    t = f.read_text(encoding="utf-8")
    return re.sub(r"\n/\s*$", "", t[t.index("CREATE OR REPLACE"):].rstrip())


def build_new_block():
    """정정된 '숫자여부 체크' UPDATE 전문을 만든다."""
    def bad(n):  # 비숫자 판정식
        return f"TRIM(ATTRIBUTE{n}) IS NOT NULL AND NOT REGEXP_LIKE(TRIM(ATTRIBUTE{n}), {RE_NUM})"

    case_lines = []
    for n, lbl in COLS:
        case_lines.append(f"                    WHEN {bad(n)}\n"
                          f"                         THEN '{lbl}: ' || TRIM(ATTRIBUTE{n})")
    where_lines = [f"                ({bad(n)}) OR--{lbl}" for n, lbl in COLS]
    where_lines[-1] = where_lines[-1].replace(" OR--", "   --")

    return (
        "        /* #################################################### */\n"
        "        /* 숫자여부 체크\t\t\t\t\t\t\t\t\t\t*/\n"
        "        /* #################################################### */\n"
        f"        /* [{TAG}] 사용자 지시 2026-09-23 — M0~M12 비숫자는 'Invalid QTY' 로 안내.\n"
        "           ⛔ 구 판정 `NVL(ATTRIBUTEn,'') <> ''` 는 Oracle 에서 '' = NULL 이라 **항상 UNKNOWN**,\n"
        "              즉 이 UPDATE 가 단 1행도 잡지 못하는 사문이었다(hook #119).\n"
        "              그 탓에 비숫자 값이 저장 분기까지 흘러가 TO_NUMBER 에서 ORA-01722 원문이 노출됐다.\n"
        "              사내 실증 2026-09-23: 현행 조건 검출 0건 / IS NOT NULL 정정 조건 1건.\n"
        "           정정 = TRIM(x) IS NOT NULL (빈 셀·공백셀은 종전대로 제외) + 정규식 대상도 TRIM(x).\n"
        "           메시지 = 'Invalid QTY [<헤더라벨>: <입력값>]' — 헤더라벨은 HEADER_CONTENT 기간 토큰\n"
        "              M0~M12 (ATTRIBUTE7~19 와 1:1). 첫 위반 칸 1개를 표기한다(CASE 선평가). */\n"
        "        UPDATE SCM_ADM_EXCEL_UPLOAD\n"
        "           SET UPLOAD_STATUS_CODE = 'ERROR'\n"
        "             , MESSAGE_TEXT       = 'Invalid QTY ['\n"
        "                                 || CASE\n"
        + "\n".join(case_lines) + "\n"
        "                                    END\n"
        "                                 || ']'\n"
        "         WHERE PROGRAM_ID         = V_PROGRAM_ID\n"
        "           AND SHEET_NAME         = V_SHEET_NAME\n"
        "           AND CREATED_BY         = P_CREATED_BY\n"
        "           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE\n"
        "           AND UPLOAD_STATUS_CODE = 'UPLOAD'\n"
        "           AND (\n"
        + "\n".join(where_lines) + "\n"
        "               );\n"
    )


def patch(src):
    b = src.index(PROC_BEG); e = src.index(PROC_END, b)
    seg = src[b:e]
    # '숫자여부 체크' 블록 = 주석 시작 ~ 그 UPDATE 의 종결 ');\n'
    i = seg.index(BLOCK_BEG)
    # 블록은 '/* ###...' 구분선부터 시작 — 주석 위 구분선까지 포함해 통째 교체
    start = seg.rindex("        /* #################################################### */", 0, i)
    j = seg.index("'Invalid NUMERIC.'", i)
    end = seg.index("               );\n", j) + len("               );\n")
    old = seg[start:end]
    assert old.count("NVL(ATTRIBUTE") == 13, f"판정식 {old.count('NVL(ATTRIBUTE')}개 (기대 13) — 중단"
    assert seg.count("'Invalid NUMERIC.'") == 1, "Invalid NUMERIC 앵커 중복 — 중단"
    new = build_new_block()
    out = src[:b] + seg.replace(old, new) + src[e:]
    assert "'Invalid NUMERIC.'" not in out, "구 메시지 잔존"
    assert out.count("'Invalid QTY ['") == 1, "신 메시지 삽입 실패"
    # 타 검증(Negative/Zero)은 손대지 않았는지 — 교체 블록 13개만 줄어야 한다.
    #   new 주석이 결함 원문 `NVL(ATTRIBUTEn,'')` 을 인용하므로 그 출현분을 더해 상쇄한다.
    expect = src.count("NVL(ATTRIBUTE") - 13 + new.count("NVL(ATTRIBUTE")
    assert out.count("NVL(ATTRIBUTE") == expect, \
        f"범위 밖 판정식이 변경됨 (out={out.count('NVL(ATTRIBUTE')} expect={expect})"
    # 실검증 조건(주석 제외 코드부)에서 사문식이 남은 곳 = Negative/Zero 26개여야 한다
    assert out.count("NVL(ATTRIBUTE") - new.count("NVL(ATTRIBUTE") == 40, "잔존 사문식 수 이상"
    return out, 1


def main():
    mode = sys.argv[1]
    u, p, d = ora.conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
    if mode == "backup":
        src = fetch(cur)
        assert TAG not in src, "이미 반영"
        patched, n = patch(src)
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={cur.fetchone()[0]} FETCHED={datetime.datetime.now():%Y-%m-%d %H:%M} DB=ZIOUI1\nSET DEFINE OFF\nSET SQLBLANKLINES ON\n"
        ASIS.parent.mkdir(parents=True, exist_ok=True); TOBE.parent.mkdir(parents=True, exist_ok=True)
        ASIS.write_text(stamp + ddl(src).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        TOBE.write_text(stamp + ddl(patched).rstrip() + "\n/\n", encoding="utf-8", newline="\n")
        print(f"backup ok — 블록 교체 {n}곳 / 구 메시지 잔존 0 / 범위 밖 판정식 무변경")
    elif mode == "apply":
        assert ddl(fetch(cur)).rstrip() == body_of(ASIS), "FRESH-GATE 실패: 백업 이후 DB 원문 변경 — 중단"
        cur.execute(body_of(TOBE))
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP)
        print("status", cur.fetchone())
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=NAME, t=TYP)
        errs = cur.fetchall(); print("errors", len(errs))
        for e in errs[:10]: print("  ", e)
        print("applied == TOBE", ddl(fetch(cur)).rstrip() == body_of(TOBE))
    elif mode == "restore":
        cur.execute(body_of(ASIS))
        cur.execute("SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=NAME, t=TYP); print("restored", cur.fetchone())


if __name__ == "__main__":
    main()
