# SCP0121_OwnerPopup — AS-IS ↔ TO-BE 매핑

> AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0121_PlanGroupMaster/SCP0121_OwnerPopup.cs`(+`.Designer.cs`)
> TO-BE: `nscm-fe/features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx`(+ store/constants/scss)
> 판정: 신규(NEW). 부모 화면 SCP0121_PlanGroupMaster 는 미전환(이 팝업만 선행 생성).

## 재사용 결정 — 전용 신규(공용 OwnerModal 미재사용)

공용 `OwnerModal`(COM0004, `features/master/src/components/ownerModal/`)은 좌/우 2그리드 transfer UI 가
동형이지만, 데이터 계약이 AS-IS 와 다르다(convert-core §2.6, `ora.py` SP 본문 실측 PKG_COM0000 L186~439):

| 축 | AS-IS SCP0121 | COM0004(실측) | 판정 |
|---|---|---|---|
| division 권한필터 | `FxUGA.Code = p_division_id` | 권한 JOIN 주석처리(2026-09-14 POJ) → 전 사용자 반환 | 불일치(후보 범위 상이) |
| 검색 3번째 컬럼 | `DEPT_NAME_KO` | `USER_NAME_EN` | 불일치 |
| UserName | 이름 + ' ' + `JOB_NAME` | 이름만(JOB_NAME 결합 주석처리) | 불일치 |
| Base/User 분리 | 서버 2커서(`p_owner_id` NOT IN/IN) | 단일커서 + 클라 분리(`p_owner_id` 없음) | 불일치 |

→ 그대로 재사용하면 후보 집합·표시·검색이 조용히 달라진다(silent drift). **전용 모달 신규**로 결정.
공용 컴포넌트를 표본(few-shot)으로 골격만 참조하고, SCP0121 전용 SP 계약(2커서·division 필터·3컬럼
콤마검색·UserName+직급)을 재현했다. 참고: 크로스-피처 import 는 이 repo 에서 실사용되나(bod →
master `RegionModal`), 재사용 불가의 결정 근거는 import 규칙이 아니라 위 SP 의미 불일치다.

## 워크플로 매핑

| AS-IS (cs 라인) | TO-BE | 비고 |
|---|---|---|
| `SCP0121_OwnerPopup(sDivision, sOwner)` 생성자 (L111) | props `divisionId` / `ownerId` | 부모 주입 |
| `Form_Load` → `GetOwnerData(true)` (L132, L296~307) | open effect → `useTabProcQuery`(초기 조회) + o_rc1/o_rc2 둘 다 바인딩 | R1 |
| `FindButton`/`btnButtonList[Find]` → `GetOwnerData(false)` (L195, L489~497) | `handleSearch` → searchParam 교체(Base 만 재바인딩, User 유지) | R2 |
| 재조회 전 현재 User UserID CSV → `_Owner`(p_owner_id) 재전달 (L263~270) | `handleSearch` 가 `ownerId = userRows.map(UserID).join(',')` 재전달 | 02 §3 |
| `btnRight[▶]` / `spdBase_CellDoubleClick` → `SetTitleSet(Base)` (L499, L508, L350~456) | `handleMoveToUser` / `handleDblClick('base')` → `moveRows('base')` | R3 |
| `btnLeft[◀]` / `spdUser_CellDoubleClick` → `SetTitleSet(User)` (L503, L512) | `handleMoveToBase` / `handleDblClick('user')` → `moveRows('user')` | R4 |
| 이동 후 대상 SORT_ORDER_NO 오름차순 정렬 (L440~446) | `sortBySortOrder` (대상 리스트 정렬) | R3/R4 |
| 이동 후 삽입행 activeRow 활성화 (SetTitleSet, L408~429) | `pendingActivateRef` + 대상 rows effect → `select`/`scrollIntoView`(옮긴 행 활성화) | R7(iter-2 GAP-02). 위치삽입은 SORT_ORDER_NO 정렬로 흡수 |
| 선택 없으면 ActiveRow 자동선택 이동 (L355~356) | `pickRows` — `selectedItems` 없으면 활성행 1건 | V8 |
| `usrButtonList1[OK]` → `SaveTitleSet` (L200, L461~487) | `handleConfirm` → `onConfirm({owner, userNameEn})` CSV | R5 |
| User 0행 시 `MSG00071` 후 차단 (L461~) | `handleConfirm` — 0행이면 `t('MSG00071')` alert 후 return | R5/V5 |
| `usrButtonList1[Cancel]` → `this.Close()` (L211~213) | `modalClose` | R6 |
| 두 그리드 전 컬럼 `LockColumn` 읽기전용 (L306~307) | 두 `DataGrid` `isReadOnly` | 03 §3-4/5 |
| 컬럼 = `CreateSheetHeaderColumn`(DMF0000 타이틀 SP, DB메타) (L168~169) | `staticColumn` = admin fetch(`/admin/menu/DMF000/column`, sheet 'Owner Base') | 03 §3-1, 하드코딩 금지 |

## 미이식 / 확인 필요 (재현 시도 금지 근거)

| 항목 | 근거 | 처리 |
|---|---|---|
| `SUB_TOTAL_FLAG` 셀버튼 단일선택 (`spdUser_ButtonClicked`, cs L517~527) | 컬럼·셀버튼이 SP 반환셋/DB 메타(DMF000) 어디에도 없음(설계 03 §1-C). ButtonClicked 발화 대상 부재 → dead | **미이식(vestigial)**. TitleSet 팝업에서 복사된 잔재 |
| `usrButtonList2` (Visible=false, 핸들러 전체 주석, dsg L109/cs L534~537) | 런타임 미노출·미배선 | **미이식(dead)** |
| `ResetWidth`/`SplitterDistance` 동적계산 (cs L239~257) | `_sTitleSetType`/`_isSubTotal` 할당 경로 없음 → 항상 false → 폭가산 0 (설계 01 §5-1) | **미이식(dead)**. 고정 850×400 + 좌우 1:1 flex |
| `pnlCenterButton` SizeChanged 세로중앙 재계산 (cs L529~532) | JS 재계산 불요 | CSS `justify-content:center` 로 대체(R9) |
| User 그리드 행 드래그 재정렬 + `USER_SELECTABLE_FLAG!=='Y'` 드롭 취소 (AllowRowMove, cs L539~546) | SP 가 항상 `'Y'` 반환 → 가드는 dead. 공용 `DataGrid` wrapper 는 행 드래그 재정렬 prop 을 노출하지 않음(shared 수정은 Hard Boundary 위반) | **미구현(확인 필요, 사용자 축)**. 순서는 SORT_ORDER_NO 정렬로 확정. 04 리포트 명시 |
| "Find" 라벨 | `SCM_ADM_MSG_M` LBL 에 "Find" 없음(Search=LBL00664 존재, 설계 02 §4.5) | 공통 Search `t('LBL00664')` 로 배선(설계단계 신규 채번 금지) |
| 모달/그리드 타이틀 "Multi Owner Set"/"Owner Base"/"Owner User" | `SCM_ADM_MSG_M` 에 등가 LBL 코드 없음(실측: LBL00337=Customer Popup, LBL00338=Dept ID(Name) — 오매핑 금지, Hook #114) | 시맨틱 키 + 영문 fallback(`LBL_MULTI_OWNER_SET`/`LBL_OWNER_BASE`/`LBL_OWNER_USER`) — bod `LBL_DISTRIBUTION_ROUTE` 선례. MSG 메타 임의 INSERT 금지 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> SCP0121_OwnerPopup 은 transfer 팝업(두 그리드 읽기전용, Base↔User 이동, OK=CSV 반환). CRUD/편집/콤보/Excel 축은 구조상 해당 없음. 콤마 다중검색은 해당(구현).

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | - | 팝업에 신규행 Insert 없음 — 행 "추가"는 Base→User 이동(moveRows)이지 그리드 신규행 생성 아님. 두 그리드 읽기전용. 미해당 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm | - | 편집 모드 없음(두 그리드 read-only, 저장 SP 없음). 미저장 수정 상태 부재로 재조회 confirm 미해당 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | - | Column/Measure 설정 버튼 없음(팝업, Measure 0). 사용자 컬럼 편집 UI 부재 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 | - | CRUD 경로 없음 — OK 는 owner/userNameEn CSV 를 부모로 반환할 뿐 저장/삭제/등록 이벤트 없음. 완료 Toast 미해당 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터 Code 아닌 Name 출력 | - | 팝업에 Excel export 없음. 두 그리드 콤보 컬럼 0(전 컬럼 read-only 텍스트, CELL_* 메타 공란). Code↔Name 매핑 대상 부재 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 콤마 구분 다중 입력 시 전건 조회 | OwnerSelectModal.tsx(handleSearch→p_search) | 검색어를 raw 로 SP 에 전달(콤마 다중 축소 없음). AS-IS 콤바 다중검색(3컬럼 OR LIKE, String_Split)은 SP 계약(P_SCP0121_GET_OWNER_DATA_POPUP, 미배포) — FE 는 원문 전달로 계약 준수 | 구현 |
| COMMON:UC-07 | 필터 걸린 상태 재조회 시 조회되고 필터도 그대로 적용(rebindFilterColumns) | - | 팝업 재조회 = Base 그리드만 교체(User 유지), 컬럼 필터 UI 는 공용 DataGrid 소관(화면 고유 필터 배선 없음). 화면 레벨 요구 미해당 | 해당없음 |
