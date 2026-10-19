# 클라우드 배치 장시간(40분+) 실행 식별 — 2026-09-29 ~ 10-01 로그 추출 쿼리

> 질문: "지난주 클라우드에서 BALANCE 배치 잡 기동 시 40분 이상 걸린 적이 있다 — 어느 잡이었는지 로그로 확인"
> 조회 전용 · DB 변경 없음 · **클라우드에서 실행**(사내 ZIOUI1 은 문법·구조 검증만, 2026-10-08).

| 파일 | 내용 |
|---|---|
| [01_longrun_identify_0929_1001.sql](01_longrun_identify_0929_1001.sql) | 추출 쿼리 Q0~Q6 (10 문장). 클라우드 SQL 툴에 그대로 붙여 실행 |
| `_run_check.py` | 사내 ZIOUI1 검증 실행기 (`python _run_check.py [from] [to]`) |
| [02_compact_q2_q3.sql](02_compact_q2_q3.sql) | Q2/Q3/Q2-c 를 행당 한 줄 문자열(C2/C3/C2c)로 압축 — SQL Developer 붙여넣기 5만 자 한도 회피. `_run_check_compact.py` |
| [04_awr_0930_run_cloud.sql](04_awr_0930_run_cloud.sql) | **클라우드 실행용 최종본** — `SET SQLFORMAT ansiconsole` 포함, 03 의 A 섹션만(A1 세션 · A2 SP 분해 · A3 SQL×플랜라인 · A3-b SQL 합계 · A5/A5-b step 타임라인 · A4 플랜 템플릿). 재실행 없음·조회만. 클라우드 P1~P7 결과(10-08): AWR 09-29 02:00~ 보존 → A 가능 · 1461 = 9/14 주차(3주 전) · 메일 SP 2종 구판(SLEEP·항상발송) · 09-29 수동 RUN_JOB 3회가 IRREGULAR SP_W 3개 + 약 300통 메일 생성 |
| [11_rerun_plan1464_cloud.sql](11_rerun_plan1464_cloud.sql) | **재실행 최종본(PLAN 1464 = 최신 계획)** — S1 사전 점검(S1-c 제외시간 게이트 ★) → S2 실행 블록(주석, 블록 안에도 제외시간 게이트: 밖이면 SP 미호출·SKIP, `v_allow_outside` 로만 해제) → S3 실행 중 관찰 → S4 결과(전체/메일/순소요 · SP 분해 · SQL 상위 · C 호출별 · 생성 버전/메일). 사용자 지시 2026-10-08: "P5 를 먼저 확인한 후 실행되도록" |
| [10_view_max_history_cloud.sql](10_view_max_history_cloud.sql) | 뷰 MAX 100초→2초 원인 판별: Z1 SQLSTAT 스냅샷별 PHV·실행당 소요 · Z2/Z2-b 대기이벤트·blocking · Z3 플랜 · Z4 부하 |
| [09_c_qty_balance_plantsite_diff_cloud.sql](09_c_qty_balance_plantsite_diff_cloud.sql) | (기록용, 추적 중단) PLANT_SITE_ID 8줄 차이 원문 |
| [08_r3_2009_and_diff_cloud.sql](08_r3_2009_and_diff_cloud.sql) | R3(10-01 20:09) 분해 · 8줄 차이 · 10-01 ERROR 내용 |
| [07_mail_sleep_split_cloud.sql](07_mail_sleep_split_cloud.sql) | 메일 SLEEP 분리: M1 메일 호출 · M2 실행별 전체/메일/순소요 · M3 잡별 |
| [06_c_qty_balance_after_fix_cloud.sql](06_c_qty_balance_after_fix_cloud.sql) | 보정 후 C 호출 소요 · PLAN_ID 수동 실행 · 주차별 버전 · 판본 마커 |
| [05_c_qty_balance_version_cloud.sql](05_c_qty_balance_version_cloud.sql) | 판본 확인 · DISPLAY_AWR 4종 · C 호출 추이 · 주차별 버전 |
| [03_rerun_plan1461_cloud.sql](03_rerun_plan1461_cloud.sql) | 09-30 51.9분 실행의 **재실행 없는 실측(A: AWR 세션·SP·SQL 분해 + step 로그)** 과, 굳이 재실행할 때의 사전 점검(P1~P7)·실행 블록(B1, 주석)·실시간 관찰(B2)·사후 비교(B3). ⚠ PLAN_ID 지정 재실행은 BALANCE 덮어쓰기·_C 재작성·IRREGULAR SP_W 버전 생성·현업 메일 발송을 수반하고 ROLLBACK 불가(메일 SP COMMIT + GATHER_STATS 27회). `_run_check_03.py`(B1 제외 17문장 사내 검증) |
| `_corp_check_20261008.txt` | 사내 검증 출력(10 문장 전부 정상 실행) |

## 1. 실행 순서 (클라우드)

| 순서 | 쿼리 | 답하는 것 | 결과 읽는 법 |
|---|---|---|---|
| 1 | **Q1** | 3일 동안 돈 **스케줄러 잡** 전부, 소요 순 | `FLAG = ◆ 40분+` 행이 답 후보. `SESSION_ID` 는 Q4 대조 키. 0행이면 잡 소유 계정이 아님 → `ALL_` 을 `DBA_` 로 바꿔 재실행 |
| 2 | **Q2** | 3일 동안 START/END 가 찍힌 **모든 SP** 실행의 소요(10분 이상), 긴 순 | `FLAG = ◆ 40분+` + `CHAIN = BALANCE 계열` 행. `START_PARAMS` 가 사업부/버전. `STATUS = ERROR` 면 `ERR_LINE` 이 실패 줄 |
| 3 | **Q3** | Q2 의 긴 SP 실행이 **어느 잡 구간** 안에서 돌았나 | `JOB_NAME` 있음 = 그 잡이 호출 주체(확정). **NULL = 잡 밖** → 수동 실행(DBeaver/SQL 툴) 또는 화면 CALL (Q2 `CREATED_BY` 가 사용자 계정이면 수동/화면) |
| 4 | Q2-b | BALANCE 호출 체인 SP 전부(짧은 정상 실행 포함) | 같은 SP 의 정상 소요와 비교. 상위(WEEKLY_ROLLING) ⊇ 하위(QTY_BALANCE_CREATE…) 구조 |
| 5 | Q2-c | END/ERROR 없이 끊긴 START | 40분+ 실행이 끝 로그 없이 kill/타임아웃 됐으면 Q2 가 아니라 여기 나옴. 소요는 Q1 `RUN_DURATION` 으로 |
| 6 | Q4 (권한) | 세션 단위 **MODULE/ACTION** | `DBMS_SCHEDULER / 잡이름` = 잡 실행 · `DBeaver…`/`python.exe`/`node.exe` = 수동·앱. `SID_SERIAL` 을 Q1 `SESSION_ID` 와 맞추면 잡↔세션 확정 |
| 7 | Q5 | Q2 1위 실행의 **구간 안 타임라인**(하위 SP 포함) | `GAP_SEC` 큰 행의 직전 구간이 병목 단계. 다른 실행을 보려면 `pick` 의 `FETCH FIRST 1` 을 `OFFSET n ROWS FETCH NEXT 1` 로 |
| 8 | Q6 | 3일 안 모든 ERROR/INVALID | 실패 SP·줄 번호 |

기간 변경: 모든 쿼리 `w` 의 날짜 4 개(`09-29` 시작, `10-02` 종료 미포함, `09-28`/`10-03` 스캔 여유)만 바꾼다.

## 2. 왜 "잡 이름" 만으로 못 찾는가 (사내 정의 전수 126 잡 확인, 2026-10-08)

잡 이름에 BALANCE 가 들어간 잡은 없다. BALANCE SP 가 실행되는 경로:

| 경로 | 잡 | 호출 SP | 비고 |
|---|---|---|---|
| ① 직접 | `JOB_SCMPROD_PLAN_FINAL_40_CREATION` / `…_81_CREATION` | `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(div, NULL)` | 사내·클라우드 모두 DISABLED, runs=0 (10-07 확인) |
| ② 롤링 안 | `JOB_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TOTAL_MOBILE`(일·수~토 00:00) / `…_TUE_TOTAL`(화 00:15) / `…_MON_40`(월 15:00 MF_W) / `…_TUE_SCM_FCST`(월 17:30 SF_W) / `…_MON_82` 등 | `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING(div, …, MF_D/MF_W/SF_W)` → 내부에서 `QTY_BALANCE_CREATE` 호출 | 매일 00시 로그의 실체(10-07 확인). 한 잡이 사업부 여러 개를 순차 호출 |
| ③ Sales Plan | `JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40/81/…` | `PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE(div)` | |
| ④ 잡 아님 | 화면 CALL(PKG_DMF0003 등) / DBeaver 수동 | `QTY_BALANCE_CREATE(div, 'CALL' 또는 PLAN_ID)` | 잡 이력 없음. `CREATED_BY` = 사용자 계정 |

→ Q2 로 "긴 SP 실행" 을 먼저 찾고, Q3 로 잡 구간과 겹쳐 잡을 확정한다. ④ 가 답이면 잡이 아니라 사람/화면이 돌린 것.

## 3. 로그 구조 (판정 근거)

- `SCM_SYS_LOG_BATCH`: SP 마다 자기 START/END/ERROR 를 남김(`PR_DM_SYS_LOG_BATCH` = 세션 계정, `PR_SCM_SYS_LOG_BATCH` = `'scm_batch'` 고정). 인덱스 없음(3일 스캔 ≈ 수 초).
- 짝짓기 규칙 = 같은 `PROGRAM_NAME + CREATED_BY` 에서 START 다음의 END/ERROR (AS-IS `PR_LONGTIME_CHK_SMS_SEND` 의 장기수행 판정과 같은 규칙). 다음 행이 또 START 이면 소요 불명 → Q2-c.
- 잡 블록 다수가 `EXCEPTION WHEN OTHERS THEN NULL` 로 step 을 감싸므로 **잡 STATUS=SUCCEEDED 여도 SP 는 실패했을 수 있음** → 실패는 Q2/Q6 의 ERROR 로 본다.
- `ALL_SCHEDULER_JOB_RUN_DETAILS.RUN_DURATION` = 잡 전체(여러 사업부 순차 호출 합). SP 1건 소요는 Q2.
- AWR/ASH(Q4) 는 보존기간 안에서만(사내 실측 6주). 10초 샘플.

## 4. 사내 검증 결과 (2026-10-08, ZIOUI1 SCM_MGR, 같은 3일 윈도)

- 10 문장 전부 정상. Q1/Q1-b 0행 = 사내 잡 전부 DISABLED(정상). Q4 는 사내 SCM_MGR 도 조회됨(클라우드 계정 권한은 실행 시 확인).
- Q2 1위 = `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` 10-01 16:11:35 → 16:50:36 **39분** END, `{"p_division_id":"82","p_plan_id":"CALL"}`, CREATED_BY=SCM_MGR → Q3 JOB_NAME NULL(잡 밖 = 수동/화면 CALL). 구조가 의도대로 동작함을 확인.
- 클라우드 선행 단서(10-07 메모리): 로그상 Daily Rolling 안의 40/NULL 완주는 5.7~6.5분뿐이고, 40분+ 는 **09-30 15:39~20:19 DBeaver 수동 실행(PLAN_ID 지정 → CUTOFF/C_QTY_BALANCE 경로)** 가능성 — Q2 `CREATED_BY`·Q3 `JOB_NAME`·Q4 `MODULE` 로 이번에 확정.

## 4-2. 클라우드 실행 결과 (2026-10-08, 사용자 실행 · Q1 전체 + C2/C3 전체 + C2c 일부 수신)

**판정: "40분 이상" 은 스케줄러 잡이 아니라 수동 실행된 `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE('40', PLAN_ID 1461)` 1건.**

| 항목 | 값 |
|---|---|
| 실행 | 09-30(수) 15:39:17 → 16:31:13, **51.9분**, END |
| 호출 | `{"p_division_id":"40","p_plan_id":"1461"}` — PLAN_ID 지정 = CUTOFF 경로(A021 → C_QTY_BALANCE → SALES_PLAN_C_QTY_BALANCE 포함) |
| 실행 주체 | CREATED_BY = `SCM_MGR` · C3 `NO_JOB`(어느 잡 구간에도 없음) → DBeaver/SQL 툴 수동 실행. 10-07 ASH 가설(09-30 15:39~ DBeaver 세션)과 일치 |
| 구성 | 본체+C_QTY_BALANCE ≈ 40.3분(15:39:17~16:19:36) + `PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE` 11.6분(16:19:36~16:31:13, 그중 `PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND` **11.0분**) |

- 잡 단위(Q1): 3일간 40분+ 잡 없음. 최장 `…WEEKLY_ROLLING_TUE_TOTAL` 09-29 00:15 20.6분. 전부 SUCCEEDED(ORA-01013 2건·ORA-04065 1건은 아래).
- 같은 인자의 다른 수동 실행: 10-01 14:38 **39.8분**(CREATED_BY `SYSTEM` — SYSTEM 계정 세션), 10-01 20:09 22.7분(SYSTEM), 09-30 16:33 81/1461 22.1분, 17:20 81/1462 19.2분, 10-01 12:59 81/1461 18.7분 — 모두 NO_JOB. 배치 경로(PLAN_ID NULL, Daily Rolling 안) 같은 날 10-01 00:00 TOTAL_MOBILE 전체 15.9분과 대비.
- **메일 대기 잔재(클라우드)**: `PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND` 8회 전부 **정확히 11.0분**, `PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND` 3회 **10.6분** → `JOB_PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40` 12분 중 11분, `…MON_40` 15.5분 중 10.6분이 메일 발송 `DBMS_SESSION.SLEEP` 대기. Q1 의 `ORA-01013 User requested cancel at PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND line 273 (DBMS_SESSION)` 2건도 이 대기 중 취소. 사내는 10-07 제거 완료, **클라우드 이관 패키지 없음**(10-07 메모리).
- `PKG_SDM2010` 1102.2 / 912.6 / 42분 3건: 17:23→다음날 11:46, 18:21→다음날 09:34 형태 = **끝 로그 없는 START 가 다음 실행의 END 와 짝지어진 것**으로 판단(퇴근 전 중단·세션 종료). BALANCE 무관. 확정하려면 Q5 pick 을 OFFSET 으로 바꿔 타임라인 확인.
- C3 오탐: 30분 주기 `JOB_PR_DM_DNM_EDI_CALLOFF` 와 시간만 겹쳐 PKG_SDM2010·SALES_PLAN_C 가 그 잡으로 매칭됨 → `MATCH_KIND`(ACT/TIME) 열 추가(§5 참조). 하위 SP(메일·KRW)는 TIME 이 정상.
- 09-30 19:20 `SALES_PLAN_WEEKLY_ROLLING_81_ST` FAILED ORA-04065 `PR_DM_DNM_SALES_PRICE_EXIST_MAIL_SEND` = 당시 재컴파일 필요 상태(일시).

## 4-3. 클라우드 AWR 실측 결과 (2026-10-08, 04 파일 A1~A5 수신) — hook #129 0-b 완료

**R1 (09-30 15:39:17~16:31:13, 51.9분 = 3,114초) 분해**

| 구간 | 시각 | 소요 | 내용 |
|---|---|---|---|
| 루트 본체 (A001~A020) | 15:39:17~15:44:13 | 5.0분 | `3g9x8t27cmu5k` GT_PRDM2_VMI_MST_MAIN INSERT 190초(당시 구판 — 10-06 클라우드 보정 후 2초) |
| **CUTOFF 루프 ×5** (`PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE`) | 15:44:13~16:19:35 | **35.4분** (회당 ≈7분) | 회당: 뷰 MAX `6nzwwbfd3rzsz`(L155 `PLAN_START <=`) ≈100초 + `0jcr4bqngwpj2`(L278) ≈15초 → **합 580초** · **`3pkngsw1b3vng` GT_DPMFCQB_VMI_MST_MAIN INSERT 플랜 21 INDEX RANGE SCAN ON CPU ≈220초 → 합 1,090초(ASH 44.5%)** · C_WS_RTF 등 ≈60초 |
| SALES_PLAN_C_QTY_BALANCE | 16:19:36~16:31:13 | 11.6분 | 그중 `PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND` **11.0분** = SLEEP(30)×(106명/5) — ASH 에 안 잡히는 유휴 ≈660초 |

- ASH 활동 2,450초 + 메일 유휴 ≈660초 ≈ 3,110초 = 51.9분 — 전량 설명됨.
- **왜 5회인가**: 9/28 주 MF_W 3개(0928 정기, **0929·0930 = 수동 MON_40 RUN_JOB**) + SF_W 2개(0928 정기, **0930 = 수동 TUE_SCM_FCST**). 수동으로 Weekly Rolling 잡을 돌릴 때마다 버전이 하나 늘고, PLAN_ID 경로 1회당 **+7분**. 이번 주(P3)는 MF_W 1·SF_W 1 → 2회.
- `3pkngsw1b3vng` 의 원인 = 루트 L2336 과 같은 계열(END_CUSTOMER 조인 누락 → CFM_C PK 인덱스가 6번째 칸에서 끊김). **사내 `PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE` 2026-10-01 18:43 판(3,092줄, AJS 보정 2곳, L2218 `A.END_CUSTOMER = C.END_CUSTOMER`)에 이미 보정됨.** 클라우드 반영 여부 = 05 V1. (10-01 20:09 수동 실행이 22.7분으로 짧아진 것은 반영 신호일 수 있음 — V3 로 확정)
- 뷰 MAX 580초(회당 ≈115초)는 **미보정** — 루트의 10-07 VIEWONCE 는 배치 경로만. C 안의 L155/L278(+EE L187/L317) 통합·재사용은 hook #129 1-b 후보.
- R2 (10-01 14:38, SYSTEM, 39.8분): 같은 구조. `3pkngsw1b3vng` 1,210초(63%), `3g9x8t27cmu5k` 200초. A3 60행 상한에 걸려 R2 의 뷰 MAX 수치는 미표시.
- 세션(A1): R1 = DBeaver 26.0.4 / LESP01D5424 / SCM_MGR · R2 = DBeaver 25.3.5 / LESP04D3465 / SYSTEM (+ 같은 시각 LESP01D5424 SCM_MGR 190초 세션 별건).

## 4-4. 클라우드 05 결과 (2026-10-08) — 판본·플랜 확정

| SP (클라우드) | LAST_DDL | 줄 | AJS 10-01 | END_CUSTOMER 조인 | 비고 |
|---|---|---|---|---|---|
| PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE | **2026-10-02 15:39:33** | 3,100 | 2 | 1 (L2226) | **보정 반영됨** — 09-30·10-01 두 느린 실행은 모두 그 이전. 사내 3,092줄(10-01 18:43)과 8줄 차 → 06 W3 로 대조 |
| PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE | 2026-10-06 16:16:08 | 3,181 | 4 | 1 | 사내 10-07 VIEWONCE(3,201줄) 미이관 |
| PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE | 2026-08-20 | 1,980 | 0 | 0 | |
| PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND | 2026-08-14 | 271 | 0 | — | 구판: SLEEP(30) L233 · `DB_NAME <> 'LGCE_SCMDEV'`(항상 발송) |
| PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND | 2026-08-14 | 310 | 0 | — | 구판: SLEEP(30) L273 |

- **V2 플랜 확정**: `3pkngsw1b3vng`(보정 전 캡처) 라인 21 = `PK_DM_PLN_CFM_MKT_DEMAND_PLAN_C_PART` INDEX RANGE SCAN, access 에 END_CUSTOMER 없음(DIVISION/VERSION/CUTOFF_TYPE/CUTOFF_YYYYMMDD/PROJECT/SITE/ITEM/…) → 행마다 END_CUSTOMER 범위를 훑음. 상위는 CFM_C(W) PK 부분탐색 → SCM_MST_SITE → **달력 38일 MERGE JOIN CARTESIAN** → CFM_C(C) NL 재탐색. 루트 `3g9x8t27cmu5k` 라인 18 도 동형(PK_DM_PLN_CFM_MKT_DEMAND_PLAN). 10-07 메모리의 가설과 1:1 일치.
- `6nzwwbfd3rzsz`(뷰 MAX, `PLAN_START <= :B1`): SCP_PLAN_VERSION_V 윈도정렬 + SCM_MST_PLAN FULL + SCP_PLN_ALLOCATION PARTITION RANGE ALL + `TH_ENG_NET_DEM…` 인덱스를 `SYS_OP_C2C`(문자셋 변환) 로 탐색 + `FN_SCM_SPLIT` REGEXP 필터 + `FN_GET_BUCKET_YYYYMMDD(-24)` 함수 술어 → 회당 ≈100초. `0jcr4bqngwpj2` 동형. **미보정(사내도)** — 1-b 후보.
- V3(보정 전 09-30): 40 사업부 C 호출 5회 4.9~5.6분, 81 사업부 1.3~2.6분(c_plan_id 1463 사용 — C 는 P_PLAN_ID 와 무관하게 자기 기준일로 계획을 다시 고름). 보정 후 호출은 06 W1 로 확인.

### 사내 C_QTY_BALANCE 판본 대조 기준 (06 W3/W3-b 와 비교)
- 사내 2026-10-01 18:43 판: total 3,092 · blank 0 · `--` 주석 11 · GATHER_TABLE_STATS 0 · SCP_PLN_RTF_ALLOCATION_V 참조 13 · PR_SCM_SYS_LOG_BATCH 호출 7
- 헤더 이력 마지막 3줄: L77 `2026.05.07 JSSBAE [E20260507-000749]` · L78 `2026.05.13 JSSBAE [E20260512-000502]` · L79 `2026.07.06 ZIONEX [PJ202650304]`. 본문 마커: L718 `-- 2026.09.11 AJS`(FROM_ITEM_ID 조인) · L2184/L2215 `2026.10.01 AJS`(END_CUSTOMER). 클라우드(3,100줄)가 이것 외의 마커를 가지면 클라우드에만 있는 변경.

## 4-5. 메일 발송(SLEEP) 분리 — 사용자 지시 2026-10-08 "방식 변경 예정이라 전체에서 제외"

메일 SP 1회 = 수신자 106명 / 5명마다 SLEEP(30) ≈ 21회 × 30초 = **10.5분 대기 + 발송 ≈0.5분 = 11.0분**(IRREGULAR) · 10.6분(WEEKLY_ROLLING). 07 파일 M1~M3 이 실행별로 자동 분리한다. 지금까지 수신한 수치로 분리하면:

| 실행 | 전체 | 메일(SLEEP 포함) | **순소요** | 순소요 구성 |
|---|---|---|---|---|
| R1 09-30 15:39 QTY_BALANCE(40, 1461) 수동 | 51.9분 | 11.0 | **40.9분** | 루트 5.0 + C_QTY_BALANCE ×5 35.4 + SALES_PLAN_C 비메일 0.5 |
| R2 10-01 14:38 QTY_BALANCE(40, 1461) 수동 | 39.8분 | 11.0 | **28.8분** | 루트 ≈4 + C ×5 ≈24 + 0.5 |
| 10-01 20:09 QTY_BALANCE(40, 1461) 수동 | 22.7분 | 11.0 | **11.7분** | |
| 잡 SALES_PLAN_WEEKLY_ROLLING_40 (6회) | 11.5~12.0 | 11.0 | **0.5~1.0분** | 거의 전부 메일 |
| 잡 MKT_FCST_WEEKLY_ROLLING_MON_40 (MF_W) | 15.2~15.5 | 10.6 | **4.6~4.9분** | |
| 잡 MKT_FCST_WEEKLY_ROLLING_TUE_SCM_FCST (SF_W) | 15.4 | 10.6 | **4.8분** | |
| 잡 WEEKLY_ROLLING_TOTAL_MOBILE (MF_D, 10-01 00:00) | 15.9 | 0 (MF_D 는 메일 없음) | **15.9분** | 사업부 8개 순차 |
| 잡 WEEKLY_ROLLING_TUE_TOTAL (09-29 00:15) | 20.6 | 82 MF_W 메일 포함 — M3 로 확정 | — | |

→ 메일을 빼면 **PLAN_ID 수동 실행의 순소요 40.9분 중 35.4분(87%)이 C_QTY_BALANCE 5회**, 그중 1,090초가 10-02 보정으로 해소된 문장. 보정 후 기대 순소요(버전 2개 기준) ≈ 루트 2.3 + C 2회 × ≈2.5 + 0.5 ≈ **8분**, 뷰 MAX 까지 고치면 ≈ 4분.

## 4-6. 클라우드 06 결과 (2026-10-08)

- **W1 = 0행**: 10-02 15:00 이후 클라우드에서 C_QTY_BALANCE 호출 없음 → **보정 후 실측치 없음**. PLAN_ID 경로 마지막 실행 = 10-01 20:09(22.7분, 순 11.7분).
- W1-b (10-01 PLAN_ID 수동 실행 전부): 12:33 81/1461 중첩 · 12:59 81/1461 18.7 END · 13:54 40/1461 3.8 **ERROR** · 14:33 40/**1462** 중첩(SCM_MGR) · 14:34 40/1461 중첩(SCM_MGR) · 14:38 40/1461 39.8 END(SYSTEM) · **18:31/18:53/19:06/19:26 40/1461 ERROR 0.3~0.5분 4회** · 20:09 40/1461 22.7 END · 10-02 13:46 81/CALL 0.1(SCMP_APP = 화면). → 14:33~14:38 에 SCM_MGR 과 SYSTEM 두 세션이 겹쳐 실행. 18:31~19:26 의 4회 ERROR 는 배포 중 오류(ORA-04068/06508)일 가능성 → 08 X5. 그렇다면 20:09 실행이 **C 보정 후 첫 실행**이고 순 11.7분 = 루트 ≈5(구판) + C 5회 ≈6.7(회당 ≈1.3) → 08 X1~X3 로 확정.
- W2: 9/28 주 **SP_W 11개**(수동 SALES_PLAN_WEEKLY_ROLLING_40 + IRREGULAR), MF_W 3·SF_W 2. 10/05 주 SP_W 4. 9/21 주 SP_W 3.
- W3/W3-b: 클라우드 3,100줄 = 사내 3,092 + **`--` 줄 8개**(11→19). 공백 0·GATHER 0·뷰 참조 13·로그 호출 7·헤더 이력(L56~79)·본문 마커 전부 동일, 마커 오프셋 L725 까지 0 → L875 +4 → L1068 +8 → 끝까지 +8. 즉 L726~L874 와 L892~L1067 사이에 `--` 로 시작하는 줄 4+4개가 클라우드에만 있음. 설명문이면 무해, 주석 처리된 코드면 로직 차이 → 08 X4 로 원문 확인. **사내 `--` 11줄 기준**: L172·173·176(E20241211 주석) · L717(`-- AND A.ITEM_ID = B.ITEM_ID`) · L1276(PRINT) · L1589·1618·1650·1723(컬럼 목록 주석) · L2942·3030(컬럼 목록 주석). 클라우드 X4 결과에서 이 11줄(오프셋 +4/+8 적용) 외의 8줄이 추가분.

## 4-7. 클라우드 08 결과 (2026-10-08) — 보정 후 첫 실행(R3) 실측 + 판본 차이 발견

**R3 = 10-01 20:09:01~20:31:43 (22.7분)** — X5 로 10-01 저녁 배포가 확인됨: 13:58 ORA-00001 PK_CFM(ATTRIBUTE 복사 미보정) → 18:31/18:53/19:06 ORA-01400 `GT_PRDM2_FP_STOCK_QTY.SCM_SITE_ID`(GTT 구 DDL) → 19:26 ORA-00001 → **20:09 성공**. 즉 18:30~20:09 사이에 GTT DDL 과 SP 보정이 순차 반영되었고 R3 가 **보정 후 첫 완주**.

| 구간 | 소요 | 비교(R1 보정 전) |
|---|---|---|
| 루트 본체 | 1.5분 (20:09:01~20:10:29) | 5.0분 → 루트 VMI INSERT `3g9x8t27cmu5k` 가 상위 20에 없음(10초 미만) |
| C_QTY_BALANCE ×5 | **9.6분, 회당 1.9분** (20:10:32~20:20:06) | 35.4분, 회당 7분 |
| SALES_PLAN_C 비메일 | 0.6분 | 0.6 |
| 메일(SLEEP) | 11.0분 (20:20:43~20:31:43) | 11.0 |
| **순소요** | **11.7분** | 40.9분 |

- 보정된 VMI INSERT = 새 SQL_ID `1nc5at1kvv06s`(END_CUSTOMER 조인 포함, **PHV 3514962743 동일** — 조인 열이 같은 PK 인덱스의 access 에 추가되어 plan hash 는 안 바뀜) **220초 = 회당 44초**(보정 전 218초). 5배 개선, 잔여 44초는 달력 38일 CARTESIAN × PK 재탐색 구조 자체.
- **뷰 MAX(6nzwwbfd3rzsz / 0jcr4bqngwpj2) 가 R3 상위 20에 없음** — C START 전 간격이 R1 101~120초 → R3 **11초**. 코드 변경 없이 10배 차 = 부하·캐시 의존(09-30 15:39 에는 같은 PC 의 python 세션 2개가 2시간씩 동시 실행 중이었음, 04 A1/Q4). 1-b 우선순위 **하향**, 재측정 후 판단.
- R3 잔여 C 회당 1.9분 구성: VMI INSERT 44 + `9nrrfxjtcj8xd` MKT_FCST_C BALANCE DELETE 14 + `aq7z2saw11yds` MKT_FCST_C INSERT 12 + C_WS_RTF 5~13 + 기타.

**판본 차이(X4 + 사내 대조)**: 클라우드에만 있는 `--` 8줄 = L745·762·780·797·930·944·965·984 `, CASE WHEN A.DIVISION_ID IN ('82','40') THEN ' ' ELSE A.PLANT_SITE_ID END AS PLANT_SITE_ID` (ORIGIN_DIVISION_ID 변형 포함). **사내에서는 같은 8줄이 활성 코드**(L745·761·778·794·926·939·959·977). 클라우드 총 +8 = 주석 8줄이 추가된 것이므로 그 자리에 **대체 활성 줄**이 있을 것 → 82/40 사업부 RTF_SCP 적재 시 PLANT_SITE_ID 공백 접기(사내) vs 원값 유지(클라우드?) 의 **로직 차이 후보**. 09 Y1~Y4 로 확정. 10-02 15:39 클라우드 재배포 때 들어간 변경으로 추정(사내 미반영 또는 클라우드 전용) — [[feedback_corp_pkg_overwrite_trace_method]] 절차로 출처 추적 필요.

## 4-8. 클라우드 09 결과 (2026-10-08) — PLANT_SITE_ID 차이 확정 → **사용자 지시로 확인 대상에서 제외**

- 클라우드 C_QTY_BALANCE(10-02 15:39 판): 82/40 사업부 PLANT_SITE_ID 자리표시자 `' '` → `'-'` 로 8곳(SELECT 4 + GROUP BY 4) 변경, 첫 블록은 `DIVISION_ID` → `ORIGIN_DIVISION_ID` 로도 바뀜(L746·763). 사내 C 판과 양쪽 루트 QTY_BALANCE_CREATE(L1870·1886·1955·1971)는 `' '` 유지. 변경 마커 없음.
- 참고: 사내 데이터는 MKT_FCST·CFM_C 의 40/82 PLANT_SITE_ID 가 이미 전부 `'-'`(PLANTNORM 2026-08-04 단일화) → 코드의 `' '` 는 적재 시점 정규화에 가려져 있을 가능성. **2026-10-08 사용자 지시: "PLANT_SITE_ID 는 현재 확인 대상에서 제외" — 추적 중단.** 09 파일은 기록용으로 보존.

## 4-9. 클라우드 재실행 (2026-10-08 13:30:46, 11 S2, PLAN 1464, SCM_MGR SID 948, 제외시간 안) — **C_QTY_BALANCE 첫 호출에서 ORA-00979 실패**

- 루트 본체: 13:30:46 → KRW 종료 13:33:08 ≈ **2.3분**(09-30 5.0분, 기대값과 일치).
- CUTOFF 블록 첫 C 호출(DBMS_OUTPUT `MF_W_20261006_V001`) → **`ORA-00979: "C"."VMI_YN" GROUP BY` at PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 728행** → 루트 EXCEPTION → CODE=0 / MSG=`[[[-20001]…` 반환, 전체 2분 34초.
- **원인 = 클라우드 10-02 15:39 판의 클라우드 전용 변경(PLANT_SITE_ID `' '`→`'-'`) 첫 블록**: 원래 GROUP BY 줄(사내 L761, 클라우드 L762 주석) 끝의 `, A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP` 이 대체 줄(클라우드 L763)에서 **빠짐**. 나머지 3 블록(L798→799, L945→947, L985→986)은 tail 이 남아 정상. 사내 10-01 18:43 판은 정상(L761 tail 포함). → 클라우드에서 PLAN_ID 경로(화면·수동·향후 SCP 연동) 는 10-02 15:39 이후 전부 이 지점에서 실패한다. 10-05/10-06 루트의 ORA-00979(구판 L1858/1939) 와 같은 편집 계열.
- **COMMIT 영향 — 정정(사내 원문 L501~650 확인)**: C 는 728행 **전에** 실테이블 DELETE 를 실행한다 — `DM_PLN_MKT_FCST_C`(L501: 40 사업부, 측정값 ∈ GT_DPMFCQB_MEASURE_MF_ALL = VMI_In_Plan·AS_In_Plan·SS_LVL·SS_GAP·RTF_PR·RTF_SYS_RP·RTF_SCP·RTF, 전극 ITEM 제외, 사용자 수정 이력(RTF_EXCEPTION_ITEM) 없는 행만) + L550/559 RTF + `DM_PLN_CFM_MKT_DEMAND_PLAN_C`(L589~650 동형). 대상 버전 = 첫 루프 **MF_W_20261005_V001** (DBMS_OUTPUT 의 `MF_W_20261006_V001` 은 L246 `V_CUT_OFF_VERSION_81` 출력, 처리 버전 아님). 재삽입(L1193~)은 미실행 → **그 버전의 RTF 계열 스냅샷 행이 삭제된 채 COMMIT 됨**. 루트 본체(BALANCE, 1464)는 00시 롤링과 동일해 영향 없음. SF_W 버전은 미도달.
- **12 D1~D3 결과(13:4x 실행): 실테이블 영향 0** — MF_W_20261005_V001·SF_W_20261005_V001 × MKT_FCST_C·CFM_C 의 모든 측정값(BALANCE 43만 ~ RTF 19 행)이 13:30:00 플래시백과 현재 행수·QTY 합 **완전 일치**(lost_rows 전부 0). MAX(LAST_UPDATE_DATE) 10-05 → 13:30 이후 변경 없음. L501~650 DELETE 가 0행에 매칭된 것(조건 NOT IN/NOT EXISTS 가 걸러낸 것으로 추정, 미확정). **복구 불필요, D4 사본 생성 불필요.** D0 로 처리 버전 = MF_W_20261005_V001 / c_plan_id 1464 확정.
- **수정분(사용자 지시 "사내 소스 기준 클라우드 반영")**: `_artifacts/_deploy_packages/C_QTY_BALANCE_CORPSYNC_CLOUD_20261008/` — 사내 10-01 18:43 판(3,092줄) 원문 무변경 덤프 + 02_VERIFY. 사내 판에는 이 오류가 없으므로 코드 수정 없음. 적용 시 클라우드 전용 8줄(PLANT_SITE_ID '-' 등)이 사내 값으로 되돌아감(패키지 README §3). 클라우드 L763 1줄 패치 스크립트는 도구가 "운영 배포" 로 거부해 미작성.
- 재발 방지: 11 S2 블록을 **MSG='SUCCESS' 일 때만 COMMIT, 아니면 ROLLBACK** 으로 수정(2026-10-08). 그 수정에서 바깥 `/* */` 안에 `/* */` 를 넣어 주석이 조기 종료 → 13:45 재실행 때 IF/COMMIT/ROLLBACK 줄이 단독 실행됨("커밋 완료/롤백 완료", 대기 트랜잭션 없어 무해, SP 는 미호출). 줄 주석으로 정정.
- **13:30 실행의 루트 분해(S4-b/c, 1초 ASH 131초)**: BALANCE DELETE `242jv1rzat1x7` 20s · MKT_FCST INSERT `630stwpcj5tr1` 13s · MST_ACCUM 9s · CFM BALANCE DELETE 8s · 뷰 MAX(PLAN_START) `3uh72s3j2h3xh` 7s · 뷰 MAX(PLAN_ID) `6nzwwbfd3rzsz` **3s, PHV 3672023246**(09-30 은 PHV 4211265331 로 회당 100초) → **뷰 MAX 100초→2초 = 실행계획 교체(가설 A) 로 기울음**, 10 Z1 로 확정. step: A001→A007 13s · A007→A010 24s · A018→A019 30s · A019→KRW 25s · KRW 13s = 10-07 실측(138초)과 동일 패턴. 루트 SP 는 실패 시에도 CODE='0' 을 돌려주고 ROLLBACK 을 호출자에 위임하므로 호출 블록이 판정해야 한다.
- 측정은 **루트 2.3분까지만 유효**. C 회당 소요 비교는 클라우드 C 수정 후 재실행 필요.

## 4-10. 클라우드 재실행 2차 (2026-10-08 14:03:58~14:11:44, 11 S2, PLAN 1464, SCM_MGR SID 948, 제외시간 안) — **SUCCESS, 전체 7분 46초**

- 패키지 `C_QTY_BALANCE_CORPSYNC_CLOUD_20261008` 적용 후 실행. MSG=SUCCESS, COMMIT. 메일 0(제외시간 → IRREGULAR 분기 전체 건너뜀, SALES_PLAN_C 미수행).
- 분해(DBMS_OUTPUT 기준): 루트 본체 14:03:58~14:06:04 ≈ **2.1분** · C_QTY_BALANCE 2회 14:06:04~14:11:44 ≈ **5.7분(회당 ≈2.8분)**. S4-d 로 회당 정밀값 확인 예정.
- 비교(메일 제외 순소요): 09-30 = 루트 5.0 + C 5회 35.4(회당 7.0) → 오늘 = 루트 2.1 + C 2회 5.7(회당 2.8). **회당 7.0분 → 2.8분**, 같은 5회 환산 시 40.9분 → ≈16분.

**S4 실측(1초 ASH · step 로그, 14:04:16~14:11:44 = 7.5분, 메일 0)**

| 구간 | 소요 | 내용(1초 ASH 상위) |
|---|---|---|
| 루트 본체 (START 14:04:16 → A021 14:06:04) | 1.8분 (+GTT 초기화 18초) | BALANCE DELETE `242jv1rzat1x7` 39s(2회 합) · MKT_FCST INSERT 25s · MST_ACCUM 15s · 뷰 MAX `6nzwwbfd3rzsz` **8s(2회 합, PHV 3672023246)** |
| C #1 MF_W_20261005_V001 (14:06:07~14:09:05) | **3.0분** | START→C_WS_RTF 56s(VMI INSERT `1nc5at1kvv06s` ≈42s/회) · C_WS_RTF 8s · →END **114s**(= `9nrrfxjtcj8xd` MKT_FCST_C BALANCE DELETE 77s/2회(그중 물리읽기 대기 47s) · `aq7z2saw11yds` MKT_FCST_C INSERT 53s/2회 · CFM_C DELETE 19s · CFM_C INSERT 18s) |
| C #2 SF_W_20261005_V001 (14:09:23~14:11:44) | **2.4분** | 67s + 4s + 70s, 구성 동일 |
| SALES_PLAN_C / 메일 | 0 | 제외시간 → IRREGULAR 분기 전체 건너뜀 |

- **잔여 비용의 중심이 바뀜**: 보정 전 C 회당 7분의 절반이 VMI INSERT(218s) 였으나, 지금 C 회당 2.7분 중 가장 큰 것은 **_C 테이블 BALANCE 측정값 DELETE+INSERT(회당 ≈85초, 버전당 42.6만 행 전량 재작성)** 이고 VMI INSERT 는 ≈42초, 뷰 MAX 는 ≈3초. 다음 후보(hook #129, 승인 후): ① `9nrrfxjtcj8xd` DELETE 의 물리읽기 47s(인덱스 경로·파티션 확인) ② BALANCE 42.6만 행 DELETE/INSERT → 변경분만 MERGE 가능 여부(1-b, 결과 동치 검증 필수) ③ VMI INSERT 달력 CARTESIAN 구조.

## 4-11. 추가 튜닝 착수 (2026-10-08 사용자 결정) — 목표 **C_QTY_BALANCE 회당 30초 이하**(현재 144~180초)

- 원칙(사용자): 후보 순서 선입견 없이 **루트·C 전체 세션의 소요 분포를 먼저 정확히 판정**한 뒤 진행 = hook #129 0-a(전수) → 0-b(플랜 라인).
- 도구: [14_full_breakdown_1404_cloud.sql](14_full_breakdown_1404_cloud.sql) — 14:04 실행의 1초 ASH 를 ROOT / C1 / GAP / C2 구간으로 나눠 K1 대기클래스 · K2 전 문장(≥2s) · K3 플랜 라인(≥5s, 읽던 객체) · K4 DISPLAY_CURSOR 4종 · K5 V$SQL 누적 · K6 로그 간격 대비 ASH 커버리지(DB 밖 시간). **V$ASH 보존 안(수 시간)에 실행**, 지나면 dba_hist(10초) 로 전환.
- 30초 목표의 의미: 현재 C 회당 구성(≈ VMI INSERT 42 + _C BALANCE DELETE/INSERT 85 + C_WS_RTF 6 + 뷰 MAX 3 + 기타 ≈30) 중 **두 큰 블록을 각각 10초 이내**로 내려야 도달 — 문장 튜닝이 아니라 "버전당 42.6만 행 전량 재작성" 과 "달력 38일 CARTESIAN × PK 재탐색" 구조 자체를 바꾸는 작업이 될 가능성이 높다. 결과 동치 검증(사내 40/81/82) 필수.

## 4-12. 14 K0~K6 결과 (2026-10-08 14:04 실행, 1초 ASH 444 샘플 수신) — **전체 분포 확정 + 구조 사실 + 후보 순위** (hook #129 0-a/0-b 완료)

**K1 구간 분포 (벽시계 466초 = 7분 46초)**

| 구간 | 벽시계 | ASH | CPU | I/O | Cluster | DB 밖(미샘플) |
|---|---:|---:|---:|---:|---:|---:|
| ROOT 14:03:58~14:06:07 | 129 | 108 | 94 | 5 | 5 | **21** (A007→A010 구간 15초, 원인 미확정 — 통계 병렬도 1 이라 PX 유휴 아님) |
| C#1 MF_W 14:06:07~14:09:05 | 178 | 177 | 123 | 42 | 11 | 1 |
| GAP(=C#2 서두 GTT 초기화) 14:09:05~14:09:23 | 18 | 18 | 17 | 0 | 0 | 0 |
| C#2 SF_W 14:09:23~14:11:45 | 142 | 141 | 108 | 26 | 7 | 1 |

**C 회당 구성 (K2/K5, 2회 합 ÷ 2 · 회당 평균 169초)**

| 순위 | 블록 | 문장 | 회당 초 | 비중 | 근거(K3/K5) |
|---:|---|---|---:|---:|---|
| ① | _C 테이블 BALANCE 전량 삭제+재삽입 (MKT_FCST_C + CFM_C, C SP L2814~2851) | `9nrrfxjtcj8xd` DELETE 38 · `aq7z2saw11yds` INSERT 27 · `19b6bty7zk5bu` 9 · `fx7r3yjtr7990` 9 | **84** | 49% | 회당 삭제 42.6만/삽입 37.7만 행(CFM_C 43.2만/38.2만). INSERT 버퍼 2,044만/37.7만 행 = 행당 54 블록 = **인덱스 6개 유지비**. DELETE 의 물리읽기 38초는 `IDX_DM_PLN_MKT_FCST_C_SUPPLY`(버전이 선두 아님 → 리프 산재) |
| ② | VMI_MST_MAIN INSERT (C SP L2154, 40 분기) | `1nc5at1kvv06s` | **43** | 25% | 100% CPU, 2회 **1억 854만 버퍼로 1만 4천 행** 출력. K3 line 21 PK 인덱스 탐색 77초 = NL 프로브가 **PARTITION RANGE ALL**(모든 파티션 로컬 인덱스) · 달력 CARTESIAN · E-Rows 전부 1 |
| ③ | GTT 초기화 DELETE 22문장 (C SP L114~135, 2회차만 부피 있음) | `08scs9480v52a` ACCUM 6 · `bx3u5b3yf9rvw` CUTOFF_MST 6 · TEMPX 2 | **14~18** | 5~10% | ACCUM 92.8만 행/회. TRUNCATE 는 **사내 실측 COMMIT 유발**(아래) → 부모 트랜잭션 설계상 불가 |
| ④ | 기타 (C_WS_RTF 4~8 · ACCUM WINDOW SORT 4 · `0m8x8bt5uuc33` 4 · 뷰 MAX 3 · 나머지) | — | ≈25 | 15% | 뷰 MAX 는 PHV 3672023246 회당 2~3초로 안정 |

**ROOT 129초 구성(K2)**: `242jv1rzat1x7` DM_PLN_MKT_FCST BALANCE DELETE 19 · `630stwpcj5tr1` INSERT 12 · **GTT DELETE 10문장 ≈38초**(bv4t/21hh/2uaj/b2sq/0cht/498y/d6b9/2p5m/259u/4d24) · MST_ACCUM 6 · 뷰 MAX 2 · 미샘플 21.

**사내(ZIOUI1) 에서 확인한 구조 사실 (2026-10-08)**
- `DM_PLN_MKT_FCST_C`(4,012만 행, 109 파티션) / `DM_PLN_CFM_MKT_DEMAND_PLAN_C`(923만 행, 17 파티션) = RANGE INTERVAL(7일), **파티션 키 = 가상컬럼 `CUTOFF_YYYYMMDD_DATE` = `TO_DATE("CUTOFF_YYYYMMDD",'YYYYMMDD')`**. SP 는 문자 `CUTOFF_YYYYMMDD` 로만 조건 → 프루닝 0. 사내 최신 파티션 불일치 행 0.
- MKT_FCST_C 인덱스 6개(PK 5.8GB · N3 4.3GB · SUPPLY 2.7GB · N1 2.1GB · SUPPLY_VERSION 1.4GB · IX03 1.2GB = 17.5GB > 테이블 6.9GB). 사내 DBA_INDEX_USAGE 는 6개 모두 당일 사용 이력 있음(IX03 2,435 · SUPPLY 811 접근). 병렬도 전부 1. 트리거 0.
- GTT 22개 ON COMMIT PRESERVE ROWS, 인덱스 0. **`TRUNCATE` 는 GTT 라도 COMMIT 을 유발**(사내 실측: 다른 GTT 1행 INSERT → TRUNCATE → ROLLBACK 후 1행 잔존).
- **후보② 등가 검증(사내 MF_W_20260824_V001/40, 주차 100)**: 파티션 키 조건 2곳 추가 전/후 **(1,402행 · QTY 합 73,290 · 키 해시) 완전 일치**, 플랜 `PARTITION RANGE ALL`(Pstop 1048575) → **`PARTITION RANGE SINGLE`(557)**. 사내는 통계가 좋아 양쪽 모두 HASH JOIN(클라우드의 NL+CARTESIAN 은 최신 파티션 통계 부재 = E-Rows 1 때문으로 추정, 15 L1-e 로 확인). 사내 소요는 캐시 워밍 후 양쪽 0.1초(출력 1,402행, 사내 데이터가 작아 클라우드 부피 재현 불가; 첫 실행 54초는 콜드 캐시) → **소요 효과의 판정은 클라우드 15 L4 가 유일**.
- **후보① 일간 변화율 대리(사내 MF_D_20260824→0825 BALANCE 21.1만 키)**: 동일 158,313(**75%**) · 값 변경 29,625(14%) · 신규 13,898(6.6%) · 소멸 9,583(4.5%) → 전량 재작성 80만 행-연산 대신 **≈5.3만 행-연산(1/15)** 으로 줄일 여지.

**후보 순위 (30초 목표 역산 — 승인 전 적용 없음, 힌트 0)**
1. **② 파티션 키 조건 추가** (`W.`/`C.CUTOFF_YYYYMMDD_DATE = TO_DATE(C_CUTOFF_YYYYMMDD,'YYYYMMDD')`, C SP 40/else 분기 2문장 + 같은 패턴의 _C 조회·삭제 전부). 가상컬럼 정의상 결과 불변. 기대 43 → **≤5초**. 같은 조건을 ①의 DELETE 4문장·`0m8x8bt5uuc33`·`achpqsdmpwpha`·`ftquxsqy458u3` 에도 적용(물리읽기 축소).
2. **① BALANCE 전량 교체 → 변경분 MERGE** (TEMPX 집계 vs 기존 BALANCE 를 단일 파티션에서 해시 비교: 값 변경 UPDATE · 신규 INSERT · 소멸 DELETE). 기대 84 → **10~15초**. ⚠ 행동 차이 1건 사용자 결정 필요: 현재는 전 행의 `CREATED_BY/CREATION_DATE/LAST_UPDATE_DATE` 가 매 실행 SYSDATE 로 갱신되나 MERGE 는 변경 행만 갱신(미변경 행의 감사컬럼 유지). 이 값을 읽는 하류가 있으면 UPDATE 로 전 행 갱신 가능(그만큼 효과 감소).
3. **③ GTT 초기화**: TRUNCATE 불가 → ACCUM 92.8만 행 자체를 줄이는 길만 있음(ACCUM 은 CUTOFF_MST 의 WINDOW SUM 사본. TEMPX 집계를 CUTOFF_MST 에서 직접 WINDOW+GROUP 으로 만들면 ACCUM 적재 4초 + 초기화 6초 + 예외 DELETE 가 사라짐). 기대 14~18 → ≈4초. 구조 변경이므로 동치 검증 필수.
4. **인덱스 6개 유지비**(①의 잔여): 15 L1-d 로 클라우드 사용 이력 확인 후 미사용 인덱스가 있으면 사용자 결정(DDL). 없으면 손대지 않음.
- 합산 기대: 169 → ② 5 + ① 12 + ③ 4 + ④ 25 ≈ **46초**. 30초는 ④(C_WS_RTF·WINDOW SORT·뷰 MAX 등 ≈25초)까지 손대야 도달 — 1~3 적용 후 재측정하고 결정.
- ROOT 는 목표 밖이나 같은 처방(GTT DELETE 38초는 줄일 수 없음 · 미샘플 21초 원인은 다음 실행에서 10046 트레이스(`V$DIAG_TRACE_FILE_CONTENTS`)로 확정 가능).

**다음 단계**: 클라우드에서 [15_c_qty_balance_tuning_facts_cloud.sql](15_c_qty_balance_tuning_facts_cloud.sql)(조회만, 사내 16 문장 검증) 실행 → L1 사실 동일 여부 · L2 탐색 부피 · L3/L4 ②의 플랜·동치·소요 · L5 변화율 · L1-d 인덱스 사용 이력 수신 후 1~3 의 수정안(사내 소스 기준, 40/81/82 동치 검증 포함) 작성.

## 4-13. ②③④ 개선 진행 (2026-10-08 사용자 결정 "② 파티션 키 · ③ ACCUM 사본 제거 · ④ 인덱스 유지비 — 확인 후 신중히 진행", ① MERGE 제외)

- **산출물**: `_artifacts/_deploy_packages/C_QTY_BALANCE_PRUNE_ACCUM_CLOUD_20261008/` (01 신판 3,128줄 · 02 검증 · 03 구판/신판 연속 실행 + 플래시백 동치 비교 + ASH 소요 비교 · 04 diff 38 hunk · README §4 = ④ 검토).
- **사내 적용 2026-10-08 16:08:19** — FRESH-GATE: 15:46 덤프 후 16:02 LAST_DDL 변동 감지 → 재덤프 diff 0(의존 재컴파일) → 원문 동일성으로 통과. VALID · 오류 0 · 의존 7객체 VALID · SCMP_APP EXECUTE 유지.
- **② 32곳**(_C 테이블의 `CUTOFF_YYYYMMDD = C_CUTOFF_YYYYMMDD` 전부) + 변수 `C_CUTOFF_DATE`(TO_DATE 실패 시 NULL). 제외 4곳 = CTE 조인 2 · GTT 2. 버전만으로 거르는 접근은 정의적 동치가 없어 미변경.
- **③** ACCUM INSERT/예외 DELETE/초기화 제거, TEMPX 를 CUTOFF_MST 인라인뷰(윈도 누적합) + NOT EXISTS 로 직접 적재. TEMPX 예외 DELETE 는 원문 유지(0행).
- **등가 검증(사내)**: T2 ② 8문장 × 40/81/82 = 24/24 SAME(전체 파티션 36~55초 → 0.02초) · T1 ③ GTT 파이프라인 40/81/82 = 3/3 EQUIVALENT(예외 381/781/348행 실제 제거 상태) · VMI SELECT 1,402행 일치. **E2E 는 사내 미실행**(C_WS_RTF 중간 COMMIT → 롤백 불가, 공유 스냅샷 재작성) → 클라우드 03 R1/R3/R4 로 대체.
- **④ 결론 = DDL 미적용**: 사내 DBA_INDEX_USAGE·V$SQL_PLAN 상 6개 모두 사용 중이고 접근 패턴이 서로 대체 불가(VERSION_NO 단독 2.96M · CUTOFF 단독 · 존재확인 8.5M). 삭제 근거 없음. 클라우드 L1-d 확인 후 0 접근 인덱스가 나오면 INVISIBLE→관찰→DROP 순(사용자 결정).
- **기대**: 회당 169 → 100~110초(② 43→수 초, ③ ≈10초). **30초는 ① 없이는 불가** — 03 R5 실측 후 재판단.
- **클라우드 다음 단계**: 03 R0~R1(구판 실행) → 01 적용 → 02 V1~V3 → 03 R3(신판) → R4 diff 0 → R5 소요. C 직접 호출이라 제외시간·메일 무관.

## 4-14. 클라우드 v1 실행 결과 (2026-10-08 16:35, 03b) → 퇴행 4곳 제외 v2 (사내 17:02 적용)

- 03b(C 직접 호출 MF_W→SF_W, 모듈 RUN_C_NEW_1464): **MF_W 268.7초 · SF_W 151.6초 · 비교 60초 = 8분 2초**. 결과 동치 44/44(DIFF 0). 적용 확인(16 T0-a/T0-b: 3,128줄·키 32·신판 SQL 15개 실행).
- 효과 확인: VMI INSERT `1nc5at1kvv06s` 85초 → `fj0mxwa6h2ua8` 3.0초(2회, 버퍼 1억 854만→25만) · ACCUM 2zp2 9+08sc 6 소멸(TEMPX 직접 적재 dg7b 11) · BALANCE DELETE `PARTITION RANGE SINGLE/KEY`.
- 느려진 원인 2가지: (1) **I/O 환경** — MF_W I/O 대기 142초(14:04 C#1 42초). 16 T5: 같은 시간대 DBeaver 스크립트 2개(멀티블록 124초)·dbms_stats 인덱스/테이블 수집·repctl 락 185초 동시. 플랜 동일 문장이 전부 늘음(aq7z 53→91 · 6nzw 3→20 · 1t8x 4→22). 14:04 는 13:30 직후라 캐시 워밍 상태. (2) **플랜 퇴행** — `05qrwgthrujm1`(MKT_FCST_C MEASURE IN GTT + NOT EXISTS DELETE) 8→35초, PHV 1056814193(해시 안티조인 VW_SQ_1) → 4008302274(NOT EXISTS 행별 FILTER/PUSH_SUBQ): 파티션 키 등식 추가로 행 추정 22→1(바인드 피킹·동적샘플링 OFF). CFM_C 짝 `b4r9df2w3nwck` 0.5→4.6초/회.
- 2회차 공정 비교(17 U4): v1 SF_W 151 vs 14:04 C#2 160 = −9 (VMI −41 · 퇴행 +13/+4 · aq7z +19 · 4q3x +7 · 2zqs +6).
- **v2**: 퇴행 4곳(L506/531/594/621)의 파티션 키 조건 제외(사유 주석) → 28곳. 사내 17:02:17 적용 VALID·3,124줄·오류 0·의존 VALID. 패키지 01/02/04 갱신. **클라우드 v2 재적용 → 03b 재실행(캐시 워밍 2회차) → 16/17 재측정 대기.** 기대 2회차 ≈ 134초/회; 30초는 ① 없이 불가(BALANCE 삭제·재삽입 75~110초).
- 교훈(룰 후보): 클라우드처럼 바인드 피킹·동적샘플링이 꺼진 환경에서는 **등식 조건 1개 추가가 서브쿼리 플랜을 바꿀 수 있다** — 서브쿼리(NOT EXISTS/IN) 있는 문장은 플랜 대조 없이 조건을 추가하지 않는다.

## 4-15. 클라우드 v2 실행 (2026-10-08 17:10:45~17:17:29, 03b, 8분 30초) — 퇴행 해소 확인 · 소요는 외부 부하가 지배

- 적용 확인(16 T0-a): v2 17:06:46 · 3,124줄 · 키 28 · ACCUM 0. **퇴행 해소**: `0m8x8bt5uuc33`(PHV 1056814193) 복귀 9.4초/회, `05qrwgthrujm1` 은 17:10 실행에서 미실행(last_active 16:40).
- 소요: MF_W ≈277초 · SF_W ≈151초(T2 누적에서 16:35 분 차감). v1 과 같음. 비교 쿼리 99초.
- **지배 요인 = 동시 부하(T5)**: 같은 창에서 DBeaver 스크립트(세션 8150) **멀티블록 읽기 1,293 ASH초**, repctl 락 대기 603초, dbms_stats 수집 74초 등 OTHERS ≈2,200초. 14:04 창은 OTHERS 111초. 그 결과 플랜 동일 문장의 물리읽기가 급증: BALANCE INSERT `aq7z2saw11yds` 디스크 7.6천(14:04) → **5.8만**, 회당 27→52초 · BALANCE DELETE `2zqsa3nha01a1` 디스크 10.9만, 회당 38→56초. CPU 도 1.5배(CPU 경합).
- 구조 효과는 그대로 유효: VMI INSERT 1.5초/회(85→3초 2회), TEMPX 직접 적재 7.7초/회, DELETE 단일 파티션, 퇴행 0. **BALANCE 삭제·재삽입 4문장 = 회당 ≈130초(이 창), 조용한 창 기준 ≈84초 — 잔여의 60% 이상.**
- 사용자 질의(①을 MERGE 아닌 방법으로): "DELETE 무로그·INSERT 일괄" 검토 의견 전달 — 일반 DELETE 는 undo/redo 필수(TRUNCATE·파티션교환 불가: 주 파티션에 여러 버전 공존), INSERT 는 이미 단일 set 문장이고 APPEND 는 같은 트랜잭션 재접근(VMI_DIO 블록)으로 ORA-12838 + 중간 COMMIT 필요 + 공간 비대 → 비권고. 대안 = **차집합 교체(PK 13컬럼+QTY 기준, UPDATE 없음, 처리 후 대칭차집합 0 ASSERT 아니면 전량 교체 폴백)**, 기대 84→10~15초, 행동 차이 = 미변경 행 감사컬럼 유지(하류 grep 선행). **사용자 결정 대기.**
- 다음: 18_load_check_before_run_cloud.sql 로 조용한 창(OTHERS 5분 ≤150초) 확인 후 03b 재실행 → 16 → 공정 수치 확정.

## 4-16. 세션 옵션 검토 (2026-10-08 사용자 제안: optimizer_dynamic_sampling=2 · TEMP_UNDO_ENABLED=TRUE) + 외부 부하 대책

- **optimizer_dynamic_sampling=2 → C SP 진입점에 삽입(v3, 사내 17:37:33 적용, 3,128줄)**. 근거: 2026-08-06 사용자 표준 규약(GTT 사용 SP 진입점 필수, 수정 시 함께 삽입 — 오늘 v1/v2 에서 누락했던 것을 정정) + 클라우드 플랜의 GTT 추정이 전부 기본값 8,168행(실제 CUTOFF_MST 92.8만·예외품목 ~16) 이었던 점 + 사내(기본값 2)에서 등가 검증한 플랜과 같은 조건이 됨. 잡 정의가 아니라 SP 진입점에 두는 이유 = 잡·수동·화면 어느 경로든 적용, 잡 재생성 시 소실 없음.
- **TEMP_UNDO_ENABLED=TRUE → 측정 후 결정(03c)**. GTT DML 의 undo 를 TEMP 로 보내 그 undo 의 redo 를 없앰 — 루트 GTT DELETE 38초·C 의 GTT 적재/초기화 25~30초/회('log buffer space' 대기 관찰) 에 효과 기대. 제약: 세션이 **GTT 를 처음 쓰기 전**에 설정해야 효력(이미 쓴 세션은 무효) → C SP 진입점에는 의미 없고 **루트 SP 진입점(첫 GTT DELETE 전) 또는 잡 세션 시작** 에만 유효. TEMP 사용량 증가(사내 TEMP 40GB) 확인 필요. 03c = 새 세션에서 두 옵션 ON + redo size/undo change vector/temp/physical reads 차이 출력. 효과 확인 시 루트 SP 진입점 삽입안을 별도 패키지로.
- **외부 부하 대책(사용자 질의)** — 16 T5 실측: 측정 창에 DBeaver 스크립트(세션 8150, user_id 9) 멀티블록 읽기 1,293초 · repctl(복제 에이전트) 락 대기 603초 · dbms_stats 자동수집 74초.
  1. 측정·운영 창 분리: 03b 류 측정은 18 L2 `GO` 일 때만. 배치(00시 롤링)는 자동 통계수집 창(22:00~, 파티션 통계 last_analyzed 22:23 확인)과 겹치지 않게 잡 시작 시각 조정 검토.
  2. 리소스 매니저(DBA): 소비자 그룹 분리 — 배치 서비스/모듈(`PR_DM_*` 잡)에 CPU·I/O 우선, DBeaver·SQL Developer 같은 ad-hoc 세션은 `MAX_UTILIZATION_LIMIT`·병렬 제한·`SWITCH_IO_MEGABYTES` 로 상한. Exadata 면 IORM(플랜 DB/PDB 단위)로 ad-hoc 풀스캔의 셀 I/O 점유 제한.
  3. ad-hoc 풀스캔 억제: 세션 8150 의 `32g6f28xxu5xk`·`1kgha68rgr43z` 가 무엇인지(개발자 스크립트인지 모니터링인지) 확인 → 필요 인덱스/조건 추가 또는 실행 시간대 합의. repctl 의 `g27btzrrf13ry` TX 락 603초는 복제 대상 테이블의 장기 트랜잭션 충돌 — 복제 담당과 대상 테이블·주기 확인.
  4. 버퍼 캐시 보호: BALANCE 삭제·재삽입이 물리읽기에 민감(디스크 7.6천→5.8만) → 핫 인덱스(PK_PART·SUPPLY 의 당주 파티션)를 KEEP 풀에 두는 방법은 DBA 판단(세그먼트 크기 수 GB 라 보수적).
  5. 우리 쪽 체질: ① BALANCE 차집합 교체(행 연산 1/4 → 물리읽기 자체가 줄어 외부 부하 민감도 감소)가 가장 큰 자구책.

## 4-17. 클라우드 v3 적용 + 03b/03c 실행 (2026-10-08 18:03 / 18:13)

- v3 적용(컴파일 OK). **03b(18:03)**: MF_W 192.3 · SF_W 175.7 · 비교 ≈169 → 8분 57초. 동치 44/44. **03c(18:13, 두 옵션 ON)**: MF_W 268.5 · SF_W 172.4 → 7분 22초. STAT: redo **4.22GB** · undo change vector **2.37GB** · temp space 0 · 물리읽기 865K · 논리읽기 3,816만 · CPU 265초.
- 판정 보류 이유: (1) 03c 의 C0 가 `dyn_sampling=2`·temp 0 → 03b 와 같은 세션(이미 GTT 사용)에서 실행된 것으로 보여 **TEMP_UNDO 미적용 상태의 측정**일 가능성이 큼(03c 에 "접속 2분 이내" 게이트 + v$tempundostat 전후 차이 출력 추가, 03b 에도 같은 STAT 계측 추가). (2) 18 부하 확인 없이 실행 → 환경 영향 분리 불가. (3) 두 실행이 연속이라 1회차/2회차 캐시 조건 차이.
- 확인된 사실: 회당 redo ≈2.1GB·undo ≈1.2GB — BALANCE 삭제·재삽입(인덱스 6개)과 GTT 적재가 만드는 로그량 자체가 크다. TEMP_UNDO 가 적용되면 GTT 분(ACCUM 제거 후에도 CUTOFF_MST 92.8만·TEMPX 등) 의 undo-redo 가 빠지고, ① 차집합 교체는 BALANCE 분 redo 를 1/4 로 줄인다.
- 다음: 18 L2 GO 확인 → **새 접속** 03b(STAT 포함) → **새 접속** 03c → 16 → redo/temp undo blocks/회당 초 대조.

## 5. 한계

- SP 가 START 를 남기지 않는 경로(로그 없는 SP·익명 블록)는 Q2 에 없음 → Q1(잡)·Q4(세션)로만 보임.
- 같은 SP 가 다른 세션에서 겹쳐 돌면(화면 동시 호출) 짝이 어긋날 수 있음 → Q2-c 로 분리. 배치 SP 는 겹침이 드묾.
- 구간 안 SQL 1문장 특정은 별도(`BATCH_PERF_QTY_BALANCE_40_20261007` Q7/C7 계열, hook #129 0-b).
