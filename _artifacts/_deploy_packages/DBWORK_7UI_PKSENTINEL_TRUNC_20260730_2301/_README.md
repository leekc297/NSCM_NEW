# DB 작업본 클라우드 이관 패키지 — 7 화면 (2026-07-30)

> 사내 Oracle 에 **적용 완료된** DB 작업분을 클라우드로 이관하기 위한 패키지.
> 대상 화면: **DMF0003 / DMF0020 / DMF0021 / DMF0042 / DMF0044 / DMF0049 / DMF0082**
> 생성: 2026-07-30 23:01 (사내 SCM_MGR live 덤프)
> 근거 룰: 룰 22 §9 · hook `deploy-package-completeness` (§1.0-B / §1.6 / §1.7 / §4.5 / §4.6) · 메모리 `feedback_deploy_package_gtt_type_ddl`

---

## 1. 이 패키지가 담고 있는 작업 3건

| # | 작업 | 범위 | 사내 적용 |
|---:|---|---|---|
| A | **DMF0082 division 82 → 81 동일 경로 편입** | `PKG_DMF0082` BODY 26곳 + 메타 12행 | 완료 (20:18~) |
| B | **PK 센티널 `'-'` 정규화** | 8 오브젝트 **136건** (DMF0082 는 GTT 정규화 2블록) | 완료 (21:54~22:08) |
| C | **GTT `TRUNCATE` → `DELETE` 전환** | 6 PKG **80건** (hook #107 mutex 경합 근본조치) | 완료 (22:37~22:38) |

3건이 **같은 오브젝트에 누적 반영**돼 있으므로 분리 배포는 불가능합니다. 본 패키지의 BODY 는 세 작업이 모두 들어간 **live 최신본 단일 스냅샷**입니다(§4.6-3 준수).

> ⭐ **2026-08-05 정본 확정 (diff 검증)**: `10_PKG_DMF0044_BODY.sql` / `12_PKG_DMF0049_BODY.sql` 은
> `DMF0044_0049_PKG_FIX_20260730` 의 변환결함 정정 전량(0044 33+477 / 0049 5건)을 포함한 **superset** 임을 실측 확정
> (차이 = 헤더 주석 제거 + TRUNCATE→DELETE 11건 + PK 센티널 NVL + **L7416 CURRENCY 사용자 수정 반영분**).
> → DMF0044/0049 BODY 의 **클라우드 이관 정본 = 본 패키지**. `DMF0044_0049_PKG_FIX` 패키지는 실행하지 말 것(되돌림 발생).
> ⭐ **2026-08-05 live 재동기화**: 사내 PKG_DMF0044 BODY 가 07-31 10:39 재배포됨(스냅샷 22:38 이후) — 차이는
> `P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY` 초입 버전유형 조회 2건 `SELECT VERSION_TYPE` → `SELECT MAX(VERSION_TYPE)`
> (0행 NO_DATA_FOUND 방어). live 전문 diff 로 확인 후 `10_PKG_DMF0044_BODY.sql` 에 반영 완료 — 그 외 차이 0.
> §3-A Step 0 게이트의 사내 기준 시각도 PKG_DMF0044 BODY 는 **07-31 10:39** 로 갱신해 판정할 것.
> ⭐ **2026-08-05 15:49 PKG_DMF0042 BODY 재배포 반영**: `P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE` '^' split 변환 파손
> (1변수 통합 → 전 필드 NULL 적재·INVALID) 을 AS-IS 2변수(v_recv=나머지/v_=토큰) 패턴으로 복원 — `08_PKG_DMF0042_BODY.sql`
> 동기화 완료(사내 기준시각 08-05 15:49). **동반 데이터**: `_apply_corporate/DMF0042_DM_BP_EXCHANGE_RATE_LOAD_20260805.sql`
> (환율 원장 727행 — 클라우드도 0행이면 함께 적재. 멱등 NOT EXISTS).
> ⭐ **2026-08-05 16:15 PKG_DMF0042 BODY 재배포(2차)**: `P_DMF0042_GET_DM_MDF_VERSION` 의
> `NVL(ATTRIBUTE1,NULL)<>'MOVE'`(hook #119 — NULL 버전 전멸) → `CHR(0)` 센티널 정정. `08_` 재동기화(기준시각 08-05 16:15).
> **동반 메타**: `_apply_corporate/MSG00400_401_REPLACE_CUTOFF_20260805.sql` (Replace 확인/완료 MSG 6행 — 문구 신설·AS-IS 원문 미확보 한계 명시).

---

## 2. 패키지 구성

```
DBWORK_7UI_PKSENTINEL_TRUNC_20260730_2301/
├── 00_PRECHECK/
│   ├── 00_PRECHECK_CLOUD.sql          ⭐ 적용 전 선판정 (READ-ONLY)
│   └── 01_BACKUP_CLOUD_CURRENT.sql    ⭐ 클라우드 현재본 백업 (원복 전제)
├── 01_PREREQ/
│   ├── 00_TYPES_DDL.sql               standalone TYPE 18본 (의존순 ROW→TAB)
│   ├── 00_GTT_DDL.sql                 GTT 203본 (멱등 -955 skip)
│   └── _GTT_TOKEN_CLASSIFICATION.md   토큰 219 → 실존 203 / 미실존 16 분류 근거
├── 02_DB_SP/
│   ├── 01~14  PKG SPEC/BODY  (7 PKG × 2, SPEC 먼저 = 의존순)
│   ├── 15~16  standalone PROCEDURE 2본
│   ├── 17_GRANT.sql                   【SCM_MGR 세션】 165본, 사내 실측 미러링
│   └── 18_APP_SYNONYM_ONLY.sql        ⛔【APP 계정 세션】 162본
├── 03_META/
│   ├── 01_PROC_M_DMF0044_0049.sql     19 SP DELETE 후 INSERT (211행)
│   ├── 02_SHEET_MEASURE_DMF0082_DIV82.sql   10행
│   ├── 03_SHEET_COLUMNS_DMF0082_DIV82.sql    2행
│   └── 04_MSG_LBL_VERSIONMODAL.sql          48행 (LBL 16 × KO/EN/CN)
└── 04_VERIFY/
    └── 90_VERIFY_AFTER_APPLY.sql      기대값 명기 검증
```

---

## 3. 적용 순서 (⚠ 순서 준수 — 의존관계 있음)

| Step | 파일 | 계정 | 비고 |
|---:|---|---|---|
| **0** | `00_PRECHECK/00_PRECHECK_CLOUD.sql` | SCM_MGR | ⭐ **결과 보고 진행 여부 판단**. §3-A 3개 게이트 |
| **1** | `00_PRECHECK/01_BACKUP_CLOUD_CURRENT.sql` | SCM_MGR | 원복본 확보 — **건너뛰지 말 것** |
| **2** | **BE 정지** | — | 라이브 PKG 재배포는 `library cache pin` 대기로 hang |
| **3** | `01_PREREQ/00_TYPES_DDL.sql` | SCM_MGR | TYPE 부재 시 BODY 가 PLS-00201 |
| **4** | `01_PREREQ/00_GTT_DDL.sql` | SCM_MGR | GTT 부재 시 ORA-00942 |
| **5** | `02_DB_SP/01~16` **번호 순** | SCM_MGR | SPEC → BODY 순서 필수 |
| **6** | `02_DB_SP/17_GRANT.sql` | SCM_MGR | |
| **7** | `02_DB_SP/18_APP_SYNONYM_ONLY.sql` | ⛔ **SCMP_APP** | SCM_MGR 로 실행 시 ORA-01031 |
| **8** | `03_META/01~04` 번호 순 | SCM_MGR | |
| **9** | **BE 재기동** | — | |
| **10** | `04_VERIFY/90_VERIFY_AFTER_APPLY.sql` | SCM_MGR (+[8]만 APP) | 기대값 대조 |
| **11** | **화면 E2E** | — | 저장 SP 직접 실행 금지 (hook #104) |

권장: `ALTER SESSION SET DDL_LOCK_TIMEOUT=120;` 을 Step 3 전에 실행.

### 3-A. Step 0 통과 게이트 (하나라도 어긋나면 중단)
- ☐ 대상 9본의 `LAST_DDL_TIME` 이 사내(2026-07-30 21:54~22:38)보다 **최신이 아님** — 최신이면 클라우드에서 별도 수정된 것
- ☐ LBL 16종이 클라우드에서 **다른 의미로 사용 중이 아님** (채번 충돌 — hook §1.0-B B2)
- ☐ 애플리케이션 계정이 **SCMP_APP** 임을 확인

---

## 4. ⚠️ 미포함 / 이 패키지 밖 (명시)

| 분류 | 내용 | 사유 |
|---|---|---|
| **FE 변경분** | 공용 `VersionModal` 신규(features/demand/src/components/versionModal) · Exchange Rate 아이콘화 · `procedures.d.ts` · **locales `{KO,EN,CN}.json`** | 본 패키지는 **DB 작업본 전용**(사용자 요청 범위). ⚠ **locales 없이는 LBL 이 화면에 fallback 으로 뜬다** — FE 이관과 **함께 적용**해야 완결 |
| **DMF0068 SHEET_COLUMNS 159행** | 오늘 변경분이지만 DMF0068 작업 | 기존 패키지 `DMF0068_DEMANDMANAGER_20260729` 소관 |
| **`LBL00783`** | 03_META/04 에 포함되어 있음 | DMF0068 패키지와 **중복** — 값 동일·멱등이라 무해하나, 둘 다 적용 시 나중 것이 최종 (§4.6-4 상호명기) |
| **PK 센티널 위험 프로시저** | 버전복사 · Cutoff · 리포트생성 · `*_PK_DATA_UPDATE` | 사내에서도 **의도적 미적용**("확실한 것만" 지시) |
| **GTT 구조 변경** | 없음 | 본 작업이 GTT 구조를 바꾸지 않으므로 `-955 skip` 멱등 DDL 로 충분 |
| ⚠️ **GTT 정밀도 `NUMBER(20,10)`** | **39 GTT / 수량·금액 계열 59 컬럼** — 미교정 | hook §1.1 점검에 걸린 항목. **사내도 동일한 기존 상태**이고, 클라우드만 바꾸면 구조가 갈라지며 GTT DROP 재생성이 필요 → 별건 판단 요청. 상세·적용 절차 = `01_PREREQ/00A_GTT_PRECISION_REBUILD_OPTIONAL.md` |

---

## 5. 🔴 알려진 기존 결함 — 이관해도 그대로 남습니다

### 5-1. `PKG_DMF0003` L3329 — 실행 시 `ORA-00942`
```sql
EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION';
```
대상은 **테이블이 아니라 PL/SQL 컬렉션 변수**입니다(L3356 `BULK COLLECT INTO`, L3499·3664·3688 `JOIN TABLE(...)`). AS-IS MSSQL 테이블변수 `@x` 의 변환 산물로, 동적 SQL 이라 **컴파일은 VALID 통과**하지만 실행 경로 도달 시 `ORA-00942` 입니다.
배선: `SCM_ADM_API_M` → `DMF0003_prHistory_SEARCH` = `P_DMF0003_GET_PR_HISTORY_POPUP` (**USE_YN='Y'**) → PR History 팝업이 이 경로에서 실패.

- ⛔ `DELETE FROM` 으로 치환하면 **정적 참조가 되어 컴파일 에러**가 납니다. 그래서 `04_VERIFY [3]` 의 기대값이 **잔존 1행**입니다.
- 수정안(미적용, 승인 필요): **L3329 삭제** — 직후 `BULK COLLECT INTO` 가 컬렉션을 전량 대체하므로 등가.

### 5-2. `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT` — 전 division `ORA-00904 "SORT_KEY"`
`V_ORDERBY` 가 `ORDER BY SORT_KEY` 를 만들지만 동적 SQL 템플릿이 `SORT_KEY` 를 투영하지 않습니다(`GET_MAIN_DATA` 의 `999 AS SORT_KEY` 2026-07-22 fix 가 CURRENT 에 미반영). 사내에서도 동일하게 실패합니다.

### 5-3. `GT_PRDM_T_MAIN` vs `GT_PRDM1_T_MAIN` 이름 불일치
`PKG_DMF0082` 는 `GT_PRDM1_T_MAIN` 에 적재하는데 `PR_DM_PLN_CFM_TO_MKT_FCST` 는 `GT_PRDM_T_MAIN`(무 `1`)을 읽습니다 → **40 전파가 사실상 no-op**. 어느 쪽이 정본인지 업무 확인 필요.

> 위 3건은 본 이관 작업이 만든 것이 아니라 **기존 상태**이며, 고치지 않았습니다.

---

## 6. 원복

```
-- BE 정지 후, Step 1 에서 만든 클라우드 자신의 백업으로 원복
@BACKUP_CLOUD_9OBJ_before_apply.sql

-- 메타
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_DMF0044.%' OR PROC_NM LIKE 'PKG_DMF0049.%';
INSERT INTO SCM_ADM_PROC_M SELECT * FROM BK_PROC_M_20260730;
-- SHEET_MEASURE / SHEET_COLUMNS / MSG_M 도 BK_* 테이블로 동일 복원
COMMIT;
```
⚠ **사내 백업(`_apply_corporate/BACKUP_*`)으로 클라우드를 원복하지 마십시오.** 두 환경의 BODY 가 동일하다는 보장이 없습니다.

---

## 7. 검증 기대값 요약

| 항목 | 기대 |
|---|---:|
| CODE 9본 STATUS | 전부 **VALID** / `USER_ERRORS` **0** |
| GTT / TYPE | ≥ **203** / ≥ **18** |
| 잔존 `TRUNCATE` | **1** (PKG_DMF0003 L3329 — 의도) |
| NVL 센티널 (8본 합) | **136** |
| `PROC_M` (0044/0049) | **211행** / 비표준 `COL_TP_CD` **0** |
| `SHEET_MEASURE` 82 / `SHEET_COLUMNS` 82 | **10** / **2** |
| `MSG_M` LBL | **48** |
| APP 계정 SYNONYM | **162** |

---

## 8. 관련 산출물 (사내 작업 기록)

- `_artifacts/_apply_corporate/DMF0082_div82_as81_README_20260730.md`
- `_artifacts/_apply_corporate/DMF0082_pk_sentinel_적용결과_20260730.md`
- `_artifacts/_apply_corporate/6UI_pk_sentinel_적용결과_20260730.md`
- `_artifacts/_apply_corporate/GTT_truncate2delete_적용결과_20260730.md`
- `_artifacts/_apply_corporate/GTT_실제필요작업_20260730.md` (재명명 제외 결정 근거)
