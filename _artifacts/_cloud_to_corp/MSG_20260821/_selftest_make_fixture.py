#!/usr/bin/env python3
"""
_selftest_make_fixture.py — msg_sync.py 의 클라우드측 경로를 검증하기 위한
                            **합성 스냅샷** 생성기 (실 클라우드 데이터 아님).

클라우드 DB 접속 권한이 없는 환경에서 NAME_DIFF / ATTR_DIFF / CLOUD_ONLY /
CORP_ONLY / CODE_SPLIT 5개 분기가 실제로 발동하는지 확인하기 위한 도구다.
사내 스냅샷을 의도적으로 변형해 "가짜 클라우드" 를 만든다.

  python _selftest_make_fixture.py --corp snap_corp.txt --out snap_cloud_FIXTURE.txt

⚠ 산출물은 검증 전용이다. 실제 이관 절차에서는 반드시 클라우드 DB 에서
  10_EXPORT_MSG_SNAPSHOT.sql 로 뽑은 진짜 스냅샷을 사용할 것.
"""
import argparse
from pathlib import Path

MUTATIONS = {
    # (MSG_ID, LANG_CD) -> ('name', 새 MSG_NM)  = NAME_DIFF 유발
    ("LBL00001", "KO"): ("name", "구분(클라우드 변경본)"),
    ("LBL00067", "KO"): ("name", "장기 유형"),
    ("MSG00097", "KO"): ("name", "사업부를 선택해 주십시오."),
    # 사내 명칭이 소스에 하드코딩된 코드 — 하드코딩텍스트 축 검증용
    ("LBL00005", "KO"): ("name", "생산 사이트"),
    # ('desc', 새 MSG_DESC) = ATTR_DIFF 유발
    ("LBL00068", "KO"): ("desc", "클라우드에서만 붙은 설명"),
    ("LBL00069", "EN"): ("desc", "cloud-side description"),
    # 'drop' = 클라우드에 없음 -> CORP_ONLY
    ("LBL00070", "CN"): ("drop", None),
    ("LBL00071", "CN"): ("drop", None),
}
# CLOUD_ONLY 유발 — 사내에 없는 신규 코드
ADDED = [
    ("LBL09901", "KO", "신규 라벨(클라우드 전용)", None, "LBL", "Y"),
    ("LBL09901", "EN", "New Label (cloud only)", None, "LBL", "Y"),
    ("MSG09901", "KO", "신규 메시지(클라우드 전용)", None, "MSG", "Y"),
]
# CODE_SPLIT 유발 — 사내 LBL00069('Date') 와 같은 명칭을 다른 코드로 보유
ADDED_SPLIT = [("LBL09902", "KO", None, None, "LBL", "Y")]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--corp", required=True)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    src = Path(a.corp).read_text(encoding="utf-8").splitlines()
    out, dropped, renamed, descd = [], 0, 0, 0
    corp_names = {}
    for ln in src:
        if ln.startswith("#FORMAT"):
            out.append(ln)
            continue
        if ln.startswith("#META"):
            out.append("#META\tSIDE=CLOUD(FIXTURE — 합성 데이터, 실 클라우드 아님)")
            continue
        f = ln.split("\t")
        if len(f) != 6:
            continue
        key = (f[0], f[1])
        corp_names[key] = f[2]
        m = MUTATIONS.get(key)
        if m and m[0] == "drop":
            dropped += 1
            continue
        if m and m[0] == "name":
            f[2] = m[1]
            renamed += 1
        if m and m[0] == "desc":
            f[3] = m[1]
            descd += 1
        out.append("\t".join(f))

    for rec in ADDED:
        out.append("\t".join(v if v is not None else r"\N" for v in rec))
    # CODE_SPLIT: 사내 LBL00069/KO 명칭을 그대로 다른 코드로 복사
    base = corp_names.get(("LBL00069", "KO"), "Date")
    for mid, lg, _nm, _ds, tp, use in ADDED_SPLIT:
        out.append("\t".join([mid, lg, base, r"\N", tp, use]))

    Path(a.out).write_text("\n".join(out) + "\n", encoding="utf-8")
    print(f"[fixture] {a.out}")
    print(f"  NAME_DIFF 유발 {renamed} / ATTR_DIFF {descd} / CORP_ONLY(삭제) {dropped} "
          f"/ CLOUD_ONLY(추가) {len(ADDED)} / CODE_SPLIT 1 (LBL09902 = '{base}')")


if __name__ == "__main__":
    main()
