#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_handlers_fill.py — DMF0049 대사표 'AS-IS 이벤트 핸들러 인벤토리' 축 기입 (2026-08-10)

`asis_mapping_gate.py --handlers` 가 AS-IS `.cs` 실측으로 뽑은 18 핸들러의
[구현 위치] / [사유] / [상태] 를 채운다. 값은 전부 양쪽 파일을 열어 확인한 것이다.
"""
import pathlib
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
MD = ROOT / "nscm-fe/features/demand/src/pages/etc-sales-reports/__asis-mapping__.md"
P = "features/demand/src/pages/etc-sales-reports"

DEAD = "AS-IS 몸통이 비어 있는 사문(dead) 핸들러 — 실제 동작은 아래 대응 메서드가 담당한다. 이식 대상 아님"

FILL = {
    "HANDLER:Form_Load": (f"{P}/EtcSalesReports.tsx:126~133 (초기화 useEffect)", "", "구현"),
    "HANDLER:FindButton": ("", DEAD + " (→ `FindData`)", "제외"),
    "HANDLER:FindData": (f"{P}/EtcSalesReports.tsx:142~155 (handleSearch) + "
                         f"{P}/useEtcSalesReportsStore.ts:121~165 (setFilter)", "", "구현"),
    "HANDLER:InsertButton": ("", DEAD + " (→ `InsertRow`)", "제외"),
    "HANDLER:InsertRow": (f"{P}/EtcSalesReports.tsx:168~189 (handleInsert — division 세트 블록 삽입) + "
                          f"{P}/utils/etc-sales-reports.editLock.ts:88~101 (신규행 정적 컬럼 잠금)",
                          "", "구현"),
    "HANDLER:DeleteButton": (f"{P}/EtcSalesReports.tsx:191~201 (handleDelete)", "", "구현"),
    "HANDLER:EditButton": (f"{P}/utils/etc-sales-reports.editLock.ts:22~104 "
                           f"(G0 게이트 + 동적 셀 매트릭스 + 정적 컬럼 2분기) — TO-BE 는 별도 Edit 버튼 없이 "
                           f"셀 단위 판정 엔진이 항상 적용된다", "", "구현"),
    "HANDLER:SaveButton": ("", DEAD + " (→ `SaveData`)", "제외"),
    "HANDLER:SaveData": (f"{P}/EtcSalesReports.tsx:203~ (handleSave) + "
                         f"{P}/utils/etc-sales-reports.save.ts:111~180", "", "구현"),
    "HANDLER:ExcelButton": (f"{P}/EtcSalesReports.tsx:352 (DataGrid excelFileName) — "
                            f"공통버튼 EXCEL 계약이 내보내기를 담당", "", "구현"),
    "HANDLER:btnSPVer_Click": (f"{P}/EtcSalesReports.tsx:343 (onOpenVersionModal → VERSION) + "
                               f"{P}/components/EtcSalesReportsForm.tsx:114 (btnSPVer '...')", "", "구현"),
    "HANDLER:btnMeasure_Click": (f"{P}/EtcSalesReports.tsx:311~316 (MEASURE_SELECT hotkey → MEASURE 모달) + "
                                 f"{P}/components/modals/MeasureSelectModal.tsx", "", "구현"),
    "HANDLER:clbDivision_SelectedIndexChanged": (
        f"{P}/EtcSalesReports.tsx:157~164 (handleDivisionChange — Grid 초기화 + CRUD reset + "
        f"정적컬럼·Measure 재조회) ← {P}/components/EtcSalesReportsForm.tsx:58~61", "", "구현"),
    "HANDLER:clbPlanResult_SelectedIndexChanged": (
        f"{P}/components/EtcSalesReportsForm.tsx:96~101 (planResult set) + "
        f"{P}/useEtcSalesReportsStore.ts:156~160 (resultMonth 스냅샷은 조회 시점에 확정)", "", "구현"),
    "HANDLER:clbType_SelectedIndexChanged": (
        f"{P}/components/EtcSalesReportsForm.tsx:70~72 (mdfType 변경 시 versionNo/versionLabel 초기화 — "
        f"AS-IS `txtSPVersion.Text = null` 파리티) · :116 (BP/SP 라벨 전환)", "", "구현"),
    "HANDLER:spdMain_Changed": (
        f"{P}/components/EtcSalesReportsGrid.tsx:302~330 (cellEditEnded — 수치셀 빈값 '0' + cascade clear) + "
        f"{P}/utils/etc-sales-reports.gridCombos.ts (resolveDeptIdRows · cascadeClearColumns)", "", "구현"),
    "HANDLER:spdMain_CellDoubleClick": (
        f"{P}/components/EtcSalesReportsGrid.tsx:335~343 (dblclick → PROJECT 모달)", "", "구현"),
    "HANDLER:spdMain_CellClick": (
        "", "AS-IS 는 Measure Cnt 에 따른 **Row Span 재계산**(주석 [C20210125-000207])과 "
            "CUST_REPORT 무파라미터 콤보 재바인딩만 한다. TO-BE 는 Row Span 을 "
            f"`{P}/utils/etc-sales-reports.merge.ts` MergeManager 가 선언적으로 처리하고, "
            "콤보는 무파라미터라 진입 시 1회 프리페치와 등가다 — 별도 클릭 핸들러 불요", "제외"),
}


def main():
    text = MD.read_text(encoding="utf-8")
    filled, missed = 0, []
    for eid, (loc, why, state) in FILL.items():
        pat = re.compile(
            r"^(\| *%s *\| *)([^|]*)(\|)([^|]*)(\|)([^|]*)(\| *)([^|\n]*)(\|)\s*$"
            % re.escape(eid), re.M)
        if not pat.search(text):
            missed.append(eid)
            continue
        text = pat.sub(
            lambda mm: "%s%s| %s | %s | %s |" % (mm.group(1), mm.group(2), loc, why, state),
            text, count=1)
        filled += 1
    MD.write_text(text, encoding="utf-8")
    print("[fill] 핸들러 %d행 기입 / 미발견 %d" % (filled, len(missed)))
    for e in missed:
        print("  ⚠ 미발견 ID: %s" % e)
    return 1 if missed else 0


if __name__ == "__main__":
    sys.exit(main())
