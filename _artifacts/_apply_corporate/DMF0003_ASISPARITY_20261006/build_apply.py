"""[E20261006-ASISPARITY] PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST — AS-IS 운영 실제 동작 일치

배경 (사용자 확정 2026-10-06 "운영 as-is 와 같이 맞춰주세요"):
  AS-IS 운영 DMF0003_SAVE_MKT_FCST [E20260720-000270] 은 품목 원천을 뷰 DM_MST_ITEM_SINGLE_V 에서
  임시테이블 #TEMP_DM_MST_ITEM_SINGLE_V_ALL 로 바꿨는데, 적재 조건이 구분자 '^' 가 붙은 @p_division_id
  ('82^' 등)와 DIVISION_ID 를 직접 비교해 항상 0건이다. 그 결과 운영에서는 아래가 동작하지 않는다.
    ① 81 환산정보(Cell/Car) 검증  ② 81 Kwh/Cell·CELL_TYPE·Cell/Car 항목 검증  ③ BOM 존재 검증
    ④ 상품·전극 RTF_SYS_RP 삭제/생성  ⑤ RMA RTF_SYS_RP 삭제/생성
  TO-BE 는 뷰를 직접 조인해 전부 동작 중 → 운영 AS-IS 와 같게 비활성화한다.

방식: 지금 DB 원문(ALL_SOURCE) 위의 외과적 삽입 8곳 (기존 줄 삭제 없음 — 원복 = 삽입분 제거).
  python build_apply.py build    # 01_PKG_DMF0003_BODY.sql 생성만 (DB 변경 없음)
  python build_apply.py apply    # FRESH-GATE 후 적용 + 검증
"""
import sys, os, re, hashlib, json, datetime

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0003"
TYP = "PACKAGE BODY"
MARK = "[E20261006-ASISPARITY]"
WHY = "AS-IS 운영 [E20260720-000270] 실제 동작 일치 (품목 임시테이블 0건 → 운영에서 미동작)"
GUARD_IF = " AND 1 = 0 /* " + MARK + " */ THEN"
GUARD_SQL = "      AND  1 = 0  /* " + MARK + " */"


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl, status = cur.fetchone()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "status": status, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def one(lines, lo, hi, pred, what):
    hit = [i for i in range(lo, hi) if pred(lines[i])]
    assert len(hit) == 1, f"{what}: 매칭 {len(hit)}건 (1건이어야 함) — 원문이 바뀌었거나 이미 반영됨"
    return hit[0]


def guard_if(lines, i, what):
    s = lines[i]
    assert s.strip().startswith("IF V_CHECK_CNT > 0 THEN"), f"{what}: IF 줄 아님 → {s!r}"
    assert MARK not in s
    lines[i] = s.replace(" THEN", GUARD_IF, 1)


def transform(src):
    assert MARK not in src, "이미 반영됨"
    lines = src.split("\n")
    lo = one(lines, 0, len(lines), lambda l: l.startswith("  PROCEDURE P_DMF0003_SAVE_MKT_FCST"), "SAVE 멤버 시작")
    hi = len(lines)   # 저장 멤버 안에 지역 서브프로그램 선언이 있어 다음 멤버 경계 대신 끝까지 탐색 (고유 매칭 assert 로 보호)
    note = lambda ind, txt: ind + "-- " + MARK + " " + txt + " — " + WHY

    # ① 81 환산정보(Cell/Car) 검증 — 품목 GT 적재 + 검증 블록 전체
    a = one(lines, lo, hi, lambda l: "INSERT INTO SCM_MGR.GT_DMF3_ITEM_SINGLE_V" in l, "① GT 적재")
    i1 = max(i for i in range(a - 4, a) if lines[i].strip() == "IF V_CHECK_CNT > 0 THEN")
    # ② 81 Kwh/Cell·CELL_TYPE·Cell/Car 항목 검증
    i2 = one(lines, lo, hi, lambda l: l.strip() == "IF V_CHECK_CNT > 0 THEN -- Case 28 변환", "② 81 항목 검증")
    # ③ BOM 존재 검증 — 후보 선확인 + 본 검증
    b = one(lines, lo, hi, lambda l: "BOM 없는 후보 행부터 확인" in l, "③ BOM 선확인 주석")
    i3 = b + 1
    c = one(lines, lo, hi, lambda l: l.strip() == "V_VALID_BOM   := NULL;", "③ BOM 본 검증")
    i4 = c - 1
    assert i1 < i2 < i3 < i4
    # ④⑤ RTF_SYS_RP 삭제/생성 4문장 — WHERE 첫 조건 다음 줄에 삽입
    d1 = one(lines, lo, hi, lambda l: l.strip() == "WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200427 변경", "④ 삭제")
    d2 = one(lines, lo, hi, lambda l: l.strip() == "WHERE  MEASURE  = 'RTF_SYS_RP'  -- 20200507 변경", "⑤ 삭제")
    s1 = one(lines, lo, hi, lambda l: l.strip() == ", 'RTF_SYS_RP'  -- 20200427 변경", "④ 생성 SELECT")
    s2 = one(lines, lo, hi, lambda l: l.strip() == ", 'RTF_SYS_RP'  -- 20200507 변경", "⑤ 생성 SELECT")
    w1 = one(lines, s1, s1 + 10, lambda l: l.strip() == "WHERE  A.MEASURE   = 'MKT_FCST'", "④ 생성 WHERE")
    w2 = one(lines, s2, s2 + 10, lambda l: l.strip() == "WHERE  A.MEASURE   = 'MKT_FCST'", "⑤ 생성 WHERE")
    assert i4 < d1 < w1 < d2 < w2

    for i, w in ((i1, "① 81 환산정보 검증"), (i2, "② 81 항목 검증"), (i3, "③ BOM 후보 선확인"), (i4, "③ BOM 존재 검증")):
        guard_if(lines, i, w)
    # 뒤에서부터 삽입 (앞 인덱스 보존)
    for i, w in sorted(((d1, "④ 상품·전극 RTF_SYS_RP 삭제"), (w1, "④ 상품·전극 RTF_SYS_RP 생성"),
                        (d2, "⑤ RMA RTF_SYS_RP 삭제"), (w2, "⑤ RMA RTF_SYS_RP 생성")), reverse=True):
        lines.insert(i + 1, GUARD_SQL + " -- " + w + " 미수행")
    # 설명 주석 (위에서 아래 순서로 한 번씩, 인덱스 밀림 고려해 뒤에서부터)
    for i, txt in sorted(((i1, "81 환산정보(Cell/Car) 검증 미수행"), (i2, "81 Kwh/Cell·CELL_TYPE·Cell/Car 항목 검증 미수행"),
                          (i3, "BOM 존재 검증 미수행 (V_BOM_YN 갱신은 AS-IS 도 수행하므로 유지)")), reverse=True):
        ind = re.match(r"\s*", lines[i]).group()
        lines.insert(i, note(ind, txt))
    out = "\n".join(lines)
    assert out.count(MARK) == 4 + 4 + 3, out.count(MARK)
    assert out.count(GUARD_IF) == 4 and out.count(GUARD_SQL) == 4
    assert len(out.split("\n")) == len(src.split("\n")) + 7
    return out


def stamp(base):
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    return f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={base['last_ddl']} FETCHED={now} DB=ZIOUI1\n"


def build(cur):
    base = read_source(cur)
    new = transform(base["src"])
    with open(os.path.join(HERE, "01_PKG_DMF0003_BODY.sql"), "w", encoding="utf-8", newline="\n") as f:
        f.write(stamp(base) + "-- " + MARK + " " + WHY + "\n" + ddl_text(new) + "/\n")
    print("BUILD base", base["last_ddl"], base["md5"], "→ +7 lines")
    return base, new


def apply():
    with connect() as con:
        cur = con.cursor()
        base, new = build(cur)
        saved = json.load(open(os.path.join(HERE, "_fresh_state.json")))
        if saved["md5"] != base["md5"]:
            sys.exit("ABORT: 착수 시 백업본과 현재 DB 원문이 다름 — 재조회·재검토 필요")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 방금 읽은 기준본
        now = read_source(cur)
        if now["md5"] != base["md5"] or now["last_ddl"] != base["last_ddl"]:
            sys.exit("FRESH-GATE FAIL: 착수 후 DB 원문 변경 — 중단")
        print("FRESH-GATE PASS", now["last_ddl"], now["md5"])
        cur.execute(ddl_text(new).rstrip())
        after = read_source(cur)
        cur.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", n=PKG)
        errs = cur.fetchone()[0]
        cur.execute("SELECT object_name, object_type FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID' "
                    "AND object_name IN (SELECT name FROM all_dependencies WHERE referenced_owner='SCM_MGR' AND referenced_name=:n)", n=PKG)
        inv = cur.fetchall()
        print("AFTER", after["last_ddl"], after["status"], "errors", errs, "same_as_built", after["src"].rstrip() == new.rstrip(),
              "dependent_invalid", inv)
        json.dump({"before": {k: base[k] for k in ("last_ddl", "md5")}, "after": {k: after[k] for k in ("last_ddl", "status", "md5")},
                   "errors": errs, "dependent_invalid": inv}, open(os.path.join(HERE, "_apply_result.json"), "w"), indent=1, ensure_ascii=False)


if __name__ == "__main__":
    if sys.argv[1:] == ["apply"]:
        apply()
    else:
        with connect() as con:
            build(con.cursor())
