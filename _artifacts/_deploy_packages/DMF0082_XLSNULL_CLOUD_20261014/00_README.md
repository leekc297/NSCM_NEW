# DMF0082_XLSNULL_CLOUD_20261014 — Excel Upload 빈값 판정 정정 (패치형)

## 무엇을 고치나
`PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD` 의 빈값 판정 `NVL(x,'') = ''` · `NVL(x,'') <> ''` · `CASE WHEN x = '' THEN` 은
Oracle 에서 `''` = NULL 이라 **항상 거짓**이었다. AS-IS 이식본 `PKG_DMF0020.P_DMF0020_EXCEL_UPLOAD` 와 같이 `IS NULL / IS NOT NULL` 로 정정 — 48종 80곳.

| 구간 | 고치기 전 | 고친 뒤 |
|---|---|---|
| 저장 — Model 빈칸 행 추출 (2곳) | 0건 추출 → **저장 0건(성공 응답)** | 같은 Div/Team/End Customer/Project 의 Model 전체에 단가 저장 |
| 필수값 NULL 검사 (10곳) | Div·Team·End Customer·Project·Currency 빈칸 통과 | `NULL TEAM.` 등 오류 |
| Invalid MODEL (1곳) | 없는 Model 통과 | `Invalid MODEL.` |
| 음수·0 검사 (26곳) | 통과 | `Negative Number.` / `Zero Number.` |
| 통화 중복 검사 (28곳) | 통과 | `동일 기간에 두 개 이상의 Currency…` |
| 빈 월 → '0' (13곳) | NULL 그대로 | '0' (기존 단가 유지 규칙이 동작) |

Model 빈칸의 대상 Model = 기존 LOC 단가 또는 Sales Plan RTF_SYS_RP 가 있는 Model (AS-IS 동일 — Incoterms·DOM/EXP·Plant·FCST Type 을 그 행에서 가져온다).

## 실행 순서 (DBeaver/SQL*Plus, 파일별 전체 F5 · 값 입력 없음 · SCM_MGR)
| 순서 | 파일 | 내용 | 기대 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | 조회 전용 | `L1 표식` 0 · `L2 합계` **PASS** (토큰 48종 개수 = 사내 80) · `L3` 실행 중 세션 없음 |
| 2 | `A_DB/10_APPLY_XLSNULL_PATCH.sql` | 이 DB 의 USER_SOURCE 를 읽어 해당 구간만 치환 후 CREATE OR REPLACE | `APPLIED — … VALID · 표식 80곳` |
| 3 | `A_DB/90_VERIFY.sql` | 조회 전용 | V1 81 PASS · V2 VALID/0/0 · V3 0 PASS |
| 원복 | `A_DB/99_ROLLBACK_XLSNULL_PATCH.sql` | 표식 자리를 원문으로 되돌림 | `ROLLED BACK` |

- `L2 합계` 가 FAIL 이면 **10 을 실행하지 말고** L2 결과를 회신 (클라우드 원문이 사내와 다름). 10 도 개수가 다르면 원문 무변경으로 중단한다.
- 10 은 재실행해도 `SKIP` (멱등). 컴파일 오류 시 원문 자동 복원.
- 사전 조건: 클라우드 `SCM_ADM_EXCEL_COLUMNS` DMF0082/FcstNPrice 행 — `DMF0082_XLSMETA_CLOUD_20261014` 먼저 적용 (없으면 업로드 자체가 `Not exist ExcelUpload Data`).
- FE·BE 변경 없음.

## 사내 ZIOUI1 검증 (2026-10-14, SERVER_HOST=localhost)
- 리허설 = 이 폴더 SQL 4종을 그대로 실행 (`run_rehearsal.py` → `_rehearsal_out/rehearsal.out.txt`):
  PRECHECK PASS → APPLY → **DB 원문 == Python 적용본(바이트 동일)** → 재실행 SKIP → VERIFY PASS → ROLLBACK → **DB 원문 == 기준본** → 재 APPLY → VERIFY PASS.
- E2E (`_apply_corporate/DMF0082_XLSNULL_20261014/e2e_upload.py`, BE 와 같은 호출 체인, 테스트 ID `XLSNULL_T1`) 6/6 PASS:
  C1 원본 파일 행(81/ESS.SCM.SCM2팀/ESS/A25PS1001-M02/USD/Model 빈칸/M2=10) SUCCESS → 저장 30행
  (E00·E05 × LOC/KRW/USD × 2026-12 5주, LOC=10) · C2 Team 빈칸 `NULL TEAM.` · C3 `Invalid MODEL.` · C4 `Zero Number.` · C5 `Negative Number.` · C6 유효 Model SUCCESS.
  테스트 행 정리 후 원장 FP/FP_H 0건(전 0건).

## 재생성
`python build_package.py` — 사내 USER_SOURCE 를 새로 읽어 A_DB 4종 재작성 (사내가 이미 적용 상태면 기준본 조건으로 중단).
