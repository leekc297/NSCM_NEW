# Post-Write Hook — NSCM 코드 작성 직후 검증

> Claude/AI가 파일 작성을 완료한 직후 반드시 자체 검증해야 할 항목.
> 위반 발견 시 즉시 수정 후 진행.

## 1. TypeScript / TSX 검증

```
[ ] any 타입 사용 없음
[ ] import 경로 alias (@shared/@foundation/@domain) 사용
[ ] console.log 잔존 없음 (운영 코드)
[ ] inline style 사용 없음 (SCSS Module만)
[ ] Wijmo 외 그리드 라이브러리 사용 없음
[ ] useState로 페이지 전역 상태 없음 (Zustand 사용)
[ ] Zustand 셀렉터 개별 사용 (객체 destructuring X)
[ ] 표준 훅 useTabProcQuery/useProcMutation 사용 (직접 axios X)
[ ] i18n 메시지 코드 사용 (하드코딩 영문 텍스트 X)
```

## 2. Java 검증

```
[ ] 패키지 선언이 디렉토리 구조와 일치
[ ] @Slf4j + @Service + @RequiredArgsConstructor 표준 어노테이션
[ ] @Autowired 필드 주입 없음 (final 필드만)
[ ] Controller가 extends BaseController
[ ] ServiceImpl이 extends BaseService implements XService
[ ] private final String nameSpace = "..." 정의됨
[ ] DTO에 @Getter @Builder @AllArgsConstructor + static of()/listOf()
[ ] @Slf4j 사용 + parameterized 로깅 (log.info("user={}", id))
[ ] ResponseEntity<BaseResponse<T>> 반환 (직접 ResponseEntity X)
[ ] 클래스 헤더 Javadoc 주석 포함 (@Project @Package @FileName @author @date @description)
```

## 3. MyBatis XML 검증

```
[ ] namespace="com.lgcns.nscm.{domain}.{feature}" 형식
[ ] statementType="CALLABLE" (Procedure 호출만)
[ ] { CALL PKG_*.P_*(...) } 표준 형식
[ ] #{DATARESULT, mode=OUT, jdbcType=CURSOR, ...} OUT 파라미터
[ ] ${} 직접 바인딩 사용 없음 (#{}만)
[ ] resultMap 정의 (HashMap 매핑)
```

## 4. SQL / PL/SQL 검증 (Oracle)

```
[ ] DATEADD/CHARINDEX/STRING_SPLIT 잔존 0건
[ ] N'유니코드' 접두사 없음
[ ] @변수 없음 (V_ / v_ 사용)
[ ] GETDATE() 없음 (SYSDATE)
[ ] ISNULL() 없음 (NVL)
[ ] WITH (NOLOCK) 없음
[ ] [bracket] 없음
[ ] dbo. prefix 없음
[ ] + 문자열 결합 없음 (|| 사용)
[ ] $$PLSQL_UNIT 사용 (v_program_name 하드코딩 X)
```

## 5. 신규 화면 추가 시 — 7개 영역 메타 등록 점검 ⭐ (자기완결형)

> 2026-05-19 업데이트: 외부 PKG (PKG_NSCM_SCREEN_REGISTRATION) 폐기. 자기완결형 인라인 DML 패턴으로 통일.
> 상세 룰: `Doc/_dev_rules/08_SCREEN_REGISTRATION.md` §2, §7

신규 화면을 추가했다면 다음 **7개 테이블** 모두 등록 확인:

```
[ ] 1. SCM_ADM_MSG_M               — i18n (MNU_{MENU_ID} × KO/EN/CN 3행)
[ ] 2. SCM_ADM_PROC_M              — SP IN/OUT 파라미터 ★ 누락 시 DMF0007 같은 빈 결과
[ ] 3. SCM_MST_SHEET_COLUMNS       — Grid 컬럼 정의 (SP OUT 컬럼별 1 row)
[ ] 4. SCM_ADM_MNU_M               — 메뉴 마스터 (MNU_ID, URL, MNU_MSG_ID)
[ ] 5. SCM_ADM_API_M               — API 메타 (API_ID, API_URL = PKG.SP)
[ ] 6. SCM_ADM_MNU_BTN_MPG_M       — 라우팅 매핑 (MNU × SHT × BTN → API_ID)
[ ] 7. SCM_ADM_USER_GR_MNU_MPG_M   — 그룹 메뉴 권한
```

❌ **금지**: `PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN` 호출 (PKG 폐기됨)
✅ **권장**: 인라인 DML 만 사용 (`02_NEW_SCREEN_FULL_REGISTRATION_TEMPLATE.sql` 패턴)

검증 SQL (4번 항목 누락 시 화면 미동작):
```sql
SELECT '1.MENU'         AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN FROM SCM_ADM_MNU_M             WHERE MNU_ID = 'DMF0099'
UNION ALL SELECT '2.MENU_AUTH',  COUNT(*), 1 FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0099'
UNION ALL SELECT '3.UI_COLS',    COUNT(*), 1 FROM SCM_MST_SHEET_COLUMNS     WHERE PROGRAM_ID = 'DMF0099'
UNION ALL SELECT '4.PROC',       COUNT(*), 3 FROM SCM_ADM_PROC_M            WHERE PROC_NM LIKE 'PKG_DMF0099.%'
UNION ALL SELECT '5.API',        COUNT(*), 1 FROM SCM_ADM_API_M             WHERE API_ID LIKE 'DMF0099\_%' ESCAPE '\'
UNION ALL SELECT '6.MNU_BTN_MPG',COUNT(*), 1 FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = 'DMF0099'
UNION ALL SELECT '7.I18N_MNU',   COUNT(*), 3 FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_DMF0099';
```

## 5.0. ⭐ INSERT NOT NULL + DEFAULT 정책 검증 (2026-05-22 신설 — DMF0020 ORA-01400 사고 반영)

SQL DML 작성 직후 다음 자기 검증을 **모든 INSERT 별** 수행:

### 5.0.1 표준 4 컬럼 명시 검증 (필수)

NSCM 의 모든 마스터/매핑 테이블 INSERT 는 4 표준 컬럼 항상 명시:

```bash
# INSERT 문에서 4 컬럼 명시 누락 검출 (작성 직후 자기 grep)
grep -nE 'INSERT (INTO|ALL).*SCM_(ADM|MST)_' {your_sql_file}.sql | head -20
# 결과의 각 INSERT 가 다음 4개 컬럼을 모두 포함하는지 수동 확인:
#   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
```

체크리스트:
```
[ ] 모든 INSERT 문이 4 표준 컬럼 (CREATED_BY / CREATION_DATE / LAST_UPDATED_BY / LAST_UPDATE_DATE) 명시
[ ] DEFAULT 정책 의존 0건 (테이블 무관 — DEFAULT 없는 NOT NULL 테이블 6개 위험)
[ ] 첫 INSERT 1줄 완성 → DDL cross-check → N-1줄 복사 (순서 준수)
```

### 5.0.2 DDL 5층 cross-check 통과 확인

작성한 INSERT 의 컬럼 목록이 다음 5층 모두 맞는지 확인:

```
[ ] ① 컬럼명 (대소문자 + 약어 OFF) — 추측 X, DDL 1차 소스에서 복사
[ ] ② 데이터 타입 (VARCHAR2 길이, NUMBER 정밀도)
[ ] ③ NOT NULL 컬럼 모두 INSERT 에 포함
[ ] ④ DEFAULT 없는 NOT NULL 은 절대 누락 금지
[ ] ⑤ CHECK / FK / UNIQUE 제약 위반 가능성 검토
```

### 5.0.3 DB 환경 보유 시 자동 검증 SQL

```sql
-- 작성된 INSERT 의 누락 컬럼 검출 (사전 dry-run)
SELECT COLUMN_NAME
  FROM USER_TAB_COLS
 WHERE TABLE_NAME = '{대상_테이블}'
   AND NULLABLE = 'N'
   AND DATA_DEFAULT IS NULL
   AND COLUMN_NAME NOT IN (
     -- INSERT 에 포함한 컬럼들 나열
     'MSG_ID', 'LANG_CD', 'MSG_NM', 'MSG_TP_CD', 'USE_YN',
     'CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE'
   );
-- 결과 0 행 이어야 통과 — 1행이라도 있으면 ORA-01400 예정
```

→ 상세 룰: [`anti-simplification.md`](anti-simplification.md) §1.4 + [`../08_SCREEN_REGISTRATION.md`](../08_SCREEN_REGISTRATION.md) §3.0

## 5.1. SQL 등록 스크립트 듀얼 출력 점검 ⭐

신규 화면 등록 SQL 작성 시 다음 4개 파일이 동시에 존재해야 함:

```
registrations/{prefix}_{MENU_ID}_Registration.sql                  — SQL*Plus / SQLcl 용 (통합)
registrations/{prefix}_{MENU_ID}_Registration_DBeaver.sql          — DBeaver 등록 PL/SQL 블록 (statement 1개)
registrations/{prefix}_{MENU_ID}_Registration_DBeaver_Verify.sql   — DBeaver 검증 SELECT (statement 1개)
registrations/{prefix}_{MENU_ID}_Registration_DBeaver_Diagnose.sql — DBeaver 라우팅 진단 PL/SQL (statement 1개)
```

DBeaver 파일 작성 시 절대 금지 항목:

```
[ ] SET DEFINE / SET SERVEROUTPUT / DEFINE / &변수 / PROMPT / UNDEFINE 사용 금지
[ ] END; 뒤 `/` 종결자 금지 (ORA-00911 유발)
[ ] 단일 파일에 PL/SQL 블록 + SELECT 혼재 금지 (PLS-00103 유발)
[ ] PKG_NSCM_SCREEN_REGISTRATION 호출 금지 (PKG 폐기됨)
```

→ 상세 룰: `Doc/_dev_rules/08_SCREEN_REGISTRATION.md` §7.1

## 5.5. ⭐ As-Is Validation / Expression 카운트 일치 검증 (신규 화면 FE)

신규 화면 FE 작업 종료 직후 카운트 일치 자체 검증:

```
[ ] hooks/use{PageName}Validation.ts 작성됨
    → validation.md 행 수 == Validation 적용 건수 (z.object 필드 + switch case + 권한 분기)
[ ] hooks/use{PageName}Expression.ts 작성됨 또는 cellTemplate에 적용됨
    → expressions.md 행 수 == Expression 적용 건수 (cellEditEnding/cellEditEnded/setCellData/aggregate)
[ ] __asis-mapping__.md 매트릭스 작성 — As-Is Line ↔ To-Be 위치 1:1
[ ] 각 적용 코드에 // AS-IS: {파일명}.cs:{라인} 주석 포함
[ ] 사업부 분기(40/81/82) 통합 없이 그대로 보존
[ ] Cell.Formula 사용 화면 → FlexSheet 사용 확인 (FlexGrid 아님)
[ ] MSG#### 하드코딩 없음 → t('msg.MSG####') 변환
```

자동 검증 (수동 grep):
```bash
# Validation 적용 카운트 추정
grep -E "errors.push|case '|isReadOnly|e.cancel" features/{domain}/src/pages/{page}/hooks/use*Validation.ts | wc -l

# Expression 적용 카운트 추정
grep -E "e.cancel|invalidate|setCellData|aggregate" features/{domain}/src/pages/{page}/hooks/use*Expression.ts | wc -l

# AS-IS 라인 주석 카운트
grep -c "AS-IS:" features/{domain}/src/pages/{page}/**/*.ts

# __asis-mapping__.md ✅/❌ 카운트
APPLIED=$(grep -c '| ✅ |$' features/{domain}/src/pages/{page}/__asis-mapping__.md)
PENDING=$(grep -c '| ❌ |$' features/{domain}/src/pages/{page}/__asis-mapping__.md)
echo "적용 $APPLIED / 미적용 $PENDING"
```

### MSG ID 신규 사용 시 → i18n JSON 갱신

새로운 MSG#### 를 코드에 추가했다면:

```bash
# i18n JSON 재생성 (전체 97 화면 스캔)
python3 Doc/_analysis/scripts/gen_i18n_msg_json.py \
    --out C:/Projects/NSCM/nscm-fe/apps/web/src/locales/

# 새로 추가된 MSG ID 가 마스터에 없다면 (TODO 로 표기됨) → SCM_ADM_MSG_M DB 등록 필요
```

→ 상세: `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md` + `Doc/_analysis/scripts/README.md`

## 6. FE procedures.d.ts 갱신 점검 ⭐

신규 화면 또는 SP 컬럼 변경 시:

```
[ ] configs/types/procedures.d.ts 에 화면 entry 추가/갱신
[ ] pnpm gen:procedures 실행 (자동 생성 활성화 시)
[ ] git diff procedures.d.ts 변경분 확인
[ ] type-check 통과 (pnpm type-check)
```

→ 상세: `Doc/_dev_rules/08_SCREEN_REGISTRATION.md` §4, `To-be_v2_converted/08_Screen_Registration/02_Generate_Procedures_DTS.md`

## 7. 파일 구조 검증

**FE 신규 화면**:
```
features/{domain}/src/pages/{kebab-page}/
├── {PageName}.tsx                  ← 메인
├── {page-name}.constants.ts        ← MENU_ID/SHEETS/RESPONSE_SET
├── use{PageName}Store.ts           ← Zustand
├── index.ts                        ← export *
└── components/
    ├── {PageName}Form.tsx          ← 검색 영역
    ├── {PageName}Form.module.scss
    └── {PageName}Grid.tsx          ← Wijmo
```

**BE 신규 기능**:
```
src/main/java/com/lgcns/nscm/{domain}/{feature}/
├── {Feature}Controller.java
├── {Feature}Service.java       (interface)
├── {Feature}ServiceImpl.java
└── dto/
    ├── {Feature}Request.java
    └── {Feature}Response.java

src/main/resources/sql/{domain}/{Feature}.xml
```

## 8. 일관성 검증 (가장 중요)

```
[ ] 새로 작성한 파일을 user-management/menu와 나란히 놓고 봤을 때 차이가 없는가?
[ ] 함수 정의 스타일(arrow function vs declaration)이 일치하는가?
[ ] export 방식(named vs default)이 일치하는가?
[ ] 빈 줄 패턴, indent, 주석 스타일이 일치하는가?
```

## 9. 자동 검증 명령

작성 후 즉시 실행:

**FE**:
```bash
# 작성한 파일만 검증
pnpm prettier --check {file}
pnpm eslint {file}

# 전체
pnpm lint:fix
pnpm type-check
```

**BE**:
```bash
./gradlew spotlessApply -PspotlessFiles="{file}"
./gradlew build
```

## 10. 발견 시 즉시 조치

| 위반 | 조치 |
|---|---|
| any 타입 | 정확한 타입으로 교체 |
| 상대 경로 import | alias로 교체 |
| console.log | 제거 또는 logger 사용 |
| @Autowired 필드 | final 필드 + @RequiredArgsConstructor |
| Hardcoded SQL ID | nameSpace 변수 도입 |
| MSSQL 키워드 잔존 | Oracle 대응 함수로 즉시 변환 |
| 누락된 주석 헤더 | 표준 헤더 추가 (BE 클래스) |

위반 사항을 모두 수정한 후 다음 작업으로 진행.

## 11. FE Wijmo Grid 안전 패턴 ⭐ (2026-05-19 신설)

화면 검색/저장 핸들러에서 Wijmo `gridRef` 수동 조작 시 다음 항목 확인:

```
[ ] handleSearch 에 gridRef.current?.invalidate() 호출 없음 (React re-render 가 처리)
[ ] gridRef.current?.invalidate() 가 필요하면 다음 중 하나로 보호:
    (A) if (gridRef.current?.hostElement) { gridRef.current.finishEditing(true); gridRef.current.invalidate(); }
    (B) queueMicrotask(() => gridRef.current?.invalidate())
[ ] dynamicColumns(예: dateColumns) 가 setState 로 변경되는 핸들러 순서:
    1) dynamicColumns 갱신 → 2) filters/data 갱신 → 3) (필요 시) editTracker.clearChanges()
[ ] data?.o_rc1?.length (optional chaining 2단) 사용 — data?.o_rc1.length 금지
```

**예방하는 에러**: `Uncaught TypeError: Cannot read properties of null (reading 'finishEditing')` (DMF0007 사례, 2026-05-19)

→ 상세: `Doc/_dev_rules/21_TROUBLESHOOTING.md` §3

## 12. AI 측 PowerShell 도구 호출 시 — UTF-8 prelude ⭐ (2026-05-19 신설)

AI 가 PowerShell 도구를 호출해 작업 결과를 출력할 때 한글 모지바케 방지:

```
[ ] PowerShell 명령 첫 줄에 항상 prelude prepend:
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $OutputEncoding = [System.Text.Encoding]::UTF8;
[ ] 한글 포함 파일 읽기: Get-Content $path -Encoding UTF8 (생략 시 CP949 해석)
[ ] 한글 포함 파일 쓰기: Set-Content / Out-File -Encoding utf8
[ ] Select-String 검색 시 -Encoding UTF8 명시
```

**환경**: 한국어 Windows + VS Code + Claude Code + PowerShell 도구
**원인**: PowerShell 도구는 매 호출마다 새 프로세스 spawn — 신규 프로세스 기본 OutputEncoding = CP949 → UTF-8 파일을 CP949 로 해석하여 모지바케 ("자기완결" → "???먭린?꾧껐??")

→ 상세: `Doc/_dev_rules/21_TROUBLESHOOTING.md` §4

## 13. 확장 패턴 화면 — hooks/ + modals/ 검증 ⭐ (2026-05-22 신설 — DMF0020 작업 반영)

신규 화면이 다음 조건 중 1개 이상 충족하는 **확장 패턴** 일 때 추가 검증:

- Validation ≥ 20건
- Expression ≥ 5건
- 사업부 분기 (40/81/82) ≥ 6건
- As-Is POPUP ≥ 1개

```
[ ] hooks/ 서브폴더 분리 — useXxxValidation.ts + useXxxExpression.ts
    (단일 .tsx 파일 인라인 작성 금지)
[ ] 각 hook 메서드 JSDoc 첫 줄: /** #N  AS-IS: {파일명}.cs:LLLL  설명 */
[ ] 사업부 분기는 메서드명에 명시: editButtonForDivision40, editButtonForDivision81, editButtonForDivision82
    (case-switch 통합 금지)
[ ] components/modals/ 서브폴더 — As-Is POPUP 1개당 1 modal 컴포넌트
[ ] 각 Modal 의 sheetName 은 메인과 별도 (예: 'main' / 'exchangeRate' / 'priceBatchInput')
[ ] 각 Modal 의 tabId 는 메인 tabId 와 분리 (cache 격리)
[ ] modalState 는 store 의 modals: { open... } 통합 (개별 useState X)
[ ] {page-name}.constants.ts 에 DIVISION_CODE / GROUP_KEY_COLUMNS / FROZEN_COLUMNS / BUCKET_TYPE 등 도메인 상수 정의
[ ] 동적 컬럼 화면이면 fetchDynamicColumns 가 별도 메타 SP 호출 (커스텀 BTN_CD: SPREAD_TITLE_DATE 등)
[ ] 그룹 동시 선택 화면이면 GROUP_KEY_COLUMNS + groupKeyOf() + formatItem 적용
[ ] 3-tier 헤더 화면이면 hooks/useXxxExpression.ts 의 buildLargeSumHeader() 로 columnGroup 구성
```

→ 상세 룰: `05_SCREEN_TEMPLATE.md` §2.0.2, `09_WIJMO_VALIDATION_EXPRESSION.md` §3/§7, `12_GRID_COMMON.md` §6.2/§10/§11

## 14. 이관 패키지 (`_artifacts`) 작성 직후 검증 ⭐ (2026-05-22 신설)

DB / 서버 미연결 환경에서 클라우드 이관용 압축 패키지를 만들 때:

```
[ ] _{screen_id}_artifacts/ 폴더 명명 규약 준수 (룰 22 §2.1)
[ ] fe/ 안의 폴더 구조가 nscm-fe 상대 경로와 정확히 일치
    (features/{domain}/src/pages/{kebab-page}/ 그대로)
[ ] sql/ 안에 4-파일 세트 모두 포함 (.sql + _DBeaver.sql + _DBeaver_Verify.sql + _DBeaver_Diagnose.sql)
[ ] _README.md 작성 — §3 적용 순서 7-step 포함
[ ] _COMMON_FILES_GUIDE.md 작성 — 공통 4 파일 (route-paths / Router.tsx / procedures.d.ts / locales) patch
[ ] __asis-mapping__.md 가 FE 폴더 안에 포함 (룰 09 §3)
[ ] BE Java 코드 0건 (동적 호출만)
[ ] PKG_{SCREEN_ID} Oracle SP 0건 (별도 PR)
[ ] node_modules / .turbo / dist 미포함
[ ] 공통 파일 (ROUTE_PATHS 등) 직접 포함 X (가이드만)
```

압축 후 검증:
```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead('{path}.zip')
$zip.Entries | Select-Object FullName, Length | Format-Table -AutoSize
$zip.Dispose()
```

→ 상세 룰: `22_PACKAGE_ARTIFACTS.md`
