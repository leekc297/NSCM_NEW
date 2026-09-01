# DMF0044_0049_SARGSWEEP_CLOUD_20260828 — Version 모달 + DMF0049 전 오퍼레이션 속도 정정

## 배경 (REQ:CHAT-20260828-03/-04)

LOCDELSARG(클라우드 저장 117초→개선 확인) 와 **동일 기준**으로 PKG_DMF0044(23 프로시저) +
PKG_DMF0049(4 프로시저) 전체를 전수 스윕(대형 영구 테이블 DELETE/UPDATE/MERGE 의
직접 술어 부재 = FULL SCAN 계열). 도구 = `_artifacts/_diagnostics/DMF0044_0049_SARG_SWEEP_20260828/`.

## 정정 [E20260828-SARGSWEEP] — 7개 구문

### PKG_DMF0044 (4)
1. **버전 COPY/CREATE 내 BIZ_TYPE 보강 MERGE** (`P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY`) —
   ON 절에 VERSION_NO 부재로 **3.93M 원장 전 버전 조인**. 필터를 ON 절로 이동
   (WHEN NOT MATCHED 부재 = 등가, CFMERGE 계보). **EXPLAIN cost 61,337 → 800 실측**.
2. ETC 저장 'D' DELETE (`P_DMF0044_SAVE_SALES_PLAN_REPORT_C`, PLAN_REPORT_C 3.93M) — 직접 술어 추가.
3. ETC 원장 'D' DELETE (동일 SP, ETC_REPORT_C) — 직접 술어 추가.
4. ETC 중복행 정리 DELETE inner 스캔 (동일 SP) — 직접 술어 추가.

### PKG_DMF0049 (3) — `P_DMF0049_SAVE_SALES_ETC_REPORT_C`
5. 'D' DELETE — 직접 술어 추가.
6. 수량 UPDATE — 직접 술어 추가.
7. PKGUARD 선삭제 (tuple-IN) — 직접 술어 추가.

### DIVISION NOT NULL 규약 (사용자 지시 2026-08-28)
- GTT 적재 가공부에 `DIVISION_ID IS NULL → '-'` 정규화 신설(PKG_DMF0049).
- WHERE/JOIN 의 `NVL(DIVISION_ID,'-')` 제거 (PKGUARD IN 절). SELECT 목록의
  적재 초기값 NVL 은 보존(그것이 초기값 처리 지점).

### 스윕 판정 기록 (수정 불요 판정분)
- Version 모달 CREATE/COPY/DELETE/TRANSFER/CANCEL 의 DELETE 류 — 전부 직접 술어 기보유 OK.
- Version SP 행별 루프 — 없음(전부 set-based).
- Exchange 저장 SP 의 LOC DELETE 류 1건 — 대상 테이블 244블록 소형 = 비병목 판정.
- Exchange 저장 MERGE 2건(PLAN_REPORT_C) — USING 이 GTT 조인 구동(ROWID 기반) = 정상.
- PKG_DMF0049 — MERGE 없음.

## 사내 적용: 2026-08-28 10:32:40 · 두 BODY VALID · ERRORS 0 · 마커 6/4행 실측.

## 적용 순서 (클라우드)
1. `11_PKG_DMF0044_BODY.sql` → `12_PKG_DMF0049_BODY.sql` (BODY 만 — SPEC 무변경)
   ⚠ 11 은 LOCDELSARG(선행 델타 `DMF0044_LOCDEL_SARG_CLOUD_20260828`) 를 **포함**하므로
   그 패키지를 아직 적용 전이면 본 11 만 적용해도 된다(마커 LOCDELSARG=2 동봉).
2. `90_VERIFY.sql` V1·V2 → 화면 재현 후 V3 회신.
