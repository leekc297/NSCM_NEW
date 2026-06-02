# 4개 화면 클라우드 이관 패키지 (2026-06-02)

DMF0043 / DMF0043_01 / DMF0008 / DMF0072 로컬 작업분의 클라우드 이관용 ZIP 패키지.

---

## ZIP 파일 인벤토리

| ZIP | 화면 | 크기 |
|---|---|---|
| `DMF0008_deploy_2026-06-02.zip` | ERP EDI Master | ~18 KB |
| `DMF0043_deploy_2026-06-02.zip` | Contribute Main | ~44 KB |
| `DMF0043_01_deploy_2026-06-02.zip` | Contribute View | ~38 KB |
| `DMF0072_deploy_2026-06-02.zip` | NN Master Mapping | ~39 KB |

---

## 공통 구조

각 ZIP 내부:
```
{SCREEN_ID}/
├── README.md                    ← 화면별 적용 가이드 (필독)
├── 01_FE/                       ← FE 화면 파일 (디렉토리 통째)
├── 02_DB_Meta_SQL/              ← DB 메타 등록 SQL (i18n MSG_M + API_M + BTN_MPG + PROC_M + 권한)
├── 03_SP_PKG/                   ← SP/PKG/Seed/Cleanup SQL
└── 04_Verify/                   ← 적용 후 검증 SQL
```

---

## 적용 권장 순서 (4개 화면 동시 이관 시)

### 1. 사전 백업 (의무)

```sql
-- SCM_MST_SHEET_COLUMNS 백업 (DMF0072 의 56_COM0008_dedupe 적용 전)
CREATE TABLE SCM_MGR.SCM_MST_SHEET_COLUMNS_BAK_20260602 AS SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS;

-- 영향 받는 SP body 백업
CREATE TABLE SCM_MGR.PKG_DMF0072_BAK_20260602 AS
SELECT * FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME LIKE 'DMF0072%';
```

### 2. 화면별 적용

각 ZIP 내부 README.md 의 "3. 적용 순서" 따라 진행. 화면 간 의존성 없음 (병렬 적용 가능).

### 3. BE 재시작 (모든 화면 적용 후 1회)

PROC_M 메타 추가 → WAS 재기동 권장.

### 4. 통합 검증

```
1) DMF0008 메뉴 진입 → 정상 동작
2) DMF0043 메뉴 진입 → 정상 동작
3) DMF0043_01 메뉴 진입 → Version Popup Division 권한 기반 동적 표시 확인
4) DMF0072 메뉴 진입 → Project/Model Popup 표시 + Grid 계층 머지 확인
```

---

## 의존성 정합 확인 (사전 의무)

| 항목 | 확인 명령 |
|---|---|
| `UF_FX_STRING_SPLIT` / `UF_FX_STRING_SPLITFORIN` VALID | `SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE 'UF_FX_STRING_SPLIT%';` |
| `PKG_DMF0043 / PKG_DMF0072 / PKG_COM0000` BODY VALID | `SELECT NAME, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_TYPE='PACKAGE BODY' AND NAME IN ('PKG_DMF0043','PKG_DMF0072','PKG_COM0000');` |
| `SCM_MST_PROJECT / SITE_ITEM / ITEM_SN / SSO_DEPT_INFO` 가용 | `SELECT TABLE_NAME, COUNT(*) FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME IN ('SCM_MST_PROJECT','SCM_MST_SITE_ITEM','SCM_MST_ITEM_SN','SCM_MST_SSO_DEPT_INFO') GROUP BY TABLE_NAME;` |

---

## i18n (locales JSON) 별도 처리

본 패키지의 메타 SQL `BLOCK 1 MSG_M` 에 i18n key 모두 포함. 클라우드 적용 후:

```bash
python gen_i18n_msg_json.py    # 또는 동등 도구
# → nscm-fe/public/locales/{KO,EN,CN}.json 재생성
# → FE 빌드 + deploy
```

---

## 변경 이력

- 2026-06-02: 4개 화면 통합 패키지 (로컬 → 클라우드 이관용) 작성
