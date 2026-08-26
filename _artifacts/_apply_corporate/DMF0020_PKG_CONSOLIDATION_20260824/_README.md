# DMF0020 — 단독 SP → `PKG_DMF0020` 통합 (2026-08-24, 사내 적용 완료)

> 계기: 클라우드 최신본 이관 후 **PKG 경유와 단독 SP 가 혼재**. UI별 PKG 원칙으로 일원화.
> 원복 지점: `_artifacts/_backup/DMF0020_PRE_PKG_CONSOLIDATION_20260824/` (소스 22본 + 배선 3표).
> 마커 = `[E20260824-PKGCONSOL]`

## 1. 무엇을 합쳤나 — 전수 대조로 판정

작업 전 단독 SP 20본을 PKG 내부 16본과 **본문 유사도로 전수 대조**했다.

| 판정 | 본수 | 처리 |
|---|---:|---|
| PKG 에 대응 없음 | **4** | **PKG 로 편입** (본문 무수정, `P_` 개명만) |
| PKG 에 이미 동일 (유사도 96~100%) | 15 | 편입 불필요 — 폐기 |
| PKG 쪽이 앞섬 | 1 | `SAVE_..._CONVERSION` — PKG 에만 **ORA-12841 가드** + `TRUNCATE→DELETE`. PKG 정본 확정 |

편입 4본:

| 단독 SP | → PKG 프로시저 | 줄수 | 배선 |
|---|---|---:|---|
| `DMF0020_GET_SCM_MST_FUTURE_PRICE` | `P_DMF0020_GET_SCM_MST_FUTURE_PRICE` | 1,194 | main·priceBatch SEARCH |
| `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` | `P_..._ALL` | 1,136 | main SAVE |
| `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` | `P_..._POPUP` | 794 | priceBatch SAVE |
| `DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` | `P_...` | 1,035 | (미배선) |

**PKG BODY 4,615 → 8,714줄 / SPEC 194 → 293줄 / 내부 프로시저 16 → 20.**

## 2. 배선 전환

`SCM_ADM_API_M` **5행** + `SCM_ADM_PROC_M` **57행**(파라미터 계약 키)을 `PKG_DMF0020.P_*` 로 전환.
→ **DMF0020 단독 SP 를 타는 배선 0건.** `titleSet`/`version` 2건만 타 화면 소유 공용으로 잔존(의도).

## 3. 폐기

단독 SP **19본 DROP**. 폐기 전 3축 안전 스윕:

- **DB 의존**: 참조 2건 발견 → 아래 §4 로 처리
- **메타**: `API_M`/`PROC_M` 에 단독 이름 잔존 0
- **소스**: `nscm-be/src` 에 단독 SP 이름 사용 0건

## 4. ⚠ 1본은 남겼다 — `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION`

호출자가 둘이었다.

| 호출자 | 위치 | 처리 |
|---|---|---|
| `PKG_DMF0020` BODY | L825 `SCM_MGR.DMF0020_SAVE_..._CONVERSION(V_DIVISION_ID, V_RC1)` | ✅ **PKG 내부 호출로 전환** (`P_` 버전, 시그니처 동일 2-arg) |
| `PR_SCM_MST_EXCHANGE_RATE` | L259 | ⛔ **미처리 — DMF0020 범위 밖 배치** |

그래서 이 1본은 DROP 하지 않았다. 완전 폐기하려면 `PR_SCM_MST_EXCHANGE_RATE` L259 를
`PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION(...)` 로 바꿔야 한다(1줄).
그 배치는 **이번 작업 전부터 INVALID** 였고(자체 컴파일 오류 0건 = 의존 전파), 이번 작업으로 악화되지 않았다.

## 5. 검증 (전 항목 PASS)

`90_VERIFY.sql` — V1 PKG VALID/VALID · V2 내부 20개 · V3 편입 4본 인자수 20/19/17/18 일치 ·
V4 단독 배선 잔존 0 · V5 PROC_M 4종 전부 `PKG_DMF0020.` 접두 · V6 배선 체인 끊김 0행.

## 6. 파일

| 파일 | 내용 |
|---|---|
| `01_PKG_DMF0020_SPEC.sql` | SPEC 293줄 (편입 4 선언 추가) |
| `02_PKG_DMF0020_BODY.sql` | BODY 8,714줄 (편입 4 + 내부 호출 전환) |
| `03_REWIRE.sql` | API_M 5 + PROC_M 3키 전환 (멱등) |
| `04_DROP_STANDALONE.sql` | 단독 19본 DROP |
| `90_VERIFY.sql` | 검증 V1~V6 |

**적용 순서** = 01 → 02 → 03 → (스모크) → 04 → 90.
클라우드 이관 시에도 동일 순서. 단 04(DROP) 는 클라우드에서 스모크 통과 후 실행할 것.

## 7. 남은 일

- 화면 스모크 (main/priceBatch/exchange/salesPriceRange/salesPriceTemplate 조회·저장)
- `PR_SCM_MST_EXCHANGE_RATE` 1줄 전환 여부 결정 → 결정 시 CONVERSION 단독본도 폐기
- 클라우드 이관 패키지화
