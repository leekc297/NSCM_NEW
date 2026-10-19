# C_QTY_BALANCE_CORPSYNC_CLOUD_20261008 — 클라우드 `PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE` 를 사내 판으로 동기화

> 목적: 클라우드 10-02 15:39 판의 **GROUP BY 누락(ORA-00979, 728행)** 해소. 사용자 지시 2026-10-08 "사내 소스를 기준으로 클라우드 반영".
> 사내 원문에는 이 오류가 없으므로 **코드 수정 없이** 사내 현재 판(2026-10-01 18:43:58, VALID, 3,092줄)을 그대로 덤프했다(1바이트도 수정하지 않음).

| 파일 | 내용 |
|---|---|
| `01_PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE.sql` | 사내 ZIOUI1 ALL_SOURCE 덤프(SOURCE-FRESH 스탬프 헤더 3줄 + `CREATE OR REPLACE` + 원문 3,092줄 + `/`). SCM_MGR 로 전체 실행 |
| `02_VERIFY.sql` | 적용 전 V0(판본·실행 세션·백업 권장) → 적용 후 V1~V4(VALID·3092줄·AJS 마크 2·tail 4곳·지표·의존 객체) → V5 실행 검증 |

## 1. 적용 순서 (클라우드, SCM_MGR)
1. `02_VERIFY.sql` V0·V0-b 실행 — 현재 판 2026-10-02 15:39:33 / 3,100줄 확인, 실행 중 세션 없음 확인. V0-c(백업 테이블) 권장.
2. `01_…sql` 전체 실행(F5). "Procedure … compiled" 확인.
3. `02_VERIFY.sql` V1~V4 — VALID · 3,092줄 · AJS 마크 2 · 컴파일 오류 0 · tail 4곳(761/795/941/978) · 의존 객체 VALID.
4. 실행 검증: `_artifacts/_diagnostics/BATCH_LONGRUN_IDENTIFY_20261008/11_rerun_plan1464_cloud.sql` 을 목요일 08:00~14:30(메일 제외시간) 안에 실행 → C_QTY_BALANCE 2회 END, S4-d 회당 소요 측정.

## 2. 오류 원인 (2026-10-08 확정)
- 클라우드 10-02 15:39 판 L763(첫 블록 GROUP BY 대체 줄)이 원래 줄 끝 `, A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP` 을 빠뜨림 → 728행 `INSERT INTO GT_DPMFCQB_MKT_FCST_INSERT` 에서 ORA-00979. 2026-10-08 13:30 재실행(40/1464)에서 재현, 실테이블 영향 0(12 D1 플래시백 대조).
- 사내 판 L761 은 tail 포함(정상). 다른 3 블록은 양쪽 모두 정상.

## 3. ⚠ 이 적용으로 클라우드에서 **되돌아가는 클라우드 전용 변경** (사용자 확인 대상 제외 건이지만 배포자가 알아야 함)
클라우드 10-02 판에만 있던 8줄 변경이 사내 판으로 덮이면서 원래대로 돌아간다:
- 82/40 사업부 RTF 적재 시 PLANT_SITE_ID 자리표시자 `'-'`(클라우드) → `' '`(사내) — SELECT 4곳 + GROUP BY 4곳 (사내 L745·761·778·794·926·939·959·977)
- 첫 블록 CASE 기준 `A.ORIGIN_DIVISION_ID`(클라우드 L746·763) → `A.DIVISION_ID`(사내 L745·761)
- 그 외 차이 없음(헤더 이력 L56~79 · 본문 마커 · 뷰 참조 13 · 로그 호출 7 · GATHER 0 동일 — 06 W3/W3-b 대조). 사내 데이터는 MKT_FCST·CFM_C 의 PLANT_SITE_ID 가 이미 전부 `'-'`(PLANTNORM 08-04) 라 `' '` 코드가 실데이터에 드러나지 않을 가능성이 높으나, 클라우드 데이터는 미확인.
- 클라우드 10-02 변경의 작성자·의도는 미확인(마커 없음). 그 변경을 유지해야 한다면 이 패키지 대신 클라우드 L763 에 tail 1줄을 추가하는 방식이어야 한다(이 패키지는 그 방식이 아님).

## 4. 원복
V0-c 로 만든 `ZZ_BK_SRC_C_QTY_BALANCE_20261008` 의 line/text 를 `CREATE OR REPLACE ` 뒤에 이어 붙여 실행하면 10-02 15:39 판으로 돌아간다(단, 그 판은 ORA-00979 를 다시 가진다).

## 5. 출처·근거
- 진단 전체: `_artifacts/_diagnostics/BATCH_LONGRUN_IDENTIFY_20261008/00_README.md` §4-6 ~ §4-9
- 사내 원문 신선도: 01 파일 헤더 SOURCE-FRESH 스탬프(덤프 시각·LAST_DDL). 24h 지나면 사내 LAST_DDL 재확인 후 재덤프(hook #152).
