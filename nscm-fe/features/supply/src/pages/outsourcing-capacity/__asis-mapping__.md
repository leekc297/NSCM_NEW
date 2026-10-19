# SCP0023 Outsourcing Capacity — AS-IS ↔ TO-BE 매핑 (convert-core §2.1 Top11 #11)

AS-IS: `GSCM.SCP.Master.UIL / SCP0023_OutsourcingCapacity` (`.cs` 534라인).
TO-BE: `features/supply/src/pages/outsourcing-capacity/`. 설계: `.atlas/gscm-design/SCP0023/design/00~03,07`.

## 조회조건 (design 02)

| AS-IS | TO-BE | 비고 |
|---|---|---|
| cboDivision (BLUtils.GetDivisionWithoutEE, ATTRIBUTE3<>'EE') | Form Division* + `Division_SCP` + FE 필터 `ATTRIBUTE3<>'EE'` | 전극(EE) 제외 재현(combo-semantic-parity) |
| clbPlantSite (PlantSiteByDivisionOSP, OSP_YN='Y') | Form Plant Site(다중) + `PlantByDivisionOperOsp_SCP` @divisionId cascade | 재조회 방식(react-query key), @operationGroup=null |
| txtItemId + btnItemId (SCM0002 팝업) | Form Model InputField + ItemByDivisionModal | division 컨텍스트 전달, 다건 |
| txtNickName (LIKE) | Form Nick Name InputField (p_nick_name) | Enter 조회 |
| CboDivision_SelectedIndexChanged → PlantSite 재조회 | division 변경 시 plantSiteIds 초기화 + ComboParam 갱신 | cascade |
| checkRequiredOfSearch (Division 필수) | handleSearch divisionId 가드 (MSG00429) | |

## 그리드 (design 03)

| AS-IS | TO-BE | 비고 |
|---|---|---|
| spdMain 13열 (SetSheetHeaderColumn + SpreadTitle) | DataGrid staticColumns = SHEET_COLUMNS(admin) / MAIN_COLUMNS fallback | DB 메타 구동 |
| LockColumn(1,max) 조회후 전체 lock (뷰) | 상시편집 + 셀 화이트리스트(daily_capa_qty만) | NSCM 표준(tact-time), 뷰/편집 토글 subsumed |
| SwitchLock EditButton (편집 진입) | (미노출) 상시편집 | daily_capa_qty 외 전부 잠금이라 뷰모드와 동치 |
| LockColumn(0,nick_name)+(created_by,last_update_date) 편집시 lock | isCellEditable = daily_capa_qty only + INPUT_TP_CD 'S' | 식별·감사셀 잠금 |
| CheckDigitValueEntered (Daily<1→1, MSG00085) | coerceDailyCapa (정수 min1) + cellEditEnded/pastedCell | MSG00085 |
| SaveData (action I/M/D, daily_capa_qty·valid_yn) | CRUD_TYPE dirty + saveWithValidation + useProcMutation | created_by/updated_by 스칼라 |
| checkValidN (Plant Total 필수, MSG00258) | validateMainRows Total 검증 (MSG00258 영문 fallback) | |
| SaveButton 확인(MSG00012)→성공(MSG00020)→재조회 | handleSave confirm(MSG00617)→mutate→react-query refetch | tran.Success = useProcMutation false-success 처리 |
| item_id '-'→'Total' | GET SP 변환(design 03 §4.1) — FE 표시 그대로 | SP 소관 |
| InsertButton/DeleteButton = NO-OP (빈 본문) | 툴바 미등록(hotkeyConfig insert/delete=false) | 로직 신설 안 함 |

## 편집제어 상태 (design 01)

- AS-IS 뷰→Edit→저장→뷰 상태기계 = TO-BE 상시편집 + 셀 화이트리스트로 재현(daily_capa_qty 유일 편집셀이라 등가). NSCM 표준(tact-time/formation) — 별도 Edit 토글 버튼 없음.
- 권한 division 0건 → SearchArea disable(R7): Division 콤보가 빈 옵션이면 조회 차단(divisionId 없음 → handleSearch 가드). 완전한 레이아웃 disable 은 후속(육안 축).

## 실행 체인 (배포 완료 — convert-sp 2026-09-22)

- `PKG_SCP0023.P_SCP0023_GET/SAVE_OUTSOURCING_CAPA` **VALID 배포**(ora.py 실측 2026-09-22 gap-resolve iter-1). PROC_M(all_arguments 1:1)·API_M·버튼·권한 메타 등록·검증. GET/SAVE 인자 계약이 FE payload(divisionId/plantSiteId/itemId/nickName/valid/debugMode · data/sesUserId)와 일치.
- GET human-doc 보완(07) 배포본 반영 확인(ora.py all_source): Pack Line Active 제외(`NVL(a.ATTRIBUTE1,'N')<>'Y'` 3-UNION 전건 L113/125/137), 3-UNION(모델+Total+미등록 L114/126), OSP_YN='Y', 이력 `SCP_MST_OUTSOURCING_CAPA_H`+`SEQ1_..._H`(VALID). 'ALL' 센티널·콤마 분할(F_LIST_PARAM) 처리 확인.
- 남은 미확인 = 브라우저 육안(조회/저장 실동작·편집 개방·toast)뿐 — 사용자 테스트 축.

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 7항목, 2026-09-22 gap-resolve iter-1 신설)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행 + 2026-08-14 공통 수정사항 2건.
> 화면 분석 md 에 없는 전 UI 공통 요구 — `asis_mapping_gate.py --check` 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter) | 해당없음 — 이 화면은 Insert 미노출 | AS-IS `override InsertButton()` 빈 본문 NO-OP(cs:233-235) → `OutsourcingCapacity.tsx` hotkeyConfig `insert:false`(신규행 추가 경로 자체 없음). 편집셀 = daily_capa_qty 단일(기존행 편집만). 신규행 Insert 요구 부재 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '작업중인 데이터가 있습니다. 조회 하시겠습니까?' confirm | `OutsourcingCapacityForm.tsx:70` `<SearchArea onSearch={onSearch}>`(공용 SearchArea 가 조회 전 dirty 레지스트리 확인해 confirm 내장) + `OutsourcingCapacityGrid.tsx:95` `DataGrid`(EditTracker 가 daily_capa_qty 변경을 dirty 로 자동 등록) | 공용 `SearchArea`+`DataGrid`(EditTracker) 경유라 화면 코드 별도 배선 불필요 — 공통 구조 그대로 사용 | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx`(`handleColumnSettingsSave`) | 컬럼 설정 저장 시 rows Reset/재조회 유도 로직 부재는 전 화면 공유 `packages/shared` 공통 동작 — Hard Boundary(convert-core §2.2)상 이 화면 gap-resolve 범위 밖(공통 컴포넌트 이슈로 별도 보고 대상, project-route 동일 판정) | 제외 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | `OutsourcingCapacity.tsx:99` `saveWithValidation(...,mutate)`(`useProcMutation` 표준 onSuccess = 성공 Toast) + `:84` 변경없음 `setToast({type:'error'})` | 저장 성공/변경없음 모두 Toast. 저장 전 검증 실패(daily_capa 필수·Plant Total MSG00258)는 CRUD 완료가 아니라 사전 차단이라 Alert 사용이 맞다(AS-IS MessageBox 동일 의미) | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (dataMap 승계) | `OutsourcingCapacity.tsx:128` `SubTitle excelFileName='OutsourcingCapacity'`(공용 `GridAction.excelDownload` 경유) | 이 화면 그리드 셀 콤보 **0건**(`SCM_MST_SHEET_COLUMNS` CELL_CONTROL_OBJECT_TYPE_CODE 전건 공란, ora.py 실측) → Code/Name 승계 이슈 자체 미해당. Excel export 경로는 공통 SubTitle 그대로 사용 | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | `useOutsourcingCapacityStore.ts:71` `setFilter`(Model itemId 원문 전달) → `PKG_SCP0023.P_SCP0023_GET` body `F_LIST_PARAM(P_ITEM_ID)`+`INSTR(V_ITEM_LIST,...)`(ora.py all_source L64/143 실측) | DB 실측: GET SP 가 P_ITEM_ID 를 콤마 분리(F_LIST_PARAM)해 IN 필터. FE 는 itemId 원문 그대로 전달, SP 가 콤마 분리 전담. NickName 은 LIKE 단건(다중 요구 없음) | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx`(`itemsSourceChanged` — 재조회로 데이터 재적재돼도 컬럼 필터 보존) | 공용 `DataGrid`(`OutsourcingCapacityGrid.tsx:95`)가 `itemsSource` 참조 변경(재조회) 시 filterDefinition 보존·재적용 — 이 화면 그리드도 공용 래퍼 경유 | 구현 |
