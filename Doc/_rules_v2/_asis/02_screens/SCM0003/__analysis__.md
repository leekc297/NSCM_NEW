# SCM0003 (Lookup) — AS-IS 정밀 분석 + TO-BE cross-check

> 기존 TO-BE 작성 화면 (`features/admin/src/pages/lookup/`) cross-check. 작성: 2026-06-04.

## §0 메타

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.SCM.Master.UIL/SCM0003_Lookup.{cs,Designer.cs}` (1212 lines) |
| TO-BE MNU_ID | `SYS0010` |
| TO-BE MNU_URL | `lookup` |
| TO-BE UPPR_MNU_ID | `Admin_Menu` |
| TO-BE 위치 | `nscm-fe/features/admin/src/pages/lookup/` ✅ **이미 작성** |
| 기능 | Lookup 마스터 / 디테일 관리 (SCM_ADM_LOOKUP_MASTER + SCM_ADM_LOOKUP_MASTER_DETAIL) |

## §1 AS-IS Button (CRUD)

| Button | AS-IS 위치 | 본문 | TO-BE 매핑 |
|---|---:|---|---|
| Find | L253 | FindData() | `search` |
| Insert | L258 | InsertRow (행 추가) | `insert` |
| Delete | L263 | DeleteRow | `delete` |
| Edit | L273 | (toggle lock) | (별도 toggle) |
| Save | L296 | SaveData() | `save` |

## §2 API / SP (3개)

| # | SP | sheetName |
|---:|---|---|
| 1 | `SCM0003_GET_LOOKUP_MASTER` (L320) | `master` |
| 2 | `SCM0003_GET_LOOKUP_MASTER_DETAIL` (L359) | `detail` |
| 3 | `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` (L633) | (Save 후 정리) |

## §3 Validation

| MSG ID | 의미 | AS-IS 위치 |
|---|---|---:|
| MSG00004 | Save 결과 (N rows) | L507, L614 |
| MSG00002 | 필수 입력 | L764 |
| MSG00060 | 중복 키 | L823 |

## §4 TO-BE 기존 작성 인벤토리

```
nscm-fe/features/admin/src/pages/lookup/
├─ components/
├─ index.ts
├─ lookup.constants.ts
├─ Lookup.module.scss
├─ Lookup.tsx
├─ lookup.utils.ts
└─ useLookupStore.ts
```

- `components/LookupForm.tsx` — 조회조건
- `components/LookupMasterGrid.tsx` — master grid
- `components/LookupDetailGrid.tsx` — detail grid

## §5 Cross-check (룰 v2 적용 vs 기존)

| 항목 | AS-IS | TO-BE 현재 | 격차 |
|---|---|---|---|
| §1 Layout | master + detail (master-detail) | ✅ master + detail grid | 매칭 |
| §2 Button CRUD 6대 | Find/Insert/Delete/Edit/Save | hotkeyConfig 확인 필요 | 검증 의무 |
| §3 SP 3개 | GET_MASTER / GET_DETAIL / AFTER | sheetName master/detail + API 메타 확인 | 검증 의무 |
| §4 Validation | MSG00004/2/60 | useMessageStore 매핑 확인 | 검증 의무 |
| §5 cascade | (없음) | (없음) | 매칭 |
| §6 권한 | MSG 권한 분기 (Admin) | 메뉴 권한 SCM_ADM_USER_GR_MNU_BTN_MPG_M | 검증 의무 |

→ **TO-BE 코드 정밀 read 후 §2~§4 cross-check 의무** — Phase 7 cross-check 패턴 (DMF0008 동등).

## §6 cross-check 작업 (별도 진행)

1. `Lookup.tsx` Read → §2 hotkeyConfig + §3 useTabProcQuery 매핑 확인
2. `useLookupStore.ts` Read → §1 GET (검색조건 복원) 적용 여부
3. `LookupMasterGrid.tsx` / `LookupDetailGrid.tsx` Read → cascade / EditTracker / column meta 검증
4. SCM_ADM_API_M / PROC_M 메타 SQL 검증
5. `__asis-mapping__.md` 작성 (4 sheet validation + expression + cascade + button)

→ DMF0007 / DMF0008 cross-check 와 동일 절차. 본 4 화면 작업 우선순위 결정 후 진행.

## §7 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | SCM0003 분석 + TO-BE 기존 작성 인벤토리 + cross-check 절차 사양 |
