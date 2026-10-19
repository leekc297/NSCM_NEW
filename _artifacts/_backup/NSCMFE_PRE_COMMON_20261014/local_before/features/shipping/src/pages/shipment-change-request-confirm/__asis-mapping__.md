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
