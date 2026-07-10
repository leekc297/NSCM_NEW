# 22. 이관 패키지 (`_artifacts`) 표준

> DB / 서버 미연결 환경에서 화면을 작성하고 클라우드 환경으로 이관할 때의 **압축 패키지 표준**.
> 화면 단위로 `_{SCREEN_ID}_artifacts/` 폴더를 만들고, FE/SQL/가이드를 모아서 압축 → 클라우드에서 풀어 적용.
>
> ⭐ **트리거**: 사용자가 "DB / 서버 미연결" 또는 "압축파일로 이관" 을 언급할 때.
> ⭐ **선행 룰**: [`17_NEW_SCREEN_QUICKSTART.md`](17_NEW_SCREEN_QUICKSTART.md) (9 step), [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) (4-파일 SQL 세트)
> ⭐ **연관**: [`18_CODE_REVIEW_CHECKLIST.md`](18_CODE_REVIEW_CHECKLIST.md) (GATE-1 빌드 검증 → 클라우드에서)

이력: 2026-05-22 신설 — DMF0020 작업을 통해 표준 확정.

---

## 1. 한 줄 요약

```
[Local 작업 환경 (DB/서버 미연결)]
  ↓ 화면 작성 → _{SCREEN_ID}_artifacts/ 폴더에 fe/ + sql/ + 가이드 모음
  ↓ PowerShell Compress-Archive → {SCREEN_ID}_To-Be_{YYYYMMDD}.zip
[클라우드 환경 (DB/서버 연결 가능)]
  ↓ 압축 해제 → _README.md 의 7-step 절차 따라 적용
  ↓ DB 메타 등록 → FE 파일 복사 → 공통 파일 수정 → 빌드 → 동작 검증
```

---

## 2. 폴더 구조 (표준)

```
_{SCREEN_ID}_artifacts/                                      ← 워크스페이스 root 에 생성
├── fe/                                                       ← FE 신규 파일 (이관 대상)
│   └── features/{domain}/src/pages/{kebab-page}/             ← 화면 폴더 그대로 (룰 05 §2.0.2)
│       ├── {PageName}.tsx
│       ├── {page-name}.constants.ts
│       ├── use{PageName}Store.ts
│       ├── __asis-mapping__.md                               ← 매트릭스 (룰 09 §3)
│       ├── index.ts
│       ├── hooks/
│       │   ├── use{PageName}Validation.ts
│       │   └── use{PageName}Expression.ts
│       └── components/
│           ├── {PageName}Form.tsx                + .module.scss
│           ├── {PageName}Grid.tsx
│           └── modals/                                       ← 룰 12 §11
│               ├── {Modal1}Modal.tsx              + .module.scss
│               └── ...
│
├── sql/                                                      ← DB 메타 등록 SQL (이관 대상)
│   ├── {NN}_{SCREEN_ID}_Registration.sql                     ← SQL*Plus
│   ├── {NN}_{SCREEN_ID}_Registration_DBeaver.sql             ← DBeaver 등록
│   ├── {NN}_{SCREEN_ID}_Registration_DBeaver_Verify.sql      ← 검증 (UNION ALL 단일 SELECT)
│   └── {NN}_{SCREEN_ID}_Registration_DBeaver_Diagnose.sql    ← 진단
│
├── _README.md                                                ← ⭐ 적용 절차서 (필수)
└── _COMMON_FILES_GUIDE.md                                    ← ⭐ 공통 파일 수정 가이드 (필수)
```

### 2.1 명명 규약

| 항목 | 규약 | 예시 |
|---|---|---|
| ⭐ **폴더 이름 (2026-07-10 사용자 명시 — 이관 대상 폴더 표준)** | **`{PROGRAM_ID}_{YYYYMMDD}_{HHMM}`** (대문자 · 대상일자 · 생성시각) | `DMF0020_20260710_1708` |
| (구) 폴더 이름 | `_{SCREEN_ID 소문자}_artifacts` (레거시 — 신규 이관 폴더는 위 규칙 사용) | `_dmf0020_artifacts` |
| SQL 파일 prefix `{NN}` | MENU_ID 의 숫자 부분 (예: DMF0020 → `20`) | `20_DMF0020_*` |
| 압축파일명 | `{SCREEN_ID}_To-Be_{YYYYMMDD}.zip` | `DMF0020_To-Be_20260522.zip` |

> ⭐ **이관 대상 폴더 생성 규칙 (2026-07-10)**: 클라우드 이관 폴더는 `{PROGRAM_ID}_{YYYYMMDD}_{HHMM}` 형식으로 생성한다. 화면 여러 개면 각각 별도 폴더. 시각(HHMM)은 폴더 생성 시각. PowerShell `Get-Date -Format 'yyyyMMdd_HHmm'` 사용(런타임 시각 — 하드코딩 금지).

### 2.2 ❌ 포함 금지

```
[ ] BE Java 파일 (동적 호출만 사용 — 룰 10)
[ ] PKG_{MENU_ID} Oracle PL/SQL (별도 To-be_v2_converted/ 로 PR)
[ ] node_modules / .turbo / dist (빌드 산출물)
[ ] 분석 자료 (Doc/_analysis/...) — 룰 09 의 매트릭스만 폴더 안에 포함
[ ] 공통 파일 (ROUTE_PATHS / Router.tsx / procedures.d.ts / locales) — _COMMON_FILES_GUIDE.md 에 patch 만
[ ] 환경 의존 파일 (.env, configs)
```

---

## 3. `_README.md` 표준 양식

화면 적용자가 이 1 파일만 읽어도 7-step 으로 적용 가능해야 함.

### 3.1 필수 섹션

```markdown
# {SCREEN_ID}_{ScreenName} — To-Be 이관 패키지

> 클라우드 환경에서 NSCM 프로젝트에 적용할 신규 화면 패키지.
> DB / 서버 미연결 환경에서 작성 → 이관 후 테스트 예정.

작성: YYYY-MM-DD
화면 ID: **{SCREEN_ID}** ({ScreenName} / 한글명)
To-Be 도메인: `{domain}` | slug: `{slug}` | URL: `/{path}/{slug}`

## 1. 패키지 구성
(전체 폴더 트리 + 파일별 줄 수 표)

## 2. 통계
| 항목 | 값 |
|---|---:|
| As-Is 메인 .cs 줄 수 | N |
| As-Is POPUP .cs 줄 수 | N (전용 X개)  |
| Validation | N (메인) + M (POPUP) |
| Expression | N |
| SP 개수 | N |
| To-Be 매핑 ✅ | N + ⚠ M (follow-up) |
| 사업부 분기 보존 | N건 |

## 3. 적용 순서 (클라우드 환경) — 7 step
### Step 1. 환경 확인 (git branch)
### Step 2. As-Is SP → Oracle PKG 변환 + 컴파일 (별도 작업)
### Step 3. DB 메타 등록 SQL 실행 (SQL*Plus 또는 DBeaver)
### Step 4. FE 파일 복사 (robocopy / cp -r)
### Step 5. 공통 파일 수정 (_COMMON_FILES_GUIDE.md 참조)
### Step 6. 빌드 검증 (pnpm gen:procedures && pnpm build)
### Step 7. 동작 검증 (브라우저)

## 4. 트러블슈팅
### 4-1. "빈 결과" — SCM_ADM_PROC_M 누락 (BLOCK 3)
### 4-2. "No Permission" — 권한 2 테이블 누락 (BLOCK 7)
### 4-3. "API not found" — BLOCK 4/5 누락
### 4-4. Grid 컬럼 빈 상태 — BLOCK 6 누락
### 4-5. Wijmo finishEditing null 에러 — 21_TROUBLESHOOTING §3

## 5. 룰셋 준수 확인 (체크리스트)
- [x] `01_CLAUDE` §6
- [x] `05_SCREEN_TEMPLATE` §2.0.2 확장 패턴
- [x] `07_DO_AND_DONT` Top 11
- [x] `08_SCREEN_REGISTRATION` 7-BLOCK + 4-파일
- [x] `09_WIJMO_VALIDATION_EXPRESSION` 100% 매핑
- [x] `10_API_DYNAMIC_PROC` 동적 호출만
- [x] `11_AUTH_SECURITY` 권한 2 테이블 동적 복제
- [x] `12_GRID_COMMON` (DataGrid / EditTracker / 동적 컬럼 / Modal 통합)
- [x] `13_I18N_MESSAGES` KO/EN/CN 3행
- [x] `15_ROUTING_MDI` leaf slug + LazyLoader
- [x] `17_NEW_SCREEN_QUICKSTART` 9 step
- [x] `22_PACKAGE_ARTIFACTS` 본 룰

## 6. 메타데이터
- 작성자 / 작성일 / 룰셋 버전 / As-Is 분석 자료 버전 / 표준 참조 화면
```

---

## 4. `_COMMON_FILES_GUIDE.md` 표준 양식

이관 대상 외 **공통 파일 4개** 의 정확한 patch 위치 + before/after.

### 4.1 수정 대상 4 파일 (항상 동일)

| # | 파일 | 수정 내용 |
|---|---|---|
| 1 | `nscm-fe/packages/foundation/src/constants/route-paths.ts` | `ROUTE_PATHS` 객체에 `{MENU_ID}: '{slug}'` 1 줄 추가 |
| 2 | `nscm-fe/apps/web/src/core/Router.tsx` | LazyLoader 선언 + nested 라우트 등록 (2 곳) |
| 3 | `nscm-fe/configs/types/procedures.d.ts` | `RawProcedureMap` 에 `{MENU_ID}` entry 추가 (또는 `pnpm gen:procedures`) |
| 4 | `nscm-fe/apps/web/public/locales/{KO,EN,CN}.json` | `gen_i18n_msg_json.py` 실행 (자동) |

### 4.2 patch 형식 (Before/After)

각 파일별로 **Before / After** 코드 블록 + 행 번호 명시:

```markdown
## 1. `nscm-fe/packages/foundation/src/constants/route-paths.ts`

### Before (line 27 부근)
\`\`\`ts
  DMF0008: 'erp-edi-master',
  DMF0082: 'forecast-price',
\`\`\`

### After
\`\`\`ts
  DMF0008: 'erp-edi-master',
  DMF0020: 'sales-future-price',   // ★ 신규
  DMF0082: 'forecast-price',
\`\`\`

> ROUTE_PATHS 의 값은 leaf slug 만. DB `SCM_ADM_MNU_M.MNU_URL` 과 동일.
```

### 4.3 적용 순서 안내

가이드 마지막에 5 절차:
1. **DB 등록 SQL 실행**
2. **PKG_{SCREEN_ID} SP 컴파일** (별도 작업)
3. **FE 파일 복사**
4. **공통 파일 수정** (§4.2 patch)
5. **i18n 갱신** + **빌드 검증** + **동작 검증**

### 4.4 Follow-up 명시

가이드 끝에 본 작업 범위 외 항목 명시:

```markdown
## 6. Follow-up (보류 항목)

다음은 본 작업 범위 외:
- ❌ **공통 POPUP {N}종 To-Be 구현** ({name} / ...) → 별도 PR
- ❌ **BE Java Controller** (동적 호출만 사용)
- ❌ **PKG_{SCREEN_ID} SP 컴파일** (As-Is → Oracle 변환 별도 PR)
- ❌ ...
```

---

## 5. 압축 명령 (PowerShell)

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$src = 'C:\Projects\NSCM\_{screen_id}_artifacts'
$dst = "$src\{SCREEN_ID}_To-Be_$(Get-Date -Format 'yyyyMMdd').zip"

if (Test-Path $dst) { Remove-Item $dst -Force }

Compress-Archive `
  -Path "$src\fe","$src\sql","$src\_COMMON_FILES_GUIDE.md","$src\_README.md" `
  -DestinationPath $dst `
  -CompressionLevel Optimal

Get-Item $dst | Select-Object FullName, Length, LastWriteTime
```

> ❌ 압축 포함 금지: `_*_artifacts/` 자체 폴더 (압축 내부에 중복 폴더 생기지 않도록 `-Path` 에 하위만 나열)

### 5.1 압축 후 검증

```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($dst)
$zip.Entries | Select-Object FullName, Length | Format-Table -AutoSize
$zip.Dispose()
```

체크 항목:
```
[ ] fe/ + sql/ + _README.md + _COMMON_FILES_GUIDE.md 모두 포함
[ ] node_modules / .turbo / dist 0건
[ ] BE Java 파일 0건
[ ] 분석 자료 (Doc/_analysis/) 0건 (단, FE 폴더 안의 __asis-mapping__.md 는 포함됨)
[ ] 압축 크기 < 1 MB (정상 화면 기준)
```

---

## 6. 클라우드 적용 절차 (재확인)

`_README.md` §3 의 7 step. 클라우드 사용자가 압축 풀고 그대로 따라 실행.

1. `unzip {SCREEN_ID}_To-Be_{YYYYMMDD}.zip`
2. `git checkout -b feat/{kebab-screen-id}` (clean state 권장)
3. `sql/{NN}_{SCREEN_ID}_Registration_DBeaver.sql` 실행 (DBeaver) → `_Verify.sql` 결과 7행 모두 통과 확인
4. `cp -r fe/features/{domain}/src/pages/{kebab-page} nscm-fe/features/{domain}/src/pages/`
5. `_COMMON_FILES_GUIDE.md` §1~§4 patch 적용 (수동)
6. `cd nscm-fe && pnpm install && pnpm gen:procedures && pnpm lint:fix && pnpm type-check && pnpm build`
7. `pnpm dev` → 브라우저 동작 검증 + POPUP / 사업부 분기 / 동적 컬럼 모두 동작 확인

---

## 7. 자기 점검 (패키지 작성 직후)

```
[ ] 폴더 명명 _{screen_id}_artifacts 규약 준수
[ ] fe/ 안의 폴더 구조가 nscm-fe 상대 경로와 정확히 일치 (features/{domain}/src/pages/{kebab})
[ ] sql/ 안에 4-파일 세트 모두 포함 (.sql + _DBeaver.sql + _Verify.sql + _Diagnose.sql)
[ ] _README.md 의 §3 적용 순서가 7-step 으로 명확
[ ] _COMMON_FILES_GUIDE.md 의 4 파일 patch 가 Before/After 형식
[ ] __asis-mapping__.md 가 FE 폴더 안에 포함 (룰 09 §3)
[ ] 압축 후 zip 내부 검증 (BE / 분석자료 / node_modules 미포함)
[ ] 압축 파일명이 {SCREEN_ID}_To-Be_{YYYYMMDD}.zip
```

---

## ⭐ 9. SP / 메타 완전성 (Combo / POPUP / Action SP 모두 포함) — 2026-06-02 신설

### 9.1 배경 (사용자 명시 요구)

> "신규 화면에 대한 압축파일 생성 중 아래의 항목에 대한 누락이 있는것 같습니다. 추가 요청 합니다.
> - 컬럼, PROC, API 등 권한 관련 SQL전체
> - COMBO, POPUP 에 사용되는 모든 QUERY 가 들어가는 SP, PKG 전체
> - COMBO, POPUP 에서 사용하기 위하여 SCM_ADM_PROC_M 에 등록한 QUERY"

**사고 사례 (실제, 2026-06-02)**:
- DMF0072 deploy zip: 메인 SP 2건 (GET/SAVE) 메타만 포함. lookup 5종 (DataType/Division/Team/EndCustomer/SalesSite) 의 API_M/BTN_MPG/PROC_M + SP body 통째 누락 → 새 환경 deploy 시 조회 조건 dropdown 동작 X.
- DMF0008 deploy zip: updateHistory sheet 의 모든 메타 + SP body 누락.
- DMF0043 deploy zip: 메타 0 누락이지만 standalone SP body 9건 03_SP_PKG/ 미포함 → 새 환경 PKG/SP 빈 상태에서 ORA-04063.
- DMF0043_01 deploy zip: DMF0002_GET_TITLESET_POPUP 공용 SP 동봉 누락 → TitleSet 모달 동작 X.

### 9.2 의무 인벤토리 (deploy 직전 필수 cross-check)

deploy zip 작성 직전 다음 5종을 화면 별로 인벤토리 작성 + 4-파일 세트 작성 의무:

| # | 인벤토리 | 추출 방법 | 산출물 |
|---:|---|---|---|
| 1 | FE useTabProcQuery / useProcMutation 의 모든 sheetName | `grep -rE "useTabProcQuery\|useProcMutation" nscm-fe/features/.../{화면-slug}/` | sheetName 목록 (= BTN_MPG SHT_NM) |
| 2 | FE POPUP modal 컴포넌트 | `grep -rE "<\w+Modal" nscm-fe/features/.../{화면-slug}/` + components/* | modal 별 sheet name |
| 3 | 위 1+2 의 sheetName 에 매핑된 BE SP (`SCM_ADM_MNU_BTN_MPG_M` 의 API_ID → `SCM_ADM_API_M` 의 API_URL) | DB 조회 또는 `_artifacts/_diagnostics/` 진단 SQL | SP 이름 목록 |
| 4 | 위 SP 들의 `SCM_ADM_PROC_M` PROC_NM 등록 | DB 조회 | PROC_NM × COL_NM × COL_TP_CD 인벤토리 |
| 5 | 위 SP 들의 ALL_SOURCE body | `DBMS_METADATA.GET_DDL('PROCEDURE', name, owner)` 일괄 추출 | `03_SP_PKG/` 의 standalone SP body 파일 |

### 9.3 메타 보강 SQL — 4-파일 세트 양식

기존 `44_DMF{XXXX}_meta.sql` 에 lookup/popup 누락 발견 시 별도 보강 파일 `{N}_DMF{XXXX}_{purpose}_meta_boost.sql` 작성 (덮어쓰기 금지 — NOT EXISTS 멱등 패턴).

표준 6 BLOCK:

```
BLOCK 1 : MSG_M (각 API 의 API_MSG_ID 마다 1 row)
BLOCK 2 : API_M (API_ID + PROC_SELECT/PROC_SAVE + API_URL=SP 이름)
BLOCK 3 : BTN_MPG (MNU_ID, SHT_NM=camelCase sheetName, MNU_BTN_CD=SEARCH/SAVE)
BLOCK 4 : PROC_M (COL_NM 변환 표 — P_USER_ID→sesUserId / P_MENU_ID→mnuId / P_LANG_CD→sesLangCd / 그 외 IN→camelCase / O_RCn→소문자)
BLOCK 5 : GUEST 권한 (BTN_MPG 자동 복제)
BLOCK 6 : 사후 카운트
```

cross-ref: 룰 08 §4.4 (PROC_M 자동 변환 표) / 메모리 `feedback_proc_meta_mandatory.md` + `feedback_proc_meta_col_nm_be_auto_keys.md`.

### 9.4 SP body 추출 — `03_SP_PKG/` 표준

```bash
# 1. 인벤토리 SP 목록을 한 .sql 로 일괄 추출 (PROMPT block 으로 구분)
cat > /tmp/extract.sql <<EOF
BEGIN
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', false);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', true);
END;
/
PROMPT === SP_BEGIN: <NAME> ===
SELECT DBMS_METADATA.GET_DDL('PROCEDURE', '<NAME>', 'SCM_MGR') FROM DUAL;
PROMPT === SP_END ===
EOF
# 2. awk 로 PROMPT 마커를 PROCEDURE 별 헤더 + `/` terminator 로 변환
# 3. PROMPT/SET/--/CREATE 패턴 정합 검증 후 03_SP_PKG/{N}_{화면ID}_{purpose}_SP_bodies.sql 저장
```

### 9.5 wrapper / 공용 SP — 별도 표시 의무

| 분류 | 처리 |
|---|---|
| 화면 전용 SP (`DMF{화면ID}_*`) | 03_SP_PKG/ 에 body 의무 동봉 |
| 화면별 wrapper (`DMF{화면ID}_GET_XXX_WRAPPER`) | body 동봉 + wrapper 가 호출하는 메인 SP body 도 같이 동봉 (DMF0008_GET_UPDATE_HISTORY → DMF0000_GET_UPDATE_HISTORY 사례) |
| 공용 SP (`DMF0000_*` / `COM*` / 다른 화면 SP 재사용) | body 동봉 + 비고에 "공용 — 환경 사전 존재 확인 의무" 표시 (DMF0043_01 의 DMF0002_GET_TITLESET_POPUP 사례) |

**환경 사전 존재 확인 명령** (deploy 받는 측 의무):
```bash
sqlplus -s SCM_MGR/<pw>@<dsn> <<< "SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_TYPE='PROCEDURE' AND OBJECT_NAME=UPPER('<공용SP>');"
# row 0 = 동봉 SP body 적용 의무
# row 1 + STATUS=VALID = SKIP 가능
# row 1 + STATUS=INVALID = ALTER PROCEDURE COMPILE 후 재확인
```

### 9.6 자기 점검 (deploy zip 작성 직전)

```
[ ] §9.2 의 5 인벤토리 모두 작성?
[ ] sheetName 카운트 == BTN_MPG SHT_NM 카운트 == API_M 카운트?
[ ] POPUP modal 카운트 == BTN_MPG (popup sheet) 카운트?
[ ] 화면 전용 SP body 모두 03_SP_PKG/ 에?
[ ] wrapper / 공용 SP body 도 03_SP_PKG/ 에 (비고: 공용 — 환경 사전 확인)?
[ ] 메타 보강 SQL 4-파일 세트 (sql + DBeaver + Verify + Diagnose) 작성?
[ ] BLOCK 6 사후 카운트가 인벤토리 카운트와 1:1 정합?
[ ] 멱등 검증 (재실행 시 0 rows created — NOT EXISTS 차단)?
```

상세: [`hooks/deploy-package-completeness.md`](hooks/deploy-package-completeness.md), 메모리 `feedback_deploy_package_completeness.md`.

---

## 8. 관련 문서

| 룰 | 주제 |
|---|---|
| [`05_SCREEN_TEMPLATE.md`](05_SCREEN_TEMPLATE.md) §2.0 | FE 폴더 구조 (기본/확장 패턴) |
| [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) §3, §7.1 | 7-BLOCK + 4-파일 SQL 세트 |
| [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md) §3 | `__asis-mapping__.md` 표준 양식 |
| [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md) | 동적 호출 (BE Java 코드 0) |
| [`12_GRID_COMMON.md`](12_GRID_COMMON.md) §11 | Modal 통합 패턴 |
| [`17_NEW_SCREEN_QUICKSTART.md`](17_NEW_SCREEN_QUICKSTART.md) | 9 step 신규 화면 절차 |
| [`18_CODE_REVIEW_CHECKLIST.md`](18_CODE_REVIEW_CHECKLIST.md) | PR 머지 게이트 (GATE-1 빌드 검증) |
