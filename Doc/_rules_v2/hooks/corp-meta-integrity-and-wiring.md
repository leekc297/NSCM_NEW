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
- 조회 proc `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` = `WHERE SHEET_NAME = :sheetNm`(case-sensitive). FE는 등록명 그대로 전송([[feedback_sheet_name_main_standard]]).
- ⛔ **2026-08-10 사용자 확정 — `SHEET_NAME` 은 절대 변경 불가.** 구명칭·대소문자 상이 행이라도
  **rename·DELETE 하지 않는다.** 종전 이 항목에 있던 "dead data 정리 가능 / CTAS 백업 후 DELETE" 지침은 **폐기**한다.
  화면이 특정 시트를 안 쓰면 **행을 지우는 대신 화면이 올바른 SHEET_NAME 을 보내도록** 고친다.
  (행 무효화가 정말 필요하면 §9-3 의 `VALID_YN='N'` UPDATE — 물리 DELETE 금지.)

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
| 1 | **채번 = 사내 권위 DB 실측 + ⭐1000 대역 규칙** — `SELECT MAX(MSG_ID) FROM SCM_ADM_MSG_M WHERE MSG_TP_CD='LBL'(/'MSG') AND MSG_ID >= 'LBL01001'(/'MSG01001')` 를 **적용 직전** 실행해 max+1. 대역이 비어 있으면 **`LBL01001` / `MSG01001` 부터**. ⚠ locales json 의 max 기준 금지 — json 은 DB 와 언싱크 | 2026-07-03 DMF0003 PR: json max(727) 기준 채번 → LBL00728~739 가 사내 타 화면 선점분과 **충돌** → 740~751 재채번 / 2026-08-14: 전 대역 max+1 이 **클라우드에서 사용자가 신규 생성한 코드를 재사용** (아래 §7.1) |
| 2 | **locales json 3종**(KO/EN/CN) 동시 추가 | — |
| 3 | **사내 SCM_ADM_MSG_M 등록** (3 LANG × 키, 멱등 NOT EXISTS, NOT NULL 전수 §1) — 등록 SQL 을 이관 패키지 `02_META/` 에 파일로 보존 | 미등록 시 사내 런타임 fallback 노출 |
| 4 | **클라우드 이관 패키지 포함** — 해당 화면 배포 패키지에 i18n 등록 SQL + locales 변경 파일 명시. README 이관 순서에 기재 | 사내만 등록하고 이관 누락 시 클라우드 fallback |

- 멱등 skip-if-exists 는 **충돌 감지가 아니다** — 기존재 키를 skip 하면 FE 는 신규 의미, DB 는 구 의미로 갈라진다. 적용 스크립트는 `max+1 ≤ 신규 시작번호` assert 로 **채번 충돌 시 중단**해야 한다.
- 텍스트 interpolation 은 react-i18next `{{var}}` 표기 — DB 등록 텍스트도 동일 표기로 저장.

### §7.1 ⭐ Claude 채번 대역 = **01001 이상 전용** (사용자 확정 2026-08-14 — 절대 준수)

> **적용 시점 = "신규 채번을 실제로 하는 경우"에 한한다.** (사용자 확정 2026-08-14)

**Step 0 — 기존 코드 재사용 판정이 항상 먼저다.**

| 분기 | 조건 | 조치 | 메타 INSERT(이관 SQL) |
|---|---|---|---|
| **(a) 재사용** | 같은 명칭·문구가 사내 `SCM_ADM_MSG_M` 에 이미 존재 | **그 코드를 그대로 사용** (새로 따지 말 것) | ❌ **불요** — 이미 원장·클라우드에 있는 코드다 |
| **(b) 신규 채번** | 같은 명칭·문구가 없음 | 아래 1000 대역 규칙으로 채번 | ✅ **필요** — 이 신규분만 INSERT 문으로 작성해 이관 패키지에 동봉 |

> ⇒ 이관 패키지의 i18n 메타 INSERT 대상 = **(b) 신규 채번분 only**. (a) 재사용분을 INSERT 에 섞으면
> 기존 원장과 중복·의미 충돌을 만든다. 재사용분은 FE 참조만 하면 끝이다.
> 문구 대조 절차(정규화 일치 판정)는 hook #114 §3 Step 3 이 단일 출처.

**Step 1 — (b) 로 판정된 경우에만 적용하는 채번 규칙:**

> **Claude(Code) 가 신규 생성하는 LBL/MSG 는 예외 없이 `LBL01001` / `MSG01001` 이상에서만 채번한다.**

| # | 규칙 |
|---:|---|
| 1 | 채번식 = `MAX(코드) + 1` 을 **1000 대역 안에서만** 구한다 — `WHERE MSG_ID >= 'LBL01001'`(/`'MSG01001'`). 대역이 비어 있으면 시작값이 `LBL01001` / `MSG01001`. |
| 2 | ❌ **1000 미만의 빈 번호(공번)를 메우지 말 것.** 앞번호가 비어 있어도 건너뛴다. |
| 3 | ❌ 전 대역 `MAX(...)+1` 금지 (종전 방식). |
| 4 | 사내 DB 만 보고 채번하되, **1000 대역은 Claude 전용 예약 구간**이므로 사내/클라우드 어느 쪽이 앞서 있어도 충돌하지 않는다. |

**근거 사고 (2026-08-14 사용자 리포트)**: 사용자가 **클라우드에서 직접 신규 생성한 LBL/MSG 코드**는 사내 DB 에
아직 없다. 이 상태에서 전 대역 `MAX+1` 로 채번하면 Claude 가 **그 코드와 같은 번호를 다시 발급**해
"클라우드에서 사용자가 만든 코드를 Claude 가 재사용" 하는 현상이 발생했다(의미 2중화 → 전 화면 오염).
1000 미만은 **사람(운영자)·클라우드 신규 생성 구간**, 1000 이상은 **Claude 채번 구간**으로 분리해 원천 차단한다.

```sql
-- 채번 실측 쿼리 (적용 직전 실행 — LBL / MSG 각각. 접두 3자 + 5자리라 문자열 비교로 정렬이 성립)
-- ⚠ 판정은 MSG_TP_CD 가 아니라 **MSG_ID 접두**로 한다 — MSG_TP_CD='LBL' 인데 MSG_ID 가 'MSG…' 인
--    오염행이 실재한다(사내 실측 2026-08-14).
SELECT NVL(MAX(MSG_ID), 'LBL01000') AS CUR_MAX
FROM   SCM_MGR.SCM_ADM_MSG_M
WHERE  MSG_ID LIKE 'LBL%' AND MSG_ID >= 'LBL01001';   -- MSG 는 'MSG%' / 'MSG01001'
-- → 다음 채번 = 'LBL' || LPAD(TO_NUMBER(SUBSTR(CUR_MAX, 4)) + 1, 5, '0')
```

**사내 실측 기준선 (2026-08-14)**: 전 대역 max = `LBL00862` / `MSG00718`, **1000 대역은 비어 있음** →
다음 Claude 채번은 **`LBL01001`** · **`MSG01001`** 부터 시작한다.

> 관련: `msg-id-asis-tobe-conversion.md`(#114 §3 Step 3-(b)) / `i18n-ko-en-alignment.md`(#44) /
> 메모리 `feedback_i18n_new_code_three_point_sync`(3점 동시 반영).

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

## §9. ⭐⭐⭐ 시트 메타 **클라우드 이관** = SHEET_NAME 단위 삭제 후 **전체 재적재** (⭐ 2026-08-12 사용자 역전 확정)

> **정책 역전 이력** (최신이 정본):
> - 2026-08-07: "DELETE 금지 — MERGE INTO 로" (일부 삭제로 데이터 소실 사고 계보)
> - 2026-08-10: "SHEET_NAME 기준 일괄 삭제 금지" 재확정
> - **2026-08-12 (현행 정본)**: "SHEET_COLUMN 클라우드 이관 시 **SHEET_NAME 기준으로 삭제하고 전체 이관**하는 것으로 RULE 변경.
>   그리고 **SHEET_NAME 은 현재의 NAME 을 변경하면 안 된다**." — 부분 MERGE(UPSERT)가 남기는 잔존 구행·논리키 어긋남이
>   시트 단위 완전 교체보다 위험하다는 운영 확정. 07-08-07 계보의 "소실" 사고는 **삭제 범위 ≠ 삽입 범위**가 원인이었으므로,
>   아래 2번 "전량 동봉" 불변식이 그 재발을 막는다(PROC_M 재정렬 관례와 동일 구조).

1. **대상**: `SCM_MST_SHEET_COLUMNS`·`SCM_MST_SHEET_MEASURE` 클라우드 이관/동기 SQL.
2. **정본 방식 = 시트 단위 완전 교체** — 반드시 다음 불변식으로 생성한다:
   - `DELETE FROM ... WHERE SHEET_NAME = '{시트}'` → 이어서 그 시트의 **사내 원천 전 행 INSERT**.
   - ⭐ **삭제 범위 = 삽입 범위 (소실 0 불변식)**: DELETE 가 SHEET_NAME 전체(타 PROGRAM_ID 포함)를 지우므로,
     INSERT 도 **그 SHEET_NAME 의 전 행 — 공유 시트면 타 PROGRAM_ID 행까지 전량 동봉**해야 한다
     (예: 'Sales Plan' 은 DMF0021+DMF1007 공유 — DMF0021 행만 동봉하면 DMF1007 컬럼 소실 = 사고).
   - INSERT 는 전 컬럼 **사내 실측 literal**(추측 금지 — anti-simplification §1). 감사 4컬럼 = 'admin'/SYSDATE.
   - DELETE~INSERT~COMMIT 은 **한 파일·한 트랜잭션**으로(중간 실행 중단 = 시트 공백 상태 방지, 말미 행수 VERIFY 동봉).
3. ⛔ **`SHEET_NAME` 값 자체를 바꾸는 UPDATE·개명 절대 금지** (2026-08-10 확정 유지·강화) — FE/SP/TITLESET 이
   SHEET_NAME 문자열로 결합돼 있어 개명 = 전 소비처 파손. 시트명 변형(공백/대소문자) 신설도 금지
   (feedback_titleset_sheetname_variant_measure_dup 계보).
4. **경계**: `SCM_ADM_PROC_M` positional 재정렬 관례(해당 PROC_NM 한정 DELETE→INSERT + 전량 동봉) 유지.
   **사내 내부** 시트 메타 정합(이관 아닌 보수)은 종전대로 MERGE/UPDATE 우선 — 본 §9 는 **클라우드 이관 SQL** 에 적용.
5. 선례: `DMF0021_CLOUD_20260812/06_SHEET_META_SYNC.sql`·`DMF0082_CLOUD_20260812/06_SHEET_META_SYNC.sql` (v4 — 2026-08-12 재생성 정본).
