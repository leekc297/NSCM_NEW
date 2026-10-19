# DMF0082 환율 저장 Sales Plan 재계산 + DMF0004 저장 이력(_H) 복원 — 클라우드 이관

> ⚠ **2026-09-29: DMF0004 부분(21~25)은 폐기 — `DMF0004_HIST_CLOUD_20260929`(rev2) 로 적용할 것.**
> 이 패키지의 23 은 고정 컬럼 목록이라 DEPT_ID 가 삭제된 클라우드에서 `ORA-00904 "S"."DEPT_ID"` 로 컴파일 실패한다.
> DMF0082 부분(00 의 [H1]/[H4]/[H5]/[F] · 11 · 12 · 90 [V2])만 유효.

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_EXRATE_DMF0004_HIST_CLOUD_20260928` |
| 범위 | **DB 전용** (FE / BE 변경 없음 · 메타 PROC_M/API_M/BTN_MPG 변경 없음 · 신규 MSG/LBL/MNU 없음) |
| 사내 적용 | **완료 · 검증 PASS** (222.110.191.243:2521/ZIOUI1 / SCM_MGR, 2026-09-28) |
| 클라우드 | **미적용** |
| 원문 | 사내 USER_SOURCE 재추출 (각 파일 1행 `SOURCE-FRESH` 스탬프 · 24h 초과 시 재빌드) |
| 사내 적용 산출물 | `_artifacts/_apply_corporate/DMF0082_EXRATE_SALESPLAN_20260928/` · `_artifacts/_apply_corporate/DMF0004_HIST_20260928/` |

---

## 1. 변경 내용

### A. [E20260928-EXRSP] DMF0082 환율 팝업 저장 → Sales Plan 재계산
- `PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA` 의 `/* TO-DO 4/1 전환 예정 … */` 주석 해제 →
  `SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(V_DIVISION_ID, 'EXCHANGE_RATE_UI')` 호출 (AS-IS `DMF0000_SAVE_EXCHANGE_POPUP_DATA` L378 파리티)
- 호출 대상 = standalone 유지 (배치·타 SP 9곳 공용). 내부 COMMIT 없음 → 환율·Sales Price·Sales Plan 한 트랜잭션.
- 변경량: 본문 1148→1149줄 (주석 해제 1곳 + 설명 주석). 그 외 SP 무변경.
- ⏱ 사내 드라이런 Division 40 = 176초 (Sales Plan 67,246행) — FE 타임아웃 300초 이내.

### B. [E20260928-D4HIST] DMF0004 저장 이력(_H) 복원
| 저장 SP | 이력 | 위치 |
|---|---|---|
| Site | `P_PR_DM_MST_SITE_HIST` (저장 후 SITE 행 복사) · 공용 `PR_DM_MST_SITE_CUSTOMER_HIST` (M·Active N) | DML 직후 / COMMIT 후 |
| Customer | 공용 `PR_DM_MST_SITE_CUSTOMER_HIST` | COMMIT 후 |
| Location | `P_PR_DM_MST_SITE_SLOC_MAPPING_HIST` (AS-IS 인자 1:1) | UPSERT 직전 |
| Bucket | `P_PR_DM_MST_BUCKET_CONVERSION_HIST` (AS-IS 인자 1:1) | UPDATE/INSERT 직전 |

- standalone 3종 → PKG_DMF0004 합류 후 삭제 (호출처 DMF0004 전용 — AS-IS/TO-BE 전수 조사). 합류 멤버는 내부 COMMIT/ROLLBACK 만 제거.
- `PR_DM_MST_SITE_CUSTOMER_HIST` 는 DMF0008·SCP0001 공용 → **standalone 유지·본문 무수정** (내부 COMMIT 때문에 저장 COMMIT 후 호출).
- `SCM_MST_SITE_H` = HISTORY_SEQ + **SCM_MST_SITE 39컬럼(동일 순서·타입)** + HISTORY_CREATION_DATE
  (SCM_SITE_ID 60 CHAR / DEPT_ID 맨 끝·NULL 허용·기본값 없음 / VALID_YN DEFAULT 'N' NOT NULL / 감사 4컬럼 NULL 허용 유지 — SCP0001 이 화면 CREATION_DATE 전달).
  INVISIBLE→VISIBLE 재배치 = 데이터 이동 없음·PK/권한/시노님/주석 보존.

---

## 2. 작업 ↔ 파일 대조표 (적용 순서)

| 순서 | 파일 | 내용 | 전제 / 멱등 |
|---|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | READ-ONLY 선판정 | — |
| 2 | [A_DB/11_PKG_DMF0000_BODY.sql](A_DB/11_PKG_DMF0000_BODY.sql) | A: PKG_DMF0000 BODY 교체 | **[H1]=MATCH_BEFORE** 일 때만 · CREATE OR REPLACE |
| 3 | [A_DB/12_RECOMPILE_DMF0020.sql](A_DB/12_RECOMPILE_DMF0020.sql) | A: PKG_DMF0020 / DMF0020_SAVE_…_ALL 재컴파일 | 멱등 |
| 4 | [A_DB/21_SCM_MST_SITE_H_ALIGN.sql](A_DB/21_SCM_MST_SITE_H_ALIGN.sql) | B: _H 백업 CTAS + 정합 DDL (조건부 PL/SQL) | **[C1] MISSING=0 · [C3] NULL_VALID_YN=0** · 멱등(SKIP) |
| 5 | [A_DB/22_PKG_DMF0004_SPEC.sql](A_DB/22_PKG_DMF0004_SPEC.sql) | B: SPEC 멤버 3종 선언 | **[H2]=MATCH_BEFORE** |
| 6 | [A_DB/23_PKG_DMF0004_BODY.sql](A_DB/23_PKG_DMF0004_BODY.sql) | B: BODY 배선 + 멤버 3종 | **[H3]=MATCH_BEFORE** · 4 선적용 필수 |
| 7 | [A_DB/24_RECOMPILE_INVALID.sql](A_DB/24_RECOMPILE_INVALID.sql) | B: _H·PKG 의존 INVALID 동적 재컴파일 | 멱등 |
| 8 | [A_DB/25_DROP_STANDALONE_HIST.sql](A_DB/25_DROP_STANDALONE_HIST.sql) | B: standalone 3종 + SCMP_APP 시노님 DROP (시노님 먼저) | **[E] 외부 호출처 0** · 멱등(SKIP) |
| 9 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | 값 단언 V1~V5 (드라이런은 ROLLBACK) | 조회 전용 |

롤백 전용 (평소 실행 안 함): `99_ROLLBACK_PKG_DMF0000_BODY.sql` · `99_ROLLBACK_PKG_DMF0004.sql`(SPEC+BODY) ·
`99_ROLLBACK_STANDALONE_HIST.sql`(본문+GRANT+시노님) · `99_ROLLBACK_SCM_MST_SITE_H.sql`(기본값/NULL 규칙).

---

## 3. PRECHECK 판정표

| 항목 | 기대 | 벗어나면 |
|---|---|---|
| [H1] PKG_DMF0000 BODY 지문 | `MATCH_BEFORE` (1148줄/46,825자) | `MATCH_AFTER` = 이미 적용 → 2 SKIP · `MISMATCH` = **2 중단**, 클라우드 본문 차이 확인 후 재빌드 |
| [H2] PKG_DMF0004 SPEC 지문 | `MATCH_BEFORE` (71줄/2,055자) | 동일 |
| [H3] PKG_DMF0004 BODY 지문 | `MATCH_BEFORE` (1403줄/50,884자) | 동일 |
| [H4] PR_DM_ANL…LOCAL_KRW / PR_DM_MST_SITE_CUSTOMER_HIST | `MATCH` | §5 참고 |
| [H5] PR_DM_ANL…LOCAL_KRW 활성 COMMIT | 0 | ≥1 이면 A 적용 시 환율 저장 도중 커밋 발생(원자성 약화) — 사내 09-23 판 이관 선행 권장 |
| [C1] SCM_MST_SITE 39컬럼 | MISSING_CNT=0 | 23 컴파일 실패(행 복사 컬럼 목록) → 중단 |
| [C3] _H NULL VALID_YN | 0 | 21 의 NOT NULL 재설정 실패 → 데이터 정리 후 진행 |
| [E] standalone 3종 외부 호출처 | 0행 | 25 보류 |

> 지문 = `USER_SOURCE` 줄수 + `SUM(LENGTH(RTRIM(TEXT, CR/LF)))`. 사내 5개 객체에서 파이썬 산출값과 DB 산출값 일치 확인.

---

## 4. 사내 사전 실행 결과 (이 패키지를 사내 ZIOUI1 = 적용 후 상태에 그대로 실행, 2026-09-28)
- 00: H1~H3 `MATCH_AFTER` · H4 `MATCH` ×2 · H5 0 · C1 0 · C3 0 · E 0행
- 21: SKIP ×5 / 24: INVALID 0 / 25: SKIP ×6
- 90: V1 전부 VALID · V2 ACTIVE=1·TODO=0 · V3 BAD=0 · V4 6,681=6,681 · V5 +1/+1/+1 → ROLLBACK 후 0/0/0
- 저장 SP 4종 실데이터 E2E (사내, 사용자 승인): SITE_H 1 · CUSTOMER_H 1 · LOCATION_H 1 · BUCKET_H 7 — 원복 후 잔여 0

---

## 5. 주의
- **본문 교체 3종(11·22·23)은 지문 MATCH_BEFORE 가 전제.** 클라우드에 다른 작업자 변경이 먼저 들어가 있으면 덮어쓰게 되므로 MISMATCH 시 적용하지 말 것.
  (이력: PKG_DMF0000 은 07-24 `DMF0082_EXCHANGE_SAVE_20260724_1241` 이후 사내 09-02 변경분 존재 / PKG_DMF0004 는 본 계열 패키지 이관 이력 없음)
- [H4] MISMATCH: 호출 대상 standalone 이 사내와 다름 — 기능 동작에는 필수 아님(시그니처 동일 시). 시그니처 차이 시 23 컴파일 오류로 드러남.
- 데이터 DML 0건 (백업 CTAS 1건 제외). 사내 전값 WHERE 없음.
- A 적용 후 환율 저장 응답이 Division 단위 Sales Plan 재생성 시간만큼 늘어난다 (사내 40 = 약 3분).
