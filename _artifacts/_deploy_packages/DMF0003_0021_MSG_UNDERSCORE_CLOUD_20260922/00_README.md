# PKG_DMF0003 / PKG_DMF0021 — 저장 Validation 메시지 '_' 길이맞춤 제거 (클라우드 이관)

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0003_0021_MSG_UNDERSCORE_CLOUD_20260922` |
| 변경 | 저장 Validation 팝업 라벨 `End Customer________ : NT` → `End Customer : NT` (마커 `[E20260922-MSGUNDERSCORE]`) |
| 범위 | **DB 전용** — PKG BODY 2종 (SPEC · 메타 · FE · BE 무변경) |
| 사내 적용 | 완료 · VALID (ZIOUI1, 2026-09-22 14:23) — `_apply_corporate/DMF0003_0021_MSG_UNDERSCORE_20260922/` |
| 원문 | 사내 USER_SOURCE 재조회본 (FRESH-GATE: 추출 직전 live = 사내 적용본 EQUAL) · 각 파일 머리 SOURCE-FRESH 스탬프 |

## 변경 내역
| PKG | 줄 | 라벨 |
|---|---|---|
| PKG_DMF0003 | 2블록 18줄 | End Customer / Project, Sales site, Model, Customs Handbook, Fcst Type, Incoterms, Plant Site, YYYYMMDD |
| PKG_DMF0021 | 1블록 9줄 | Project Code, Sales site, Model, Customs Handbook, Fcst Type, Incoterms, Plant Site, Cell Prod Site, Week |

## 적용 순서
1. `A_DB/00_PRECHECK_CLOUD.sql` — **조회 전용**. 판정:
   - **[B] `*** CLOUD_ONLY ***` 행이 있으면 중단** — 클라우드에만 있는 수정이 BODY 전체 교체로 사라진다. 결과 공유 요청.
   - [B] `CORP_ONLY` / `COUNT_DIFF` 행 = 사내에만 있는 수정 → 이번 교체로 클라우드에 **함께 반영된다**. 목록 확인 후 진행 여부 판단.
   - [B] 0행 = 마커 기준 동일 → 진행.
   - [A] `MSGUNDERSCORE` 가 이미 있으면 기적용(재실행 무해).
2. `A_DB/05_BACKUP_CLOUD_BODY.sql` — 클라우드 현행 BODY 2종을 파일로 저장 (롤백용).
3. `A_DB/01_PKG_DMF0003_BODY.sql` → `A_DB/02_PKG_DMF0021_BODY.sql` (CREATE OR REPLACE, 순서 무관)
4. `A_DB/90_VERIFY.sql` — 전부 PASS 기대: VALID · ERRORS 0 · PADDED_LABELS 0 · MSGUNDERSCORE DMF0003=2 / DMF0021=1 · BODY_LINES 15273 / 3873

## 롤백
2번에서 저장한 `BACKUP_CLOUD_PKG_DMF00xx_BODY.sql` 앞에 `CREATE OR REPLACE ` 를 붙여 실행.

## 사내 사전 검증 (2026-09-22)
- PRECHECK: [A] PADDED 0 / MSGUNDERSCORE 2·1 · [B] 0행 (마커 집계 SQL = Python 집계 일치: DMF0003 70종 232건, DMF0021 39종 137건)
- VERIFY: 전부 PASS
- 화면 저장 재현(E2E)은 미실행

## MSG / LBL / MNU / BTN
신규 0 · 변경 0.
