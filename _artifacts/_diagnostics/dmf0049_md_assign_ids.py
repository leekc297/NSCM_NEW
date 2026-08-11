#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_md_assign_ids.py — DMF0049 원천 md 의 **ID 컬럼 없는 데이터 표**에 제약 ID 부여 (2026-08-11)

## 배경 — 커버리지 결손
`asis_mapping_gate --init` 이 DMF0049 재생성 시 경고를 냈다:
    [warn] ID 컬럼 없는 데이터 표 행 83건 — **추출 대상 아님**
결과로 DMF0049 대사표는 **63행**뿐인데 형제 화면은 DMF0044=155 / DMF0042=273 / DMF0082=280 이다.
빠진 행들은 서식 문제일 뿐 내용은 전부 실재 제약이다(Division 분기 22 / 권한 13 / Measure 15 /
기간·버전 16 / 잠금 45 / SP 호출 6 …). ⇒ **ID 를 부여해 추출 경로에 태운다.**

## 설계 — 추측 없음
· 추출기 인식 형식 = `RE_TABLE_CONSTRAINT = ^\\|\\s*([A-Z]{1,3}-?\\d{1,3})\\s*\\|` → `XX-01` 형태.
· 표는 **인덱스로 명시 지정**한다(자동 판별 금지). 아래 PREFIX 맵에 없는 표는 **건드리지 않는다**.
· 각 표의 첫 컬럼 앞에 `| ID ` 컬럼을 삽입한다(헤더·구분행·데이터행 모두).
· 이미 ID 가 인식되는 표(T03/T08/T12/T14 등)는 대상에서 제외 — 중복 부여 방지.

## 제외 사유 (은폐 아님 — 명시)
· `원천 (전수 Read 실측)` 표 = 분석 메타(파일·행수)이지 화면 동작이 아니다 ⇒ 제외.
· 주요이벤트 `이벤트 배선 전수(Designer.cs)` 표 = **`--handlers` 축이 이미 18개로 전수 강제**한다
  ⇒ 중복 등재 방지를 위해 제외.

사용:
  python dmf0049_md_assign_ids.py --dry / --apply
"""
import argparse
import pathlib
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

DOC_EVENT = pathlib.Path(r"C:\Projects\NSCM\Doc\화면분석서\DMF0049_EtcSalesReports_주요이벤트_상세분석.md")
DOC_MATRIX = pathlib.Path(r"C:\Projects\NSCM\Doc\화면분석서\DMF0049_EtcSalesReports_제약매트릭스_상세.md")

RE_SEP = re.compile(r"^\|[\s:\-|]+\|$")

# {문서: {표인덱스(1-base): (접두, 설명)}} — 명시 지정만 처리
PREFIX = {
    DOC_EVENT: {
        3: ("BF", "5.1 BaseForm override 공통버튼"),
        4: ("VM", "5.3 화면 내 검증 메시지"),
        5: ("HU", "부록 헬퍼/유틸"),
    },
    DOC_MATRIX: {
        2: ("DV", "1. Division 축 분기"),
        4: ("AU", "2.1 권한 축 — 정본 화면"),
        5: ("AP", "2.2 권한 축 — 팝업측"),
        6: ("MS", "3. Measure/컬럼 축"),
        7: ("PV", "4. 기간·버전 축"),
        9: ("LE", "6.1 잠금 — EditButton"),
        10: ("LF", "6.2 잠금 — FindData"),
        11: ("LI", "6.3 잠금 — InsertRow"),
        13: ("LP", "6.5 잠금 — 팝업측"),
        15: ("XP", "7.4 비활성 팝업 인벤토리"),
        16: ("SP", "8.1 SP 직접 호출"),
    },
}


def process(path, dry):
    lines = path.read_text(encoding="utf-8").splitlines()
    pmap = PREFIX[path]
    out = []
    i = 0
    tno = 0
    report = []
    while i < len(lines):
        ln = lines[i]
        if ln.startswith("|") and i + 1 < len(lines) and RE_SEP.match(lines[i + 1].strip()):
            tno += 1
            hdr, sep = ln, lines[i + 1]
            j = i + 2
            rows = []
            while j < len(lines) and lines[j].startswith("|"):
                rows.append(lines[j])
                j += 1
            if tno in pmap:
                pre, desc = pmap[tno]
                if hdr.lstrip().startswith("| ID "):
                    report.append("  [T%02d] %-28s 이미 부여됨 — 건너뜀" % (tno, pre))
                    out.extend([hdr, sep] + rows)
                else:
                    out.append("| ID " + hdr.lstrip())
                    out.append("|---" + sep.lstrip())
                    for k, r in enumerate(rows, 1):
                        out.append("| %s-%02d " % (pre, k) + r.lstrip())
                    report.append("  [T%02d] %-4s %-26s %d행 부여 (%s-01 ~ %s-%02d)"
                                  % (tno, pre, desc, len(rows), pre, pre, len(rows)))
            else:
                out.extend([hdr, sep] + rows)
            i = j
            continue
        out.append(ln)
        i += 1
    print("\n## %s (표 %d개)" % (path.name, tno))
    for r in report:
        print(r)
    if not dry:
        path.write_text("\n".join(out) + "\n", encoding="utf-8")
    return sum(int(r.split("행 부여")[0].split()[-1]) for r in report if "행 부여" in r)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry", action="store_true")
    ap.add_argument("--apply", action="store_true")
    a = ap.parse_args()
    if not (a.dry or a.apply):
        ap.error("--dry / --apply 중 하나 필요")
    total = sum(process(p, a.dry) for p in (DOC_EVENT, DOC_MATRIX))
    print("\n== 부여 합계 %d행 (%s)" % (total, "드라이런" if a.dry else "적용됨"))


if __name__ == "__main__":
    main()
