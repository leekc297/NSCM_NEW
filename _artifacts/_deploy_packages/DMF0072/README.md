# DMF0072 — NN Master Mapping 클라우드 이관 패키지

작성: 2026-06-02
대상 환경: NSCM 클라우드 (Oracle 19c + Spring Boot + React)

---

## 1. 개요

DMF0072 (N대N Master Mapping) 신규 화면 풀스택 + COM0008 (공용 Item Popup) 데이터 미조회 fix 통합 이관 패키지.

### 1.1 적용 범위

| 영역 | 변경 |
|---|---|
| FE | 신규 화면 `nn-master-mapping` (5 파일) + 공용 modal `ItemByDivisionModal` `headerTitle?` prop 추가 |
| DB 메타 | API_M / BTN_MPG / PROC_M / GUEST 권한 신규 등록 (DMF0072 main+5 lookup+2 popup sheet) + COM0008 sheet columns duplicate cleanup |
| SP / PKG | `DMF0072_GET_NNMASTER_MAPPING_WRAPPER` signature 확장 + lookup SP 4종 As-Is 1:1 변환 + Project/Item Popup standalone SP 2종 신규 |

---

## 2. 폴더 구조

```
DMF0072/
├── README.md                              ← 본 파일
├── 01_FE/
│   ├── nn-master-mapping/                 ← 신규 화면 (FE 파일 전체)
│   │   ├── index.ts
│   │   ├── NnMasterMapping.tsx
│   │   ├── NnMasterMapping.module.scss
│   │   ├── nn-master-mapping.constants.ts
│   │   ├── useNnMasterMappingStore.ts
│   │   └── components/
│   │       └── NnMasterMappingForm.tsx
│   └── shared-modal/
│       └── ItemByDivisionModal.tsx        ← 변경분 (headerTitle? prop 추가, 기존 화면 영향 0)
├── 02_DB_Meta_SQL/                        ← DB 메타 등록 SQL
│   ├── 44_DMF0072_meta.sql                ← 초기 메타 (MSG_M / API_M / BTN_MPG / PROC_M / GUEST 권한)
│   ├── 55_DMF0072_popup_meta.sql          ← Project/Item POPUP 메타 추가 (sheet=projectPopup, itemPopup)
│   ├── 55_DMF0072_popup_meta_DBeaver.sql  ← DBeaver 용 (SQL*Plus 명령 제거)
│   └── 56_COM0008_sheet_columns_dedupe.sql ← COM0008 sheet columns duplicate cleanup (34→17)
├── 03_SP_PKG/                             ← SP/PKG 변경 SQL
│   ├── 52_DMF0072_lookup_sp_fix.sql       ← WRAPPER signature 확장 + END_CUSTOMER/SALES_SITE multi-value split
│   ├── 52_DMF0072_lookup_sp_fix_DBeaver.sql
│   ├── 53_DMF0072_TEAM_LIST_sp_body.sql   ← Team SP body As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1
│   ├── 53_DMF0072_TEAM_LIST_sp_body_DBeaver.sql
│   ├── 54_DMF0072_popup_sp_create.sql     ← Project/Item POPUP SP 2종 (As-Is 1:1)
│   ├── 54a_Project_SP_only.sql            ← Project SP 단독 (분리 적용용)
│   └── 54b_Item_SP_only.sql               ← Item SP 단독 (분리 적용용)
└── 04_Verify/                             ← 적용 후 검증 SQL
    ├── 52_DMF0072_lookup_sp_fix_Verify.sql
    ├── 53_DMF0072_TEAM_LIST_sp_body_Verify.sql
    └── 55_DMF0072_popup_meta_Verify.sql
```

---

## 3. 적용 순서 (의무 순서 — 의존성 있음)

### Step 1. DB SP/PKG 변경 (03_SP_PKG/)

```
1) sqlplus SCM_MGR/{PW}@{DB} @52_DMF0072_lookup_sp_fix.sql
   → WRAPPER + END_CUSTOMER_LIST + SALES_SITE_LIST + PROC_M 메타 (2 row)
   → 사후 카운트: 10 args (WRAPPER) / sesUserId=1 / mnuId=1 / SP VALID=4 모두 PASS 확인

2) sqlplus SCM_MGR/{PW}@{DB} @53_DMF0072_TEAM_LIST_sp_body.sql
   → TEAM_LIST stub → As-Is 1:1 변환 (27 lines, ALL=48 / 81=26 / 40=0 row 확인)

3) sqlplus SCM_MGR/{PW}@{DB} @54_DMF0072_popup_sp_create.sql
   → Project POPUP + Item POPUP SP 2종 신규 (VALID=2 확인)
   ※ 본 파일이 오래 걸리면 (PowerShell Select-Object stream 이슈) 54a/54b 분리 실행 가능
```

### Step 2. DB 메타 등록 (02_DB_Meta_SQL/)

```
1) sqlplus SCM_MGR/{PW}@{DB} @44_DMF0072_meta.sql
   → 초기 메타 (main/SEARCH + main/SAVE) + GUEST 권한
2) sqlplus SCM_MGR/{PW}@{DB} @55_DMF0072_popup_meta.sql
   → Project/Item POPUP 메타 추가 (sheet=projectPopup, itemPopup)
   → 사후: API_M=2 / BTN_MPG=2 / PROC_M PROJECT=7 / ITEM=8 / GUEST=2 모두 PASS
3) sqlplus SCM_MGR/{PW}@{DB} @56_COM0008_sheet_columns_dedupe.sql
   → COM0008 itemByDivisionPopup column 정의 duplicate cleanup (34 → 17)
   → 이미 클라우드가 17 인 경우 0 rows deleted (멱등)
```

### Step 3. FE 파일 배포 (01_FE/)

```
1) nn-master-mapping/ → nscm-fe/features/master/src/pages/nn-master-mapping/
   (디렉토리 전체 통째 복사. 기존 폴더가 있다면 백업 후 교체)

2) shared-modal/ItemByDivisionModal.tsx → nscm-fe/features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx
   (덮어쓰기. headerTitle? prop 추가 — 다른 화면 영향 0, 기본값 = 기존 i18n key)
```

### Step 4. BE 재시작

PROC_M 메타가 추가되었으므로 BE WAS 재기동 권장 (캐시 무효화).
(현재 GeneralServiceImpl 은 PROC_M 캐싱 없음 → 재시작 없이도 동작하지만 안전 위해 권장)

### Step 5. 검증 (04_Verify/)

```
1) sqlplus SCM_MGR/{PW}@{DB} @52_DMF0072_lookup_sp_fix_Verify.sql  → V1~V5 모두 PASS
2) sqlplus SCM_MGR/{PW}@{DB} @53_DMF0072_TEAM_LIST_sp_body_Verify.sql → V1~V5 모두 PASS
3) sqlplus SCM_MGR/{PW}@{DB} @55_DMF0072_popup_meta_Verify.sql → V1~V6 모두 PASS
```

### Step 6. 브라우저 검증

1. NSCM 클라우드 URL 접속 → 로그인 (시크릿 창 권장)
2. 메뉴 DMF0072 (NN Master Mapping) 진입
3. 조회 조건 콤보 5종 동작 확인 (Data Type / Division / Team / End Customer / Sales Site)
4. Project 🔍 클릭 → Project Popup 표시 (Division/Team/EndCustomer/SalesSite 자동 사전 채움)
5. Model/Nickname 🔍 클릭 → **Model/Nickname Popup** 헤더로 표시 (데이터 표시 확인)
6. 조회 실행 → Grid 의 Data Type ~ MDM Code 컬럼 계층적 세로 머지 확인

---

## 4. 의존성

### 4.1 As-Is 자료 (사전 보존 확인)

| 자료 | 위치 (참고용) |
|---|---|
| As-Is `.cs` | `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Master.UIL/Master/DMF0072_NNMasterMapping/` |
| As-Is `SCM0001_GET_TEAM_BY_DIVISION` | `Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:19847` |
| As-Is `SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX` | `Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP6_DDL.sql:22747` |
| As-Is `DMF0002_GET_ITEM_BY_DIVISION_POPUPEx` | `Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP1_DDL.sql:20954` |

### 4.2 To-Be DB 함수/테이블 (사전 가용성 의무)

- 함수: `SCM_MGR.UF_FX_STRING_SPLIT`, `SCM_MGR.UF_FX_STRING_SPLITFORIN` (둘 다 VALID)
- 테이블: `SCM_MST_PROJECT` (7,671 rows) / `SCM_MST_SITE_ITEM` (109,078 rows) / `SCM_MST_ITEM_SN` (synonym → FP_MGR.SCM_ITEM_M, 623,382 rows) / `SCM_MST_SSO_DEPT_INFO` (20,442 rows) / `SCM_MST_SSO_USER_INFO` / `SCM_ADM_LOOKUP_MASTER_DETAIL`
- PKG: `PKG_DMF0072` (BODY VALID), `PKG_COM0000` (BODY VALID — Item/Project popup 호출용)

### 4.3 i18n (locales/{KO,EN,CN}.json)

본 패키지의 메타 SQL `BLOCK 1 MSG_M` 에 i18n key 모두 포함. 클라우드에서 `gen_i18n_msg_json.py` 또는 동등 도구 실행 후 locales JSON 재생성 후 deploy.

---

## 5. 영향 분석

### 5.1 신규 메타

| 테이블 | 신규 row |
|---|---|
| `SCM_ADM_MSG_M` (KO 기준) | ~4 row (NN Mapping 조회/저장 + Project/Item POPUP 조회) |
| `SCM_ADM_API_M` | ~4 row (P_DMF0072_GET / SAVE / PROJECT_POPUP_GET / ITEM_POPUP_GET) |
| `SCM_ADM_MNU_BTN_MPG_M` | ~4 row (main/SEARCH + main/SAVE + projectPopup/SEARCH + itemPopup/SEARCH) |
| `SCM_ADM_PROC_M` | ~15+ row (WRAPPER 10 args + Project SP 7 + Item SP 8 + 기존 TEAM/EC/SS_LIST) |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` (GUEST) | ~4 row |
| `SCM_MST_SHEET_COLUMNS` | -17 row (COM0008 duplicate cleanup. 클라우드도 duplicate 라면 적용 필요) |

### 5.2 신규 SP

| SP | 라인 수 | 분류 |
|---|---:|---|
| `SCM_MGR.DMF0072_GET_NNMASTER_MAPPING_WRAPPER` | 20 | CREATE OR REPLACE (signature 확장) |
| `SCM_MGR.DMF0072_GET_END_CUSTOMER_LIST` | 22 | CREATE OR REPLACE (cascading) |
| `SCM_MGR.DMF0072_GET_SALES_SITE_LIST` | 18 | CREATE OR REPLACE (multi-value split) |
| `SCM_MGR.DMF0072_GET_TEAM_LIST` | 27 | CREATE OR REPLACE (stub → As-Is 1:1) |
| `SCM_MGR.DMF0072_GET_PROJECT_POPUP_LIST` | 80 | CREATE OR REPLACE (신규) |
| `SCM_MGR.DMF0072_GET_ITEM_POPUP_LIST` | 200+ | CREATE OR REPLACE (신규 — WITH CTE 2개 + 3-UNION 분기) |

### 5.3 FE 신규/변경

- 신규: `nn-master-mapping/` (6 파일)
- 변경: `master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx` (`headerTitle?` prop 추가, 기존 영향 0)

---

## 6. 롤백 계획

### 6.1 DB 롤백

- 메타: `DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID LIKE 'MSG_API_DMF0072%'` 등 (BLOCK 별 역순)
- SP: 클라우드 기존 SP 백업 후 `CREATE OR REPLACE` 로 복원 — 본 패키지 적용 전 백업 의무

### 6.2 FE 롤백

- `nn-master-mapping/` 폴더 삭제
- `ItemByDivisionModal.tsx` 이전 버전 복원

### 6.3 SHEET_COLUMNS 롤백

`56_COM0008_sheet_columns_dedupe.sql` 적용 시 삭제한 17 row 복원은 불가 (정확 row 정보 없음). 클라우드 적용 전 백업:
```sql
CREATE TABLE SCM_MST_SHEET_COLUMNS_BAK_20260602 AS SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='COM0008' AND SHEET_NAME='itemByDivisionPopup';
```

---

## 7. 변경 이력

- 2026-06-02: 본 패키지 작성 (DMF0072 풀스택 + COM0008 fix 통합)
