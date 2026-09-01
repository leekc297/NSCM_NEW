# -*- coding: utf-8 -*-
"""DMF0040 대사표 전 행 채움 — EID/제약/UC/HANDLER (빈 칸 0)"""
import io, sys, pathlib, re
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)

P = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt-fcst-comparison\__asis-mapping__.md")
t = P.read_text(encoding="utf-8")

PG = "MktFcstComparison.tsx"
FM = "components/MktFcstComparisonForm.tsx"
GR = "components/MktFcstComparisonGrid.tsx"
MD = "components/ComparisonVersionModal.tsx"
ST = "useMktFcstComparisonStore.ts"

FILL = {
    # ── EID ──
    "E01": (f"{PG}:60~66 (mount fetch)·{FM}:57~69 (콤보 적재)·{ST}:33~57 (기본값 — Bucket MONTHLY·기간 당월~+6개월)", "", "구현"),
    "E02": (f"{FM}:118~137 (DivisionField cascade 클리어)·{PG}:60~66 (staticColumns/Measures 재fetch)·{ST}:setFilters (spreadTitle division)", "", "구현"),
    "E02-1": ("", "해당없음 — AS-IS 프레임워크 속도 로그(FP_Log2). TO-BE 는 BE QueryLogInterceptor 가 대체", "해당없음"),
    "E02-2": (f"{ST}:107~113 (spreadTitle filters — division 파라미터)·{GR}:dynColMetas (조회 시 재구성)", "", "구현"),
    "E02-3": (f"{FM}:118~137 (cascade)·{FM}:isDivision40 → ProjectField/PlantSiteField disabled (D-04)", "", "구현"),
    "E02-4": (f"{FM}:126~134 (projectCodes/itemIds/owners/version 클리어)", "", "구현"),
    "E02-5": (f"{FM}:72~103 (defaultVersionQuery — MF_W 'Current' 제외 상위 2 자동 세팅. E08 사문 부분은 제외)", "", "구현"),
    "E03": (f"{FM}:139~144 (TeamField onChange — endCustomers/salesSiteIds 클리어, 파라미터 분기는 master 공용 필드)", "", "구현"),
    "E04": (f"{FM}:146~151 (EndCustomerField onChange — salesSiteIds 클리어)", "", "구현"),
    "E05": ("", "제외 — E05~E08 은 SetClbVersion 사문(no-op) 호출뿐 (주요이벤트 md §G)", "제외"),
    "E08": ("", "제외 — 사문 메서드 (로컬 변수만 읽고 종료, 구 로직 제거 잔재)", "제외"),
    "E09": (f"{GR}:bucketPrefix/applyDynVisibility (D_/W_/M_ 가시성)·{FM}:106~110 (ONLY_WEEKLY Sum 해제). EditButton 2회 분기는 사문 제외", "", "구현"),
    "E10": ("", "제외 — Insert 행 전제 사문 (읽기 전용 화면 — 편집 진입 불가)", "제외"),
    "E11": (f"{GR}:onDblClick (M_→W_ 토글·D_ 접기 / W_→D_ 토글). 셀 더블클릭 분기(Insert 전제)는 사문 제외", "", "구현"),
    "E12": (f"{GR}:ComparisonHeaderMergeManager + allowMerging=All (wijmo 가 스크롤 시 병합 유지 — SmartColMerge 대응)", "", "구현"),
    "E13": (f"공용 DataGrid — wijmo 기본 클립보드 복사 (읽기 전용이라 붙여넣기 무효 = AS-IS 전열 잠금 파리티)", "", "구현"),
    "E14": (f"{FM}:ProjectField (master 공용 검색 모달 — AS-IS DMF000_ProjectbyDivisionPopupEx 대응)", "", "구현"),
    "E15": (f"{FM}:ItemField (master 공용 — AS-IS DM0002_ItembyDivisionPopupEx 대응)", "", "구현"),
    "E16": (f"{PG}:customButtons Column Setting + ColumnLayoutModal (PROGRAM_ID=DMF0040·titleSet 'C'·저장 시 clearData=UC-03)", "", "구현"),
    "E17": (f"{PG}:customButtons Measure + MeasureSelectModal (master 정본 — TO-BE 는 PROGRAM_ID=DMF0040 독립 축, SHEET_MEASURE 49행 시딩 seed_meta.py)", "", "구현"),
    "E18": (f"{GR}:summaryBindings × searchParams.isSumChecked (applyDynVisibility)", "", "구현"),
    "E19": (f"{FM}:Version InputField(클릭/키=모달) + {MD} (최대 2·기간 반영 onApply)", "", "구현"),
    "E20": (f"{FM}:onKeyDown={{() => setOpenVersionModal(true)}} (AS-IS 키 입력=팝업 1:1)", "", "구현"),
    "E21": (f"{FM}:OwnerField (master 공용 — AS-IS DM0020_OwnerbyDivisionPopup 대응)", "", "구현"),
    "E22": (f"{GR}:gridRows (QTY divisor ÷1/1e3/1e6/1e8 표시 사본 — Round 2·0 skip·원본 보존) + E22-b 는 {FM}:defaultVersionQuery", "", "구현"),
    # ── 제약 ──
    "A-01": (f"{PG}:handleSubmit (MSG00097 — division 빈값 차단)", "", "구현"),
    "A-02": (f"{PG}:handleSubmit (MSG00108 — from>to 차단)", "", "구현"),
    "A-03": (f"{PG}:handleSubmit (MSG00164 + 종료일=시작일+2년 자동 보정 — 보정까지 파리티. 문구 3년 vs 로직 2년은 제약매트릭스 A-03 비고)", "", "구현"),
    "D-01": (f"{FM}: master 필드가 division 빈값 시 빈 목록 (공용 필드 내장 가드)", "", "구현"),
    "D-02": (f"{FM}:EndCustomerField division/deptId 파라미터 (81계열·82/40 분기 = 공용 CMBO 서버측)", "", "구현"),
    "D-03": (f"{PG}:handleSubmit V1 (A-01 동일 지점)", "", "구현"),
    "D-04": (f"{FM}:isDivision40 → ProjectField/PlantSiteField disabled", "", "구현"),
    "D-05": (f"{FM}: master 필드 division 가드 (D-01 동일)", "", "구현"),
    "D-06": (f"{FM}:TeamField→Customer/SalesSite 재적재 (deptId/endCustomer 파라미터 — 공용 필드)", "", "구현"),
    "D-07": (f"{FM}: master 필드 division 가드", "", "구현"),
    "D-08": (f"{FM}:SalesSiteField comboId='UserSiteByEndCustomer' + endCustomer/deptId 파라미터", "", "구현"),
    "D-09": ("", "제외 — Insert 행 전제 사문 (읽기 전용)", "제외"),
    "D-10": ("", "제외 — Insert 행 전제 사문 (fnValidation 9키 중복 검사 — 저장 경로 없음)", "제외"),
    "G-01": (f"{FM}:Version InputField readOnly + onClick/onKeyDown=모달 (직접 타이핑 차단 1:1)", "", "구현"),
    "G-02": (f"{GR}:thisWeekMondayYmd (Current 실적 경계 월요일 역산)", "", "구현"),
    "G-03": (f"{GR}:lastWeekSundayYmd (Cutoff 버전 전주 일요일 역산)", "", "구현"),
    "G-04": (f"{GR}:gridRows divisor===1 이면 원본 반환 (QTY index 0 가드 1:1)", "", "구현"),
    "P-01": ("", "해당없음 — 편집 진입점 자체 미노출 (hotkeyConfig insert/delete/save=false — MSG00109 표시 상황 부재)", "해당없음"),
    "P-02": (f"{MD}:handleApply (VERSION_MAX_SELECT=2 초과 시 MSG00255 — AS-IS 반환부 검사를 모달 내부로 통합)", "", "구현"),
    "P-03": (f"{MD}:handleApply (동일 지점 — AS-IS 팝업 SetItem 차단 1:1)", "", "구현"),
    # ── UC ──
    "COMMON:UC-01": ("", "해당없음 — Insert 기능 없음 (읽기 전용 화면, AS-IS InsertButton 빈 구현)", "해당없음"),
    "COMMON:UC-02": ("", "해당없음 — 편집 기능 없음 (수정 중 상태가 존재하지 않음)", "해당없음"),
    "COMMON:UC-03": (f"{PG}:ColumnLayoutModal onSave·MeasureSelectModal onApply → clearData() (filters 리셋 = 그리드 비움, hook #132 §2-2)", "", "구현"),
    "COMMON:UC-04": ("", "해당없음 — CRUD 저장 없음 (titleSet 개인화 저장은 공용 모달 경로)", "해당없음"),
    "COMMON:UC-05": (f"공용 SubTitle Excel Download (gridAction dataMap 승계 — 본 화면 정적 컬럼은 콤보 셀 없음·코드 그대로가 원장 값)", "", "구현"),
    "COMMON:UC-06": (f"{FM}:ProjectField/ItemField/OwnerField — master 공용 필드의 콤마 다중 입력 지원 (join(',') 전달 {ST}:setFilters)", "", "구현"),
    "COMMON:UC-07": ("공용 DataGrid 내장 (DataGrid.tsx:850~852 rebindFilterColumns — 재조회 시 필터-컬럼 재연결)", "", "구현"),
}

# HANDLER 축 — E 매핑 참조/사문 제외
HANDLERS = {
    "ClbPlantSite_SelectedIndexChanged": ("", "제외 — 사문 (SetClbVersion no-op 호출뿐, E05 판정)", "제외"),
    "ClbSalesSite_SelectedIndexChanged": ("", "제외 — 사문 (동일)", "제외"),
    "DeleteButton": ("", "제외 — 빈 몸통 (읽기 전용) — hotkeyConfig delete:false 로 미노출이 파리티", "제외"),
    "EditButton": ("", "해당없음 — 읽기전용 통보(MSG00109)뿐. TO-BE 는 편집 진입점 미노출 (P-01)", "해당없음"),
    "ExcelButton": ("공용 SubTitle Excel Download (excelFileName='MktFcstComparison' — HideZero·수치 포맷은 공용 옵션)", "", "구현"),
    "FindButton": (f"{PG}:hotkeyConfig.search=handleSubmit", "", "구현"),
    "FindData": (f"{PG}:handleSubmit + {ST}:setFilters + {GR} (회색/파랑/footer)", "", "구현"),
    "Form_Load": (f"{PG}:60~66 + {FM}:57~69 + {ST}: 기본값 (E01)", "", "구현"),
    "InsertButton": ("", "제외 — 빈 몸통. insert:false 미노출", "제외"),
    "SaveButton": ("", "제외 — 빈 몸통. save:false 미노출", "제외"),
    "TxtItemId_Enter": ("", "제외 — 사문 (SetClbVersion no-op)", "제외"),
    "TxtProject_Changed": ("", "제외 — 사문 (동일)", "제외"),
    "btnColumn_Click": (f"{PG}:ColumnLayoutModal (E16)", "", "구현"),
    "btnItemId_Click": (f"{FM}:ItemField (E15)", "", "구현"),
    "btnMeasure_Click": (f"{PG}:MeasureSelectModal (E17)", "", "구현"),
    "btnOwner_Click": (f"{FM}:OwnerField (E21)", "", "구현"),
    "btnProject_Click": (f"{FM}:ProjectField (E14)", "", "구현"),
    "btnVersion_Click": (f"{FM}:Version 버튼 + {MD} (E19)", "", "구현"),
    "cboBucketType_SelectedIndexChanged": (f"{GR}:applyDynVisibility + {FM}:ONLY_WEEKLY Sum 해제 (E09)", "", "구현"),
    "cboDivision_SelectedIndexChanged": (f"{FM}:DivisionField onChange (E02)", "", "구현"),
    "cboQTY_SelectedIndexChanged": (f"{GR}:gridRows divisor (E22)", "", "구현"),
    "chkSum_CheckedChanged": (f"{GR}:summaryBindings 가시성 (E18)", "", "구현"),
    "clbCustomer_SelectedIndexChanged": (f"{FM}:EndCustomerField (E04)", "", "구현"),
    "clbTeam_SelectedIndexChanged": (f"{FM}:TeamField (E03)", "", "구현"),
    "spdMain_CellDoubleClick": (f"{GR}:onDblClick 헤더 드릴다운 (E11 — 셀 분기는 사문)", "", "구현"),
    "spdMain_ComboSelChange": ("", "제외 — Insert 전제 사문 (E10)", "제외"),
    "spdMain_KeyUp": ("공용 DataGrid — wijmo 기본 클립보드 (E13)", "", "구현"),
    "spdMain_TopChange": (f"{GR}:MergeManager (E12 — wijmo 자동 유지)", "", "구현"),
    "txtVersion_KeyDown": (f"{FM}:Version onKeyDown=모달 (E20 — AS-IS 는 btnVersion_Click 위임)", "", "구현"),
}
for k, v in HANDLERS.items():
    FILL[f"HANDLER:{k}"] = v

lines = t.split("\n")
out = []
filled = 0
for line in lines:
    m = re.match(r"^\| (E[\d-]+|A-\d+|D-\d+|G-\d+|P-\d+|COMMON:UC-\d+|HANDLER:\S+) \| (.*?) \|  \|  \| 미구현 \|$", line)
    if m and m.group(1) in FILL:
        rid, summary = m.group(1), m.group(2)
        impl, reason, status = FILL[rid]
        out.append(f"| {rid} | {summary} | {impl} | {reason} | {status} |")
        filled += 1
    else:
        out.append(line)
P.write_text("\n".join(out), encoding="utf-8")
print("채움:", filled, "행 / 대상", len(FILL), flush=True)
remain = sum(1 for l in out if "| 미구현 |" in l)
print("잔여 미구현:", remain, flush=True)
