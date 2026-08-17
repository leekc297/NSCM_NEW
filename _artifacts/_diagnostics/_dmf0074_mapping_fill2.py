#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0074 대사표 — 도구 생성 축(E/CRUD/MODAL/COMMON/HANDLER) 기입.

세부 축(IT/BT/CT/PU/VA/ED/GP/EV)은 _dmf0074_mapping_fill.py 가 이미 채웠고,
여기서는 §헤더 단위 E행·CRUD·MODAL·UI공통·핸들러 인벤토리의 빈 3열(구현위치/사유/상태)을 채운다.
전부 FE/SP/메타 실측 근거. UI 공통 7항목은 2026-08-18 실측 판정(UC-07 은 보완 후 '구현').
"""
import io
import pathlib
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
MAP = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\metal-link-price"
                   r"\__asis-mapping__.md")
P = "features/demand/src/pages/metal-link-price"

# id -> (구현위치, 사유, 상태)
FILL = {
    # ── § 헤더 축 (원자 항목은 IT/BT/CT/PU/VA/ED/GP 축이 1:1 보유) ──
    "E01": (f"IT-01~IT-21 (이벤트·액션 21 원자 축) — {P}/ 전반", "", "구현"),
    "E02": ("ED-01~ED-07 (편집제어·저장구조 축)", "", "구현"),
    "E02-1": ("ED-01~ED-06 — 그리드 전셀 읽기전용 + SP INNER JOIN 하드필터 + EDIT_YN", "", "구현"),
    "E02-2": (f"ED-07 — {P}/MetalLinkPrice.tsx:285~320 (Excel Upload 2-Step 단일 저장경로)", "", "구현"),
    "E02-3": ("PKG_DMF0074 GET SP 버전 분기 — versionType 'Current' vs 버전NO (store:92 전달)",
              "", "구현"),
    "E03": ("BT-01~BT-08 + CT-01~CT-09 (버튼·컨트롤 인벤토리 축)", "", "구현"),
    "E03-1": ("BT-01~BT-08", "", "구현"),
    "E03-2": ("CT-01~CT-09", "", "구현"),
    "E04": ("PU-01~PU-05 (팝업 흐름 축)", "", "구현"),
    "E05": ("VA-01~VA-10 + XP-00", "", "구현"),
    "E05-1": ("VA-01~VA-10 (MSG_M 실측 대사 완료 — MSG00002→00614 / 00049 도달불가 / 00427→00656)",
              "", "구현"),
    "E05-2": ("XP-00 — Expression 0건", "AS-IS expressions.md 대조 0건 (조회전용 화면)", "해당없음"),
    "E06": ("사용자 관점 요지 — UI분석서 v1.0 시트5 반영분", "분석 문서 서술 절(구현 대상 아님)", "해당없음"),
    "E06-1": ("§6.1 화면 성격 — 조회전용 + 엑셀 업로드 단일 수정경로", "동상", "해당없음"),
    "E06-2": ("§6.2 조회 서술 — CT/VA 축이 구현 근거 보유", "동상", "해당없음"),
    "E06-3": ("§6.3 템플릿·업로드 서술 — PU-04/PU-05 가 구현 근거 보유", "동상", "해당없음"),
    "E07": ("GP-01~GP-09 (격차 축 — 2026-08-18 현재 상태로 갱신)", "", "구현"),
    # ── CRUD 매트릭스 ──
    "CRUD:E02:SAVE": (f"{P}/MetalLinkPrice.tsx:285~320 (FcstUploadModal onSave → P_MODE=1)",
                      "그리드 직접 SAVE 경로 없음 — 저장은 Excel Upload 2단계가 유일(AS-IS 파리티). "
                      "2026-08-16 원장 적재 왕복 실측 PASS", "구현"),
    # ── 모달 축 ──
    "MODAL:ProjectByDivisionModal": ("PU-01 — @master/components ProjectByDivisionModal 재사용", "", "구현"),
    "MODAL:ItemByDivisionModal": ("PU-02 — @master/components ItemByDivisionModal 재사용", "", "구현"),
    "MODAL:MetalLinkVersionModal": (f"PU-03 — {P}/components/modals/MetalLinkVersionModal.tsx",
                                    "AS-IS DMF0073_VersionBySalesPricePopup 대응 (분석 md §4-C 근거 존재)",
                                    "구현"),
    "MODAL:MetalLinkTemplateModal": (f"PU-04 — {P}/components/modals/MetalLinkTemplateModal.tsx", "", "구현"),
    "MODAL:ShowDialog": ("—", "AS-IS 코드의 `ShowDialog()` 호출문(WinForms 모달 표시 API)이 팝업명으로 "
                         "오추출된 행 — 개별 팝업은 PU-01~PU-05 가 보유", "해당없음"),
    # ── UI 공통 7 (2026-08-18 실측 판정) ──
    "COMMON:UC-01": ("—", "이 화면은 신규행 Insert 기능이 없다(AS-IS InsertButton 빈 override → "
                     "hotkeyConfig.insert=false). 필터×신규행 상호작용 자체가 성립하지 않음", "해당없음"),
    "COMMON:UC-02": ("—", "그리드 편집 경로가 없어(전 셀 읽기전용) '수정 중 데이터'가 존재하지 않는다 — "
                     "MSG00703 confirm 대상 아님", "해당없음"),
    "COMMON:UC-03": ("—", "Column/Measure 설정 모달 미보유 화면(그리드는 admin SHEET_COLUMNS 고정 PIVOT). "
                     "AS-IS 에도 컬럼 설정 UI 없음", "해당없음"),
    "COMMON:UC-04": ("components/fcst-upload-modal/FcstUploadModal.tsx:165~175,247 (Toast — "
                     "검증완료 MSG00659 / 저장완료 MSG00606·MSG00265)",
                     "업로드가 이 화면의 유일한 CRUD — 완료 알림은 공용 모달 Toast 가 담당(Alert 아님)",
                     "구현"),
    "COMMON:UC-05": ("—", "그리드에 콤보(dataMap) 셀이 없다 — 전 컬럼 SEARCH_ONLY 텍스트("
                     "Grid:111,137). Code→Name 변환 대상 컬럼 부재", "해당없음"),
    "COMMON:UC-06": (f"{P}/useMetalLinkPriceStore.ts:88~89 (projectCode/itemId raw 전달) + "
                     "PKG_DMF0074 GET 토큰 분해(B1/B2 서브쿼리 LIKE)",
                     "Key-in 조회조건 = Project·Model 2종. AS-IS raw 전달 계약 유지", "구현"),
    "COMMON:UC-07": (f"{P}/components/MetalLinkPriceGrid.tsx:6 import + :263~268 "
                     "rebindFilterColumns (정본 DMF0042 BusinessPlanGrid.tsx:715 동형)",
                     "⭐ 2026-08-18 보완 — 미적용 상태였음. 조회마다 DataGrid key 재마운트 + 메탈 42 "
                     "dynamicColumns 재생성이라 끊긴 Column 참조 재바인딩 필요", "구현"),
}

# ── 핸들러 인벤토리 (18) ──
H = {
    "Form_Load": ("IT-02", ""),
    "FindButton": ("IT-11", "AS-IS 는 FindData() 호출 3행 래퍼 — 실체는 FindData(IT-11)"),
    "FindData": ("IT-11", ""),
    "ExcelButton": ("IT-13", ""),
    "InsertButton": ("IT-12", "AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티"),
    "DeleteButton": ("IT-12", "AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티"),
    "EditButton": ("IT-12", "AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티"),
    "SaveButton": ("IT-12", "AS-IS 빈 몸통(사문) — 버튼 미노출이 파리티"),
    "btnProject_Click": ("IT-14", ""),
    "btmItem_Click": ("IT-15", ""),
    "btnSPVer_Click": ("IT-16", ""),
    "btnTemplate_Click": ("IT-17", ""),
    "btnExcelUpload_Click": ("IT-18", ""),
    "clbDivisions_SelectedIndexChanged": ("IT-06", ""),
    "clbTeam_SelectedIndexChanged": ("IT-07", ""),
    "clbEndCustomer_SelectedIndexChanged": ("IT-08", ""),
    "txtProject_KeyDown": ("IT-09", "Enter→팝업은 미이식(SearchArea Enter=조회와 충돌) — 검색 아이콘 "
                                    "버튼으로 대체. 보완목록 R-1"),
    "txtItemId_KeyDown": ("IT-10", "IT-09 동일 사유. 보완목록 R-1"),
}
DEAD = {"InsertButton", "DeleteButton", "EditButton", "SaveButton", "FindButton"}
for name, (ref, why) in H.items():
    st = "제외" if name in ("txtProject_KeyDown", "txtItemId_KeyDown") else "구현"
    loc = f"{ref} 참조" if st == "구현" else "—"
    FILL[f"HANDLER:{name}"] = (loc, why, st)

text = MAP.read_text(encoding="utf-8")
lines = text.splitlines()
done = 0
for i, ln in enumerate(lines):
    m = re.match(r"^\|\s*([^|]+?)\s*\|(.*)\|\s*미구현\s*\|\s*$", ln)
    if not m:
        continue
    _id = m.group(1).strip()
    if _id not in FILL:
        continue
    cells = [c.strip() for c in ln.strip().strip("|").split("|")]
    gist = cells[1]
    loc, why, st = FILL[_id]
    lines[i] = f"| {_id} | {gist} | {loc} | {why} | {st} |"
    done += 1

MAP.write_text("\n".join(lines) + "\n", encoding="utf-8")
left = [re.match(r"^\|\s*([^|]+?)\s*\|", l).group(1).strip()
        for l in lines if re.match(r"^\|.*\|\s*미구현\s*\|\s*$", l)]
print(f"기입 {done}행 / 잔여 미구현 {len(left)}행 = {left}")
