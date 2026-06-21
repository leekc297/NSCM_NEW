# Hook — SHEET_COLUMNS 메타 완전성 + 미사용 데이터 정리 의무 (2026-06-20)

> 사용자 명시 (2026-06-20, DMF0072 fix 중) — **rule 로 추가**.
> 위반 시: (1) UI Category Setup admin 변경이 화면에 반영 안 됨 / (2) 동일 PROGRAM_ID 내 obsolete sheet 누적 → admin UI 혼란.

---

## §0. 배경 — DMF0072 사례 (2026-06-20)

DMF0072 NN Master Mapping 화면:
- FE: `useNnMasterMappingStore.fetchStaticColumns` 가 `POST /admin/menu/DMF0072/column { sheetNm: 'main' }` 호출.
- BE: `PR_GET_SHEET_COLUMN_LIST` SP 가 `SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0072' AND SHEET_NAME='main'` 조회.
- 사내 DB: **0 row** (미등록 상태).
- FE: 빈 응답 → fallback (FE 하드코딩 23 컬럼, `visible:true`) 사용 → admin UI Category Setup 변경 **무력화**.

또한 사후 점검 결과:
- `SHEET_NAME='NNMasterMapping'` (구 PascalCase 명) 23 row 존재 → admin UI 에 DMF0072 의 sheet 2개로 표시 → 사용자 혼란.

이런 사고가 반복되어 사용자가 "rule 로 추가" 요구.

---

## §1. 원칙 2건

### 원칙 1 — UI Category Setup 데이터를 **실제 사용 데이터** 로 채우기
- 화면이 사용하는 모든 컬럼 (FE 하드코딩 MAIN_COLUMNS 또는 staticColumns 가 표현하는 column 인벤토리) 은 `SCM_MST_SHEET_COLUMNS` 에 등록 의무.
- 등록 후 FE 하드코딩 제거 (룰 #65 ui-category-setup-column-meta — admin 변경 즉시 반영 보장).

### 원칙 2 — **사용하지 않는 데이터** 삭제
- 동일 PROGRAM_ID 안 obsolete sheet (구 명명규약 / 테스트 잔존 / 폐기 sheet) 삭제 의무.
- DELETE 후 `SHEET_NAME` 별 인벤토리에 FE SHEETS enum 만 남는지 검증.

> ⭐ **확장 적용** (SYS0011 사례 — 2026-06-20): 원칙 2 는 SHEET_COLUMNS 뿐 아니라 화면 관련 메타 전반 (`SCM_ADM_MNU_BTN_MPG_M` / `SCM_ADM_API_M` / `SCM_ADM_PROC_M` / `SCM_ADM_MSG_M` / `SCM_ADM_USER_GR_MNU_BTN_MPG_M`) 의 dead row 에 적용. 단 cleanup scope 는 `MNU_ID` 또는 명확한 `API_ID prefix` 단위로 좁혀야 함 (corp-wide pattern DELETE = 다른 화면 영향 위험 — 별도 audit PR 필요).

---

## §2. PRE-WRITE 점검 (화면 작성 시)

| # | 점검 항목 | 확인 방법 |
|---:|---|---|
| 1 | FE 의 SHEETS enum 값 인벤토리 | `rg "^export enum SHEETS" -A 10 features/{domain}/src/pages/{screen}/{screen}.constants.ts` |
| 2 | 각 sheet 가 grid 인 경우 column 인벤토리 | FE `MAIN_COLUMNS` 또는 reference DMF0004 SalesSiteGrid 의 column 사용처 |
| 3 | SHEET_COLUMNS INSERT SQL 작성 (해당 column 1:1 매핑) | `_artifacts/_deploy_packages/{MNU_ID}/03_META/0XX_dynamic_property_management.sql` BLOCK 3 |
| 4 | **NOT NULL 컬럼 전수 cross-check** (#anti-simplification §1.4) | `python ora.py desc SCM_MST_SHEET_COLUMNS` → NULLABLE='N' 컬럼 모두 INSERT 명시 |
| 5 | sheet 명명 규약 (camelCase) — `main` / `dataType` / `endCustomer` 등 | FE SHEETS 와 SQL SHEET_NAME 100% 일치 |

### §2.1 표준 INSERT 형식 (DMF0072 080 reference)
```sql
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (
  PROGRAM_ID, SHEET_NAME, COLUMN_NAME,
  COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
  VISIBLE_FLAG, FIXED_FLAG, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, DEFAULT_FLAG, VALID_YN,  -- NOT NULL 12종
  INPUT_TP_CD, CELL_CONTROL_OBJECT_TYPE_CODE, HORIZONTAL_ALIGN_CODE,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT '{MNU_ID}', '{sheetNm}', NEW.COL,
       NEW.LBL, NEW.SORT_ORD, NEW.WIDTH,
       'Y', 'N', 'N', 'Y', 'Y', 'Y',  -- VALID_YN='Y' 필수 (DMF0072 080 첫 실행 ORA-01400 사고)
       NEW.INPUT_TP, NEW.CTRL_TP, 'L',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT '{COL_NAME}' AS COL, '{COL_LABEL}' AS LBL, {SORT_ORD} AS SORT_ORD, {WIDTH} AS WIDTH,
           '{INPUT_TP}' AS INPUT_TP, '{CTRL_TP}' AS CTRL_TP FROM DUAL UNION ALL
    ...
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
    WHERE X.PROGRAM_ID = '{MNU_ID}' AND X.SHEET_NAME = '{sheetNm}' AND X.COLUMN_NAME = NEW.COL
 );
```

---

## §3. POST-WRITE 검증 (사내 적용 후)

### §3.1 DB 인벤토리
```sql
-- sheet 별 컬럼 수 — FE SHEETS enum 과 1:1 매칭 확인
SELECT SHEET_NAME, COUNT(*) AS COL_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='{MNU_ID}'
 GROUP BY SHEET_NAME ORDER BY SHEET_NAME;
-- 기대: FE SHEETS enum 값과 동일 / 다른 sheet (구 PascalCase / 폐기) 0 row
```

### §3.2 BE 응답 확인
```bash
# FE 화면 진입 시 DevTools Network 확인
# POST /admin/menu/{MNU_ID}/column { sheetNm:'main' } → result: [{...},{...},...]
# 기대: 모든 FE 사용 column 포함 + visible/display 가 admin 설정 반영
```

### §3.3 admin UI Category Setup 동작 확인
1. admin → UI Category Setup → 화면 선택
2. Sheet 목록에 **FE SHEETS enum 값만** 표시 (구 명 0건)
3. 한 column 의 VISIBLE_FLAG='N' 저장 → 화면 새로고침 → 해당 column 숨김 확인

---

## §4. 미사용 데이터 cleanup 절차 (사용자 요구 2026-06-20)

### §4.1 점검 query (사내 DB)
```sql
-- 1. PROGRAM_ID 별 sheet 인벤토리
SELECT SHEET_NAME, COUNT(*) AS COL_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='{MNU_ID}'
 GROUP BY SHEET_NAME ORDER BY SHEET_NAME;

-- 2. FE SHEETS enum 과 비교 — enum 에 없는 SHEET_NAME 가 obsolete
-- 3. TITLESET_USER personalization (column 명 변경 시 orphan 가능)
SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID='{MNU_ID}' GROUP BY SHEET_NAME;

-- 4. SHEET_MEASURE (PIVOT 화면만)
SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID='{MNU_ID}' GROUP BY SHEET_NAME;
```

### §4.2 cleanup SQL 작성 + 적용
- 신규 파일: `_artifacts/_deploy_packages/{MNU_ID}/03_META/0XX_{MNU_ID}_obsolete_sheet_columns_cleanup.sql`
- PRE-DELETE / DELETE / POST-DELETE 3 블록 + 상세 코멘트 (왜 삭제 가능한지 안전성 명시)
- 멱등성: DELETE 자체 멱등 (0 row 삭제 무영향)
- python wrapper (`_artifacts/_apply_corporate/XX_{mnu_id}_obsolete_cleanup.py`) 작성 — PRE/POST AUDIT + delta 보고

### §4.3 cleanup 시 안전성 체크리스트
| # | 점검 | 안전 조건 |
|---:|---|---|
| 1 | obsolete sheet 명이 FE SHEETS enum 에 없음 | `rg "SHEETS\." {Screen}.tsx` 결과에 obsolete sheet 명 0 hit |
| 2 | BE PR_GET_SHEET_COLUMN_LIST 가 obsolete sheet 명으로 호출될 일 없음 | FE fetchStaticColumns 가 enum 값만 사용 |
| 3 | obsolete sheet 의 column_name 가 신규 sheet 와 의미 동일 | DMF0072: NNMasterMapping (구) vs main (신) — column_name 23개 100% 동일 |
| 4 | TITLESET_USER 의 obsolete sheet 참조 row 함께 cleanup (orphan 방지) | `DELETE FROM TITLESET_USER WHERE PROGRAM_ID + SHEET_NAME = obsolete` |

---

## §5. 적용 표

| 화면 | SHEET_COLUMNS 등록 | FE 하드코딩 제거 | obsolete sheet cleanup | 상태 |
|---|:---:|:---:|:---:|---|
| DMF0004 (sales-site) | ✓ | ✓ | ? | 정상 (BE 메타 적용 + FE store 사용) |
| DMF0008 (erp-edi-master) | ✓ | ✓ | ? | 정상 |
| DMF0072 (nn-master-mapping) | ✓ (2026-06-20 080) | ✓ (2026-06-20 MAIN_COLUMNS 211 line 제거) | ✓ (2026-06-20 085 — NNMasterMapping 23 row 삭제) | 2026-06-20 fix 완료 |
| SYS0011 (auth-request) | ✓ (4 sheet 21 row, 2026-06-04 SCM0008→SYS0011 rename 적용 / 2026-06-06 dedupe 42→21) | ✓ (DataGrid wrapper `staticColumns` BE store fetch) | ✓ obsolete sheet 0 (camelCase 4 sheet 모두 FE SHEETS 1:1) | 2026-06-20 audit 정합 ✓ — 본 hook 의 원칙 확장 적용: BTN_MPG_M 의 legacy `API_SCM0008_*` 참조 7 row 도 미사용 cleanup 대상 (`19_sys0011_dead_meta_cleanup.py`, SYS0011 scope) |
| 기타 master 도메인 | ? | ? | ? | **일괄 점검 대상** |

---

## §6. RULESET_MASTER §3 UI-MANDATORY 통합

PRE-WRITE:
- ✅ SHEET_COLUMNS INSERT SQL — 모든 NOT NULL 컬럼 (12종) 명시 + VALID_YN='Y' 포함
- ✅ FE staticColumns 출처 = store (BE 메타) — 하드코딩 MAIN_COLUMNS 작성 금지

POST-WRITE:
- 사내 DB 적용 후 SHEET_NAME 별 인벤토리 cross-check — FE SHEETS enum 과 1:1
- obsolete sheet 발견 시 cleanup SQL 작성 + 적용

POST-DEPLOY:
- admin UI Category Setup 진입 → sheet 목록에 FE enum 값만 표시
- column visible='N' 변경 → 화면 새로고침 → 즉시 숨김 확인

### §6.1 자동 점검 grep
```bash
# FE 하드코딩 MAIN_COLUMNS 검출 (잔존 시 위반)
rg -n "export const MAIN_COLUMNS" features/{domain}/src/pages/{screen}
# 기대: 0 hit (BE 메타로 이관 완료)

# FE staticColumns 출처 확인 — store 만 사용 (constants 직접 import 금지)
rg -n "MAIN_COLUMNS" features/{domain}/src/pages/{screen}
# 기대: 0 hit (constants 자체에서 정의도 X)

# SQL INSERT 의 NOT NULL 컬럼 누락 검출
rg -n "INSERT INTO SCM_MGR\.SCM_MST_SHEET_COLUMNS" _artifacts/_deploy_packages/{MNU_ID}
# → 결과 SQL 의 column list 에 VALID_YN / FIXED_FLAG / VISIBLE_FLAG / DEFAULT_FLAG / USER_SELECTABLE_FLAG / UPPERCASE_APPLY_FLAG / HORIZONTAL_ALIGN_CODE / COLUMN_WIDTH / SORT_ORDER_NO / COLUMN_LABEL_NAME / COLUMN_NAME / SHEET_NAME / PROGRAM_ID 모두 포함 의무
```

---

## §7. 짝 hook

- `Doc/_rules_v2/hooks/ui-category-setup-column-meta.md` (#65 — admin 메타 동적 fetch 의무 — 본 hook 의 base 룰)
- `Doc/_rules_v2/hooks/grid-column-meta-mandatory.md` (#19 — Grid Column 메타 표준 14 enum)
- `Doc/_rules_v2/hooks/feature-button-meta-completeness.md` (짝 hook — BTN_MPG_M 완전성)
- `Doc/_rules_v2/anti-simplification.md` §1.4 (DDL NOT NULL 정책 cross-check 의무 — 080 첫 실행 ORA-01400 사고)
