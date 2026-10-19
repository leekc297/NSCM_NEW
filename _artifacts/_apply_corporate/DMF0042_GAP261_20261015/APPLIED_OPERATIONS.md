# GAP 261 — DMF0042 40 Replace 2024-12 이전 구간 불가 (사내 ZIOUI1 적용 기록)

- 대상: `SCM_MGR.PKG_DMF0042` PACKAGE BODY → `P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF` 컷오프→원장 INSERT…SELECT (L1578)
- 마커: `[E20261015-GAP261]` 1곳 · 접속: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost)
- 기준본: DB 재조회 LAST_DDL **2026-10-15 18:48:21** (GAP257 적용본) → 적용 19:04:56 (FRESH-GATE 통과)
  → 클라우드 패키지 리허설로 원복·재적용, 최종 LAST_DDL **2026-10-15 19:09:20** (md5 `6e9f8f45…` = 적용본) · GAP257 마커 5 보존

## 원인 판정
| 항목 | 사내 실측 |
|---|---|
| `DM_PLN_BP_FCST_C.INCOTERMS` | **NULL 허용** · DEFAULT 없음 |
| `DM_PLN_BP_FCST.INCOTERMS` | NOT NULL · PK · `DEFAULT ON NULL '/'` (10-08 SLASHDEF) |
| 컷오프 40 빈 INCOTERMS | 버전마다 71,673~71,694행 = **전부 `'-'`** (NULL 0) — GAP 비고 건수와 일치 |
| Replace 재현 (직접 호출 → ROLLBACK) | 202401~202412 `OK 110,908` · 202609~202702 `OK 68,534` — **사내는 실패 재현 안 됨** |

- SP 는 `_C.INCOTERMS` 를 그대로 원장에 넣는다. 원장에 DEFAULT ON NULL 이 없는 DB(클라우드 — SLASHDEF 미적용)에서 `_C` 에 NULL 이 있으면 ORA-01400 → Replace 전체 실패(GAP 증상 구조). 사내는 원장 DEFAULT ON NULL 과 `_C` 값 `'-'` 때문에 드러나지 않음.
- Replace 실행 로그(SCM_SYS_LOG_BATCH)는 이 DB 에 0건 — 클라우드 실제 오류 문구는 미확보.

## 변경 (1줄)
`INCOTERMS,` → `NVL(NULLIF(RTRIM(INCOTERMS), ''), '/'),` — 빈값은 `'/'`(이관·적재 규칙과 같음, GAP 조치 방향과 같은 값). 데이터 UPDATE 없음.

## 검증 (`verify.py`, 전부 ROLLBACK — 원장·컷오프 무변경 확인)
| 항목 | 결과 |
|---|---|
| 컴파일 | VALID · ALL_ERRORS 0 |
| V1 회귀 | 202401~202412 `OK 110,908` · 202609~202702 `OK 68,534` (수정 전과 동일) |
| V2 클라우드 모사 (트랜잭션 안에서 `_C` 2024 빈값 336행 NULL 화 → Replace) | 오류 없음 · 원장 INCOTERMS `'/'` 336행 |
| 클라우드 패키지 리허설 | 90→99→00→10→10(SKIP)→90→99→99(SKIP)→10→90 기대대로 · 99 후 md5 = 수정 전 · 10 후 md5 = 적용본 |
- ⚠ V2 는 판별 시험이 아님: 사내 원장은 DEFAULT ON NULL '/' 라 수정 전에도 같은 결과였을 것. 클라우드 판별 = 패키지 `00_PRECHECK` L3(컷오프 NULL 행 · 원장 DEFAULT_ON_NULL).

## ⭐ 원인 재판정 (19:13~19:30 — 클라우드 QA PRECHECK·진단 회신 + AS-IS 직접 조회)
- QA(OCGSCMQ_P01): 컷오프 INCOTERMS NULL 71,673~71,694행/버전 **있음**. 그러나 원장 INCOTERMS `DEFAULT ON NULL '/'` **있음**. 다른 NOT NULL 무기본값 컬럼(UNIT_ENERGY·QTY·CREATION_DATE)의 NULL 0, 컷오프 PK 중복 0, Replace 실행 로그(SCM_SYS_LOG_BATCH·SCM_COM_SYS_LOG) 30일 0건 → **ORA-01400 은 원인 아님. QA 에서 SP 가 호출된 적 없음.**
- 실제 원인 = 버전 목록 조회 조건: Replace 모달의 기간 하나가 ① 버전 목록 필터(`DM_MST_VERSION.YYYYMMDD BETWEEN from AND to` + `ATTRIBUTE1<>'MOVE'`) ② Replace 구간 양쪽에 쓰인다(AS-IS `ReplaceByCutOffPopUp.cs` L225~226 / L469~496 동일).
  2024 구간을 고르면 조회 가능한 버전은 `24BP_DM_2024_W23_V01`(컷오프 2024-06-03) **1건뿐이고 컷오프 데이터 0행**이다(TO-BE·AS-IS 동일, AS-IS 2026-10-15 19:26 직접 조회).
  - AS-IS: 그 버전으로 실행 → 2024 원장 DELETE 후 INSERT 0 → **그 구간이 비워짐**(가능처럼 보이나 데이터 소실).
  - TO-BE: 2026-08-27 AJS 가드("선택한 버전에 되돌릴 자료가 없습니다") → 삭제 전 중단 = **의도된 안전장치**.
- 2024 이전 버전(2019~2022 전부, 2023 64/89, 2024 113/114)은 `MOVE` 처리돼 목록 제외 — 양쪽 동일. 2024 구간만 2025~2026 버전으로 되돌리는 것은 AS-IS 도 불가(기간 1개 공유 구조).
- 본 SP 패치(INCOTERMS NVL)는 동작 동일·무해 — GAP 해소책 아님.
- ✅ **종료(사용자 2026-10-15)**: "결함 아님(AS-IS 동일 구조 + TO-BE 데이터 보호 가드)" 회신으로 GAP 종결. 사내 패치 유지 · 클라우드 패키지 선택 적용 · 기간 분리 기능 미진행.

## 파일
- `apply.py`(plan/apply · FRESH-GATE) · `00_BACKUP_PKG_DMF0042_BODY_2026-10-15_1848.sql` · `_new_PKG_DMF0042_BODY.txt` · `repro.py` · `verify.py`
- 클라우드: `_artifacts/_deploy_packages/DMF0042_GAP261_REPLINCO_CLOUD_20261015/`
