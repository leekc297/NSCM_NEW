#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0049_mapping_fill.py — DMF0049 `__asis-mapping__.md` EID 1:1 대사표 기입 (2026-08-10)

`asis_mapping_gate.py --init` 이 만든 40행(이벤트·제약 34 + CRUD·모달 6)의
[구현 위치] / [사유] / [상태] 를 **FE 실측 라인**으로 채운다.

⚠ 채우는 값은 전부 실제 파일을 열어 확인한 것이다. 추정으로 채우면 게이트가 무력해진다.
⚠ 재실행 안전(멱등) — ID 매칭으로 해당 행만 치환한다.
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

# ID -> (구현 위치, 사유, 상태)
FILL = {
    # ── §0~§1 초기화 ─────────────────────────────────────────────────────────
    "E00": ("", "정본 선택 근거 — `GSCM.DM.Forms.UIL/Plan/DMF0049_Sales_ETC_Reports/`(1,727행) "
                "폴더단위 유일본. 평면본 `GSCM.DM.Plan.UIL/DMF0049_Sales_ETC_Reports.cs` 는 구본. "
                "TO-BE 구현 산출물이 아니라 **분석 메타** 항목", "제외"),
    "E01": (f"{P}/EtcSalesReports.tsx:126~133 (useEffect 초기화 — fetchStaticColumns/fetchStaticMeasures)",
            "", "구현"),
    "E01-1": (f"{P}/components/EtcSalesReportsForm.tsx:37~39 (MDF_TYPE·CALENDAR_YYYY) + "
              f"{P}/useEtcSalesReportsStore.ts:100~116 (initSearch 기본값)", "", "구현"),
    "E01-2": (f"{P}/components/EtcSalesReportsGrid.tsx:76~120 (정적 컬럼 메타 + 셀 콤보 dataMap) + "
              f"{P}/utils/etc-sales-reports.merge.ts:17 (2단 헤더 MergeManager)", "", "구현"),
    "E01-3": ("", "AS-IS FarPoint `DefineProperty` = Spread 내부 속성 선언. TO-BE 는 Wijmo + "
                  "SHEET_COLUMNS 메타가 동일 역할을 하며 대응 코드 단위가 없다(hook #113 메타 주도)",
              "해당없음"),
    # ── §2 조회 ──────────────────────────────────────────────────────────────
    "E02": (f"{P}/EtcSalesReports.tsx:142~155 (handleSearch) + "
            f"{P}/useEtcSalesReportsStore.ts:121~165 (setFilter — thisMonth/resultMonth 스냅샷) + "
            f"{P}/EtcSalesReports.tsx:83~90 (useTabProcQuery MAIN)", "", "구현"),
    # ── §3 편집/저장 ─────────────────────────────────────────────────────────
    "E03": (f"{P}/utils/etc-sales-reports.editLock.ts:30~71 (evalEtcReportCell) + "
            f"{P}/EtcSalesReports.tsx:203~ (handleSave)", "", "구현"),
    "E03-1": (f"{P}/utils/etc-sales-reports.editLock.ts:22~23 (G0 그룹 게이트) · :30~71 (동적 셀 매트릭스) · "
              f":88~104 (정적 컬럼 잠금 — Insert/기존행 2분기)", "", "구현"),
    "E03-2": (f"{P}/EtcSalesReports.tsx:203~ (handleSave) + "
              f"{P}/utils/etc-sales-reports.save.ts:111~175 (buildEtcReportSaveRows — 세트×채택월×세트내 행) · "
              f":176~ (buildBulkPayload '^' bulk)", "", "구현"),
    "E03-3": (f"{P}/EtcSalesReports.tsx:168~189 (handleInsert — GET_MEASURE CODE 순서 강제 세팅) + "
              f"{P}/etc-sales-reports.constants.ts:92~105 (INSERT_ROW_DEFAULTS)", "", "구현"),
    "E03-4": (f"{P}/EtcSalesReports.tsx:191~201 (handleDelete)", "", "구현"),
    # ── §4 그리드 이벤트 ─────────────────────────────────────────────────────
    "E04": (f"{P}/components/EtcSalesReportsGrid.tsx:259~343 (formatItem / beginningEdit / "
            f"cellEditEnded / dblclick 핸들러 등록)", "", "구현"),
    "E04-1": (f"{P}/components/EtcSalesReportsGrid.tsx:302~330 (cellEditEnded — 수치셀 빈값 '0' 강제 + "
              f"cascade clear) + {P}/utils/etc-sales-reports.gridCombos.ts:56~ "
              f"(resolveDeptIdRows 2분기 · cascadeClearColumns 매트릭스) "
              f"⭐ 2026-08-10 이관 — DEPT_ID 부모키 필터가 소실돼 있던 것을 AS-IS L1268/L1294 1:1 복원",
              "", "구현"),
    "E04-2": (f"{P}/components/EtcSalesReportsGrid.tsx:335~343 (dblclick → onProjectCellDblClick) + "
              f"{P}/EtcSalesReports.tsx:375 (PROJECT 모달 오픈)", "", "구현"),
    "E04-3": ("", "AS-IS `spdMain_CellClick`(L1578~1605)은 CUST_REPORT 셀 콤보 재바인딩 전용이고, "
                  "그 콤보(`DMF0005_REPORT_GROUP2`)는 **무파라미터**라 화면 진입 시 1회 프리페치와 등가다"
                  "(콤보 호출지점 대사 PASS 사유와 동일). 별도 클릭 핸들러 불요", "제외"),
    # ── §5 버튼 ─────────────────────────────────────────────────────────────
    "E05": (f"{P}/EtcSalesReports.tsx:289~330 (hotkeyConfig — 공통버튼 10종 배선)", "", "구현"),
    "E05-1": (f"{P}/EtcSalesReports.tsx:289~330 (hotkeyConfig) — SEARCH/INSERT/DELETE/SAVE/EXCEL/"
              f"FILTER/SORT/COLUMN_SETUP 은 공통버튼 계약으로 처리", "", "구현"),
    "E05-2": (f"{P}/EtcSalesReports.tsx:305 (COLUMN_SETUP) · :311~316 (MEASURE_SELECT) · "
              f":343 (SP_VER → VersionModal) + {P}/components/EtcSalesReportsForm.tsx:114 (btnSPVer '...')",
              "", "구현"),
    "E05-3": (f"{P}/utils/etc-sales-reports.validate.ts:9~16 (MSG00283 조회 / MSG00688 저장·팝업 / "
              f"MSG00096 편집권한) + {P}/utils/etc-sales-reports.save.ts:126~129 (MSG00429 Department 필수)",
              "", "구현"),
    # ── §6 팝업 ─────────────────────────────────────────────────────────────
    "E06": (f"{P}/components/EtcSalesReportsModals.tsx:30~ (모달 4종 라우팅)", "", "구현"),
    "E06-1": (f"features/demand/src/components/versionModal/VersionModal.tsx (공용 — DMF0044 와 1본 공유) "
              f"← {P}/components/EtcSalesReportsModals.tsx:171", "", "구현"),
    "E06-2": (f"{P}/components/modals/MeasureSelectModal.tsx ← "
              f"{P}/components/EtcSalesReportsModals.tsx:152", "", "구현"),
    "E06-3": (f"공용 `ProjectByDivisionModal` ← {P}/components/EtcSalesReportsModals.tsx:83", "", "구현"),
    # ── 제약매트릭스 라인 축 ─────────────────────────────────────────────────
    "L121": (f"{P}/etc-sales-reports.types.ts (EtcSalesReportRow) + SHEET_COLUMNS 메타(FCST_TYPE, "
             f"DIVISION_ID='81*' 한정)", "", "구현"),
    "L344": (f"{P}/utils/etc-sales-reports.editLock.ts:22~23 (isEditBlockedGroup) + "
             f"{P}/utils/etc-sales-reports.validate.ts:15~16 (MSG00096)", "", "구현"),
    "L362": ("", "AS-IS 원문에서 **주석 처리된 코드**(`//LockColumn(0, MEASURE, true)`) — 실행되지 않는다. "
                 "이식 대상 아님", "제외"),
    "L528": (f"{P}/utils/etc-sales-reports.validate.ts:9~10 (validateFind → MSG00283)", "", "구현"),
    "L633": (f"{P}/utils/etc-sales-reports.validate.ts:12~13 (validateVersionForAction) — "
             f"MSG ID 는 AS-IS 00281 → TO-BE **MSG00688** 로 재매핑(hook #114 — 00281 원문 부재로 신설)",
             "", "구현"),
    "L638": (f"{P}/EtcSalesReports.tsx:203~ (handleSave 진입 게이트) — TO-BE 는 AS-IS `IsLock` 대신 "
             f"편집 판정 엔진(evalEtcReportCell)이 셀 단위로 잠그므로 '변경분 0건'이 동일 역할", "", "구현"),
    "L734": (f"{P}/etc-sales-reports.constants.ts (measureCntOf) + "
             f"{P}/utils/etc-sales-reports.save.ts:131 (cnt = measureCntOf(divisionId)) — "
             f"AS-IS 주석의 조건 치환 이력까지 반영(40=2 / 비40=3)", "", "구현"),
    "L748": (f"{P}/utils/etc-sales-reports.save.ts:126~129 (Department 공백 → MSG00429) — "
             f"AS-IS MSG00002 {{0}} 용법을 TO-BE 필수입력 메시지로 재매핑", "", "구현"),
    "L874": (f"{P}/utils/etc-sales-reports.save.ts (EtcReportSaveRow.fcstType) — "
             f"⚠ SP 파라미터 순서는 분석서가 아니라 `ALL_ARGUMENTS` POSITION 실측을 따랐다"
             f"(PROC_M 37행 = 36 IN + result)", "", "구현"),
    "L899": (f"{P}/EtcSalesReports.tsx:203~ (handleSave — SP 반환 message 를 그대로 alert)", "", "구현"),
    "L928": (f"{P}/EtcSalesReports.tsx:168~172 (handleInsert 진입 게이트 — 편집 게이트 공유)", "", "구현"),
    # ── CRUD·모달 매트릭스 ───────────────────────────────────────────────────
    "CRUD:E02:SEARCH": (f"{P}/EtcSalesReports.tsx:142~155 · :83~90 (useTabProcQuery MAIN / SHEETS.MAIN SEARCH)",
                        "", "구현"),
    "CRUD:E03:SAVE": (f"{P}/EtcSalesReports.tsx:203~ + {P}/utils/etc-sales-reports.api.ts:81 "
                      f"(callSaveEtcReport → SHEETS.MAIN 'SAVE') + save.ts:111~ (36키 '^' bulk)",
                      "", "구현"),
    "MODAL:DMF0044_Sales_VersionPopUp": (
        "", "AS-IS dead 팝업 — 2026-07-22 사용자 확정으로 이관 제외(활성 경로는 "
            "`DMF0044_United_VersionPopup` = 공용 VersionModal, E06-1)", "제외"),
    "MODAL:EtcSalesReportsModals": (
        f"{P}/components/EtcSalesReportsModals.tsx (모달 4종 라우팅 — PROJECT/COLUMN/MEASURE/VERSION)",
        "", "구현"),
    "MODAL:MeasureSelectModal": (
        f"{P}/components/modals/MeasureSelectModal.tsx ← AS-IS §6.2 DM0002_TitleSetForm_Popup "
        f"(Measure Setting). CRUD = 표시/선택 전용(저장은 개인화 titleSet 경유)", "", "구현"),
    "MODAL:ShowDialog": (
        "", "AS-IS `ShowDialog` 는 팝업 호출 **공통 헬퍼**(WinForms API)이지 개별 팝업이 아니다 — "
            "TO-BE 대응 단위 없음(각 팝업은 E06-1~3 로 개별 대사)", "해당없음"),
}


def main():
    if not MD.is_file():
        sys.exit("[error] 대사표 부재: %s" % MD)
    text = MD.read_text(encoding="utf-8")
    filled, missed = 0, []
    for eid, (loc, why, state) in FILL.items():
        pat = re.compile(
            r"^(\| *%s *\| *)([^|]*)(\|)([^|]*)(\|)([^|]*)(\| *)([^|\n]*)(\|)\s*$"
            % re.escape(eid), re.M)
        m = pat.search(text)
        if not m:
            missed.append(eid)
            continue
        text = pat.sub(
            lambda mm: "%s%s| %s | %s | %s |" % (mm.group(1), mm.group(2), loc, why, state),
            text, count=1)
        filled += 1
    MD.write_text(text, encoding="utf-8")
    print("[fill] %d행 기입 / 미발견 %d" % (filled, len(missed)))
    for e in missed:
        print("  ⚠ 미발견 ID: %s" % e)
    return 1 if missed else 0


if __name__ == "__main__":
    sys.exit(main())
