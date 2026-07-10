# DMF0008 Status Update — Last Update Start 미갱신 클라우드 이관 패키지 (2026-07-09 v2)

## 증상 / 원인 (v2 — 사용자 확인으로 재진단)

- 증상: 클라우드에서 Status Update 실행("실행완료") 후 **Last Update Start 시각 미갱신**. 로컬(사내)은 동일 FE 소스로 정상.
- **FE 동일 소스 확인됨 → 원인은 DB(SP) 측.**
- 조회 체인: FE `refetchHistory` → `DMF0008_GET_UPDATE_HISTORY`(위임 wrapper) → `DMF0000_GET_UPDATE_HISTORY` →
  `SCM_SYS_LOG_BATCH` 에서 `PROGRAM_NAME='PR_DM_DNM_EDI_CALLOFF_STATUS' AND LOG_TYPE='START'/'END'` 의 MAX 시각.
- 사내 실행 SP `PR_DM_DNM_EDI_CALLOFF_STATUS` 는 시작 시 `PR_SCM_SYS_LOG_BATCH(... 'START' ...)` 기록(L54~58) +
  **2026-06-17 fix** 로 정상 경로 END 로그 보강 — 이것이 "이전 로컬 보완"의 실체.
- **클라우드 SP 가 이 로그 기록 이전 버전이면 START 행이 안 쌓여 시각이 영구 고정** → 현 증상과 정확히 일치.

## 이관 대상 (실행 순서)

| 순서 | 파일 | 내용 |
|---|---|---|
| 0 | `sql/00_CLOUD_DIAGNOSE.sql` | 적용 전 진단 5종 — #1 이 0건이면 원인 확정 (구버전 SP) |
| **1 (필수)** | `sql/01_PR_DM_DNM_EDI_CALLOFF_STATUS.sql` | 사내 최신본 (START/END 배치 로그 + 2026-06-17 fix 포함, 571줄) |
| 2 | `sql/02_DMF0000_GET_UPDATE_HISTORY.sql` | 공용 조회 SP (진단 #4 에서 부재/상이 시) |
| 3 | `sql/03_DMF0008_GET_UPDATE_HISTORY.sql` | 위임 wrapper (진단 #4 에서 부재/상이 시) |
| 참고 | `sql/51_DMF0008_status_update_meta.sql` | 버튼/API 메타 (멱등 — 클라우드 실행완료가 뜨므로 기적용 추정, 보험) |
| 참고 | `fe/features/master/src/pages/erp-edi-master/` | FE 최신본 — **사용자 확인상 클라우드와 동일 소스이므로 생략 가능** (버전 불확실 시에만) |

- 전제: `PR_SCM_SYS_LOG_BATCH` 가 클라우드에 존재해야 함 (진단 #5 — 공용 SP 라 존재 예상).
- GRANT/SYNONYM: 기존 SP CREATE OR REPLACE 는 권한 유지 — 추가 GRANT 불필요.

## 적용 후 검증

1. Status Update 버튼 실행 → 진단 #2 재실행: START/END 의 LAST_AT 이 방금 시각으로 갱신 확인.
2. 화면 재조회 → Last Update Start/End 시각 표시 확인.

## v3 갱신 (2026-07-09) — ORA-30926 근본 수정 (사용자 확정: 중복 시 마지막 데이터 채택)

- 원인 계층 2가지:
  1. 클라우드 SP 구버전 — 사내본의 GT_SITE_ITEM 적재 dedup(ROW_NUMBER, "가장 최근 프로젝트 선정")이 없으면 MERGE 2/3/4 에서 30926.
  2. Sales Site 판정 MERGE(사내본 L214)는 사내본에도 dedup 부재 — (DIVISION,SOLDTO,SHIPTO)당 복수 Sales Site 매핑 시 30926 (사내에도 중복 키 17건 잠재).
- **수정(v2)**: L214 USING 에 ROW_NUMBER() PARTITION BY (DIVISION,SOLDTO,SHIPTO) ORDER BY LAST_UPDATE_DATE DESC, SCM_SITE_ID DESC → RN=1 — **최종 수정분 채택**. 교체 구간 외 byte-identical 검증 통과.
- 사내 적용 완료(VALID) + dedup 후 중복 키 0 확인. `sql/01_...sql` 은 v2(dedup 포함 최신본)로 교체됨 — **클라우드에 01 적용이 필수** (구버전의 GT_SITE_ITEM dedup 부재 + L214 보강을 한 번에 해소).
- 적용 후: Status Update 실행 → 00 진단 #2 에서 ERROR 미증가 + END 정상 + 화면 Last Update Start 갱신 확인.
- 미확인: AS-IS MSSQL 원본 대조는 AS-IS 망 접속 불가(timeout)로 미교차 — 원본 UPDATE FROM 은 MSSQL 특성상 중복 시 오류 없이 임의 1행 적용되므로 동작 차이는 "오류 발생 여부"뿐, 채택 정책(최신분)은 사용자 확정 기준.

## ✅ 최종 해결 (2026-07-09 사용자 확인)

05_CLOUD_FIX_API_WIRING.sql 적용 후 Status Update → 최종 UPDATE 일시 재조회 정상 확인.
원인 3중: ① 클라우드 SP 구버전(ORA-30926) ② Sales Site MERGE 중복 무방비(사내 포함 — dedup 보강) ③ **클라우드 API_M 오배선(STATUS_UPDATE→조회 SP — "성공 토스트인데 무동작"의 정체)**.
