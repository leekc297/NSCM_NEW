# SSP0202 AS-IS → TO-BE 매핑 매트릭스

AS-IS: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0202_ShipmentChangeRequestConfirm.cs`(+`.Designer.cs`)
설계: `.atlas/gscm-design/SSP0202/design/00~03`. 규범: convert-core §2.1(11) — validations 12 + buttonGuards 16 전건 매핑.

화면 성격: **조회 전용 승인 화면**. 표준 툴바 Insert/Delete/Save NO-OP, Edit "읽기전용", Find 실동작. 실제 액션은 커스텀 3종(Approval/Reject/SelfReject).

## 1. 컨트롤 → TO-BE (영역별 요약)

| AS-IS | TO-BE |
|---|---|
| usrConditionPanel1(조회조건 7종) | `ShipmentChangeRequestConfirmForm`(SearchArea, 6+Period extra) |
| clbDivision('40' 고정·disable) | Division 상수 '40' + disabled(콤보 조회 없음) |
| clbFromSite(다중+ALL) | From Site `CustomDropdown` multiple+allOption, `FromSiteByDivisionOspPack` |
| cboStatus(기본 Q) | Status `useTabLookupQueries(CHANGE_REQ_STATUS)`, 기본 'Q', ALL 선두 |
| cboChangeType(기본 ALL) | Change Type `useTabLookupQueries(CHANGE_REQ_TYPE)`, 기본 'ALL', ALL 선두 |
| drpPeriod(D-14) | `PeriodField`, 기본 today-14 ~ today |
| txtRequest+btnRequestUser | Requestor 입력 + 돋보기 → `SsoUserModal`(SSO=N) |
| txtItemID+btnItemId | Item 입력 + 돋보기 → `ItemByDivisionModal`(division='40') |
| spdMain(siMain 22열) | `ShipmentChangeRequestConfirmMainGrid`(DataGrid, isReadOnly, allowMerging) |
| txtApprovalDeptName(FpSpread=siSub 50열, 오명명) | `ShipmentChangeRequestConfirmSubGrid`(DataGrid, 2단헤더, isReadOnly) → `detailGrid` 로 정정 |
| 디테일 폼 8필드 + txtRejectReason | `ConfirmDetailPanel`(8 읽기전용 + rejectReason 입력) |
| btnApproval/btnReject/btnSelfReject(초기 숨김) | `customButtons` 조건부(canApprove/canReject/canSelfReject) |

## 2. validations 12건 (§3v) → TO-BE

| # | msgId(AS-IS) | 조건 | TO-BE 매핑 | 위치 |
|---:|---|---|---|---|
| 1 | MSG00109 | EditButton "읽기전용" | NSCM 표준 툴바에 Edit 없음 — 조회전용 화면이라 개념 부재. MSG00109(TO-BE 실측 "Read-only mode.") 상수 보유(READ_ONLY), 하드코딩 대체 안내 불필요 | constants MSG.READ_ONLY |
| 2 | MSG00109 | (dead: cs:565 return 이후) | 도달불가 — 미이식(설계 명시 dead) | - |
| 3 | MSG00284 | SaveData 실패(보안조치) | SAVE 실패 surfacing. **AS-IS MSG00284 ≠ TO-BE MSG00284("grid not ready")** → 역조회 MSG00003("Failed to save.") 사용 | constants MSG.SAVE_FAIL |
| 4 | MSG00204 | 시스템오류(arg=change_req_no) | 역조회 MSG01215("system error... Request No : {0}") | constants MSG.SYSTEM_ERROR |
| 5 | MSG00267 | ERP I/F 차단(chkERPIFBlockYn) | `checkErpBlock`(SSPBlockCheckIF_SCP) → 역조회 MSG01395 | actions hook + runAction |
| 6 | MSG00291 | 엔진 수행중(EngProcessingChk) | 역조회 MSG01294("SSP Daily Plan Processing now... {0} minutes"). 서버판정=PKG_SSP0202 SP(미배포) — SAVE 응답 surfacing(convert-sp) | constants MSG.ENGINE_PROCESSING |
| 7 | MSG00192 | 자기반려 확인 | 역조회 MSG01205 confirm | runAction(SELF_REJECT) |
| 8 | MSG00181 | 자기반려 사유 필수 | MSG00181(TO-BE 실측 일치) alert·차단 | runAction 사유 가드 |
| 9 | MSG00191 | 반려 확인 | 역조회 MSG01204 confirm | runAction(REJECT) |
| 10 | MSG00181 | 반려 사유 필수 | MSG00181 alert·차단 | runAction 사유 가드 |
| 11 | MSG00362 | CONFIRM_ID 존재 시 저장불가(chkSaveYN) | 역조회 MSG01356("...Confirm ID occurred in SCS..."). 서버판정=PKG_SSP0202 SP(미배포) — SAVE 응답 surfacing(convert-sp) | constants MSG.CONFIRM_ID_EXISTS |
| 12 | MSG00190 | 승인 확인 | 역조회 MSG01203 confirm | runAction(APPROVAL) |

## 3. buttonGuards 16건 (§4d) → TO-BE (순수가드 hasMessage=false 12건 필수 이식)

| # | method | condition | hasMsg | TO-BE 매핑 |
|---:|---|---|:--:|---|
| 1 | EditButton | fps==null | false | NSCM Edit 부재 — 해당 없음 |
| 2 | CellDoubleClick | siMain.IsLock==true | false | 조회전용 그리드 상시 Lock — 더블클릭 항상 진행(진입조건 자동 성립) |
| 3 | CellDoubleClick | Rows.Count<=0 | false | 셀 히트로 행 존재 시에만 `onRowDblClick` 호출(MainGrid handleDblClick) |
| 4 | SelfReject | siSub.RowCount==0 | false | `runAction`: subRows.length===0 → return(무메시지) |
| 5 | SelfReject | chkERPIFBlockYn | false | `checkErpBlock` → 차단 |
| 6 | SelfReject | MSG00192 No | false | confirm(MSG01205) 취소 시 return |
| 7 | SelfReject | rejectReason 빈값 | true | 사유 필수(MSG00181) |
| 8 | Reject | siSub.RowCount==0 | false | runAction return |
| 9 | Reject | chkERPIFBlockYn | false | checkErpBlock |
| 10 | Reject | MSG00191 No | false | confirm(MSG01204) 취소 |
| 11 | Reject | rejectReason 빈값 | true | 사유 필수(MSG00181) |
| 12 | Approval | siSub.RowCount==0 | false | runAction return |
| 13 | Approval | chkSaveYN==false | true | CONFIRM_ID 존재(MSG01356) — 서버 SP(convert-sp) surfacing |
| 14 | Approval | !EngProcessingChk | false | 엔진 수행중(MSG01294) — 서버 SP(convert-sp) surfacing |
| 15 | Approval | chkERPIFBlockYn | false | checkErpBlock |
| 16 | Approval | MSG00190 No | false | confirm(MSG01203) 취소 |

가드 순서(Approval): RowCount0 → chkSaveYN → EngProcessingChk → chkERPIFBlockYn → confirm(MSG01203).
TO-BE runAction: RowCount0 → (사유 해당없음) → chkERPIFBlockYn(실동작) → confirm. chkSaveYN/EngProcessingChk 는 PKG_SSP0202 미배포로 **SAVE SP 응답 surfacing 으로 이연**(convert-sp) — 04 리포트 명시.

## 4. 동적 규칙 (영역1/3)

- 액션버튼 Visibility(A1~A9): `canApprove = status==='Q' && (APPROVAL_USER===sesUserId ‖ delegatee===sesUserId)`, `canSelfReject = status==='Q' && REQUEST_USER===sesUserId`. **userId 데이터 비교(그룹권한 금지, hook #128)**. delegatee=Delegate_Load(SHEETS.DELEGATE) 반환 DELEGATEE_USER, fallback 마스터행 DELEGATEE_USER.
- siSub 컬럼세트 분기(design 03 §2): `changeType==='P'` → ERP_SO_NO hide + 그룹라벨 "Plan"/"Confirm"; else → ERP_SO_NO show + "Confirmed"/"Change"(메타 SCLS). `applyChangeTypeBranch`.
- 셀 병합(SmartColMerge siMain/siSub): `allowMerging=Cells` + CustomMergeManager. TopChange 재병합 = Wijmo sticky 자동(grid-behavior-parity §1.3).
- 전열 LockColumn: 전 그리드 `isReadOnly=true`(편집 컬럼 0).

## 5. 확인 필요 / 이연 (정직 보고)

- PKG_SSP0202 미배포(SP MISSING) — 조회/저장/서버체크(chkSaveYN/EngProcessingChk/GetErpIFCheck/Delegate_Load) 런타임 미검증. convert-sp 후속.
- Delegate_Load 반환 컬럼명(DELEGATEE_USER) 추정 — SP 배포 후 확정(design 03 §6, 01 §5).
- Item 팝업 scmSite=fromSite 사전필터: 현재 divisionId+itemId 만 전달(자매 known-good). scmSite 전달은 경미 이연.
- NICK_NAME(siMain SN8) main GET SP 미반환 / CHANGE_REASON_CODE 셀콤보 ATTRIBUTE1 공란 — design 04 CN 이월.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> SSP0202 는 승인 화면(두 그리드 읽기전용·전열 INPUT_TP_CD='S', 셀콤보 7종 표시전용, Insert/Delete/Save=NO-OP, 저장은 액션버튼 Approval/Reject/SelfReject). 공용 DataGrid·gridAction·useMessageStore 위임 축 포함.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | - | 두 그리드 전열 읽기전용(isReadOnly). Insert=NO-OP(`() => undefined`), 신규행 생성 없음(저장은 액션버튼). 미해당 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm | - | 편집 컬럼 0(전열 INPUT_TP_CD='S'). 그리드 인라인 편집 없음 — 미저장 수정 상태 부재로 재조회 confirm 미해당 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | - | Column/Measure 설정 버튼 없음(Measure 0, GridColumnSet 미배선). 사용자 컬럼 편집 UI 부재 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | ShipmentChangeRequestConfirm.tsx:204 | 승인/반려 액션 성공 시 `setToast`(useMessageStore, LGES 표준 하단중앙 자동소멸 Toast, MSG.SAVE_SUCCESS) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 | ShipmentChangeRequestConfirm.tsx:276 / packages/foundation/src/utils/gridAction.ts | 공용 DataGrid `excelFileName` export + gridAction dataMap(CODE→NAME 승계) — 셀콤보 7종(CHANGE_TYPE/SHIPMENT_STATUS/CHANGE_REASON_CODE/Dept×3/FCST_TYPE) Name 출력 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | useShipmentChangeRequestConfirmStore.ts:96-99 | Requestor/Item = `multiLine`(개행·콤마 `split(/[\n,]/)`→join) 다중 입력 전건 전달. From Site=joinOrEmpty. GET SP IN절/TRIM 계약(design 02 §5) | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) | packages/shared/src/components/organisms/data-grid/DataGrid.tsx:55 | 공용 DataGrid 가 `rebindFilterColumns` 사용 — 재조회 시 컬럼 필터 재적용(2 DataGrid 공용) | 구현 |

## 2026-10-07 UI 패리티 이식 (기준 = 자매 SSP0003 의 사용자 피드백 교정분)

> 사용자 지시로 SSP0003 교정분(8c440da7 · cf323c0a)을 항목별 AS-IS 대조 후 선별 이식했다.
> 입력: AS-IS `SSP0202_ShipmentChangeRequestConfirm.cs` 실측 + DB 실측(ora.py 2026-10-07).

### A. DB 실측으로 교정한 전제 (종전 주석이 stale 이었다)

| 항목 | 종전 주석 | 2026-10-07 실측 |
|---|---|---|
| `PKG_SSP0202` | "미배포(convert-sp 후속)" | **PACKAGE / PACKAGE BODY 모두 VALID**. SP 8종 전건 배포 — `_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM` · `_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING` · `_GET_DELEGATEE_LOAD` · `_GET_SCS_CONFIRM_ID_CHECK` · `_GET_SSP_PLAN_PROCESSING_CHECK` · `_SAVE_SHIPMENT_REQUEST_CONFIRM` · `_SAVE_..._CONFIRM_40` · `_SAVE_..._CONFIRM_IF_CHECK` |
| 버튼메타 | — | **등록 완료**: main SEARCH/SAVE/SAVE_40/IF_CHECK/PLAN_CHECK/SCS_CHECK/EDIT/INSERT + sub SEARCH + delegate SEARCH(10행). 즉 서버체크 3종은 **DB 작업 없이 바로 배선 가능**하다 — 차단 사유는 "미배포"가 아니라 **FE 미배선** 이다 |

### B. 이식한 것 (UI)

| ID | 교정 내용 | 근거 | 착지점 |
|---|---|---|---|
| Q-1 | **그리드1 `CHANGE_TYPE`/`SHIPMENT_STATUS` 코드→이름** | 공용 DataGrid 가 `'LookupCommon'`(@lookupType 필수)을 **comboId 로만 중복제거**해 컬럼별 `@lookupType` 을 못 싣는다 → 두 컬럼이 한 쿼리로 합쳐지고 0행 → dataMap null → **코드가 그대로 노출**. SSP0003 cf323c0a 와 동일 결함 | `buildColumns` 가 두 컬럼의 셀콤보 메타(`cellCtrlObjTpCd`/`cellCboDataTp`/`attribute1`)를 벗기고, MainGrid 가 `useTabLookupQueries` 로 직접 조회해 `initialized` 에 등록한 `formatItem` 으로 매 셀 `textContent` 확정 |
| Q-2 | **액션 버튼 3종 상시 노출 + disabled** | AS-IS(cs:1195~1201)는 자격 미충족 시 `Visibility.Never`(완전 숨김)가 **정확한 패리티**다. 그러나 승인자 본인이 아닌 사용자에겐 버튼이 하나도 안 보여 "기능이 없다" 로 읽힌다 — 자매 SSP0003 에서 실사용 신고(2026-09-30). **의도적 드리프트**(사용자 지시 2026-10-07) | `customButtons` 조건부 렌더 → 상시 3개 + `disabled: !canApprove/!canReject/!canSelfReject` |
| Q-3 | **승인/반려 완료 후 하단 초기화** | 처리된 요청의 디테일 그리드·폼·반려사유가 그대로 남으면 아직 승인 대기인 것처럼 보인다(SSP0003 사용자 요청 2026-10-01 동일) | `mutateSave onSuccess` 에 `clearDetail()` 추가(store 에 이미 있던 액션 — 호출부만 없었다) |

### C. 이식하지 않은 것 (AS-IS 실측으로 "SSP0003 고유" 판정)

| 항목 | SSP0003 | SSP0202 AS-IS | 판정 |
|---|---|---|---|
| **셀 병합 정책** | main `AllowMerging.None` / sub `ColumnHeaders` — SSP0003 은 `SmartColMerge` **호출 0건**(dead)이라 병합을 껐다 | **`SmartColMerge` 3회 호출 실재** — `siMain`(cs:640 FindData_Main, cs:1276 TopChange) · `siSub`(cs:709 FindData_Sub) | **현 설정(`AllowMerging.Cells` 양쪽) 유지가 정답**. SSP0003 에 맞춰 끄면 AS-IS 병합이 사라진다 |
| **CHK 컬럼 + 행단위 승인/반려 상태기계** | 있음(siSub CHK, `checkedIds`·`isChkEditable`·`decideChangeStatus`·DE_CONFIRM 이중 SP) | **NOT FOUND** — `CHK` grep 0건. siSub 전열 LockColumn = 조회전용 | **미이식**. 따라서 `SAVE_DE` 메타 부재도 정상이고 단일 payload 저장이 맞다 |
| **Status 기본값 `D`(Drafting)** | Q→D 로 교정(AS-IS SelectedIndex=2 가 CODE 정렬상 Drafting) | `cboStatus.SelectedIndex = 2`(cs:312) — **번호는 같지만 콤보 모집단이 다르다**(SSP0202 는 `setListBox(..., true)` = ALL 선두). 현 `DEFAULT_STATUS='Q'` 가 design 02 §4 판정분 | **변경하지 않음** — SSP0003 값을 그대로 가져오면 모집단 차이를 무시한 추정이 된다. 바꾸려면 SSP0202 콤보 커서 정렬 실측이 선행조건(확인필요) |
| **조회조건 콤보 `'ALL'` 전송** | 8c440da7 에서 division/from/status/changeType 을 `'ALL'` 로 교정 | — | **미이식(이식하면 결함)**. `PKG_SSP0202` body line 351~352 = `AND (TRIM(V_CHANGE_TYPE) IS NULL OR A.CHANGE_TYPE = UPPER(TRIM(V_CHANGE_TYPE)))` — **`'ALL'` 분기가 없다**. `'ALL'` 을 보내면 `CHANGE_TYPE='ALL'` 로 필터돼 **0행**이 된다. 현 `oneOrEmpty`(→ `''` = NULL)가 정답 |

### D. 잔여 미배선 (SP·메타 준비 완료 — 다음 회차에 바로 가능)

1. **`IF_CHECK`** — 승인 성공 후 ERP 적재(`_SAVE_..._CONFIRM_IF_CHECK`, AS-IS `GetErpIFCheck("A")` cs:1411 → `XIF_ERP_SHIP_PLAN_CONFIRM_S` 스테이징). A→E fallback 은 BE/ERP 소관.
2. **`PLAN_CHECK`** — `EngProcessingChk(pDivisionID)`(cs:1387) → MSG01294.
3. **`SCS_CHECK`** — `chkSaveYN()`(cs:1379, `_GET_SCS_CONFIRM_ID_CHECK`) → MSG01356.
4. **`SAVE_40` 분기** — division 앞2자리 '40' 런타임 분기. 현재 `SAVE` 단일 경로만 호출한다.
5. **`delegateeDept`** — 현 payload 에 없다. SSP0003 은 `DELEGATE_COLUMNS`(SP 커서) vs `MASTER_USER_COLUMNS`(GET 커서) 2원천 혼용 결함을 교정했다(2026-09-30). SSP0202 는 ①~④ 배선 시 `_SAVE_..._CONFIRM` 의 `ALL_ARGUMENTS` 실측과 함께 확정.

#### Q-4 컬럼 폭/표시 메타를 SSP0003 과 동일화 (사용자 지시 2026-10-07)

`SCM_MST_SHEET_COLUMNS` FULL OUTER JOIN 실측(ora.py 2026-10-07) 후 **SSP0003 값으로 정렬**했다
(적용 스크립트 `.atlas/gscm-design/SSP0202/design/06_register_column-width-parity.sql` + 롤백 동반).

| 시트 | 결과 |
|---|---|
| main `Shipment Change Request Confirm` | **폭/표시 상이 0건** — 변경 없음(이미 일치) |
| sub `…Confirm Detail` | `ERP_SO_NO` W `0 → 80` · VIS **N → Y** / `REMARKS2` W **80 → 150** |

`ERP_SO_NO` 는 AS-IS else 분기가 보여주는 열인데 메타가 'N' 이라 TO-BE 에서만 사라져 있었다.
FE 는 선택 마스터행 `CHANGE_TYPE='P'` 일 때만 숨긴다(`applyChangeTypeBranch`) — 메타 복원과 양립한다.

**컬럼셋 차이는 변이체 정상이라 손대지 않았다**:
SSP0003 고유 6열(`CHK`·`ERP_ATTR1~3`·`REJECT_REASON`·`STATUS_DETAIL`) — CHK 상태머신은 SSP0003 전용이고
AS-IS SSP0202 에 CHK 신호가 0건이다(실측). SSP0202 고유 2열(`SHIPTO_CODE`·`NEW_SHIPTO_CODE` @70) = Packer 판 컬럼.

**함께 적용(코드)**: sub 그리드 `allowMerging` `Cells → ColumnHeaders`(2단 헤더 그룹라벨 병합) + autoFit 신설
— 자매 SSP0003 sub 와 동일 구성. 상세는 SSP0201 매핑 §G-7 과 같은 근거다.

**검증**: 적용 후 재조회로 **SSP0003 ↔ SSP0202 공통컬럼의 폭/표시 상이 0행** 확인.
