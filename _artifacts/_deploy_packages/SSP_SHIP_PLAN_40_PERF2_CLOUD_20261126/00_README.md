# SHIP_PLAN_40 2차 속도 보완 클라우드 이관 (2026-11-26 사내 적용)

- 대상 : SCM_MGR.PR_SSP_ANL_SHIP_PLAN_40 1개
- 담은 보완 3건 : E20261126-OWMSMAX(1-1), E20261126-AGINGCUT(1-6), E20261126-WHSTKHD(2-14)
- SSP_SHIP_PLAN_40_OWMSMAX_CLOUD_20261126 패키지를 포함함. 그 패키지를 적용했든 안 했든 이 패키지만 실행하면 됨
- 사내 최종본 : 3589줄, SUM(ORA_HASH(TEXT)) 8012851557184, LAST_DDL 2026-11-26 14:51:33
- 실행 계정 : SCM_MGR. 파일마다 전체 실행(F5), 반복 실행 가능

## 실행 순서 (클라우드)

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | A_DB/00_PRECHECK.sql | 원문 상태, 표식 수. [P2] 실행 중 세션 0행일 때 진행 |
| 2 | A_DB/05_BACKUP.sql | 현재 원문을 ZB_SSP40_SHIP_20261126C 에 보관 |
| 3 | A_DB/15_DIFF_SOURCE.sql | 진단(조회만). 클라우드 원문과 기준본 B 의 다른 줄 번호, 원문 출력. Output 창 회신 |
| 4 | A_DB/20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql | 클라우드 원문 위에 보완 3곳만 바꿈. 위치마다 표식이 있으면 SKIP, 바꿀 문장을 한 곳에서 못 찾으면 -20011 중단(원문 무변경) |
| 5 | A_DB/90_VERIFY.sql | 기대값 : VALID, ERR_CNT 0, M_DS2, M_OWMSMAX, M_AGINGCUT, M_WHSTKHD 각 1. 클라우드 원문이 사내와 다른 줄이 있으면 SAME_AS_CORP_FINAL = N, LINE_CNT 다를 수 있음 |
| 문제 시 | A_DB/99_ROLLBACK.sql | 05 보관 원문으로 복원 |

- 2026-11-26 15:13 변경 : 처음 판 20(전체 교체, 기준본 A, B 해시 일치 때만)이 클라우드에서 -20011 로 중단됨(줄 3583, 해시 8003433689173, 기준본 B 8003242559807). 패치판 20 으로 바꾸고 15 진단 추가
- 기준본 A = SSP_SHIP_PLAN_40_BATCH_PERF_CLOUD_20261126 적용본(3582줄, 8002014763396), B = A + OWMSMAX 적용본(3583줄, 8003242559807)

## 바뀌는 것

| 표식 | 단계, SQL_ID | 변경 | 클라우드 11-26 회차당 |
|---|---|---|---|
| E20261126-OWMSMAX | 1-1 최근 CUTOFF 조회, 83wgypmy3wyvu | 함수 조건을 `(SELECT 함수 FROM DUAL)` 로 감쌈 | 73 ~ 76초(그날 첫 실행) |
| E20261126-AGINGCUT | 1-6 GT_SCM_DNM_STOCK_AGING_V 적재, awr2c30u4h31c | 바깥쪽 뷰에 `A.DIVISION_ID = V_DIVISION_ID`, `A.ORG_CUTOFF_DATE > SYSDATE - 4` 추가 | 156 ~ 159초 |
| E20261126-WHSTKHD | 2-14 WH_STOCK 적재, aj7nw6qjt4tjv | 본 SELECT 에 `/*+ NO_PUSH_PRED(HD) */` | 111 ~ 133초 |

- AGINGCUT : 조인 조건(B.CUTOFF_DATE > SYSDATE - 5, B.DIVISION_ID = V_DIVISION_ID)에서 나오는 조건을 바깥쪽에 명시함. 뷰 CUTOFF_DATE = 원장 CUTOFF_DATE - 1 이라 ORG_CUTOFF_DATE > SYSDATE - 4 와 같음. 원문은 바깥쪽에서 원장 SCM_AGING_STOCK_H 전체(사내 7,704,590행)를 읽음
- WHSTKHD : 클라우드는 GT_SSP_ANL_SHIP_PLAN_40 을 1행으로 추정해(2차 회신 [C12] 계획 1891027486) Z 행마다 HOLD 집계를 다시 하고 SSP_ANL_HOLD_STOCK 을 인덱스 스킵 스캔함. 힌트 없이 WITH 로 분리한 안은 효과 없음(아래 측정)
- 3단계 최종 INSERT(cy0a8kvgd0cw7, 52 ~ 55초)는 바꾸지 않음. 1행 추정 재현 시 해시 조인 지정 효과 10.68 → 9.31초. 시간 대부분이 1,382,612행 DISTINCT, 저장임

## 사내 ZIOUI1 확인 (2026-11-26)

| 시각 | 항목 | 결과 |
|---|---|---|
| 14:29 ~ 14:31 | 1-6 SELECT 원문 vs 변경(기준 시각 2개, 2회) | 결과 행 단위 같음(5,847행, 수량 합 85,973,549). 33.0 ~ 33.6초 → 1.4 ~ 1.6초. DB 시간 32.32 → 0.31초, 블록 534,017 → 21,354 |
| 14:32:02 | 1-6 사내 적용 | VALID, 오류 0 |
| 14:36 ~ 14:46 | 2-14 SELECT, GTT 1,170,792행, 1행 추정 재현(CARDINALITY(P 1)), adaptive_plans FALSE | 원문 DB 97.5초, 블록 26,027,159(클라우드 23,039,170 ~ 27,330,174). NO_PUSH_PRED 2.37초, 1,116,228. WITH 분리 103.24초. WITH + MATERIALIZE 3.01초. 결과 4안 같음(105,910행, 수량 합 1,961,775,331.181) |
| 14:48:21 | 2-14 사내 적용 | VALID, 오류 0 |
| 14:50 | 2-14 INSERT 문 그대로(1행 추정 재현) | 원문 88.01초 → 적용본 2.47초. 적재 105,910행, 수량 합, 해시 합 같음 |
| 14:51:26 ~ 14:51:33 | 처음 판(전체 교체) 리허설 : A, B 경로 | APPLY → SKIP → 원복 → APPLY. 90 기대값 일치 |
| 15:13:08 ~ 15:13:19 | 패치판 리허설 : B 에서 100줄만 다른 원문(B') → 15 → 20 → 90 → 20, A → 20, 1-6 위치 1칸 다른 원문 → 20 | 15 다른 줄 1건(100줄) 출력. B' : SKIP 1, PATCH 2, VALID, 100줄 유지. 재실행 SKIP 3. A : PATCH 3, 결과 == 사내 최종본. 1-6 위치 다름 : -20011, 원문 무변경 |
| 15:12:59 | 패치판 -20012 경로(주석이 깨진 시험 원문으로 우연히 실행) | 컴파일 실패 → 원문 복원 동작 확인 |
| 15:13:19 | 사내 원문 복원 | 사내 최종본(3589줄)과 같음 |

- 1-1 보완 클라우드 측정(95 회신 2회) : 함수 76.9 / 73.69초 → 스칼라 0.36초(HQ00), 74.01 / 71.37 → 0.85 / 0.84초(NJ00), 71.24 / 72.89 → 0.22초(AZ00). JOIN 0.68, 2.59, 0.22초. [DUP] 0. 결과 같음
- 1-6, 2-14 클라우드 효과는 미측정. 다음 회차 [C4] [C7] [C8] 로 확인
- 클라우드 GTT 1행 추정 원인 미확인. 사내는 같은 설정(dynamic_sampling 2, adaptive_plans FALSE, GTT 1,170,792행)에서 598K 행으로 추정함
- GTT 세션 통계 수집(DBMS_STATS) 안은 쓰지 않음. 사내 시험에서 진행 중 트랜잭션을 커밋함(SP 오류 시 전체 ROLLBACK 이 깨짐)
- 사내 SCM_MGR 에 보관 표 ZB_SSP40_SHIP_20261126C 생성됨

## 클라우드 적용 결과 (2026-11-26 회신)

- 15_DIFF_SOURCE : 기준본 B 와 다른 줄 1건. 1752줄(사내 = 공백 8칸만 있는 빈 줄, 클라우드 출력 = 빈 줄). 공백 차이로 동작 영향 없음
- 20_PATCH : 위치 1(OWMSMAX) SKIP(이미 반영), 위치 2(AGINGCUT), 위치 3(WHSTKHD) PATCH, VALID, 바꾼 위치 2
- 90_VERIFY 결과 미회신. 기대 : VALID, ERR_CNT 0, 표식 4종 각 1, LINE_CNT 3589, SAME_AS_CORP_FINAL N(1752줄 공백 차이)

## 생성
- `_artifacts/_apply_corporate/SHIP_PLAN_40_AGING_20261126/` : build_aging.py(1-6), build_whstk.py(2-14), build_package_perf2.py(이 패키지), a2.py, w2.py, w3.py, s3.py(측정)
- 1-1 : `_artifacts/_apply_corporate/SHIP_PLAN_40_OWMSMAX_20261126/`
