# DMF0043 / DMF0043_01 PKG/SP 보완 + 조회 진단 보고 — 2026-06-10

## 진행 단계
- ✅ Phase 0~7: Python apply.py wrapper + 진단 + INVALID fix + dump v_sql_text 분석
- ✅ Phase 8: SP body ORDER BY patch (line 187 + line 193)
- ⚠️ Phase 9 (Data Mapping): 데이터 source 매핑 이슈 발견 — 사용자 결정 의무

## 핵심 fix (Phase 8 — DMF0043_GET_CONTRIBUTION_SALES_LIST)

### 발견된 사고 (2단계)

**1차 (이미 fix 완료)**: `DMF0043_GET_CONTRIBUTE_MAIN_DATA` INVALID
- 원인: `NVL(A.REPORT_GROUP3, '')` × 5건 — 사내 `SCM_MST_SITE_ITEM.REPORT_GROUP3` 컬럼 미존재
- Fix: `_artifacts/_apply_corporate/05_dmf0043_main_data_report_group3_fix.py` → `NULL`/`''` 대체 → STATUS = VALID
- 백업: `_diagnostics/DMF0043_GET_CONTRIBUTE_MAIN_DATA_before_20260610_202637.sql`

**2차 (이번 작업)**: `DMF0043_GET_CONTRIBUTION_SALES_LIST` silent fallback 활성 → 데이터 0건
- 진단 흐름:
  1. SP 호출 → `main: total 0 rows, cols=['DUMMY']` (silent fallback OPEN cursor)
  2. silent fallback → RAISE 임시 변경 → 실 ORA-* 노출: `ORA-01003: no statement parsed`
  3. v_sql_text dump → 정밀 분석 → ORA-00904 "A"."DM_BIZ_TYPE": invalid identifier
  4. SQL 부분별 isolate test → **UNION ALL 결과 ORDER BY 의 `A.컬럼명` 직접 참조가 원인**
- 근본 원인: SP body `v_orderby` 동적 SQL template
  - Line 187: `v_orderby := ' ORDER BY A.' || v_col_name;` (첫 컬럼)
  - Line 193: `v_orderby := v_orderby || ', A.' || v_col_name;` (후속 컬럼)
- Fix (2건 patch):
  - Line 187: `' ORDER BY A.'` → `' ORDER BY '`
  - Line 193: `', A.'` → `', '`
- Python script: `23_fix_orderby.py` + `25_fix_orderby_line193.py`
- 백업: `_diagnostics/DMF0043_GET_CONTRIBUTION_SALES_LIST_before_*.sql` (총 3건)
- 결과: STATUS = VALID + SP 호출 시 main cursor 정상 컬럼 반환 (DUMMY 아님)

## ⚠️ Phase 9: 데이터 매핑 이슈 (사용자 결정 의무)

### 발견
SP 가 정상 동작하나 매칭 row 0:

| 테이블 | VERSION_NO 패턴 |
|---|---|
| `DM_MDF_VERSION` (Year 콤보 source) | `R_B_/R_S_/REPOR_` (To-Be Report Business/Sales) |
| `DM_PLN_SALES_PLAN_C` (실 데이터 source) | `SP_W_/SP_D_` (As-Is Sales Plan Weekly/Daily) |

`DM_MDF_VERSION.ORI_VERSION_NO` chain: `R_B_xxx_C → R_B_xxx → BP_M_xxx` — 그러나 `DM_PLN_SALES_PLAN_C` 의 `SP_W_/SP_D_` 와 직접 매칭 없음.

### SP body 의 분기
- Line 264: `IF p_version_no LIKE 'BP%' THEN`
- FE 가 보내는 `R_B_xxx_C` 패턴은 분기 외 — 다른 분기로 들어가나 매칭 0

### 옵션
| 옵션 | 동작 | 의무 |
|---|---|---|
| A | DM_PLN_SALES_PLAN_C 에 `BP_M_xxx`/`R_B_xxx` 패턴 데이터 적재 (사내 DBA 협업) | DBA |
| B | DM_MDF_VERSION 의 ORI chain 을 `SP_W_xxx` 로 보강 (마스터 데이터 수정) | 사내 DBA |
| C | SP body 의 매핑 로직 추가 — `R_B_*` 패턴 시 ORI chain follow + 최종 `SP_*` 패턴 매칭 | SP body 수정 |
| D | FE Year/Version 콤보를 `DM_PLN_SALES_PLAN_C` 의 VERSION_NO (`SP_W_xxx`) 로 변경 | FE 수정 |

## 검증된 사실

| 카테고리 | 결과 |
|---|---|
| **사용자 권한** | minyonglee1 = ADMIN/DM ADMIN/DM Viewer/GUEST 4 그룹 — 권한 충분 |
| **Division 권한** | Division 40/81/81_HD/HG/HM/82 — 풍부 |
| **DMF0043 메뉴 권한** | ADMIN + DM ADMIN — OK |
| **메타** | API 10 / PROC 70 / BTN 16 / SHEET 28 — 정상 |
| **마스터 데이터** | DM_PLN_SALES_PLAN_C Div40 = **1,296,935 row** (SP_W_*) — 풍부 |
| **CONTRIBUTE_RATIO** | MST 26K / DTL 1.5M / VERSION 396 — 풍부 |
| **SP STATUS** | DMF0043 11 SP 모두 VALID |
| **SP 호출 동작** | callproc OK + main cursor 정상 컬럼 반환 |

## 작성 파일

| 경로 | 역할 |
|---|---|
| `_artifacts/_apply_corporate/apply.py` | Python oracledb wrapper |
| `_artifacts/_apply_corporate/05_dmf0043_main_data_report_group3_fix.py` | DMF0043_GET_CONTRIBUTE_MAIN_DATA REPORT_GROUP3 fix |
| `_artifacts/_apply_corporate/15_diagnose_silent_fallback.py` | silent fallback → RAISE 진단 (자동 복원) |
| `_artifacts/_apply_corporate/16_dump_vsql.py` | v_sql_text dump (DBMS_OUTPUT 캡쳐) |
| `_artifacts/_apply_corporate/19~21_isolate_test.py` | SQL 부분별 parse test |
| `_artifacts/_apply_corporate/23_fix_orderby.py` | Line 187 ORDER BY patch |
| `_artifacts/_apply_corporate/25_fix_orderby_line193.py` | Line 193 ORDER BY patch + 호출 test |
| `_artifacts/_apply_corporate/26_test_multi_conditions.py` | 5 추천 조합 test |
| `_artifacts/_apply_corporate/03/09/10/11/12/13/17/18/22/24/27/28/29*.sql` | 진단 SELECT |
| `_artifacts/_diagnostics/DMF0043_*_before_*.sql` | USER_SOURCE 백업 (사고 시 복원) |
| `_artifacts/_diagnostics/DMF0043_vsql_dumped.sql` | 동적 SQL dump (24K) |

## 사용자 검증 안내

### 즉시 검증 (BE/FE 변경 불필요)
1. F12 DevTools → Application → Clear site data → 재로그인
2. DMF0043 (Contribute Main) 진입
3. **Division 40 / Year 콤보 선택** → 조회 클릭
4. Grid 빈 표시 (정상 — Phase 9 매핑 이슈)
5. BE 로그 `ORA-/PLS-` 0건 확인 — SP fix OK

### 다음 작업 결정 필요
- Phase 9 옵션 A/B/C/D 선택
- 데이터 매핑 보강 또는 SP body 매핑 로직 수정

## 잔존 작업

- TUNING 5 파일 (LOCAL_FIX/CLOUD_FIX/BODY_PATCH/VERIFY) — sqlplus 토큰 호환 issue (apply.py 한계)
- DMF0043_01 (Contribute View) 의 동일 ORDER BY 패턴 확인 — DMF0043 와 SP 공유
- 메모리 갱신: `feedback_corporate_schema_8_diffs.md` 의 9번째 known issue (REPORT_GROUP3 컬럼 미존재) + 10번째 (UNION ALL ORDER BY 의 `A.` prefix 문제) 추가 권장
