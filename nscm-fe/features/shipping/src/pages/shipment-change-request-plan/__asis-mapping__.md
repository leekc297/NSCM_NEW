# SSP0200 AS-IS ↔ TO-BE 매핑

| 항목 | 값 |
|---|---|
| 화면코드 | `SSP0200` — Shipment Change Request |
| AS-IS 정본 | `GSCM/06.UIL/GSCM.SSP.Forms.UIL/Plan/SSP0200_ShipmentChangeRequest.UIL/SSP0200_ShipmentChangeRequest.cs` (6,906행) + Designer(1,780행) |
| TO-BE | `nscm-fe/features/shipping/src/pages/shipment-change-request-plan/` |
| 설계 정본 | `.atlas/gscm-design/SSP0200/design/00_checklist.md` · `01_layout.md`(v3) · `02_search-combo.md` · `03_grid-columns.md` |
| 자매 주의 | `features/shipping/src/pages/shipment-change-request` 는 **SSP0201(Packer 판)** 으로 별개 화면이다. 컬럼셋(68/56 vs 65/58)·`hotkeyConfig`·MENU_ID·AS-IS 소스(`GSCM.SSP.Plan.UIL/SSP0201_*.cs` 5,838행) 전부 다르다 → **파일 복사 금지**. 단 **UI 수정 금지는 해제됐다**(사용자 지시 2026-10-07): SSP0200 의 사용자 피드백 교정분을 **항목별로 AS-IS 대조해 선별 이식**한다. 이식/비이식 판정은 SSP0201 `__asis-mapping__.md` 의 「2026-10-07 UI 패리티 이식」 절이 정본 |
| 폐기 입력 | `design/_superseded-planuil-copy/**`, `roslyn/*PlanUIL*` 은 **틀린 사본** 백본 — 입력에서 제외했다 |

매핑의 단위는 **설계 문서의 규칙 ID** 다. 설계 3영역이 이미 백본 전건(영역1 155 / 영역2 42 / 영역3 437)을
규칙 ID 로 1:1 소진해 두었으므로, 여기서는 그 ID 가 TO-BE 어디에 착지했는지와 **미이식 근거**를 남긴다.
원 신호번호 단위 열거는 `01_layout.md §2` / `02_search-combo.md §2~§5` / `03_grid-columns.md §3` 이 정본이다.

---

## 1. 영역1 레이아웃 (L-001 ~ L-155)

| 규칙 ID | AS-IS | TO-BE 착지점 | 상태 |
|---|---|---|---|---|
| L-001 | `splitContainer1` Orientation=Horizontal(=상/하), SplitterDistance=253 | `ShipmentChangeRequestPlan.tsx` `<PanelGroup orientation='vertical'>` 상 39 / 하 61 |  | 구현 |
| L-002·L-003·L-005 | `usrConditionPanel1`(HidePanel) + `usrLayoutControl1` | `<SearchArea>` + `MainTitle openSearchArea` | 구현 |
| L-006 ~ L-011 | `panel3` / `panel1` / `usrLayoutControl2·3` | `RequestInfoPanel` + `RequestActionBar` + `ChangeRequestPlanSubGrid` | 구현 |
| L-012·L-013 | `usrLabel2` 섹션 헤더(정적, `.cs` 참조 0건) | 미이식 — 정적 장식 라벨, TO-BE 폼에 대응 영역 없음 | 미이식(장식) |
| L-014·L-015·**L-126** | `layoutControlItem5`/`txtRequestNo` — `Visibility=Never`(cs:459, 조건 없는 상시 숨김) | 입력란 **렌더 안 함**. 값은 store `requestInfo.requestNo` 로만 보관 | 구현 |
| L-016 ~ L-019·**L-148** | 요청자/부서 세션 주입(언어별 `UserName`/`UserName_E`) | `useShipmentChangeRequestPlanStore.initSessionFields()` + `setRequestorFromServer()` | **부분구현** — TO-BE `UserSession` 에 부서 필드가 없다(실측: groupId/langCd/userId/userEngNm/userNm/div/menus). 이름은 세션, 부서는 detail 조회 `o_rc2` 로 보완했다 |
| L-020 ~ L-023·L-024·L-026·**L-078·L-125** | `btnApprovalUser` → `SSP0002_UserInfoPopup` 단일선택 → 4값(ID/이름/부서명/부서ID) | 공용 `SsoUserModal`(`ssoUserYn='N'`) → `approvalId`/`approval` 2값 | **부분구현** — 공용 모달의 `setSelectedValue` 계약이 `(userId, userNm, userEngNm)` 3값이라 **부서 2값을 돌려주지 않는다**. `packages/shared` 수정은 Hard Boundary 위반이라 하지 않았다. 승인부서는 `o_rc2` 자동채움(L-152) 경로로만 채워진다 |
| L-025·L-029·L-031·L-034·**L-142·L-143** | `SetChangeRequestInfo` ReadOnly/Enabled 토글 | **미이식** — 메서드 호출 0건(참조 cs:1895·1969·2106 전부 주석). Δ5. 이식하면 AS-IS 에 없는 잠금이 생긴다 | 미이식(dead) |
| L-027·L-028·L-030·L-032·L-033 | Title/Change Reason/Reason Detail 필수 3필드 | `RequestInfoPanel` `required` + `checkRequestInfoRequired()` | 구현 |
| L-035 ~ L-038 | `btnChangeRe2`(Request Complete) / `btnCancel`(Cancel) | `RequestActionBar` Primary/Secondary **2개만** | 구현 |
| **L-039 ~ L-046** | `lcSave`/`btnSave`(Save Draft) · `lcDel`/`btnDel`(Delete) · `lcAdd`/`btnAdd`(Add Date) · `lcDate`/`dtDate` | **미이식** — Designer `Visibility=Never` 4건(D:1241/1155/1142/1192) + 일부 `Visible=false` = 2축 dead(Δ4). 되살릴 유일 경로 `SetButtonVisual(bool)` 은 **호출 0건**(L-154) | 미이식(dead 8) |
| L-047 ~ L-049·L-053 ~ L-056 | 조회조건 라벨 | `ShipmentChangeRequestPlanForm` `t(LBL…)` | 구현 |
| **L-050** | `PlanType1`(Change Type 라벨/콤보) `Visibility=Never`(D:839), `.cs` 참조 0건 | **노출로 이식(의도적 차이)** — AS-IS 는 영구 비노출(Δ1)이나 이 콤보가 화면 모드 스위치(기간 재산출 + 컬럼 폭 0 + 양 그리드 재구성)라 숨기면 모드 전환 수단이 사라진다. `extraConditions` 3단에 배치. **배치·노출 여부는 확인필요(04 #4)** | 초과구현(근거 명시) |
| L-051·L-052 | `chkSingleProcess`(live) | Form `extraConditions` 체크박스 + store `singleProcess` → SO 전파 분기 | 구현 |
| L-057 | LCG1 잔여 라벨/여백 4건 | SearchArea grid 배치로 흡수 | 흡수 | 구현 |
| L-058 ~ L-060 | 승인자/취소/요청완료 Click | `handleApproval…` / `handleCancel` / `handleRequestComplete` | 구현(요청완료는 SP 미배포로 실행체인 미완) |
| **L-061·L-077·L-084 ~ L-086·L-103·L-104** | `BtnSave_Click` 경로 7건 | **미이식** — 버튼이 dead(L-040) | 미이식(dead 7) |
| L-062·L-063 | `VisibleTab(true)` 2건 | **시트 탭 UI 없음** — FarPoint 시트 탭 스트립이지 화면 탭이 아니다. master/detail 은 상하 split(hook #81 미해당) | 구현(판정) |
| L-064 | `GET_CHANGE_REQ_NO` 채번 | `hooks/useShipmentChangeRequestPlanPreChecks.ts:64` `post(BTN_GET_CHANGE_REQ_NO, { userId })` → `o_rc1` 첫 행 `'S'` 일 때 채번값 | 정정(convert-gap-resolve iter-1): iter-1 의 "API/버튼 메타 미등록" 은 **stale** 이다. ora.py 2026-09-28 실측 = `SCM_ADM_MNU_BTN_MPG_M`(SSP0200, main, `GET_CHANGE_REQ_NO`) → `API_ID='P_SSP0200_GET_CHANGE_REQ_NO'`, `USE_YN='Y'`(iter-3 `05_register_prechecks.sql` 적용분) + `PKG_SSP0200` 멤버 실재. FE 배선도 완료 | 구현 |
| **L-065·L-070·L-071** | `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · `SCM_SSP_DELETE_..._BY_CONFIRM` · `PR_SSP_XIF_..._IFSEQ_MERGE` | **미구현** — `PKG_SSP0200` 에 없음(SP 6건 미이관, convert-sp 후속) | 미구현(SP) |
| L-066 ~ L-069 | `DELETE_..._DRAFTING` / `GET_SHIPMENT_STATUS` / `GET_ERP_SO_NO_CNT` | 배선 메타(`05_register.sql` API 6행)만 등록. 호출부는 확정 체인과 함께 보류 | 미구현(체인) |
| L-072 | `FindButton` = `FindData_Main(); FindData_Sub_Draft();` | `hotkeyConfig.search: handleSearch` — `setFilter()` 가 main·sub filters 를 **동시에** 갈아끼운다 |  | 구현 |
| L-073 | `SaveButton` 6가드 | `handleSave` + `useSaveWithValidation` | 필수검증은 메타 미정비로 미검증 | 구현 |
| **L-074** | `DeleteButton` 본문 `{ }` 완전 공백 = NO-OP | `hotkeyConfig.delete: () => undefined` — **버튼 노출 + 명시적 무동작**. `false`·키 생략 둘 다 금지(생략하면 공용 `removeRow` 가 살아난다) | 구현 |
| L-075·L-076 | 화면 고유 버튼 | `RequestActionBar` | 구현 |
| L-079·L-082·L-102 | `SSPBlockCheckIF` → `BLOCK_YN='Y'` 면 저장 차단 + PERIOD 안내 | `useShipmentChangeRequestPlanValidation.checkErpBlock()` (파라미터 = `MENU_ID` 상수) | 구현(런타임 미검증) |
| L-080 | `IsLock` 시트 잠금 가드 | **미이식** — 편집모드 기본 ON(convert-core §2.4). 대신 `hasButton('SAVE')` 로 버튼 자체를 게이트 | 미이식(결정) — AS-IS 가 dead/장식이거나 의도적 미이식 결정. 상세는 §5 미이식 결정 요약 | 제외 |
| L-081 | `SheetName == shtMain` 일 때만 저장 | `handleSave` 가 master 그리드(`mainGridRef`) 전용 |  | 구현 |
| L-083·L-089 | 변경분 0 → `MSG00133` | `dirty.length === 0` → alert | 구현 |
| L-087 | `checkRequired()` 실패 시 조용히 return | `checkRequestInfoRequired()` — 개별 필드 메시지는 내부에서 낸다 |  | 구현 |
| **L-088** | `BtnCancel_Click` — detail 0행이면 **알림 없이 무동작** | `if (subRows.length === 0) return;` (alert 없음 = 패리티) | 구현 |
| L-090 ~ L-121 | 검증 메시지 33건 | 아래 §4 i18n 표 | 구현/미구현 혼재 |
| L-122 ~ L-124 | `ProgressForm` 3건 | 공용 로딩(react-query `isFetching`) — 전용 컴포넌트 불요 | 구현(공용 흡수) |
| **L-127·L-128** | Division 권한 0건 → 조회영역 전체 잠금 + `return`(이후 초기화 전부 중단) | `handleSearch` 의 `!sc.divisionId` 게이트 + `MSG00667`. **"반쪽 화면" 부분 초기화 상태는 흉내내지 않았다** — 권한 없음 단일 상태로 표현(설계 §4.4 지침) | 부분구현(의도적 차이) |
| **L-129 ~ L-141** | `lcSave.Move` 1건 + `SetButtonVisual` 12건 | **미이식** — 대상 컨트롤이 전부 `Never` 이고 메서드 호출 0건 | 미이식(dead 13) |
| L-144 ~ L-147 | Designer `Never` 4건 | §1.3 dead 판정 근거 | 미이식(dead) |
| L-149·L-150 | `CHANGE_REQ_DAY`(`D`/`-56`) → `dDay` → `dBaseDate = 오늘 + dDay` | **미구현** — 출하일 하한 검증(`MSG00194`)의 기준일. inner-table 환산식 미확정(설계 R-3) + 이 값을 소비하는 `SHIPMENT_DATE` 하한 검증 자체를 이번 회차에 걸지 않았다 | 미구현 |
| L-151 | `SHIPMENT_PERIOD_DAY`(`1D+`=56 / `2D-`=30) → 출하일 상·하한 | 없음 | 미구현 — inner-table 환산식(설계 R-3) 미확정 + 콤보 `SHIPMENT_PERIOD_DAY_SCP` 의 `SEGMENT1` 값에 Oracle 연결연산자 2개가 그대로 남은 형태(`1D` + 파이프2 + 공백) 불일치 결함(설계 §6 #8) 미해소. 상·하한 자체는 `CHANGE_REQ_DAY` lookup 축으로 iter-3 에 구현됨(별개 축) | 미구현 |
| **L-152** | 조회 SP 2번째 커서로 승인자 **빈칸일 때만** 자동채움 | `ShipmentChangeRequestPlan.tsx` `o_rc2` useEffect → `fillApprovalIfEmpty()` (이미 값이 있으면 덮지 않는다) | 구현 |
| L-153 | `txtItemId` — Designer 인스턴스화만, `Controls.Add` 0건 | **미이식** — Model 조회조건의 실제 원천은 `txtRequest` 다 | 미이식(dead) — AS-IS 가 dead/장식이거나 의도적 미이식 결정. 상세는 §5 미이식 결정 요약 | 제외 |
| L-154·L-155 | `SetButtonVisual` / `bReadOnly` / `SetImageCell()` | **미이식** — 호출 0건 / 대입 0건 / 본문 공백 | 미이식(dead 3) |

**영역1 dead 미이식 합계 = 38행** (토글 4 + 하단 dead 컨트롤 8 + `PlanType1` 1 + `BtnSave_Click` 경로 7 +
`lcSave.Move` 1 + `SetButtonVisual` 12 + `SetChangeRequestInfo` 2 + dead 필드·메서드 3).
단 `PlanType1`(L-050)은 위 표대로 **의도적으로 노출**해 dead 미이식에서 제외했고 근거를 남겼다 → 실 미이식 37.

---

## 2. 영역2 조회조건 (42행)

| 축 | AS-IS | TO-BE | 상태 |
|---|---|---|---|---|
| 9필드 인벤토리 | Div / From Site / To Site / Status / Shipment Date / Model / SO No / Confirm Id / Change Type | `ShipmentChangeRequestPlanForm` — 메인 8 + `extraConditions` 2(Change Type + Single Process) | 구현 |
| 필드 수 > 6 | — | `extraConditions` 분리(hook #52) | 구현 |
| **C1** | `dtChangeStatusCode.Rows.RemoveAt(0)` = Status 콤보에서 `P`(Plan) 제거 | `.filter(r => r.CODE !== 'P')` | 구현 |
| **C2·C3** | `CODE != "EE"` — **완전일치 1건만** 제외 | `.filter(r => r.CODE !== 'EE')`. `ATTRIBUTE3<>'EE'` 형 SQL_ID 를 쓰면 `EE_HD/EE_HG/EE_HM/EE_ST/EE_UC` 5건이 사라지므로 쓰지 않았다 | 구현 |
| **C4** | `JVFlag = dtMyDivision[ATTRIBUTE1] == '0'` | **미구현(false 고정)** — 원천 `SSP0200_GET_SHIPMENT_DIVISION` 미이관. 대체 콤보 `MyDivisionInEE_SCP` 는 `ATTRIBUTE1` 을 반환하지 않는다. store `jvFlag: false` 로 **명시 보관**(조용한 기본값 아님) | 미구현(SP) |
| **C5** | `GetCheckedListValue(..., !JVFlag)` — 3번째 인자 false 면 **선택을 무시**하고 권한 전체 CODE 를 콤마 전개 | `setFilter()` 에 분기 코드는 구현했으나 `jvFlag` 가 false 고정이라 **분기가 발동하지 않는다** | 배선구현 / 발동 미구현 |
| cascade 5단계 | Div → From/To Site **서버 재조회**, ChangeType → 기간 재산출 + 요청정보 초기화 + 양 그리드 재구성 | `changeDivision()` / `changeChangeType()`. `Filter*` 접두(클라 좁힘) 콤보 0건 | 구현 |
| Div 변경 그리드 초기화 | `InitSpread(siMain)` | **의도적 미이식(드리프트, 사용자 지시 2026-10-01)** — Div 변경만으로 그리드를 비우지 않는다. `changeDivision()` 은 From/To Site cascade 재설정 + `fetchStaticColumns(newDivision)` 만 하고 `filters`/`hasSearched` 는 유지한다(재조회 시 `setFilter` 로 교체). | 미이식(의도) |
| 초기 mount 무발화 | `InitEvent()` 가 마지막이라 초기 설정이 cascade 를 트리거하지 않는다 | mount effect 는 `clearFilters()` + 기간 SP + 컬럼메타만. Div 기본값은 `set({divisionId})` 로만 넣고 `changeDivision()` 을 부르지 않는다 | 구현 |
| 자동조회 금지 | `FindData_Main` 은 `FindButton` 에서만 | `enabled: !!filters[...]` | 구현 |
| payload 12키 | cs:1468~1482 · 1540~1541 | `setFilter()` — 키명은 `SCM_ADM_PROC_M.COL_NM` **실측 대조 완료**(2026-09-27 ora.py, 12 IN 전건 일치) | 구현 |
| Period 기본값 | `GetDayRange("")` = `SCM0001_GET_SCP_DAY_PERIOD` | `fetchDayRange()` → `/SSP0200/main/GET_SCP_DAY_PERIOD/call-proc`. **dayjs 근사 아님**(자매 3화면이 근사로 우회한 것과 다르다) | 구현 |
| Model 팝업 | `SCM0002_ItembyDivisionPopup` — `sdivision` + **`sScmSite`(From Site)** 사전필터, 반환 빈 값이면 기존 유지 | `ItemByDivisionModal` — 빈 값 무시는 구현. **From Site 사전필터는 미전달** (공용 모달 `preSearchParams` 계약에 site 축이 없다) | 부분구현 |
| Designer 잔여 초기값 | `2013-07-12` / `1999-01-01` | 이식하지 않았다 | 구현(제외) |
| `txtItemId`(F1) · FCST Type(B4/F8) | dead | 만들지 않았다 | 구현(제외) |
| `ChangeType='A'` | 목록에 있고 항상 else 경로 | 목록에서 제거하지 않았다 | 구현 |

---

## 3. 영역3 그리드 (R-01 ~ R-80, 437행)

| 규칙 ID | 요지 | TO-BE 착지점 | 상태 |
|---|---|---|---|---|
| R-01·R-02 | `FpSpread` 2 + 이벤트 10 | `…MainGrid.tsx` / `…SubGrid.tsx` | 구현 |
| R-10 | 시트 초기화 폭/라벨/헤더 span/소수 32건 | `shipmentChangeRequestPlanColumns.ts` `buildMainColumns`/`buildSubColumns` |  | 구현 |
| **R-11** | `SetMainStatus` 20건 — 저장 후 master 상태 전파 | **미구현** — ① 메서드 **호출 0건**(Δ6) ② 대입 대상 4열(`REQUEST_USER`/`REQUEST_USER_NAME`/`REQUEST_TIME`/`PLAN_CONFIRM_ID`)이 메타·SP 양쪽에 없어 **AS-IS 에서도 no-op**. **컬럼 신설 금지** | 미이식(dead 20) |
| R-12 | div 40/EE 컬럼 표시 전환(시트 축) 12건 | `buildMainColumns` — **조회조건 division 기준으로만** 잡는다 | 의도적 차이 ↓ | 구현 |
| R-13 | div 셀 변경 cascade(행 축) 23건 | **미구현** — AS-IS 는 행 하나를 바꾸면 컬럼 Visible 을 **전역으로** 흔든다(혼합 division 결함). TO-BE 는 컬럼 축을 조회조건 division 으로 고정했다. 행 단위 차이는 후속 회차에서 셀 값/편집 가능 축으로 표현 |  | 부분구현(의도적 차이) |
| R-14 | TO_SITE/FROM_SITE 변경 → `INCOTERMS`/`TRANSPORT_MODE`/`BOD_ID` 초기화 | `onCellEditEnded` + `clearBodDerived()` | `FindData_BOD` 재조회는 SP 미이관으로 제외 | 구현 |
| R-15·R-16 | INCOTERMS 4중 선행값 가드 → 위반 시 값 롤백 | `incotermsPrerequisiteMissing()` | 구현 |
| R-17 | TRANSPORT_MODE 선행값 가드 | `transportModePrerequisiteMissing()` |  | 구현 |
| R-18 | BOD 0행 처리 | 미구현 — `FindData_BOD` 자체가 없다 |  | 미구현(SP) |
| R-19 | `EDIT_MAIN` 마킹 19건 (`'-'` 선택 시 `'N'`) | `setEditMain()` / `applyChangeReasonCode()`. `CRUD_TYPE` 과 **별개 축** 유지 |  | 구현 |
| R-20·R-21 | 동일 SO 전파 + 행상태 `'M'` | `soGroupRows()` + `markPropagated()`(`CRUD_TYPE='U'`). `chkSingleProcess` 체크면 자기 행만 | 구현 |
| R-22 | `SHIPMENT_DATE` 검증·파생·전파 11건 | `deriveShipmentDate()` — `NEW_LT_DAY` 공백이면 **파생 없음**. **단 `dBaseDate` 하한 검증(MSG00194)은 미구현**(L-149/L-150 참조) |  | 부분구현 |
| **R-23** | TRANSPORT_MODE 의 `NEW_*` 9열 파생 | **미구현이 정답** — AS-IS 대입문이 **전부 주석**(cs:5819~5831·5844~5856). 구현하면 AS-IS 초과다. 패리티 목표는 "전파 + `EDIT_MAIN='Y'`" 뿐 | 미이식(dead, 의도) |
| R-24 | CHANGE_REASON 연동 11건 | `applyChangeReasonCode()` + `isReasonCodeMissing()` + SO 전파 |  | 구현 |
| R-25 | `ERP_STATUS='C'` 수정 차단 | `isRowEditable()` + `beginningEdit` 선차단. **AS-IS 는 값이 바뀐 뒤 막지만 TO-BE 는 진입 자체를 막는다**(의도적 차이 — 데이터 오염 방지) | 의도적 차이 | 구현 |
| R-26 | `setEndCustomer` 자동선택/합성 4건 | **미구현** — `END_CUSTOMER` 셀 콤보를 이번 회차에 주입하지 않았다(행 단위 3키 좁힘 필요) |  | 미구현 |
| R-27 | 소수자릿수 동적 전환 8건 | `qtyScaleOf()` + `formatItem` — **조회 축(S1)만**. 편집 중 재판정(S2/S3/S5)은 `SSP0200_GET_ITEM_FROM_BOD` 미이관으로 불가 |  | 부분구현(SP) |
| R-28 | 신규행 3경로 39건 | `handleInsert`(가드 `RowCount>0` + 상위행 13키 복사) / `handleNew`(가드 없음 + div 분기 `'-'` + `T07`) / `handleInsertMultiple`(팝업 건수). **3경로 동작 차이 보존**. `FROM/TO_SITE_DESCRIPTION` 복사원은 **코드값**(`FROM_SITE`/`TO_SITE`) |  | 구현 |
| R-29 | 검증 전 색/상태 초기화 16건 | 미구현 — 셀 오류 표시 자체를 이번 회차에 넣지 않았다 |  | 미구현 |
| **R-30** | `CHK` 헤더 전체선택 8건 | **미구현** — shtMain 에 `CHK` 컬럼이 없고(메타 실측) `spdSub` 이벤트 배선도 0건이라 **AS-IS 동작 여부가 불명**(설계 §6 #15). 구현하면 AS-IS 초과 가능성 | 미구현(확인필요) |
| R-31① | `RollBack_Flag` 포커스 복귀 | 미구현 — 셀 롤백 시 Wijmo 기본 동작에 맡겼다 | 미구현 |
| R-31② | EditButton 잠금 8건 | **`INPUT_TP_CD` 로 이관**(§3.4 매트릭스) + 행 조건만 `isRowEditable()`. **FE 컬럼명 상수 배열 금지**(hook #130) 준수 | 구현(메타 미적용) |
| R-31③④ | `Query(ds)` 바인딩 / 조회 직후 전열 잠금 | `useTabProcQuery` + `INPUT_TP_CD`. 전열 잠금은 조건부(`OPERATION_GROUP='E'`)였다는 설계 정정을 반영해 무조건 잠금은 이식하지 않았다 | 구현 |
| **R-31⑤** | `SetChangeRequestSOGrid` 23건 | **미이식** — 호출 0건(Δ6) | 미이식(dead 23) |
| R-31⑥⑦ | 팝업 결과 기입 + `TRANSPORT_MODE` 셀콤보 주입 | `writeCell()` (ITEM_ID→NICK_NAME, PROJECT_CODE→PROJECT_NAME). 셀콤보 주입은 미구현 | 부분구현 |
| R-40 | spCalls 12건 | §1 L-064~L-071 과 동일 축 |  | 부분구현 |
| R-41 | entryPoints 12건 | `handleInsert`/`handleNew`/`handleSave`/`handleSearch` + 그리드 핸들러. `TopChange` 는 본문이 스크롤 top 보존뿐이라 **미이식** |  | 구현 |
| R-50 | buttonGuards 52건 | `beginningEdit` 게이트 + `useSaveWithValidation` + 활성 그리드 라우팅 | 필수검증 미검증 | 구현 |
| R-51 | validations 36건 | §4 i18n 표 |  | 부분구현 |
| R-52 | popups 5건 | InsertPopup=`InsertMultipleModal` / Item·Project=공용 모달 / **`SSP0300_OrderDetailPopup`·`SCM0002_ShipmentPlanRequestPopup` 는 미구현**(TO-BE 공용 컴포넌트 부재 — 임의 신설하지 않았다) |  | 부분구현 |
| R-60 C6 | detail→master `PLAN_CONFIRM_ID` 역참조 | **미구현이 정답** — master 에 그 컬럼이 없어 AS-IS 도 no-op | 미이식(dead) |
| R-60 C7~C9 | 원본 스냅샷 대조 | 미구현 — 확정 체인(SP 미이관)과 함께 보류 | 미구현 |
| R-60 C10 | 동일 SO 부분선택 → `MSG00247` | `hasPartialSoSelection()` **정의만, 참조 0건** — 소비처(요청확정 경로)가 SP 미이관으로 막혀 있다. **삭제하지 않고 보고**한다 | 미배선(보고) |
| R-60 C11 | `dtTransMode` 9값 추출 | 미구현(R-23 과 동일 — AS-IS 대입 전부 주석) | 미이식(dead) |
| R-60 C12·C13 | `GetItemFromBOD` 전극 판정 | 미구현(SP 미이관) | 미구현(SP) |
| R-70 D1·D2·D4·D5 | ChangeType='P' 폭 0/복원 | `PLAN_HIDDEN_COLUMNS` → `colWth: 0` | 구현 |
| R-70 D3·D6 | 수량 라벨 동적 교체 | **미구현** — `Shipment Plan Qty`/`Shipment Confirm Qty` 둘 다 TO-BE `SCM_ADM_MSG_M` **0행**(신규 등록 필요). 임의 하드코딩 라벨을 넣지 않았다 | 미구현(i18n) |
| R-70 D7·D8 | shtSub CHK 헤더 체크박스 + 장식 Border | 미구현(R-30) / Border 는 장식이라 미이식 | 미구현 |
| R-70 D9 | `CHK` `MergePolicy=None` | `buildSubColumns` 가 `CHK` 에 `allowMerging: false` | 구현 |
| R-70 D10 | shtSub `REMARKS` 런타임 폭 0 | `buildSubColumns` `colWth: 0` | 구현 |
| R-70 D11~D16 | `cellTypeImage` 경로별 차이 | 팝업 셀 렌더 게이트(`wj-cell-popup` 토글) + 3경로 차이 보존 | 구현 |
| R-70 D17 | `CharacterCasing.Upper`(ITEM_ID/PROJECT_CODE 대문자 강제) | **미구현** — 메타 `UPPERCASE_APPLY_FLAG` 가 124행 전건 `'-'` 라 메타 축에 없다. FE 하드코딩 대신 메타 정비를 남긴다(사용자 결정) | 미구현(메타) |
| R-70 D18 | `SuspendLayout`/`ResumeLayout` | Wijmo `deferUpdate` 미적용 — 현재 대량 갱신 경로(다건 삽입)가 루프 1건 단위라 체감 영향 없음 | 미구현(성능) |
| R-80 F9 | dead 필드 5종 | 이식하지 않았다 | 미이식(dead) |

**영역3 dead 미이식 = 43행**(`SetChangeRequestSOGrid` 23 + `SetMainStatus` 20, 둘 다 호출 0건 — Δ6)
**+ ChangeType `P` 분기**(Δ2/Δ3 — 런타임 내내 `'C'` 고정이라 도달 불가. 단 컬럼 폭 0 분기는 코드에 보존했다)
**+ R-23/C11 NEW_* 파생**(AS-IS 대입 전부 주석) **+ C6**(대상 컬럼 부재로 AS-IS 도 no-op).

---

## 4. i18n 매핑 (hook #114 — AS-IS 번호 그대로 쓰지 않는다)

TO-BE 에서 **뜻이 전혀 다른 충돌 번호 3종은 코드에 넣지 않았다**(self-check grep 0 hit).

| AS-IS | TO-BE 실측 문구 | 이 화면이 쓰는 코드 | 근거 |
|---|---|---|---|---|
| MSG00002 | TO-BE = `Saved successfully.` (충돌) | **`MSG00614`** `The {0} value is required.` / 콤보 미선택은 **`MSG00429`** | 01 §2-H L-105~L-107, 02 §4.7 |
| MSG00012 | TO-BE = `Maximum of 10 tabs allowed.` (충돌) | **`MSG00001`** `Would you like to save it?` | 01 §2-H L-090 |
| MSG00284 | TO-BE = `The grid is not ready.` (충돌) | **등가 미발견** → 영문 `defaultValue` fallback. 번호 재사용 금지 | 01 §2-H L-094 |
| MSG00097 | TO-BE = `Please select Division.` (뜻 다름) | **`MSG00667`** `No authority assigned.` | 02 §4.7 |
| MSG00293 | — | **`MSG01296`** (EN 문자열 완전일치) | 02 §4.7 |
| MSG00174 | — | **`MSG01189`** | 01 §2-H L-104 |
| MSG00248 | — | **`MSG01258`** | 01 §2-H L-111 |
| MSG00189 | — | **`MSG01202`** | 01 §2-H L-113 |
| MSG00133 / MSG00328 | 동일 | 그대로 사용 | — |
| MSG00195 / MSG00267 / MSG00173 / MSG00249 / MSG00098 / MSG00194 / MSG00202 / MSG00287 / MSG00247 | TO-BE 미등록 또는 등가 2후보 | 번호는 상수에 두되 **영문 `defaultValue` fallback** 으로 표시된다. 등록은 별도 요청(설계 R-4) | 01 §5 R-4 |
| `Confirmed` / `Change` / `Shipment Plan Qty` / `Shipment Confirm Qty` / `Qty` / `L/T(Day)` | TO-BE **0행** | 신규 등록 필요 — 임의 하드코딩하지 않았다. shtSub 2단 헤더는 메타 `SMALL_CLASS_LABEL_NAME` 을 그대로 쓴다 | 03 §2.2 |

---

## 5. 미이식 결정 요약 (조용한 제외 금지 — convert-core §1)

1. **편집모드 모드토글 미이식** — AS-IS `EditButton` 의 `SwitchLock()` 기반 "조회=전열 잠금 → Edit 으로 해제"
   상태기계를 이식하지 않았다. 사용자 지시(2026-09-25, `Doc/Doc_lgc_bak/rules/11_asis_parity/asis_to_tobe.md §11`) 및
   convert-core §2.4 에 따라 **편집 기본 ON**, mount 시 `const canEdit = hasButton('EDIT')` 1회만 둔다.
   `editMode`/`setEditMode` state 0건(self-check grep 0 hit). 컬럼 단위 잠금은 모드가 아니라
   **컬럼 속성(`INPUT_TP_CD`)** 이므로 그대로 유지했다.
2. **`INPUT_TP_CD` 정비 미적용** — 124행 전건 `'S'`. 정비 UPDATE 24행은
   `design/05_register_input-tp-cd.sql` 로 **분리 산출**했으나 사용자 결정(2026-09-27)에 따라
   **DB 에 적용하지 않았다**. 따라서 그리드 편집·`useSaveWithValidation` 필수검증 축은 **미검증**이다.
   FE 컬럼명 화이트리스트로 우회하지 **않았다**(hook #130 BLOCK — 우회하면 필수검사가 조용히 무발동).
3. **JVFlag = false 고정** — 원천 SP(`SSP0200_GET_SHIPMENT_DIVISION`) 미이관. 분기 코드는 있으나
   발동하지 않는다. store `jvFlag` 상태로 명시 보관한다.
4. **SP 6건 미이관의 영향** — `GET_ITEM_FROM_BOD`(전극 소수자리 편집 중 재판정) ·
   `GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION`(From Site 셀콤보 공급원) ·
   `GET_SHIPMENT_DIVISION`(JVFlag) · `GET_SHIPMENT_PLAN_PLANT_SITE`(VP From Site) ·
   `SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM` · `SCM_SSP_DELETE_..._BY_CONFIRM` →
   **런타임 실행체인 미완**. `convert-sp` 후속.
5. **초과구현 1건** — `Change Type` 콤보 노출(L-050). AS-IS 는 영구 비노출이나 모드 스위치라 숨기면
   기능이 잠긴다. 근거를 남기고 배치를 확인필요로 올린다.

---

## iter-2 추가 매핑·결정 (2026-09-27, convert-react 보완 회차)

### A. 저장 경로 재매핑 (AS-IS SaveButton → TO-BE)

| AS-IS | 위치 | TO-BE | 근거 |
|---|---|---|---|---|
| `FoxDataRequest("SSP.SSP0200_SAVE_SHIPMENT_CONFIRM_NEW")` + `request.Parameters["p_*"]` 31개 | cs:1066~1098 | `apiClient.post('/SSP0200/main/SAVE/call-proc', payload)` — 31 camelCase 키(`SCM_ADM_PROC_M.COL_NM` 실측)의 `^` 결합 평면 문자열 | `ALL_ARGUMENTS`: IN 31 중 29개 CLOB / PKG 본문 `C_DELIMITER := '^'`. 행 배열 전송(`useProcMutation`)은 `params.get(COL_NM)` 에 걸려 전건 NULL |
| `if (action != CAppSetting.FlagI) continue;` | cs:1005 | `saveTargetRows()` = `CRUD_TYPE==='I'` 만 | SaveButton 은 **신규행 전용** 저장이다. 수정행은 요청확정/초안 경로 소관 |
| `p_project_code40 ← END_CUSTOMER` / `p_project_code ← PROJECT_CODE` | cs:1014~1015 | 동일(별개 인자 2개 유지) | div40 분기를 SP 가 파라미터로 받는다 |
| `p_lt/p_route_id/p_bod_id/p_d_*/p_a_*/p_to_*` ← `NEW_CUSTOMER_LT`/`NEW_ROUTE_ID`/`NEW_BOD_ID`/`NEW_D_*`/`NEW_A_*`/`NEW_TO_*` | cs:1023~1029 | 동일 매핑(shtMain 메타에 15개 NEW_* 열 존재 — ora.py 실측) | AS-IS 주석 "아래 Parameter는 프로시져에서 다시 setting 함" |
| `p_a_conuntry` (원문 오타) | cs:1019 | `aConuntry` **오타 그대로 전송** | PROC_M COL_NM 실명. 교정 시 NULL 바인딩 |
| `Convert.ToDateTime(...).ToString("yyyy-MM-dd HH:mm:ss.fff")` | cs:1017 | **8자리 숫자(`YYYYMMDD`)로 정규화** — 의도적 차이 | 이관 SP 가 토큰을 8자리 VARCHAR 컬럼과 직접 비교(PKG 본문 2182~2183 / `SCP_MST_BOD_N_V.FROM_YYYYMMDD='20220411'`). AS-IS 문자열을 그대로 보내면 하이픈 때문에 범위 비교가 전건 참이 되어 BOD 가 조용히 잘못 잡힌다 → convert-sp 확정 필요(04 ⑤ #5) |
| `ds.Tables[0].Rows[0][0] == "S"/"N"/"F"/"X"` 분기 | cs:1107~1130 | `SaveResult.code` 분기 — 'S' 만 성공 toast, 'N'=MSG00261, 그 외/‘X’=MSG00328(+reason 상세) | 'X' 상세 필드(`reason_id`/`division_id`/`to_site`)는 cs:1140~1164 와 동일 |
| `GetNewERPInterface()` 실패 시 `MessageBox("신규 생성 요청 실패")` | cs:1111~1114 | **미이식** — ERP I/F 재확인 SP 가 미이관이다 | 조용한 제외가 아니라 04 ⑤ #6 에 기재 |

### B. i18n 메시지 코드 이번 회차 확정분 (hook #114)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| MSG00429 사용처(Change Reason 미선택) | `MSG00429` 유지 | 번들 실측 `"{0} value is required."` — design 02 §4.7 지정 코드 |
| MSG00202(수량 0) | `MSG00202` 유지 | TO-BE 미등록 → 영문 `defaultValue` fallback(설계단계 INSERT 금지) |
| MSG00247(SO 부분선택) | `MSG00247` 유지 | 동일(미등록, fallback) |
| MSG00261(저장결과 'N') | `MSG00261` 유지 | 동일(미등록, fallback) |
| MSG00293(Trans Mode 콤보 미로드) | **MSG01296** | 번들 실측 `"BOD (Trans mode…"` 완전일치 |
| MSG00173(요청완료 안내) | **코드 미사용** — 화면 전용 키 `_ssp0200.requestCompleteUnavailable` | 실행체인이 배선되기 전에 완료 코드를 쓰면 등록 시점에 false success 문구가 된다 |
| 저장 성공 toast | 공용 `CRUD_MSG.SAVED.id` **심볼 참조** | 화면 파일에 AS-IS 번호 리터럴을 적지 않는다(self-check 금지 3종 grep 0 유지) |
| shtSub 2단 헤더 'P' 분기 | `LBL00358`(Plan) / `LBL00359`(Confirm) | 번들 실측. LBL01034 도 'Confirm' 동일 문구 — 중복은 확인필요 유지 |

### C. 이번 회차 미이식·의도적 차이 근거 (조용한 제외 금지)

1. **요청확정/초안저장/초안삭제 실행체인 미배선** — SP·PROC_M(45/41/9)·API 메타는 배포 실측. 45 인자 조립이 이번 회차 범위 밖이라 **배선 미완**으로 남긴다("SP 미이관" 아님).
2. **`SearchType='E'` 분기 미이식**(shtSub `NEW_SHIPMENT_DATE` 해제) — 원천이 전극 조회 SP(미이관)다. ≠'E' 분기(잠금 유지)만 구현.
3. **`sShipStatus='R'` 분기** — 요청확정 실행체인이 세팅하는 화면 변수라 현재 도달 불가. 행 `SHIPMENT_STATUS` 기준 게이트만 걸어둠.
4. **`TRANSPORT_MODE` 셀 콤보 미배선** — AS-IS #66(`dtTransMode==null`)과 동일하게 진입 차단 + MSG01296 안내로 처리. 콤보 임의 신설 금지.
5. **컬럼 메타 소수자리** — FE 로 `cellCtrlObjTpCd` 를 덮지 않는다(CLAUDE.md §2 체크4). 메타 정정 SQL 분리 산출 + 적용 대기.
6. **`CRUD_UPDATE` 어휘 교체** — `'U'` → 공용 `CRUD_TYPE.MODIFY('M')`. AS-IS StringAction 도 'M' 이라 의미 일치이며, EditTracker 가 넣는 값과 섞이지 않게 한다.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — `--check` 가 부재 행을 FAIL 처리한다.
> 기입 회차: **convert-gap-resolve iter-1 (2026-09-28)**. 전 7행을 공용 패키지 소스 직접 read 로 대사했다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | `packages/foundation/src/utils/gridAction.ts:836`(공용 `addRowSet` 내부) ← `ShipmentChangeRequestPlan.tsx:201·208`(`GridAction.addRow`) · `:219`(`GridAction.addRowSet`) | 공용 상속. `addRow` 는 `addRowSet` 의 1행 특수형(gridAction.ts:856~863)이라 3개 삽입 경로 전건이 `keepRowVisibleUnderFilter` 를 탄다. 화면이 필터를 clear 하는 코드 0건 | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (1st 행4) | 공용 위임 — `DataGrid.tsx:560~575`(`registerDirtyCheck`/`registerDirtyReset` 자동 등록) ← `ShipmentChangeRequestPlan.tsx:329`·`MainGrid.tsx:456` `editTrackerRef={editTrackerRef}` · 조회 가로채기는 `SearchArea.tsx:115`·`SubTitle.tsx:198` `confirmIfDirtyKey(dirtyKey,'search')` | 공용 위임이라 화면 코드에 가드가 없는 것이 **정상**이다. 확인한 것: ① `editTrackerRef` 를 main·sub 양쪽 DataGrid 에 전달 ② `excludeFromDirtyCheck` **미설정**(grep 0) → 자동 등록됨. 문구는 조회 경로 전용 **`MSG00704`** 이고 `MSG00703` 은 화면 닫기 전용이다(`useDirtyRegistry.ts:110·112`) — `useDirtyRegistry` 를 화면이 import 하지 않는 것도 정상 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | `ShipmentChangeRequestPlan.tsx:148`(mount) · `:183`(매 Search) · `useShipmentChangeRequestPlanStore.ts:177`(division 변경 시 filters 비움 + 재fetch) | `staticColumns` 를 mount·Search·division 변경 3자리에서 refetch 한다(hook #66). Measure 축은 `SCM_MST_SHEET_MEASURE` 0행 실측 = PIVOT 미해당 | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | `hooks/useShipmentChangeRequestPlanSaveActions.ts:193~195` `setToast({type:'success', message: translate(CRUD_MSG.SAVED.id, …)})` | 저장(Save)은 공용 toast. 요청확정 완료(MSG01188)·취소 확인(MSG00684)은 AS-IS 가 `GMessageBox` alert/confirm 인 자리라 alert 유지가 패리티다(CRUD 완료 알림 축과 별개) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | `ShipmentChangeRequestPlan.tsx:313` `excelFileName='ShipmentChangeRequest'` + `hooks/useShipmentChangeRequestPlanToolbar.ts:57` `hasButton('EXCEL')` | 셀 콤보 7종 전건 `dataMap` 주입이라 공용 export 가 NAME 을 쓴다(`cellCboDataTp` 비움). **이번 회차에 `EXCEL` 버튼 메타를 등록**(`05_register_excel_btn.sql` 적용·재조회 확인)해 버튼이 실제로 노출된다 — 등록 전에는 `excel:false` 로 숨겨져 이 축이 도달 불가였다(gap G4-M2) | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | `useShipmentChangeRequestPlanStore.ts:129` `multiLine()` → `:222`(erpSoNo) · `:223`(itemId) · `:231`(confirmId) | Key-in 조회조건 3필드 전건 콤마 분해. AS-IS cs:1476·1479·1482 대응 | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1481~1483` `rebindFilterColumns(grid, getGridFilter())` | 공용 DataGrid 상속. 화면은 `gridFilterRef` 를 main·sub 양쪽에 전달하고 필터를 리셋하는 코드가 0건이다 | 구현 |
