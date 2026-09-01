# DMF0044_LOCDEL_SARG_CLOUD_20260828 — 클라우드 저장 지연(타임아웃) 근본 정정

## 원인 (2026-08-28 클라우드 실측 확정 — 사용자 실행 검증쿼리 회신 기반)

- 범인 SQL = `182ttxhbfz24r` — `_C_CF`(Cutoff 저장) 실적구간 처리의
  **LOC DELETE** (`DELETE FROM DM_PLN_SALES_PLAN_REPORT_C A WHERE A.MEASURE='LOC' AND EXISTS(GTT...)`).
- 이 DELETE 만 A 측 직접 술어가 `MEASURE='LOC'` 뿐 (자매 구문 '기타 금액메저 모두 삭제'는
  `A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO` 직접 술어 보유) → 원장 FULL SCAN.
- 실측: 클라우드 **117.74초/회 · 749만 블록 · 처리 0행** (SEQ_RANK 루프 안이라 반복 실행 = 타임아웃)
  vs 사내 2.68초/회 · 44.8만 블록 (같은 SQL_ID, 원장 크기 17배 차이).

## 정정 [E20260828-LOCDELSARG]

직접 술어 2개 추가 (자매 구문과 동일 형태 — GTT 는 단일 V_VERSION_NO/V_DIVISION_ID 만
적재되는 첫 토큰 규약이므로 의미 등가):

```sql
AND A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO --[E20260828-LOCDELSARG]
```

- 사내 EXPLAIN PLAN 실측: FULL SCAN cost 60,946 → **PK INDEX RANGE SCAN cost 100** (1/609).
  인덱스 신설 불필요 (PK 경로) — 클라우드 즉시 적용 가능.
- 사내 적용 완료: 2026-08-28 09:57:37 · VALID · ERRORS 0 · 마커 2행.

## 적용 순서 (클라우드)

1. `11_PKG_DMF0044_BODY.sql` 실행 (BODY 만 — SPEC 무변경. 사내 적용 후 라이브 재추출본,
   기존 클라우드 본문과 동일 계보: 마커 CFMERGE 2/CFSETBASED 2/CFNOSTATS 1/EXAUTH 4/DS2 9 포함)
2. `90_VERIFY.sql` V1→V2 실행 (마커 6종·VALID)
3. 화면에서 저장 1회 재현 후 `90_VERIFY.sql` V3 실행 → SEC_PER_EXEC 회신

## 전제

- 클라우드에 `DMF0044_CLOUD_20260820` 기적용 상태여야 함 (2026-08-28 검증쿼리로 실측 확인됨 —
  BODY 2026-08-23 19:52 적용, 마커 일치).
- 참고: 클라우드 `optimizer_dynamic_sampling=0` (V$PARAMETER 실측) — 저장 SP 는 DS2 세션 가드로
  방어되나, 근본 조치는 DBA 의 `ALTER SYSTEM SET optimizer_dynamic_sampling = 2 SCOPE=BOTH`
  (전 화면 공통 개선, DMF0082 계보).
