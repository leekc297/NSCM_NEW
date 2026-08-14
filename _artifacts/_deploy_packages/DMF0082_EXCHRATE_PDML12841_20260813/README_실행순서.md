# DMF0082 환율 저장 오류(ORA-12841) 클라우드 적용 — 2026-08-13

## 증상·원인
- 환율 모달 수정(M) 저장 시 오류: `ORA-20001: [PKG_DMF0000] … [PKG_DMF0020] SQLCODE=-12841 — 트랜잭션안에 세션 병렬 DML 상태를 고칠 수 없습니다`
- 경로: `PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA` (환율 DML) → 같은 트랜잭션에서
  `PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` (Sales Price 재계산) 내부호출 →
  그 도입부 `ALTER SESSION ENABLE PARALLEL DML` 이 활성 트랜잭션 중 실행 금지라 즉사.
- DMF0003 ORA-12841 계보 동일 (`_deploy_packages/DMF0003_ORA12841_FIX_20260723` 참조). 진입점 단독 테스트로는 미발현.

## 적용 내용 (수정 1곳 — QA·DEV 각각, SCM_MGR)

⚠ **사내 본문 전문 덮어쓰기 금지** — 클라우드 PKG_DMF0020 본문이 사내와 세대가 다를 수 있음(셸 신·구 혼재 계보).
반드시 **클라우드 현행 본문을 추출해 아래 1곳만 수정** 후 재컴파일할 것.

1. 클라우드 현행 본문 추출(백업 겸):
```sql
SELECT TEXT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0020' AND TYPE='PACKAGE BODY' ORDER BY LINE;
```
2. `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` 내부(사내 기준 :4351 — STEP 1 직전)의
   **비주석 라이브 라인 1곳** 을 치환 (⚠ 같은 SP 에 `--EXECUTE …` 주석분 4곳 있음 — 주석은 건드리지 말 것):

변경 전:
```sql
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
```
변경 후:
```sql
    -- [E20260813-PDML12841] 환율 저장(PKG_DMF0000 SAVE_EXCHANGE_POPUP_DATA)이 트랜잭션 중 본 SP 를
    --   내부호출하면 PDML 전환이 ORA-12841 로 실패 → 저장 전체 오류 (2026-08-13 실사고).
    --   트랜잭션 중이면 전환 생략(직렬 실행) — DMF0003 동일 계보 가드.
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE != -12841 THEN
                RAISE;
            END IF;
    END;
```
3. `CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0020 …` 재컴파일
   (적용 세션에서 `ALTER SESSION SET DDL_LOCK_TIMEOUT = 30;` 선행 — 사용 중 잠금 대기).

## VERIFY
```sql
-- 1) 컴파일 상태
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0020';   -- BODY = VALID

-- 2) 마커 존재 + 라이브 ALTER 가드 확인
SELECT LINE, TEXT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0020' AND TYPE='PACKAGE BODY'
   AND (TEXT LIKE '%E20260813-PDML12841%' OR UPPER(TEXT) LIKE '%ENABLE PARALLEL DML%')
 ORDER BY LINE;  -- ENABLE 라이브 라인이 BEGIN…EXCEPTION 가드 안에 있어야 함
```
- 3) 화면 검증: 환율 모달에서 기존 행 하나를 **현행 값 그대로** 수정 저장 → 성공 토스트(오류 0).
  (사내 검증 실측: 동일 왕복 CODE 0 / EVENT 2 / 원장 값 불변)

## 참고
- `REF_사내적용본_PKG_DMF0020_BODY.sql` — 사내 적용 완료본 전문(참고용). 클라우드 본문과 diff 검토 용도로만 사용,
  그대로 실행 금지.
- 사내 백업: `_artifacts/_apply_corporate/BACKUP_PKG_DMF0020_BODY_pre_pdml12841_20260813.sql`
- 계보 메모리: `feedback_sp_parallel_dml_alter_in_txn.md` §5 (sweep 잔여 후보 중 PKG_DMF0007 등 미점검분 존재 —
  타 화면 동일 오류 시 우선 조사)
