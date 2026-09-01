# DMF0074 Excel Upload Validation — 클라우드 확인 절차 (2026-08-31)

> DMF0014 와 동일 표준 (기대값=실측 기준·단일시트 업로드·시효 명기). 사내 최종 PASS 실측 = 08-27 리포트(47/49 — 잔여 2건도 08-31 기대값 정정으로 해소).

## 파일

| 경로 | 용도 |
|---|---|
| `cases/00_OK-N.xlsx ~ 53_GATE.xlsx` (49본) | **실제 업로드용 단일 시트 파일** — division 40 / DMF0074_40 53열 양식 |
| `DMF0074_ExcelUpload_ValidationCases_20260831.xlsx` | 00_INDEX + 케이스별 시트 — 열람/대조용. ⚠ **업로드 금지** (BE 는 첫 시트만 읽음) |
| `사내_실측_리포트_*.md` | 08-27(정상 데이터 상태 — 최종 PASS) / 08-31(SPW 원장 소실 상태 — 데이터 전제 미충족 시의 증상 견본) |

## ⚠⚠ 데이터 전제 (이게 핵심 — 08-31 사내에서 실측된 함정)

C19(SPW 조합)·C3(MRF 버전) 및 **화면 조회 자체**가 `MAX(SP_W·ATTRIBUTE7='Y')` 버전의 SPW 원장(PLAN_C/RESULT_C)에 의존합니다.
- 원장이 비어 있으면(재적재 직후 등) **정상 케이스 포함 대부분이 'Invalid Sales Plan Waterfall MODEL.' 로 반려** — 규칙 결함이 아니라 데이터 상태 이슈 (08-31 사내 실측: MRF 버전 SP_W_20260728_V002 의 원장 0행 → 12케이스 마스킹)
- **테스트 전 `A_DB/90_VERIFY.sql` 의 ANCHOR-1/-2 를 먼저 실행**:
  - ANCHOR-1 (MRF 버전 원장 행수) = 0 → MRF 플래그가 실원장 보유 버전에 있는지 정비 필요
  - ANCHOR-2 (기준행 Isuzu 조합) = 0 → 기준행 교체 필요: 그 환경 원장에서 유효 조합을 뽑아 알려주시면 시트 재생성 (후보 추출 쿼리 = `_artifacts/…/scratchpad` 아닌 요청 시 제공)

## 진행 방법

1. `A_DB` 적용 (QA·DEV) → `90_VERIFY` 전 게이트 + ANCHOR PASS 확인
2. Metal Link Price(DMF0074) 화면(division 40) → [Upload] → `cases/` 를 00 → 53 순서로 업로드, 00_INDEX 기대 메시지와 대조
3. 특이 케이스:
   - `01_C2`(Div 공란): **SKIP 1건이 정상** (BE 가 스테이징 단계에서 SKIP 선처리 — 오류 아님)
   - `53_GATE`: [Upload] 시 'NULL PLAN DATE.' 1건이 정상. **진짜 판정은 수동 축** — Error 잔존 상태에서 [OK](P_MODE=1) 호출 시 CODE='-1' + 원장 Δ0
   - N/A 6건(04/10/23/25/33/52): division 40 양식 대상 외 또는 검증 아님 — INDEX 비고 참조
4. 시효: `Plan Date` 기준값 202610 — **2026-10 월이 지나면** 'Past Date.' 오탐 → 생성기 재실행 필요
