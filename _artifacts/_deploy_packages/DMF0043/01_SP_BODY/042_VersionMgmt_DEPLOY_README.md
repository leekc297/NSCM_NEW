# DMF0043 기여율 버전관리 (VersionPopup) — 클라우드 배포 패키지

작성: 2026-06-11 17:48:48
출처: 사내 Oracle (10.20.100.153:2521:ESSCMD) SCM_MGR

## 배포 파일

| # | 파일 | SP | 변경 내역 |
|---:|---|---|---|
| 1 | 040_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_VersionMgmt.sql | `DMF0043_SAVE_DM_MST_CONTRIBUTE_VER` | TRUNCATE→DELETE (1) + SUBSTR(s,0,n)→(s,1,n-1) (7) |
| 2 | 041_DMF0043_GET_MAIN_VARSION_DATA_VersionMgmt.sql | `DMF0043_GET_MAIN_VARSION_DATA` | LAST_DDL 변경 (정합성 동봉) |

## 변경 이유 (1: SAVE SP)

VersionPopup 에서 신규 버전 추가/수정 후 "저장 완료" 메시지 노출되나 **DB 미반영** 사고:

### Root cause A — TRUNCATE GT_* 권한 부족
NextSCM Pilot 변환기가 MSSQL `#TEMP DROP/CREATE` 를 Oracle `EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDMCV_RESULTS_MST_2'` 로 변환.
SCM_MGR 는 DDL 권한 없음 → `ORA-01031: insufficient privileges` → SP 의 generic `EXCEPTION WHEN OTHERS` 가 catch 후 silent OK 반환.

**Fix**: `EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_*'` → `DELETE FROM GT_*` (PL/SQL DML, 권한 불요).

### Root cause B — SUBSTR(s, 0, n) Oracle pitfall
Oracle `SUBSTR(s, 0, n)` 의 position=0 은 1 로 정규화 → `SUBSTR(s, 1, n)` 과 동일.
즉 `^` 구분자 token 추출 시 token + `^` 까지 포함 → MERGE INTO 매치 실패 → silent EXCEPTION → DB 미반영.

**Fix**: 7곳 모두 `SUBSTR(v_w_X, 0, v_index_X)` → `SUBSTR(v_w_X, 1, v_index_X - 1)`.

## 배포 절차

### Step 1: 백업 (의무)
```sql
-- 클라우드 측 백업 (롤백 대비)
SET LONG 100000
SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_SAVE_DM_MST_CONTRIBUTE_VER') FROM DUAL;
SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_GET_MAIN_VARSION_DATA') FROM DUAL;
```

### Step 2: 적용
DBeaver / SQL*Plus 에서 다음 순서로 실행:
1. `040_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_VersionMgmt.sql`
2. `041_DMF0043_GET_MAIN_VARSION_DATA_VersionMgmt.sql`

### Step 3: 검증
```sql
-- 1) STATUS=VALID
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('DMF0043_SAVE_DM_MST_CONTRIBUTE_VER','DMF0043_GET_MAIN_VARSION_DATA')
   AND OBJECT_TYPE='PROCEDURE';

-- 2) SUBSTR 패치 확인 (0건 = 모두 fix)
SELECT COUNT(*) AS substr_zero_remaining
  FROM USER_SOURCE
 WHERE NAME='DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'
   AND TYPE='PROCEDURE'
   AND REGEXP_LIKE(TEXT, 'SUBSTR\s*\([^,]+,\s*0\s*,');

-- 3) TRUNCATE 잔존 확인 (0건 = 모두 fix)
SELECT COUNT(*) AS truncate_remaining
  FROM USER_SOURCE
 WHERE NAME='DMF0043_SAVE_DM_MST_CONTRIBUTE_VER'
   AND TYPE='PROCEDURE'
   AND UPPER(TEXT) LIKE '%TRUNCATE TABLE GT%';
```

### Step 4: 실 데이터 테스트
- VersionPopup 열고 신규 버전 추가 → 저장 → DM_MST_CONTRIBUTE_VER 행 증가 확인
- `SELECT * FROM DM_MST_CONTRIBUTE_VER ORDER BY VER_SEQ DESC FETCH FIRST 5 ROWS ONLY;`

## 롤백 절차 (만약 문제 발생 시)

```sql
-- Step 1 의 백업 DDL 을 그대로 실행하여 원복
```

## 참고

- 사내 적용 스크립트: `_artifacts/_apply_corporate/07_dmf0043_save_truncate_to_delete.py` + `08_dmf0043_save_substr_zero_fix.py`
- AS-IS 분석: `_artifacts/_diagnostics/DMF0043_SAVE_DM_MST_CONTRIBUTE_VER_*.sql` (before snapshots)
- 룰 메모리: feedback_sp_truncate_gtt_grant / feedback_sp_substr_zero_index_pitfall
