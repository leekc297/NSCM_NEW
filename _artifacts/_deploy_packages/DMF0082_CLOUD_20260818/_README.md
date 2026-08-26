# DMF0082 (FCST&PRICE MGMT) 클라우드 이관 패키지 — 2026-08-18 취합

> **상태: 취합 완료 / 클라우드 미적용.** 직전 클라우드 패키지 = `DMF0082_PERF_CLOUD_20260815`.
> 본 패키지 = **그 이후 delta 전량** (기계 스윕 실측 — 메타 10테이블 `LAST_UPDATE_DATE >= 2026-08-16`
> + 공유 자산 직접 확인. 스윕 결과: CMBO 2 + 공유 CMBO 2 + SHEET_COLUMNS 1 / 그 외 8테이블 delta 0).
> DB 원문은 전부 **사내 배포본 ALL_SOURCE·원장 신선 덤프** (파일 재사용 아님).

## 담긴 정정 (전부 2026-08-18 사내 적용·실증 완료)

| # | 정정 | 마커/식별 | 신고 증상 |
|---|---|---|---|
| 1 | **Excel Upload 2-Step NOT_SAVABLE** — 배치 유도의 `UPLOAD_STATUS_CODE='UPLOAD'` 필터 제거(정본 DMF0074 패턴). [Upload]가 분류하며 상태를 바꾼 뒤 [OK]가 배치를 못 찾던 결함 | `[E20260818-UPLOADBATCH]` | `NOT_SAVABLE (SUCCESS=0, ERROR=0)` |
| 2 | **52주 판가 검증 1단계 전진** — [OK] 전체 실패 대신 [Upload] 분류에서 위반 키 행별 ERROR + 미입력 주차 병기. 판정 산식 = SAVE 검증 1.2+10 1:1(SENTINEL3·FCSTNAME 동일). 2단계 검증은 방어선으로 유지 | `[E20260818-PRICECHK1]` | `Unit Price Not Found` 가 [OK]에서 통짜 실패 |
| 3 | **그리드 End Customer 셀 콤보 division 3분기** — (3) 81/82 = 조회조건과 동일 축(`SCM_MST_SITE.END_CUSTOMER`). 종전 ② 분기가 division 무관 PROJECT_CODE 를 반환해 81/82 매핑 전멸 | `[E20260818-ENDCUST81]` | 그리드 End Customer 코드 표시·Insert 후보 오염 |
| 4 | **`SiteEndCustomerMapDMF0082` 신규** — FE 표시/키 분리용 site→End Customer 맵 (`(DIV,SITE)` 유일성 실측 0중복) | CMBO 신규 | — |
| 5 | **(공유 ⚠) `EndCustomer` 정렬** — `ORDER BY DIVISION_ID, DEPT_ID, CODE` → `DIVISION_ID, NAME, CODE` (팀 우선 정렬이 드롭다운에서 무작위로 보임) | 03 파일 ③ | 조회조건 End Customer Sort 미적용 |
| 6 | **환율 [BPS I/F] PLS-00201** — 래퍼 `PR_SCM_MST_EXCHANGE_RATE_UI` 앱 계정 노출 세트(GRANT+시노님) 누락 | 04 파일 | BPS I/F 클릭 시 SQL ERROR |
| 7 | **FE ENDCUSTDISP** — 비40 그리드 END_CUSTOMER 표시값을 조회조건 축으로 파생(`END_CUSTOMER_KEY` 로 원장 키 보존 — `DM_PLN_CFM_*` **PK 에 END_CUSTOMER 포함**이라 표시값 저장 시 중복 적재). 저장·중복키는 KEY 우선(`keyOf` 단일 지점) | ForecastPrice.tsx / save.ts | 조회조건·그리드 End Customer 불일치 |
| 8 | **FE 기타** — W/S 메저 3분기(사이트 미입력=3종 — `q('')→'ALL'` 오전달 정정) · `comboParams.divisionId` 전달(Insert 시 타 division 후보 차단, 5콤보 0행 없음 실측) · 환율 모달 Save 건수 표기 제거 · BPS I/F 실패 시 EVENT(실오류) 노출 | ForecastPriceGrid.tsx 외 | 메저 2종만 표시 / Save (N) 표기 |
| 9 | **(공유 ⚠) CustomDropdown** — 조회조건 콤보 센티널 4형(`' '`/`''`/`'-'`/`'--'`) 표시 제외(선택값 보존) + 전체 선택 = `'ALL'` sentinel 수렴(센티널 행도 ALL 조회 포함) | B_FE/shared | 조회조건 중복·센티널 노출 |

## 파일 구성

```
00_CLOUD_PRECHECK.sql                 적용 전 확인 (마커 기준선 C1 / 참조 GTT 9종 C2 / lookup C3 / 공유콤보 C4)
A_DB/01_PKG_DMF0082_SPEC.sql          92줄   (신선 덤프 — 클라우드에 기존재 시 재실행 무해)
A_DB/02_PKG_DMF0082_BODY.sql          14,412줄 (⭐ 본문 전체 교체 — UPLOADBATCH+PRICECHK1 포함.
                                       ⚠ C1 에서 SENTINEL3/FCSTNAME/UPLOADSAVE 가 0이면 클라우드는
                                       08-13~15 정정도 미적용 상태 — 본 교체로 일괄 반영, 회귀 범위 큼)
A_DB/03_CMBO_DMF0082_20260818.sql     콤보 3본 MERGE (②③④⑤)
A_DB/04_GRANT_SYNONYM_EXCHANGE_RATE_UI.sql  ⑥ (시노님 2문은 DBA/앱계정 실행)
A_DB/05_META_SHEET_COLUMNS_20260818.sql     스윕 delta 1행 (END_CUSTOMER 셀 콤보 배선)
A_DB/90_VERIFY.sql                    적용 후 검증 (마커·콤보·GRANT/시노님·런타임 스모크 4종)
B_FE/forecast-price/                  화면 폴더 **전체** (부분 이관 금지 — resolveView 사고 계보)
B_FE/shared/customDropdown/           공용 드롭다운 (⚠ 전 화면 영향 — ⑨)
```

## 적용 순서

1. `00_CLOUD_PRECHECK.sql` (QA/DEV 각각) — C1 마커 기준선 기록
2. `A_DB` 01 → 02(라이브면 `DDL_LOCK_TIMEOUT=120`) → 03 → 04(시노님은 DBA) → 05
3. `90_VERIFY.sql` — V1~V4 기대치 + V5 런타임 스모크 4종
4. `B_FE` — forecast-price 폴더 전체 + customDropdown 교체, 빌드·배포

## 사내 실증 근거 (2026-08-18)

- ①: 실사고 배치(18:36, SUCCESS 14) 재현 → 정정 후 유도 시뮬 `v_creation_date` 적중·SAVABLE
- ②: 실사용자 배치(18:59) P_MODE=0 직접 재실행 → **SUCCESS 10 / ERROR 4** (신고 키 INFAC/MCMMA38038A1-016 포함, 미입력 주차 병기 실측)
- ③: div 81 콤보 1,338종 / 원장 316종 전건 매핑 · 40/82 회귀 0
- ⑤: div 81 반환 A→Z 실측 / ⑥: GRANT·시노님 각 2행 + BPS I/F 성공(CODE=0) 로그 실측
- FE: `tsc --noEmit` 잔여 0 (BACKUP 폴더 기존 4건 제외) / vitest forecast-price 32 PASS(기존 실패 2건 무관)

## 미포함 (별개 패키지)

- DMF0021 RTFGATE2·MSG01001 / DMF0074 MRFPARITY — 각 화면 패키지로 별도 (`DMF0074_CLOUD_20260818` 기취합)
- FE `BACKUP_20260818/` 폴더 — 이관 대상 아님
