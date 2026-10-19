# 일괄 점검 결과의 수동 판독 (2026-10-14 10:40)

자동 점검 결과는 [00_REPORT.md](00_REPORT.md) · 문장 목록은 `findings.tsv`.
자동 점검이 "같은 계열" 또는 "미판정" 으로 남긴 35문장을 원문으로 다시 봤다.

## 결론
- **정상(VALID) 객체에서 같은 계열 오류로 확인된 문장: 0건** (PKG_DMF0044 는 오늘 보완 뒤 0건).
- 자동 점검이 "같은 계열" 로 잡은 2문장은 이미 INVALID 인 프로시저 1개에 있다 — 이 패턴으로 확정할 수 없다(아래 1).
- 미판정 33문장 = 정상 객체 4문장(수동 판독 결과 이상 없음) + INVALID 객체 29문장(판정 불가).

## 1. 자동 점검이 "같은 계열" 로 잡은 2문장 — 확정 아님
| 객체 | 상태 | 행 | 판독 |
|---|---|---|---|
| PR_SSP_BI_SSP_RESULT_H | INVALID | 250 · 1237 | 컴파일 오류가 따로 있다: `ORA-00904: "B"."DEPT_ID": invalid identifier` (484 · 1465행). 점검 도구는 모르는 이름을 변수로 보고 바꿔 넣기 때문에, 없는 컬럼이 변수로 바뀌면서 ORA-00979 가 부수적으로 나왔을 수 있다. 어차피 실행할 수 없는 상태라 "GROUP BY 불일치" 로 확정하지 않는다. 컴파일 오류를 먼저 풀고 다시 점검해야 한다. |

## 2. 정상(VALID) 객체의 미판정 4문장 — 원문 판독 결과 이상 없음
| 객체 | 행 | 도구가 실패한 이유 | 판독 |
|---|---|---|---|
| PKG_DMF0005 | 1425 | `V_EDI_KEY(K).DIVISION_ID` (배열 레코드) | SELECT 와 GROUP BY 의 날짜 식이 글자까지 같다. 식 안에 변수(`V_EDI_LT`)가 있으나, 같은 꼴의 문장을 작은 조회로 실행해 정상 동작을 확인했다. |
| PKG_DMF0082 | 15580 | INSERT 대상 컬럼 이름이 `V_…` 라 변수로 오인 | 단순 컬럼 + 변수 1개, GROUP BY 와 일치. |
| PKG_DMF0082 | 16419 | 같은 이유 | 단순 컬럼 + 변수 1개, GROUP BY 와 일치. |
| PKG_SCM0016 | 116 | `AT TIME ZONE` · 패키지 내부 함수 | GROUP BY 는 안쪽 조회(OWNER, JOB_NAME)에만 있고 일치. |

## 3. INVALID 객체의 미판정 29문장 — 판정 불가
참조하는 테이블 · 시노님 · 권한이 사내 DB 에 없어 파싱 자체가 되지 않는다. 이 객체들은 이미 INVALID 라 실행되지 않는다.

| 사유 | 문장 | 객체 |
|---|---|---|
| ORA-00942 테이블 없음 | 13 | PR_DM_PLN_CUST_PSI_TO_MKT_FCST · PR_SCM_DNM_MES_STOCK · PR_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY · PR_SCP_ANL_PSI_INTEGRATION_ESS_ELEC_ONLY · PR_SCP_ANL_PSI_INTEGRATION_SMALL_ELEC_ONLY · PR_SCP_MST_FORMATION_COPY_FROM_FP · PR_SCP_MST_TACT_TIME_COPY_FROM_FP · PR_SCP_XLS_PSI_GLOBAL_ESS_S |
| ORA-00980 시노님 대상 없음 | 10 | PR_DM_DNM_EDI_CALL_OFF_HEAD · PR_SCP_MST_FORMATION_COPY_FROM_FP |
| ORA-41900 조회 권한 없음 | 4 | PR_SCP_ANL_LONG_TERM_STOCK_REPORT · PR_SCP_ANL_MONTH_END_STOCK_R |
| 그 밖(문법) | 2 | PR_SCM_MST_SITE_PLANT · PR_SCP_MST_FINAL_ITEM_COPY_FROM_FP |

## 한계
- **사내 DB 기준이다.** 클라우드 원문은 사내와 다른 곳이 있다(오늘 PKG_DMF0044 에서 확인: 빈값 표기 · 들여쓰기 · 주석). 이 결과가 클라우드에도 그대로 성립한다고 볼 수 없다.
- **동적 SQL 은 대상 밖이다.** 문자열로 조립해 실행하는 SQL 중 GROUP BY 가 있는 곳이 60개 객체 · 204곳이다. 이 방법으로는 점검할 수 없다.
- **GROUP BY 가 있는 문장만 봤다.** 그 밖의 실행 시점 오류(자료형 · 데이터 의존)는 대상이 아니다.
- TRIGGER · VIEW 는 대상에 넣지 않았다(패키지 BODY · 프로시저 · 함수만).
