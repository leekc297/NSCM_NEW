# SCM0003 (Lookup) — AS-IS ↔ TO-BE cross-check

> Phase 7 cross-check 패턴 적용 (DMF0008 동등). 본 화면은 **TO-BE 기존 작성** — AS-IS와 cross-check 후 격차 식별. 작성: 2026-06-04.

화면 ID: SYS0010 (lookup)
AS-IS: `GSCM.SCM.Master.UIL/SCM0003_Lookup.{cs,Designer.cs}` (1212 lines)
TO-BE: `nscm-fe/features/admin/src/pages/lookup/`

---

## §1 Button 매핑 (CRUD 6대)

| Button | AS-IS 위치 | AS-IS 본문 | TO-BE hotkeyConfig | 매핑 |
|---|---:|---|---|---|
| Find | L253 | FindData() | (없음 — Form 의 onSubmit + setFilters) | ⚠️ search hotkey 없음 — Form Enter 키로 trigger |
| Insert | L258 | InsertRow | `insert: onInsert` (master/detail 분기) | ✅ |
| Delete | L263 | DeleteRow | `delete: onDelete` (master/detail 분기) | ✅ |
| Edit | L273 | toggle lock | (별도 IsReadOnly toggle) | ⚠️ hotkeyConfig 미지원 — DataGrid 의 allowEditing 자동 |
| Save | L296 | SaveData() | `save: onSave` (master/detail 분기 + 중복 check + sanitize) | ✅ |
| Excel | (없음) | — | `excel: false` 명시 | ✅ |

특화: activeGrid (master/sub) 에 따라 Insert/Delete/Save 동작 분기.

## §2 API 매핑 (3 SP)

| AS-IS SP | TO-BE sheetName | BE 메타 |
|---|---|---|
| `SCM0003_GET_LOOKUP_MASTER` (L320) | `LOOKUP_MASTER` | SCM_ADM_PROC_M 등록 의무 |
| `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) | `LOOKUP_DETAIL` | SCM_ADM_PROC_M 등록 의무 |
| `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L633) | `lookupDetail` MNU_BTN_CD=`AFTER_SAVE` | ✅ **wire 완료 2026-06-04** — `P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL` standalone + API_M/MNU_BTN_MPG/PROC_M 메타 + FE `mutateDetail.onSuccess` 내 `apiClient.post` fire-and-forget (AS-IS DoAfterSave 빈 catch 패턴 보존) |

→ ✅ **격차 #1 해소** (2026-06-04): `_artifacts/SCM0003_AFTER_LOOKUP_MASTER_DETAIL_PKG_SYS0010_addon_2026-06-04.sql` + `_artifacts/SCM0003_AFTER_LOOKUP_MASTER_DETAIL_meta_2026-06-04.sql` 적용. AS-IS 본문 모든 비즈니스 로직 주석 처리 (2025-02-10 mrchois) → 1:1 보존 (START/END LOG_BATCH + `'S'/result_cnt` cursor 반환).

## §3 Validation 매핑

| MSG ID | AS-IS 위치 | TO-BE 매핑 |
|---|---:|---|
| MSG00004 | L507, L614 (Save 결과 N rows) | `useSaveWithValidation` 의 onSuccess toast (자동) |
| MSG00002 | L764 (필수 입력) | `useSaveWithValidation` 안의 staticColumns validation 자동 |
| MSG00060 | L823 (중복 키) | `findDuplicateMasterRow` / `findDuplicateDetailRow` (`lookup.utils.ts`) + setAlert ✅ |

→ ✅ 모두 매핑. MSG00060 (중복) 의 placeholder `{0}` 은 빈 값 — i18n 개선 가능.

## §4 Cascade

| AS-IS handler | TO-BE 구현 |
|---|---|
| DataModel.Changed grep 결과 0 건 (cascade 없음) | (없음) — 매칭 |

→ ✅ cascade 격차 없음.

## §5 권한

| 항목 | AS-IS | TO-BE |
|---|---|---|
| 메뉴 권한 | (기본 — admin 메뉴 단순 Read) | SCM_ADM_USER_GR_MNU_BTN_MPG_M (메뉴 권한 표준) ✅ |
| 추가 분기 | (없음) | (없음) — 매칭 |

## §6 격차 종합 (3 건)

| # | 격차 | 우선순위 | 결정 |
|---:|---|---|---|
| 1 | ~~`SCM0003_AFTER_LOOKUP_MASTER_DETAIL` BE 메타 미등록 + FE TODO 마커~~ | ✅ 해소 2026-06-04 | standalone P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL + 4 BLOCK 메타 등록 + FE wire 완료 |
| 2 | Find/Search hotkey 없음 (Form Enter 만) | 低 | 의도된 차이 — search hotkey 적용 가능 (`search: handleSubmit`) |
| 3 | Edit toggle UI 별도 (FlexGrid 의 allowEditing 자동) | 低 | 의도된 차이 — TO-BE 가 더 깔끔 |

## §7 종합 평가

✅ TO-BE 작성 **양호** — AS-IS 의 모든 logic 거의 1:1 매핑. 격차 3건 중 #1 만 BE 작업 필요.

룰 v2 적용 상태:
- §1.2 #6 G1 GET (fetchSearchConditions) — 없음 (별도 fetchStaticColumns 만)
- 룰 07 DataGrid wrapper — ✅ 사용
- 룰 25 §1.5.1 asis-button-mapping — ✅ 5/6 매핑
- 메모리 `feedback_grid_editable_coloring_mandatory.md` — ✅ DataGrid 사용
- Phase 7 cross-check 패턴 — 본 문서 작성으로 적용

## §8 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | SCM0003 ↔ Lookup cross-check 작성. 격차 3건 식별 (#1 BE wire 후속) |
| 2026-06-04 | 격차 #1 해소 — P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL standalone + 4 BLOCK 메타 + FE `mutateDetail.onSuccess` 안 `apiClient.post('/SYS0010/lookupDetail/AFTER_SAVE/call-proc')` fire-and-forget wire. AS-IS DoAfterSave 빈 catch 패턴 보존 (실패가 사용자 흐름 차단 X) |
