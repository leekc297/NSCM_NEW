# DMF0082 — CUST_FCST 종속 메저 확장 (E20260825-CUSTSUB, 2026-08-25)

사용자 지시: AS-IS DMF0003 의 81 CUST FCST 종속 메저(EDI·Commercial_Agreement 등)를
DMF0082 에서도 **데이터 기반으로** 보이게.

## 사전 확인 (실측)
- AS-IS DMF0003 본조회 = ①EDI 하위 고정 8종 확장(CSR C20191031-000137/E20241126-000426) +
  ②`DM_MST_CUSTOMER_FCST`(MEASURE_GROUP='CUST_FCST') 데이터 기반 확장 — 이중 구조
- **TO-BE PKG_DMF0003 = 이식돼 있음** (L6498~6564 실측) / **PKG_DMF0082 = 참조 0건(완전 부재)** — 사용자 관찰과 일치
- 원장(81) 하위 메저 실데이터: CUST_FCST_EDI 41,750행·Commercial_Agreement 41,137행 등

## 적용 (사내 완료)
`P_DMF0082_GET_MAIN_DATA` 의 TempSelectMeasure 기본 적재 직후에 확장 INSERT 1개:
CUST_FCST 선택 시 → EDI 8종(parent+0.11~0.18) + DM_MST_CUSTOMER_FCST 등재 메저(parent+0.10, 데이터 기반).
이름 GROUP BY + NOT EXISTS 중복 방어. RESULT_MEASURE=자기 이름(AS-IS 동일).

## 검증 (사내 — CUST_FCST 선택 실사용자 DM_A_TEST, div 81, Current)
- GTT 확장: CUST_FCST(47.0) → 하위 10종 47.10~47.18 정렬 (Customer FCST·Cutomer FCST = 데이터 기반 유입 확인)
- 스테이징 실산출: **Commercial_Agreement 224행 · CUST_FCST_EDI 224행 · CUST_FCST 688행** — 조회 창 실데이터 표시 확인
- Immidiate/Backorder 등 0행 = 해당 창 원장 무데이터 (데이터 기반 정상 — 데이터 생기면 자동 표시)
- 컴파일 VALID · O_RC1 8,627행

## 클라우드 적용
`DMF0082_CLOUD_20260825_DAILY/A_DB/02_PKG_DMF0082_BODY.sql` (금일 마커 5종 누적본) 로 반영.
