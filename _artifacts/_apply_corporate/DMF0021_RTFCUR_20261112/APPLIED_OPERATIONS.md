# [E20261112-RTFCUR] 사내 적용 기록 — 2026-11-12

## 증상
DMF0021(40 · SpaceX_US_XLC · MCCM348015A1-000) — 환율 적용 뒤 같은 키의 RTF[R+P] 행이 통화 없는 행으로 하나 더 보임.

## 원인 (사내 ZIOUI1 실측 13:20~13:28)
- `DM_PLN_SALES_PLAN` 의 2027-02·03·04 `RTF` · `RTF_SYS_RP` 6행 CURRENCY = NULL (`RTF_SCP` 는 USD).
- 13:09:31 저장 요청은 5개월 모두 `currency USD` 로 전송(BE 로그), 저장 이력(`DM_PLN_SALES_PLAN_H`)도 USD → 저장 SP 는 정상.
- 13:21:11 환율 적용 = `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW('40','EXCHANGE_RATE_UI')`. RTF·RTF_SYS_RP·RTF_PR 행을 지우고 다시 넣으면서 통화를 같은 기간 단가(`GT_PRDM_T2_PRICE`)에서만 가져온다. 단가 없는 기간은 NULL.
  수량이 0 이 아니면 11-02 보완(`[E20261102-RTFLATESTPRICE]`)이 최근 단가를 채워 통화가 생기지만, 수량 0 은 대상이 아니다.
- 조회 SP 는 원장 통화로 행을 나눈다(10-29 마스터 보충 제거) → 통화 NULL 행이 별도 행.

## 보완
- 대상: `SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW` — RTF 재생성 2곳(40 / 그 외)의 `SI.CURRENCY` 를
  `COALESCE(SI.CURRENCY, 원장의 같은 키·같은 일자 RTF 계열 행 통화)` 로 변경. 841줄 → 873줄.
- 적용 13:28:39 (기준본 LAST_DDL 2026-11-03 19:11:30 → FRESH-GATE 통과 → VALID · ALL_ERRORS 0 · 적용본 == DB 원문 · 스키마 INVALID 83 → 83).
- 원복: `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW.ASIS.sql`.

## 검증 (배치 1회 실행 13:28:40 · 68.0초 · 화면과 같은 인자)
| 항목 | 전 | 후 |
|---|---|---|
| 40 원장 행 수(이번 주 이후) | 18,790 | 18,790 |
| 전에만 / 후에만 있는 행 | 0 | 0 |
| 수량 달라진 행 | — | 0 |
| 통화 달라진 행 | — | 6 (전부 대상 키 RTF 3 · RTF_SYS_RP 3 · NULL → USD) |

상세 = `apply_20261112.log` · `snap_before.json` · `snap_after.json`.

## 미확인 · 남은 것
- 화면 재조회로 행이 하나로 합쳐졌는지는 실행하지 않았다(사용자 확인 필요).
- 81·82 등 다른 사업부 분기는 배치를 실행하지 않았다(같은 치환 · 컴파일만 확인).
- 같은 키에 통화 있는 RTF 계열 행이 하나도 없으면 여전히 NULL(예: MKT_FCST 만 있어 자동 생성된 RTF_SYS_RP 0 행). 40 에 통화 NULL RTF_SYS_RP 1,973행(전부 수량 0) 남아 있다.
- MKT_FCST·SCM_FCST 계열도 같은 방식으로 통화를 가져온다 — 이번 보완 범위 밖.

## 클라우드
`_artifacts/_deploy_packages/DMF0021_RTFCUR_CLOUD_DB_MOD_20261112_1331/` (공용 프로시저라 cloud_pkg 대상 밖 → 별도 패키지 · 2곳 치환 · 기준 문구 다르면 중단 · 사내 리허설 통과). 클라우드 적용·회신 대기.
