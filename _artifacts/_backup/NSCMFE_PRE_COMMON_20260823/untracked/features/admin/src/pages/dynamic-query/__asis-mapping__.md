# SYS0013 ↔ AS-IS SCM0005 이벤트 매핑 (재개발 2026-07-09)

> 기준 스펙: `Doc/화면설계서/SYS0013_DynamicQuery_상세동작_개발용.md` (이벤트 23종 전수)
> 원천: `GSCM\06.UIL\GSCM.SCM.Master.UIL\SCM0005_DynamicQueryList.cs`(1,255줄) + `POPUP\SCM0005_DynamicQueryListPopUp.cs`(782줄)

## 메인 폼 이벤트 11종

| # | AS-IS 이벤트 (줄) | TO-BE 구현 위치 | 상태 |
|---|---|---|---|
| 1.1 | Form_Load (L132) | `DynamicQuery.tsx` mount useEffect (fetchSearchConditions/fetchStaticColumns/초기 조회) | 구현 |
| 1.2 | FindButton (L285) | `handleSearch` — hotkeyConfig.search (hasButton 게이트) + staticColumns refetch | 구현 |
| 1.3 | InsertButton (L291) | `handleInsert` — GridAction.addRow (VALID_YN/ADMIN_ONLY_YN='Y' 기본 = AS-IS L955) | 구현 |
| 1.4 | DeleteButton (L296) | `handleDelete` — MSG00654 confirm + GridAction.removeRow('D' 마킹, 저장 시 확정) | 구현 |
| 1.5 | EditButton (L301) | (방식 상이) FE 상시 편집 + SHEET_COLUMNS INPUT_TP_CD 편집플래그 + 권한 게이트 — SwitchLock 토글 대체 | 구현(방식 상이) |
| 1.6 | SaveButton (L318) | `useDynamicQuerySave.handleSave` — main→columns→parameters→role 순차 (AS-IS 4-SP 체인 정합) | 구현 |
| 1.7 | spdMain_CellDoubleClick (L969) | `DynamicQueryMainGrid.handleDblClick` — Designer 진입 + 신규(I)행 차단(AS-IS L974) + child fetch | 구현 |
| 1.8 | fpGroup_CellDoubleClick (L1122) | 미구현 — AS-IS 원본이 무동작(빈 핸들러) | 해당없음(원본 no-op) |
| 1.9 | DsdmWhere_Changed (L1127) | EditTracker 자동 'M' 마킹 (Condition 그리드) | 구현(표준 대체) |
| 1.10 | DsdmGroup_Changed (L1168) | EditTracker 자동 'M' 마킹 (Columns 그리드) | 구현(표준 대체) |
| 1.11 | tabQuery_SelectedIndexChanged (L1209) | `TabWrapper setActiveTabIndex` → store.activePage | 구현 |

## SQL Query 팝업 이벤트 12종 — `DynamicQueryEditModal` 로 복원 (사용자 요구 2026-07-09)

> 진입: Register **Insert(신규 — 행 추가 후 모달 자동 기동)** / Register **행 더블클릭(수정)** — AS-IS 팝업 정합.
> View 탭 진입은 탭 클릭 (선택 행 기준 자동 구성 — AS-IS 조회모드 더블클릭 대체).

| # | AS-IS 이벤트 (줄) | TO-BE 구현 위치 | 상태 |
|---|---|---|---|
| 2.1 | Form_Load (L106) | `DynamicQueryEditModal` open useEffect — 대상 행 값 로드 (LoadData 정합) | 구현 |
| 2.2 | Dsdm_Changed (L177) | 모달 로컬 상태 편집 (OK 시 일괄 반영) | 구현(표준 대체) |
| 2.3 | FindButton (L193) | AS-IS 원본 무동작 | 해당없음(원본 no-op) |
| 2.4 | InsertButton (L198) | View 탭 `handleViewInsert` — 활성 그리드 라우팅 addRow | 구현 |
| 2.5 | DeleteButton (L203) | View 탭 `handleViewDelete` — 활성 그리드 removeRow | 구현 |
| 2.6 | EditButton (L214) | 모달 SQL 편집기 상시 편집 | 구현(방식 상이) |
| 2.7 | SaveButton (L278) | AS-IS 원본 no-op (mSave 는 dead code) — 저장은 공통 Save 일원화 | 해당없음(원본 no-op) |
| 2.8 | btnButtonList Click_Detected (L470) | **Confirm→모달 Validate 버튼** (검증+컬럼/파라미터 미리보기+자동채움) / **OK→onApply(행 반영+Role, 저장은 Save)** / **Close→폐기** — AS-IS 6버튼 정합 | 구현 |
| 2.9 | fpWhere_CellDoubleClick (L707) | AS-IS 원본 무동작 | 해당없음(원본 no-op) |
| 2.10 | rtxtSQL_TextChanged (L721) | AS-IS 원본 no-op — SQL 파싱은 Validate(DBMS_SQL DESCRIBE)로 구현 | 구현(격차①로 대체) |
| 2.11 | spdMain_ComboSelChange (L726) | 콤보 = CMBO_SQL_M(sysAggregateOptions) 메타 구동 | 구현(표준 대체) |
| 2.12 | fpWhere_ComboSelChange (L743) | 콤보 = CMBO_SQL_M(sysOperationOptions) 메타 구동 | 구현(표준 대체) |

**신규 저장 체인 (2026-07-09 3차 — AS-IS sDB_ID 정합 완결)**: `P_SYS0013_SAVE_QUERY_LIST` v3 가 O_RC1 에 `NEW_DQ_IDS`('#' 연결, I 행 순서 = payload 순서)를 additive 로 반환 → 모달 OK(신규) 시 보관한 Role/Validate 결과(Columns/Condition)를 Save 가 채번된 ID 로 후속 저장 (`useDynamicQuerySave` — main→columns→parameters→role, AS-IS SaveData 체인 정합). 이로써 신규 흐름도 모달 한 번으로 완결.

## 격차 2종 구현 (사용자 확정 D2)

| 격차 | AS-IS | TO-BE 구현 |
|---|---|---|
| ① SQL 사전검증+컬럼 자동추출 | 팝업 Confirm — 'SELECT TOP 0' 시험 실행 후 스키마 역추출 + MSG00148(미등재) | `handleValidate` → `PKG_SYS0013.P_SYS0013_VALIDATE_QUERY` (DBMS_SQL PARSE+DESCRIBE, 실행 0) → MSG00655 + Columns/Condition 빈 경우 자동채움 |
| ② 실행이력 | PR_DM_ADM_DQ_EXECUTE_HIST (L527, catch{} 침묵) | Execute 성공 시 fire-and-forget `history/EXECUTE/call-proc` → `P_SYS0013_EXECUTE_HIST` (.catch 침묵 정합) |

## Validation 22종 커버리지

스펙 §4 기준 — 재개발 반영: 구현 17 (기존 14 + 격차① 해소 3: #13/16/17) / 원본 no-op·dead code 유래 5 는 해당없음.
TO-BE 전용 10종(MSG00630/00012/00014/00617/00628/00629 게이트 등)은 신규 코드에 재이식 완료 + MSG00655 1종 추가.
