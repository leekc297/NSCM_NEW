#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 대사표 — 잔여 10행 판정 확정 (모달 3 오탐 + 공통 UC 7).

⚠ hook: 게이트 FAIL = **먼저 도구 오탐인지 가른다**(feedback_gate_tool_false_positive_families).
   아래 3건은 AS-IS 원본 실측으로 **모달이 아님/비활성**임이 확인됐다 — 구현 대상이 아니다.

AS-IS 실측 (DMF0003_MktFcst.cs):
  · ImagePopUp        L555/L558  `siMain.ImagePopUp = imageList1.Images[0]`
                      → FarPoint Spread **셀 이미지 속성**. 팝업 화면이 아니다(추출기 오탐).
  · ShowDialog        15회       `popup.ShowDialog()` / `popProject.ShowDialog()` …
                      → WinForms **모달 표시 메서드**. 특정 팝업 이름이 아니다(추출기 오탐).
                        실제 팝업들은 ProjectByDivision/ItemByDivision 등으로 이미 별도 대사됨.
  · VersionCutOffPopUp L5605~5606 **전 줄 주석 처리** + btnCutOff_Click(L5593) 도 주석
                      → AS-IS 에서 **비활성(LEGACY/DISABLED)**. 이식 대상 아님.

공통 UC 는 코드 실측 결과를 근거와 함께 기입한다(§9.1 R-검증).
"""
import io, re, sys, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

MAP = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt-fcst\__asis-mapping__.md")
s = MAP.read_text(encoding="utf-8")

# (ID, 구현위치, 사유, 상태)
FIX = {
 "MODAL:ImagePopUp": (
   "해당없음 — 모달 아님",
   "AS-IS `DMF0003_MktFcst.cs` L555/L558 `siMain.ImagePopUp = imageList1.Images[0]` = FarPoint Spread **셀 이미지 속성**. 팝업 화면이 아니라 추출기 오탐",
   "해당없음"),
 "MODAL:ShowDialog": (
   "해당없음 — 메서드명",
   "AS-IS 15회 전부 `popup.ShowDialog()` 형태 = WinForms **모달 표시 메서드**. 특정 팝업 이름이 아니다. 실제 팝업(ProjectByDivision/ItemByDivision 등)은 별도 행으로 이미 대사됨",
   "해당없음"),
 "MODAL:VersionCutOffPopUp": (
   "해당없음 — AS-IS 비활성",
   "AS-IS L5605~5606 전 줄 주석 + `btnCutOff_Click`(L5593) 도 주석 = **LEGACY/DISABLED**. 분석서에도 'LEGACY/DISABLED' 명기(상세동작_개발용 §17). 이식 대상 아님",
   "해당없음"),
 "COMMON:UC-03": (
   "MktFcst.tsx:4,6 (ColumnLayoutModal/MeasureSelectModal) · useMktFcstStore.ts:68",
   "", "구현"),
 "COMMON:UC-04": (
   "MktFcst.tsx:64 `setToast` · components/modals/PrModal.tsx:50,141,182",
   "", "구현"),
 "COMMON:UC-05": (
   "MktFcst.tsx:393 (dataMap) · components/MktFcstGrid.tsx:301 · utils/mkt-fcst.gridCombos.ts:3",
   "", "구현"),
 "COMMON:UC-06": (
   "components/MktFcstForm.tsx:182,187 (join/split ',') · utils/mkt-fcst.gridCombos.ts:531",
   "", "구현"),
}

lines = s.split("\n")
done = []
for i, l in enumerate(lines):
    if not l.startswith("| "):
        continue
    cells = l.split("|")
    if len(cells) < 6:
        continue
    rid = cells[1].strip()
    if rid not in FIX:
        continue
    loc, why, st = FIX[rid]
    cells[3] = f" {loc} "
    cells[4] = f" {why} "
    cells[5] = f" {st} "
    lines[i] = "|".join(cells)
    done.append(rid)

MAP.write_text("\n".join(lines), encoding="utf-8")
print(f"[대사표] {len(done)}행 갱신")
for r in done:
    print(f"   {r:<30}→ {FIX[r][2]}")
missing = [k for k in FIX if k not in done]
if missing:
    print(f"⛔ 미반영 {missing}")
