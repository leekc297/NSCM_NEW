# DMF0020 Sales Price — 클라우드 이관 패키지 v3 full

생성일: 2026-06-12
작성자: minyonglee1
범위: DMF0020 (Sales Price) 메인 화면 + 5 popup + 동적 속성관리 + i18n 변경분

---

## 1. 변경 요약

### 1.1 화면명 변경
- DB MNU_DESC: `Sales Future Price` → **`Sales Price`**
- FE MNU_DMF0020 (KO/EN): `Sales Future Price` / `향후 단가 관리` → **`Sales Price`** (KO=EN 통일)
- CN: 기존 `未来销售单价管理` 유지

### 1.2 SP body 수정 (사내 환경 적용된 상태)
- `DMF0020_GET_SCM_MST_FUTURE_PRICE` (main, 20 args):
  - V_PROD PIVOT alias 정정 (`'W_x'` → `'W_x' AS "W_x"`) — 동적 컬럼 표시 fix
  - 'ALL' filter 분기 (IF + WHERE OR ALL)
  - GT_FTPR_TMPOUTPUT MERGE ON 절 YYYYMMDD 추가 (ORA-30926 fix)
- `DMF0073_GET_VERSION_SALESPRICE` (version popup): GROUP BY 에 `tei.EDIT_YN` 추가 (ORA-00979 fix)
- `DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` (priceBatch): fn_string_split 'ALL' skip 7 패턴 적용 (부분 fix — 잔존 hang 시 priceBatchInput API_URL 을 메인 SP 로 우회 routing)

### 1.3 UI 동적 속성관리 룰 적용
- `SCM_MST_SHEET_COLUMNS` main 15 cols 정확 등록 (FE MAIN_COLUMNS 와 1:1)
- `SCM_MST_SHEET_MEASURE` Sales Price 4 measures (RTF/KRW/USD/LOC) 등록
- FE: store `staticColumns` / `staticMeasures` + `fetchStaticColumns` / `fetchStaticMeasures`
- FE Grid: 통합 `mergedColumns` useMemo + `visibleColumns` 필터 → admin VISIBLE_FLAG='N' 즉시 반영
- handleInsert: `MEASURE_4` → `staticMeasures` 동적

### 1.4 조회조건 popup 버튼 형식
- DMF0005 표준 `InputField + Button(FunctionSearchIcon)` flex 컨테이너 — 박스 + 우측 별도 조회 버튼
- ProjectField / ItemField / OwnerField / VersionField 4종 (catalog 표준)

### 1.5 Price 일괄입력 popup
- Edit 버튼 삭제, PRICE_ALL 항상 편집 가능 (background color = `wj-cell-editable`)
- API_URL routing: main SP 로 우회 (popup SP hang 임시 우회)

---

## 2. 폴더 구조

```
DMF0020_v3_full/
├─ 00_README.md                   (이 파일)
├─ 01_FE/                         (FE 소스 — nscm-fe/ root 에 cp)
│  ├─ sales-future-price/         → features/master/src/pages/
│  ├─ components/searchFields/    → features/master/src/components/
│  └─ locales/                    → public/locales/  (KO/EN/CN.json 전체)
├─ 03_META/                       (DB 메타 SQL — 적용 순서대로)
│  ├─ 01_MNU_i18n.sql             (SCM_ADM_MNU_M + SCM_ADM_MSG_M)
│  ├─ 02_SHEET_COLUMNS_main.sql   (SCM_MST_SHEET_COLUMNS main 15 cols)
│  ├─ 03_SHEET_MEASURE.sql        (SCM_MST_SHEET_MEASURE 4 measures)
│  ├─ 04_MNU_BTN_MPG.sql          (SCM_ADM_MNU_BTN_MPG_M 12 buttons)
│  ├─ 05_API_M.sql                (SCM_ADM_API_M 12 APIs)
│  ├─ 06_PROC_M.sql               (SCM_ADM_PROC_M 5 SP signatures)
│  ├─ 07_USER_GR_BTN.sql          (USER_GR_MNU_BTN_MPG_M 자매 그룹 복사)
│  └─ 08_CMBO_SQL_inventory.sql   (사내 등록 여부 확인용 — DML 아님)
├─ 04_PKG_SP/                     (SP body — VALID 상태로 compile)
│  ├─ DMF0020_GET_SCM_MST_FUTURE_PRICE.sql               (main 20 args)
│  ├─ DMF0073_GET_VERSION_SALESPRICE.sql                 (version popup)
│  └─ DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP.sql (priceBatch popup)
└─ 05_VERIFY/                     (검증 SQL — 적용 후 실행)
```

---

## 3. 적용 순서 (이관 담당자용)

### Step 1. FE 소스 복사
```bash
cd nscm-fe/
cp -r /path/01_FE/sales-future-price/         features/master/src/pages/
cp -r /path/01_FE/components/searchFields/    features/master/src/components/
cp /path/01_FE/locales/*.json                 public/locales/
pnpm type-check && pnpm build      # 사내 빌드 검증
```

### Step 2. DB SP body 컴파일 (04_PKG_SP/)
```sql
@04_PKG_SP/DMF0020_GET_SCM_MST_FUTURE_PRICE.sql
@04_PKG_SP/DMF0073_GET_VERSION_SALESPRICE.sql
@04_PKG_SP/DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP.sql
-- 각 SP STATUS=VALID 확인
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'DMF0020%' OR OBJECT_NAME='DMF0073_GET_VERSION_SALESPRICE';
```

### Step 3. DB 메타 SQL 순차 적용 (03_META/)
```sql
@03_META/01_MNU_i18n.sql              -- 메뉴 + i18n
@03_META/02_SHEET_COLUMNS_main.sql    -- ⭐ admin UI Category Setup 의 단일 진실 source
@03_META/03_SHEET_MEASURE.sql         -- Sales Price measure 4종
@03_META/04_MNU_BTN_MPG.sql           -- button 정의 12
@03_META/05_API_M.sql                 -- API routing 12
@03_META/06_PROC_M.sql                -- SP signature 매핑
@03_META/07_USER_GR_BTN.sql           -- 사용자 그룹 권한 복사
-- 08 은 확인용 SELECT — 사내 등록 안 된 combo 있으면 별도 작성 필요
@03_META/08_CMBO_SQL_inventory.sql
```

### Step 4. BE 재기동 (변경 메타 캐시 무효화)

### Step 5. 화면 검증
- 로그인 → 메뉴: Master → Demand Master → **Sales Price** 클릭
- 조회조건 form 의 Project/Model/Owner/Version 박스 + 우측 별도 조회 버튼 표시
- 메인 grid 의 PROJECT_STATUS 컬럼 hide (VISIBLE_FLAG='N')
- 조회 결과: 동적 컬럼 W_YYYYMMDD (월요일만) 표시
- Bucket 토글 → Month 시 M_YYYYMM SUM 표시
- Insert (F8) → measure 4 row 추가 (RTF/KRW/USD/LOC)
- Exchange Rate popup / Price 일괄입력 popup / Version popup 동작
- Price 일괄입력의 일괄입력 Price 컬럼 노란 배경 + 항상 편집 가능

---

## 4. 동적 속성관리 (UI Category Setup) 확인

### 4.1 admin 변경 → 즉시 반영 동작 검증
- SYS0004 UI Category Setup → DMF0020 main 의 임의 컬럼 → VISIBLE_FLAG='N' / COLUMN_WIDTH 변경 → SAVE
- DMF0020 화면 재진입 또는 Search → 변경 사항 즉시 반영

### 4.2 Measure 동적 검증
- SYS0004 Measure 탭 → DMF0020 Sales Price → measure VALID_YN 토글
- DMF0020 → Insert (F8) → valid measure 만 row 생성

---

## 5. 참조 룰
- master hook: `Doc/_rules_v2/hooks/ui-dynamic-property-management.md`
- column/measure: `Doc/_rules_v2/hooks/ui-category-setup-column-meta.md` (§8 measure + §9 신규 등록 의무 + §11 Wijmo 직접 사용 통합 column meta)
- button: `Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md`
- i18n: `Doc/_rules_v2/hooks/i18n-ko-en-alignment.md` (KO=EN 전체 통일)

---

## 6. 알려진 제약
- **priceBatch popup SP** (`DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP`) 는 fn_string_split + cartesian 결함 잔존 — main SP 로 routing 우회 중. SP body 전면 재작성 별도 세션 필요.
- BE `/admin/menu/{MENU_ID}/column` `/measure` endpoint 응답 형식 검증 필요 (RawFlexGridColumnConfig).

---

## 7. 롤백
- DB SP body: 적용 전 `DBMS_METADATA.GET_DDL('PROCEDURE', '{SP_NAME}')` 백업 후 작업
- 메타: 모든 SQL 은 MERGE / DELETE + INSERT 패턴 — 재실행 가능
- FE: git revert
