#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS DMF0082 컬럼별 EVENT 전수 추출 (사용자 지시 2026-08-22).

> "ASIS 의 SOURCE내 COLUMN별 EVENT 내역을 일괄적으로 추출해서 정리를 먼저 해주세요."

## 원칙

· **주석은 근거가 아니다**(hook #138) → `strip_code_comments.strip_cs` 로 라인 보존 제거본에서만 판정.
  (이 화면은 주석 처리된 `SetValue(e.Row, iCol, "")` 계열이 다수라, 주석을 세면 있지도 않은 종속이 생긴다.)
· **전수**(anti-simplification) → 샘플링 없이 `spdMain_*` 핸들러 **전 handler 전 라인**을 훑는다.
· 컬럼 식별자는 `DefColumns.X` 상수 → 실제 COLUMN_NAME 매핑까지 같이 뽑는다(추정 금지).

## 대상 이벤트 (Designer 배선 실측 — DMF0082_FcstNPrice_Mgmt.Designer.cs:1142~1148)

    ClipboardPasted / LeaveCell / CellDoubleClick / ComboSelChange / EditChange / TopChange / KeyUp
    + 데이터 모델 변경 `spdMain_Changed`

산출: _dmf0082_asis_column_events.json  (+ 콘솔 요약)
"""
import io
import json
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from strip_code_comments import strip_cs                        # noqa: E402

SRC = (r"C:\Projects\NSCM\GSCM\06.UIL\GSCM.DM.Forms.UIL\Plan"
       r"\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs")
OUT = r"C:\Projects\NSCM\_artifacts\_diagnostics\_dmf0082_asis_column_events.json"
NL = chr(10)

# Designer 실측 배선 + 데이터모델 변경
HANDLERS = ("spdMain_ClipboardPasted", "spdMain_LeaveCell", "spdMain_CellDoubleClick",
            "spdMain_ComboSelChange", "spdMain_EditChange", "spdMain_TopChange",
            "spdMain_KeyUp", "spdMain_Changed")


def method_span(text, name):
    """메서드 선언 이후 첫 '{' 부터 짝 맞는 '}' 까지 — 문자열/문자 리터럴 안의 괄호는 건너뛴다."""
    spans = []
    for m in re.finditer(r"^\s*(?:private|protected|public|internal)[^\n(]*\b"
                         + re.escape(name) + r"\s*\(", text, re.M):
        i = text.find("{", m.end())
        if i < 0:
            continue
        depth, j, in_s, in_c = 0, i, False, False
        while j < len(text):
            ch = text[j]
            if in_s:
                if ch == "\\":
                    j += 2
                    continue
                if ch == '"':
                    in_s = False
            elif in_c:
                if ch == "\\":
                    j += 2
                    continue
                if ch == "'":
                    in_c = False
            elif ch == '"':
                in_s = True
            elif ch == "'":
                in_c = True
            elif ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    break
            j += 1
        spans.append((m.start(), i, j))
    return spans


def line_of(text, pos):
    return text[:pos].count(NL) + 1


def main():
    raw = io.open(SRC, encoding="utf-8", errors="replace").read()
    code = strip_cs(raw)                       # 라인 보존 — 라인번호가 원본과 1:1
    print(f"== 원본 {raw.count(NL)+1}줄 · 주석 제거본 동일 라인수 {code.count(NL)+1} ==")

    # DefColumns 상수 → 실제 컬럼명
    defcols = {}
    for m in re.finditer(r"(?:public|internal|private)?\s*(?:const|static\s+readonly)\s+string\s+"
                         r"([A-Za-z_][\w]*)\s*=\s*\"([^\"]+)\"", code):
        defcols[m.group(1)] = m.group(2)
    print(f"   DefColumns 상수 {len(defcols)}개 추출")

    result = {"source": SRC, "defcolumns": defcols, "handlers": {}}
    for h in HANDLERS:
        spans = method_span(code, h)
        if not spans:
            result["handlers"][h] = {"exists": False}
            print(f"   {h:26s} — 미존재")
            continue
        blocks = []
        for _decl, i, j in spans:
            body = code[i:j + 1]
            l1, l2 = line_of(code, i), line_of(code, j)
            cols = sorted(set(re.findall(r"DefColumns\.([A-Za-z_][\w]*)", body)))
            blocks.append({"line_from": l1, "line_to": l2, "loc": l2 - l1 + 1,
                           "columns_referenced": cols,
                           "setvalue_count": len(re.findall(r"\.SetValue\s*\(", body)),
                           "getvalue_count": len(re.findall(r"\.GetValue\s*\(", body))})
        result["handlers"][h] = {"exists": True, "blocks": blocks}
        tot = sum(b["loc"] for b in blocks)
        cols = sorted({c for b in blocks for c in b["columns_referenced"]})
        print(f"   {h:26s} {len(blocks)}블록 · {tot:5d} LOC · 참조 컬럼 {len(cols):2d}종"
              f" · SetValue {sum(b['setvalue_count'] for b in blocks):3d}")

    io.open(OUT, "w", encoding="utf-8", newline=NL).write(
        json.dumps(result, ensure_ascii=False, indent=2))
    print(f"{NL}   -> {OUT}")
    print(f"   ⚠ 이 스크립트는 **범위·규모 확정**까지다. 컬럼별 종속 규칙은 본문을 읽고 정리한다"
          f"(자동 파싱만으로 규칙을 단정하지 않는다 — anti-simplification).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
