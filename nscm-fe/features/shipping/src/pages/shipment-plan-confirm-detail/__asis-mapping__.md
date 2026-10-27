# SSP0012 Shipment Plan Confirm Detail — AS-IS ↔ TO-BE 매핑

- AS-IS: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0012_ShipmentPlanConfirmDetail.cs` (+ Designer)
- 설계: `.atlas/gscm-design/SSP0012/design/00_checklist.md ~ 03_grid-columns.md`
- 화면 성격: 읽기전용 조회(Inquiry) + 고정 47컬럼 상세 그리드. 편집·저장·동적 PIVOT 없음.

## 영역1 — Layout / 툴바 (design 01)

| AS-IS | cs 근거 | TO-BE |
|---|---|---|
| Form(BaseFormAsync) | Designer:537 | `ShipmentPlanConfirmDetail.tsx` + Form + Store |
| usrConditionPanel1(HidePanel) | Designer:116 | `SearchArea`(openSearchArea 접기/펼치기) |
| L1 권한 게이트(dtMyDivision 0건) | cs:232-233 | Form: MyDivision(EE제외) 0건 → `hasDivisionAuth=false` → 조회영역 disable + MSG00667("No authority assigned." — TO-BE 문구 실측 코드, AS-IS MSG00097 답습 금지 Hook#114) |
| L2 Insert = NO-OP | cs:303-306 | `hotkeyConfig.insert = hasButton ? () => undefined : false` |
| L3 Delete = NO-OP | cs:308-311 | `hotkeyConfig.delete = hasButton ? () => undefined : false` |
| L4 Save = NO-OP | cs:345-347 | `hotkeyConfig.save = hasButton ? () => undefined : false` |
| L5 Edit = MSG00109 안내(읽기전용 가드) | cs:314-318 | **미이식** — TO-BE 표준은 편집모드 토글 버튼을 두지 않는다(convert-core §2.4 / analysis.md ANL-06). 읽기전용 화면이라 처음부터 전열 잠김으로 열리고 Edit 트리거 소멸. 다수파 선례(waterfall-shipment-plan-fg·validation-shipment-result 등 미노출)와 정합. 사용자 확정 2026-10-14 |
| L6 Find = 조회 | cs:298-301,384 | `hotkeyConfig.search = handleSearch`(Period 필수 가드) |
| L7 btnColumn(컬럼설정) | cs:605-615 | SubTitle 아이콘 customButton(#120) → 공용 표준 `ColumnLayoutModal`(POP-13) → OK 시 `fetchStaticColumns` refetch |

## 영역2 — 조회조건 콤보 (design 02)

| AS-IS | cs 근거 | TO-BE |
|---|---|---|
| Division(clbDivision) MyDivisionInEE + EE 제외 | cs:48,237 | 콤보 `MyDivisionInEE_SCP` + 클라 필터 `CODE!=='EE'`(정확히 'EE') |
| From Site(clbPlantSite) EE/비-EE 분기 재조회 | cs:364-378 | `useTabComboQueries` comboId 분기(`ShipmentPlanPlantSite_SCP`/`PlantSiteByDivision_SCP`) @divisionId 재발사 + ALL |
| Division 변경 = Period 리셋 | cs:380 | `setDivisions` → Period 기본값 재설정 + From Site 초기화 |
| Model(txtItemId) 팝업 | cs:322-343 | `ModelByDivisionPopup`(SCM0002/ModelPopup, params: divisionId/scmSiteId/itemId, `multiSelect`) → itemId 세팅. 정정 2026-10-15: AS-IS 는 `SCM0002_ItembyDivisionPopup`(cs:329) = ModelByDivisionPopup 이다. 종전 `ItemByDivisionModal`(COM0008/DM0002) 은 오기 — SP·조건·컬럼·ALL전체조회 동작이 모두 다름 |
| Period* 기본값(오늘~+55영업일) | cs:243,381,587-608 | `SCM0001_GET_SCP_DAY_PERIOD` 콤보 서버 산출(@fromDate=오늘,@offsetDay='55',@timeZone='') → `setServerPeriod`(ShipmentPlanConfirmDetailForm.tsx) · 미도착 시 dayjs 근사 폴백. gap-resolve iter-1 에서 서버콤보 배선(콤보 배포 USE_YN='Y' 실측) — 종전 dayjs-only 근사 교정 |
| Sold To / Ship To Party | cs:403-404 | 자유 텍스트 → SP p_Sold_To_Party / p_Ship_To_Party |
| LABEL 6종 | design 02 §4.5 | LBL00641/00022/00669/00013/01122/01114(실측 존재, 신규 0) |

## 영역3 — 그리드 (design 03)

| AS-IS | cs/메타 근거 | TO-BE |
|---|---|---|
| 47컬럼 고정 스키마 | SCM_MST_SHEET_COLUMNS 47행 | `staticColumns`(admin 메타 구동, 하드코딩 없음 #130) |
| W1/W3/W7 세로 머지 sticky | cs:267,287-291,441 | DataGrid `allowMerging=Cells` + CustomMergeManager(hook #69) |
| W5 조회 바인딩 | cs:438 | `useTabProcQuery` 결과 바인딩 |
| W6 전열 읽기전용 잠금 | cs:439 | DataGrid `isReadOnly` |
| W4 SetLockSumColumn(dead) / 동적 PIVOT | cs:353-362(호출부 없음) | 미구현(반증, 구현 시 AS-IS 초과 결함) |
| 2단 머지 헤더(Departure Port/Arrival Port/Departure days/Lead Time) | cs:266 | admin 메타 SMALL_CLASS_LABEL_NAME 구동 다단 헤더(hook #93) |
| INCOTERMS 좌측 고정(FIXED_FLAG=Y) | 메타 | admin 메타 `fixed` → DataGrid frozenColumns |
| FCST_TYPE 코드→표시(SALES_TYPE_CODE) | cs:56 메타 FPComboBox | admin 메타 자동 콤보(표시매핑, 편집 아님) |
| W9 INCOTERMS 셀 클릭 → BOD 상세 | cs:507-523 | Grid click → `BodDetailModal`(divisionId[DIVISION_ID 정확히 'EE' 일 때만 ORIGIN_FROM_DIVISION_ID]+bodId). gap-resolve iter-1: cs:513 `== "EE"` 정확 일치 재현(`.includes` 오연산자 교정, Grid.tsx:86) |
| W10 CHANGE_REQ_NO 셀 클릭 → 변경요청 상세 | cs:524-534 | Grid click → `ShipmentRequestDetailModal`(changeReqNo) |
| G1 빈 그리드 가드 | cs:505 | click: `g.rows.length===0` return |
| G2 컬럼 판정 가드 | cs:507/524 | click: binding == INCOTERMS/CHANGE_REQ_NO |
| G3 공백 CHANGE_REQ_NO 가드 | cs:528 | click: changeReqNo 공백이면 미오픈 |
| hidden 4컬럼(PLAN_QTY/BOD_ID/ORIGIN_FROM_DIVISION_ID +1) | 메타 VISIBLE_FLAG=N | admin 메타 visible=false 유지(드릴다운 파라미터) |

## 미이관/유예 (정직 보고 — gap-resolve iter-1 DB 실측 갱신 2026-10-13)

- GET SP `PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL` **배포·배선 완료**(ora.py 실측: PACKAGE+BODY VALID · `SCM_ADM_API_M` P_SSP0012_GET USE_YN='Y' · `SCM_ADM_PROC_M` 11행 = FE 페이로드 일치). 종전 "미배포" 는 패키지 멤버를 이름으로만 all_objects 조회한 오판(db-access 경고). 실데이터 런타임 렌더는 브라우저 육안(사용자 축).
- Period 서버 기본값 `PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD` **배포·콤보 등록**(USE_YN='Y') → iter-1 에서 서버콤보 배선(위 영역2 Period 행). 종전 dayjs-only 근사 교정.
- 드릴다운 상세 팝업 데이터 원천 SP — 2026-10-14 재확인으로 **두 팝업 상태가 다름**(SCM0002 는 단일 화면이 아니라 공용 팝업 라이브러리 `GSCM.SCM.Popup.UIL` 접두어):
  - **변경요청 팝업**(SCM0002_ShipmentPlanRequestPopup, CHANGE_REQ_NO 드릴다운): AS-IS SP `SSP.SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING`(p_change_request_no/p_language) = 전환 SP `PKG_SSP0003.P_SSP0003_GET_REQ_DRAFTING` **이미 배포됨**(procedures.d.ts, o_rc1=비교그리드/o_rc2=요청폼). 기존 전환 모달 `ShipmentChangeRequestDraftingModal`(SSP0015)이 `/SSP0015/main/GET_REQ_DRAFTING/call-proc`로 사용 중. → **convert-sp 불요. 2026-10-14 실배선 완료**: `ShipmentRequestDetailModal` placeholder → 실조회(`/SSP0012/main/GET_REQ_DRAFTING/call-proc`, o_rc1 비교그리드+o_rc2 요청폼, 자매와 동일 계약) 교체 + `REQ_DRAFTING_BTN` 상수. 호출 버튼/권한 등록 SQL `design/06_register_change_req_drafting_btn_auth.sql`(API_M/PROC_M 재사용, MNU_BTN+USER_GR 2층만, 멱등) 작성 — DB 실행 사용자(admin-meta-sql). **2026-10-15 런타임 end-to-end PASS**(브라우저 실측): CHANGE_REQ_NO 셀 클릭 → `POST /SSP0012/main/GET_REQ_DRAFTING/call-proc` 200·145ms, o_rc2 요청폼(Request No/Requestor/Dept/Approval/Reason) + o_rc1 비교그리드 실데이터 렌더, 콘솔 0.
  - **BOD 팝업**(SCM0002_ShipmentPlanConfirmBODPopup, INCOTERMS 드릴다운): AS-IS SP `SCM.SCM0002_SHIPMENT_PLAN_CONFIRM_BOD_POPUP`(p_division_id/p_bod) → 전환 SP `PKG_SCM0002.P_SCM0002_SHIPMENT_PLAN_CONFIRM_BOD_POPUP` **2026-10 Oracle 이관 완료**. **계약 DB 실측(2026-10-15 스크린샷)**: API_M=`P_SSP0012_BOD_POPUP_GET`, PROC_M IN 키 = `divisionId`/`bod`(bodId 아님), OUT o_rc1/O_RESULT_CURSOR — **API_M/PROC_M 이관 때 선등록됨**. **2026-10-15 실배선**: `BodDetailModal` placeholder → 실조회(`/SSP0012/main/GET_BOD_DETAIL/call-proc` body{divisionId,bod}, o_rc1 경로상세(30컬럼), AS-IS 2단 헤더 From/To Site·Dep/Arr Port·Departure days·Lead Time) 교체 + `BOD_DETAIL_BTN` 상수. 등록 SQL `design/07_register_bod_popup_btn_auth.sql` = **MNU_BTN+USER_GR만**(기존 API_ID 참조, 멱등). 공유 팝업(AS-IS SSP0001+SSP0012)이나 TO-BE 소비자 SSP0012 하나라 화면 로컬(배치 A), SSP0001 전환 시 shared 승격. **2026-10-15 런타임 end-to-end PASS**(브라우저 실측): INCOTERMS 셀 클릭 → `POST /SSP0012/main/GET_BOD_DETAIL/call-proc` body{divisionId:40,bod:11323} 200·84ms, o_rc1 경로상세 실데이터(HQ06-A→SpaceX_US_HHR, AIR, INCHEON→LOSANGELES, DAYS Y) 전건 정확 바인딩+2단 헤더 렌더, 콘솔 0. **2026-10-16 레이아웃 정정**(AS-IS cs:149-178 전수 대조): 당초 23컬럼은 **Lead Time 구간분해 6컬럼**(Departure Inland/Waiting For Shipping/Voyage/Lay Off·Customs Clearance/Arrival Inland/Total L/T) + `Departure days`·`Lead Time` 2단 그룹을 누락한 것 → **30컬럼**으로 정정(폭/정렬도 AS-IS 실측 정합). 단독 LT_TOTAL 라벨은 AS-IS 'Lead Time'이나, 공용 DataGrid 가 동일 그룹명을 병합해 분해그룹 'Lead Time'과 충돌하면 6컬럼이 앞으로 당겨지므로 단독만 'L/T'(메인 L/T(Day) 축약)로 표기해 순서 보존. 브라우저 재검증: 상단 그룹 순서 Division→From Site→To Site→Trans Mode→L/T→Departure Port→Arrival Port→Departure days→Lead Time = AS-IS 일치.
  - 공통: 두 팝업 모두 트리거·가드·파라미터는 구현, 상세 데이터는 placeholder 유예.
- 드릴다운 모달 제목/라벨 i18n(Hook#114): 'BOD Detail'/'Change Request Detail'/'Change Request No' 문구 코드가 SCM_ADM_MSG_M 에 없음(LBL01047='Receiver Setup', LBL01048='SMS Content *', LBL01108='Requestor'). AS-IS 번호 답습 대신 화면 스코프 키(`_ssp0012.*`)+defaultValue 사용. message-master 신규 등록은 실 팝업 전환(convert-sp) 때로 유예.
- SetChangedPeriod/dBaseDate = dead(cs:500 호출부 주석처리·dBaseDate 미참조, dtBaseDay 는 dead dBaseDate 전용) → 이식 안 함. SetLockSumColumn/동적 PIVOT 도 dead(반증) → 미구현.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 축)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common'.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다. 성격: 읽기전용 조회(Inquiry).

| ID | 요지 | 구현 위치 | 사유 | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | — | 조회전용 inquiry — 신규행 Insert 없음(hotkeyConfig.insert=() => undefined, ShipmentPlanConfirmDetail.tsx:112). 대상 미해당 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 조회 시도 = confirm(MSG00703) | — | 조회전용 inquiry — 편집 없음(전열 isReadOnly, ShipmentPlanConfirmDetailGrid.tsx:114). 수정중 상태 자체 부재 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column 설정) 적용 시 재조회 유도(hook #132 §2-2) | ShipmentPlanConfirmDetail.tsx | ColumnLayoutModal onSave → `fetchStaticColumns` refetch(헤더 재구성). 동적 PIVOT 아님(design 03 §2)이라 데이터 Reset 재조회는 불요 — 컬럼 메타만 재구성 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | — | 조회전용 inquiry — CRUD 완료 이벤트 없음(SEARCH 만 동작). 완료 Toast 대상 미해당 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 Code 아닌 Name 출력 | ShipmentPlanConfirmDetailGrid.tsx:118-120 + ShipmentPlanConfirmDetail.tsx:153-163 | FCST_TYPE 셀콤보(admin 메타 FPComboBox+SALES_TYPE_CODE) dataMap → SubTitle grid+gridFilter Excel export 시 wijmo 가 Name 렌더 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 전건 조회 | useShipmentPlanConfirmDetailStore.ts:105-113,195-198 | Model(itemId) multiLine(개행/콤마 split→join), Sold To/Ship To 원문 그대로 SP 전달 | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회+필터 그대로 적용(rebindFilterColumns) | ShipmentPlanConfirmDetailGrid.tsx:113 + ShipmentPlanConfirmDetail.tsx:36,157 | 공용 DataGrid gridFilterRef 배선(FlexGridFilter 유지·rebind) — 재조회 시 필터 상태 보존 | 구현 |
