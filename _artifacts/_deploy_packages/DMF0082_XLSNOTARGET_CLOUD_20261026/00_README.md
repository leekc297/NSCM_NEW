# DMF0082_XLSNOTARGET_CLOUD_20261026 — Excel Upload: Model 빈칸 행의 저장 대상 Model 검증 (패치형)

## 무엇을 고치나
81 Excel Upload 에서 Model 을 비우면 저장 시 같은 Div / End Customer(사이트) / Project / Team(품목 부서) 의 Model 중
기존 LOC 단가(`SCM_MST_FUTURE_PRICE`) 또는 Sales Plan `RTF_SYS_RP`(`DM_PLN_SALES_PLAN`) 가 있는 Model 전체에 단가를 넣는다.
검증은 각 값을 따로 존재만 보았기 때문에 **조합이 맞지 않으면 SUCCESS 후 저장 0행**이었다.
→ `P_DMF0082_EXCEL_UPLOAD` 검증 단계에서 'Invalid MODEL.' 검사 바로 뒤에, 저장과 같은 조인으로 대상 Model 이 0 인 Model 빈칸 행을 ERROR 로 바꾸는 UPDATE 1개를 삽입한다 (기존 줄 변경 0).

| 끊긴 단계 | 메시지 |
|---|---|
| End Customer 사이트에 그 Project 품목 없음 | `No MODEL for END CUSTOMER / PROJECT CODE.` |
| 품목은 있으나 부서명이 Team 과 다름 | `No MODEL for TEAM / PROJECT CODE.` |
| 품목·부서는 맞으나 LOC / RTF_SYS_RP 대상 없음 | `No Upload Target MODEL (LOC / RTF_SYS_RP).` |

값 자체가 없는 Division·Team·End Customer·Project·Currency 는 종전 그대로 `Invalid …` (사내 E2E 로 동작 재확인). ERROR 행이 있으면 저장(OK)은 `-1 Validation Check` 로 막힌다(기존 로직).

## 실행 순서 (SQL Developer/DBeaver/SQL*Plus, 파일별 전체 F5 · 값 입력 없음 · SCM_MGR)
| 순서 | 파일 | 기대 |
|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | `L1 TAG` 0 · `L2 ANCHOR` 1 **PASS** · `L3` 실행 중 세션 없음 |
| 2 | `A_DB/10_APPLY_XLSNOTARGET_PATCH.sql` | `APPLIED - PKG_DMF0082 BODY VALID / XLSNOTARGET block 1` |
| 3 | `A_DB/90_VERIFY.sql` | V1 1 PASS · V2 VALID / 0 / 0 · V3 3 PASS |
| 원복 | `A_DB/99_ROLLBACK_XLSNOTARGET_PATCH.sql` | `ROLLED BACK` |

- `L2 ANCHOR` 가 1 이 아니면 10 을 실행하지 말고 결과 회신. 10 도 앵커가 1 곳이 아니면 원문 무변경으로 중단한다.
- 10·99 는 재실행해도 `SKIP` (멱등). 컴파일 오류 시 원문 자동 복원. PKG_DMF0082 사용 중이라 생성이 실행되지 못하면(ORA-04021 등) `-20006 STOP - CREATE not executed` 로 중단(원문 무변경) → 사용 세션 종료 후 재실행.
- 클라우드 BODY 는 사내와 세대가 달라 전체본 교체가 아니라 그 DB 의 USER_SOURCE 위 앵커 뒤 삽입이다.
- FE·BE·메타 변경 없음.

## 사내 ZIOUI1 검증 (2026-10-26, SERVER_HOST=localhost)
- 리허설 (`run_rehearsal.py` → `_rehearsal_out/rehearsal.out.txt`): FRESH-GATE → 99 SKIP → 00 PASS → 10 APPLY → **DB 원문 == Python 적용본** → 10 SKIP → 90 PASS
  → 99 ROLLBACK → **DB 원문 == 기준본** → 99 SKIP → 10 APPLY(최종) → 90 PASS. 현재 사내 = 적용 상태 (LAST_DDL 23:46:21).
- E2E (`_apply_corporate/DMF0082_XLSNOTARGET_20261026/e2e_upload.py`, BE 와 같은 호출 체인, 테스트 ID `XLSNT_T1`) **16/16 PASS** — 상세 = 같은 폴더 `APPLIED_OPERATIONS.md`.

## 재생성
`python build_package.py` — 사내 USER_SOURCE 를 새로 읽어 A_DB 4종 재작성 (사내가 이미 적용 상태면 기준본 조건으로 중단). SOURCE-FRESH 24h 경과 시 재생성 후 전달.
