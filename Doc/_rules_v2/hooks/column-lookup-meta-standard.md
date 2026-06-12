# Hook — 컬럼 lookup 메타 표준 + INPUT_TP_CD 표준 (누락 방지)

> ⚠ **신규/수정 화면 작업 시 필수 적용**
> Grid cell 의 lookup dropdown 적용 시 메타 위치 + INPUT_TP_CD 표준값 둘 다 정확해야 동작.
> 잘못된 위치 (ATTRIBUTE1 에 SQL_ID) / 잘못된 값 (INPUT_TP_CD='MI') 시 dropdown / cell editor 영원히 미동작.

작성: 2026-06-12 (SYS0014 dropdown 사고 + INPUT_TP_CD 'MI' typo 사고 후)
관련 룰: `_tobe/08_column_meta.md`, `_tobe/12_metadata_sql.md`
상위 hook: `ui-dynamic-property-management.md`, `ui-category-setup-column-meta.md`
관련 메모리:
- `feedback_column_lookup_meta_standard.md`
- `feedback_input_tp_cd_im_standard.md`
- `feedback_be_auto_resolve_combo_data_map.md` (DEPRECATED — 잘못된 진단)

---

## §0. 트리거 (작업 키워드 자동 적용)

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 작성 (T01) | PRE-WRITE + POST-WRITE |
| 신규 grid cell 메타 등록 (T04) | PRE-WRITE + POST-WRITE |
| dropdown / lookup / combo 추가 | PRE-WRITE |
| cell 클릭/F2 무반응 사고 | 진단 단계 |

⚠ 이 hook 은 `ui-category-setup-column-meta.md` 의 **세부 표준**. 메타 등록 시 둘 다 필수.

---

## §1. 컬럼 lookup 메타 — 표준 위치 (CELL_COMBO_DATA_TYPE)

### 1.1 표준 — `CELL_COMBO_DATA_TYPE` (FE `cellCboDataTp`)

```sql
UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = '{SQL_ID in SCM_ADM_CMBO_SQL_M}'
 WHERE PROGRAM_ID = '{MENU_ID}' AND SHEET_NAME = '{sheet}' AND COLUMN_NAME = '{col}';
```

### 1.2 ❌ 금지 — ATTRIBUTE1 위치 등록

```sql
-- ❌ 잘못된 위치 — DataGrid wrapper 가 인식 안 함
UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       ATTRIBUTE1                    = 'Division'  -- ← 절대 금지
 WHERE PROGRAM_ID = 'SYS0014' AND SHEET_NAME = 'division' AND COLUMN_NAME = 'UNIT_ID';
```

**ATTRIBUTE1 의 올바른 용도**:
- 기존 화면들: sheet 그룹 이름 (예: 'MsgMgmt', 'UserMgmt')
- popup cell: `_modalKey` (cellCtrlObjTpCd='FPModal' 인 경우만)
- lookup SQL_ID 절대 X

### 1.3 FE 동작 흐름 (인프라 — 변경 불필요)

```
Store fetchStaticColumns
  → BE /admin/menu/{MENU_ID}/column
  → SHEET_COLUMNS row 응답 (cellCboDataTp 포함)
  → DataGrid.tsx:85-95 가 cellCboDataTp 추출 → useTabComboQueries 자동 fetch
  → DataGrid.tsx:101-107 column.dataMap 에 fetch 결과 주입
  → wijmo cell editor 시작 시 dropdown 표시
```

⚠ **FE 코드 변경 절대 불필요**. `useTabComboQueries` 별도 호출 작성 금지 — DataGrid wrapper 가 자동 처리.

### 1.4 SQL_ID 인벤토리 (SCM_ADM_CMBO_SQL_M 등록 52종)

표준 인벤토리는 메모리 `reference_combo_sql_id_inventory.md` 참조. 주요:

| 도메인 | SQL_ID |
|---|---|
| Division | `Division` / `MyDivision` / `TeambyDivision` |
| Plant | `SalesPlant` / `PlantByDivisionCompany` / `CompanySalesSite` / `SalesSite` |
| Customer | `EndCustomer` / `EndCustomerByDivisionDept` / `SoldCustomer` / `SiteByEndCustomer` / `CustomerPSI` |
| 공통 | `YesOrNo` / `MessageType` / `Language` / `TimeZone` |

미등록 SQL_ID 사용 시 BE 응답 BusinessException "Query is not exist" — 신규 등록 필요 (메모리 `feedback_combo_migration_asis_to_tobe`).

---

## §2. INPUT_TP_CD 표준 5종 — 'MI' 절대 금지

### 2.1 표준 5종 (FE enum 정확 일치 의무)

`nscm-fe/packages/foundation/src/constants/column-config.ts:1-7`:
```ts
export enum CELL_INPUT_EDIT_TYPE {
  SEARCH_ONLY = 'S',
  OPTIONAL = 'O',
  MANDATORY = 'M',
  OPTIONAL_INSERT_ONLY = 'IO',
  MANDATORY_INSERT_ONLY = 'IM',   // ⭐ I 다음 M — 'MI' 아님!
}
```

| 코드 | 동작 |
|---|---|
| `S` | read-only |
| `O` | edit 가능 (모든 row) |
| `M` | edit 가능 + 필수 표시 |
| `IO` | INSERT row (`CRUD_TYPE='I'`) 만 edit 가능 |
| `IM` | INSERT row 만 edit 가능 + 필수 표시 |

### 2.2 ❌ 'MI' 사용 시 사고

`dataGridUtils.ts:138-143 isEditableCell`:
```ts
const isEditableCell =
  (cellCrudType === 'I' &&
    (cellInputEditType === 'IM' || cellInputEditType === 'IO')) ||  // 'MI' 미정의
  cellInputEditType === 'M' ||
  cellInputEditType === 'O';
```

→ `'MI'` 입력 시 4 분기 모두 false → 항상 false → `beginningEdit` cancel → cell click + F2 / Enter / typing 모두 무반응 → **dropdown 영원히 안 나옴**.

### 2.3 사고 사례 (SYS0014, 2026-06-12)

- 5 row 모두 INPUT_TP_CD='MI' (typo): division/UNIT_ID, plant/UNIT_ID, customer/UNIT_ID, main/USER_GR_ID, userInfo/USER_ID
- dropdown / cell input 모두 미동작
- 전 시스템 audit: 141 화면 정상 'IM', SYS0014 만 'MI' 사용 → 작성 시 typo

---

## §3. PRE-WRITE 자기 점검 (모두 ✓ 필수)

### 3.1 신규 메타 등록 시
- [ ] dropdown 컬럼 → `CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'` (S 아님)
- [ ] dropdown 컬럼 → `CELL_COMBO_DATA_TYPE = '{SQL_ID}'` (**ATTRIBUTE1 아님**)
- [ ] `SCM_ADM_CMBO_SQL_M` 에 해당 SQL_ID 존재 확인
- [ ] INPUT_TP_CD = 5종 표준 중 선택 (`S`/`O`/`M`/`IO`/`IM`) — **`'MI'` 절대 금지**
- [ ] popup 컬럼 (`FPModal`) 만 ATTRIBUTE1 = modalKey 사용

### 3.2 SQL_ID 미등록 시
- [ ] AS-IS → To-Be 마이그레이션 5단계 (메모리 `feedback_combo_migration_asis_to_tobe`)
- [ ] SCM_ADM_CMBO_SQL_M 에 NOT EXISTS INSERT
- [ ] 결과 컬럼 = `CODE` + `NAME` 의무

---

## §4. POST-WRITE 자동 검증 (grep + SQL)

### 4.1 신규 등록 화면 검증
```sql
-- (a) FPComboBox + CELL_COMBO_DATA_TYPE 정합
SELECT SHEET_NAME, COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, ATTRIBUTE1, INPUT_TP_CD
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '{NEW_MENU_ID}'
   AND CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox';
-- 기대: CELL_COMBO_DATA_TYPE 모두 NOT NULL, ATTRIBUTE1 NULL (lookup 용도 아닌 경우)

-- (b) SQL_ID 존재 검증
SELECT DISTINCT c.CELL_COMBO_DATA_TYPE
  FROM SCM_MST_SHEET_COLUMNS c
  LEFT JOIN SCM_ADM_CMBO_SQL_M s ON s.SQL_ID = c.CELL_COMBO_DATA_TYPE
 WHERE c.PROGRAM_ID = '{NEW_MENU_ID}'
   AND c.CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'
   AND s.SQL_ID IS NULL;
-- 기대: 0 rows (모든 SQL_ID 등록되어 있어야 함)

-- (c) INPUT_TP_CD 표준 5종 외 검출
SELECT SHEET_NAME, COLUMN_NAME, INPUT_TP_CD
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '{NEW_MENU_ID}'
   AND INPUT_TP_CD NOT IN ('S','O','M','IO','IM','SS')
   AND INPUT_TP_CD IS NOT NULL;
-- 기대: 0 rows
```

### 4.2 전 시스템 audit (정기 검증)
```sql
-- 'MI' typo audit
SELECT PROGRAM_ID, COUNT(*) CNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE INPUT_TP_CD = 'MI'
 GROUP BY PROGRAM_ID
 ORDER BY PROGRAM_ID;
-- 기대: 0 rows (이미 SYS0014 fix 완료)

-- ATTRIBUTE1 위치 lookup SQL_ID 잘못 등록 audit
SELECT c.PROGRAM_ID, c.SHEET_NAME, c.COLUMN_NAME, c.ATTRIBUTE1
  FROM SCM_MST_SHEET_COLUMNS c
  JOIN SCM_ADM_CMBO_SQL_M s ON s.SQL_ID = c.ATTRIBUTE1
 WHERE c.CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox';
-- 기대: 0 rows (ATTRIBUTE1 위치 lookup SQL_ID 사용 0건)
```

### 4.3 FE 자기 점검 grep
```bash
# 화면별 useTabComboQueries 직접 호출 검출 — DataGrid wrapper 가 자동 처리하므로 일반적으로 form 의 SearchArea 용도 만 허용
grep -rn "useTabComboQueries" features/*/src/pages/{NEW_SCREEN}/ | grep -v "Form\|Search"
# 기대: 0 매치 (Form / SearchArea 외 grid 용 직접 호출 X)
```

---

## §5. 진단 절차 (dropdown 안 나옴 / cell click 무반응)

순서대로 검증:

1. **메타 위치 검증** — `CELL_COMBO_DATA_TYPE` 에 SQL_ID 있나?
   ```sql
   SELECT * FROM SCM_MST_SHEET_COLUMNS
    WHERE PROGRAM_ID='...' AND SHEET_NAME='...' AND COLUMN_NAME='...';
   ```
   - ATTRIBUTE1 에 잘못 등록 시 → CELL_COMBO_DATA_TYPE 으로 이동

2. **SQL_ID 존재 검증** — CMBO_SQL_M 에 등록?
   ```sql
   SELECT * FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='...';
   ```
   - 미등록 시 → AS-IS → To-Be 마이그레이션 (메모리 `feedback_combo_migration_asis_to_tobe`)

3. **INPUT_TP_CD 검증** — 5종 표준?
   ```sql
   SELECT INPUT_TP_CD FROM SCM_MST_SHEET_COLUMNS WHERE ...;
   ```
   - 'MI' / 다른 값 → 'IM' 또는 표준 5종 중 정정

4. **FE 캐시 확인** — F12 → Application → Clear site data → 재로그인
   - staticColumns refetch 동작 확인

5. **wijmo cell editor 시작 방법** — single click + F2 / Enter / typing
   - dblClick 표준 X (DataGrid wrapper 미설정)

6. **BE 응답 검증** — Network 탭 `/admin/menu/{MENU_ID}/column` 응답 JSON
   - `cellCboDataTp: 'Division'` 등 포함 확인
   - 또는 직접 PROC 호출:
     ```python
     cur.callproc('SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST',
                  ['userId', 'MENU_ID', 'sheet', None, oc])
     ```

---

## §6. anti-pattern 사고 사례

### 6.1 (실제) ATTRIBUTE1 위치 SQL_ID 등록 (SYS0014, 2026-06-12)
- 잘못된 SQL: `UPDATE SET ATTRIBUTE1='Division' ...` → DataGrid wrapper 인식 안 함
- fix: `UPDATE SET CELL_COMBO_DATA_TYPE='Division' ...`
- 참조: `52_sys0014_unit_dropdown_cloud_apply.sql`

### 6.2 (실제) INPUT_TP_CD 'MI' typo (SYS0014, 2026-06-12)
- 메타 등록 시 `'MI'` 작성 → cell editor 영원히 미동작
- 전 시스템 audit 결과 SYS0014 만 사용 (141 화면 정상 'IM')
- fix: `51_sys0014_input_tp_cd_typo_fix.sql` + `52_*.sql` 통합

### 6.3 (잘못된 진단) BE 자동 resolve (deprecated)
- 표준 패턴 미인지 → BE `MenuServiceImpl.resolveComboBoxDataMaps` 추가
- DataGrid wrapper 가 `column.dataMap` 덮어쓰기 → 무력화
- 참조: 메모리 `feedback_be_auto_resolve_combo_data_map.md` (DEPRECATED)

### 6.4 (가능성) SQL_ID 미등록
- 신규 화면 SQL_ID 가 CMBO_SQL_M 에 없음 → BE BusinessException "Query is not exist"
- fix: AS-IS → To-Be 마이그레이션 5단계 + NOT EXISTS INSERT

---

## §7. Cross-ref

### 룰 v2
- `_tobe/08_column_meta.md` — column meta 표준
- `_tobe/12_metadata_sql.md` — 메타 SQL 7-BLOCK + lookup combo
- `_tobe/04_store.md §10` — fetchStaticColumns guard
- `_tobe/07_datagrid.md §11` — staticColumns 출처 표준

### Hook
- `ui-dynamic-property-management.md` — UI 생성의 동적 속성관리 (master)
- `ui-category-setup-column-meta.md` — UI Category Setup 동적 fetch
- `grid-column-meta.md` — column meta 동적 fetch
- `sheet-columns-binding-match.md` — COLUMN_NAME 정렬

### 메모리
- `feedback_column_lookup_meta_standard.md` (이 hook 짝)
- `feedback_input_tp_cd_im_standard.md`
- `feedback_admin_meta_dynamic_fetch.md`
- `feedback_combo_migration_asis_to_tobe.md`
- `feedback_cmbo_sql_at_division_param.md`
- `reference_combo_sql_id_inventory.md`
- `feedback_be_auto_resolve_combo_data_map.md` (DEPRECATED)

---

## §8. 위반 시 대응

- 신규 화면 작성 시 §3 PRE-WRITE 체크리스트 위반 = PR 머지 차단
- POST-WRITE §4 audit SQL 결과 0 rows 아닐 시 즉시 fix
- 사용자 보고 "dropdown 안 나옴" / "cell click 무반응" → §5 진단 절차 의무
- anti-simplification 위반 (메타 위치 추측 / typo 무시) = 도구 사용 중단
