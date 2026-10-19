# DMF0082 조회 — 81 TIMEOUT · 40 지연 보완 (GTT 대표 통계 고정, 클라우드 이관)

> 마커 `[E20261009-DMF0082GTTSTATS]` — SP·힌트·데이터 변경 없음. `GT_DMF0082_*` GTT 6본에 SHARED 대표 통계만 설정.

| 항목 | 값 |
|---|---|
| 증상 (클라우드 QA 10-09) | 12:08 PKG_DMF0082 재컴파일('/' 패키지) 직후 81 조회 4,875초·4,720초 TIMEOUT, 40 은 27~48초 (10-06~08 은 81 6~9초 · 40 10~14초) |
| 원인 | 재컴파일로 커서 무효화 → 재파싱 때 GTT(TEMP_SITE_ITEM 등) 1행 추정 → 81 수요 문장 `c3bg6q8n39195` MERGE JOIN CARTESIAN×2+NL(CPU 20~47초) · 판가 `d019r0hbb0muh` PHV 3633386171(1회 3,711초, 버퍼 3억) · 40 수요 `6bucw2kzuc0nt`(10~11초). 사내 같은 문장 = HASH JOIN 0.05~1초. 10-01 에도 같은 유형(6bucw 130~407초) — 재컴파일마다 재발하는 구조 결함(07-31 DMF0003 동형). '/' 텍스트 변경·AJS 수정과 무관(SQL_ID 동일·AJS 클라우드 미반영) |
| 조치 | GTT 6본(TEMP_SITE_ITEM·TEMP_SELECT_MEASURE·T_WS_FCST·TEMP_FCST_N_PRICE·T_LAST_DATA_SETUP_FCST·MF_SP) 에 `GLOBAL_TEMP_TABLE_STATS=SHARED` + `SET_TABLE_STATS/SET_COLUMN_STATS(NO_INVALIDATE=>FALSE)`. 파싱 시점 GTT 상태와 무관하게 HASH JOIN 고정. LOCK 없음(SP·타 패키지가 이 GTT 를 GATHER 하지 않음 — 00 [G4] 로 확인) |
| 사내 적용 | **완료** (ZIOUI1 2026-10-09 16:28:50) — 40/81/82·k0101 전 커서 결과 동일, 판가·수요 3문장 Note 에 dynamic sampling 소멸, 재컴파일 뒤 PHV 유지. [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0082_GTTSTATS_20261009/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 부수 효과 | NO_INVALIDATE=>FALSE 로 10-09 나쁜 계획 커서가 즉시 버려진다(별도 커서 PURGE 불요). 세션 9396(MF_SP 78분 TEMP 쓰기, 15:49 D05)은 BE 와 끊긴 채 도는 것이라 **DBA 세션 종료** 별도 필요 |
| BE 재기동 | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | A_DB/00_PRECHECK_CLOUD.sql | G1 6행 NUM_ROWS 공백·PREF SESSION(미적용) · G2 에 `❌ 10-09 타임아웃 계획` 자식 보임 · G4-GATHER 0행 |
| 2 | A_DB/10_SET_GTT_STATS.sql | `APPLIED` 6행 NUM_ROWS·PREF SHARED |
| 3 | 화면에서 81 Search 1회, 40 Search 1회 (또는 90 의 V4 가 대신 호출) | 81 수 초~십수 초 |
| 4 | A_DB/90_VERIFY.sql | V1 6행 PASS · V3 PASS · V4 `OK` 2줄 · V5 계획에 CARTESIAN 없음 · V6 `❌ 구 계획 잔존` 0행 |

롤백: A_DB/99_ROLLBACK_GTT_STATS.sql (통계 삭제·PREF SESSION, 커서 무효화 포함). 사내에서 99 → 10 왕복 리허설 완료.

## 남은 것 (별건)
- 사내 콜드 I/O: 판가 원장 190K 행 랜덤 읽기(3만 블록)로 첫 조회 400초 — 통계 고정으로는 안 바뀐다. 커버링 인덱스 또는 판가 주간 요약 테이블 결정 필요.
- '/' 82 AS_Inv 행 분리(27 키): 차주 데이터 정리로 해소 예정.
