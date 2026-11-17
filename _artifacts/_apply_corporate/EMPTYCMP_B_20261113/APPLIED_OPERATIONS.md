# 결과에 영향 없는 빈 문자열 비교 항 정리 — 사내 적용 기록 (2026-11-13)

- 대상 DB: 사내 Oracle ZIOUI1, 스키마 SCM_MGR. 요청: 사용자 "(b) 실행 코드 28줄도 정리해줘"(2026-11-13)
- 근거: `Doc/_rules_consolidation/2026-11-13_EMPTY_STRING_COMPARE_조사.md` §6. `X IS NOT NULL OR X <> ''` 꼴의 `<> ''` 항은 Oracle 에서 항상 거짓이라 지워도 결과가 같음
- 기준 원문: 2026-11-13 19:04:44 `ALL_SOURCE` 재조회본(`backup/<객체>.ASIS.sql`). 적용 직전 원문이 착수 원문과 같은지 확인 후 적용
- 바뀐 줄 끝 표시: `-- [E20261113-EMPTYCMP-B] 결과에 영향 없는 빈 문자열 비교 항 삭제`
- 블록 주석 안의 같은 구문은 건드리지 않음(토큰 분석으로 제외)

## 적용 내용 (11개 객체, 28줄)

| 객체 | 줄 | 수정 전 | 수정 후 | 수정 전 상태 | 수정 후 상태 | 최종 LAST_DDL |
|---|---|---|---|---|---|---|
| PKG_SDM1010 | 552, 553, 607, 608 | `( NVL(V, '') != '' OR V IS NOT NULL )` | `( V IS NOT NULL )` | VALID | VALID | 19:08:50 |
| PKG_SDM2010 | 1226~1229, 1280, 1365 | 같음 | 같음 | INVALID, 오류 4건 | INVALID, 오류 4건 같음 | 19:08:51 |
| PKG_SDM2020 | 1190~1193, 1244, 1329 | 같음 | 같음 | INVALID, 오류 4건 | INVALID, 오류 4건 같음 | 19:08:52 |
| PKG_SDM5010 | 386, 584, 632, 652 | `( P IS NOT NULL OR P != '' )` | `( P IS NOT NULL )` | VALID | VALID | 19:08:52 |
| PKG_SCM0002 | 4375, 4462 | `ELSIF V_COLUMN_NAME IS NOT NULL OR V_COLUMN_NAME != '' THEN` | `ELSIF V_COLUMN_NAME IS NOT NULL THEN` | VALID | VALID | 19:08:53 |
| PKG_DMF0003 | 6168 | `( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL OR NVL(A.ATTRIBUTE4,'') <> '' OR NVL(A.ATTRIBUTE5,'') <> '')` | `( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL)` | VALID | VALID | 19:08:56 |
| PKG_DMF0003_01 | 6693 | 같음 | 같음 | VALID | VALID | 19:09:01 |
| PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK | 938 | `(T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')` | `(T.ETA_DATE IS NOT NULL)` | INVALID, 오류 0건 | VALID | 19:09:05 |
| PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK | 1352 | 같음 | 같음 | VALID | VALID | 19:09:05 |
| PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK | 1427 | 같음 | 같음 | VALID | VALID | 19:09:06 |
| PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH | 1018 | 같음 | 같음 | INVALID, 오류 0건 | VALID | 19:09:07 |

## 수정 전부터 있던 문제 (이번 변경과 무관, 미조치)

- PKG_SDM2010, PKG_SDM2020 BODY: `ORA-00904 "BLD"."BIZ_TYPE"`, `ORA-00904 "BIZ_TYPE"` 로 컴파일되지 않음. 수정 전 LAST_DDL 2026-10-15 10:47:59. 오류 4건씩, 수정 전후 같음
- PR_SCP_OPT_ENG_EE_RUN_MAIN_PROC: INVALID. 참조하는 PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST, PR_SCP_OPT_ENG_EE_INPUT_DEMAND, PR_SCP_OPT_ENG_EE_INPUT_EVERY_DAY_CAL 이 INVALID
- PR_SCP_OPT_ENG_RUN_MAIN_PROC_BATCH: INVALID. 참조하는 PR_SCP_OPT_ENG_INPUT_ASSIGN_MODEL_LIST_BATCH 가 INVALID

## 실행 순서와 결과

| 시각 | 실행 | 결과 |
|---|---|---|
| 19:04:44 | `emptycmp.py prep` | 11개 원문 백업, 치환 검사 28줄 일치 |
| 19:06:45 | `run_tests.py before` | 조회 6건 오류 0, 술어 등가 조회 4건 |
| 19:08:50~19:09:07 | `emptycmp.py apply` | 11개 적용, 적용본==DB 11개 True |
| 19:09:08 | `emptycmp.py verify` | 11개 OK. 표시 줄 28 |
| 19:10:01 | `run_tests.py after`, `compare` | 6건 결과 커서 3개씩 전후 같음 |
| 19:10:31 | 클라우드 패치 시험 실행(적용 없음) | 10_APPLY 11개 SKIP, 99_ROLLBACK 11개 적용 가능 |

## 전후 시험

| 시험 | 수정 전 | 수정 후 | 판정 |
|---|---:|---:|---|
| PKG_DMF0003 GET_MKT_FCST_DATA 81 | 170행 | 170행 | 결과 커서 3개 같음 |
| PKG_DMF0003 82 | 5,557행 | 5,557행 | 같음 |
| PKG_DMF0003 40 | 211행 | 211행 | 같음 |
| PKG_DMF0003_01 81 | 308행 | 308행 | 같음 |
| PKG_DMF0003_01 82 | 5,519행 | 5,519행 | 같음 |
| PKG_DMF0003_01 40 | 208행 | 208행 | 같음 |
| DM_PLN_MKT_FCST MKT_FCST 에 수정 전 술어 / 수정 후 술어 | 12,850행 | 12,850행 | 같음 |
| DUAL `NVL(V,'') != '' OR V IS NOT NULL` 과 `V IS NOT NULL` | 값 있음 1,1 / NULL 0,0 | | 같음 |
| DUAL `V IS NOT NULL OR V != ''` 과 `V IS NOT NULL` | 값 있음 1,1 / NULL 0,0 | | 같음 |

- 조회 프로시저 안의 `COMMIT WORK`(PKG_DMF0003 5892, 5915줄)는 시험 계정의 `SCM_MST_TITLESET_USER` 행이 0건일 때만 실행됨. 시험 전후 행 수 같음(DMF0003 C 15, M 4. DMF0003_01 C 21, M 4)
- 실행하지 않은 것: PKG_SDM1010, PKG_SDM5010 저장 프로시저, PKG_SCM0002 `P_SCM0002_SET_TITLESET_POPUP`, PR_SCP_OPT_ENG_* 배치 4개. 데이터를 바꾸므로 실행하지 않았고 술어 등가와 컴파일로만 확인함
- PKG_SDM2010, PKG_SDM2020 은 컴파일되지 않는 상태라 실행 시험 불가

## 클라우드 이관

- `_artifacts/_deploy_packages/EMPTYCMP_B_CLOUD_20261113/`: `10_APPLY_PATCH.sql`, `90_VERIFY.sql`, 되돌리기 `99_ROLLBACK_PATCH.sql`, `README.md`
- 수정 구간만 치환함. 객체 11개, 구간 20개
- 사내 되돌리기, 재적용 왕복 리허설은 하지 않음. 같은 생성기의 왕복은 EMPTYCMP_20261113 에서 확인했고 이번에는 시험 실행만 함
- 클라우드에서 객체가 INVALID 면 패치 블록이 컴파일 실패로 판정해 실행 전 원문으로 되돌리고 ORA-20013 을 냄. 원문은 그대로 남음

## 되돌리기

- 사내: `python rehearse.py ..\..\_deploy_packages\EMPTYCMP_B_CLOUD_20261113\99_ROLLBACK_PATCH.sql`
