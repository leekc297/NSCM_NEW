# SCP0022 Formation — AS-IS ↔ To-Be 매핑 매트릭스

> AS-IS `GSCM.SCP.Forms.UIL/Master/SCP0022_Formation/SCP0022_Formation.cs`(1920L, +Designer 523L) → To-Be `features/supply/src/pages/formation`.
> 근거: `.atlas/gscm-design/SCP0022/design/00~03`(정식 설계 4문서) + DB 실측(`ora.py`, TO-BE Oracle `SCM_MGR`, 2026-09-28).
> gap 리포트(판정/self-check/정직보고): `.atlas/gscm-design/SCP0022/design/04_react-gap.md`.
> 이 문서는 **실제 소스 상태**를 그대로 기재한다(코드에 없는 구현을 "구현"으로 적지 않는다 — convert-core §4.3).

## 1. 화면 구조

| 영역 | AS-IS | To-Be | 파일 |
|---|---|---|---|
| Layout | splitContainer1(상/하) | `PanelGroup vertical`(상 Formation 55% / 하 Except 탭 45%) | `Formation.tsx` |
| 검색조건 | cboDivision(단일·필수) | Division CustomDropdown (`MyDivision`), 기본값=목록 첫 항목 자동선택 | `FormationForm.tsx` |
| 검색조건 | clbPlantSite(다중 체크리스트) | Plant Site multi CustomDropdown (`PlantByDivisionOperNonOsp1_SCP_ALL` 전량 조회 + **FE 클라 필터** `DIVISION_ID`=선택division·`OPERATION_GROUP='A'`) | `FormationForm.tsx` |
| 검색조건 | btnItemId(팝업) | Material 팝업 버튼 → `MaterialByDivisionModal`(scpModuleType=SCP0022) | `FormationForm.tsx` |
| 상단 그리드 | spdMain(Formation) — 기존행 수정 전용, Insert 없음 | `FormationGrid` | `components/FormationGrid.tsx` |
| 하단 탭1 | spdExcept(Formation Except) — Insert/Delete/수정 | `FormationExceptGrid` | `components/FormationExceptGrid.tsx` |
| 하단 탭2 | spdExcept_LT(Formation Except LT) — Insert/Delete/수정 | `FormationExceptLtGrid` | `components/FormationExceptLtGrid.tsx` |
| 탭 전환 | ActiveSheetChanging(수정 중 전환 시 MSG00129 가드, cs:1904-1913) | `Formation.tsx handleLowerTabChange` — controlled `TabWrapper`(activeTabIndex/setActiveTabIndex), 편집중(dirty CRUD_TYPE) 전환 차단+MSG00129 | `Formation.tsx` |

## 2. 검증 (설계 03 §3 R4/R6 · 00_checklist §4.3)

| AS-IS Msg | 시트 | 규칙 | To-Be | 상태 |
|---|---|---|---|---|
| MSG00203({1,100})→MSG01037 | Main·Except | 수율(FORMATION/CHAR/SSP_MODIFY) 1~100, 위반 시 1로 리셋 | `FormationGrid`/`FormationExceptGrid` cellEditEnded → `t('MSG01037')` | 구현 |
| MSG00193→MSG00699 | Main·Except_LT | LT_FORMATION > 0(정수), 위반 시 1로 | `FormationGrid`/`FormationExceptLtGrid` cellEditEnded → `t('MSG00699')` | 구현 |
| MSG00085 | Main·Except_LT | ADD_LT_FORMATION 정수·**음수 허용**(min -9999999999). 파싱 실패 시에만 0으로 리셋 | 위 2그리드 cellEditEnded → `t('MSG00085')`(NaN 일 때만) | 구현(정정 — 이전엔 음수 차단, design 03 §1.1 SO7 기준 음수 허용으로 수정) |
| MSG00071 | Except/LT | Insert 시 Main 행 미선택 차단 | `Formation.tsx handleInsert` → `t('MSG00071')` | 구현 |
| MSG00108 | Except·Except_LT | 시작일 > 종료일 차단(편집행) | `Formation.tsx handleSave` → `t('MSG00108')`(toYmd8 8자리 정규화 후 비교) | 구현 |
| MSG00048 | Except·Except_LT | 날짜 하한(<17530101) 차단(전체행) | `Formation.tsx handleSave hasBelowLowerBound` → `t('MSG00048')` | 구현(보완 — 이번 회차 신규) |
| MSG00105 | Except·Except_LT | 같은 키 기간 겹침 → 저장 전 차단 | `Formation.tsx handleSave hasPeriodOverlap`(전체행 키그룹 pairwise) → `t('MSG00105')` + 서버 99010 반환 시 `handleExceptError` 로 MSG00105 매핑 | 구현(보완 — 클라 pre-check + 서버오류 매핑. **겹침행 셀 색상(InvalidColor) 하이라이트는 미구현** — §3 잔여) |
| MSG00129 | Except↔Except_LT | 수정 중 탭 전환 가드 | `Formation.tsx handleLowerTabChange`(controlled TabWrapper, dirty 검사) → `t('MSG00129')` | 구현(보완 — 이번 회차 신규. DB 실측 코드 존재 확인) |
| MSG00049(형식) | Except·Except_LT | 날짜 형식오류 | 셀타입 `FPDateText`(DB 메타)가 형식 강제 → 별도 형식검증 없음 | 구조대체(형식은 셀타입 강제, AS-IS 색상 피드백만 없음) |
| MSG00020 / MSG00004 | Main / Except·LT | 저장 성공(그리드별 다른 코드) | 공용 `useProcMutation` 성공 toast(MSG00002, 코드 구분 없음) | 구조대체(공용 훅 표준. DB 실측: TO-BE SAVE 는 표준 '0'/'-1' 반환) |
| MSG00043 | Except·LT | PK중복(2627) + 중복셀 배경 | 서버 오류 → `handleExceptError` 제네릭/99010 매핑. 중복셀 배경 미표시 | 잔여·저(겹침=99010→MSG00105 로 흡수, 순수 PK중복 셀 하이라이트는 미구현) |

## 3. 특이 로직(grid-behavior) 처리 주체

| 로직 | AS-IS | To-Be | 처리 주체 |
|---|---|---|---|
| setTotalYield 파생 | cs:1846~1870 | `calcTotalYield`(constants) — 편집 시 재계산 | 화면 코드 |
| 신규행 상속(Div/Plant/Item/Nick + 수율/LT) | InsertRow | `handleInsert`(Formation.tsx) Main 선택행 복사 시드 | 화면 코드 |
| 상속셀·키·감사 잠금 | LockColumn | 컬럼 메타 INPUT_TP_CD=S(DB 실측) | 컬럼 메타 |
| 편집가능 셀 white-list | LockColumn/LockRange | 컬럼 메타 INPUT_TP_CD(M/O) | 컬럼 메타 |
| SmartColMerge | roslyn 312/326/340 | `AllowMerging.None`(3그리드) | 화면 코드 — 사용자 확정 드리프트(memory `scp0022-formation-grids-no-cell-merging`), 갭 아님 |
| ORG_* 5키 왕복(기간키 변경) | 조회 수령→저장 반송→UPDATE WHERE 원본키 | Except/Except_LT hidden 컬럼 + 제네릭 useProcMutation row 왕복 | 컬럼 메타 + PKG(배포 확인) |
| 기간 겹침 색상(InvalidColor) | SetBGColor(R6 1013/1154..) | **미구현**(클라 pre-check MSG00105 로 저장 차단은 함, 셀 배경 하이라이트 없음) | 잔여(UX 패리티·사용자 축) |

## 4. 콤보 (design 02 · 04_react-gap §2)

| 콤보 | AS-IS 원천(CODE + SP변형 + 클라필터) | To-Be 콤보 ID | 판정 |
|---|---|---|---|
| Division | `BLUtils.GetDivisionWithoutEE`→`UP_FX_GetCommonDataList_SCP`(code=Division) + 클라필터 `ATTRIBUTE3<>'EE'` | `MyDivision` | 구현 — EE제외·권한이 CMBO SQL WHERE 에 반영(DB 실측) |
| Plant Site | `Data_SCP.CommonAll(PlantByDivisionOperNonOsp1)`→`UP_FX_GetCommonDataList_SCP_ALL` + 클라필터 `DIVISION_ID`+`OPERATION_GROUP='A'`+OSP제외 | `PlantByDivisionOperNonOsp1_SCP_ALL`(전량 조회) + FE 클라 필터 | 구현(정정) — DB 실측(2026-09-28): 반환 CODE=SCM_SITE_ID/NAME/OSP_YN/OPERATION_GROUP/DIVISION_ID, `SITE_TYPE='PLANT' AND VALID_YN='Y' AND OSP_YN='N'` baked = AS-IS SP 본문과 1:1. division·OPERATION_GROUP='A' 는 FE 클라 필터(`FormationForm.tsx plantSiteOptions`)로 재현. **이전 `PlantByDivisionCompany`(SCM_MST_PLANT_SN·PLANT_ID, 다른 원장) 오매핑을 정정**(convert-core §2.6 실사고 원천 화면) |
| Material(Item) | `SCM0002_MaterialByDivisionPopup`(division 컨텍스트) | `MaterialByDivisionModal`(features/master 재사용, scpModuleType=SCP0022) | 구현 |
| 그리드 콤보 | 0건(InitSpread AddComboColumn 없음) | 해당 없음 | 정합(DB 실측: 55컬럼 CELL_COMBO_DATA_TYPE 전건 NULL) |

## 5. DB 메타 게이트 (이번 회차 ora.py 재실측, 2026-09-28 · 전건 기존 등록 확인)

| 게이트 | 대상 | 실측 결과 | 상태 |
|---|---|---|---|
| 메뉴 등록(2.7) | `SCM_ADM_MNU_M` MNU_ID=SCP0022 | 1행(MNU_URL=formation, UPPR=Supply_Master, USE_YN=Y) | 확인만(기존 등록) |
| 컬럼 메타(2.75) | `SCM_MST_SHEET_COLUMNS` PROGRAM_ID=SCP0022 | 55행(16/20/19) = design 03 일치 | 확인만 |
| Measure(2.75) | `SCM_MST_SHEET_MEASURE` | 0행(동적 pivot 없음) | 확인만 |
| 콤보(2.76) | `SCM_ADM_CMBO_SQL_M` MyDivision / PlantByDivisionOperNonOsp1_SCP_ALL | 둘 다 존재·SQL 본문 실측 | 확인만 |
| 버튼 API(2.8) | `SCM_ADM_MNU_BTN_MPG_M` | 6행 → **iter-6: 10행**(except/exceptLt × INSERT/DELETE 추가, API_ID NULL — 자매 SCP0001 미러) | iter-6 등록 |
| 권한(2.8) | `SCM_ADM_USER_GR_MNU_MPG_M`(2행 ADMIN/SCP Planner) · `SCM_ADM_USER_GR_MNU_BTN_MPG_M`(12행 → **iter-6: 20행**) | 존재·확장 | iter-6 등록 |
| 버튼 게이팅(FE) | `Formation.tsx` hotkeyConfig | **iter-6**: `useTabBtnPermissions().hasButton()` 로 SEARCH/SAVE/INSERT/DELETE 게이팅(자매 PlantSite 패턴). `false`=권한없음 숨김(의도된 동적 동작, NO-OP 숨김과 구분). manual/upload=false(admin 정의 없음) | 구현 |
| MSG 라벨 | MSG00048/105/129/043/108/071/699/085/01037 | 전건 SCM_ADM_MSG_M 존재(EN) | 확인만 |
| PKG_SCP0022 | GET 3 / SAVE 3 | 배포·VALID(design 03) | 확인만(convert-sp 소관) |

## 6. 정직 보고 (검증 축 — convert-react 이번 실행)

| 축 | 상태 | 사유 |
|---|---|---|
| FE 소스 대조 + grep 게이트 | PASS | 상대경로/console/inline/any/직접cast/editMode/자체행상태 0 hit |
| type-check(supply 도메인) | PASS | `pnpm --dir nscm-fe/features/supply type-check` = 0 error |
| lint(formation 폴더) | PASS | `eslint src/pages/formation` = 0 error/warning (도메인 타 폴더의 기존 lint 오류는 Hard Boundary 밖) |
| DB 메타 게이트(ora.py) | PASS | §5 전건 실측·기존 등록 확인 |
| 겹침행 셀 색상(InvalidColor) | 미구현(잔여·저) | 클라 pre-check MSG00105 로 저장 차단·서버 rollback 으로 무결성 보장. 시각 하이라이트만 잔여(사용자 축) |
| 브라우저 시각·조작 | 미수행(사용자 축) | 소스·DB 대조만. 렌더/조작감은 전환 검증 단계 |

> 세부 판정 근거(줄번호·roslyn·DB 실측 쿼리)는 `04_react-gap.md` 를 1차 출처로 한다.
