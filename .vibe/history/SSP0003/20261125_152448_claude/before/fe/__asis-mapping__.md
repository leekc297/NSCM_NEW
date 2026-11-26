# SSP0003 AS-IS → TO-BE 매핑 매트릭스

AS-IS: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0003_ShipmentChangeRequestConfirm.cs`(2018행)+`.Designer.cs`
설계: `.atlas/gscm-design/SSP0003/design/00~03`. 규범: convert-core §2.1(11) — validations 23 + buttonGuards 19 전건 매핑.
청사진(자매): `features/shipping/src/pages/shipment-change-request-confirm`(SSP0202 — 동일 화면군, read-only 승인). read 만, import 금지.

화면 성격: **조회 전용 승인 화면**. 표준 툴바 Insert/Delete/Save NO-OP, Edit "읽기전용", Find 실동작. 실제 액션은 커스텀 3종(Approval/Reject/SelfReject).

## 0. SSP0202 vs SSP0003 (별개 화면 — 복제 금지 축)

| 축 | SSP0003 (본 화면) | SSP0202 (자매/청사진) |
|---|---|---|
| Division | 권한범위 **EE 제외 다중** (`MyDivisionInEE_SCP`+클라 EE제거) | '40' 고정 disabled |
| From Site | `PlantSiteByDivision_SCP`(divisionIds cascade) | `FromSiteByDivisionOspPack` |
| siSub 컬럼 | 54 | 50 |
| PKG | `PKG_SSP0003`(배포·VALID) | `PKG_SSP0202`(미배포) |
| ROUTE_PATH | `shipping/shipment-change-request-confirm-ssp0003`(2단, 05_register 정정) | `shipping/shipment-change-request-confirm` |

## 1. 컨트롤 → TO-BE (영역별 요약)

| AS-IS | TO-BE |
|---|---|
| usrConditionPanel1(조회조건 7종) | `ShipmentChangeRequestConfirmSsp0003Form`(SearchArea, 메인 5: Division/From Site/Request Date/Status/Change Type + extra 2: Model/Requestor — design 02 §5) |
| clbDivision(다중+ALL) | Division `CustomDropdown` multiple+allOption, `MyDivisionInEE_SCP`+클라 `CODE!=='EE'` |
| clbFromSite(다중+ALL) | From Site `CustomDropdown` multiple+allOption, `PlantSiteByDivision_SCP`(divisionIds cascade) |
| cboStatus(기본 Q) | Status `useTabLookupQueries(CHANGE_REQ_STATUS)`, 기본 'Q', ALL 선두 |
| cboChangeType(기본 ALL) | Change Type `useTabLookupQueries(CHANGE_REQ_TYPE)`, 기본 'ALL', ALL 선두 |
| drpPeriod(D-14) | `PeriodField`, 기본 today-14 ~ today |
| txtRequest+btnRequestUser | Requestor 입력 + 돋보기 → `SsoUserModal`(SSO=N) |
| txtItemID+btnItemId | Model 입력 + 돋보기 → `ItemByDivisionModal` |
| spdMain(siMain 22열) | `...MainGrid`(DataGrid, isReadOnly, allowMerging) |
| txtApprovalDeptName(FpSpread=siSub 54열, 오명명) | `...SubGrid`(DataGrid, 2단헤더, isReadOnly) |
| 디테일 폼 8필드 + txtRejectReason | `ConfirmDetailPanel`(8 읽기전용 + rejectReason 입력) |
| btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 숨김) | **의도적 드리프트(사용자 지시 2026-09-30)** — 조회영역 `SearchArea.extraButtons` 에 3버튼 **상시 노출 + `disabled={!canApprove/!canReject/!canSelfReject}`**. AS-IS 는 우상단 + 조건부 **숨김**(§2-A A1~A4). 근거: DB 실측 `SSP_ANL_SHIP_CONFIRM_CHG_REQ` 의 `CHANGE_REQ_STATUS='Q'` 3,828행 중 `APPROVAL_USER`/`DELEGATEE_USER` 가 보고자 본인인 행이 **0건**이라 Approval/Reject 가 구조적으로 도달 불가였고(Self Reject 는 1건) "버튼이 다 없다"로 보고됐다. 판정식(A2/A4)과 클릭 가드(G2~G17)는 그대로 유지 |

## 2. buttonGuards 19건 (design 01 §2-E) → TO-BE

| # | method | condition | hasMsg | TO-BE 매핑 |
|---:|---|---|:--:|---|
| G1 | EditButton | fps==null (dead) | false | 미이식(§2-B dead, editMode 신설 금지 convert-core §2.4) |
| G2 | CellDoubleClick | siMain.IsLock==true | false | 조회전용 상시 Lock — 더블클릭 항상 진행 |
| G3 | CellDoubleClick | Rows.Count<=0 | false | 셀 히트로 행 존재 시에만 `onRowDblClick`(MainGrid handleDblClick) |
| G2(E) | SelfReject | siSub.RowCount==0 | false | `runAction`: subRows.length===0 → return |
| G3(E) | SelfReject | chkERPIFBlockYn | false | `checkErpBlock`(SSPBlockCheckIF_SCP) → 차단 |
| G4 | SelfReject | rejectReason 빈값 | true | 사유 필수(MSG00181) |
| G5 | SelfReject | !ChkDraftingData("S")=전체체크 | false | **구현(iter-2)** `checkDraftingData("S")` 미체크>0 → MSG00422 차단 |
| G6 | SelfReject | MSG00192 No | false | confirm(MSG01205) 취소 |
| G7~G11 | Reject | RowCount0/ERP/사유/ChkDrafting("R")/confirm | 구현 | RowCount0·ERP·사유(MSG00181)·ChkDrafting(MSG00421 미체크>0)·confirm(MSG01204) 전건 |
| G12 | Approval | siSub.RowCount==0 | false | runAction return |
| G13 | Approval | !EngProcessingChk | false | **구현(iter-2)** `checkEngProcessing`(PLAN_CHECK O_RC1 'Y')→MSG00291 |
| G14 | Approval | chkERPIFBlockYn | false | checkErpBlock |
| G15 | Approval | GetShipmentStatusChk==false | false | **구현(iter-2)** `checkShipmentStatus`(SCS_CHECK O_RC3 행수>0)→D/O Reject('O')+MSG00413 |
| G16 | Approval | !ChkDraftingData("A") | false/true | **구현(iter-2)** 체크0 MSG00420 / 미체크>0&사유공백 MSG00181 |
| G17 | Approval | MSG00190 No | false | confirm(MSG01203) 취소 |

가드 순서(runAction, iter-2): RowCount0 → (승인)EngProcessingChk → ERP block → (승인)D/O 체크 → 사유필수(R/S) → ChkDraftingData → confirm → dual-SP 저장. AS-IS BtnApproval/Reject/SelfReject_Click 순서 1:1.

## 3. 동적 규칙 (영역1/3)

- 액션버튼 Visibility(§2-A A1~A5): `canApprove = status==='Q' && (APPROVAL_USER===sesUserId ‖ delegatee===sesUserId)`, `canSelfReject = status==='Q' && REQUEST_USER===sesUserId`. **userId 데이터 비교(그룹권한 금지, hook #128)**. delegatee=Delegate_Load(SHEETS.DELEGATE) 반환 DELEGATEE_USER, fallback 마스터행 DELEGATEE_USER.
- siSub 컬럼세트 분기(design 03 §2): `changeType==='P'` → ERP_SO_NO hide + 그룹라벨 "Plan"/"Confirm"; else → ERP_SO_NO show + "Confirmed"/"Change"(메타 SCLS). `applyChangeTypeBranch`.
- 셀 병합: **AS-IS 무병합**(SmartColMerge 주석·Add*Column FPMerge dead block, react-gap-audit iter-1 SSP0003-06) → `allowMerging=None`(iter-2 파리티 교정, grid-behavior-parity §1).
- CHK 상태머신(iter-2, design 03 §3.4): siSub CHK 만 조건부 활성 — status else(Q) 만 사용자 토글, 그 외 표시·잠금. formatItem 체크박스 렌더 + 헤더 전체선택 + 클릭토글(EditTracker 미개입). 초기 체크셋 `computeInitialCheckedIds`(E/O/R/S 해제·D/A 체크·P 행별 STATUS_DETAIL·else 체크). AS-IS FindData_Sub L722-761.
- 전열 LockColumn: 전 그리드 `isReadOnly=true`(CHK 외 편집 컬럼 0).
- 편집모드 미이식: EditButton SwitchLock(gridSignal #34) dead — `editMode`/`setEditMode` 신설 금지(convert-core §2.4). read-only(canEdit=hasButton('EDIT')).

## 4. 조회조건 콤보 파리티 (design 02, convert-core §2.6)

- Division `MyDivisionInEE_SCP` + FE 클라 `CODE!=='EE'` — AS-IS(MyDivisionInEE+클라EE제거) 등가. `MyDivision`(정렬 ATTRIBUTE1) 재사용 회피(design 02 §2.1 권장안).
- From Site `PlantSiteByDivision_SCP`(divisionId cascade). EE 분기(`ShipmentPlanPlantSite_SCP`)는 clbDivision EE제거로 도달불가 → **미이식**(design 02 §2.2).
- `SetChangedPeriod`/`PERIOD_` dead code 미이식(comboCall #3). `SSPBlockCheckIF_SCP` 는 콤보 아님(버튼 가드로 편입).

## 5. 확인 필요 / 이연 (정직 보고 §4.3)

- **CHK 상태머신 + per-row dual-SP 저장(iter-2 구현)**: design 03 §3.4/§4.4 이식 완료 — CHK 인터랙티브 + SaveDraftingData(DE_CONFIRM 7 IN) + SaveData(CONFIRM/_40 36 IN) 체크행 NEW_* CLOB 콤마 + change_status A/R/P. SP 파라미터=ALL_ARGUMENTS 실측, 컬럼명=SCM_MST_SHEET_COLUMNS 실측. **런타임 결합은 PROC_M(convert-sp) 등록 대기** — 04_react-gap §5 #1.
- ChkDraftingData(MSG00420/421/422)·EngProcessingChk(MSG00291)·GetShipmentStatusChk(MSG00413) 가드 iter-2 구현. TO-BE MSG 미채번(420/421/422/413)은 영문 fallback(Hook #114).
- GetErpIFCheck A→E fallback(AS-IS SaveData('E'), ERP IF 실패 분기)만 미이식 — 주경로 정상, 후속(04 §5 #2).
- Delegate_Load 반환 컬럼명(DELEGATEE_USER/DELEGATEE_DEPT) 추정 — SP 실행 대조로 확정.
- Model 팝업 division/scmSite: 다중선택 중 첫 값 전달(divisionIds[0]/fromSiteIds[0]). 다중 전달은 후속 확정.
- 브라우저 시각·조작감(체크박스/전체선택 렌더·2단헤더·toast·확인 다이얼로그 문구)은 사용자 확인 축 = 미완.
