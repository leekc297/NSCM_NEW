# GTT `TRUNCATE` → `DELETE` 치환 — **완료** (사내 DB, 2026-07-30)

> 근거 룰: **hook #107 `sp-hang-runaway-loop-diagnosis`** — GTT `TRUNCATE`(DDL) 동시세션 library cache/cursor/row cache **mutex 경합 hang**
> 선행 검토: `GTT_실제필요작업_20260730.md` (재명명 방안② 제외 결정 반영)
> 대상: DMF0020 / DMF0021 / DMF0044 / DMF0042 / DMF0082 / DMF0003

---

## 1. 결과 — 6 오브젝트 / **80건 치환** (전부 VALID · USER_ERRORS 0)

| # | 오브젝트 | 대상 | 치환 | 잔존 | 배포 | 비고 |
|---:|---|---:|---:|---:|---|---|
| 1 | `PKG_DMF0020` | 10 | **10** | 0 | 22:37:38 | 🔴 **10건 전부 공유 GTT** (경합 1순위) |
| 2 | `PKG_DMF0021` | 6 | **6** | 0 | 22:37:57 | |
| 3 | `PKG_DMF0044` | 10 | **10** | 0 | 22:38:00 | |
| 4 | `PKG_DMF0042` | 16 | **16** | 0 | 22:38:15 | |
| 5 | `PKG_DMF0082` | 19 | **19** | 0 | 22:38:18 | 전부 `GT_DMF0082_*` 접두 GTT |
| 6 | `PKG_DMF0003` | 20 | **19** | **1** | 22:38:22 | ⚠️ L3329 = **치환 대상 아님**(§3) |
| | **합계** | **81** | **80** | **1** | | |

치환 형태 (라인수 불변, 주석 라인 보호):
```sql
EXECUTE IMMEDIATE 'TRUNCATE TABLE X';   →  DELETE FROM X;
TRUNCATE TABLE X;                       →  DELETE FROM X;
```
GTT 는 세션(`SYS$SESSION`)/트랜잭션(`SYS$TRANSACTION`) 단위 격리이므로 `DELETE` 로 바꿔도 **자기 세션 데이터만 삭제 = 결과 동일**. DDL 이 사라져 mutex 경합만 제거됨.

### 대상 없음 (이미 DELETE 사용)
`PKG_DMF0049` · `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` · `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` · `DMF0020_GET_SCM_MST_FUTURE_PRICE`

---

## 2. ⚠️ 프로세스 결함 — 검증 실패인데 배포가 실행됨 (DMF0003)

패처는 L3329 를 **정상적으로 거부**하고 `검증: ### 실패` → `sys.exit('검증 실패 — 배포 금지')` 로 종료했으나,
배포 루프가 `python trunc_patcher.py ... | grep ...` 뒤에 `if [ $? -eq 0 ]` 를 썼습니다.
bash `$?` 는 **파이프라인 마지막 명령(`grep`)의 종료코드**를 읽으므로 패처의 `exit 1` 이 무시되고 `deploy_obj.py` 가 실행됐습니다.

**결과적 안전성 확인**: 패치 파일은 "19건 치환 + L3329 원문 유지" 상태였고, L3329 는 §3 대로 **원문 유지가 정답**이었습니다. 따라서 배포된 PKG_DMF0003 은 의도한 최종 상태와 동일합니다(VALID · USER_ERRORS 0 · 잔존 1 = 정상).
다만 "게이트가 실제로는 작동하지 않았다"는 사실 자체는 결함이므로 기록합니다. → 향후 `set -o pipefail` 또는 파이프 없이 종료코드 판정.

---

## 3. 🔴 별건 기존 결함 발견 — `PKG_DMF0003` L3329 (MSSQL→Oracle 변환 산물)

패처의 GTT 가드(`대상이 TEMPORARY='Y' 인 실존 테이블일 때만 치환`)가 잡아낸 **실제 결함**입니다.

```sql
-- L3329 (P_DMF0003_GET_PR_HISTORY_POPUP 내부, 주석 아님 = 실행 경로)
EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION';
```

### 실측 근거
| 확인 | 결과 |
|---|---|
| `ALL_TABLES` / `ALL_OBJECTS` (SCM_MGR 접속) | `GT_DMF0_DM_MST_VERSION` **테이블 미실존** |
| 유사명 `GT_DMF0003_DM_MST_VERSION` | `SCMP_APP` / `SCMD_APP` 의 **시노님 2본만 존재, 기반 테이블 없음**(dangling) |
| **정체** | L3356 `BULK COLLECT INTO GT_DMF0_DM_MST_VERSION`, L3499·3664·3688 `JOIN TABLE(GT_DMF0_DM_MST_VERSION)` → **PL/SQL 컬렉션 변수**. 테이블이 아님 |
| 배선 | `SCM_ADM_API_M` → `DMF0003_prHistory_SEARCH` = `PKG_DMF0003.P_DMF0003_GET_PR_HISTORY_POPUP`, **USE_YN='Y'** |

### 판정
- AS-IS MSSQL 의 **테이블 변수 `@DM_MST_VERSION`** 이 변환기에 의해 한쪽은 컬렉션 변수로, `TRUNCATE TABLE @x` 한 줄만 **동적 SQL 문자열**로 남은 전형적 변환 산물.
- **동적 SQL 이라 컴파일은 통과**(VALID) → 정적 검사로는 안 잡힘. 실행 경로 도달 시 **런타임 `ORA-00942`**.
- ⛔ `DELETE FROM GT_DMF0_DM_MST_VERSION;` 로 치환하면 정적 참조가 되어 **컴파일 에러**가 됩니다. 패처의 거부가 정확한 판단.

### 제안 수정 (미적용 — 승인 필요)
L3356 의 `BULK COLLECT INTO` 가 컬렉션 전체를 **덮어쓰므로** L3329 는 기능상 불필요합니다.
```sql
-- L3329 삭제 또는 주석화 (BULK COLLECT INTO 가 전량 대체하므로 의미 동일)
```
> 본 작업(TRUNCATE→DELETE) 범위 밖의 **기능 결함 수정**이므로 적용하지 않았습니다.

### 동일 유형 파급 (본 6화면 밖)
소스에 등장하나 **실존하지 않는 `GT_DMF0_*` 토큰 104종** — 보유 오브젝트 **18본**(INVALID 16 / VALID 2).
`GT_DMF0_V_SQL_TEXT` · `GT_DMF0_V_COLLIST` · `GT_DMF0_VERSION_NO` 처럼 **PL/SQL 변수명에 `GT_DMF0_` 접두가 잘못 붙은 형태**가 다수 — 과거 일괄 변환/재명명이 변수명까지 건드린 흔적.
대상: `DMF0005_*` `DMF0022_*` `DMF0035_*` `DMF0051*` `DMF0053_*` `DMF0074_*` 등 — **전부 본 작업 범위 밖 / 기존 상태**.

---

## 4. 검증

1. 오브젝트별 **기대건수 assert** + **라인수 불변** + 주석 라인 보호
2. 대상이 **`ALL_TABLES.TEMPORARY='Y'`(GTT)** 인 경우만 치환 — 일반 테이블이면 중단(이 가드가 §3 을 잡음)
3. BE(8080) 정지 상태 → `DDL_LOCK_TIMEOUT=120` 배포 → **6/6 VALID · USER_ERRORS 0**
4. 배포 후 전수 재조회: 6 오브젝트 잔존 `TRUNCATE` = **1건(L3329, 의도된 유지)**
5. INVALID 총계 **738 → 737** (본 작업과 무관한 기존 결함들, 감소분은 재컴파일 부수효과)

---

## 5. 원복

```
-- BE 정지 후 (오브젝트별 개별 원복 가능)
@BACKUP_PKG_DMF0020_pre_trunc_20260730.sql
@BACKUP_PKG_DMF0021_pre_trunc_20260730.sql
@BACKUP_PKG_DMF0044_pre_trunc_20260730.sql
@BACKUP_PKG_DMF0042_pre_trunc_20260730.sql
@BACKUP_PKG_DMF0082_pre_trunc_20260730.sql
@BACKUP_PKG_DMF0003_pre_trunc_20260730.sql
```

## 6. 잔여

- **BE 재기동** — 요청 시 (현재 정지)
- **효과 실측 미수행** — 동시 세션 2+ 로 `V$SESSION` event / `V$SQL` 대기 전·후 비교 필요. 미측정 시 "경합 해소"는 이론값
- ⚠️ **`DELETE` 성능** — 대량 행 GTT 는 `TRUNCATE` 보다 느릴 수 있음 → 화면 E2E 시 조회 소요시간 비교 필요
- **클라우드 미적용** — 이관 패키지 취합 시 6 오브젝트 동봉 (룰 22 / hook #14)
- §3 L3329 수정 — 승인 대기
- 별건 결함(미수정): `GT_PRDM_T_MAIN`(읽기) vs `GT_PRDM1_T_MAIN`(쓰기) 불일치로 40 전파 no-op / `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT` 전 division `ORA-00904 "SORT_KEY"`
