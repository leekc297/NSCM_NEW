# DMF0044·DMF0049 개발본 잔존 제거 `[E20261006-ASISPARITY]` — 사내 ZIOUI1 실행 작업 대조표

대상: asis_delta_20261002 시트 `14_대상_대상제외_확정` — "DMF0044 개발본 잔존"(4블록) · "DMF0049 개발본 잔존"(2블록).

| 시각 (2026-10-06) | 계정 | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|---|
| 15:37 | SCM_MGR | 적용 전 원문 조회·백업 (조회 전용) | `PKG_DMF0044` BODY (LAST_DDL 10-01 10:18:26) · `PKG_DMF0049` BODY (10-01 12:33:17) | [00_BACKUP_PKG_DMF0044_BODY.sql](00_BACKUP_PKG_DMF0044_BODY.sql) · [00_BACKUP_PKG_DMF0049_BODY.sql](00_BACKUP_PKG_DMF0049_BODY.sql) |
| 15:43 | SCM_MGR | 검증 전용 복제 패키지 4개 생성 (SPEC+BODY) | `PKG_DMF0044_TB/_TA` · `PKG_DMF0049_TB/_TA` | `python t01_test.py clone` |
| 15:50~16:16 | SCM_MGR | 수정 전/후 비교 테스트 (호출마다 ROLLBACK — 원장 무변경) | 복제 패키지 | `python t01_test.py t44` · `t49` → [_t44.log](_t44.log) · [_t49.log](_t49.log) |
| 16:17:43 | SCM_MGR | **PKG BODY 적용** (FRESH-GATE 통과 · VALID · ERR 0 · 적용본 == DB 원문) | `PKG_DMF0044` BODY | [01_PKG_DMF0044_BODY.sql](01_PKG_DMF0044_BODY.sql) (`python build_apply.py apply`) |
| 16:17:44 | SCM_MGR | **PKG BODY 적용** (〃) | `PKG_DMF0049` BODY | [01_PKG_DMF0049_BODY.sql](01_PKG_DMF0049_BODY.sql) (〃) |
| 16:18 | SCM_MGR | 적용 후 검증 (실제 패키지 원문 == 시험한 복제 원문 · 검증 반환 경로 3건 호출) | 실제 패키지 | `python t01_test.py verify` → `_test_verify.json` |
| 16:19 | SCM_MGR | 복제 패키지 4개 삭제 (잔존 0) | `PKG_DMF0044_TB/_TA` · `PKG_DMF0049_TB/_TA` | `python t01_test.py drop` |

SPEC · PROC_M · GRANT · 메타 · 테이블 변경 없음 (BODY 2개 교체만). 의존 객체 INVALID 0.

## 변경 내용

| asis_delta 블록 | 대상 | 적용 후 줄 | 방식 |
|---|---|---|---|
| DMF0044 #002 · #003 | `P_DMF0044_MOBILE_REPORT_CREATE` DEPT_NAME(팀명) 없음 검증의 로그·화면 문구 | L7264, L7267 | `'DEPT_NAME 정보가 …'` → `'TEAM정보가 존재하지 않아 저장할 수 없습니다.'` |
| DMF0044 #001 · #004 | 같은 멤버의 DEPARTMENT_NAME(부서명) 없음 검증 + 오류 처리 | L7272~7280 | 9줄 줄 주석 (`--[E20261006-ASISPARITY] ` 접두) |
| DMF0049 #007 · #009 | `P_DMF0049_SAVE_SALES_ETC_REPORT_C` 구코드 COMPANY_ID 검증 + INVALID 반환 | L856~866 | 11줄 줄 주석 (〃) |

## 근거
- AS-IS 운영 원문(`lgce_mssql_prod_20260917` modules.sql) 전문 확인: `DMF0044_MOBILE_REPORT_CREATE`(수정일 2025-05-20, 472줄)에 DEPARTMENT_NAME 검증이 주석으로도 없고, DEPT_NAME 검증 문구는 L417·L423 `N'TEAM정보가 존재하지 않아 저장할 수 없습니다.'`(실행 코드). `DMF0049_SAVE_SALES_ETC_REPORT_C`(2025-07-23, 800줄)에 `NERP_CONV_MASTER` · `INVALID` 분기 없음(오류 분기는 `DUPICATION_INVALID` 하나).
- TO-BE 에 있던 로직은 AS-IS 개발 DB 에만 있는 SR [E20260107-001542] (개발본 2026-02 수정, 운영 미배포).
- #007 작업메모의 "행 수 기준(운영 p_active_flag / TO-BE p_division_id)" — FE `buildBulkPayload` 가 전 파라미터를 같은 행 배열에서 `join('^')` 하므로 구분자 수가 항상 같다 → 결과 동일, 변경하지 않음.

## 테스트 결과 (수정 전 = TB, 수정 후 = TA · 사업부 40)

| # | 입력 | 수정 전 | 수정 후 | 판정 |
|---|---|---|---|---|
| A1 | 팀명 NULL 행 1개(미확정 임시) 버전 Transfer | 'DEPT_NAME 정보가 …' | 'TEAM정보가 …' | 의도한 변경 |
| A2 | 부서명 NULL 24행 버전 `R_S_20260604_V001` Transfer | 'DEPARTMENT_NAME 정보가 …' 로 중단 | success — 리포트 12,377행 생성(부서명 NULL 24행은 '-'), 부서별 587 · 제품별 23 · 환율 23 | 의도한 변경 · 오류 없음 |
| A3 | 정상 버전 `R_S_20260610_V001` Transfer | success | success | 결과 데이터 동일 |
| A4 | 미전송 버전 Cancel | 'Transfer Cancel은 SendYN 이 Y일 경우만 …' | 동일 | 동일 |
| A5 | 없는 버전 | 'VERSION 값이 존재하지 않습니다.' | 동일 | 동일 |
| A6 | 전송 완료 버전 `R_S_20260604_V002_C` Cancel | success | success | 결과 데이터 동일 |
| A7 | 전송 완료 버전 재 Transfer | success | success | 결과 데이터 동일 |
| B1 | 신규 저장, COMPANY_ID 구코드 C100(회사명 룩업 있음) | '구코드 COMPANY_ID는 저장할 수 없습니다.' | success — 3행(메저 세트), 회사명 LGESK | 의도한 변경 · 오류 없음 |
| B2 | 신규 저장, 구코드 B100(회사명 룩업 없음) | 〃 | success — 3행, 회사명 NULL(컬럼 NULL 허용) | 의도한 변경 · 오류 없음 |
| B3 | 신규 저장, 현행 코드 AZ00 | success 3행 | success 3행 | 저장 결과 동일 |
| B4 | 현행 AZ00 + 구코드 C100 2세트 | '구코드 …' 로 전체 중단 | success — 6행 | 의도한 변경 · 오류 없음 |

- "결과 데이터 동일" = 호출 직후(ROLLBACK 전) 7개 테이블(`DM_MDF_VERSION` · `DM_PLN_SALES_ETC_REPORT_C` · `DM_PLN_SALES_PLAN_REPORT_C` · `DM_MOBILE_REPORT_DEPT/PRODUCT/EXCHANGE_RATE` · `DM_PLN_SALES_ETC_REPORT_H`)의 버전별 행 수 + 일시 컬럼 제외 전 컬럼 해시 합이 수정 전/후 일치.
- 원장 무변경 확인: 호출마다 ROLLBACK 전·후에 **다른 접속**에서 같은 7개 테이블 지문(일시 컬럼 포함)이 호출 전과 같음을 확인(전 건 통과). 종료 후 시험 버전 3개의 SEND_YN·최종수정일 원값 그대로, 시험 키(`ITEM_ID='ZZ_ASISPARITY_T1'`) 잔존 0.
- 적용 후: 실제 패키지 원문에 복제 변환(이름·COMMIT 무력화·자기참조)을 적용한 결과 == 시험한 TA 복제 원문 → 시험한 코드와 배포된 코드가 같다. 실제 `PKG_DMF0044` 로 A1·A4·A5 재호출 결과 동일.

## 미실시·주의
- **실제 패키지의 성공(COMMIT) 경로는 실행하지 않았다.** Transfer·저장 성공 경로는 COMMIT 을 `NULL` 로 바꾼 복제 패키지로만 실행했다(차이 = 그 COMMIT 줄뿐). 화면 경유 확인은 하지 않았다.
- 테스트 중 로그 테이블 `SCM_SYS_LOG_BATCH` 에 프로그램명 `DMF0044_MOBILE_REPORT_CREATE` · `DMF0049_SAVE_SALES_ETC_REPORT_C` 등 로그 행이 남았다(로그 프로시저가 자율 트랜잭션). 이력 시퀀스 `SEQ1_DM_PLN_SALES_ETC_REPORT_H` 는 소비 없음(이력 0행).
- 이제 Transfer 가 되는 버전: 부서명 NULL 행을 가진 40 사업부 3개 버전(`R_S_20260604_V001` 24행 · `R_S_20260823_V003` 72행 · `R_S_20260903_V001_C` 24행). 리포트에는 부서명 '-' 로 들어간다(`DM_PLN_SALES_PLAN_REPORT_C.DEPARTMENT_NAME` NOT NULL — 기존 `NVL(…,'-')`).
- 구코드 COMPANY_ID(22종, `NERP_CONV_MASTER`)가 ETC Report 에 저장 가능해졌다. 현재 원장에 구코드 행은 0건.
- AS-IS 가 SR [E20260107-001542] 를 운영에 배포하면 본 건을 원복해야 한다 — `python 99_ROLLBACK_apply.py` (현재 DB 원문에서 이번 변경분만 제거).
- 클라우드 미적용 — 이관 패키지 [DMF0044_0049_ASISPARITY_CLOUD_20261006](../../_deploy_packages/DMF0044_0049_ASISPARITY_CLOUD_20261006/00_README.md) 작성(2026-10-06 16:31).
- 무관: `PKG_DMF0002` · `PKG_DMF0035` · `PKG_DMF0051` BODY 가 INVALID 상태(LAST_DDL 09-17~09-29, 두 패키지 의존 없음, 컴파일 오류 기록 없음) — 본 작업 이전부터의 상태로 손대지 않음.
