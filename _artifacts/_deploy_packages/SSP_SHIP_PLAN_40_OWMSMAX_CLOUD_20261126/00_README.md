# SHIP_PLAN_40 1-1 단계 최근 CUTOFF 조회 보완 클라우드 이관 (2026-11-26 14:10 사내 적용)

- 2026-11-26 14:51 : SSP_SHIP_PLAN_40_PERF2_CLOUD_20261126 에 포함됨. 이 패키지를 아직 적용하지 않았으면 PERF2 만 실행
- 대상 : SCM_MGR.PR_SSP_ANL_SHIP_PLAN_40 1개
- 표식 : E20261126-OWMSMAX
- 선행 : SSP_SHIP_PLAN_40_BATCH_PERF_CLOUD_20261126 적용본(E20261126-DS2) 위에 1줄 바꾸고 1줄 추가. 클라우드 11-26 [C1] 회신에서 줄 수 3582, MARK_DS2 1 확인
- 기준본 : 사내 ZIOUI1 2026-11-26 14:10:06 조회(LAST_DDL 2026-11-26 11:26:43, 3582줄, SUM(ORA_HASH(TEXT)) 8002014763396)
- 실행 계정 : SCM_MGR. 파일마다 전체 실행(F5), 반복 실행 가능

## 실행 순서 (클라우드)

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | A_DB/00_PRECHECK.sql | [P1] SAME_AS_CORP_BASE = Y, [P2] 0행일 때 진행 |
| 2 | A_DB/05_BACKUP.sql | 현재 원문을 ZB_SSP40_SHIP_20261126B 에 보관 |
| 3 | A_DB/20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40.sql | 사내 적용본으로 교체 |
| 4 | A_DB/90_VERIFY.sql | 기대값 : VALID, ERR_CNT 0, LINE_CNT 3583, SAME_AS_CORP_TOBE Y, MARK_DS2 1, MARK_OWMSMAX 1 |
| 5 | A_DB/95_COMPARE_OWMSMAX.sql | 원문 조건, 변경 조건을 같은 입력으로 실행해 결과, 소요 비교(조회만). [CMP] 3줄 회신 |
| 문제 시 | A_DB/99_ROLLBACK.sql | 05 보관 원문으로 복원(E20261126-DS2 는 남음) |

## 바뀌는 것

1-1 단계에서 전일 OWMS I/F 가 없을 때 가장 최근 CUTOFF_DATE 를 찾는 문장(원문 527줄, SQL_ID 83wgypmy3wyvu)의 조건 1줄.

| | 조건 |
|---|---|
| 변경 전 | `AND FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL` |
| 변경 후 | `AND (SELECT FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL` |

- 같은 함수를 그대로 부르고, 같은 PLANT_ID, ITEM_ID 는 문장 실행 안에서 결과를 재사용함
- 함수를 조인으로 바꾸지 않은 이유 : SCM_MST_ITEM_SN 은 키 제약이 없고 같은 DIVISION_ID, ITEM_ID 에 SCP_OPERATION_GROUP 이 다른 행 48건(사내 14:09). 함수는 ROWNUM <= 1 로 1행만 쓰므로 조인으로 바꾸면 결과가 달라질 수 있음
- 같은 조건이 있는 앞 문장(V_OWMS_IF_COUNT 건수 조회, 전일 하루치만 읽음)은 바꾸지 않음

## 근거 (클라우드 회신 2026-11-26, Downloads/20260608_01.txt)

| 법인 | 11-25 비교 회차 ASH 초 | 11-26 회차 ASH 초 | 차이 | 83wgypmy3wyvu |
|---|---|---|---|---|
| HQ00 | 402 (2회차) | 481 (1회차) | +79 | 0 → 76 |
| NJ00 | 427 (4회차) | 508 (3회차) | +81 | 0 → 73 |
| AZ00 | 292 (3회차) | 301 (2회차) | +9 | 71 → 73 |

- 그 밖의 문장 차이 회차당 -8 ~ +7초. dynamic_sampling 2 적용 뒤 계획이 바뀌어 느려진 문장 없음(16zd7hkh15tk1 2568510255 유지, 15 ~ 17초)
- 83wgypmy3wyvu 는 그날 그 법인의 SSP_ANL_OWMS_STOCK_C 가 없을 때(그날 첫 실행) 전일 OWMS I/F 가 없으면 실행됨. 11-25 HQ00, NJ00 비교 회차는 같은 날 재실행이라 이 문장이 실행되지 않음
- 클라우드 SQL 모니터 : 83wgypmy3wyvu 73.3 ~ 75.8초, CPU 72.3 ~ 74.5초, PLSQL 20.7 ~ 21.4초, BUFFER_GETS 4,746,303 ~ 4,746,355

## 사내 ZIOUI1 확인 (2026-11-26)

| 시각 | 항목 | 결과 |
|---|---|---|
| 14:09 | 원문 조건 vs 변경 조건(40 사업부, HQ00, NJ00, AZ00) | 결과 3건 같음. 2.43 → 0.23초, 2.54 → 0.35초, 2.42 → 0.20초 |
| 14:10:14 | 사내 적용(build_owmsmax.py apply, FRESH-GATE DB == 기준본) | VALID, ALL_ERRORS 0, DB 원문 == 적용본 |
| 14:11:24 ~ 14:11:29 | 리허설 : 기준본 복원 → 00 → 05 → 20 → 90 → 20 → 99 → 20 → 90 | APPLY → SKIP → 원복(DB == 기준본) → APPLY. 90 기대값 일치 |
| 14:12 | 95_COMPARE_OWMSMAX.sql | 결과 3건 같음. 2.45 → 0.20초, 2.54 → 0.34초, 2.41 → 0.17초 |

- 클라우드 95 회신(2026-11-26, JOIN 추가 전 판) : HQ00 76.9 → 0.36초, NJ00 74.01 → 0.85초, AZ00 71.24 → 0.22초. 결과 3건 같음(20261125, 20261125, 20261115)
- 사내는 결과 캐시가 크고(result_cache_max_size 687,865,856) 클라우드는 작음(65,011,712). 클라우드 소요 차이는 95 회신으로 확인
- 시험하지 않은 경로 : 20 의 -20011(원문 다름), -20012(컴파일 실패 복원). 사내에 해당 조건 없음
- SP 전체 실행은 하지 않음. 사내는 IF_STOCK_CHECK 가드(GUARD_STOCK 1)로 1-1 단계까지 가지 않음
- 사내 SCM_MGR 에 보관 표 ZB_SSP40_SHIP_20261126B 생성됨

## 생성
- `_artifacts/_apply_corporate/SHIP_PLAN_40_OWMSMAX_20261126/build_owmsmax.py` : 기준본 조회, 적용본 생성, 사내 적용
- `_artifacts/_apply_corporate/SHIP_PLAN_40_OWMSMAX_20261126/build_package_owmsmax.py` : 이 패키지 생성(FRESH-GATE, SOURCE-FRESH 스탬프)
