# Hook #116 — SP 도입부 ALTER SESSION PARALLEL DML = 트랜잭션 가드 의무 (ORA-12841)

> **트리거**: SP/PKG 멤버 도입부에 `ALTER SESSION (DIS|EN)ABLE PARALLEL DML` 존재 · SP 가 다른 SP 의 DML 이후 내부 호출됨 · 저장 시 `ORA-12841: 트랜잭션안에 세션 병렬 DML 상태를 고칠 수 없습니다`
>
> 위반 시: 진입점 단독 테스트는 통과하지만, **DML 후 내부 호출되는 순간 무조건 실패** — E2E 시점에야 발현하는 잠재결함.

작성: 2026-07-23 (DMF0003 div82 저장 사고 — SAVE 가 DML 후 P_..._MKT_FCST_SALES_PLAN_SYNC 내부 호출 → SYNC 도입부 DISABLE PARALLEL DML 에서 ORA-12841. 클라우드 선발현·사내 동일 잠재)
관련 메모리: `feedback_sp_parallel_dml_alter_in_txn.md` / 패키지: `_deploy_packages/DMF0003_ORA12841_FIX_20260723`

---

## §1. 원리
- **PARALLEL DML 상태 변경만** 활성 트랜잭션 중 불가(ORA-12841). `PARALLEL DDL`/`PARALLEL QUERY` 변경은 합법 — 손대지 않는다.
- MSSQL→Oracle 변환 시 도입부에 관성적으로 넣는 세션 병렬 제한 3종 세트가 원인. AS-IS 에는 없던 코드.

## §2. 의무 패턴

### §2.1 DISABLE → 12841 허용 가드 (표준 fix)
```plsql
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -12841 THEN RAISE; END IF;  -- 활성 트랜잭션 중 skip (PDML 기본 비활성 → 기능 동일)
END;
```

### §2.2 ENABLE 은 skip 시 의미가 달라짐 — 호출 경로 검토 후 결정
`ENABLE PARALLEL DML` 을 skip 하면 이후 DML 이 serial 로 실행(성능만 영향, 정합성 무영향). 성능 SP 면 "호출 전 COMMIT 가능 여부"부터 검토, 아니면 동일 가드 + serial 허용 주석.

## §3. 작업 규칙
1. **치환은 비주석 라인만** — 문자열 count 는 주석 `--EXECUTE ...` 을 오탐(DMF0003 실측 6매칭 중 live 2건). 라인 단위(strip 후 정확 일치 + `--` 미시작)로 치환.
2. **검증 표준**: ① `DBMS_TRANSACTION.LOCAL_TRANSACTION_ID(TRUE)` 로 트랜잭션 강제 개시 → 무가드 = 12841 재현 / 가드 = 오류 0 ② 배포본 가드 블록 수 실측 ③ PACKAGE/BODY VALID·errors 0.
3. **sweep 의무**: 동일 사고 진단 시 전 오브젝트 검색 후 후보 목록 보고(도입부 단독 호출 = 합법이므로 일괄 수정 금지 — DML 후 내부 호출 경로만 fix):
```sql
SELECT name, type, line, TRIM(text) FROM user_source
 WHERE UPPER(text) LIKE '%ALTER SESSION%PARALLEL DML%' AND TRIM(text) NOT LIKE '--%' ORDER BY name, line;
```
4. 2026-07-23 사내 sweep 잔여 후보(참고): PKG_DMF0007 / PKG_DMF0020 / PKG_DMF0044(일부 기가드) / DMF0006·DMF0020 standalone / PR_DM_MST_SITE_CUSTOMER_HIST — 타 화면 동일 오류 시 우선 조사.
