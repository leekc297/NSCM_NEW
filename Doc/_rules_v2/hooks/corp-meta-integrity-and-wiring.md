# Hook #98 — corp-meta-integrity-and-wiring (사내 메타 INSERT 무결성 + LBL 할당 + generic 배선)

> **트리거**: 사내 DB 메타 작업 (corp 스크립트 / `SCM_ADM_MSG_M`·`SCM_ADM_PROC_M`·`SCM_ADM_API_M`·`SCM_ADM_MNU_BTN_MPG_M` INSERT / 신규 LBL / SP 호출 배선)
> **상태**: ⭐⭐ 필수 (사용자 명시 2026-06-28, SYS0011·SYS0012·SYS0013). 상위 = `anti-simplification`.
> **차단**: NOT NULL 필수컬럼 누락(ORA-01400) / LBL 코드 충돌 / PROC_M positional 불일치(PLS-00306).

---

## §1. 메타테이블 INSERT = NOT NULL 필수컬럼 전수 (ORA-01400 재발 방지)
INSERT/MERGE 전 `user_tab_columns WHERE nullable='N'` 로 필수컬럼 확인 후 **전부 포함**. 반복 사고 컬럼:
- **`SCM_ADM_MSG_M`**: `MSG_TP_CD`(='LBL' 등) + `USE_YN`(='Y') 누락 빈발 → ORA-01400 (SYS0011/0012 2회 발생).
- 공통: `CREATED_BY`/`CREATION_DATE`/`LAST_UPDATED_BY`/`LAST_UPDATE_DATE` (전 메타테이블 NOT NULL).
- DMF0020 사고 계보와 동일(컬럼 추측/NOT NULL 미검증). DDL 안 본 컬럼 추측 금지([[feedback_ddl_grep_before_sql]]).
- 멱등: `MERGE WHEN NOT MATCHED` 또는 `NOT EXISTS`.

## §1.1 ⭐ 감사컬럼 값 = `'admin'` 만 (claude 포함 ID 절대 금지) — 사용자 명시 2026-07-10
- `CREATED_BY` / `LAST_UPDATED_BY` 리터럴 = **반드시 `'admin'`**. `claude_dmf0074_fe`·`claude_sys0013_rebuild` 처럼 **claude 가 들어간 ID 금지** (AI 도구명이 운영 감사데이터에 남으면 안 됨).
- 작성 직후 grep 게이트: `grep -rnE "'claude" *.sql` **= 0 건** (post-write 의무).
- 이미 적재된 잔재 교정 = `_artifacts/_deploy_packages/_shared_cmbo/FIX_created_by_claude_to_admin.sql` (전 메타테이블 `WHERE CREATED_BY LIKE 'claude%' OR LAST_UPDATED_BY LIKE 'claude%' → 'admin'`, 멱등). 사내 147행 교정 완료(2026-07-10) + 클라우드 폴더 `98_FIX_*` 동봉.
- ⚠️ SP 본문 변경이력 주석의 "Claude" 는 코드 주석 → 대상 아님(감사 컬럼 리터럴만). ([[feedback_meta_audit_column_admin_only]])

## §2. LBL 코드 할당 정책 (명칭 = 동일명칭 재사용 / 없으면 신규)
1. **동일 명칭이 권위 원천(`SCM_ADM_MSG_M`)에 있으면 그 코드 재사용** (예 User ID(Name)=LBL00339).
2. 없으면 **권위 DB 최대 LBL 이후** 신규 — ⚠️ **FE `public/locales/*.json` 의 stray 코드(DB 미등록)도 회피**. DB max=658 인데 FE에 659~670 stray 점유 → 신규는 **DB·FE 양쪽 충돌 없는 첫 번호**(671+)부터.
3. 신규 = **FE locales 3종(KO=EN, CN 번역) + corp `SCM_ADM_MSG_M` 등록 스크립트** 동반(§1 NOT NULL 준수). KO=EN([[feedback_i18n_ko_en_alignment]]).
- ⚠️ `locales/*.json` 은 generated(원천 message DB)이나 커밋본이 런타임 SSOT → DB 맞아도 stray 가능. 사례: 22/23 register 스크립트.

## §3. BE(Java) 무변경 SP 호출 = generic call-proc 메타 배선
기존 SP 를 화면에서 호출하려면 BE Java 수정 없이 **메타 3건만** 추가(BE 의 `/{menuId}/{sht}/{btn}/call-proc` 가 메타로 라우팅):
1. `SCM_ADM_API_M`: `API_xxx` (API_TP_CD='POST', **API_URL=proc명** — `PKG.PROC` 또는 **standalone proc명** 둘 다 가능).
2. `SCM_ADM_MNU_BTN_MPG_M`: (MNU_ID, SHT_NM, BTN_CD) → API_ID.
3. `SCM_ADM_PROC_M`(PROC_NM=proc): **COL_NM=camelCase(=FE payload key)**, **SORT_ORD=SP positional 정확 일치**, IN=VARCHAR/CLOB·OUT=CURSOR. ([[feedback_proc_meta_must_match_sp_signature]])
- FE: `apiClient.post('/${MENU_ID}/${sht}/${btn}/call-proc', {camelKey:...})`. 단건 SP 는 변경분만큼 루프 호출.
- 사례: SYS0013 Role 저장 — standalone `SYS0013_SAVE_USER_GROUP` 를 `28_sys0013_role_save_wiring.py`(API_M+BTN_MPG_M+PROC_M)로 배선, BE/SP 무변경.
- 신규 SP 작성 전 기존 SP/메타 재사용 우선([[feedback_be_infrastructure_reuse]], BE 변경 금지 [[feedback_be_no_modification_rule]]).

## §4. SHEET_NAME 대소문자 / AS-IS 잔존 sheet
- 조회 proc `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` = `WHERE SHEET_NAME = :sheetNm`(case-sensitive). FE는 소문자/camel enum만 전송 → **AS-IS 대문자(snake)·구명칭 sheet 행은 dead data → 정리 가능**([[feedback_sheet_name_main_standard]]). 정리 시 CTAS 백업 후 DELETE.

## §5. 자기 점검
```
✅ INSERT 대상 테이블 NOT NULL 컬럼 전수 포함? (특히 MSG_TP_CD/USE_YN)
✅ CREATED_BY/LAST_UPDATED_BY = 'admin' 만? grep "'claude" = 0 건? (§1.1)
✅ 신규 LBL = 동일명칭 재사용? 아니면 DB·FE 양쪽 max+1?
✅ PROC_M COL_NM=camelCase / SORT_ORD=SP positional 일치?
✅ corp 변경 = 멱등(MERGE/NOT EXISTS) + 적용 후 count 검증?
✅ BE Java 무변경(메타 배선) / SP 무변경(기존 재사용)?
```
- cross-ref: `column-align-code-standard`(#96) · `proc-meta-signature-match` · `sheet-columns-binding-match` · `feature-button-meta-completeness` · **§6 값 단언 표준**

---

## §6. ⭐⭐ SHEET_COLUMNS 메타 "값 단언" 표준 (2026-08-06 SYS0017 감사 계기 신설)

> **카운트는 값 검증을 대체할 수 없다** — "SHEET_COLUMNS 32행" 은 32행 전부가 잘못된 값이어도 통과한다.
> SYS0017 실사고: ①전 32행 `INPUT_TP_CD='IM'`(읽기전용 컬럼까지) → 상단 grid 편집 불가 ②콤보 CTRL `'C'`(비표준) →
> dataMap 자동 배선 불발·코드 원문 표시. **둘 다 헤더 주석에 "사양"처럼 기재되어 건수 검토를 통과**했다.
> 등록·검증 SQL 은 아래 3종 **값 단언(분포·화이트리스트)** 이어야 한다. (수평 감사: CTRL 'S' 61행/4화면 잔존 — SYS0013 AGGREGATE 실기능 파손)

### §6.1 CTRL 화이트리스트 단언 (0행 기대)

허용값 = FE `packages/foundation/src/constants/column-config.ts` 의 `CELL_CONTROL_TYPE` 실제 열거(전부 `FP*`):
`FPModal / FPComboBox / FPButton / FPDate / FPDateMonth / FPDateTime / FPDateText / FPCheckBox / FPNumberText / FPTextBox / FPPercent / FPText / FPNumber / FPMultiLineTextBox`. 이 밖의 값(**`'C'`/`'S'` 등 AS-IS 한 글자 코드**)은 FE 가 인식하지 못해 **silent 미동작**.

```sql
-- 검출 기대 0행 — 'C'/'S' 등 비표준 검출 시 즉시 교정 (NULL=컨트롤 없음 은 허용)
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '{ID}'
   AND CELL_CONTROL_OBJECT_TYPE_CODE IS NOT NULL
   AND CELL_CONTROL_OBJECT_TYPE_CODE NOT IN
       ('FPModal','FPComboBox','FPButton','FPDate','FPDateMonth','FPDateTime','FPDateText',
        'FPCheckBox','FPNumberText','FPTextBox','FPPercent','FPText','FPNumber','FPMultiLineTextBox');
```

### §6.2 INPUT_TP_CD 분포 대사 (편집 화면 전면 'IM' 금지)

편집 기능이 있는 화면의 SHEET_COLUMNS 를 **단일값 일괄('IM' 전면 등)로 등록 금지** — 컬럼별 편집 여부는
**화면설계서 5.GRID "편집 규칙" 컬럼과 1:1 대사** 의무 (S=표시전용 / O·M=편집 / IM·IO=Insert행 한정 — `column-lookup-meta-standard` 5종).

```sql
-- 분포를 눈으로 단언 — 편집 화면인데 단일 코드 1종이면 오등록 의심 (SYS0017: 전 32행 IM → 목표 main IM3/M2/O4/S2 ...)
SELECT SHEET_NAME, INPUT_TP_CD, COUNT(*) CNT
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '{ID}'
 GROUP BY SHEET_NAME, INPUT_TP_CD ORDER BY 1, 2;
```

### §6.2-T ⭐ 실행 hook 자동화 (2026-08-07 신설 — `check-meta-sql.ps1`)

본 §6.1/§6.2 의 **작성 시점 자동 검사**가 실행 hook 으로 승격되었다 — `.claude/hooks/check-meta-sql.ps1`
(PostToolUse Write/Edit, `.claude/settings.json` 5번째 등록):

| 검사 | 판정 |
|---|---|
| M-A CTRL 화이트리스트(column-config.ts `CELL_CONTROL_TYPE` 실값 파싱 + `'S'` hidden 허용 + NULL) 밖 값 — `'C'` 등 | **BLOCK (exit 2)** |
| M-B `INPUT_TP_CD` 미정의 코드 (S/O/M/IO/IM 밖 — `'MI'` typo 등) | **BLOCK (exit 2)** |
| M-C INSERT 세트 전 행 `'IM'` 단일 코드 (전면 잠금 의심 — 파일 주석 `READONLY-SHEET` 명시 시 통과) | WARN (exit 1) |

- INSERT 는 **컬럼 목록 positional 매핑**으로 판정 (`HORIZONTAL_ALIGN_CODE='C'` 는 정상 — naive grep 금지). UPDATE 는 SET 절만 판정(WHERE 의 구값 참조는 정상).
- 실측 검증(2026-08-07): SYS0017 7/29 원본 `03_sheet_columns.sql` → CTRL `'C'` 8행 BLOCK + 전면 IM 32행 WARN / 8/6 fix SQL → PASS.
- DB 적용 후 값 단언(§6.1/§6.2 SQL)은 여전히 별도 의무 — hook 은 SQL 파일 작성 시점 방어선.

### §6.3 원칙: 검증 = 카운트 아닌 **값 단언**

- 정본 = `_artifacts/_deploy_packages/SYS0017_MAILSETUP_PATCH_20260806/00_PRECHECK.sql` **[B] 섹션 형식**: [B-1] CTRL 코드 단언(`CTRL_C=0 & FPComboBox=8` 기대) + [B-2] INPUT_TP_CD 분포 단언(시트별 목표 분포를 PROMPT 주석으로 명기) — **기대값을 스크립트에 박아 사람이 판독**.
- 헤더 주석의 "사양" 기재는 검증이 아니다 (주석은 준수의 증거가 아니다 — 감사 교훈 3).
- 자기 점검(§5)의 "적용 후 count 검증" 은 본 §6 값 단언 **후행 보조**로 격하 — count 만으로 PASS 금지.

## §7. 신규 Label/Message 4단 의무 (사용자 명시 2026-07-03 — 누락 0)

> 신규 LBL/MSG 를 FE 에 추가하는 순간, 아래 4단이 **전부** 같은 작업 안에서 완료되어야 한다.
> 하나라도 빠지면 미완 — "json 만 추가" 는 화면에 fallback(`_...`) 노출 + 클라우드 미표시 사고.

| 단계 | 의무 | 근거 사고 |
|---|---|---|
| 1 | **채번 = 사내 권위 DB 실측** — `SELECT MAX(MSG_ID) FROM SCM_ADM_MSG_M WHERE MSG_TP_CD='LBL'(/'MSG')` 를 **적용 직전** 실행해 max+1. ⚠ locales json 의 max 기준 금지 — json 은 DB 와 언싱크 | 2026-07-03 DMF0003 PR: json max(727) 기준 채번 → LBL00728~739 가 사내 타 화면(6-29 등록 'Result'/'Execute' 등) 선점분과 **충돌** → 740~751 재채번 |
| 2 | **locales json 3종**(KO/EN/CN) 동시 추가 | — |
| 3 | **사내 SCM_ADM_MSG_M 등록** (3 LANG × 키, 멱등 NOT EXISTS, NOT NULL 전수 §1) — 등록 SQL 을 이관 패키지 `02_META/` 에 파일로 보존 | 미등록 시 사내 런타임 fallback 노출 |
| 4 | **클라우드 이관 패키지 포함** — 해당 화면 배포 패키지에 i18n 등록 SQL + locales 변경 파일 명시. README 이관 순서에 기재 | 사내만 등록하고 이관 누락 시 클라우드 fallback |

- 멱등 skip-if-exists 는 **충돌 감지가 아니다** — 기존재 키를 skip 하면 FE 는 신규 의미, DB 는 구 의미로 갈라진다. 적용 스크립트는 `max+1 ≤ 신규 시작번호` assert 로 **채번 충돌 시 중단**해야 한다.
- 텍스트 interpolation 은 react-i18next `{{var}}` 표기 — DB 등록 텍스트도 동일 표기로 저장.

## §8. SHEETS 시트 배선 완결성 (2026-07-03 신설 — DMF0003 sspCompare 미배선 사고)

> FE 의 `SHEETS` enum 에 시트를 추가(또는 기존 시트를 실사용)하는 순간, BE 배선 2종이 없으면
> **컴파일·타입 전부 통과하지만 런타임 BE 호출이 실패**한다 (-9994 류). 화면 완료 선언 전 전수 대조 의무.

| 점검 | 방법 |
|---|---|
| 1. **FE 실사용 여부 먼저 판정** | `useTabProcQuery/useProcMutation` 에서 해당 sheetName 을 실제 호출하는가 grep — **상수 정의만 있고 미호출이면 등록 불요**로 정직 판정 (DMF0003 measureCount 사례: 정의만 존재 → 등록 불요 정정) |
| 2. **API_M** | API_ID = `{MENU_ID}_{sheetName}_{BTN}` 규약 (예: `DMF0003_sspCompare_SEARCH`) — `SELECT ... WHERE API_ID = '...'` **정확 일치** 조회 (URL LIKE 검사 금지, #100 §5) |
| 3. **PROC_M** | SP positional 실측(`ALL_ARGUMENTS` ORDER BY POSITION) → IN = FE payload 키(camelCase) 1:1 + OUT 커서(COL_NM = FE `RESPONSE_SET` 키, 예 `o_rc1`, DATA_TP_CD='CURSOR') |
| 4. **SP 왕복** | 등록 후 대표 파라미터로 callproc — 커서 컬럼이 FE 컬럼 정의와 대응하는지 확인 |

- 사고: DMF0003 SSP 비교(더블클릭)가 FE 골격 완성 상태로 **API_M/PROC_M 0행** — 분석서 작성 중 전수 대조로 발견. 신규 시트 배선은 화면 작업 완료 게이트(#54 screen-completion-gate)의 점검 대상.

---

## §9. ⭐⭐⭐ 시트 메타 이관 SQL = MERGE INTO — DELETE 절대 금지 (2026-08-07 사용자 확정)

> 사용자 지시 원문: "Meta SheetColumn 이관 sql 생성 시 Program_id, Sheet_name 기준으로 Delete 하는 문장 삭제하고 Merge into 로 이관 sql 생성 요청. Delete 하면서 기존의 데이터가 다 사라져서 문제가 발생한 케이스가 많으므로, 절대 Delete 는 하지 않도록 요청."

1. **대상**: `SCM_MST_SHEET_COLUMNS`·`SCM_MST_SHEET_MEASURE` 등 시트 메타 이관/동기 SQL 전부.
2. ⛔ **`DELETE ... WHERE PROGRAM_ID=... [AND SHEET_NAME=...]` 문장 절대 금지** — 대상 DB(클라우드 등)에만 존재하는 행·운영 중 갱신분까지 소실되는 실사고 다수.
3. **정본 = `MERGE INTO`** (PK = PROGRAM_ID+SHEET_NAME+COLUMN_NAME):
   - `WHEN MATCHED THEN UPDATE` — 비PK 속성 전체를 원천 실측 literal 로 동기(CREATED_BY/CREATION_DATE 는 보존, LAST_UPDATED_BY='admin'+SYSDATE 갱신)
   - `WHEN NOT MATCHED THEN INSERT` — NOT NULL 전수(§1) 준수
   - 행 제거가 정말 필요한 경우(폐기 컬럼) = `VALID_YN='N'` UPDATE 로 무효화 (물리 DELETE 금지), 예외는 사용자 명시 승인 시만.
4. **경계**: `SCM_ADM_PROC_M` positional 재정렬은 기존 관례(해당 PROC_NM 한정 DELETE→INSERT + 전량 literal 동봉 = 소실 0) 유지 — 단 PROC_NM 보다 넓은 WHERE 금지.
5. 선례: `DMF0082_UICATEGORY_20260807_1418/04_META_SHEET_COLUMNS.sql` (MERGE 재생성 정본).
