#!/usr/bin/env python3
"""
_selftest_make_cloud_csv.py — msg_update.py 검증용 **합성 클라우드 추출본** 생성기.

클라우드 DB 접속 권한이 없는 환경에서 A / B / C-1 / C-2 4분기가 실제로 발동하는지
확인하기 위한 도구다. 사내 원장을 뽑아 의도적으로 변형해 "가짜 클라우드 CSV" 를 만든다.
실제 DBeaver CSV export 를 흉내내 **BOM + CRLF + 따옴표 인용** 으로 쓴다(로더 검증 겸용).

  python _selftest_make_cloud_csv.py -o cloud_FIXTURE.csv

⚠ 산출물은 검증 전용이다. 실제 작업에서는 사용자가 클라우드에서 뽑은 진짜 파일을 쓴다.
"""
import argparse
import csv
import importlib.util
from pathlib import Path

HERE = Path(__file__).resolve().parent
ORA_PY = HERE.parents[2] / "_artifacts" / "_diagnostics" / "ora.py"
FIELDS = ("MSG_ID", "LANG_CD", "MSG_NM", "MSG_DESC", "MSG_TP_CD", "USE_YN")

# --- 변형 시나리오 -----------------------------------------------------------
# A   : 미사용 코드의 명칭만 변경 -> "명칭 UPDATE 만"
# C-1 : 사용중 코드의 명칭 변경 + 옛 명칭을 이미 보유한 다른 코드 존재 -> 그 코드로 치환
# C-2 : 사용중 코드의 명칭을 유일값으로 변경 -> 신규 채번 + 클라우드 PUSH
RENAME = {
    ("LBL00002", "KO"): "미사용 라벨(클라우드 변경본)",          # A  (사용처 0)
    ("LBL00001", "KO"): "사업부",                              # C-1 (옛 'Div' = LBL00663 보유)
    ("LBL00001", "EN"): "Business Division",
    ("MSG01014", "KO"): "이 기능은 특정 사업부 전용입니다.",       # C-2 (옛 명칭 보유 코드 없음)
    ("MSG01014", "EN"): "This function is division-restricted.",
    # WS : 뒤 공백만 제거된 값 -> "공백차이"로 분류되어야 하며 코드 채번은 없어야 한다
    # META: MNU_M.MNU_MSG_ID 가 참조하는 코드 -> 메타 치환 SQL + MNU 대역 채번 검증
    ("MNU00023", "KO"): "권한 관리(클라우드 변경본)",
    ("MNU00185", "KO"): "Biz Plan Price",
    ("MNU00185", "EN"): "Biz Plan Price",
}
# B : 사내에 없는 신규 코드 (따옴표·콤마·개행 포함 = 로더 스트레스)
ADDED = [
    ("LBL00901", "KO", '신규,라벨 "따옴표" 포함', None, "LBL", "Y"),
    ("LBL00901", "EN", "New label with, comma", None, "LBL", "Y"),
    ("MSG00901", "KO", "여러 줄\n메시지 테스트", "설명", "MSG", "Y"),
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--out", required=True)
    a = ap.parse_args()

    spec = importlib.util.spec_from_file_location("ora_helper", ORA_PY)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    import oracledb
    u, p, d = mod.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con, con.cursor() as cur:
        cur.execute("SELECT MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN "
                    "FROM SCM_MGR.SCM_ADM_MSG_M ORDER BY MSG_ID, LANG_CD")
        rows = [list(r) for r in cur.fetchall()]

    hit = 0
    for r in rows:
        nm = RENAME.get((r[0], r[1]))
        if nm:
            r[2] = nm
            hit += 1
    rows.extend([list(x) for x in ADDED])

    with open(a.out, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f, quoting=csv.QUOTE_ALL, lineterminator="\r\n")
        w.writerow(FIELDS)
        for r in rows:
            w.writerow(["" if v is None else v for v in r])

    print(f"[fixture] {a.out}  총 {len(rows)}행 (명칭변경 {hit} / 신규 {len(ADDED)})")
    print("  A  : LBL00002(미사용) 명칭 변경 -> UPDATE 만")
    print("  C-1: LBL00001(사용중) 명칭 변경 -> 옛 'Div' 보유 코드로 치환 기대")
    print("  C-2: MSG01014(DMF0082 사용중) 명칭 변경 -> 신규 채번 + 클라우드 PUSH 기대")
    print("  META: MNU00023(Auth_Mgmt 메뉴 참조) 변경 -> 메타 UPDATE + MNU01001 채번 기대")
    print("  WS : MNU00185 뒤 공백 제거 -> 공백차이 분류·채번 없음 기대")
    print("  B  : LBL00901/MSG00901 신규 -> INSERT 기대 (따옴표·콤마·개행 포함)")


if __name__ == "__main__":
    main()
