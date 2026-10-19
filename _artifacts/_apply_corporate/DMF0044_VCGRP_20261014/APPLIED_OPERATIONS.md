# DMF0044 Version Copy 저장 — GROUP BY 불일치(ORA-00979) 보완 `[E20261014-DMF0044VCGRP]`

- 대상 DB: 사내오라클 `59.19.252.148:2521/ZIOUI1` (SERVER_HOST=localhost) · 계정 SCM_MGR
- 경위(2026-10-14): 조회 오류 보완(`[E20261014-DMF0044GRPUPPER]`) 뒤 사용자 요청으로 패키지 전체를 점검 → Version Copy 저장 프로시저에서 같은 계열 4문장 발견 → 사용자 지시 "진행".

## 원인
`PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY` 의 INSERT 4문장에서 SELECT 와 GROUP BY 의 식이 다르다.

| SELECT | GROUP BY |
|---|---|
| `NVL(NULLIF(RTRIM(X),''), '/')` | `NVL(X, '/')` |

X 자체는 GROUP BY 에 없어 실행 시점에 ORA-00979 가 난다(컴파일은 VALID).
**정정(10-14 10:20)**: 처음에 "10-06 백업본에도 같은 4문장이 있었다"고 적었으나 틀렸다 — 그때 점검한 파일은 10-13 19:46 원문(조회 보완의 백업)이었다.
10-06 백업본은 SELECT · GROUP BY 가 모두 `NVL(X, '-')` 로 서로 같아 문제가 없다. 불일치는 그 뒤 빈값 표기 `'-'` → `'/'` 전환 때
SELECT 만 `NVL(NULLIF(RTRIM(X),''), '/')` 로 바뀌고 GROUP BY 는 `NVL(X, '/')` 로 바뀌면서 생겼다(오늘 조회 오류와는 별개).

| 문장(적용 전 시작 행) | 실행 조건 | 대상 컬럼 | 고친 곳 |
|---|---|---|---|
| L8011 | SP 버전 복사 | A.CURRENCY | 7 |
| L8354 | BP 버전 복사 | B.SALES_COMPANY · A.ITEM_USE · A.END_CUSTOMER | 3 |
| L8527 | 실적 기반 복사 | A.CURRENCY | 6 |
| L9270 | 리포트 원장 적재 | A.COMPANY_ID | 1 |

A.ITEM_USE · A.END_CUSTOMER 는 첫 점검에서는 보이지 않았다(Oracle 은 문장마다 첫 오류만 알려 준다). 보완본을 다시 점검해 찾았다.

## 변경 내용 (GROUP BY 절 17곳 · 16줄 + 설명 주석 1줄)
- GROUP BY 의 `NVL(X, '/')` 를 SELECT 와 같은 `NVL(NULLIF(RTRIM(X),''), '/')` 로 바꿨다(16곳).
- L8111 한 곳은 SELECT 가 `NVL(A.CURRENCY, '/')` 도 따로 쓰므로(CASE 조건) 기존 식을 두고 SELECT 의 식을 덧붙였다.
- SELECT · WHERE · 그 밖의 문장 무변경. 결과 행의 값은 SELECT 가 정하므로 달라지지 않는다.
- 치환 목록: `_changes.json`.

## 실행 작업 ↔ 파일
| # | 작업 | 파일 | 시각 | 결과 |
|---|---|---|---|---|
| 1 | 패키지 정적 SQL 313문장 파싱 점검 (실행 없음) | `../DMF0044_GRPUPPER_20261014/check_static_sql.py` | 09:48 | 같은 계열 4문장 |
| 2 | BODY 최신 원문 조회·백업 (LAST_DDL 09:30:23) | `00_BACKUP_PKG_DMF0044_BODY.sql` | 09:58 | 10,587줄 |
| 3 | 보완본 파일 파싱 점검 | 위 도구 + `01_PKG_DMF0044_BODY.sql` | 09:58 | 같은 계열 0 |
| 4 | PKG_DMF0044 BODY 적용 | `01_PKG_DMF0044_BODY.sql` (`build_apply.py apply`) | 09:59:27 | VALID · 오류 0 · DB==적용본 · INVALID 63→63 |
| 5 | 적용 후 DB 원문 파싱 점검 · 조회 회귀 | 위 도구 · `test_call.py` | 10:00 | 같은 계열 0 · 조회 6케이스 PASS |
| 6 | 클라우드 패키지 리허설 (원복 → 점검 → 적용 → 재적용 → 검증) | `_deploy_packages/DMF0044_VCGRP_CLOUD_20261014/` | 10:03:33 | 최종 적용 상태 · DB 원문 == 사내 적용본 |
| 7 | 리허설 뒤 파싱 점검 · 조회 회귀 재확인 | 위 2종 | 10:04 | PASS |

권한·시노님·메타·데이터 변경 없음. SPEC 무변경.

## 클라우드 패치 v2 (10-14 10:20)
- QA 에서 v1(줄 글자 단위 일치) 이 2회 중단. QA `00` L2 결과: 대상 16줄 중 4줄이 아직 `'-'` 표기 · 들여쓰기와 줄 끝 주석이 사내와 다름.
- v2 = 줄을 코드 내용으로만 맞추고(들여쓰기 · 주석 · `'-'`/`'/'` 무관) 줄 안의 토큰만 바꾼다. SELECT 쪽 식의 개수가 사내 적용 전과 같아야 적용한다.
- 사내 검증 `test_cloud_sim.py`: A 사내 실제 원문(99→10→SKIP→99) 7항목 · B QA 모양 원문을 사내 패키지에 잠시 올려 10→파싱 점검 0건→90→99 9항목 · C 사내 적용본(01) 복귀 — 모두 PASS(10:23). 패키지 BODY 최종 = 01 과 동일.

## 미실행
- **Version Copy 저장의 실제 실행.** 원장(`DM_PLN_SALES_PLAN_REPORT_C` 등)에 쓰고 내부에서 COMMIT 하는 프로시저라 실행하지 않았다.
  확인한 것은 "4문장이 파싱을 통과한다"까지다. 화면에서 Version Copy 를 한 번 실행해 확인이 필요하다.
- 파싱 점검 도구가 판정하지 못한 2문장(L4107 · L5129, 배열 일괄 INSERT — GROUP BY 없음).
- 클라우드 적용.

## 원복
`00_BACKUP_PKG_DMF0044_BODY.sql` 실행(조회 보완은 유지된 상태로 돌아간다), 또는 패키지의 `99_ROLLBACK_VCGRP_PATCH.sql`.
