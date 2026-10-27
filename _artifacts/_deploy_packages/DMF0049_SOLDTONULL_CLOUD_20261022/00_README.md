# DMF0049_SOLDTONULL_CLOUD_20261022 — ETC Sales Report 저장 시 빈 Sold-To '/' 저장 → 정렬 변동 보정 (클라우드 패치, DB 만)

- 마커: `[E20261022-SOLDTONULL]` 2곳 · 대상: `SCM_MGR.PKG_DMF0049` PACKAGE BODY → `P_DMF0049_SAVE_SALES_ETC_REPORT_C`
- 데이터: `DM_PLN_SALES_ETC_REPORT_C.SOLDTO_CODE` `'-'`/`'/'` → NULL (백업 `DM_PLN_SALES_ETC_REPORT_C_BAK20261022_SOLDTO`)
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(11:44, 사내 적용본과 원문 md5 일치) — `_artifacts/_apply_corporate/DMF0049_SOLDTONULL_20261022/APPLIED_OPERATIONS.md`
- **FE 무변경 · BE 재기동 불필요 · 메타 변경 없음.**

## 무엇이 바뀌나
저장 SP INSERT 2곳(수정 행 재적재 / 신규 행)이 빈 Sold-To 를 `NVL(NULLIF(RTRIM(SOLDTO_CODE),''), '/')` 로 `'/'` 저장했다
(2026-08-11 `[SOLDTO-SENTINEL]` 도입 시 `'-'`, 10월 센티널 전환 후 `'/'`). AS-IS `DMF0049_SAVE_SALES_ETC_REPORT_C` 는 값 그대로 저장 → 기존 원장은 NULL.
조회 정렬 `ORDER BY … UPPER(SOLDTO_CODE)` 에서 NULL 은 맨 뒤, `'/'` 는 맨 앞이라 저장한 행만 위치가 바뀌었다.
→ `NULLIF(RTRIM(A.SOLDTO_CODE),'')` 로 변경(원래 줄은 주석 보존). SOLDTO_CODE 는 PK 아님·NULL 허용.
이미 `'-'`/`'/'` 로 저장된 행은 20_DATA 가 NULL 로 정리(이력 _H 는 무변경).

## 사내 검증 (ZIOUI1)
- SP 실호출: SQL_LOG 실전송값(LOG_SEQ 2293331, 10-16 hongjae.kim, 신규 3행·soldtoCode 빈값) 재실행 → 신규 DATA_SEQ 345 3행 SOLDTO_CODE **NULL**, O_RESULT `success` (시험 행 삭제 완료)
- 데이터: `'-'` 144 · `'/'` 94 = 238행 백업 후 NULL → 원장 전체 NULL 863,497행

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 대상 2 PASS · L2 마커 0 · L3 데이터 `'-'`/`'/'` 건수 확인 | L1 FAIL(마커 0인데 2 아님)이면 **10 실행 금지**, 결과 회신. 마커 2 = 이미 적용 |
| 2 | `A_DB/10_APPLY_SOLDTONULL_PATCH.sql` | `APPLIED — PKG_DMF0049 BODY VALID · 마커 2곳` | `중단 — …` 이면 원문 무변경, 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/20_DATA_SOLDTO_NULL.sql` | `DATA — SOLDTO_CODE NULL 정리 N행 COMMIT` · POST 에 `'-'`/`'/'` 없음 | 회신 |
| 4 | `A_DB/90_VERIFY.sql` | V1 마커 2 · 치환줄 0 · V2 VALID/오류 0 · V3 데이터 0 PASS | 회신 |
| 5 | 화면: DMF0049 Sold-To 빈 행 수정 저장 → 재조회 | 저장 전과 같은 위치에 정렬 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_SOLDTONULL_PATCH.sql` · `A_DB/99_ROLLBACK_DATA.sql` | `ROLLED BACK — … 마커 0` · `DATA ROLLED BACK — N행` | 회신 |

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (2줄 패치 + 원래 줄 주석) |
| 데이터 | ✅ 20_DATA (백업 테이블 CTAS 후 UPDATE) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타 · MSG/LBL · GRANT/SYNONYM · FE · BE | 해당 없음 (백업 테이블은 SCM_MGR 전용, 앱 권한 불필요) |

## 참고 (본 패키지 범위 밖)
- `PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C` 의 ETC 원장 MERGE(사내 L4599)도 SOLDTO_CODE 에 `'-'` 고정 INSERT — 미변경(사용자 판단 대기).

## 파일
- `build_package.py` — 생성기(FRESH-GATE · 시뮬레이터 · ASCII 앵커) · `run_rehearsal.py` · `_rehearsal_out/` · `_md5now.py` · `_md5_corporate_applied.txt`
