# SSP0020 Delegate — AS-IS ↔ TO-BE 매핑 (Top11 #11)

AS-IS 정본: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0020_Delegate.cs` (+ `.Designer.cs`).
설계: `.atlas/gscm-design/SSP0020/design/00~03,07`. TO-BE: `features/shipping/src/pages/delegate/`.

전환 판정: **신규(NEW)**. PKG_SSP0020 **MISSING**(2026-09-22 실측) → 저장/해제/조회 런타임 실행체인은
convert-sp 후속. FE 는 목표 PKG 이름으로 API/권한 선배선(convert-core §2.3 예외 (b)).

## 1. validations (17건 — 00_checklist §4f 전건)

| # | AS-IS msgId | cs line | condition | TO-BE 처리 | TO-BE MSG | 파일 |
|---:|---|---:|---|---|---|---|
| 1 | MSG00298 | 372 | 위임자명 공백 | validateSave delegatee 공백 차단 | MSG00298(미존재→영문 fallback) | hooks/useDelegateValidation.ts |
| 2 | MSG00305 | 379 | 위임자==본인 | validateSave delegateeId===sesUserId | MSG00305(미존재→fallback) | useDelegateValidation.ts |
| 3 | MSG00134 | 385 | 기간 공백 | validateSave from/to 공백 | MSG00134(미존재→fallback) | useDelegateValidation.ts |
| 4 | MSG00219 | 393 | From>To | validateSave toYmd 비교 | MSG00219(미존재→fallback) | useDelegateValidation.ts |
| 5 | MSG00105 | 426 | 중첩 기간(intCount>0) | validateSave: rs1(dtFind_Data)에서 선택 division·VALID='Y'·AS-IS 중첩정의(FROM/TO∈[from,to]) — 위임자 무관(AS-IS cs:416 에 delegatee 필터 없음) | **MSG00105(TO-BE 실존 "There are overlapping periods")** | useDelegateValidation.ts |
| 6 | MSG00296 | 440 | 수임자 타 위임 현황(intCount>0) | validateSave: rs1 에서 선택 division·VALID='Y'·`USER_ID==delegateeId`·중첩 (AS-IS cs:430 그대로 클라 판정 — dtFind_Data=rs1, SP 조회 아님) | MSG00296(미존재→fallback, 상수 보유) | useDelegateValidation.ts |
| 7 | MSG00297 | 454 | 중첩 기간 수임 현황(intCount>0) | validateSave: rs1 에서 선택 division·VALID='Y'·`DELEGATEE_ID==sessionUserId`·중첩 (AS-IS cs:444 그대로 클라 판정) | MSG00297(미존재→fallback, 상수 보유) | useDelegateValidation.ts |
| 8 | MSG00299 | 462 | 선택 division 없음(bolDivisionChk) | validateSave divisionIds.length===0 | **MSG00097**(TO-BE 실존 "Please select Division") | useDelegateValidation.ts |
| 9 | MSG00004 | 523 | 저장 성공(Rows[0][0]=="S", arg 건수) | 저장 성공 toast(건수) | **MSG00672**("{0} data saved") ※AS-IS MSG00004 는 TO-BE 에서 "No changes" 이므로 재매핑 | Delegate.tsx handleSave |
| 10 | MSG00284 | 528 | 완료 | 성공 toast 로 통합(별도 완료 메시지 미사용 — TO-BE MSG00284="grid not ready" 상이) | (미사용) | Delegate.tsx |
| 11 | (없음) | 535 | 예외(iCount>0) GMessageBoxForException | catch → setAlert(SAVE_FAIL) | MSG00003 | Delegate.tsx handleSave |
| 12 | MSG00300 | 576 | 해제 대상 미선택(bChk) | handleUnset 선택 0건 차단 | MSG00300(미존재→fallback) | Delegate.tsx handleUnset |
| 13 | MSG00004 | 749 | 해제 성공(bolSuessceChk, arg 건수) | 해제 성공 toast(건수) | **MSG00672** (동上 재매핑) | Delegate.tsx handleUnset |
| 14 | MSG00284 | 757 | 해제 완료 | 성공 toast 로 통합 | (미사용) | Delegate.tsx |
| 15 | (없음) | 761 | 예외 GMessageBoxForException | catch → setAlert(SAVE_FAIL) | MSG00003 | Delegate.tsx handleUnset |
| 16 | MSG00302 | 802 | UserName_Search **다중검색** "검색창 여시겠습니까?"(cs:799-806) | 수기입력 위임자 다건 시 confirm→SsoUserModal 오픈 (저장 confirm 아님 — 설계 00 §4f 오독 정정) | MSG00302(미존재→fallback) | Delegate.tsx handleSave / useDelegateValidation.ts |
| 17 | MSG00301 | 811 | UserName_Search **0건** "검색창 여시겠습니까?"(cs:808-815) | 수기입력 위임자 미검색 시 confirm→SsoUserModal 오픈 (해제 confirm 아님) | MSG00301(미존재→fallback) | Delegate.tsx handleSave / useDelegateValidation.ts |

> i18n 재매핑 근거(Hook #114, 2026-09-22 ora.py SCM_ADM_MSG_M 실측): MSG00004=TO-BE "No changes to save"
> (AS-IS 성공용과 상이) / MSG00284=TO-BE "The grid is not ready"(AS-IS 완료용과 상이) → 성공/완료는
> **MSG00672**("{0} data saved")로 재매핑. MSG00105/00097 은 TO-BE 문구 일치 확인 후 재사용.
> 미존재 8종(298/305/134/219/296/297/300/301/302/300)은 영문 defaultValue fallback + 정식 등록 후속.

## 2. buttonGuards (3건 — §4d)

| # | method | cs line | condition(hasMessage) | TO-BE | 파일 |
|---:|---|---:|---|---|---|
| 1 | BtnSave_Click | 341 | `UserName_Search(txtDelegatee)==false`(false, 순수가드) | searchDelegatee(): 수기입력 1건 통과 / 다건 MSG00302·0건 MSG00301 검색창 유도, 팝업 확정 id 는 재검색 생략(의도적 차이) | Delegate.tsx / useDelegateValidation.ts |
| 2 | BtnSave_Click | 347 | `Validation_Check()==false`(false) | validateSave() 실패 시 중단 | useDelegateValidation.ts |
| 3 | BtnUnSet_Click | 549 | `ActiveSheet.Rows.Count>0`(true) | handleUnset delegateRows.length===0 return + CHK 선택 가드 | Delegate.tsx handleUnset |

## 3. events (6건 — §2)

| # | control.event | handler | cs line | TO-BE |
|---:|---|---|---:|---|
| 1 | btnDelegatee.Click | BtnDelegatee_Click | 771 | onDelegateeSearch → SsoUserModal open (Delegate.tsx) |
| 2 | btnSave.Click | BtnSave_Click | 339 | handleSave (Delegate.tsx) |
| 3 | btnUnSet.Click | BtnUnSet_Click | 546 | handleUnset (Delegate.tsx) |
| 4 | chkAll.CheckStateChanged | chkAll_CheckStateChanged | 924 | Division "All" 선택 = 권한 division 전건 확장(DelegateForm CustomDropdown allOption, R5 초기 전체체크) — 영역2 clbDivision 전체선택(design 03 §3 정정, 그리드 아님) |
| 5 | spdMain.CellClick | SpdMain_CellClick | 850 | 그리드 CHK 선택 = 공용 DataGrid useCheckbox(Selector) rowHeader 체크박스 + 헤더 전체선택(DelegateGrid) |
| 6 | spdMain.SheetTabClick | SpdMain_SheetTabClick | 232 | TabWrapper activeTabIndex/setActiveTabIndex → R1/R2 SAVE·UnSet 노출 토글(DelegateForm showActions=권한, actionsActive=isDelegateSheet → SearchArea SAVE/UnSet 버튼, Delegate 시트에서만 활성·그 외 visibility:hidden) |

## 4. spCalls (5건 — §4a) / 실행체인

| # | AS-IS SP | 용도 | TO-BE 목표 SP(선배선) | 배선 | 상태 |
|---:|---|---|---|---|---|
| 1 | SSP0020_GET_DELEGATE | 위임 조회(2rs) | PKG_SSP0020.P_GET_DELEGATE | useTabProcQuery(sheetName=Delegate) o_rc1/o_rc2 | 선배선(PKG MISSING → convert-sp) |
| 2 | SSP0020_SAVE_DELEGATE | 위임 저장 | PKG_SSP0020.P_SAVE_DELEGATE | apiClient.post `/SSP0020/Delegate/SAVE/call-proc` | 선배선 |
| 3 | SSP0020_SAVE_UNSET(657) | 위임 해제 | PKG_SSP0020.P_SAVE_UNSET | apiClient.post `/SSP0020/Delegate/UNSET/call-proc` | 선배선 |
| 4 | SSP0020_SAVE_UNSET(715) | 위임 해제(분기) | 동上(3과 동일 파라미터셋) | 동上(행 단위 ^-join 전송으로 배칭 등가) | 선배선 |
| 5 | UP_FX_GetSSPUserUseInfoList | 위임자 실존 검증 | PKG_SSP0020.P_USER_CHECK | apiClient.post `/SSP0020/Delegate/USER_CHECK/call-proc` + SsoUserModal | 선배선 |

## 5. toolbar override (entryPoints §4g #1,4~7)

| override | cs line | 본문 | TO-BE |
|---|---:|---|---|
| FindButton | 892 | FindData_Main() | hotkeyConfig.search=handleSearch (GET) — 유일 기능 툴바 버튼 |
| InsertButton | 897 | no-op | hotkeyConfig.insert=false — **사용자 지시로 툴바에서 숨김**(AS-IS 도 no-op) |
| DeleteButton | 902 | no-op | hotkeyConfig.delete=false — **사용자 지시로 툴바에서 숨김**(AS-IS 도 no-op) |
| EditButton | 908 | no-op | (edit 훅 슬롯 없음 — 미배선) |
| SaveButton | 942 | no-op | hotkeyConfig.save=false — 툴바 Save 숨김. **위임 저장/해제는 SearchArea SAVE/UnSet 버튼**(DelegateForm onSave=handleSave / onUnset=handleUnset, AS-IS 헤더 btnSave/btnUnSet 재현) |

## 5b. 콤보 EE 제외 후처리 필터 (convert-core §2.6 / AGENT.md 규칙3 — gap-resolve iter-1 정정)

AS-IS `InitControls`(cs:137) `dtMyDivision = dtMyDivision.Select().Where(c => c["CODE"] != "EE").CopyToDataTable();` — 콤보 `MyDivisionInEE_SCP` 는 SP 레벨에서 EE(전극) division 을 포함하나 화면이 바인딩 직전 **EE 를 클라에서 제외**한다. 무권한 판정(cs:139)도 EE 제외 후 집합 기준. 이 후처리 필터는 이관 CMBO SQL 에 없다(design 02 §2.1/§6·03 §0 가 Roslyn `filterCalls=0`(인라인 LINQ 미검출)에 근거해 "EE 포함"으로 오판정) → convert-core §2.6·AGENT.md 규칙3 대로 **FE 클라 필터로 재현**(`Delegate.tsx` divisionRows `.filter(CODE !== 'EE')`). design 02/03 의 "EE 포함" 결론은 오류이며 design-filter 정정 권장.

## 6. 이월/한계 (정직 보고)

- **UNSET raw 키(design 03 §6 #1)**: GET rs1 은 LAST_UPDATED_BY 를 "이름(id)" 표시문자열로만 반환 →
  handleUnset 은 DELEGATEE_ID(hidden raw) 우선 + LAST_UPDATED_BY 괄호 id 파싱으로 도출. SP 반환 확장(raw
  LAST_UPDATED_BY/FROM/TO/LAST_UPDATE_DATE)은 convert-sp 에서 권장(파싱 의존 제거).
- **MSG00296/00297**(수임자 타 위임/중첩 수임 현황): AS-IS 는 이 둘을 dtFind_Data(=GET rs1, 내가
  위임한 목록)에서 클라 판정한다(cs:430/444, 별도 SP 조회 아님) → FE 도 rs1 클라 선검증으로 동일
  재현(gap-resolve iter-1). SAVE_DELEGATE SP 의 최종 재검증은 서버측 방어로 별개(convert-sp).
- **미존재 MSG 8종**(298/305/134/219/296/297/300/301/302): TO-BE SCM_ADM_MSG_M 미등록(실측 0건) →
  영문 defaultValue fallback 노출. 정식 등록(KO/EN/CN)은 후속(Hook #114).
- **런타임 미검증**: PKG_SSP0020 MISSING 이라 GET/SAVE/UNSET/USER_CHECK 실행·브라우저 육안은 미완
  (사용자 확인 축). convert-sp 배포 후 runtime-parity 로 검증.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목)

> 원천: 통합테스트 사전점검 1st 구분='Common'. 개별 화면 md 에 없는 전 UI 공통 요구 —
> asis_mapping_gate.py 가 상수 보유, --check 가 부재/미판정 행을 FAIL 처리. SSP0020 은
> 읽기전용 2그리드 + 폼입력 저장(그리드 dirty 아님) 화면이라 편집·신규행·컬럼설정 축은 해당없음.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가행 노출 |  | 그리드 신규행 Insert 없는 화면 — 전 칼럼 LockColumn 읽기전용, toolbar Insert no-op, 저장은 폼입력 INSERT(design 01 toolbar / 03 §4) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 조회 시 'MSG00703' confirm |  | 그리드 인라인 편집 없음(전 칼럼 읽기전용) → dirty '수정 중' 상태 자체가 없음 | 해당없음 |
| COMMON:UC-03 | Column/Measure 설정 적용 시 데이터 Reset 후 재조회 |  | Measure 미사용(non-pivot, SHEET_MEASURE 0건) + btnMeasure 미렌더(R6) — 컬럼/Measure 설정 진입점 없음 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단중앙 Toast 자동소멸 | Delegate.tsx:204,276 (handleSave/handleUnset 성공 → setToast type='success') |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 Code 아닌 Name 출력 |  | 그리드 셀 콤보 0건(FPComboBox 0) + 사용자 컬럼은 SP 가 '이름(id)' 표시조립(Code 아님) → Excel(SubTitle 공용) 표시값이 이미 Name | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중입력 전건 조회 |  | key-in 조회조건 없는 화면 — GET=p_user_id/p_language 만, 입력영역(Division/Period/Delegatee)은 저장용(design 02 §5) | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회해도 조회+필터 유지(rebindFilterColumns) | Delegate.tsx:330-331 (SubTitle gridFilter=activeFilterRef) + components/DelegateGrid.tsx:14 (gridFilterRef — 공용 DataGrid FlexGridFilter 유지) |  | 구현 |
