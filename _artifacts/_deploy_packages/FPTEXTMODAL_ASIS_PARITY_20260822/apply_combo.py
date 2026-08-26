#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""admin `Cell object` 드롭다운(`ColumnControlType`)에 `FPTextModal` 등재.

## 왜 필요한가

`apply.py` 로 메타 6행을 `FPTextModal` 로 복원했지만, admin SYS0004 의 `Cell object` 셀은
lookup 테이블이 아니라 **CMBO SQL `ColumnControlType` 의 하드코딩 UNION ALL 14종**을 쓴다(실측).
등재하지 않으면:
  · 운영자가 드롭다운에서 `FPTextModal` 을 **고를 수 없다**
  · 기존 6행을 admin 에서 열면 목록에 없는 값이라 **빈 셀로 보이고**, 다른 값 저장 시 조용히 유실된다

## 소비자 확인 (공유 CMBO 덮어쓰기 전 의무)

    SHEET_COLUMNS 배선 : SYS0004/column/CELL_CONTROL_OBJECT_TYPE_CODE  (1행이 전부)
    FE 하드코딩        : 0건 (`grep ColumnControlType` packages/features/apps)
⇒ 영향 범위는 admin SYS0004 셀 하나. 기존 14종은 **손대지 않고 1종만 추가**한다.

정렬 위치: `FPText`·`FPTextBox` 뒤 (알파벳 순서 유지 — 기존 목록이 알파벳 정렬이다).
멱등: 이미 포함돼 있으면 무변경. 실행: python apply_combo.py  (점검만: --dry)
"""
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

SQL_ID = "ColumnControlType"
NEW = "FPTextModal"
ANCHOR = "FPTextBox"          # 이 값 뒤에 삽입 (알파벳 순)
BAK = "BAK_CMBO_COLUMNCTRLTYPE_20260822"


def body_of(cur):
    cur.execute("SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:s", s=SQL_ID)
    r = cur.fetchone()
    if not r:
        sys.exit(f"[ABORT] CMBO '{SQL_ID}' 미등록 — 중단.")
    v = r[0]
    return v.read() if hasattr(v, "read") else v


def codes_of(body):
    return re.findall(r"SELECT\s+'([^']+)'\s+AS CODE", body, re.I)


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = body_of(cur)
    codes = codes_of(before)
    print(f"== 적용 전: {len(codes)}종 ==")
    print("  ", codes)

    if NEW in codes:
        print(f"== 이미 등재됨({NEW}) — 무변경 종료 ==")
        con.close()
        return 0
    if ANCHOR not in codes:
        sys.exit(f"[ABORT] 기준값 '{ANCHOR}' 부재 — 목록 구조 변동. 중단.")

    # 앵커 절을 통째로 찾아 그 뒤에 동일 형태로 1절 추가 (원문 서식 보존)
    m = re.search(r"SELECT\s+'%s'\s+AS CODE\s*,\s*'%s'\s+AS NAME\s+FROM\s+DUAL" % (ANCHOR, ANCHOR),
                  before, re.I)
    if not m:
        sys.exit(f"[ABORT] '{ANCHOR}' 절 패턴 불일치 — 수기 확인 필요. 중단.")
    clause = m.group(0)
    after = before[:m.end()] + " UNION ALL " + clause.replace(ANCHOR, NEW) + before[m.end():]

    new_codes = codes_of(after)
    # 회귀 가드 — 기존 14종이 전부 살아있고 정확히 1종만 늘어야 한다
    if set(codes) - set(new_codes):
        sys.exit(f"[ABORT] 기존 값 유실: {set(codes) - set(new_codes)} — 중단.")
    if len(new_codes) != len(codes) + 1:
        sys.exit(f"[ABORT] 기대 {len(codes)+1}종 / 실제 {len(new_codes)}종 — 중단.")
    print(f"== 적용 후(예정): {len(new_codes)}종 ==")
    print("  ", new_codes)

    if dry:
        print("== --dry: 변경 없이 종료 ==")
        con.close()
        return 0

    cur.execute("SELECT COUNT(*) FROM all_tables WHERE owner='SCM_MGR' AND table_name=:t", t=BAK)
    if cur.fetchone()[0] == 0:
        cur.execute(f"CREATE TABLE SCM_MGR.{BAK} AS "
                    f"SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='{SQL_ID}'")
        print(f"== BACKUP 생성: SCM_MGR.{BAK} ==")
    else:
        print(f"== BACKUP 기존 유지: SCM_MGR.{BAK} ==")

    cur.setinputsizes(v=cfg.oracledb.CLOB if hasattr(cfg, "oracledb") else None)
    cur.execute("""UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
                      SET SQL_DTL_CTN=:v, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
                    WHERE SQL_ID=:s""", v=after, s=SQL_ID)
    print(f"   UPDATE {cur.rowcount}행")
    con.commit()
    print("== COMMIT ==")

    print("== VERIFY ==")
    bad = 0
    final = codes_of(body_of(cur))
    ok = NEW in final and len(final) == len(codes) + 1 and not (set(codes) - set(final))
    print(f"   {'PASS' if ok else 'FAIL'}  목록 {len(codes)}종 -> {len(final)}종, {NEW} 포함={NEW in final}")
    bad += 0 if ok else 1

    # 실행 검증 — 콤보 SQL 이 실제로 돌아가고 신규값을 반환하는가
    try:
        cur.execute(f"SELECT COUNT(*) FROM ({body_of(cur)}) WHERE CODE='{NEW}'")
        n = cur.fetchone()[0]
        print(f"   {'PASS' if n == 1 else 'FAIL'}  콤보 SQL 실행 결과 {NEW} {n}행")
        bad += 0 if n == 1 else 1
    except Exception as e:                                   # noqa: BLE001
        print(f"   FAIL  콤보 SQL 실행 오류: {e}")
        bad += 1

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
