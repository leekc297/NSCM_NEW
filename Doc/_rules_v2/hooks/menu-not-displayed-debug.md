# Hook — menu-not-displayed-debug (메뉴 미표시 7-단계 디버깅)

> **트리거**: 사용자 신고 "메뉴 클릭 후 화면 안 나옴" / "권한 없다고 떠요" / 신규 화면 메뉴 미표시
>
> **목적**: 권한 누락 단정 금지. 7-단계 순서로 진단.

---

## §0 ⚠️ 안티 패턴 (사고 사례, 메모리 룰)

> 메모리 `feedback_mnu_uppr_case_standard.md` + 룰 21 §0 Quick Decision Tree:

**금지**:
- 사용자가 "권한 없다" 라고 신고 → 즉시 권한 INSERT 시도 → 4 화면 사고 반복
- 한 가지 원인만 추측 → 다른 6 원인 무시

**의무**: 7-단계 순서대로 진단. 각 단계에서 합격해야 다음 단계.

---

## §1 7-단계 디버깅

### §1.1 Step 1 — MNU_URL ↔ FE slug 정합 (⭐ "Page Not Found" 최우선 원인)

> 실제 파일: route-paths = `nscm-fe/packages/foundation/src/constants/route-paths.ts` / Router = `nscm-fe/apps/web/src/core/Router.tsx`.
> FE navigate 경로 = `findMenuPath(mnuId).map(m=>m.mnuUrl).join('/')` (`apps/web/src/mdi/useMDIStore.ts`) → **leaf MNU_URL === ROUTE_PATHS.{MNU_ID} 값** 이어야 매칭. 불일치 = **Page Not Found**.

```bash
# DB (사내/클라우드 각각)
sqlplus -s ... "SELECT MNU_URL FROM SCM_ADM_MNU_M WHERE MNU_ID = '{MENU_ID}';"   # 예 'sales-monitoring'
# FE
grep -n "{MENU_ID}" nscm-fe/packages/foundation/src/constants/route-paths.ts       # DMF0048: 'sales-monitoring'
grep -n "ROUTE_PATHS.{MENU_ID}" nscm-fe/apps/web/src/core/Router.tsx               # path: ROUTE_PATHS.DMF0048
```

**⚠️ Page Not Found 3-SET (2026-07-06 DMF0048/DMF0014 사고)** — 아래 3곳 slug 가 하나라도 어긋나면 Page Not Found:
1. `route-paths.ts` `ROUTE_PATHS.{MNU_ID}` 값
2. `Router.tsx` route `path: ROUTE_PATHS.{MNU_ID}` (리터럴 `'dmf00xx'` 금지)
3. `SCM_ADM_MNU_M.MNU_URL` (사내+클라우드 **둘 다** — FE 만 배포하고 MNU_URL 미변경이 대표 사고)

**리터럴 `dmf00xx` slug 금지** → 의미형 kebab (자매: DMF0008=`erp-edi-master`/DMF0020=`sales-future-price`). 상세 = 룰 13 §1.5.
- 불일치 시 3곳 모두 동일 slug 로 fix → Step 2 로 / 일치 시 Step 1.5 로

### §1.2 Step 1.5 — UPPR_MNU_ID 대소문자 정합 (DMF0020 사고)

```bash
sqlplus -s ... "SELECT UPPR_MNU_ID FROM SCM_ADM_MNU_M WHERE MNU_ID = '{MENU_ID}';"
# 표준: 'Demand_Master' (PascalCase + underscore)

# 자매 화면 cross-check
sqlplus -s ... "SELECT MNU_ID, UPPR_MNU_ID FROM SCM_ADM_MNU_M WHERE UPPR_MNU_ID = 'Demand_Master';"
# 7+ 자매 화면 표시
```

**금지 값**: `'DEMAND_MASTER'` (대문자), `'demand_master'` (소문자)
**의무**: 자매 화면 (DMF0004 / DMF0007 등) 의 UPPR_MNU_ID 정확 복사.

### §1.3 Step 1.6 — SHT_NM 자매 화면 cross-check (DMF0020 사고)

```bash
sqlplus -s ... "SELECT SHT_NM FROM SCM_ADM_MNU_M_SHEET WHERE MNU_ID = '{MENU_ID}';"
# 단일 sheet 화면: 'main' (표준)

# FE 와 일치
grep "SHEETS\." features/{domain}/src/pages/{screen}/{kebab}.constants.ts
# SHEETS.MAIN = 'main'   → 일치
```

**⚠️ 변형 — "조회 권한없음" (BTN_MPG/USER_GR 불완전 이관, 2026-07-06 DMF0043)**: BE 로그 `checkMenuBtnAuth(SEARCH, shtNm='<FE명>')` → **HAS_AUTH_YN='N'**. FE 소스가 쓰는 sheet_name 으로 `SCM_MST_SHEET_COLUMNS` 는 이관됐으나 `SCM_ADM_MNU_BTN_MPG_M`/`SCM_ADM_USER_GR_MNU_BTN_MPG_M` 은 **구명칭만** 등록(신명칭 0행) → 권한 매칭 실패.
```bash
# BE 로그 checkMenuBtnAuth 의 shtNm 값 확인 → 그 값으로 BTN_MPG 조회
SELECT COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{ID}' AND SHT_NM='{FE_SHEET}';  # 0 = gap
```
→ 보완: 구명칭 행을 FE명칭으로 **미러링**(값 그대로 INSERT-SELECT, 멱등 NOT EXISTS, null-API 오타버튼 제외). 메모리 `feedback_sht_nm_incomplete_migration_auth.md`.

**증상 (불일치)**: 화면 진입 시 `ORA-01403` at `PKG_NSCM_UI_COMM:17` (retrieveBtnInfoList)

### §1.3.5 Step 1.7 — MNU_DESC NULL 누락 (SYS0015 사고, 2026-06-09)

```sql
SELECT MNU_ID, MNU_DESC FROM SCM_ADM_MNU_M WHERE MNU_ID = '{MENU_ID}';
-- 결과 MNU_DESC NULL = 위반 (메뉴 트리에서 표시 안 됨, 사이드바 skip)
```

**증상**: BE 의 `PKG_NSCM_UI_COM_MENU.PR_GET_MENU_LIST` 결과에 menu row 가 반환되지만 `MNU_DESC: null` 인 경우, **sidebar 가 메뉴명 표시 불가로 skip**. minyonglee1 의 그룹 권한도 정상이고 UPPR/MNU_URL 도 정확하지만 화면에 안 보임.

**자매 화면 cross-check**:
```sql
SELECT MNU_ID, MNU_DESC FROM SCM_ADM_MNU_M WHERE MNU_ID IN ('SYS0010','SYS0013','{MENU_ID}');
-- 자매 화면: MNU_DESC='Lookup', 'Dynamic Query', ...
-- 신규 화면: MNU_DESC NULL  ← 위반
```

**fix**:
```sql
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_DESC='{Screen Name}' WHERE MNU_ID='{MENU_ID}' AND MNU_DESC IS NULL;
COMMIT;
```

**자동 검증 (PR 머지 게이트)**:
```sql
SELECT MNU_ID FROM SCM_ADM_MNU_M WHERE MNU_DESC IS NULL AND USE_YN='Y';
-- = 0 의무
```

**예방**: 신규 화면 MNU_M INSERT 시 `MNU_DESC` 필수 명시:
```sql
INSERT INTO SCM_ADM_MNU_M
  (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, MNU_TP_CD, UNIT_TP_CD, MNU_LV_NO, ...)
VALUES ('SYS0015', 'Admin_Menu', 'program', 'MNU_SYS0015', 'Program' /* ⭐ 의무 */, 'SCREEN', '-', 3, ...);
```

### §1.4 Step 2 — FE 라우터 등록 정합

```bash
grep -n "{MENU_ID}\|{screen-slug}" nscm-fe/apps/web/src/app/router/
# AppRouter.tsx 또는 동등 안 등록 확인
```

### §1.5 Step 3 — 메뉴 권한 (SCM_ADM_USER_GR_MNU_MPG_M)

```sql
SELECT FIND_AUTH_YN, INSERT_AUTH_YN, EDIT_AUTH_YN, SAVE_AUTH_YN, DELETE_AUTH_YN 
FROM SCM_ADM_USER_GR_MNU_MPG_M 
WHERE USER_ID = 'minyonglee1' AND GR_ID = 'ADMIN' AND MNU_ID = '{MENU_ID}';
-- 'Y' 또는 NULL (NULL = row 없음 = 권한 누락)
```

→ 권한 INSERT 는 여기서만 결정 (Step 1~1.6 모두 통과 후).

### §1.6 Step 4 — 부모 권한 (Lv1 + Lv2)

```sql
SELECT MNU_ID, FIND_AUTH_YN 
FROM SCM_ADM_USER_GR_MNU_MPG_M 
WHERE USER_ID='minyonglee1' AND MNU_ID IN ('Master', 'Demand_Master');
-- 부모 권한 없으면 자식 메뉴 표시 안 됨
```

### §1.7 Step 5 — 런타임 오류 (브라우저 콘솔)

```
F12 콘솔 → 404 / 500 / TypeError 확인
```

흔한 오류 + 매핑:
- `_setOwnerList is not a function` → Wijmo FlexGridColumnGroup 사고 (룰 07 §3.2)
- `value?.trim is not a function` → NUMBER → String 변환 누락 (룰 07 §3.6)
- 404 → BE endpoint 미등록 (Step 6 으로)
- 500 + `PLS-00306` → SCM_ADM_PROC_M 메타 누락 (Step 6)
- 500 + `ORA-01403` → SHT_NM 불일치 (Step 1.6)

### §1.8 Step 6 — BE 메타 누락 (PROC_M / API_M)

```sql
-- SCM_ADM_PROC_M 누락 시 PLS-00306 사고
SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM = 'P_DMF0099_GET_MAIN';
-- 0 이면 메타 누락 → BLOCK 4 INSERT 필요 (룰 12 §2.4)

SELECT COUNT(*) FROM SCM_ADM_API_M WHERE MNU_ID = '{MENU_ID}';
-- 0 이면 endpoint 등록 누락 → BLOCK 5 INSERT 필요
```

### §1.9 Step 7 — i18n 누락 / 사이드 이펙트

```bash
grep "MSG00\d\d\d\|LBL00\d\d\d" nscm-fe/apps/web/public/locales/ko/translation.json
# 등록 안 되면 텍스트 = key 자체 표시 (사용성 ↓, 사고 X)

# 또는 BE 재시작 필요한 경우 (`config-local.yml` 변경 후 등)
ps aux | grep gradle  # BE 가 실행 중인지
```

---

## §2 빠른 진단 명령 (one-liner)

```bash
MENU_ID="DMF0099"

# 한 줄 진단 (Step 1 ~ 6 통합)
sqlplus -s "$DB_CONN" <<EOF
SELECT 'MNU_M' AS chk, COUNT(*) AS cnt FROM SCM_ADM_MNU_M WHERE MNU_ID='$MENU_ID'
UNION ALL SELECT 'SHEET' AS chk, COUNT(*) FROM SCM_ADM_MNU_M_SHEET WHERE MNU_ID='$MENU_ID'
UNION ALL SELECT 'PROC_M', COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'P_${MENU_ID}_%'
UNION ALL SELECT 'API_M', COUNT(*) FROM SCM_ADM_API_M WHERE MNU_ID='$MENU_ID'
UNION ALL SELECT 'GR_MNU_MPG', COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='$MENU_ID' AND USER_ID='minyonglee1'
UNION ALL SELECT 'GR_BTN_MPG', COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='$MENU_ID' AND USER_ID='minyonglee1'
;
EOF
```

→ 각 카운트가 ≥ 1 이면 그 단계 통과. 0 이면 사고 단계.

---

## §3 적용 룰 cross-ref

| 단계 | 룰 |
|---|---|
| Step 1 (MNU_URL 정합) | 룰 13 §1.1 / 메모리 `reference_scm_adm_mnu_m_url_slug.md` |
| Step 1.5 (UPPR_MNU_ID) | 룰 13 §2 / 메모리 `feedback_mnu_uppr_case_standard.md` |
| Step 1.6 (SHT_NM) | 룰 13 §3 / 메모리 `feedback_sheet_name_main_standard.md` |
| Step 2 (FE 라우터) | 룰 13 §1.3 |
| Step 3-4 (권한) | 룰 11 §6 / 메모리 `reference_perm_seed_tables.md` |
| Step 5 (런타임) | 룰 07 / 룰 27 §F / 메모리 사고 모음 |
| Step 6 (BE 메타) | 룰 12 §2.4 / 메모리 `feedback_proc_meta_mandatory.md` |
| Step 7 (i18n) | 룰 05 §3.4 / 메모리 `feedback_i18n_lbl_code_pattern.md` |
