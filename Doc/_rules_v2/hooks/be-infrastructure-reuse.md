---
trigger: 신규 BE endpoint / Service / Controller / DTO / SP 작성 의도가 있을 때
mode: pre-write 의무 (anti-simplification 룰 동급 강제)
related: hooks/oracle-db-workflow.md, hooks/ui-dynamic-property-management.md
created: 2026-06-16
reason: 사용자 명시 (2026-06-16) — "backend 는 기본적으로 틀을 제공하는 방식으로 작성되어 있을 가능성이 높으니, 신규로 생성하기 보다는 필요한 기능을 찾아서 사용할 수 있도록 개발 시 적용"
---

# Hook — BE 인프라 재사용 의무 (신규 작성 전 검색 우선)

> ⭐ **핵심 룰** — NSCM BE 는 **표준 동적 인프라** (메타 기반 SP 호출 + 표준 endpoint family) 가 이미 작성되어 있다.
> 화면별 신규 BE Controller / Service / DTO / Endpoint / SP **작성 전** 기존 인프라 활용 가능 여부를 **의무적으로 검색**.
> 위반 시 — 중복 코드 / 인프라 분리 / 유지보수 부담 / "한 사람이 개발한 것처럼" 원칙 위반.

## 1. NSCM BE 표준 인프라 인벤토리

### 1.1 동적 SP 호출 — 모든 화면 공용 ⭐

| 용도 | FE 호출 | BE 라우팅 | 메타 |
|---|---|---|---|
| **SELECT** (조회) | `useTabProcQuery({menuId, sheetName, filters})` | `POST {menuId}/{sheetName}/SEARCH/call-proc` | `SCM_ADM_API_M` API_ID='{MENU}_{SHEET}_SEARCH' → API_URL=SP명 |
| **SAVE** (저장) | `useProcMutation({menuId, sheetName, procedureAction})` + `mutate(rows)` | `POST {menuId}/{sheetName}/{action}/call-proc` | API_ID='{MENU}_{SHEET}_{ACTION}' |
| **SAVE 직접** (callback chain) | `apiClient.callMutationProc(menuId, sheet, action, rows)` | 동일 | 동일 |
| **lookup combo** | `useTabComboQueries({filters: [comboIds]})` | `POST /admin/combo-muti` | `SCM_ADM_CMBO_SQL_M` |

→ **신규 endpoint 작성 X**. SCM_ADM_API_M + SCM_ADM_PROC_M INSERT + SP 작성 (또는 기존 SP 재사용) 만으로 완성.

### 1.2 표준 endpoint family (admin/menu/*)

| Endpoint | 용도 |
|---|---|
| `GET  /admin/menu` | 사용자 메뉴 tree |
| `GET  /admin/menu/{mnuId}/access` | 메뉴 접근 권한 |
| `GET  /admin/menu/{mnuId}/auth` | 버튼/단위 권한 (useTabBtnPermissions 사용) |
| `POST /admin/menu/{mnuId}/column` | Grid Column 메타 (staticColumns) |
| `POST /admin/menu/{mnuId}/measure` | Grid Measure 메타 (staticMeasures) |
| `POST /admin/menu/favorite` | 즐겨찾기 |
| `GET/POST /admin/menu/{mnuId}/search-conditions` | 검색조건 저장/조회 |

→ 새 메타/속성 fetch 필요 시 **이 family 확장** (또는 기존 endpoint 재호출). 별도 controller 분리 금지.

### 1.3 표준 SP family (기존 재사용)

| SP | 용도 | 비고 |
|---|---|---|
| `PKG_DMF0002.P_DMF0002_GET_TITLESET_POPUP` | 사용자별 column/measure setting 조회 | `DMF0002_GET_TITLESET_POPUP` |
| `PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP` | 사용자별 column/measure 권한 UPSERT (1 row) | TITLESET_USER SAVE 표준 |
| `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` | Grid Column 메타 조회 | menu controller column endpoint |
| `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_MEASURE_LIST` | Grid Measure 메타 조회 | menu controller measure endpoint |

→ 신규 SP 작성 전 **기존 SP 인벤토리 검색 의무** (특히 user permission / title set / personalize).

## 2. PRE-WRITE 검색 의무 (모든 BE 신규 작업 시작 전)

### 2.1 BE Controller / Service 신규 작성 검토

```bash
# Step 1) 의도하는 endpoint URL 또는 기능 키워드로 기존 endpoint 검색
grep -rn "@PostMapping\|@GetMapping" nscm-be/src/main/java/com/lgcns/nscm/admin/

# Step 2) 비슷한 기능 service / mapper 검색
grep -rn "<해당 기능 키워드>" nscm-be/src/main/java/

# Step 3) DB 메타 (SCM_ADM_API_M) 의 endpoint 인벤토리 확인
SELECT API_ID, API_URL FROM SCM_ADM_API_M
 WHERE API_ID LIKE '<MENU>_%' OR API_URL LIKE '%<기능 키워드>%';
```

→ **하나라도 히트하면 신규 작성 금지**. 기존 인프라 활용.

### 2.2 SP 신규 작성 검토

```sql
-- Step 1) 비슷한 SP 검색 (PR_GET_/PR_SAVE_/SET_/GET_)
SELECT OBJECT_NAME, PROCEDURE_NAME FROM ALL_PROCEDURES
 WHERE OWNER='SCM_MGR'
   AND (UPPER(PROCEDURE_NAME) LIKE '%<기능 키워드>%'
     OR UPPER(OBJECT_NAME)    LIKE '%<도메인>%');

-- Step 2) SP signature (IN/OUT param) 확인 — 기존 SP 재사용 가능 여부 판단
SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE
  FROM ALL_ARGUMENTS
 WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='<PKG>' AND OBJECT_NAME='<SP>'
   AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION;
```

→ 기존 SP signature 가 의도 기능 충족 시 **그대로 활용 + SCM_ADM_PROC_M 메타 매핑만 추가**.

### 2.3 사용 가능한 표준 메타 endpoint 재호출 검토

화면 측 데이터 fetch 의도 시 — 표준 endpoint family (§1.2) 의 재호출로 해결 가능한지 우선 검토:

- column 메타 추가 fetch → `POST /admin/menu/{mnuId}/column` 의 sheet 별 재호출 (sheet 신규 INSERT)
- measure 메타 추가 fetch → `POST /admin/menu/{mnuId}/measure` 동일
- 권한 추가 → `GET /admin/menu/{mnuId}/auth` (mnuBtnAuth 자동 fetch)
- 검색조건 저장 → `POST /admin/menu/{mnuId}/search-conditions` 기존 활용

## 3. 표준 신규 추가 절차 (인프라 재사용 시)

> **신규 BE Java code 0 line** 으로 새 기능 완성.

| Step | 작업 |
|---|---|
| 1 | **SP 작성 또는 기존 SP 선택** — `PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP` 같은 기존 활용 우선 |
| 2 | **SCM_ADM_API_M INSERT** — `API_ID='{MENU}_{SHEET}_{ACTION}'`, `API_URL='<PKG.SP 또는 SP명>'` 멱등 |
| 3 | **SCM_ADM_PROC_M INSERT** — SP 의 IN param 별 `COL_NM` 매핑 (camelCase + BE 자동 채움 keys: `mnuId`/`sesUserId`/`sesLangCd`) 멱등 |
| 4 | **FE 호출** — `useProcMutation({menuId, sheetName, procedureAction})` 또는 `apiClient.callMutationProc(menuId, sheet, action, rows)` |
| 5 | **invalidateQueries** — `queryClient.invalidateQueries({queryKey: [tabId]})` |

### 예시 — DMF0003 사용자별 measure 권한 UPSERT (2026-06-16 실제 작업)

```sql
-- 신규 작성 0 BE code. 메타 INSERT 만으로 완성.

-- Step 1) SCM_ADM_API_M
INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_URL, USE_YN, ...)
VALUES ('DMF0003_titleSet_SAVE', 'SAVE', 'PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP', 'Y', ...);

-- Step 2) SCM_ADM_PROC_M — 9 row (P_SCM0002_SET_TITLESET_POPUP IN params)
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SCM0002_SET_TITLESET_POPUP', 'mnuId',       'VARCHAR2', 'IN', 1, ...);
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SCM0002_SET_TITLESET_POPUP', 'sheetName',   'VARCHAR2', 'IN', 2, ...);
-- ... (columnType / activeFlag / columnName / sortOrderNo / subTotalFlag / sortMethodCode / sesUserId)
INSERT INTO SCM_ADM_PROC_M VALUES ('P_SCM0002_SET_TITLESET_POPUP', 'O_RESULT_CURSOR', 'CURSOR', 'OUT', 10, ...);
```

```tsx
// FE 호출 — useProcMutation 또는 apiClient.callMutationProc
await apiClient.callMutationProc(MENU_ID, 'titleSet' as never, BUTTON_TYPE.SAVE, rows as never);
void queryClient.invalidateQueries({ queryKey: [tabId] });
```

## 4. 안티 패턴 (위반 사례)

| 패턴 | 위반 | 올바른 방법 |
|---|---|---|
| 화면별 신규 `@PostMapping("/admin/menu/{mnuId}/user-measures")` 작성 | BE Java 신규 controller / service / DTO 작성 | 기존 `useProcMutation` + 메타 INSERT |
| MyBatis xml 에 화면 전용 select id 신규 | 동적 SP 호출 인프라 무시 | SCM_ADM_API_M/PROC_M 메타로 등록 후 표준 호출 |
| FE 에서 `apiClient.post('/api/custom-endpoint', ...)` 직접 작성 | endpoint family 분산 | `apiClient.callMutationProc` 표준 path |
| SP 신규 작성 (이미 있는데) | 인벤토리 검색 안 함 | `ALL_PROCEDURES` grep 후 재사용 |

## 5. POST-WRITE 검증

작업 완료 직전 자기 점검:

```
✅ BE Java (Controller/Service/DTO) 신규 0 file?
✅ MyBatis xml 화면 전용 select 신규 0?
✅ SCM_ADM_API_M / SCM_ADM_PROC_M 메타 등록만으로 완성?
✅ FE 측 표준 path (useProcMutation / useTabProcQuery / apiClient.callMutationProc) 사용?
✅ 기존 SP 재사용 여부 인벤토리 grep 결과 첨부 (작업 보고 시)?
```

## 6. 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-16 | 신설 — DMF0003 사용자 measure 권한 UPSERT 사고에서 발견. 사용자 명시 "BE 는 틀 제공 + 신규 생성 회피" 룰화 |
