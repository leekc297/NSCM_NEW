# AS-IS 변경분 반영 2건 `[E20261006-ASISDELTA]` — 사내 ZIOUI1 실행 작업 대조표

대상: `Doc/_analysis/asis_delta_20261002/02_변경분_반영현황.xlsx` 시트 14 "DMF0004 저장 컬럼 누락"(우선순위 20·21) · "DMF0022 81 사업부 분기"(31·32).
접속: 사내 `ZIOUI1` / 호스트 `ol9-db` / 계정 `SCM_MGR`.

| 시각 (2026-10-06) | 작업 | 대상 | SQL / 스크립트 |
|---|---|---|---|
| 15:34 | 적용 전 원문 조회·백업 (조회 전용) | `PKG_DMF0004` SPEC·BODY (LAST_DDL 14:42:40) · `PKG_DMF0022` BODY (LAST_DDL 09-17 19:14:16, INVALID) | [00_fetch.py](00_fetch.py) → [00_BACKUP_PKG_DMF0004__PACKAGE_BODY.sql](00_BACKUP_PKG_DMF0004__PACKAGE_BODY.sql) · [00_BACKUP_PKG_DMF0022__PACKAGE_BODY.sql](00_BACKUP_PKG_DMF0022__PACKAGE_BODY.sql) |
| 16:01 | JSON 컬럼 정의 사전 확인 (DUAL 조회) | — | [t00_json_semantics.py](t00_json_semantics.py) |
| 16:05:21 | `PKG_DMF0022` BODY 자동 재컴파일 (적용 전 조회 호출 시 Oracle 이 수행 — 원문 동일) | `PKG_DMF0022` BODY | (조회 SP 호출) |
| 16:07:10 | **PKG BODY 적용** — FRESH-GATE 통과 · VALID · 오류 0 · 적용본 == DB 원문 · 의존 INVALID 0 | `PKG_DMF0004` BODY | [01_PKG_DMF0004_BODY.sql](01_PKG_DMF0004_BODY.sql) (`python build_apply.py apply DMF0004`) |
| 16:07 | 저장 실행 검증 — 시험 키 `DIVISION_ID='ZZ'` 로 저장 SP 10회 호출 (내부 COMMIT) | `SCM_MST_SITE` 2행 · `SCM_MST_SITE_H` 8행 생성 | [t04_test.py](t04_test.py) |
| 16:07 | 시험 행 삭제 + COMMIT (`DIVISION_ID='ZZ'` 만) — 잔여 0 · `SCM_MST_SITE` 전체 3,037건 불변 | `SCM_MST_SITE` 2행 · `SCM_MST_SITE_H` 8행 삭제 | [t04_test.py](t04_test.py) `finally` |
| 16:17~16:26 | 적용 전 조회 결과 캡처 (조회 SP 4회) | — | [t22_capture.py](t22_capture.py) `BEFORE` |
| 16:26:32 | **PKG BODY 적용** — FRESH-GATE 통과 · VALID · 오류 0 · 적용본 == DB 원문 · 의존 객체 없음 | `PKG_DMF0022` BODY | [02_PKG_DMF0022_BODY.sql](02_PKG_DMF0022_BODY.sql) (`python build_apply.py apply DMF0022`) |
| 16:27~16:29 | 적용 후 조회 결과 캡처·비교 (조회 SP 4회) | — | [t22_capture.py](t22_capture.py) `AFTER` · `--cmp BEFORE AFTER` |

`SCM_MST_SITE_H` 시퀀스(`SEQ1_SCM_MST_SITE_H`)는 시험으로 8 증가했다. 그 외 SPEC · PROC_M · API_M · GRANT · 시노님 · 테이블 · 메타 변경 없음.

## ① PKG_DMF0004.P_DMF0004_SAVE_SALES_SITE_DATA — 삽입 19줄 (기존 줄 변경 없음)

| 위치 (적용 후 줄) | 내용 | AS-IS 운영 근거 |
|---|---|---|
| L184~188 조회 목록 | `TRIM(JT.DISTRIBUTION_CHANNEL)` · `TRIM(JT.ATTRIBUTE5)` · `HAS_*` 2개 | L229-230 · L242 (TRIM) |
| L210~214 JSON_TABLE | `DISTRIBUTION_CHANNEL` · `ATTRIBUTE5` (VARCHAR2(600)) · `HAS_*` (`EXISTS PATH`) | L211 · L213 (파라미터 분해) |
| L345~347 UPDATE | `ATTRIBUTE3` · `ATTRIBUTE5` 저장 | L433-434 |
| L370~372 · L392~394 INSERT | 컬럼·값 2개씩 | L457-458 · L479-480 |

- AS-IS 는 화면이 두 값을 항상 넘긴다. TO-BE 는 JSON 이라 키가 아예 없는 행이 올 수 있어, **키가 없으면 기존 값을 유지**한다(UPDATE). 키가 있으면 null·빈값 포함 그대로 저장한다(AS-IS 의 `''` 저장 = Oracle NULL).
- TO-BE 화면(`salesSite` 시트)에는 두 컬럼이 없다(`SCM_MST_SHEET_COLUMNS` VALID_YN='N'). 조회 결과에는 `DISTRIBUTION_CHANNEL` · `ATTRIBUTE5` 가 들어 있고 화면은 조회 행을 그대로 저장에 넘기므로, 기존 행은 읽은 값이 그대로 다시 저장된다.
- JSON 컬럼 폭을 600 바이트로 둔 이유: 150자를 넘는 값이 조용히 NULL 이 되지 않고 `ORA-12899` 로 실패하게 하려는 것(T10).

### 저장 실행 검증 — 23/23 PASS ([_test_result_DMF0004.json](_test_result_DMF0004.json))

| # | 입력 | 결과 |
|---|---|---|
| T1 | 신규 · `'  50 '` / `' 7  '` | `50` / `7` 저장 · 기존 컬럼 정상 |
| T2 | 수정 · 두 키 없음 | 기존 값 유지 · VMI 만 변경 |
| T3 | 수정 · `'AB'` / 숫자 `0` | `AB` / `0` |
| T4 | 수정 · `ATTRIBUTE5` 키만 | `ATTRIBUTE3` 유지 · `ATTRIBUTE5` 갱신 |
| T5 | 수정 · null / 빈값 | 둘 다 비움 |
| T6 | 신규 · 두 키 없음 | 둘 다 NULL 로 생성 |
| T7 | 2행 한 번에 | 처리 2건 · 행별로 맞게 반영 |
| T8 | 필수값(COMPANY_ID) 누락 | 종전대로 오류 · 미저장 |
| T9 | 중복 신규 | 종전대로 오류 |
| T10 | 151자 | `ORA-12899` · 미저장 |
| 이력 | 성공 저장 8건 | `SCM_MST_SITE_H` 8행 · `ATTRIBUTE3/5` 기록 |

실원장 확인: 적용·시험 후 SALES 사이트의 `ATTRIBUTE3` 2건 · `ATTRIBUTE5` 3건(모두 82) — 적용 전과 같다.

## ② PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL — 조건 2줄 치환 + 주석 2줄

| 적용 후 줄 | 구간 | 변경 | AS-IS 운영 |
|---|---|---|---|
| L1018 | Current · `DM_PLN_SALES_PLAN` | `A.DIVISION_ID = '40'` → `(A.DIVISION_ID = '40' OR A.DIVISION_ID LIKE '81%')` | L457-458 |
| L1087 | Cutoff · `DM_PLN_SALES_PLAN_C` | 같음 | L537-538 |

- AS-IS 두 줄 모두 실행 코드다(주석 범위 아님). 만든 `CELL_PROD_SITE_ID` 는 뒤에서 `FROM_SITE_ID` 표시와 행 묶음 기준으로 쓰인다.
- 뒤쪽 조인 구조는 TO-BE 가 AS-IS 와 같다 — 40 외 사업부의 단가 조인(Current `SCM_MST_FUTURE_PRICE`, Cutoff `#T_PRICE`)에는 `CELL_PROD_SITE_ID` 조건이 없다(AS-IS L1623 은 주석 블록 안).

### 조회 결과 전·후 비교 ([cmp22_BEFORE_AFTER.json](cmp22_BEFORE_AFTER.json))

조건: 계정 `minyonglee1` · 기간 2026-08-03 ~ 2027-03-28 (기준일 2026-10-05) · 월 단위 · 버전 `SP_W_20260827_V001`.

| 케이스 | 행수 전 → 후 | FROM_SITE_ID 값 종류 | 수량·금액 합계 |
|---|---|---|---|
| 82 Current | 206 → 206 | — | 전행 일치 |
| 81_UC Current+Cutoff | 47 → 49 | `N/A` → `GM00-A`, `N/A` | 동일 |
| 81 Current | 1,360 → 1,544 | 4종 → 8종 | 동일 |
| 81 Cutoff | 1,007 → 1,143 | 1종 → 9종 | 동일 |

- 81 계열은 생산 사이트별로 행이 나뉘고 `FROM_SITE_ID` 에 실제 값이 나온다. 수량(`RTF_SYS_RP` · `RTF_PR`)과 금액(`SalesAmt_KRW` · `SalesAmt_LOC`)의 기간별 합계는 전·후가 같다.
- 단가 메저 `LOC` 는 행마다 같은 단가가 반복 표시되므로 행이 나뉜 만큼 단순 합이 커진다(값 자체가 바뀐 것은 아님).
- 4개 케이스 모두 결과 코드 `0 / SUCCESS`.

## 미실시·주의

- **40 사업부 실행 비교 미실시** — 변경식은 사업부가 81 로 시작할 때만 값이 달라진다(`'40'` 은 전·후 모두 참). 사내 DB 디스크 읽기가 느려 40 Current 1건이 10분을 넘겨 중단했다.
- **AS-IS 조회 결과와의 직접 대조 미실시** — 판정 근거는 운영 원문 대조와 TO-BE 전·후 비교다.
- **화면 확인 미실시** — Sales Site 저장(DMF0004), Sales Plan Waterfall 81 조회(DMF0035 화면)의 From Site 표시는 화면에서 확인이 필요하다.
- 클라우드 미적용 (이관 패키지 미작성).
- 진행 중 `SCM_COM_SQL_LOG` 전체 탐색 조회 3건이 20분 넘게 돌았다(호출 로그 확인용 · 결과 미사용). 중지했고 세션 종료를 확인했다.
- 원복: `python 99_ROLLBACK_apply.py DMF0004` / `DMF0022` (지금 DB 원문에서 이번 변경분만 제거 · 로컬 왕복 검증 완료).
