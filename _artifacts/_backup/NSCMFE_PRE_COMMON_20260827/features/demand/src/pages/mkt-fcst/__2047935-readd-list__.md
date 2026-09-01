# DMF0003 — 커밋 2047935 신규 반영분 재적용 목록

작성 2026-08-13. **용도**: `2047935` 이전 파일(부모 = `3af4586`)로 통째로 원복한 뒤,
이 커밋으로 들어온 항목만 하나씩 다시 얹기 위한 체크리스트.

## 0. 커밋 좌표

| 커밋 | 내용 |
|---|---|
| `3af4586` | **원복 기준(= 2047935 의 부모)**. gridCombos 단일 출처 / 음수색 / seq 정렬 / F4 정적필터 / ROW_PARAM 콤보 / 워밍업 / 공용 saveTitleSet / Project Code 필수 가 살아 있는 상태 |
| `2047935` | `fix: mkt fcst 이규철이사 본 추가` — **이규철 이사 본 통째 덮어쓰기**. 아래 A-01~A-16 이 들어오고, 위 로컬 개선분이 함께 사라졌다 |
| `e1945a8` | mkt-fcst 무관 (다른 화면 동기화) |
| `78cdeef` | `fix: mkt fcst 수정` — 2047935 회귀 중 4종 복원 (음수 빨간 글자 / 동적 컬럼 seq 정렬 / F4 정적 컬럼 필터 / Column·Measure 저장 시 그리드 초기화). `MktFcst.tsx` +30-28, `MktFcstGrid.tsx` +83-37, `MktFcstForm.tsx` +1-1 |
| 워킹트리(미커밋) | gridCombos 정본화(D-12) + D-1/D-3/D-4/D-5/D-6/D-10 + 신규행 END_CUSTOMER 권한 콤보 |

원문 추출: `git show 2047935 -- <파일>` / 정리본(gridCombos 기반)은 현재 워킹트리.
줄바꿈 노이즈 제거해서 보려면 `--ignore-cr-at-eol -w` 를 붙인다 (24개 파일 중 실제 변경은 10개뿐).

## 1. 원복 전 경고 — 함께 사라지는 것

`3af4586` 으로 되돌리면 `78cdeef` 와 **현재 미커밋 작업분까지** 같이 날아간다.
아래 파일은 원복 대상에서 제외하거나, 원복 전에 반드시 따로 보관한다.

| 파일 | 판단 |
|---|---|
| `utils/mkt-fcst.gridCombos.ts` | **원복 금지**. 현재 트리가 가장 최신 (정본화 + 권한 콤보 + quoteParamAll) |
| `mkt-fcst.constants.ts` | **원복 금지**. 콤보 테이블 3종을 gridCombos 로 이관한 상태 |
| `components/MktFcstGrid.tsx` | 원복하면 D-5/D-6/D-10/D-12 + 4종 복원이 전부 되돌아간다. 원복할 거면 현재 파일을 먼저 백업 |
| `MktFcst.tsx` | 원복하면 `clearGridOnSettingChange` 등 78cdeef 분이 되돌아간다 |
| `utils/mkt-fcst.comboDebug.ts` | 임시 디버그. 최종 정리 시 파일 삭제 대상 |

## 2. 재적용 체크리스트

권장 순서: 준비물(B) → 콤보(A-03~A-06) → 잠금/클리어(A-07~A-10) → 게이트(A-11~A-12) → 나머지.

### B. 준비물 — 다른 항목의 전제

| # | 항목 | 파일 | 요지 |
|---|---|---|---|
| B-1 | `AS_FROM_SITE` 콤보 + `asSiteNamesRef` | MktFcstGrid | `{ comboId: 'AS_FROM_SITE', param1: "'<div>'" }` 조회 → `NAME` 집합. **비축향 판정의 유일한 근거** (AS-IS `dtAsSalesSite.Select("Name = …")` 1:1). A-03/A-05/A-07/A-09 전부 이걸 쓴다 |
| B-2 | `AsIncotermsEdit` 콤보 + `asIncotermsMapRef` | MktFcstGrid | A-03 전용 dataMap |
| B-3 | 콤보 `mnuId` quoting | MktFcstGrid | 조회 콤보 filter 에 `mnuId: "'DMF0003'"` — 없으면 `Measure` 콤보 0건 → 그리드가 measure 코드를 그대로 표시. 워킹트리는 `buildGridComboFilter` 가 담당 |

현재 트리 위치(B-1 적용 완료 2026-08-13): `MktFcstGrid.tsx:440~442`(콤보 조회 — `buildWsSupportComboFilters`
가 이미 `AS_FROM_SITE` 를 요청하고 있었고 그리드가 두 번째 결과를 버리던 상태였다. 신규 통신 없음),
`:456~465`(`asSiteNamesRef` 적재 + `invalidate`), `:471~474`(`isAsBoundRow` 판정 헬퍼 — A-07/A-09 공용).

### A. 재적용 항목

| # | 항목 | 근거 | 파일 / 현재 위치 | 상태 |
|---|---|---|---|---|
| A-01 | AS-IS 대사표 문서 | — | `__asis-mapping__.md` (신규 492줄) | 원복해도 untracked 로 남음. CA/CD/CE/CG 번호 체계의 출처이므로 **삭제 금지** |
| A-02 | 순수함수 단위 테스트 | — | `utils/mkt-fcst.core.test.ts` (신규 191줄) | division/editLock/save/sspSync import. 원복 시 `weekIndexOf`·`todayYmd`·`recalcDailyEditUnderWeekMonth` export 상태와 맞는지 확인 |
| A-03 | 비축향 행 INCOTERMS = AS 전용 목록 스왑 | CD-02 (.cs L3441·6517) | MktFcstGrid beginningEdit `:883~895` | B-1·B-2 필요. 후보 0건이면 스왑 생략(회귀 0) |
| A-04 | 행별 Plant Site 후보 (`PlantSiteByItem`) | CD-10 (.cs L4157·4166·6614) | `:399~414`(WeakMap+`applyPlantSites`), `:897~909`(스왑), `:1182~1186`(재조회 트리거) | 81* 한정. 트리거 = `PROJECT_CODE`/`ITEM_ID` 변경. 워킹트리는 `ROW_PARAM_EDIT_COMBO.PLANT_SITE_ID` 가 정의 보유 |
| A-05 | MEASURE 편집 후보 3분기 | E20260402-001736 1-a/1-b/1-c | `:930~950`, 규칙 본체 `gridCombos.filterMeasureEditRows` | 사이트 확정 → 비축향 `AS_In_Req` 단독 / 고객향 `MKT_FCST_RP` 단독, 사이트 미정 + 비W·S + 81*/82 → `AS_In_Req` 제거. **주의: 이 1종 고정을 걷어내자는 반대 의견이 있었다(D-7 보류) — 업무 확정 후 적용** |
| A-06 | Div 82 FCST Type `WS`/`WSF` 제거 | 통합테스트 1st No.54 | 목록·필터 `gridCombos.FCST_TYPE_DIV82_BLOCKED`/`filterFcstTypeRows` `:407~427` + MktFcstGrid 조회 dataMap `:306~317`·조회 rows 미러 `:327~334`·편집 후보 `swapEditCandidates` `:968~972` | **적용 완료 2026-08-13**. 조회 표시 dataMap 과 편집 후보가 **같은 함수**를 거치게 했다 — 한쪽만 걸면 편집에서는 못 고르는데 조회 표시에는 남아 CODE→NAME 변환만 살아 있는 불일치가 된다. MEASURE 필터와 달리 후보 0건 fallback 없음(82 에서 WS·WSF 는 업무상 선택 불가). 82 판정은 `DIVISION.ESS` 상수. 81* 영향 0, 콤보 SQL(`FCST_TYPE`/`FCST_TYPE_NOT_ETC`) 무수정 — 화면단 필터 |
| A-07 | AS_FROM_SITE 잠금 2종 | CE-02 (.cs L3480~3483) + No.56-① | MktFcstGrid `isAsFromSiteEditable` `:483~496` | **적용 완료 2026-08-13**. 기존 2축(Insert·W/S Planner·FcstType) 에 (1) 비축향 행 잠금(`isAsBoundRow`) (2) Sales Site 미입력 행 잠금(`rowSalesSite` 공란) 추가 = 4축. 콤보 늦게 도착 시 셀 색이 굳는 문제 때문에 `asSiteRows` 적재 effect 에 `invalidate(true)` 동반 |
| A-08 | I 행 키값 변경 → 수량 전량 클리어 | CG-05 (.cs L5319~5379) | 키 목록 `gridCombos.ROW_KEY_BINDINGS` `:329~355` + MktFcstGrid cellEditEnded `:1283~1296` + MktFcst `clearDynQuantities` `:490~501`, 호출 `:816`(Project)·`:854`(Item) | **적용 완료 2026-08-13**. 두 경로 모두 반영. 원문(`__grid-combos__.md` #6)은 트리거가 **정적 컬럼 아무거나**였으나 **키 컬럼 한정**으로 좁혔다 — REMARK·VMI_YN·ITEM_NAME 처럼 행 정체와 무관한 컬럼 편집으로 입력한 수량이 날아가는 건 손실이다. 키 컬럼 정의는 `division.ts buildDuplicateKey`(중복검증 키) 와 동일 셋을 쓴다(DIVISION_ID 제외 — 행 편집 대상 아님). 양쪽 모두 **같은 값 재선택은 클리어 안 함**(그리드=`changed` 게이트, 팝업=이전 값 비교) |
| A-09 | AS 조건 파기 시 값 클리어 | CE-04 (.cs L3478~3483·3506·3587·3597) | MktFcstGrid cellEditEnded `:1266~1279`, 트리거 목록 `gridCombos.AS_FROM_SITE_CLEAR_TRIGGERS` | **AS_FROM_SITE 분 적용 완료 2026-08-13** — 비축향이거나 FCST Type 비 W/S → `AS_FROM_SITE=''`, 같은 `INSERT_GROUP_ID` 형제 행 일괄. FcstTypeWs 집합 0건이면 미실행(오클리어 방지). **`MEASURE=''` 분은 미적용 — A-05 와 함께 처리해야 한다**: measure 후보를 사이트로 좁히는 규칙(1-c)이 2026-08-10 요구로 걷어내진 상태라, 지금 넣으면 현재 규칙상 허용되는 조합(예 비축향 사이트 + `MKT_FCST_RP`)의 값을 근거 없이 지운다 |
| A-10 | Insert 행 머지 제외 강화 | 통합테스트 1st No.57 | `utils/mkt-fcst.merge.ts:90~` | 자기 행 판정 + **형제 판정(`sameRow`)에도** `CRUD_TYPE==='I'` 차단 추가. 원문은 `CRUD_TYPE` 상수 import 를 지우고 리터럴 `'I'` 로 바꿨는데, 상수 유지가 낫다 |
| A-11 | DM Planner 시간창 게이트 재활성 | CA-04 (.cs L862~874) | MktFcst `:459~475` | 주석 상태였던 블록을 코드로 되살린 것. MSG00478 5파라미터(`CODE` `^` 분리). 운영 lookup 0행이면 미발동 |
| A-12 | 조회 선행 강제 | CA-07 (.cs L941~945) | MktFcst `guardEditGates` (2b) `:424~427` | **적용 완료 2026-08-13**. 원문의 inline alert 대신 기존 미사용 헬퍼 `validation.validateEditMode(hasSearched)` 호출로 구현. `MSG.EDIT_AFTER_SEARCH='MSG00662'` 는 원복본에 이미 존재 |
| A-13 | 조회조건 End Customer = 표준 카탈로그 | — | MktFcstForm `EndCustomerField` | 화면 로컬 `CustomDropdown` + `endCustomerCombo` 필터를 표준 필드로 교체. 원복 시 로컬 구현으로 되돌아간다 |
| A-14 | 조회조건 Sales Site = `UserSiteByEndCustomer` 서버 바인드 | — | MktFcstForm `q()` + filter | `q(v) = "'" + (공란이면 ALL) + "'"`. **공란 → `'ALL'` 규약의 출처** (신규행 최초 EndCustomer 스펙 노트와 동일 계보). 원복 시 `SiteByEndCustomer`/`UserSiteByEndCustomer` 2개 조회 + 클라 필터로 되돌아간다 — 어느 쪽을 쓸지 결정 필요 |
| A-15 | 스타일 | — | `MktFcst.module.scss` | **재적용 불필요 — 2026-08-13 사용자 결정으로 폐기**. 원문 내용: 현재기간 셀 `border-right: 2px solid #1e8449` 추가 + Measure 선택 모달 레이아웃(`.measureDualContainer`, `.measureActionBar`). 현재 트리는 `border-left` 만 유지(`:54~55`), 모달 클래스 2종은 사용처가 없어 넣지 않는다. **작업 없음** (원복본에 애초에 없었으므로 걷어낼 것도 없음) |
| A-16 | 깜빡임 방지 주석 2건 | — | MktFcstGrid | (1) `DataGrid` 에 `key` 주지 말 것 (2) `onPopupCellDblClick` 을 effect dep 에 넣지 말 것. 코드 변경은 없고 재발 방지 주석 |

## 3. 원복하면 되살아나므로 다시 걷어낼 것

`3af4586` 에는 없던(= 2047935 가 만든) 퇴행이라, 원복하면 자동으로 해결된다.
반대로 **원복 후 A-xx 를 얹을 때 다시 끌고 들어오지 않도록** 주의할 목록.

| 항목 | 2047935 가 만든 상태 |
|---|---|
| 콤보 정의 위치 | gridCombos → `mkt-fcst.constants.ts` 하드코딩 역이관 |
| 음수 빨간 글자 | `paintNegative` 삭제 |
| 동적 컬럼 정렬 | `seq` tie-break 삭제 → 연말 분할주 `W53+`/`+W53` 분리 |
| F4 필터 | `filterChanging` cancel + `filterColumns` sanitize 로 정적 컬럼 필터 무력화 |
| Column/Measure 저장 | `clearGridOnSettingChange` 삭제 |
| 표시명 재기입 | formatItem 표시명 블록 삭제 (신규행 Measure 편집 중 기존 행 이름 사라짐) |
| dataMap 원복 | `ROW_PARAM_EDIT_COMBO` 원복 누락 |
| 공용 `saveTitleSet` | 화면 로컬 함수 60줄로 복제 |
| 죽은 상수 | `MEASURE_FALLBACK` · `SHEETS.MEASURE_COUNT` 부활 |
| 필수값 검증 | `RequiredField` 튜플화 → **Project Code 필수 소실** + 미등록 라벨 `_LBL00679` 화면 노출 + 메시지 끝 `(행번호)` 부착 |
| 초록 rail | 당주 `W_` 한정(`shouldRailCurrentPeriod`) → 전 버킷 확대 |
| 기본 Division | `session.div ?? MOBILITY` → `MOBILITY` 고정 (로그인 본부 무시) |

## 4. 검증 (node_modules 미설치 상태라 정적 검증 불가)

`pnpm install` 후 `pnpm --filter @demand exec tsc --noEmit` / `vitest run mkt-fcst.core`.
그 전까지 IDE 의 `Cannot find module '@mescius/wijmo…'` 계열 진단은 전부 의존성 부재 artifact.
