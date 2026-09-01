# -*- coding: utf-8 -*-
"""DMF0053 대사표 전 행 채움 — 실측 라인 인용 (fill after --init/--handlers)"""
import io, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)

P = r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\cust-fcst-waterfall\__asis-mapping__.md"
MAIN = "CustFcstWaterfall.tsx"
FORM = "components/CustFcstWaterfallForm.tsx"
GRID = "components/CustFcstWaterfallGrid.tsx"
STORE = "useCustFcstWaterfallStore.ts"
API = "utils/cust-fcst-waterfall.api.ts"

IMPL = "구현"; EXCL = "제외"; NA = "해당없음"

ROWS = {
  # ── E 축 ──
  "E01": (f"{MAIN}:26~78 (store 초기화·division effect L72~77) + {STORE}:46~66 (기본값 Bucket=MONTHLY·기간 6/1개월)", "", IMPL),
  "E02": (f"{FORM}:75~92 (DivisionField onChange — cascade 클리어+텍스트 3칸) + {MAIN}:72~77 (#113 재fetch) + cascade-combo-filter §1.4 Grid 초기화=clearData 경로", "", IMPL),
  "E03": (f"{FORM}:93~98 (TeamField — endCustomers·salesSiteIds 클리어)", "", IMPL),
  "E04": (f"{FORM}:99~104 (EndCustomerField — salesSiteIds 클리어)", "", IMPL),
  "E05": ("", "제외 — AS-IS 미배선 사문 (Designer·InitEvent 에 += 없음 + 본문 SetClbVersion=no-op L1114~1121)", EXCL),
  "E06": ("", "제외 — 동일 사문 (E05)", EXCL),
  "E07": ("", "제외 — 동일 사문 (E05)", EXCL),
  "E08": ("", "제외 — 동일 사문 (E05)", EXCL),
  "E09": (f"{FORM}:136~149 (Bucket 콤보) + {GRID}:139~157 (bucket 가시성 재계산·드릴 리셋) — AS-IS 이중 배선은 1회로 정상화", "", IMPL),
  "E10": ("", "제외 — dead path (조회 후 전열 잠금 L786·Insert 미노출 — ACTION='I' 행이 존재할 수 없음)", EXCL),
  "E11": (f"{GRID}:296~330 (onDblClick — M_→W_ 토글·D_ 접기 / W_→D_ 토글)", "", IMPL),
  "E12": ("", "제외 — dead path (IsLock || ACTION!='I' 즉시 return L1213 — 읽기 전용 화면에서 도달 불가)", EXCL),
  "E13": (f"{GRID}:365~372 (DataGrid allowMerging=All — wijmo 기본 머지가 스크롤 재머지 담당)", "", IMPL),
  "E14": (f"{GRID}:365~372 (wijmo 기본 Copy) — Paste 는 제외(읽기 전용·WinForms 플랫폼 차이)", "", IMPL),
  "E15": (f"{FORM}:155~165 (ProjectField — master 공용 ProjectByDivisionModal·40 비활성)", "", IMPL),
  "E16": (f"{FORM}:166~175 (ItemField — master 공용 ItemByDivisionModal)", "", IMPL),
  "E17": (f"{MAIN}:180~217 (ColumnLayoutModal 'C' + applyColumnLayout + saveTitleSet('C') + clearData UC-03)", "", IMPL),
  "E18": (f"{MAIN}:219~233 (MeasureSelectModal + saveTitleSet('M') + clearData)", "", IMPL),
  "E19": (f"{FORM}:231~242 (Sum 체크 — ONLY_WEEKLY 비활성) + {GRID}:263~276 (요약 컬럼 가시성)", "", IMPL),
  "E20": ("", "제외 — AS-IS 미배선 사문 + 실적 회색 로직 전부 주석 (L811~903)", EXCL),
  "E21": ("", "제외 — Version 조회조건 미구현 (AS-IS btnVersion.Visible=false Designer L348 + #112 카탈로그 17행·Figma 프레임 모두 부재 → versionNo='' 고정 " + STORE + ":118)", EXCL),
  "E22": ("", "제외 — E21 과 동일 사유 (숨겨진 팝업의 유일한 진입로)", EXCL),
  "E23": (f"{FORM}:204~213 (OwnerField — master 공용 OwnerByDivisionModal) + {GRID}:88~103 (cboQTY→QTY 표시 사본 divisor E23+)", "", IMPL),
  # ── A 축 ──
  "A-01": (f"{MAIN}:83~87 (MSG00097 차단)", "", IMPL),
  "A-02": (f"{MAIN}:98~102 (MSG00108 차단)", "", IMPL),
  "A-03": (f"{MAIN}:104~109 (MSG00164 알림 + endYyyymmdd=from+3년 보정 후 중단 — PERIOD_LIMIT_YEARS=3 cust-fcst-waterfall.constants.ts:27)", "", IMPL),
  "A-04": (f"{MAIN}:111~115 (MSG00108 차단)", "", IMPL),
  "A-05": (f"{MAIN}:117~122 (MSG00164 + toCreateYyyymmdd 보정)", "", IMPL),
  "A-06": ("", "해당없음 — 편집 진입점 자체 미노출 (hotkeyConfig insert/delete/save=false " + MAIN + ":130~137) — MSG00109 도달 경로 없음", NA),
  # ── B/C/D 축 ──
  "B-01": (f"{FORM}:41~42 (isProjectEnabled = startsWith('81') || ==='82') + master 공용 필드 division cascade", "", IMPL),
  "B-02": (f"{MAIN}:83~87 (A-01 과 동일 지점)", "", IMPL),
  "B-09": ("", "제외 — dead path (E10 과 동일 — 전열 잠금·편집 셀 없음)", EXCL),
  "B-10": ("", "제외 — dead code (SaveData 주석·저장 경로 없음 — fnValidation 소비처 부재)", EXCL),
  "C-01": ("", "제외 — 소비처(실적 회색 L811~903)가 전부 주석 = dead code", EXCL),
  "C-02": (f"{GRID}:90~103 (divisor===1 이면 원본 반환 — AS-IS SelectedIndex 0 복원 파리티)", "", IMPL),
  "D-01": ("", "제외 — Version 조회조건 미구현 (E21/E22 와 동일 사유)", EXCL),
  # ── CRUD/MODAL ──
  "CRUD:E15:SEARCH": (f"{FORM}:155~165 (ProjectField 열기→선택 반영 — R 전용)", "", IMPL),
  "CRUD:E16:SEARCH": (f"{FORM}:166~175 (ItemField 열기→선택 반영 — R 전용)", "", IMPL),
  "MODAL:ColumnLayoutModal": (f"{MAIN}:180~217 — 공용 정본 (@shared/components) 사용·columnType='C'·sheetName='CUST Fcst Waterfall'·onSave=titleSet 'C'+UC-03. 4영역=공용 모달 소관(#132 사본 금지)", "", IMPL),
  "MODAL:MeasureSelectModal": (f"{MAIN}:219~233 — master 공용 정본·staticMeasures(SHEET_MEASURE 기시딩 2행)·onApply=titleSet 'M'+UC-03", "", IMPL),
  "MODAL:ProjectByDivisionModal": (f"{FORM}:155~165 — master 공용 정본 (AS-IS SCM0002_ProjectbyDivisionPopupEx L1286 대응·division/team/endCustomer/scmSite/project 전달)", "", IMPL),
  "MODAL:ItemByDivisionModal": (f"{FORM}:166~175 — master 공용 정본 (AS-IS DM0002_ItembyDivisionPopupEx L1311 대응)", "", IMPL),
  "MODAL:OwnerByDivisionModal": (f"{FORM}:204~213 — master 공용 정본 (AS-IS DM0020_OwnerbyDivisionPopup L1713 대응)", "", IMPL),
  # ── UC 축 (DMF0040 판정 계보) ──
  "COMMON:UC-01": ("", "해당없음 — Insert 기능 없음 (읽기 전용 화면, AS-IS InsertButton 주석 L577~580)", NA),
  "COMMON:UC-02": ("", "해당없음 — 편집 기능 없음 (수정 중 상태가 존재하지 않음)", NA),
  "COMMON:UC-03": (f"{MAIN}:212~216·231 (ColumnLayoutModal onSave·MeasureSelectModal onApply → clearData() = filters 리셋·그리드 비움, hook #132 §2-2)", "", IMPL),
  "COMMON:UC-04": ("", "해당없음 — CRUD 저장 없음 (titleSet 개인화 저장은 공용 모달 경로)", NA),
  "COMMON:UC-05": (f"{MAIN}:171 (SubTitle excelFileName='CustFcstWaterfall' — gridAction dataMap 승계. 본 화면 정적 컬럼은 콤보 셀 없음·코드 그대로가 원장 값)", "", IMPL),
  "COMMON:UC-06": (f"{FORM}:155~213 (ProjectField/ItemField/OwnerField — master 공용 필드 콤마 다중 입력, join(',') 전달 {STORE}:106~115)", "", IMPL),
  "COMMON:UC-07": (f"{GRID}:365~372 (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장, 화면 배선 불요)", "", IMPL),
}

# HANDLER 축 — E 축 참조 + 사문 제외
H = {
  "Form_Load": (f"{MAIN}:26~78 (E01)", "", IMPL),
  "FindButton": (f"{MAIN}:80·130 (hotkeyConfig.search=handleSubmit — F5)", "", IMPL),
  "FindData": (f"{MAIN}:80~127 (handleSubmit — A-01~A-05 + setFilters)", "", IMPL),
  "InsertButton": ("", "제외 — 사문(빈 몸통·주석) — hotkeyConfig insert=false 로 미노출이 파리티", EXCL),
  "DeleteButton": ("", "제외 — 사문(빈 몸통·주석) — delete=false", EXCL),
  "SaveButton": ("", "제외 — 사문(빈 몸통·주석) — save=false", EXCL),
  "EditButton": ("", "해당없음 — 편집 진입점 미노출 (A-06 동일 — MSG00109 도달 경로 없음)", NA),
  "ExcelButton": (f"{MAIN}:164~178 (SubTitle Excel Download — UC-05)", "", IMPL),
  "cboDivision_SelectedIndexChanged": (f"{FORM}:75~92 (E02)", "", IMPL),
  "clbTeam_SelectedIndexChanged": (f"{FORM}:93~98 (E03)", "", IMPL),
  "clbCustomer_SelectedIndexChanged": (f"{FORM}:99~104 (E04)", "", IMPL),
  "ClbSalesSite_SelectedIndexChanged": ("", "제외 — 사문(미배선 + SetClbVersion no-op) — E05", EXCL),
  "ClbPlantSite_SelectedIndexChanged": ("", "제외 — 사문 — E06", EXCL),
  "TxtProject_Changed": ("", "제외 — 사문 — E07", EXCL),
  "TxtItemId_Enter": ("", "제외 — 사문 — E08", EXCL),
  "cboBucketType_SelectedIndexChanged": (f"{FORM}:136~149 + {GRID}:139~157 (E09)", "", IMPL),
  "spdMain_ComboSelChange": ("", "제외 — dead path (E10)", EXCL),
  "spdMain_CellDoubleClick": (f"{GRID}:296~330 (헤더 드릴다운 E11 — 셀 팝업 축은 dead path E12 제외)", "", IMPL),
  "spdMain_TopChange": (f"{GRID}:365~372 (wijmo 기본 머지 — E13)", "", IMPL),
  "spdMain_KeyUp": (f"{GRID}:365~372 (wijmo 기본 Copy — E14·Paste 제외)", "", IMPL),
  "btnProject_Click": (f"{FORM}:155~165 (E15)", "", IMPL),
  "btnItemId_Click": (f"{FORM}:166~175 (E16)", "", IMPL),
  "btnColumn_Click": (f"{MAIN}:180~217 (E17)", "", IMPL),
  "btnMeasure_Click": (f"{MAIN}:219~233 (E18)", "", IMPL),
  "chkSum_CheckedChanged": (f"{FORM}:231~242 (E19)", "", IMPL),
  "chkColor_CheckedChanged": ("", "제외 — 사문(미배선·회색 로직 주석) — E20", EXCL),
  "btnVersion_Click": ("", "제외 — Version 미구현 (E21)", EXCL),
  "txtVersion_KeyDown": ("", "제외 — Version 미구현 (E22)", EXCL),
  "btnOwner_Click": (f"{FORM}:204~213 (E23)", "", IMPL),
  "cboQTY_SelectedIndexChanged": (f"{GRID}:88~103 (QTY 표시 사본 divisor — E23+·C-02)", "", IMPL),
}
for k, v in H.items():
    ROWS[f"HANDLER:{k}"] = v

s = io.open(P, encoding="utf-8").read()
lines = s.split("\n")
filled, missed = 0, []
for i, line in enumerate(lines):
    m = re.match(r"^\| ([A-Za-z0-9:_\-]+) \| (.*?) \|  \|  \| 미구현 \|$", line)
    if not m:
        continue
    rid, desc = m.group(1), m.group(2)
    if rid not in ROWS:
        missed.append(rid)
        continue
    loc, reason, status = ROWS[rid]
    lines[i] = f"| {rid} | {desc} | {loc} | {reason} | {status} |"
    filled += 1
io.open(P, "w", encoding="utf-8").write("\n".join(lines))
print(f"채움 {filled}행 / 미매칭 {missed}")
