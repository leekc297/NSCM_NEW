# 카테고리 08 — admin 메타·배선 / Admin Meta & Generic Wiring

> **연다: 언제?** admin 메타 테이블(API_M/BTN_MPG_M/PROC_M/MNU_M/SHEET_COLUMNS/LOOKUP/CMBO/MSG_M) INSERT·UPDATE, generic call-proc 배선 시.
> **대원칙**: admin 메타 8 테이블 **AI 임의 생성 절대 금지** (#78 — anti-simplification 동급).

| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 78 | [ui-category-setup-no-arbitrary-data](../hooks/ui-category-setup-no-arbitrary-data.md) | ⭐⭐⭐ | 메타 8테이블 임의 INSERT/UPDATE/추측 금지 — 허용=사용자 명시/AS-IS 실데이터 복사/조회. PRE-WRITE 4점검 |
| 98 | [corp-meta-integrity-and-wiring](../hooks/corp-meta-integrity-and-wiring.md) | ⭐⭐ | INSERT 전 NOT NULL 전수(`desc` 실측 — ORA-01400) + **BE 무변경 generic 배선 3종 세트**(API_M+BTN_MPG_M+PROC_M) |
| 39 | [proc-meta-signature-match](../hooks/proc-meta-signature-match.md) | ⭐ | PROC_M 행/SORT_ORD = SP ALL_ARGUMENTS **positional 일치** |
| 100 | [get-zero-dup-invisible-diagnosis](../hooks/get-zero-dup-invisible-diagnosis.md) §① | ⭐⭐⭐ | 오류 없는 0행=PROC_M 순서 뒤틀림(silent) — 위치+이름 대조 SQL. COL_NM UPDATE 금지(PK) |
| 82 | [feature-button-meta-completeness](../hooks/feature-button-meta-completeness.md) | ⭐ | 기능 버튼 BTN_MPG 등록 완전성 |
| 84 | [sheet-columns-meta-completeness](../hooks/sheet-columns-meta-completeness.md) | ⭐ | SHEET_COLUMNS 완전성 + obsolete 정리 |
| 44 | [scmd-app-grant-mandatory](../hooks/scmd-app-grant-mandatory.md) | ⭐⭐ | 신규 SP/테이블 = SCMD_APP GRANT+SYNONYM 즉시 (-9994 방지) |
| 122 | [cloud-ui-db-object-fetch](../hooks/cloud-ui-db-object-fetch.md) | ⭐⭐ | (배포 축 — 카테고리 12 주소속) 클라우드 생성 UI 배선 메타 8테이블 = 클라우드 실측 추출 INSERT-only (수기 작성 금지 — #78 정합) |
| 91 | [sheet-name-asis-preserve-mandatory](../hooks/sheet-name-asis-preserve-mandatory.md) | ⭐⭐⭐ | SHEET_NAME=AS-IS 원본 보존(개명 금지) — FE SHEETS·SP·SHEET_COLUMNS·BTN_MPG.SHT_NM 5구간 일치 |
| 75 | [be-api-contract-ui](../hooks/be-api-contract-ui.md) | ⭐⭐ | BE API javadoc 계약 — callProc/combo/lookup/menu·column endpoint ↔ apiClient 매핑 |
| 66 | [ui-dynamic-property-management](../hooks/ui-dynamic-property-management.md) | ⭐⭐ | (master — 카테고리 02 참조) 동적 속성 3종 admin 데이터 확인·신규 등록 |

## 필수 지식 (사고 계보)
- **PROC_M 표준**: IN 행=`(COL_NM, DATA_TP_CD=VARCHAR 등, COL_TP_CD='IN')` / 커서=`('data','CURSOR','OUT')` / **result 행=`('result','PROC_RESULT','OUT')`** — `COL_TP_CD='PROC_RESULT'` 로 넣으면 makeProcedure 빈 슬롯→**전 SP PLS-00103** (DMF0044/0049 19행 사고 2026-07-30, 메모리 `feedback_proc_m_col_tp_cd_standard`)
- 감사컬럼 = **'admin'** 만 (claude ID 금지 — `feedback_meta_audit_column_admin_only`)
- 메타 INSERT 전 `desc TABLE_NAME` DDL 실측 의무 (`feedback_ddl_grep_before_sql`)

## Cross-ref
- TO-BE 정밀: `_tobe/12_metadata_sql.md` · 사내 적용 절차: 카테고리 12
- 메모리: `feedback_corp_meta_integrity_wiring` / `feedback_proc_meta_must_match_sp_signature` / `feedback_sheet_name_main_standard`(#91) / `feedback_api_m_diagnosis_by_api_id`
