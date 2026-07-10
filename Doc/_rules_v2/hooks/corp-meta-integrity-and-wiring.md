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
- cross-ref: `column-align-code-standard`(#96) · `proc-meta-signature-match` · `sheet-columns-binding-match` · `feature-button-meta-completeness`

---

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
