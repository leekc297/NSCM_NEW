# PKG_DMF0082_SAVECLOB_20260901 — DELETE 후 저장 SQL ERROR 근본정정

## 증상 → 원인 (사내 완전 재현, 2026-09-01)
클라우드 "조회된 ROW DELETE 후 저장 시 SQL ERROR"(신규 ROW 는 정상).
사내에서 **다중 행** 페이로드로 재현하여 원인 확정:

| 행수 | 최장 파라미터 | 결과 |
|---:|---:|---|
| 200 | 3,387자 | 정상 (검증 메시지 반환) |
| **300** | **4,927자** | **-9994 "Sql Error"** = 신고 증상 |
| 500 | 8,291자 | 동일 |

실오류 = **ORA-06502 (character string buffer too small), L11829**.
'^' 페이로드 홀더 로컬 `v_p_*` 17종이 **VARCHAR2(4000 CHAR)** 인데 IN 파라미터는 무제한 VARCHAR2 →
다건 DELETE(조회행 다수 선택) 시 4000자 초과 대입에서 폭발. **신규 ROW 는 1~2행이라 payload 가 작아 통과** — 신고 증상과 정확히 일치.

> ⚠️ 이 결함은 **hook #106 §2 패턴 B 의 기존 계보**다 (DMF0014/DMF0043/DMF0048 3연발 후 신설된 룰).
> DMF0082 만 정정에서 누락돼 있었다.

## 정정
홀더 17종 → **CLOB** (hook #106 표준). 단일 토큰(`v_p_division_id_val`, `v_p_created_by_val`)은
VARCHAR2(4000) **유지**(무분별 CLOB 화 시 토큰 루프 O(N²) 성능저하 — 룰 명시).
사전 안전조건 실측: LENGTHB/SUBSTRB 0건, 홀더 직접 사용 위험지점 0건.

## 사내 실측 (해소)
| 행수 | 결과 | 소요 |
|---:|---|---:|
| 1 / 5 / 200 | code=0 정상 (회귀 없음) | 0.5s |
| **300** | **code=0 정상** (구 -9994) | 0.7s |
| **500** | **code=0 정상** | 0.7s |
컴파일 0 오류 · CLOB 전환에 따른 성능 저하 없음.

## 적용 순서 (클라우드)
1. (선행 확인) `GT_DMF0082_SAVE_FLAG` 실존 — PKG_DMF0082_STATELESS_20260901/01 적용분
2. `01_PKG_DMF0082_BODY.sql` — STATELESS + SAVECLOB + NCHARUNION + W34 계열 통합 정본
3. `02_POSTCHECK.sql` → **P2 홀더잔존 = 0** 이 정정 완료의 증거
4. 화면에서 DELETE(다건) 후 저장 재확인

## ② [E20260901-CURRKEEP] 수량 메저 CURRENCY 표기 복원 (2026-09-01 추가)
**신고**: "UNIT PRICE 외 메저에도 자신의 단가 CURRENCY 를 가져와 표기해야 하는데 누락"(AS-IS 동등 요구).

**원인**(소스 실측): 백필 MERGE(LOC 기준 8키 — AS-IS L2284 동등)가 수량 메저 행에 통화를 채운 **직후**,
`[E20260825-CURRNORM]` UPDATE 가 `CURRENCY IS NULL OR CURRENCY <> ' '` 조건으로 **판가 5종 외 전 행을 공백으로 덮어써**
백필 결과를 소실시켰다. GET **2벌 모두**(GT_DMF0082_MF_SP / GTT_MF_SP) 동일.

**정정**: 실값은 보존하고 NULL·공백·센티널('-')만 ' ' 로 통일. VMI 계열은 AS-IS(항상 공백)와 동일 유지
→ 사용자 요구(단가 통화 표기)와 CURRNORM 본래 목적(행 분리 방지) 동시 충족.

**GTT 양성테스트 실측**(사내에 해당 조회조건 데이터 부재 → 모의행 검증):
| 입력 | 현행(결함) | 정정 후 |
|---|---|---|
| MKT_FCST [USD] (백필분) | [ ] 소실 | **[USD] 보존** |
| CUST_FCST [KRW] (백필분) | [ ] 소실 | **[KRW] 보존** |
| MKT_FCST NULL / '-' / RTF 공백 | [ ] | [ ] (동일) |
| VMI_IN_PLAN [USD] | [ ] | [ ] (AS-IS 파리티) |
| 판가 LOC/KRW/USD/MKT_AMT_* | 보존 | 보존 (무영향) |
회귀: 저장 300행 code=0 · 조회 code=0 · 컴파일 0 오류 · 마커 CURRKEEP 2/SAVECLOB 17/STATELESS 6/NCHARUNION 1.

## ③ [E20260901-MEASORDER] 메저 표시 순서 = MODAL 선택 순서 (2026-09-01 추가)
**신고**: "GRID 메저 순서가 MEASURE MODAL 선택 순서대로 나와야 하는데 혼합됨."

**원인**(소스+데이터 실측): ORDER BY 조립이
`REPLACE(V_ORDERBY,'MEASURE_GROUP', CAST(SORT_ORDER_NO ...))` → `REPLACE(V_ORDERBY,', MEASURE','')` 2단인데,
사용자 컬럼목록(titleset 'C')에 **MEASURE_GROUP 이 없으면** 치환은 무발생하고 `, MEASURE` 제거만 실행되어
**ORDER BY 에서 메저 정렬 기준이 통째로 사라진다**(표시 순서 비결정). 실측: minyonglee1 C 목록 15컬럼에
MEASURE 는 있으나 MEASURE_GROUP 없음 / AS-IS 사용자들도 둘 다 없음(로직은 AS-IS 1:1 이나 정렬키가 없는 상태).

**정정**: 정렬키 부재 시 titleset 'M' 순번(= 모달 선택 순서 그대로 저장, FE `sortOrderNo: i+1`)을 말미에 추가.
SORT_ORDER_NO 는 PIVOT 소스 SELECT 에 실재(L4062/4073)하여 PIVOT 이후 ORDER BY 사용 가능. GET 2벌 모두.

**양성테스트 실측**(문자열 조립 3케이스):
| 입력 | 결과 |
|---|---|
| 신고상황(MEASURE만 보유) | `… ITEM_ID, CURRENCY, CAST(SORT_ORDER_NO AS NUMBER(10,2))` **정렬키 복원** |
| MEASURE_GROUP 보유(기존 경로) | 기존과 동일 **회귀 없음** |
| C_TITLE 0행 | `ORDER BY CAST(SORT_ORDER_NO …)` **빈 문자열 방어** |
회귀: 조회 code=0 · 저장 300행 code=0 · 컴파일 0 오류 · 마커 MEASORDER 2.

## ⚠ 동일 결함 잔존 (별건 — 사용자 판단 대기)
'^' bulk 저장 SP 전수 스윕 결과 **8개 소스**에 같은 패턴이 남아 있다(원장 X05):
DMF0000_SAVE_EXCHANGE_POPUP_DATA · DMF0014_SAVE_CUST_FCST_UPLOAD_DATA · DMF0043_SAVE_DM_MST_CONTRIBUTE_VER ·
PKG_DMF0000 · PKG_DMF0003 · PKG_DMF0020 · PKG_DMF0042 · PKG_DMF0043
(각 홀더 수 다름 — 정정 전 홀더/단일토큰 정밀 분류 필요. 대량 저장 시 동일 사고 대기 중)
