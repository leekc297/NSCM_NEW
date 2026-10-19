# DMF0035 (PLAN TYPE = SALES PLAN) · PKG_DMF0022 — [E20261019-000071] Sales Plan Waterfall RTF 중복 현상

## 증상 (클라우드)
DMF0035 · PLAN TYPE `SALES PLAN` · VERSION `SP_W_20261001_V001` · MODEL `MCCM348014A3` · SALES SITE `SCUD_CN_FOC` · INCOTERMS `DAP`
→ CNY 행만 나와야 하는데 USD 행도 조회된다.

## 원인 (사내 ZIOUI1 재현·실측 — SP_W_20260825_V002, 같은 모델·사이트)
1. 원천 `DM_PLN_SALES_PLAN_C` 의 DAP 행 대부분은 CNY 이지만, 일부 행(사내 = 2028-01-03 RTF_SYS_RP/RTF_PR/RTF_SCP/SalesAmt_* 1행씩)의 **CURRENCY 가 공란(NULL)** 이다.
2. 조회 SP 는 CURRENCY 공란 행을 `SCM_MST_SITE_ITEM.CURRENCY` 로 채운다 → 이 사이트·모델은 **USD**. 그래서 DAP 에 CNY 키와 USD 키가 함께 생긴다.
3. 40사업부 `[PJ2024-50611]` 블록이 계획구간(now 이후) 행을 지운 뒤 `DM_PLN_SALES_PLAN(_C)` 에서 **다시 적재하는데, 조인 키에 CURRENCY 가 없다**.
   → USD 키에도 CNY 행 수량 전체가 붙고, CNY 키에도 공란 행 수량이 붙는다 = **RTF 중복**.

| DAP · RTF_SYS_RP | 원천 | 수정 전 화면 | 수정 후 화면 |
|---|---|---|---|
| CNY | 10,175,172 | 10,268,503 (공란 행 93,331 섞임) | 10,175,172 |
| USD | 공란 행 93,331 (2028-01) | 9,320,503 (CNY 계획 수량 복제) | 93,331 |

⚠ 수정 후에도 원천에 CURRENCY 공란 행이 있으면, **그 행 수량만** SITE_ITEM 통화(USD)로 따로 나온다(복제 아님 · AS-IS 의 채움 로직 그대로).
클라우드에서 USD 가 완전히 사라져야 한다면 `05_DIAG` D1 의 `(NULL)` 행이 생긴 원인(데이터)을 따로 확인해야 한다.

## 조치
`P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` 의 40사업부 `[PJ2024-50611]` 재적재 블록 전체(IF p_division_id = '40' ~ END IF)를 주석 처리.
블록 안의 `/*+ NO_PARALLEL */` 힌트 8개는 블록주석 중첩 불가(PLS-00103)로 `\*+ NO_PARALLEL *\` 로 표기(같은 패키지 기존 주석 블록과 같은 방식).
원장 · 메타 · FE · BE · 권한 · GTT 무변경. BE 재기동 불필요.

## 실행 순서 (클라우드 · 전부 전체 F5 · 값 입력 없음)
| 순서 | 파일 | 성격 | 기대 |
|---|---|---|---|
| 1 | `A_DB/05_DIAG_CURRENCY_CLOUD.sql` | 조회 전용 | D0 MARKER_LINES=0 · D1 에 DAP `(NULL)` 행 · D4 `USD ← CNY DUPLICATED` 행 → 원인 확정 |
| 2 | `A_DB/00_PRECHECK_CLOUD.sql` | 조회 전용 | L1 앵커 1/1 PASS · 블록 PASS · L2 마커 0 · L3 실행중 0행 |
| 3 | `A_DB/10_APPLY_RTFDUP_PATCH.sql` | BODY 패치 | `APPLIED - PKG_DMF0022 BODY VALID / marker 2` |
| 4 | `A_DB/90_VERIFY.sql` | 조회 전용 | V1 PASS · V2 VALID/0/0 · V3 PASS 2줄 |
| 5 | 화면 | DMF0035 SALES PLAN 같은 조건 | DAP 의 USD 행 = 공란 행 수량만(없으면 미표시) |
| 원복 | `A_DB/99_ROLLBACK_RTFDUP_PATCH.sql` | BODY 원복 | `ROLLED BACK ... marker 0` |

- L1 이 FAIL 이면 10 을 실행하지 말고 결과를 회신(클라우드 BODY 세대 차이 — 앵커 재지정 필요).
- 05_DIAG 의 now = 이번 주 월요일. 화면 nowYyyymmdd 가 다르면 `TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD')` 를 그 값으로 바꿔 실행.
- 10/99 는 멱등(마커 기준 SKIP) · 컴파일 오류 시 원문 자동 복원(EXECUTE IMMEDIATE 를 BEGIN…EXCEPTION 으로 감쌈).

## 반영 후에도 USD 가 남는 경우 — `A_DB/06_DIAG_USD_2028_CLOUD.sql` (조회 전용 · 2026-10-19 13:13 추가)
클라우드 회신: 반영 후 USD 행이 2027-12 까지 0, 2028-01 부터 값 있음.
사내 동형 실측(SP_W_20260825_V002): 이 키의 CURRENCY 공란 행 = DAP · 20280103 · RTF_SYS_RP/RTF_PR/RTF_SCP 93,331 + SalesAmt_* 0
(CREATED_BY=SYSTEM, 버전 생성 시각). CNY 행 마지막 = RTF 20271230 · MKT_FCST 20271227 → **MKT_FCST 기간 밖 RTF 가 통화 없이 적재**되고,
조회 SP 가 SITE_ITEM 통화(USD)로 채워 표시. 복제가 아니라 원천 데이터 상태다.

| 블록 | 확인 내용 | 원인 확정 조건 |
|---|---|---|
| G0 | 마커·BODY 상태 | MARKER_LINES=2 |
| G1 | 원천 3표 공란 통화 행(월·메저·생성자) | 2028xx 행만 존재 |
| G2 | 통화 있는 행 마지막 날짜 vs 공란 첫 날짜 | LAST < FIRST_BLANK |
| G3 | SITE_ITEM 통화(채움 값) | USD |
| G4 | 표시 통화 시뮬레이션(CNY 외) | 화면의 USD 월·수량과 일치 |
| G5 | 같은 버전 40 전체 공란 통화 분포 | 이 키만인지 버전 전체 현상인지 |
| G6 | CURRENT 원장 같은 키 | 원장도 공란이면 버전 스냅샷 이전 단계 원인 |

사내 리허설 사본: `_rehearsal_06_SP_W_20260825_V002.sql` (버전만 치환).

### 클라우드 06 결과 판독 (OCGSCMQ_P01 · 2026-10-19 13:14) → `A_DB/07_DIAG_SR_E20260921_000253_CLOUD.sql`
- G0 MARKER_LINES=2 · VALID (LAST_DDL 13:05:56) — 주석 처리 반영됨
- G1 `SCUD LEV` · CIF/DAP · **202801~202808** CURRENCY 공란
  - MKT_FCST / MKT_AMT_* / SCM_FCST: CREATED_BY **`E20260921-000253`** 2026-09-28 15:24:05 (SR 번호 형식 = 데이터 적재. 사내 ALL_SOURCE 0건 → 프로그램 아님)
  - RTF_* / SalesAmt_*: CREATED_BY `SYSTEM` 2026-09-30 16:10:53 (위 적재분에서 배치 파생)
  - LAST_UPDATED system 2026-10-01 10:10:07 (버전 스냅샷)
- 결론: USD 행 = SR 적재 시 CURRENCY 누락 데이터. PKG 로직 문제 아님(CIF 는 원래 USD 라 합쳐져 안 보이고 DAP 만 USD 로 분리).

07 블록: H1 SR 적재 범위 · H1b 키 목록 · H2 같은 키 SYSTEM 파생분 · H3 이 키 공란 생성자 · H4 같은 키 기존 통화 · **H5 보정 가능성(같은 키 통화 1종=보정 가능)** · H6 버전 스냅샷 파급.
⚠ 보정 값은 SITE_ITEM 이 아니라 **같은 키의 기존 통화** 기준이어야 함 — 사내 사례에서 둘이 다른 키 존재(GREENWAY LEV CIF: 기존 USD / SITE_ITEM CNY).
사내 리허설 사본: `_rehearsal_07_E20250901-000326.sql` (사내 기존 SR 생성자로 치환 · 오류 0).

### 클라우드 07 결과 판독 (13:20 · H1 까지만 수신, 출력 한도로 잘림) → `A_DB/08_DIAG_SR_SUMMARY_CLOUD.sql` (요약형)
- SR 적재 = CURRENT `DM_PLN_SALES_PLAN` 공란 통화 MKT_FCST 1,931행/209키 + `_C` 직접 적재(15:21~15:24) 공란 MKT_FCST 25,401행/217키 · RTF_SYS_RP 11,901행/223키
- 키별 '앞 기간 통화 있음 → 이후 기간 공란' (예: Bafang MCCM348014A3 DAP 2027 CNY / 2028 공란)
- 08: S1 공란 행 생성자별 요약 · S2 버전별 파급 · S3 보정 가능성 판정별 키 수(+ SITE_ITEM 불일치 수) · S4 판단 필요 키 · S6 이 화면 키
- 사내 08 리허설(`_rehearsal_08_E20250901-000326.sql`, 오류 0)에서 관찰: 공란 통화 MKT_FCST 는 SR 외에 **화면 저장 사용자분(bkk33·danbii·jeff.hur 등, 2027-08~12 신규 기간)·이전 SR(E20260522-001828)** 에도 존재 → '새 기간 MKT_FCST 저장 시 통화 미설정' 이 반복되는 원천 결함일 가능성(미조사).

### 클라우드 08 결과 판독 (13:25)
- S1 CURRENT 공란: SR MKT_FCST·SCM_FCST 1,931 / RTF_SYS_RP 1,926 (209키) — 그 밖 생성자는 과거 소량
  · _C: SR 직접분 + **SYSTEM 파생 RTF_* 13,360 · SalesAmt_* 7,303 (195키, 09-28 ~ 10-19 11:11 계속 생성 중)**
- S2 2026-09-28 이후 **버전 14개 전부** 공란 포함(최신 SP_D_20261019_V001 5,986행/212키) → CURRENT 원장을 고치기 전까지 새 버전마다 계속 번짐
- S3 보정 판정 247키: A 같은 키 통화 1종 157(이 중 21키는 SITE_ITEM 과 다름) · B 같은 키 통화 없음(SITE_ITEM 만) 89 · D 2종 1
- S4 D = **SCUD LEV · SCUD_CN_FOC · MCCM348014A3 · CIF (CNY/USD 공존, SITE_ITEM USD)** · 이 화면 DAP 는 A(CNY)
- S6 이 화면 키 CURRENT CIF/DAP 각 24행(2028-01~08) = 전부 SR

## 사내 리허설 (ZIOUI1 · 2026-10-19)
- A(적용 상태): 99 SKIP사본 문법 OK → 00 (L1 N/A·L2 2) → 90 PASS → 10 SKIP
- B: 99 원복(md5 = 수정 전 cd60de2a…) → 수정 전 재현(USD 9,320,503) → 99 SKIP → 00 PASS → 05_DIAG(D4 DUPLICATED 검출) → 10 적용 → 10 SKIP → 90 PASS
  → 재적용 md5 = 사내 적용본 57c2de02… (UNISTR 한글 포함 동일) → 수정 후 USD 93,331 / CNY 10,175,172
- 결과 파일: `_rehearsal_out/`
