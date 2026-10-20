# -*- coding: utf-8 -*-
"""SCP0096 __asis-mapping__.md 갱신 — 2026-10-20 2차 보완. 행 추가·갱신만(M06 축소 금지). 라인 번호는 현재 소스에서 앵커로 산출."""
import io, re, os
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..')
P = os.path.join(ROOT, 'nscm-fe/features/supply/src/pages/shipment-working-day-osp/')
def lines(f): return io.open(os.path.join(P, f), encoding='utf-8').read().splitlines()
PG, HK, GR, CT = lines('ShipmentWorkingDayOsp.tsx'), lines('hooks/useShipmentWorkingDayOspInputValue.ts'), lines('components/ShipmentWorkingDayOspGrid.tsx'), lines('shipment-working-day-osp.constants.ts')
def ln(src, pat, start=0):
    for i in range(start, len(src)):
        if pat in src[i]: return i + 1
    raise SystemExit('anchor not found: ' + pat)
# Page anchors
pg_mount = ln(PG, 'clearFilters();') - 1; pg_mount_end = ln(PG, '}, [tabId]);')
pg_dr = ln(PG, 'const dayRangeFilters = useMemo'); pg_dr_end = ln(PG, '}, [dayRangeData, dayRangeApplied]);')
pg_q = ln(PG, 'const { data, isFetching } = useTabProcQuery'); pg_q_end = ln(PG, '});', pg_q)
pg_vf = ln(PG, 'const validateFind'); pg_vf_div = ln(PG, 'MSG.DIVISION_REQUIRED'); pg_vf_per = ln(PG, 'MSG.REQUIRED_VALUE'); pg_vf_inv = ln(PG, 'MSG.INVALID_PERIOD'); pg_vf_end = ln(PG, '  };', pg_vf)
pg_hs = ln(PG, 'const handleSearch'); pg_hs_end = ln(PG, '  };', pg_hs)
pg_rg = ln(PG, 'const resetGrid'); pg_rg_end = ln(PG, '  };', pg_rg)
pg_sv = ln(PG, 'const handleSave'); pg_wtd = ln(PG, 'WORKING_TIME_DEFAULT 제약'); pg_wtd_end = ln(PG, 'MSG.WTD_RANGE') + 7
pg_cur = ln(PG, 'type SaveResultRow'); pg_toast = ln(PG, 'MSG.SAVED_COUNT'); pg_sv_end = ln(PG, '  };', pg_toast)
pg_hk = ln(PG, 'const hotkeyConfig: HotkeyConfig'); pg_hk_end = ln(PG, '  };', pg_hk)
pg_iv = ln(PG, 'const handleInputValue = useShipmentWorkingDayOspInputValue'); pg_iv_end = ln(PG, '  });', pg_iv)
pg_st = ln(PG, '<SubTitle'); pg_st_end = ln(PG, '/>', pg_st); pg_gr = ln(PG, '<ShipmentWorkingDayOspGrid'); pg_ss = ln(PG, 'showSum={false}')
pg_ce = ln(PG, "const canEdit = hasButton('EDIT')"); pg_sumc = pg_ce + 1
# Hook anchors
hk_cb = ln(HK, 'return useCallback'); hk_ns = ln(HK, 'MSG.NOT_SEARCHED'); hk_ne = ln(HK, 'MSG.NOT_EDIT_MODE'); hk_rv = ln(HK, 'MSG.REQUIRED_VALUE')
hk_wc = ln(HK, 'const writeCell'); hk_wc_end = ln(HK, '    };', hk_wc); hk_sd = ln(HK, 'if (isSelectDay) {'); hk_nc = ln(HK, 'MSG.NO_CELL_SELECTED', hk_sd); hk_else = ln(HK, '} else {', hk_sd); hk_ed = ln(HK, 'if (!isEveryDay && dayCol.weekday !== targetWeekday) continue;'); hk_w0 = ln(HK, 'wrote === 0'); hk_end = ln(HK, '}, [hasSearched')
# Grid anchors
gr_et = ln(GR, 'const EDITABLE_INPUT_TYPES'); gr_et_end = ln(GR, ']);', gr_et); gr_mc = ln(GR, 'inputTpCd: col.inputTpCd'); gr_ms_tp = ln(GR, 'inputTpCd: c.inputTpCd'); gr_eb = ln(GR, 'const editableStaticBindings'); gr_eb_end = gr_eb + 3
gr_ie = ln(GR, 'const isEditableBinding'); gr_be = ln(GR, 'const beginningEditHandler'); gr_be_end = ln(GR, 'g.beginningEdit.addHandler')
gr_sg = ln(GR, 'const sumGroups'); gr_sv = ln(GR, 'visible: showSum'); gr_sg_end = ln(GR, 'return [...dayGroups, ...sumGroups];') + 1
gr_dyn = ln(GR, 'const dynamicColumns = useMemo'); gr_leaf_vis = ln(GR, 'visible: true,', gr_dyn)
gr_raf = ln(GR, '// 다단 헤더 총높이'); gr_raf_end = ln(GR, '}, [gridRef]);', gr_raf); gr_flt = ln(GR, '// F4 Filter'); gr_flt_end = ln(GR, '}, [visibleColumns, dynBindings, gridRef, gridFilterRef]);')
ct_msg = ln(CT, 'export const MSG'); ct_wtd = ln(CT, 'export const WTD_RANGE'); ct_sc = ln(CT, "SAVED_COUNT: 'MSG00672'"); ct_ns = ln(CT, "NOT_SEARCHED: 'MSG00662'"); ct_ne = ln(CT, "NOT_EDIT_MODE"); ct_nc = ln(CT, "NO_CELL_SELECTED: 'MSG01153'"); ct_wr = ln(CT, "WTD_RANGE: 'MSG01037'"); ct_wi = ln(CT, "WTD_INTEGER: 'MSG00460'")

m = os.path.join(P, '__asis-mapping__.md')
s = io.open(m, encoding='utf-8').read()
orig_rows = s.count('\n|')
def rep(row_id, new_row):
    global s
    pat = re.compile(r'^\| ' + re.escape(row_id) + r' \|.*$', re.M)
    assert pat.search(s), row_id
    s = pat.sub(lambda _m: new_row, s, count=1)
SUMREASON = "AS-IS Designer `this.chkSum.Visible = false`(:346) — 사용자에게 보이지 않는 컨트롤 + AS-IS MSSQL SP·사내 Oracle GET SP 모두 D_ 일자열만 PIVOT(W_/M_ SUM 열 미생성) = 살아있는 동작 없음(#138, feedback_asis_delta_apply_criteria). 2026-10-20 2차 보완(원장 S96-13): Sum 커스텀 버튼 제거, Grid SUM 처리 코드는 showSum=false 로 비활성 보존"
rep('D00-1-005', f"| D00-1-005 | §1 chkSum / UsrCheckBox | Page:{pg_sumc}-{pg_sumc+1}(주석)·{pg_ss} showSum={{false}} / Grid:{gr_sg}-{gr_sg_end}(SUM 열 코드 비활성 보존) | {SUMREASON} | 제외 |")
rep('D00-1-011', f"| D00-1-011 | §1 usrButton1 / UsrButton | Page:{pg_hk}-{pg_hk_end},{pg_st}-{pg_st_end} (hotkeyConfig + SubTitle 공통버튼 컨테이너 — SEARCH/SAVE · Insert/Delete false · customButtons 없음) | AS-IS 컨테이너 버튼그룹 → SubTitle 로 흡수 | 구현 |")
rep('D00-1-021', "| D00-1-021 | §1 layoutSum / LayoutControlItem | — | chkSum(D00-1-005) 배치 래퍼 — chkSum 자체가 Designer Visible=false(:346) 비노출이라 래퍼도 화면 요소 아님(2026-10-20 정정) | 제외 |")
rep('D00-2-004', f"| D00-2-004 | §2 chkSum / CheckedChanged (.cs:324-337) | Grid:{gr_sv} (visible: showSum — 부모 Page:{pg_ss} 가 항상 false) | {SUMREASON} | 제외 |")
rep('D00-2-005', f"| D00-2-005 | §2 btnInput / Click (.cs:684-809) | Hook:{hk_cb}-{hk_end} (useShipmentWorkingDayOspInputValue — 가드 5 + 3분기 SetText, 메시지 코드 TO-BE 실측으로 2026-10-20 정정) ← Page:{pg_iv}-{pg_iv_end} 배선 |  | 구현 |")
rep('D00-2-008', f"| D00-2-008 | §2 this / Load → Form_Load (.cs:103,107-114: InitForm·InitControls·DefineProperty·CreateSpread·InitEvent) | Page:{pg_mount}-{pg_mount_end} (mount useEffect — clearFilters·fetchStaticColumns·restoreSearchConditions = InitForm/컬럼 메타) + Page:{pg_dr}-{pg_dr_end} (dayRange 쿼리·1회 적용 effect = InitControls `dCalendar.InitValue = GetDayRange()` .cs:137) + Store:56-80 (초기값: divisionId 세션 · dayWeek SelectDay · initPeriod placeholder) + Page:{pg_sumc}-{pg_sumc+1}(DefineProperty chkSum.Checked=false .cs:121 = SUM 항상 숨김) + Form 콤보 로드(= setListBox .cs:130-132) + Grid 핸들러 등록(= InitEvent/CreateSpread) | 2026-10-20 추가(G03). GetBucketType(.cs:136) 은 D00-4-007 제외 | 구현 |")
rep('D00-3-001', f"| D00-3-001 | §3 SetReNumerCellType / 163 (WORKING_TIME_DEFAULT 소수 0 · 최소 0 · 최대 7) | Grid:{gr_mc},{gr_ms_tp} (편집형 = admin INPUT_TP_CD 'O' 위임) + Page:{pg_wtd}-{pg_wtd_end} (저장 직전 정수·0~7 범위 판정 MSG00460/MSG01037, Const:{ct_wtd} WTD_RANGE) | 2026-10-20 2차 보완(원장 S96-8): 이전엔 편집형 선언만 있고 0~7 정수 제약이 없었다. 사내 SAVE SP F_TO_NUM 은 범위 미검사 | 구현 |")
rep('D00-3-016', f"| D00-3-016 | §3 LockColumn / 288 (키 3컬럼 잠금) | Grid:{gr_et}-{gr_et_end},{gr_eb}-{gr_eb_end},{gr_ie}-{gr_ie+1},{gr_be}-{gr_be_end} (INPUT_TP_CD 'S' → editableStaticBindings 제외 → beginningEdit e.cancel; 사내 메타 DIVISION_ID~PLANT_SITE_NAME 'S') | 2026-10-20 2차 보완(원장 S96-14): 리터럴 EDITABLE_STATIC_BINDING → admin INPUT_TP_CD 단일 원천 | 구현 |")
rep('D00-3-017', f"| D00-3-017 | §3 LockColumn / 289 (LAST_INPUT_DATE~MEASURE 잠금) | Grid:{gr_mc},{gr_ms_tp} (admin INPUT_TP_CD 'S' 그대로 SEARCH_ONLY) + isEditableBinding 제외 → 잠금 |  | 구현 |")
rep('D00-3-018', f"| D00-3-018 | §3 Visible= / 347 (D_/W_ 항상표시) | Grid:{gr_leaf_vis} (D_ leaf visible:true) | W_ 열은 GET SP 가 만들지 않음(AS-IS·Oracle 동일) — D_ 만 해당 | 구현 |")
rep('D00-3-019', f"| D00-3-019 | §3 Visible= / 352 (chkSum SUM 토글) | Grid:{gr_sv} (sumGroups visible: showSum — 항상 false) | {SUMREASON} | 제외 |")
rep('D00-3-021', f"| D00-3-021 | §3 Query / 470 (FindData_Main 조회) | Page:{pg_q}-{pg_q_end},{pg_hs}-{pg_hs_end} (useTabProcQuery GET SP + handleSearch invalidateQueries) |  | 구현 |")
rep('D00-3-023', f"| D00-3-023 | §3 SmartColMerge / 477 (조회 후 재병합) | Grid:{gr_raf}-{gr_raf_end} (조회 후 updatedLayout rAF 로 머지헤더 재적용) |  | 구현 |")
rep('D00-3-024', f"| D00-3-024 | §3 Get / 683 (Columns.Get(0).Visible 조회 전 차단) | Hook:{hk_ns-2}-{hk_ns+1} (가드 #1 !hasSearched → MSG00662 \"조회 후 수정모드로 가능합니다\") | AS-IS MSG00135 원문(\"수정모드가 아니므로 입력할 수 없습니다\")은 TO-BE 에서 다른 본문이라 의미 동일 코드로 치환(2026-10-20, 원장 S96-10) | 구현 |")
rep('D00-3-025', f"| D00-3-025 | §3 GetModelColumnFromViewColumn / 734 | Hook:{hk_wc}-{hk_wc_end} (writeCell — g.columns[col].binding 로 뷰열→모델 binding 변환) |  | 구현 |")
rep('D00-3-026', f"| D00-3-026 | §3 GetModelColumnFromViewColumn / 735 | Hook:{hk_wc}-{hk_wc_end} (writeCell 좌표→binding 변환, dataItem 조회) |  | 구현 |")
rep('D00-3-027', f"| D00-3-027 | §3 SetText / 744 (SelectDay 선택셀 기입) | Hook:{hk_sd}-{hk_else} (isSelectDay 선택영역 D_ 셀 writeCell) |  | 구현 |")
rep('D00-3-028', f"| D00-3-028 | §3 SetText / 758 (SelectDay 기입 지점2) | Hook:{hk_nc+3}-{hk_else} (선택영역 중첩루프 writeCell) |  | 구현 |")
rep('D00-3-029', f"| D00-3-029 | §3 SetText / 771 (SelectDay 기입 지점3) | Hook:{hk_wc}-{hk_wc_end} (writeCell setCellData + tracker.storeChange) |  | 구현 |")
rep('D00-3-030', f"| D00-3-030 | §3 SetText / 789 (EveryDay 전행 D_) | Hook:{hk_else}-{hk_w0-2} (isEveryDay → 전행×전 D_ 컬럼 writeCell) |  | 구현 |")
rep('D00-3-031', f"| D00-3-031 | §3 SetText / 797 (요일별 매칭 D_) | Hook:{hk_ed}-{hk_ed+1} (dayCol.weekday===targetWeekday 매칭 셀만 writeCell) |  | 구현 |")
rep('D00-4-004', f"| D00-4-004 | §4 SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP / SCP0096_GET_SHIPMENT_WORKING_DAY_OSP (FindData_Main .cs:457-467, IN 4 + debug_mode) | Store:118-134 setFilters(divisionId/plantSiteId/fromYyyymmdd/toYyyymmdd = 사내 PROC_M COL_NM) + Page:{pg_q}-{pg_q_end} useTabProcQuery MAIN → 사내 배선 SEARCH→P_SCP0096_GET→PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP(6인자) | debug_mode 는 As-is PRINT 전용 — 사내 PROC_M 미등록(2026-10-19 결정) | 구현 |")
rep('D00-4-006', f"| D00-4-006 | §4 SCP.SCM0001_GET_SCP_MONTH_PERIOD (InitControls GetDayRange .cs:137,840-846 → DateUtil.GetDayRange(cboDivision,'DAILY') DateUtil.cs:330 — flow.csv 미수록 프레임워크 유틸) | Const:22 SHEETS.DAY_RANGE + Page:{pg_dr}-{pg_dr_end} (dayRangeFilters IN 5 = PROC_M COL_NM · useTabProcQuery · o_rc1[0].PERIOD 1회 적용) + Store:25,56-68,184,193-201 (dayRangeApplied·placeholder·applyDayRange) → 사내 배선 dayRange/SEARCH → SCM0001_SCP_MONTH_PERIOD_GET → PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD | 2026-10-20 추가(원장 S96-1). 사내 실측 '20261020:20271017' | 구현 |")
rep('D00-4d-001', f"| D00-4d-001 | §4d BtnInput_Click 가드 #1 조회 전(AS-IS MSG00135) | Hook:{hk_ns-2}-{hk_ns+1} (!hasSearched → MSG.NOT_SEARCHED=MSG00662, Const:{ct_ns}) | TO-BE MSG00135 본문은 \"편집 모드에서는 이 기능을 사용할 수 없습니다\"(다른 메시지)·MSG00134/MSG00050 미등록 — SCM_ADM_MSG_M 실측으로 재배선(2026-10-20, 원장 S96-10) | 구현 |")
rep('D00-4d-002', f"| D00-4d-002 | §4d BtnInput_Click 가드 편집모드 아님(AS-IS MSG00135) | Hook:{hk_ne-3}-{hk_ne+2} (!canEdit → MSG.NOT_EDIT_MODE=MSG01154 \"수정모드가 아니므로 입력할 수 없습니다\" alert, Const:{ct_ne}) | 2026-10-20 정정(원장 S96-11): 이전 무메시지 return 은 AS-IS(메시지 표시)와 달랐다. TO-BE 원문 동일 코드 사용 | 구현 |")
rep('D00-4d-004', f"| D00-4d-004 | §4d BtnInput_Click Input Value 값 검증(Y/N) | Hook:{hk_rv-5}-{hk_rv+3} (INPUT_VALUE_SET 밖(미선택 ''·오염) → MSG.REQUIRED_VALUE=MSG00429 \"{{0}} 값은 필수 입력 항목입니다\" {{0}}=Input Value) | AS-IS 는 콤보라 형식검증 없이 빈값도 SetText(.cs:696) — TO-BE 는 빈 Y/N 셀 적재 방지로 선택 요구. 이전 MSG00050 은 TO-BE 미등록 코드(2026-10-20 정정) | 구현 |")
rep('D00-4d-005', f"| D00-4d-005 | §4d BtnInput_Click 가드 #4 SelectDay 선택셀0(AS-IS MSG00134 \"날짜 선택 후 입력하세요\") | Hook:{hk_nc-2}-{hk_nc+2} (isSelectDay sel 없음 → MSG.NO_CELL_SELECTED=MSG01153 원문 동일, Const:{ct_nc}) + Hook:{hk_w0}-{hk_w0+4} (선택영역에 D_ 셀 0 — 동일 안내) | 2026-10-20 정정(원장 S96-10) | 구현 |")
rep('D00-4d-006', f"| D00-4d-006 | §4d BtnInput_Click 권한(!CanModelChange, 무메시지) | Hook:{hk_ne-3}-{hk_ne+2} (canEdit 게이트로 흡수 — canEdit = hasButton('EDIT') Page:{pg_ce}, 사내 MNU_BTN_MPG_M EDIT 정의) | AS-IS CanModelChange 권한체크 = TO-BE EDIT 버튼 권한으로 흡수(메시지는 D00-4d-002 의 MSG01154 로 통합) | 구현 |")
rep('CRUD:SEARCH', f"| CRUD:SEARCH | Main 조회(FindData_Main — checkRequiredOfSearch Division*/Period* .cs:432 + GET) | Page:{pg_vf}-{pg_vf_end},{pg_hs}-{pg_hs_end} (validateFind — Division 필수 MSG00097 :{pg_vf_div} · Period 필수 MSG00429 :{pg_vf_per} · 역전 MSG00108 :{pg_vf_inv} + handleSearch — setFilters + invalidateQueries) | 2026-10-20 2차 보완(원장 S96-9): Period 필수 검증 추가(Designer \"Period*\" :532), 메시지 코드 TO-BE 실측으로 교정 | 구현 |")
rep('CRUD:SAVE', f"| CRUD:SAVE | 저장(SaveData_Main, M-only 7 CLOB · MSG00004 iCount 건 저장 · 빈 WORKING_TIME_DEFAULT→\"0\" .cs:567) | Page:{pg_sv}-{pg_sv_end} (handleSave — EditTracker net 변경 '^' 직렬화 + WORKING_TIME_DEFAULT 정수·0~7 판정 :{pg_wtd}-{pg_wtd_end} + apiClient.post SAVE → 사내 배선 SAVE→P_SCP0096_SAVE→PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP 9인자 + 결과 커서 o_result_cursor(RESPONSE_SET.STATUS) RESULT_CODE 'F' 분기 :{pg_cur}-{pg_cur+11} + 성공 토스트 MSG00672 {{0}}=RESULT_CNT :{pg_toast-2}-{pg_toast+2}) | 2026-10-20 2차 보완(원장 S96-8·S96-12): 결과 커서 키 대문자 O_RESULT_CURSOR → 소문자(BE PROC_M COL_NM) · 성공 토스트 MSG00004(TO-BE 본문 \"수정한 내용이 없습니다\") → MSG00672. 빈 WORKING_TIME_DEFAULT→\"0\" 은 사내 SP F_TO_NUM(NULL)=0 이 흡수(FE 는 '' 전송) | 구현 |")
rep('COMMON:UC-02', f"| COMMON:UC-02 | 수정 중 재조회 시 confirm (MSG00703) | Page:{pg_rg}-{pg_rg_end},{pg_hs}-{pg_hs_end} (resetGrid — Division 변경 시 미저장 편집 폐기 + handleSearch 는 편집 폐기) | AS-IS 는 수정중 재조회 confirm 없이 SwitchLock 잠금복귀 — TO-BE 도 조회 시 EditTracker clear(동일 동작). 별도 confirm 은 AS-IS 미존재 | 구현 |")
rep('COMMON:UC-03', f"| COMMON:UC-03 | 컬럼 설정 적용 시 Reset 후 재조회 | Page:{pg_mount}-{pg_mount_end},{pg_hs}-{pg_hs_end} (fetchStaticColumns mount+Search refetch) — admin 컬럼 메타(INPUT_TP_CD 포함) 변경 반영 | 이 화면은 Column/Measure 설정 UI 진입점 없음(SHEET_MEASURE 0행). admin 메타 변경은 Search refetch 로 반영 | 구현 |")
rep('COMMON:UC-04', f"| COMMON:UC-04 | CRUD 완료 알림 = 하단 Toast | Page:{pg_toast-2}-{pg_toast+2} (handleSave 성공 setToast success — MSG00672 {{0}}개 저장) |  | 구현 |")
rep('COMMON:UC-07', f"| COMMON:UC-07 | 필터 걸린 상태 재조회 시 필터 유지 (rebindFilterColumns) | Grid:{gr_flt}-{gr_flt_end} (FlexGridFilter 피처 소유 + filterApplied 재적용, filterColumns 유지) |  | 구현 |")
s = s.replace("> 2026-10-20 보완(원장 `REQ:CHAT-20261020-S96-1~7`)", "> 2026-10-20 2차 보완(원장 `REQ:CHAT-20261020-S96-8~16`): PKG.sql 사내 미러 복원·GTT DDL · 메시지 코드 TO-BE 실측 재배선 · Period 필수 · WORKING_TIME_DEFAULT 0~7 정수 · 저장 커서 키 소문자+MSG00672 · Sum 비노출 · INPUT_TP_CD 메타 위임 · __tests__ · e2e_plan 갱신. 행은 추가·갱신만(M06).\n> 2026-10-20 보완(원장 `REQ:CHAT-20261020-S96-1~7`)", 1)
req = f"""
## 보완요청 원장 축 (REQ — 2026-10-20 2차, `Doc/단위테스트_보완대상/보완요청_원장.md` S96-8~16)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| REQ:CHAT-20261020-S96-8 | WORKING_TIME_DEFAULT 0~7 정수 제약(AS-IS SetReNumerCellType .cs:163) | Page:{pg_wtd}-{pg_wtd_end} + Const:{ct_wtd},{ct_wr},{ct_wi} |  | 구현 |
| REQ:CHAT-20261020-S96-9 | 조회 Period 필수(Designer "Period*" :532 + checkRequiredOfSearch .cs:432) | Page:{pg_vf_per-5}-{pg_vf_per+3} (MSG00429 {{0}}=Period) |  | 구현 |
| REQ:CHAT-20261020-S96-10 | 메시지 코드 TO-BE SCM_ADM_MSG_M 실측 재배선(MSG00135→MSG00662 · MSG00134→MSG01153 · MSG00050 폐기 · Division 필수 MSG00097 · 역전 MSG00108) | Const:{ct_msg}-{ct_sc} + Hook:{hk_ns},{hk_nc},{hk_w0+2} + Page:{pg_vf_div},{pg_vf_inv} |  | 구현 |
| REQ:CHAT-20261020-S96-11 | btnInput 편집권한 없음 = AS-IS MSG00135 알림(무메시지 return 아님) → MSG01154 | Hook:{hk_ne-3}-{hk_ne+2} |  | 구현 |
| REQ:CHAT-20261020-S96-12 | 저장 결과 커서 키 o_result_cursor(소문자) + 성공 토스트 MSG00672 {{0}}=RESULT_CNT | Page:{pg_cur}-{pg_toast+2} |  | 구현 |
| REQ:CHAT-20261020-S96-13 | Sum 커스텀 버튼 비노출(AS-IS chkSum Visible=false :346 · SP W_/M_ 없음) | Page:{pg_sumc}-{pg_sumc+1},{pg_ss} / Grid:{gr_sv} |  | 구현 |
| REQ:CHAT-20261020-S96-14 | 정적 컬럼 편집 판정 = admin INPUT_TP_CD 단일 원천(리터럴 EDITABLE_STATIC_BINDING 제거) + registration.sql BLOCK 3-b 정합 UPDATE | Grid:{gr_et}-{gr_et_end},{gr_mc},{gr_ms_tp},{gr_eb}-{gr_eb_end},{gr_ie}-{gr_ie+1} + Doc/gen/SCP0096/SCP0096_registration.sql BLOCK 3-b |  | 구현 |
| REQ:CHAT-20261020-S96-15 | Doc/gen/SCP0096/SCP0096_PKG.sql = 사내 현행 미러 복원(check-pkg BLOCK 7→0) + SCP0096_GTT.sql | Doc/gen/SCP0096/SCP0096_PKG.sql · SCP0096_GTT.sql · _artifacts/_diagnostics/SCP0096_SUPP2_20261020/ | DB 객체 무변경(사내 현행 그대로) | 구현 |
| REQ:CHAT-20261020-S96-16 | DoD B20 __tests__ + e2e_plan.json 실제 페이지 정합 + TobeFacts 재추출(gap this.Load MISSING→COVERED) | __tests__/ShipmentWorkingDayOsp.spec.ts(TC-SCP0096-001~009) · Doc/gen/SCP0096/e2e_plan.json · Doc/e2e/specs/SCP0096.*.spec.ts | E2E 실행은 dev-login 401(BE)로 미검증 | 구현 |
"""
s = s.rstrip('\n') + '\n' + req
io.open(m, 'w', encoding='utf-8', newline='\n').write(s)
print('rows before', orig_rows, 'after', s.count('\n|'))
