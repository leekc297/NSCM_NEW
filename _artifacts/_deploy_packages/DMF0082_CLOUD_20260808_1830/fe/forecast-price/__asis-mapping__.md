# __asis-mapping__.md — EID 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `DMF0082_FcstNPrice_주요이벤트_상세분석.md`, `DMF0082_FcstNPrice_제약매트릭스_상세.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (EID 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| A-01 | 메인 조회 SP / `p_user_group = UserInfoContext.Current["NowGroupID"]` | useTabProcQuery SEARCH → PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(p_user_group=세션 그룹, BE 주입) | — | 구현 |
| A-02 | Measure 편집권한 로드 / `dsMain.Tables.Count >= 3` → `dsMain.Tables[3]` (GET_ADMIN_GROUP_MEASUR… | store `measureAuth`(GET drop3 = MEASURE/EDIT_FLAG 커서) — ForecastPriceGrid `measureAuthRef` | AS-IS 4개 bool 변수 → TO-BE 는 measure별 EDIT_FLAG 맵으로 일반화(하드코딩 4종 제거) | 구현 |
| A-03 | DeleteButton — SCM_FCST / `bEDIT_AUTH_SCM_FCST == false` | ForecastPrice.tsx `handleDelete` — measure 권한 미보유 시 MSG00671(MEASURE_NOT_EDITABLE) | AS-IS MSG00464 → TO-BE MSG00671 재채번(hook #114 대조 완료) | 구현 |
| A-04 | DeleteButton — MKT_FCST / `bEDIT_AUTH_MKT_FCST == false` | ForecastPrice.tsx `handleDelete` (A-03 과 동일 경로 — measure 무관 일반화) | — | 구현 |
| A-05 | DeleteButton — LOC / `bEDIT_AUTH_LOC == false` | ForecastPrice.tsx `handleDelete` (A-03 동일) | — | 구현 |
| A-06 | DeleteButton — VMI_In_Req / `bEDIT_AUTH_VMI_IN_REQ == false` | ForecastPrice.tsx `handleDelete` (A-03 동일) | — | 구현 |
| A-07 | SetLockRange — LOC / `!bEDIT_AUTH_LOC` → continue (해당 행 unlock 제외) | ForecastPriceGrid `canEditCell` — `measureAuthRef` EDIT_FLAG 판정(AUTH_MEASURES 화이트리스트) | — | 구현 |
| A-08 | SetLockRange — MKT_FCST / `!bEDIT_AUTH_MKT_FCST` → continue | ForecastPriceGrid `canEditCell` (A-07 동일 경로) | — | 구현 |
| A-09 | SetLockRange — SCM_FCST / `!bEDIT_AUTH_SCM_FCST` → continue | ForecastPriceGrid `canEditCell` (A-07 동일 경로) | — | 구현 |
| A-10 | SetLockRange — VMI_In_Req / `!bEDIT_AUTH_VMI_IN_REQ` → continue | ForecastPriceGrid `canEditCell` (A-07 동일 경로) | — | 구현 |
| A-11 | 조회조건/셀 콤보 (그룹권한 스코프) / `NowGroupID + UserId` 파라미터 | CMBO `@sesUserId` 서버 자동 주입(BE LookupServiceImpl) + `EndCustomerByDivision40`/`SiteByEndCustomer`/`CurrencyList`/`FcstTypeByUserGroupDMF0082` 배선 | AS-IS 는 GroupID+UserId 를 파라미터로 전달 — TO-BE 는 세션에서 서버가 주입(위조 불가). BigFilter GROUP_ID 는 조회조건 카탈로그가 담당 | 구현 |
| A-12 | 팝업 폼 권한 / `this.IsPopup = true` — "팝업일 경우 권한 체크 패스" | — | AS-IS 팝업 `IsPopup=true` = BaseForm 권한검사 우회. TO-BE 모달은 부모 화면 권한 컨텍스트를 그대로 쓰므로 우회 개념 자체가 없다 — 플랫폼 차이 | 해당없음 |
| A-13 | 팝업 행 권한 / `AUTHORITY_YN != "Y"` && Action 빈값 | components/modals/SavePricePeriodModal.tsx — 조회행 계획구간 편집 차단 | — | 구현 |
| A-14 | 팝업 행 권한 예외 / `AUTHORITY_YN != "Y"` && Action=="I" && IsEditMode | components/modals/SavePricePeriodModal.tsx — I행 W_ 편집 허용 + 키 컬럼 잠금 + 전주 차단 | — | 구현 |
| A-15 | 팝업 조회 SP / `p_userinfo = NowGroupID`, `p_created_by = UserId` | savePriceData 시트 → DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (sesUserId 서버 주입) | — | 구현 |
| D-01 | InitControls / (무조건) | components/ForecastPriceForm.tsx `DivisionField` — 사용자 권한 division 목록 | ⚠️ AS-IS 는 40 **단일 고정**이었으나 TO-BE 는 81(편집)·82(조회) 확장이 요건(2026-08-07 사용자 지시) — 고정 제약을 의도적으로 해제 | 제외 |
| D-02 | OnShown / `sDivision == "40"` | ForecastPriceForm BucketField 기본값 | AS-IS 40 고정 화면의 Weekly 강제. TO-BE 는 division 별 bucket 선택 자유 — 확장 요건에 따라 미이관 | 제외 |
| D-03 | EditButton / `clbDivision.ControlValues == "40"` | ForecastPrice.tsx `handleSave` → utils/forecast-price.validate.ts 필수키 검증(MSG00113 계열) | — | 구현 |
| D-04 | fnValidation / `clbDivision.ControlValues == "40"` | utils/forecast-price.save.ts `buildSaveRows` — I행 키 취득 | — | 구현 |
| D-05 | fnValidation / `clbDivision.ControlValues.Substring(0,2) == "40"` | utils/forecast-price.validate.ts V3 중복검사(LOC=CURRENCY 유사키 포함) | — | 구현 |
| D-06 | InsertRow / `clbDivision.ControlValues.Substring(0,2) == "40"` | ForecastPrice.tsx `handleInsert` — DIVISION_ID 시드 세팅 + DOM_EXP 콤보(GRID_EDIT_COMBO CustomsHandbook, div40 한정) | — | 구현 |
| D-07 | InsertRow / `sDivision == "40"` | ForecastPriceGrid 신규행 프라이밍 effect + GRID_EDIT_COMBO — EndCustomerByDivision40 / SiteByEndCustomer / IncotermsEdit / FcstPriceEditMeasure / CELL_PROD_SITE_ID / CurrencyList | 2026-08-08 UP_FX 정합에서 InsertRow 시점 재조회 전수 이식 | 구현 |
| D-08 | clbCustomer_SelectedIndexChanged / `Substring(0,2)=="81" \ | components/ForecastPriceForm.tsx SalesSiteField comboId 스왑(`ScmSitebyEndCustomer40` ↔ `UserSiteByEndCustomer`) | — | 구현 |
| D-09 | spdMain_CellDoubleClick / `sDivision=="40" && sMeasure=="MKT_FCST" && BackColor∈{PaleGree… | — | SSP 동기수량 비교 팝업 — 2026-07-20 사용자 보류 결정(E08-B 동일). 완전재현=라이브 GET 개조 필요 | 제외 |
| D-10 | spdMain_Changed(Validation) / `sDivision.Substring(0,2)=="81" \ | utils/forecast-price.validate.ts — 81/82 PROJECT_CODE 키 검증 | AS-IS 는 40 고정으로 도달 불가 잔존이었으나 TO-BE 는 81/82 가 실사용 → **활성화** | 구현 |
| D-11 | spdMain_Changed(Validation) / `sDivision == "40"` | utils/forecast-price.validate.ts — 40 END_CUSTOMER 필수 | — | 구현 |
| D-12 | spdMain_Changed(중복검사) / `clbDivision.ControlValues == "40"` | ForecastPriceGrid `cellEditHandler` DUP_KEY_COLS 8키 실시간 중복검사 → MSG00260 + 값 롤백 | — | 구현 |
| D-13 | spdMain_Changed(else, 키변경) / `clbDivision.ControlValues == "40"` | ForecastPriceGrid `cellEditHandler` + GRID 키 변경 시 수량 클리어 경로 | — | 구현 |
| D-14 | SetSaveData / `sDivision == "40"` | utils/forecast-price.save.ts `buildSaveRows` — 키 빈값 행 적재 제외 | — | 구현 |
| D-15 | SetSaveData / `(=="40" \ | utils/forecast-price.save.ts — DOM_EXP 빈값 행 적재 제외 | — | 구현 |
| D-16 | SetSaveDataRemove / `sDivision == "40"` | utils/forecast-price.save.ts — 삭제 대상도 동일 키 가드 | — | 구현 |
| D-17 | spdMain_ComboSelChange(Division 셀) / `clbDivision.ControlValues.Substring(0,2) == "40"` | ForecastPriceGrid `applySalesSites`(END_CUSTOMER/DIVISION_ID 변경 → SiteByEndCustomer 재조회) | 2026-08-08 신설 | 구현 |
| D-18 | spdMain_ComboSelChange(Division 셀) / `sDivision.Substring(0,2)=="81"` → PlantSite unlock … | ForecastPriceGrid `cellEditableHandler` — PLANT_SITE_ID 는 81 계열 컬럼 메타(DIVISION_ID 토큰)로 노출 제어 | AS-IS 의 명령형 unlock/lock → TO-BE 는 컬럼 메타 division 토큰 + 편집 판정으로 등가 | 구현 |
| D-19 | fnValidation(LOC Currency 유사키) / `clbDivision.ControlValues.Substring(0,2) == "40"` | utils/forecast-price.validate.ts V3 — LOC 행 CURRENCY 를 중복키에 포함 | — | 구현 |
| DP-01 | InitControls / `81prefix \ | components/modals/SavePricePeriodModal.tsx — Project 조회조건 division 분기 | — | 구현 |
| DP-02 | EditButton / `=="40"` | components/modals/SavePricePeriodModal.tsx — 40 필수컬럼 8종 검증(MSG00113) | — | 구현 |
| DP-03 | EditButton / `81prefix` | components/modals/SavePricePeriodModal.tsx — 81 필수컬럼(PROJECT/PLANT_SITE 포함) | AS-IS 잔존 분기였으나 TO-BE 는 81 실사용 → 활성화 | 구현 |
| DP-04 | EditButton / `=="82"` | components/modals/SavePricePeriodModal.tsx — 82 필수컬럼 7종 | TO-BE 82 는 조회 전용(V82-00) — 저장 경로 미도달이나 검증 로직은 보존 | 구현 |
| DP-05 | EditButton / `=="82" && NEW_FLAG=="Y"` | — | 82 NEW_FLAG 키 컬럼 개별 잠금 — TO-BE 82 는 조회 전용이라 편집 진입 자체가 없음 | 해당없음 |
| DP-06 | SaveData / `sDIVISION_ID=="40"` → PROJECT_CODE=END_CUSTOMER40 / `81prefix\ | components/modals/SavePricePeriodModal.tsx 저장 키 결정 — 40=END_CUSTOMER / 81·82=PROJECT_CODE | — | 구현 |
| DP-07 | SaveData 필수메시지 / `=="40"` → "[End Customer]" / `81prefix\ | components/modals/SavePricePeriodModal.tsx 필수 메시지 문구 division 분기 | — | 구현 |
| DP-08 | fnValidation / `81prefix\ | components/modals/SavePricePeriodModal.tsx 중복키 소스 division 분기 | — | 구현 |
| DP-09 | fnValidation 중복키 / 81prefix: 10키(+PLANT_SITE) / 82: 9키 / 40: 9키(END_CUSTOMER40) — iRow +=… | components/modals/SavePricePeriodModal.tsx 중복 판정(Measure 3행 세트) | — | 구현 |
| DP-10 | 중복 MSG00043 문구 / `=="40"` → End Customer 축 / else → Project+PLANT_SITE 축 | components/modals/SavePricePeriodModal.tsx 중복 MSG 문구 분기 | — | 구현 |
| DP-11 | usrButton1_Click(Project 팝업) / `SelectedValue != "40"`일 때만 Project 검색팝업 | components/ForecastPriceForm.tsx ProjectField(COM 공용 모달) — div40 disabled | — | 구현 |
| DP-12 | clbDivisions_SelectedIndexChanged / 81prefix/82 → Project 활성, else → 비활성 (Division 콤보 자체는… | components/modals/SavePricePeriodModal.tsx — Division 변경 시 Project 활성 토글 | — | 구현 |
| DP-13 | Dsdm_Changed / SetExchangeValues / `81prefix` → PROJECT/ITEM 변경 시 PlantSite 콤보 (⚠ 이벤트 미배선… | — | AS-IS 원문이 **이벤트 미배선(잠재 코드)** — 제약매트릭스 §1.3 DP-13·§8 X-24 명시. 미이관이 파리티 | 제외 |
| F-01 | SetLockRange / `sMeasure=="SCM_FCST" && sFcstType=="RMA"` | components/ForecastPriceGridUtils.ts `isNonEditableCell` — SCM_FCST × FCST_TYPE=RMA 편집 차단(:413) | — | 구현 |
| F-02 | FindData(캐시) / 조회 성공 시 | components/ForecastPriceGrid.tsx 셀 콤보 `FcstTypeByUserGroupDMF0082` 프리페치(그룹별 W/S 분기 1:1) | — | 구현 |
| F-03 | InsertRow / 신규 행 | ForecastPrice.tsx `handleInsert` + 메타 셀 콤보(FCST_TYPE) | — | 구현 |
| F-04 | spdMain_Changed(Validation) / `FcstType==""` | utils/forecast-price.validate.ts — FCST_TYPE 필수 검증 | — | 구현 |
| F-05 | SetSaveData / SetSaveDataRemove / `sFcstType==""` | utils/forecast-price.save.ts `buildSaveRows` — FCST_TYPE 빈값 행 적재/제거 제외 | — | 구현 |
| F-06 | 저장 SP / `p_fcst_type` ^연결 전달 | SAVE PROC_M `fcstType` 파라미터(18 IN 중) | — | 구현 |
| F-07 | 비교팝업 SP / `p_fcst_type` 전달 | — | SSP 비교 팝업(DMF0003_GET_MKT_FCST_COMPARE_POPUP) — E08-B·D-09 와 동일 보류(2026-07-20 사용자) | 제외 |
| F-08 | 중복/필터 키 / FCST_TYPE 포함 | components/ForecastPriceGrid.tsx DUP_KEY_COLS(FCST_TYPE 포함) + utils/forecast-price.validate.ts V3 + utils/forecast-price.save.ts 필터 | — | 구현 |
| F-09 | 팝업 콤보 / `GetLookupValues("SALES_TYPE_CODE")` | components/modals/SavePricePeriodModal.tsx — FCST_TYPE 셀 콤보(FCST_TYPE_NOT_FREE 메타 배선) | — | 구현 |
| F-10 | 팝업 저장 / FCST_TYPE 필수(1596, 1625~1626) + 중복키 포함(2150, 2171~2172, 2188~2189, 2218~2219) + `… | components/modals/SavePricePeriodModal.tsx — 필수/중복키/저장 파라미터 포함 | — | 구현 |
| L-01 | `LockColumn2(xCol1+1, 마지막, true)` / EditButton — Edit 해제 시 Action 이후 전 컬럼 잠금(+SetLockFlag… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-02 | `SetLockRange(0, maxRow, !IsEditMode)` / EditButton — 전 행 편집가능 셀 unlock/lock 일괄 | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-03 | `LockColumn(0, maxCol, true)` / Draw() — 조회 직후 전 컬럼 잠금(조회모드 기본) | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-04 | `LockRange2(iActRow, col, iRowCount, col, false, MarkedForeColor, UnLockColor)` ×9컬럼 루프 /… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-05 | `SetLockRange(iActRow, iActRow, false)` / InsertRow — 신규 행 계획구간 unlock | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-06 | `LockRange2(e.Row, MEASURE+1, e.Row, maxCol, true, true)` / spdMain_Changed — MEASURE 변경 … | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-07 | `SetLockRange(e.Row, e.Row, false)` / spdMain_Changed — 변경된 Measure 기준 재-unlock | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-08 | `LockRange(ActiveRow, PlantSiteId.., false)` / ComboSelChange Division — 81 prefix면 Plant… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-09 | `LockRange(ActiveRow, PlantSiteId.., true)` / ComboSelChange Division — 그 외(40) PlantSite… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-10 | `LockRange2(iRow, MEASURE+1, iRow, maxCol, true, true)` / SetLockRange — Insert 행 선잠금(Mon… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-11 | `LockRange2(iRow, idx, iRow, idx, bLockFlag, true)` / SetLockRange — LOC: 편집대상 idx unlock… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-12 | `LockRange2(iRow, idx, iRow, idx, bLockFlag, true)` / SetLockRange — FCST 3메저 Monthly(M+4… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-13 | `LockRange2(iRow, idx, iRow, idx, bLockFlag, true)` / SetLockRange — FCST 3메저 Weekly/Dail… | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| L-14 | `range3.Locked = false` (+UnLockColor) / Insert() — 빈 시트 최초 행 추가 시 Action 이후 전 컬럼 unlock | ForecastPriceGrid.tsx `cellEditableHandler`(진입 차단) + `ForecastPriceGridUtils.isNonEditableCell` + `utils/forecast-price.editLock.ts`(금주 월요일 cutoff) + 서버 `EDIT_FLAG`(PKG GET) + 셀 색상 `wj-cell-editable`/`wj-cell-non-editable` | AS-IS 는 WinForms 스프레드의 `LockRange/LockColumn` 으로 **셀 범위를 명령형 잠금**한다. TO-BE(Wijmo)는 잠금 API 대신 **편집 진입 시점 판정**(beginningEdit e.cancel)으로 등가 구현 — 호출 1건 1행 대응이 아니라 판정 함수 1곳으로 수렴한다(hook #95 3색 표준 연동) | 구현 |
| M-01 | MKT_FCST/VMI_In_Req/SCM_FCST/LOC / DeleteButton | ForecastPrice.tsx `handleDelete` + `AUTH_MEASURES` 화이트리스트(SCM_FCST/MKT_FCST/LOC/VMI_In_Req) | — | 구현 |
| M-02 | 4종 각각 / DeleteButton | ForecastPrice.tsx `handleDelete` — 권한 미보유 시 MSG00671 | — | 구현 |
| M-03 | LOC / SetLockRange | components/ForecastPriceGridUtils.ts `isNonEditableCell` — Daily 버킷 × LOC 편집 차단(:423) | — | 구현 |
| M-04 | SCM_FCST / SetLockRange | components/ForecastPriceGridUtils.ts `isNonEditableCell` :413 (F-01 동일) | — | 구현 |
| M-05 | LOC / SetLockRange(unlock 루프) | components/ForecastPriceGridUtils.ts `allocateLoc` — LOC 일괄 할당 | — | 구현 |
| M-06 | MKT_FCST/SCM_FCST/VMI_In_Req / SetLockRange(unlock 루프) | components/ForecastPriceGridUtils.ts `isNonEditableCell` M+4 규칙(m3CutoffYyyymm, :430) — FCST 3메저 Monthly 한정 | — | 구현 |
| M-07 | 그 외 measure (default) / SetLockRange | components/ForecastPriceGridUtils.ts `editableMeasures` 미포함 measure 는 편집 차단(:410) | — | 구현 |
| M-08 | LOC / spdMain_Changed(I행 CURRENCY/MEASURE 변경) | components/ForecastPriceGrid.tsx `cellEditableHandler` — CURRENCY: PRICE 계열 아니면 빈 DataMap 스왑(AS-IS NO_DATA 등가) | 2026-08-08 UP_FX 정합 D7 신설 | 구현 |
| M-09 | LOC vs 기타 / spdMain_Changed(MEASURE 변경) | components/ForecastPriceGrid.tsx formatHandler #11 — MEASURE 별 소수/정수 표시 스왑 | AS-IS 는 행 포맷 명령형 스왑 + 재잠금 — TO-BE 는 표시 포맷터 + 편집 판정으로 수렴 | 구현 |
| M-10 | LOC / fnValidation | utils/forecast-price.validate.ts V3 — LOC 행 CURRENCY 유사키 포함 | — | 구현 |
| M-11 | LOC / fnValidation / Validation / SetSaveData | utils/forecast-price.validate.ts V1 CURRENCY_REQUIRED + V1-R 역방향 정리 + utils/forecast-price.save.ts 적재 가드 | — | 구현 |
| M-12 | LOC / SetSaveData 필터 | utils/forecast-price.save.ts `buildSaveRows` — LOC 는 CURRENCY 포함 키로 dedup | — | 구현 |
| M-13 | LOC / spdMain_Changed 버킷결정 | components/ForecastPriceGridUtils.ts `LOC_BUCKET_BITS`(0100000=월요일) — LOC 는 버킷 강제 | 2026-08-08 상수화(AS-IS .cs L6008~6012 1:1) | 구현 |
| M-14 | MKT_FCST/VMI_In_Req/SCM_FCST / spdMain_Changed(Daily 수정) | components/ForecastPriceGrid.tsx `cellEditHandler` — D_ 직접 입력 시 FCST 3종 `Math.trunc` 정수 절사 | — | 구현 |
| M-15 | 비LOC / spdMain_Changed(Weekly 수정) | components/ForecastPriceGridUtils.ts `divideByWeek` — 버킷요일 분배 + 마지막 버킷요일 잔량 | — | 구현 |
| M-16 | LOC / spdMain_Changed(Weekly 수정) | components/ForecastPriceGridUtils.ts `allocateLoc` W_ 분기 — 월요일(MON_IDX) 셀에만 기입, 그 외 0 | — | 구현 |
| M-17 | LOC / spdMain_Changed(Weekly 수정 후 Monthly 합) | components/ForecastPriceGridUtils.ts `allocateLoc` :369 — LOC 월합 = 값 있는 주차의 평균 | — | 구현 |
| M-18 | 비LOC vs LOC / spdMain_Changed(Monthly 수정) | components/ForecastPriceGridUtils.ts `divideByMonth`(비LOC 반올림) / `allocateLoc`(LOC 그대로) | — | 구현 |
| M-19 | 비LOC / spdMain_Changed(Monthly 수정) | components/ForecastPriceGridUtils.ts `divideByMonth` — MONTH_DAY_CNT/WEEK_DAY_CNT 캘린더 기반 배분 + 잔량 가산 | — | 구현 |
| M-20 | LOC / spdMain_Changed(Monthly 수정) | components/ForecastPriceGridUtils.ts `allocateLoc` M_ 분기 — 월요일 셀 기입 + 1일 셀 기입, 그 외 클리어 | 2026-08-08 기준일 정정(일요일→월요일) | 구현 |
| M-21 | LOC/POINT3 vs INTEGER / Draw()(조회 직후 NOTATION 스왑) | components/ForecastPriceGrid.tsx formatHandler :885~891 — NOTATION POINT3/LOC=소수3 / INTEGER=정수, 0·null 빈칸 | — | 구현 |
| M-22 | MKT_FCST / InsertRow(포커스 행 없음) | ForecastPrice.tsx `handleInsert` — 시드 없으면 MEASURE='MKT_FCST' | — | 구현 |
| M-23 | MKT_FCST / spdMain_CellDoubleClick | — | SSP 동기수량 비교 팝업 — D-09·E08-B 동일 보류 | 제외 |
| M-24 | (편집 measure 목록) / FCST_PRICE_EDIT_MEASURE 룩업 | components/ForecastPriceGrid.tsx `applyEditMeasures`(FcstPriceEditMeasure) — Insert 프라이밍 + SCM_SITE/DIVISION/INCOTERMS 변경 + Paste 공유 | 2026-08-08 호출 지점 6→트리거 4 정합(hook #117 §5.12) | 구현 |
| M-25 | KRW / USD / 팝업 EditButton | components/modals/SavePricePeriodModal.tsx — KRW/USD 파생행 입력 차단 | — | 구현 |
| P-01 | 실적 cutoff = 금주 월요일 / `DateTime.Today.AddDays(Monday - DayOfWeek)` → `sResultYYYYMMDD` | utils/forecast-price.editLock.ts `thisWeekMondayYmd` — 실적 cutoff | — | 구현 |
| P-02 | 실적 판별 컬럼 인덱스 / `D_ < 금주월요일` → iResultCol / `M_ == 당월` → iResultMonth / 당주 W_ 중복 count | components/ForecastPriceGrid.tsx 동적 컬럼 메타(SPREAD_TITLE) + `currentPeriodRef` | — | 구현 |
| P-03 | 과거(실적) 회색 / `iResultCol > iStartCol` | components/ForecastPriceGrid.tsx formatHandler — 과거 구간 회색(hook #95 3색 표준: 기본 White+zebra / 편집 Yellow / 잠금 Gray) | — | 구현 |
| P-04 | 당주 녹색 보더(Weekly/Monthly) / `count >= 2`(동일 주차명 복수) && 조회시작 > 금주월요일 → this_YYYYMMWW / else… | components/ForecastPriceGrid.tsx `currentPeriodRef` — 당월(M_)/당주(W_) 녹색 보더 | — | 구현 |
| P-05 | 당일 녹색 보더(Daily) / `D_금주월요일` 컬럼 존재 시 | components/ForecastPriceGrid.tsx `currentPeriodRef` — 금주 월요일 D_ 녹색 보더 | — | 구현 |
| P-06 | 편집 시작 — Month / `당월(this_YYYYMM) <= M_컬럼` → list_EDIT_Month | components/ForecastPriceGridUtils.ts `isNonEditableCell` — Monthly 당월 이후만 편집 | — | 구현 |
| P-07 | 편집 시작 — M+4(FCST 3메저) / `M_컬럼 > dtWeek.Rows[0]["MONTH_NAME"]` → list_EDIT_Month_M4 (SP가 내… | components/ForecastPriceGridUtils.ts `isNonEditableCell` :430 — m3CutoffYyyymm(SP drop1) 초과 월만 편집(FCST 3메저) | — | 구현 |
| P-08 | 편집 시작 — Week(당주) / 당주 컬럼(this_YYYYMMWW) 존재 && `idx >= 당주컬럼` → list_EDIT_Week | components/ForecastPriceGridUtils.ts `isNonEditableDateColumn`(@foundation) — 당주 이후 W_ 편집 | — | 구현 |
| P-09 | 12월 마지막주 W01+ 보정 / else: `Period 시작월 >= 당주월` 이면 당주컬럼 이후 W_ 전부 추가 (E20251202-000637 — 12월 … | components/ForecastPriceGrid.tsx isoWeek 기반 주차 식별 + SPREAD_TITLE 서버 산출 | AS-IS 의 12월 W01 보정은 **서버(SPREAD_TITLE)가 주차 목록을 내려주는** TO-BE 구조에서 재현 불요 — 클라 비교식 자체가 없음 | 해당없음 |
| P-10 | 편집 시작 — Day(금주 월요일) / `sResultYYYYMMDD <= D_컬럼` → list_EDIT_Day | components/ForecastPriceGridUtils.ts `isNonEditableCell` + editLock — 금주 월요일 이후 D_ 편집 | — | 구현 |
| P-11 | 당주/당월 식별자 산출 / Tables[1].ISO_WEEK → this_YYYYMMWW/this_YYYYMM(가), Tables[2].THIS_YYYYMMWW… | components/ForecastPriceGrid.tsx SPREAD_TITLE + store `calendar`(drop4) — 당주/당월 식별 | — | 구현 |
| P-12 | 버킷별 컬럼 표시 / Daily: D_·W_ 표시, M_·W_는 chkSum 연동 / Weekly: D_ 숨김·W_ 표시·M_ chkSum / Monthly: … | components/ForecastPriceGrid.tsx `applyDynVisibility` + `sumYn` — 버킷별 M_/W_/D_ 표시 토글 | — | 구현 |
| P-13 | 당월/당주 헤더 강조 / M_==당월 또는 W_==당주 → ForeColor Green + Bold | components/ForecastPriceGrid.tsx formatHandler — 당월/당주 헤더 강조 | — | 구현 |
| P-14 | 버킷 전환 시 Lock 복원 / Edit 상태(`!IsLock`)면: 이벤트 해제 → **이전 버킷(sBfBucket)으로 되돌려 EditButton() 실행(… | — | AS-IS 는 버킷 전환 시 unlock 컬럼을 **명령형으로 되돌리는** 복원 절차가 필요했다. TO-BE 는 편집 가능 여부를 매 렌더 판정하므로 복원 개념이 없다 — 플랫폼 차이 | 해당없음 |
| P-15 | Insert 행 존재 시 버킷 변경 차단 / 어떤 행이든 Action=="I" | ForecastPrice.tsx `handleBucketChange` — Insert 행 존재 시 MSG00227 차단 | — | 구현 |
| P-16 | 기간 역전 금지 / `sPeriod[0] > sPeriod[1]` | ForecastPrice.tsx `handleSubmit` V — 기간 역전 MSG00108 | — | 구현 |
| P-17 | 기간 3년 초과 금지 / `Value1+3년 < Value2` | ForecastPrice.tsx `handleSubmit` V — 3년 초과 MSG00164 + 보정 | — | 구현 |
| P-18 | Version 미선택 금지 / Current만 수정 / `txtVersion==""` → MSG00283; `=="Current"` → isCurVersion=… | ForecastPrice.tsx `handleSubmit` V + `isEditableVersion`(Current 한정) — MSG00283 | — | 구현 |
| P-19 | 헤더 더블클릭 접기/펼치기 / M_ 헤더 → 하위 W_ 토글(D_는 접기만) / W_ 헤더 → 하위 D_ 토글 | components/ForecastPriceGrid.tsx dblclickHandler + drillVisRef — 헤더 더블클릭 접기/펼치기 | — | 구현 |
| P-20 | Delete 시 실적구간 보호 / `D_금주월요일 컬럼index > iCol` → continue (실적 일자 미변경) + list_EDIT_Day 비면 Del… | ForecastPrice.tsx `handleDelete` + components/ForecastPriceGridUtils.ts `isNonEditableCell` — 실적 구간 보호 | — | 구현 |
| P-21 | Monthly 배분 실적 pass / `금주월요일 > D_` → continue (배분 제외) | components/ForecastPriceGridUtils.ts `divideByMonth` — 실적 일자 배분 제외 | — | 구현 |
| P-22 | 캘린더 기반 배분 / dtWeek=Tables[1], dtCalendarDetail=Tables[4] (MONTH_DAY_CNT/WEEK_DAY_CNT/BASI… | components/ForecastPriceGrid.tsx `calendarMapRef`(GET drop4: MONTH_DAY_CNT/WEEK_DAY_CNT/BASIS_YYYYMMDD) | — | 구현 |
| P-23 | 기본 버킷요일 / 행 BUCKET 빈값/"0000000" → DEFAULT_BUCKET_DAY 룩업(sDefaultDay, 조회 시 1773) 요일 비트 변환(… | components/ForecastPriceGridUtils.ts `bucketBitsOfDay` + CMBO `DefaultBucketDay`(division×MONTHLY／WEEKLY 마스터 조회) | ⚠️ **2026-08-08 결함 정정** — 구 코드는 40=MON/그 외=FRI **FE 상수 하드코딩**이었다(본 제약이 대사표에 없어 게이트가 못 잡음). 마스터 조회로 교체 + 주배분 분기 버그·LOC 월 기준일 동시 정정 | 구현 |
| P-24 | 조회기간 기본값 / PR_GET_DAY_RANGE p_month=6 (13→6개월 축소) | components/ForecastPriceForm.tsx PeriodField 기본값(6개월) | — | 구현 |
| PL-00 | `SwitchLock()` / EditButton — 시트 Lock 토글 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-01 | `LockColumn(iCol, iCol, true)` / Edit 진입, W_ 컬럼: 과거주(`금주월요일 > W_`) 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-02 | `LockColumn(iCol, iCol, true)` / Edit 진입, W_ 컬럼: `0 < W_숫자` — **항상 참 → 모든 주차 셀 잠금 (PRICE_… | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-03 | `LockColumn(iCol, iCol, true)` / Edit 아님(잠금모드)일 때 W_ 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-04 | `LockColumn(iCol, iCol, true)` / W_ 아닌 계획컬럼 전부 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-05 | [범위행 PL-05~18 전개 1/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-06 | [범위행 PL-05~18 전개 2/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-07 | [범위행 PL-05~18 전개 3/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-08 | [범위행 PL-05~18 전개 4/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-09 | [범위행 PL-05~18 전개 5/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-10 | [범위행 PL-05~18 전개 6/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-11 | [범위행 PL-05~18 전개 7/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-12 | [범위행 PL-05~18 전개 8/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-13 | [범위행 PL-05~18 전개 9/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-14 | [범위행 PL-05~18 전개 10/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-15 | [범위행 PL-05~18 전개 11/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-16 | [범위행 PL-05~18 전개 12/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-17 | [범위행 PL-05~18 전개 13/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-18 | [범위행 PL-05~18 전개 14/14] `LockRange(iRow, {키컬럼}, iRow, {키컬럼}, true)` ×14 / 82+NEW_FLAG=Y 행: DIVISION_ID(993)/DEPT_… | — | AS-IS 82+NEW_FLAG='Y' 행의 키 컬럼 개별 잠금(잔존). TO-BE 82 는 **조회 전용**(PKG SAVE V82-00 거부 + FE Insert/Delete/Save·Price Batch Input 숨김)이라 편집 진입 자체가 없다 — DP-05 와 동일 판정 | 해당없음 |
| PL-19 | `LockRange(iRow, MEASURE, iRow, MEASURE, true)` / 〃 MEASURE 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-20 | `LockRange(iRow, DIVISION_ID, iRow, MEASURE, true)` / 그 외 행: 키 구간 일괄 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-21 | `LockRange(iRow, MEASURE+1, iRow, maxCol, true)` / AUTHORITY_YN != Y && Action 빈값 → 계획구간 … | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-22 | `LockRange(iRow, iCol, iRow, iCol, false)` / AUTHORITY_YN != Y && I행 && Edit → W_ 셀 unlock | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-23 | `LockRange(iRow, iCol, iRow, iCol, true)` / 〃 W_ 외 컬럼 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-24 | `LockRange(iRow, DIVISION_ID.., true)` / 〃 DIVISION 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-25 | `LockRange(iRow, DIVISION_ID+1, iRow, MEASURE, false)` / 〃 키 구간 unlock (I행 키 입력 허용) | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-26 | `LockRange(iRow, PROJECT_NAME.., true)` / 〃 40 아닌 경우 파생 컬럼 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-27 | `LockRange(iRow, ProjectStatus.., true)` / 〃 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-28 | `LockRange(iRow, BizTypeName.., true)` / 〃 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-29 | `LockRange(iRow, ITEM_CLASS_NAME.., true)` / 〃 공통 파생 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-30 | `LockRange(iRow, ITEM_NAME.., true)` / 〃 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-31 | `LockRange(iRow, MEASURE.., true)` / 〃 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-32 | `LockRange(iRow, NICK_NAME.., true)` / 〃 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-33 | `LockRange(iRow, MEASURE, iRow, "W_"+전주컬럼, true)` / 조회 시작이 7일 이전이면 dtWeek(DMF0082_POPUP_G… | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-34 | `LockRange(iRow, MEASURE+1, iRow, maxCol, true)` / Measure=="KRW" 행 계획구간 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-35 | `LockRange(iRow, MEASURE+1, iRow, maxCol, true)` / Measure=="USD" 행 계획구간 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| PL-36 | `LockColumn(0, maxCol, true)` / FindData — 조회 직후 전 컬럼 잠금 | components/modals/SavePricePeriodModal.tsx — 편집 가능 셀 판정(W_ 계획구간·PRICE_ALL) + 권한/과거주 차단 | AS-IS 팝업의 `LockColumn/LockRange` 37 호출 = WinForms 셀 범위 잠금. TO-BE 는 Wijmo 편집 판정으로 수렴(L 축과 동일 구조). 개별 호출 1:1 대응 없음 — 플랫폼 차이 | 구현 |
| S-01 | 재진입 차단 / `blnWork == true` | components/modals/SavePricePeriodModal.tsx — 저장/조회 중복 실행 가드(MSG00137 WORK_IN_PROGRESS) | — | 구현 |
| S-02 | 기간 역전 / `from > to` | components/modals/SavePricePeriodModal.tsx 기간 역전 검증(MSG00108 PERIOD_ORDER) | — | 구현 |
| S-03 | 과거구간 금지 / `이번주 월요일 > 시작일` | components/modals/SavePricePeriodModal.tsx 과거구간 금지(MSG00409 PAST_PERIOD) | — | 구현 |
| S-04 | 월요일 강제 / from 또는 to가 월요일 아님 | components/modals/SavePricePeriodModal.tsx 월요일 강제(MSG00330 PERIOD_MONDAY) | — | 구현 |
| S-05 | Division 필수 / `p_division_id == ""` | components/modals/SavePricePeriodModal.tsx Division 필수(MSG00667 DIVISION_NO_AUTH) | — | 구현 |
| S-06 | 월요일 스냅(입력 보정) / Form_Load: `MinDate1 = 이번주 월요일`, from/to를 각자 주의 월요일로 스냅 / 달력 Load: Value1… | components/modals/SavePricePeriodModal.tsx — from/to 를 해당 주 월요일로 스냅 | — | 구현 |
| S-07 | 조회 SP / `DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` (userinfo=NowGroupID) —… | savePriceData 시트 조회(DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP) | — | 구현 |
| S-08 | PRICE_ALL 초기값 / 첫 주차(W_ 첫 컬럼) 값을 PRICE_ALL 컬럼에 복사 + CELL_PROD_SITE 콤보(`LOOKUP_COMBO SP_CE… | components/modals/SavePricePeriodModal.tsx — PRICE_ALL 초기값(첫 주차 복사) + CELL_PROD_SITE 콤보 | — | 구현 |
| S-09 | 실적 회색/당월 White / `W_ < 금주월요일` → iResultCol → Gainsboro, 당월 M_ White | components/modals/SavePricePeriodModal.tsx — 과거주 회색/당월 White(hook #95 3색 표준) | — | 구현 |
| S-10 | 범위초과 Pink / COL_LIST 컬럼의 W_목록 셀 → Pink 배경 | components/modals/SavePricePeriodModal.tsx — 범위초과 셀 강조 | — | 구현 |
| S-11 | 필수 컬럼(Division별) / §1.3 DP-02~04 — MSG00113 | components/modals/SavePricePeriodModal.tsx 필수컬럼 검증(DP-02~04 참조) | — | 구현 |
| S-12 | 주차 셀 전면 잠금 / `0 < int.Parse(W_...)` 항상 참 → Edit 진입 시 **모든 W_ 셀 잠금** (과거주 잠금 927과 중첩) → 실질… | components/modals/SavePricePeriodModal.tsx — 입력 가능 셀 = PRICE_ALL 1컬럼 | — | 구현 |
| S-13 | 행 키 구간 잠금 / NEW_FLAG 분기 / §6.2 PL-05~20 | components/modals/SavePricePeriodModal.tsx 행 키 구간 잠금(PL 축 참조) | — | 구현 |
| S-14 | 권한행 잠금 + I행 예외 + 전주 잠금 / §2 A-13~14, §6.2 PL-21~33 | components/modals/SavePricePeriodModal.tsx 권한행 잠금 + I행 예외 + 전주 잠금 | — | 구현 |
| S-15 | KRW/USD 행 잠금 / 파생통화 행은 직접 입력 불가(LOC 행 입력 → 환산) | components/modals/SavePricePeriodModal.tsx — KRW/USD 파생행 입력 차단(LOC 입력→환산) | — | 구현 |
| S-16 | 변경 없음 차단 / 전 행×계획컬럼 스캔, ForeColor Red(변경 표식) 셀 1건도 없으면 MSG00133 | components/modals/SavePricePeriodModal.tsx — 변경 없음 차단(MSG00004 NO_CHANGES) | — | 구현 |
| S-17 | NEW_FLAG 승격 / `NEW_FLAG=="Y" && Action=="M"` → action을 "I"로 간주하여 검증 진입 | components/modals/SavePricePeriodModal.tsx — NEW_FLAG 승격(M→I 간주) | — | 구현 |
| S-18 | 필수 10키 검사(I행) / DIVISION / PROJECT(=40이면 END_CUSTOMER40, 81·82면 PROJECT_CODE) / SCM_SITE … | components/modals/SavePricePeriodModal.tsx — I행 필수 10키 검증(MSG00429 REQUIRED) | — | 구현 |
| S-19 | 중복 검사 / fnValidation: I행 기준 3행(Measure 세트) 단위(iRow+=3)로 전행 대조 — **81: 10키**(DIVISION/PROJ… | components/modals/SavePricePeriodModal.tsx — 중복 검사(MSG00043 DUP_SAVE_ERROR) | — | 구현 |
| S-20 | 저장 대상 셀 / Red 셀 존재 행만, `PRICE_ALL`·비W_ 컬럼 제외, `p_yyyymmdd = W_ 제거값`, qty = PRICE_ALL 값(콤마… | components/modals/SavePricePeriodModal.tsx — 저장 대상 = 변경 셀 보유 행, PRICE_ALL 값 전달 | — | 구현 |
| S-21 | qty 0 → D / `qty==""` → "0"; `Action != "D" && qty=="0"` → 해당 건 action "D"(stempAction) | components/modals/SavePricePeriodModal.tsx — qty 0 → D 액션 전환 | — | 구현 |
| S-22 | 파라미터 조립 / 16개 파라미터 `CString.AppendStringEx` ^연결 → `DM.DMF0082_SAVE_MAIN_DATA` (CommandTim… | 기배선 SAVE(DMF0082_SAVE_MAIN_DATA) 재사용 — 16 IN ^ bulk | — | 구현 |
| S-23 | 결과 처리 / RESULT_CODE=="S" → MSG00004(건수) / "F" → ERR_MESSAGE·RESULT_MSG 표시, Tables[1].TITL… | components/modals/SavePricePeriodModal.tsx — 결과 코드 분기(성공 MSG00672 / 실패 원문 표시) | SSP_SYNC_T_ERR 시 DMF0003_SspSyncPopUp 표시는 E08-B 와 동일하게 보류(2026-07-20 사용자) | 구현 |
| S-24 | 저장 후 / isSaveOK=true, panel1 숨김, FindData(false) 재조회 | components/modals/SavePricePeriodModal.tsx — 저장 후 재조회 | — | 구현 |
| S-25 | ① 동일 통화 / `sBaseER == sTargetER` → 입력값 그대로 | components/modals/ExchangeRateModal.tsx — 동일 통화 그대로 | 환율 4룰은 AS-IS 팝업에서 **이벤트 미배선(잠재)** 상태(§7.4 ⚠ 실측). TO-BE 는 ExchangeRateModal 의 환율 마스터 조회·저장 경로로 별도 구현 | 구현 |
| S-26 | ② 직행 환산 / dtFuturePrice에서 `CURRENCY=Target, UNIT_CURRENCY=Base, YYYYMM, DIVISION_ID` 행 존재… | components/modals/ExchangeRateModal.tsx — 직행 환산 | §7.4 동일 | 구현 |
| S-27 | ③ 역방향 / `CURRENCY=Base, UNIT_CURRENCY=Target` 행 존재 → `Round(1/EXCHANGE_PRICE, 5) × 값` | components/modals/ExchangeRateModal.tsx — 역방향 환산 | §7.4 동일 | 구현 |
| S-28 | ④ KRW 경유 / 둘 다 KRW 아님 → `(값 × KRW/Base환율) ÷ KRW/USD환율`; 미해결 시 TargetVal null→"" else "0" | components/modals/ExchangeRateModal.tsx — KRW 경유 환산 | §7.4 동일 | 구현 |
| X-01 | 메인 / 706~711, 722~725 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-02 | 메인 / 932~1519 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-03 | 메인 / 2313~2327 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-04 | 메인 / 2411~2487 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-05 | 메인 / 2754~2849 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-06 | 메인 / 2857~3014 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-07 | 메인 / 3494~3532 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-08 | 메인 / 3835~5535 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-09 | 메인 / 5661~5737 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-10 | 메인 / 5973~5995 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-11 | 메인 / 6001~6006, 6014~6019 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-12 | 메인 / 6207~6541 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-13 | 메인 / 6745~7110 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-14 | 메인 / 7140~7178 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-15 | 메인 / 7401~7548 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-16 | 메인 / 7596~7609 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-17 | 메인 / 8051~8195 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-18 | 메인 / 8345~8369 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-19 | 메인 / 8427~8485 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-20 | 메인 / 8496~8644 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-21 | 메인 / 8782~8902, 8905~9042 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-22 | 메인 / 9100~9111 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-23 | 메인 / 9148~9164 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-24 | 팝업 / 508, 510 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-25 | 팝업 / 105~110, 363~366, 513~527, 659~690, 921~972, 1038~1065 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-26 | 팝업 / 811~829 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-27 | 팝업 / 1495~1501 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-28 | 팝업 / 1785~1964 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |
| X-29 | 팝업 / 2492, 2513~2522 등 | — | AS-IS **주석(사문) 구간** — 제약매트릭스 §8 비활성 인벤토리로 명시된 구 로직. 사문 = 미이관이 파리티 | 제외 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:DMF0003_SspSyncComparePopUp | AS-IS 팝업 (분석 md) | — | 제외 — E08-B 와 동일(2026-07-20 사용자 보류 결정) | 제외 |
| MODAL:DMF0003_SspSyncPopUp | AS-IS 팝업 (분석 md) | — | 제외 — E08-B 와 동일(SSP 동기화 계열 보류) | 제외 |
| MODAL:ExchangeRateModal | 환율 팝업 (AS-IS DMF0000_ExchangeRatePopup 1:1) | components/modals/ExchangeRateModal.tsx — R:POPUP_GET_FUTUREPRICE_INFO / CUD:PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA(hasButton EDIT×div40 게이트, Delete=사문·사용자 확정 2026-07-24) | — | 구현 |
| MODAL:ForecastTemplateModal | Excel Form 템플릿 다운로드 (81 전용) | components/modals/ForecastTemplateModal.tsx — 조회·다운로드 전용(저장 CRUD 없음: 템플릿 생성 모달) | — | 구현 |
| MODAL:MeasureSelectModal | Measure 개인화 선택 | components/modals/MeasureSelectModal.tsx — R:measureCount 계열 / U:titleSet 'M' SAVE(개인화 저장) | — | 구현 |
| MODAL:SavePricePeriodModal | Price Batch Input (기간 판가 일괄 저장) | components/modals/SavePricePeriodModal.tsx — R:savePriceData/savePriceTitle / CU:SAVE_PRICE 경로. div82 = 진입 버튼 숨김(2026-08-07 사용자 지정) | — | 구현 |
| MODAL:VersionSelectModal | 버전 선택 팝업 | components/modals/VersionSelectModal.tsx — R:version 시트(DMF0073_GET_VERSION_SALESPRICE 공유) 조회 전용, dblclick 선택 | — | 구현 |
| E01 | spdMain_Changed — 셀 값 변경·배분 엔진 (md §1) | ForecastPriceGrid.tsx:394-531 cellEditEnded + ForecastPriceGridUtils.ts 배분 엔진 | — | 구현 |
| E01-A | Insert 행 키 셀 처리(sAction='I' 캐스케이드) (md §1-A) | ForecastPriceGrid.tsx — MEASURE dataMap 스왑/원복 + `applySalesBucket`·`applyEditMeasures`·`applySalesSites`·`applyCellProdSites`(hook #59 §5-G). ⭐ **2026-08-08 보완**: AS-IS 는 편집가능 Measure 를 **6지점**에서 재조회(.cs L2621 InsertRow / L5841 셀변경 / L7922·L8027 Paste / L8261 Division / L8308 SalesSite·Incoterms)하는데 구 코드는 SCM_SITE_ID 1곳뿐이라 **시드 복사 후 그대로 저장하는 정상 흐름에서 사이트 특성(VMI_YN) 필터가 미적용**이었다 → Insert 행 프라이밍 effect 신설(WeakSet 1회) + DIVISION_ID·INCOTERMS 트리거 추가 | — | 구현 |
| E01-B | 수량 변경 — 버킷 요일비트 산출 (md §1-B) | ForecastPriceGridUtils.ts `bucketBitsOfDay` + divideByMonth/divideByWeek `defaultBucket` 인자 — **2026-08-08 정정**: 구 코드는 `40=MON/그 외=FRI` FE 상수였으나 AS-IS 는 lookup `DEFAULT_BUCKET_DAY`(division×MONTHLY／WEEKLY) 조회값(.cs L1773 sDefaultDay → L6024 switch). CMBO `DefaultBucketDay` 신규 등록 후 마스터 조회로 교체 | — | 구현 |
| E01-B1 | Daily 버킷 D_ 셀 수정 (md §1-B1) | ForecastPriceGrid.tsx cellEditHandler → D_ 직접 반영 + 검증(editLock) | — | 구현 |
| E01-B2 | Weekly W_ 셀 수정 — 주배분(요일비트 SUN-first) (md §1-B2) | ForecastPriceGridUtils.ts:182-200 주배분(2026-07-20 #2 SUN-first 교정) | — | 구현 |
| E01-B3 | Monthly M_ 셀 수정 — 월수량 일별 배분 (md §1-B3) | ForecastPriceGridUtils.ts 월배분 — drop4 MONTH_DAY_CNT/WEEK_DAY_CNT 달력기반(2026-07-20 #1) | — | 구현 |
| E01-B4 | 키 변경(수량 아님) else 분기 (md §1-B4) | ForecastPriceGrid.tsx:443-456,494-496 키 셀 cascade | — | 구현 |
| E02 | SetSaveData/SetSaveDataRemove — 저장 버퍼 (md §2) | @foundation EditTracker(CRUD_TYPE 마킹) + utils/forecast-price.save.ts:59-98 buildSaveRows(I/M/D×D_ flat) | — | 구현 |
| E03 | EditButton+SetEditList+SetLockRange — 잠금 게이트 5종 (md §3) | 서버 EDIT_FLAG(PKG GET L3041-3069: ADMIN/EDIT_AUTH_YN×요일 + 82='N') + utils/forecast-price.editLock.ts(금주 월요일) + measureAuth(drop3)+M+4(drop1 M3_CUTOFF) + wrapper 편집판정(ForecastPrice.tsx:204-206) | — | 구현 |
| E04 | SaveData(F7)+fnValidation (md §4) | ForecastPrice.tsx:309-354 handleSave + utils/forecast-price.validate.ts:20-51(V1~V3) + PKG SAVE — **2026-08-07 SP 직접 왕복 실증**(40/81 M·I 원장 반영·원복, 판가 52주·BIZ_TYPE·구간 검증 게이트 작동, 82 V82-00 차단) | — | 구현 |
| E05 | FindData(F5) 조회+Draw (md §5) | ForecastPrice.tsx:213-237 handleSubmit(V1~V4)+useTabProcQuery SEARCH/SEARCH_CURRENT — 2026-08-07 실측 40=17,343/81=6,518/82=4,890행 | — | 구현 |
| E06-A | InsertRow — 시드 10키 복사 (md §6-A) | ForecastPrice.tsx:241-266 handleInsert(#9 시드 복사, 82 차단 hotkey 게이트) | — | 구현 |
| E06-B | DeleteButton — D·I·DB행 3분기 (md §6-B) | ForecastPrice.tsx:281-306 handleDelete(I 즉시 제거/D 마킹·토글/measure 권한 MSG) | — | 구현 |
| E07 | ClipboardPasted/KeyUp — 붙여넣기 (md §7) | ForecastPriceGrid pastedCell→cellEditHandler(#8 2026-07-21 — 캐스케이드·중복·배분 발동). 1행→N행 확장은 Wijmo whole-range paste 이벤트 부재로 원천 불가(mkt-fcst L1090 동일 한계) | — | 구현 |
| E08-A | 헤더 더블클릭 드릴다운 (md §8-A) | ForecastPriceGrid.tsx:711-775 dblclickHandler + drillVisRef(hook #103 계열) | — | 구현 |
| E08-B | 셀 더블클릭 — SSP 비교 팝업 (md §8-B) | — | 제외 — 2026-07-20 사용자 결정 보류(완전재현=라이브 GET 개조 필요·route-only 대안 기록). 동기화 마커 ATTR1 캐리어는 2026-08-07 UICATEGORY 로 적재 준비됨 | 제외 |
| E08-C | Insert 행 키 셀 더블클릭 — 검색 팝업 (md §8-C) | ForecastPriceGrid.tsx `applyEditMeasures`(FcstPriceEditMeasure) + `applyCellProdSites`(CELL_PROD_SITE_ID) — 셀 종속 콤보로 대체 구현. ⚠️ **2026-08-08 정정**: 종전 기재는 CELL_PROD_SITE_ID 캐스케이드가 "구현"이라 했으나 **코드가 실재하지 않았다**(ITEM_ID 변경 트리거 0건 → @divisionId/@itemId 미전달 → 무필터 전체 목록). AS-IS 기본판 SP 의 `@Code='CELL_PROD_SITE_ID'` 분기(PARAM1 유무 → 품목 BIZ_TYPE≠CELL 이면 '-'만) 실재 확인 후 행 단위 재조회로 신규 구현 | — | 구현 |
| CRUD:MAIN:SEARCH | 버전 조회 (GET_MAIN_DATA) | useForecastPriceStore.setFilters→useTabProcQuery(SEARCH)→PKG_DMF0082.P_DMF0082_GET_MAIN_DATA — 실측 40/81/82 SUCCESS | — | 구현 |
| CRUD:MAIN:SEARCH_CURRENT | Current 조회 | SEARCH_CURRENT 배선→P_DMF0082_GET_MAIN_DATA_CURRENT — 2026-08-07 사문 파손(ORA-00904) 복구 실증 | — | 구현 |
| CRUD:MAIN:INSERT | 행 추가 → SAVE 'I' | ForecastPrice.tsx:241-266 + SAVE 'I' — SP 직접 실증(40/81 신규 7 원장 생성 확인) | — | 구현 |
| CRUD:MAIN:UPDATE | 셀 편집 → SAVE 'M' | cellEditEnded+EditTracker + SAVE 'M' — SP 직접 실증(40/81 +1→원장 반영→원복) | — | 구현 |
| CRUD:MAIN:DELETE | 행 삭제 → SAVE 'D' | ForecastPrice.tsx:281-306 + SAVE 'D' — 81=QTY 0 물리 저장(원문 정본, 실증) / 40 수요=원장 무변경(AS-IS Phase2 MERGE `QTY_PRICE<>0` 규약 — LOC 판가 삭제는 별도 검증·삭제 경로 L11773~) 실증 | — | 구현 |
| CRUD:MAIN:SAVE | 저장 (16+1 IN '^' bulk) | handleSave→/DMF0082/FcstNPrice/SAVE/call-proc — 82 는 V82-00 서버 거부+FE 버튼 숨김(2026-08-07) 실증 | — | 구현 |
| CRUD:MAIN:UPLOAD | Excel Upload (81 전용) | UploadModal→P_DMF0082_EXCEL_UPLOAD/GET_EXCEL_UPLOAD_DATA 배선(UPLOAD/UPLOAD_DATA/UPLOAD_SAVE BTN_MPG 실측) — isDiv81 게이트 | — | 구현 |

## 배선 체인 WARN 처리 근거 (2026-08-08 — wiring_chain_check L2P/L3/L7)

| 항목 | 판정 | 근거 |
|---|---|---|
| L7 `titleSet` 시트 | 해소 | 공유 모달(`@master/components/columnSettingModal:96`·`columnLayoutModal:108`)이 리터럴 `'titleSet'` 으로 호출 → 화면 SHEETS 에 `TITLE_SET` 등재(sales-plan 등 4화면 동일 규약) |
| L2P `hotkey DELETE` 권한 0그룹 | 정상 | FE 가 `hasButton('SAVE')` 로 insert/delete/save 를 **일괄 게이트**(hook #97) — DELETE 전용 권한 없이도 버튼 노출. 체커가 hotkeyConfig 내 `hasButton()` 을 읽도록 보완해 INFO 로 판정 |
| L3 `futurePriceInfo/EDIT`·`/INSERT` API_ID NULL | 정상 | UI 전용 권한 게이트(편집모드 토글 / 행 추가)이고 실저장은 `futurePriceInfo/SAVE` 경유. 실측 = 각 5그룹 매핑, 3계정 `mnuBtnAuth` 에 EDIT·INSERT 존재 |

## 토큰 대사표 (hook #117 §5.6 — 2026-08-08 실측)

> AS-IS `UP_FX_GetCommonDataList(_DM)` 의 `@CODE + PARAM1~5` 에 대응하는 TO-BE 축.
> BE `BaseService.makeComboQuery` 는 `@토큰` 을 **raw 문자열 치환**하고, 미전달 토큰은 `''` 로 채운다.
> 서버 자동 주입 = `@sesUserId`/`@sesLangCd` 뿐(`/admin/combo` 단건 경로 — `@userId`/`@langCd` 는 미주입).
> 미전달 토큰은 관대형(`@t IS NULL OR …` / `NVL(TRIM(@t),'ALL')='ALL' OR …\`)이어야 하며,
> 비관대형(`COL = @t`) + 미전달 = **0행(조용한 빈 콤보)** 으로 즉시 FAIL 이다.
> "동적" = `GRID_EDIT_COMBO` 등 설정 맵을 거쳐 전달되어 정적 귀속이 불가한 경우.

| SQL_ID | 필요 토큰 | 서버 자동 | FE 전달 | 미전달 | 판정 | 미전달 사유 |
|---|---|---|---|---|---|---|
| BizType | - | - | - | - | ✅ |  |
| BizTypeByDivision | divisionId | - | 동적: divisionId | - | ✅ (동적 전달) |  |
| CELL_PROD_SITE_ID | divisionId, itemId | - | divisionId, itemId | - | ✅ |  |
| CurrencyList | - | - | - | - | ✅ |  |
| DOM_EXP | - | - | - | - | ✅ |  |
| DeptId | - | - | - | - | ✅ |  |
| Division | divisionId | - | 동적: divisionId | - | ✅ (동적 전달) |  |
| EndCustomerByDivision40 | - | - | - | - | ✅ |  |
| EndCustomerByDivisionDept | deptId, divisionId | sesUserId | 동적: divisionId | deptId | ⚠ 관대형 | 모달 `Sales Price Save All` 표시 전용(INPUT_TP_CD=S) — 저장 대상 아님 |
| FCST_TYPE_NOT_FREE | - | - | - | - | ✅ |  |
| FcstTypeByUserGroupDMF0082 | - | sesUserId | - | - | ✅ |  |
| FromSiteByDivision | divisionId | - | 동적: divisionId | - | ✅ (동적 전달) |  |
| Incoterms | - | - | - | - | ✅ |  |
| ItemType | - | - | - | - | ✅ |  |
| Measure | mnuId | - | mnuId | - | ✅ |  |
| PlantByDivisionCompany | companyId, divisionId | - | 동적: divisionId | companyId | ⚠ 관대형 | @companyId 는 DMF0082 에 컨텍스트 없음(AS-IS 도 미전달). @divisionId 는 GRID_EDIT_COMBO 스왑 경로가 전달 |
| SiteByEndCustomer | divisionId, endCustomer | sesUserId | divisionId, endCustomer | - | ✅ |  |
| SoldCustomer | - | - | - | - | ✅ |  |
| YesOrNo | - | - | - | - | ✅ |  |
| AS_FROM_SITE | param1 | - | param1 | - | ✅ |  |
| AsIncotermsEdit | divisionId | - | divisionId | - | ✅ |  |
| CustomsHandbook | - | - | - | - | ✅ |  |
| DefaultBucketDay | bucketType, divisionId | - | bucketType, divisionId | - | ✅ |  |
| FcstPriceEditMeasure | bucketType, divisionId, scmSiteId | - | bucketType, divisionId, scmSiteId | - | ✅ |  |
| FcstType | - | - | - | - | ✅ |  |
| SalesBucket | divisionId, incoterms, scmSiteId | - | divisionId, incoterms, scmSiteId | - | ✅ |  |
| TeambyDivision | langCd | sesUserId | - | langCd | ⛔ FAIL |  |

- DataGrid `comboParams` 일괄 전달: `['mnuId']` (⚠ divisionId 는 의도적 제외 — 전 셀 콤보 일괄 spread 부작용 차단)
- quoting 누락 **0건** / 빈 `.catch`(조용한 실패) **0건**
- 행 단위 종속은 서버 재조회 + WeakMap 캐시로 처리: `applyEditMeasures`(FcstPriceEditMeasure) ·
  `applySalesBucket`(SalesBucket) · `applyCellProdSites`(CELL_PROD_SITE_ID) · `applySalesSites`(SiteByEndCustomer).
- 편집/조회 이원화는 `GRID_EDIT_COMBO` 스왑 (메타 `CELL_COMBO_DATA_TYPE` 무변경 → 공유 콤보 소비 화면 회귀 0).

## AS-IS 이벤트 핸들러 인벤토리 (2026-08-08 축 — 분석서가 놓친 핸들러 차단)

> 원천: `Doc\_legacy_source\06_UIL\domain_DM\GSCM.DM.Forms.UIL\Plan\DMF0082_FcstNPrice_Mgmt\DMF0082_FcstNPrice_Mgmt.cs` — `.cs` 에서 **기계 추출**한 UI 이벤트 핸들러 25개.
> 대사표의 E번호는 **분석 md** 기준이라 분석서가 누락한 핸들러를 못 잡는다. 이 축이 그 구멍을 막는다.
> 사문(빈 몸통) 핸들러는 **미이관이 파리티** — 상태 '제외' + 사유 기재로 통과시킨다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| HANDLER:DeleteButton | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:686` (라이브 170행) | ForecastPrice.tsx `handleDelete` — I 즉시제거 / D 마킹·토글 / measure 권한 MSG | — | 구현 |
| HANDLER:EditButton | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:1531` (라이브 57행) | 서버 EDIT_FLAG(PKG GET) + `isEditableVersion`(Current 버전 한정) + wrapper 편집판정 | AS-IS 는 클라 스프레드 LockRange 조작 — TO-BE 는 서버 EDIT_FLAG 판정으로 등가 이전 | 구현 |
| HANDLER:FindData | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:1662` (라이브 86행) | ForecastPrice.tsx `handleSubmit` (V1~V4 검증) + useTabProcQuery SEARCH | — | 구현 |
| HANDLER:Form_Load | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:312` (라이브 8행) | ForecastPrice.tsx mount useEffect — staticColumns/measure fetch·초기 조회조건 | AS-IS InitForm/InitControls/CreateSpread 는 TO-BE 에서 메타 기반 자동 구성 | 구현 |
| HANDLER:InsertRow | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:2492` (라이브 170행) | ForecastPrice.tsx `handleInsert`(시드 10키 승계) + Grid 신규행 프라이밍 effect | — | 구현 |
| HANDLER:SaveData | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:2025` (라이브 164행) | ForecastPrice.tsx `handleSave` + utils/forecast-price.validate.ts(V1~V3) + PKG SAVE | — | 구현 |
| HANDLER:SetEditList | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:9059` (라이브 56행) | ForecastPriceGrid `isNonEditableCell`/`canEditCell` + utils/forecast-price.editLock.ts | — | 구현 |
| HANDLER:btnColumn_Click | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3424` (라이브 9행) | ForecastPrice.tsx customButtons `Column Setting`(LBL00605) → ColumnSettingModal | — | 구현 |
| HANDLER:btnExchangeRate_Click | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3113` (라이브 16행) | ForecastPrice.tsx customButtons `Exchange Rate`(LBL00661) → ExchangeRateModal | — | 구현 |
| HANDLER:btnItemId_Click | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3373` (라이브 17행) | components/ForecastPriceForm.tsx `ItemField`(Model 검색 — 카탈로그 필드 내장 모달) | — | 구현 |
| HANDLER:btnMeasure_Click | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3436` (라이브 9행) | ForecastPrice.tsx customButtons `_Measure`(LBL00712) → MeasureSelectModal | — | 구현 |
| HANDLER:btnSavePricePeriod_Click | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3455` (라이브 17행) | ForecastPrice.tsx customButtons `Price Batch Input`(LBL00662) → SavePricePeriodModal (V15 편집모드 차단 + div82 숨김) | — | 구현 |
| HANDLER:btnVersion_Click | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3397` (라이브 14행) | ForecastPrice.tsx → VersionSelectModal (DMF0073 공유 계약) | — | 구현 |
| HANDLER:cboBucketType_Click | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3361` (라이브 10행) | ForecastPrice.tsx `handleBucketChange` — Insert 행 존재 시 MSG00227 차단 | — | 구현 |
| HANDLER:cboBucketType_SelectedIndexChanged | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3248` (라이브 75행) | ForecastPrice.tsx bucketType 변경 → setSearchParams + 동적 컬럼 재구성 | — | 구현 |
| HANDLER:chkSum_CheckedChanged | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:9046` (라이브 6행) | components/ForecastPriceForm.tsx `sumYn` 토글 → Grid `applyDynVisibility`(SUM 컬럼 표시) | — | 구현 |
| HANDLER:clbCustomer_SelectedIndexChanged | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3063` (라이브 11행) | components/ForecastPriceForm.tsx EndCustomer onChange → SalesSite 서버바인드 재조회(cascade F-B) | — | 구현 |
| HANDLER:clbDivision_SelectedIndexChanged | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3039` (라이브 2행) · **사문(빈 몸통)** | — | AS-IS 본문이 **빈 몸통(사문)** — 미이관이 파리티. TO-BE Division 변경 처리는 Form onChange(bizTypes reset 등, cascade F-A)가 별도 담당 | 제외 |
| HANDLER:clbTeam_SelectedIndexChanged | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3043` (라이브 8행) | components/ForecastPriceForm.tsx Team onChange → EndCustomer/SalesSite 재조회 | — | 구현 |
| HANDLER:spdMain_Changed | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:5537` (라이브 834행) | components/ForecastPriceGrid.tsx `cellEditHandler` — 배분/캐스케이드/중복검사 (E01 계열) | — | 구현 |
| HANDLER:spdMain_ClipboardPasted | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:7864` (라이브 120행) | ForecastPriceGrid `pastedCell`/`pastingCell` = 편집 핸들러 공유. 1행→N행 확장은 Wijmo whole-range paste 이벤트 부재로 원천 불가(mkt-fcst 동일 한계) | — | 구현 |
| HANDLER:spdMain_ComboSelChange | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8201` (라이브 116행) | ForecastPriceGrid `cellEditHandler` 캐스케이드 분기(SCM_SITE_ID/DIVISION_ID/INCOTERMS/END_CUSTOMER/ITEM_ID) | — | 구현 |
| HANDLER:spdMain_EditChange | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8375` (라이브 4행) | — | AS-IS 본문 4행 = `bPasteContinue` 플래그 세팅뿐(붙여넣기 연속 처리용 WinForms 내부 상태). TO-BE Wijmo 는 해당 상태가 불요 — 플랫폼 차이 | 해당없음 |
| HANDLER:spdMain_KeyUp | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:8384` (라이브 29행) | — | AS-IS 본문 = Ctrl+V 감지해 `fps.ActiveSheet.ClipboardPaste()` 를 **수동 호출**하는 WinForms 배관. Wijmo 는 붙여넣기를 네이티브 처리(pastingCell/pastedCell)하므로 불요 — 플랫폼 차이 | 해당없음 |
| HANDLER:txtVersion_KeyDown | AS-IS `DMF0082_FcstNPrice_Mgmt.cs:3419` (라이브 3행) · **사문(빈 몸통)** | — | AS-IS 본문 3행 = `btnVersion_Click` 재호출(엔터키 단축). TO-BE 는 Version 필드가 모달 진입 버튼 단일 경로 — 단축키 미제공(사용자 조작 동등) | 해당없음 |

## AS-IS 제약 — §1.2 division 파라미터 흐름 (2026-08-08 수기 편입)

> 원천 `DMF0082_FcstNPrice_제약매트릭스_상세.md` §1.2 는 **ID 컬럼이 없는 표**(대상／파라미터／라인)라
> 자동 추출 대상이 아니다. 문서 §9 는 이를 제약 **10건**으로 세므로 `DPF-nn` ID 를 수기 부여해 편입한다.
> (도구는 `--init` 시 'ID 컬럼 없는 데이터 표 행 N건' 을 경고로 보고한다 — 조용한 누락 방지)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| DPF-01 | `DM.DMF0082_GET_SPREAD_TITLE` p_division_id | spreadTitle 시트 SEARCH filters.divisionId (useTabProcQuery) | — | 구현 |
| DPF-02 | `DM.DMF0082_GET_MAIN_DATA` p_division_id + p_user_group | FcstNPrice SEARCH filters.divisionId / p_user_group 은 BE 세션 주입 | — | 구현 |
| DPF-03 | `DMF0000_ExchangeRatePopup.LoadData` division | components/modals/ExchangeRateModal.tsx divisionId prop | — | 구현 |
| DPF-04 | `DM0002_TitleSetForm_Popup` division (Column/Measure) | ColumnSettingModal / MeasureSelectModal — titleSet 시트 배선 | — | 구현 |
| DPF-05 | `DMF0082_SaveSalesFuturePrice_Popup.LoadData` division | components/modals/SavePricePeriodModal.tsx divisionId | — | 구현 |
| DPF-06 | `FCST_PRICE_EDIT_MEASURE` 룩업 PARAM2=division | ForecastPriceGrid `applyEditMeasures` divisionId=q(div) | — | 구현 |
| DPF-07 | `CELL_PROD_SITE_ID` 공통룩업 (division, item) | ForecastPriceGrid `applyCellProdSites` divisionId/itemId (2026-08-08 신설) | — | 구현 |
| DPF-08 | `SALES_BUCKET` 룩업 (division, site, incoterms) | ForecastPriceGrid `applySalesBucket` — 3파라미터 quoting 정합(2026-08-08) | — | 구현 |
| DPF-09 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | components/ForecastPriceForm.tsx BizTypeField (division 변경 시 reset — cascade F-A) | — | 구현 |
| DPF-10 | `DM.DMF0082_SAVE_MAIN_DATA` p_division_id (행별 ^연결) | utils/forecast-price.save.ts `buildSaveRows` — divisionId 행별 전달 | — | 구현 |
