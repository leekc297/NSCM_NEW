# DMF0082 대용량 저장 호출 추출 → 실행 문장(재현 스크립트) — 클라우드용 (2026-10-19)

## 목적
클라우드에서 DMF0082 를 1,000건 이상 일괄 저장한 호출(`PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA`)을 찾아,
그대로 다시 실행할 수 있는 PL/SQL 파일로 만든다. 두 파일 모두 **조회 전용**(클라우드 DB 변경 없음).

## 근거
- BE callProc 로그 `SCM_COM_SQL_LOG`(SQL_ID=`com.lgcns.nscm.callProc`)의 `SQL_TEXT` = 값이 채워진 실행 문장 전체
  (한 줄 · 문자열 인자 17개 + OUT 커서 자리 `NULL`). `PARAMS`(JSON)는 4,000자 근처에서 잘려 재현 불가.
- 로그 문장을 그대로 실행하면 인자 1개가 수십만 자(사내 최대 706,964자)라 **PLS-00172**(문자열 리터럴 32,767바이트 초과).
  → 인자마다 CLOB 변수에 4,000자 조각을 이어 붙인 뒤 SP 를 호출하는 형태로 생성한다.

## 실행 (클라우드 · 전체 F5)
| 순서 | 파일 | 결과 |
|---|---|---|
| 1 | `A_DB/01_FIND_DMF0082_BULK_SAVE_CLOUD.sql` | 1,000건 이상 저장 호출 목록 (LOG_SEQ · 시각 · 사용자 · 소요 ms · 문장 길이 · 저장 건수 · 예외) |
| 2 | `A_DB/02_MAKE_REPLAY_SCRIPT_CLOUD.sql` | `C:\temp\DMF0082_SAVE_REPLAY.sql` 생성 (C:\temp 폴더 먼저 생성) |

- 02 기본값 = 1,000건 이상 중 **가장 최근 1건**. 다른 건이면 02 의 `c_log_seq := NULL` 을 01 의 LOG_SEQ 로 바꿔 실행.
- 생성 파일 맨 아래 `-- REPLAY-END rows=… params=17 chars=… LOG_SEQ=…` 줄이 있어야 완전한 파일.
- SPOOL 이 안 되면 스크립트 출력창 전체를 복사해 .sql 로 저장.

## 3개 화면 대용량 저장 목록 — `A_DB/03_FIND_BULK_SAVE_3SCREENS.sql` (사내/클라우드 공용 · 조회 전용)
| SP | 화면 |
|---|---|
| `PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA` | DMF0082 |
| `PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST` | DMF0003 |
| `PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL` | DMF0021 (IN 인자 VARCHAR2 — 인자당 32,767B 상한) |
- B0 로그 보존 기간 · B1 화면별 요약(호출 수·최대 건수·최대 소요·1,000건 이상 수) · B2 1,000건 이상 목록(건수·ms·초·ms/행·결과) · B3 SYS_LOG 화면 저장 소요 상위 10
- 사내 실행(14:15): SQL_LOG 보존 2026-09-15 ~ · DMF0003 10건(최대 14,393건 116초) · DMF0082 3건(최대 45,882건) · DMF0021 0건(최대 14건)
- 클라우드에서 0건이면 B0(보존 기간)·B1(최대 건수)로 '대용량 저장이 없었음' vs '로그 보존 밖' 구분

## 사내 로그 2건 재현 스크립트 — `B_REPLAY/` (make_replay.py · 2026-10-19)
| 파일 | 원본 | 건수 | 크기 |
|---|---|---|---|
| `DMF0082_SAVE_REPLAY_LOG1676794.sql` | PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA · 2026-09-29 21:32:39 · 370.2초 | 45,882 | 4.8MB / 1,291줄 |
| `DMF0003_SAVE_REPLAY_LOG1840792.sql` | PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST · 2026-10-02 20:45:31 · 116.0초 | 14,393 | 1.4MB / 445줄 |
- 인자 타입·개수는 ALL_ARGUMENTS 기준(DMF0003 = CLOB 14 + VARCHAR2 2 + OUT 커서 2). 검증: FIDELITY PASS(재조립 == 원본) · 호출 막은 사본 실행 OK(인자별 토큰 수 = 건수)

## 생성 파일(DMF0082_SAVE_REPLAY.sql) 내용
- 머리: 원본 LOG_SEQ · 시각 · 사용자 · 소요 ms · 저장 건수
- 인자 17개 CLOB 조립 → 인자별 길이·토큰 수 출력 → SP 호출 → 소요 시간 · 결과 커서(최대 50행) 출력
- ⚠ **실행하면 실제로 저장된다(SP 내부 COMMIT)**. 실행 대상 DB 를 확인할 것.

## 사내 리허설 (ZIOUI1 · 2026-10-19 14:04 · `rehearse.py`, 저장 호출은 실행 안 함)
- 01: 3건 검출 (32,206 / 32,240 / 45,882건)
- 02: LOG_SEQ 1677565 (32,206건) → 950줄 · 3.4MB 생성, `REPLAY-END` 확인
- 충실도: 생성 스크립트 조각을 다시 이어 붙인 17개 인자 == 원본 SQL_TEXT 인자 **전부 일치(PASS)** · 인자 17개 모두 토큰 32,206
- 문법: 인자 조립까지 실제 실행 OK · 저장 호출 포함 전체 블록 컴파일 OK(호출은 IF 1=0 으로 막아 미실행)
- 결과물: `_rehearsal_out/DMF0082_SAVE_REPLAY.sql`
