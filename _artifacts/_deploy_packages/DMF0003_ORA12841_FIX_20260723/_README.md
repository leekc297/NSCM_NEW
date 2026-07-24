# DMF0003 저장(div 82) ORA-12841 fix — 2026-07-23

## 오류 (클라우드 실측)
```
ORA-20001: [PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST] ... ORA-12841: 트랜잭션안에 세션 병렬 DML 상태를 고칠 수 없습니다
BACKTRACE: PKG_DMF0003 13241행 → 13608행 → 11857행 → 11983행
```

## 근본 원인 (구조)
- `P_DMF0003_SAVE_MKT_FCST` 는 저장 DML 수행 후(=트랜잭션 활성) **div 82 이면 실시간 연동**(E20230608-000891)으로
  `P_DMF0003_MKT_FCST_SALES_PLAN_SYNC` 를 내부 호출 (L11857).
- SYNC 도입부(L13241)의 `ALTER SESSION DISABLE PARALLEL DML` 은 **활성 트랜잭션 중 실행 불가**(ORA-12841 — PARALLEL DML 상태 변경 전용 제약; DDL/QUERY 는 합법).
- 동일 패턴이 `P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` 도입부(L13728)에도 존재.
- 사내에서도 div 82 SAVE 실행 시 동일 발생하는 **잠재결함**(E2E 미수행으로 미발현) — 클라우드에서 먼저 발현.

## 보완 (본문 해당 지점만, 그 외 무수정)
비주석 `DISABLE PARALLEL DML` 2개 지점을 **ORA-12841 허용 가드**로 치환:
```plsql
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -12841 THEN RAISE; END IF;  -- 활성 트랜잭션 중엔 skip (PDML 기본 비활성 → 기능 동일)
END;
```
(DISABLE PARALLEL DDL/QUERY 는 트랜잭션 중 합법 — 무변경. 주석행 4건은 그대로.)

## 적용 (클라우드)
```
sp/PKG_DMF0003_BODY_12841fix.sql   (BODY 전체 재배포 — titleset 면역 가드 포함 최신 live 기준)
```

## 검증 (사내 OCGSCMD_P01, 2026-07-23 적용 완료)
- 치환 2건(비주석 라인만; 주석 4건 오탐 배제), PACKAGE/BODY VALID, errors 0.
- **재현 테스트**: 활성 트랜잭션 중 무가드 ALTER → ORA-12841 재현 확인 / **가드 버전 → 오류 0 (PASS)**.
- 배포본 가드 블록 2건 반영 실측.

## 전 오브젝트 sweep (참고 — 동일 계열 잠재 후보)
비주석 `ALTER SESSION ... PARALLEL DML` 보유: PKG_DMF0007(L1364) / PKG_DMF0020(L2116·2130·4351) / PKG_DMF0044(ENABLE 4곳+DISABLE 일부 무가드 — 일부는 이미 가드 적용됨) / DMF0006·DMF0020 standalone / PR_DM_MST_SITE_CUSTOMER_HIST.
→ **프로시저 도입부(트랜잭션 없음)에서 실행되는 경우는 합법.** DML 후 내부 호출 경로에서만 문제 — DMF0003 외 화면에서 동일 오류 발생 시 이 목록 우선 조사.

## 잔여
- 클라우드 BODY 재배포 후 div 82 저장 재시도 → 정상 저장 + Sales Plan 연동 반영 확인.
