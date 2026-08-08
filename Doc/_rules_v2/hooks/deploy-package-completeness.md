# Hook — Deploy Package 완전성 (Combo / POPUP / Action SP 모두 포함)

> ⭐ **신규 화면 deploy zip 작성 시 메인 SP 외 모든 lookup combo / POPUP modal / action SP 의 메타 + body 동봉 의무**
>
> 위반 시: 새 환경 deploy 시 조회 조건 dropdown / 모달 / 액션 버튼 동작 안 함. ORA-04063 (SP 미존재) 또는 PLS-00306 (메타 미등록) 폭발.

작성: 2026-06-02 (DMF0072/0008/0043/0043_01 deploy zip 누락 4건 사후 보강 — 사용자 명시 요구)
관련 룰: `22_PACKAGE_ARTIFACTS.md` §9, `25_NEW_SCREEN_MANDATORY_CHECKLIST.md`, `08_SCREEN_REGISTRATION.md` §4.4
관련 메모리: `feedback_deploy_package_completeness.md`, `feedback_proc_meta_mandatory.md`, `feedback_proc_meta_col_nm_be_auto_keys.md`

---

## §0. 배경 (사용자 명시 요구 — 2026-06-02)

> "신규 화면에 대한 압축파일 생성 중 아래의 항목에 대한 누락이 있는것 같습니다. 추가 요청 합니다.
>  컬럼, PROC, API 등 권한 관련 SQL전체
>  COMBO, POPUP 에 사용되는 모든 QUERY 가 들어가는 SP, PKG 전체
>  COMBO, POPUP 에서 사용하기 위하여 SCM_ADM_PROC_M 에 등록한 QUERY"

**사고 사례 (실제, 2026-06-02)**:

| 화면 | 누락 카테고리 | 누락 수 | 사후 보강 파일 |
|---|---|---:|---|
| DMF0072 | lookup combo 5종 (DataType/Division/Team/EndCustomer/SalesSite) — API_M/BTN_MPG/PROC_M + SP body | 9 PROC row + 4 SP body | `60_DMF0072_lookup_meta_boost.sql` + `60_DMF0072_lookup_SP_bodies.sql` |
| DMF0008 | updateHistory sheet 메타 + wrapper SP body + DMF0000 본문 | 3 PROC row + 2 SP body | `52_DMF0008_updateHistory_meta_boost.sql` + `52_DMF0008_updateHistory_SP_bodies.sql` |
| DMF0043 | standalone SP body 9건 (03_SP_PKG 누락) | 9 SP body | `65_DMF0043_main_SP_bodies.sql` |
| DMF0043_01 | 공용 의존 SP body 1건 (DMF0002_GET_TITLESET_POPUP) | 1 SP body | `50_DMF0002_titleset_SP_body.sql` |

---

## §1. PRE-DEPLOY 자기 점검 (zip 작성 직전 — 의무)

### §1.0 ⭐ 2026-06-15 SYS0013 사고로 추가된 의무 (3건)

| 사고 | 누락 카테고리 | Root Cause |
|---|---|---|
| ① `useTabBtnPermissions` Vite resolve 실패 | barrel export 통째 교체 | zip 의 `shared_hooks_index.ts` 가 로컬 export 목록 전체 → 클라우드 측 형제 hook 누락 |
| ② DIVISION_ID='--' (2글자) mismatch | sentinel 글자 DUMP byte 검증 누락 | 사내 `'-'` (Len=1) → 클라우드 `'--'` (Len=2) 깨짐 |
| ③ `SCM_ADM_DQ_EXECUTE_HIST` ORA-00942 | SP 참조 테이블 이름 추측 | 실제 이름 `_H` suffix (NSCM 표준), 추측 `HIST` 로 02_DB_DDL 누락 |

### §1.0-B ⭐ 2026-07-29 SYS0017 이관 취합으로 추가된 의무 (3건)

| # | 의무 | 사유 (실측) |
|---|---|---|
| B1 | **`00_PRECHECK_CLOUD.sql` 동봉** (read-only 선판정, 패키지 최상단) | 클라우드에 참조 테이블·시퀀스·이력 SP·함수가 이미 있는지, 화면 메타가 0건인지 **적용 전에** 판정해야 어느 스크립트를 실행할지 결정 가능. 사내 실측만 믿고 적용하면 중복·충돌 발생 |
| B2 | ⭐⭐ **신규 채번(MSG/LBL/MNU) 충돌 점검 섹션 필수** | 사내 MAX 기준으로 채번한 번호가 클라우드에서 이미 사용 중일 수 있음. PRECHECK 결과가 0 이 아니면 **그대로 적용 금지 — 생성기의 번호를 클라우드 MAX 로 재채번 후 SQL 재생성** |
| B3 | **권한 미러링 원본 메뉴 실측 확인** | SYS0017 최초안은 형제 화면(SYS0016)을 미러링 원본으로 썼으나 **SYS0016 자체가 권한 0건** → 권한 2테이블이 0행으로 등록됨. 원본 메뉴의 그룹 보유 여부를 PRECHECK 로 확인하고, 0 이면 실제 그룹을 보유한 동급 메뉴로 교체 |

> 사고 계보: 이 3건이 없으면 "사내에서는 정상, 클라우드에서만 실패" 또는 "적용은 성공했는데 화면 진입 시 권한없음" 이 재발한다.

### §1.0-C ⭐⭐ 메타 "값 단언" 3종 (2026-08-06 SYS0017 근본원인 감사 계기 신설)

> **검증 = 카운트 아닌 값 단언.** SYS0017 7/29 패키지는 SHEET_COLUMNS 32행 "건수" 검증만으로 통과했으나
> 32행 전부 `INPUT_TP_CD='IM'` + 콤보 CTRL `'C'`(비표준) 오등록이었다. 본문 표준 = **hook #98 §6** (단일 소스).

| # | 의무 (SHEET_COLUMNS 등록·검증 SQL 포함 패키지 전부) | 방식 |
|---|---|---|
| 1 | **CTRL 화이트리스트 단언** — FE `packages/foundation/src/constants/column-config.ts` `CELL_CONTROL_TYPE` 실제 열거(`FP*` 14종)를 인용한 `NOT IN (...)` 검출 쿼리 동봉 (기대 0행 — `'C'`/`'S'` 검출 시 적용 중단) | #98 §6.1 SQL |
| 2 | **INPUT_TP_CD 분포 대사** — 편집 화면의 전면 'IM' 일괄 금지. 시트별 목표 분포를 검증 스크립트 PROMPT 주석에 명기하고 화면설계서 5.GRID "편집 규칙" 컬럼과 1:1 대사 | #98 §6.2 SQL |
| 3 | **값 단언 형식** — 검증 SQL 은 기대값(분포/화이트리스트)을 스크립트에 박은 단언 형식. 정본 = `_deploy_packages/SYS0017_MAILSETUP_PATCH_20260806/00_PRECHECK.sql` **[B-1]/[B-2]** | PRECHECK [B] 형식 |

> ⭐ **자동화 2종 (2026-08-07 신설)**: ①SHEET_COLUMNS SQL 작성 시점에 실행 hook `.claude/hooks/check-meta-sql.ps1`
> 이 CTRL 화이트리스트/INPUT_TP_CD 를 자동 차단 (본문 = hook #98 §6.2-T). ②이관 PRECHECK 보조 도구 =
> `python _artifacts/_diagnostics/wiring_chain_check.py --menu {MNU_ID}` — 패키지 적용 **후** 배선 체인
> (BTN_MPG→API_M→PROC_M→SP VALID→시그니처)을 실측 판정 (DMF0072 유형 = API_M 부재를 L3 에서 검출).
> zip 동봉 검증 절차에 위 러너 실행 결과 요약을 README 에 기재 권장.

### §1.1 6-종 인벤토리 작성

```
☐ FE useTabProcQuery / useProcMutation 의 모든 sheetName 추출?
   → grep -rE "useTabProcQuery|useProcMutation" nscm-fe/features/.../{화면-slug}/
   → 모든 sheetName 목록 산출 (예: 'main', 'dataType', 'team', 'endCustomer', 'salesSite', ...)

☐ FE POPUP modal 컴포넌트 모두 식별?
   → grep -rE "<\w+Modal" nscm-fe/features/.../{화면-slug}/
   → 공용 modal (master/src/components/) + 화면 전용 modal 분리

☐ ⭐ 재사용 i18n 키(LBL/MSG)의 실제 문구 확인? (2026-07-29 SYS0017 사고)
   → grep -rhoE "t\('(LBL|MSG)[0-9]{5}'" {화면-slug}/ | sort -u
   → 각 키를 public/locales/{KO,EN,CN}.json + SCM_ADM_MSG_M 에서 **실제 값 조회**
   → 의미가 맞는지 대조 (fallback 문구 '_Add' 만 보고 재사용 금지)
   ※ 사고: LBL00073 을 'Add' 로 재사용했으나 실제 값은 'Exfactory Date',
      LBL00074 는 'From Country' → 화면에 엉뚱한 라벨 노출. LBL00109/LBL00407 로 정정.
   ※ locales 에는 있으나 SCM_ADM_MSG_M 에 없는 키(예: LBL00378/379/383)는
      표시엔 문제없어도 **패키지 README 에 '재사용 자원 — 클라우드 존재 확인만' 으로 명시**

☐ 위 sheetName 별 BE SP 이름 cross-check?
   → SCM_ADM_MNU_BTN_MPG_M[MNU_ID, SHT_NM] → API_ID → SCM_ADM_API_M.API_URL = SP 이름
   → BLOCK 3 의 모든 SHT_NM 이 sheetName 과 1:1 일치 의무

☐ 위 SP 들의 SCM_ADM_PROC_M 등록 확인?
   → PROC_NM × COL_NM × COL_TP_CD 모두 등록
   → BE 자동 채움 키 (sesUserId/mnuId/sesLangCd) 정확 매핑

☐ ALL_SOURCE 의 SP body 모두 03_SP_PKG/ 동봉?
   → DBMS_METADATA.GET_DDL('PROCEDURE', name, 'SCM_MGR') 일괄 추출
   → wrapper / 공용 SP 도 동봉 (비고 표시)

☐ ⭐ SP body 가 참조하는 모든 테이블/시퀀스 02_DB_DDL/ 동봉? (2026-06-15 신설)
   → grep -oE '(INTO|FROM|UPDATE)\s+(SCM_MGR\.)?(\w+)' 03_SP_PKG/*.sql + 02_DB_DDL/*.sql
   → grep -oE '\w+\.NEXTVAL' 03_SP_PKG/*.sql + 02_DB_DDL/*.sql
   → 사내 USER_OBJECTS 에서 실제 이름 확인 (추측 금지 — NSCM 표준: history = `_H` suffix, `HIST` 비표준)
   → 누락 시 DBMS_METADATA.GET_DDL('TABLE'/'SEQUENCE', ...) 추출 + GRANT/SYNONYM 동봉

☐ ⭐⭐ GTT/TABLE DDL 수량·금액 컬럼 NUMBER(30,10) 표준? (2026-07-22 신설 — 사용자 확정 룰)
   → grep -nE "NUMBER\(20,10\)" 이관 DDL 전체 — 수량(QTY)/금액(AMT)/율 계열 검출 시 (30,10) 교정 의무
   → (20,10)=정수부 10자리 → 백억(10^10) 이상 금액에서 ORA-01438 (실측: DMF0082 클라우드 61.8B 사고)
   → ⚠ -955 skip 멱등 DDL 은 대상 DB 의 구판 GTT 를 갱신하지 못함 — 정밀도 교정 포함 이관은
     DROP→재생성 REBUILD 파일(00A_GTT_REBUILD_<ID>.sql) 동봉 + 배포 후 all_tab_columns 검증 쿼리 명기
   → 상세: oracle-sp-perf-correlated-setbased-and-live-redeploy.md §D
```

### §1.5 ⭐ barrel re-export 파일 PATCH 안내문 표준 (2026-06-15 신설)

```
❌ 절대 금지: zip 에 `01_FE/<barrel>_index.ts` 전체 교체용 파일 포함
   → 클라우드 측 export 목록과 mismatch → 클라우드에 없는 형제 파일 Vite resolve 실패

✅ 의무: `01_FE/<barrel>.PATCH.md` 안내문 파일로 대체
```

PATCH.md 표준 내용:
```markdown
⚠ 이 파일을 통째로 교체하지 마세요.

## 적용 방법
클라우드 측 `<경로>/index.ts` 파일 끝에 한 줄 추가:
```ts
export * from './<신규파일>';
```

## 동반 파일
같은 폴더에 `<신규파일>.ts` 신규 파일을 함께 배포 (이 zip 안 `01_FE/<신규파일>.ts`).
```

### §1.6 ⭐ 데이터 이관 sentinel byte 검증 (2026-06-15 신설)

```sql
-- 이관 직후 모든 sentinel 컬럼 (DIVISION_ID / USE_YN / VALID_YN / UNIT_TP_CD / MNU_TP_CD) DUMP byte 검증
SELECT col, DUMP(col, 1016) AS HEX, COUNT(*) AS CNT
  FROM <table>
 GROUP BY col
 ORDER BY 3 DESC;
-- 기대: 사내 DUMP 와 정확 일치 (Len=1, byte=0x2d 등)
```

| 사고 패턴 | Fix |
|---|---|
| `'-'` (Len=1) → `'--'` (Len=2) 깨짐 | `UPDATE ... SET col='-' WHERE col='--'` |
| `'Y'` 누락 / `'N'` 누락 | NVL default 검증 |

### §1.7 ⭐ NOT EXISTS INSERT + UPDATE 동반 패턴 (2026-06-15 신설)

이관 패키지 메뉴/메타 SQL 은 NOT EXISTS INSERT 만 하면 **기존 잘못된 row 못 고침**. UPDATE 동반 의무:

```sql
-- 1. 신규 등록
INSERT INTO <table> (...) SELECT ... FROM DUAL WHERE NOT EXISTS (...);

-- 2. 기존 row 보정 (표준값 강제)
UPDATE <table> SET <표준컬럼>='D' WHERE <key>='SYS0013' AND <표준컬럼> <> 'D';
COMMIT;
```

대상 컬럼:
- `SCM_ADM_MNU_M.UNIT_TP_CD` = `'D'` (Division)
- `SCM_MST_SHEET_COLUMNS.INPUT_TP_CD` = `'IM'` (mandatory insert)
- 기타 표준값 강제 컬럼

### §1.2 자동 차단 (1건이라도 ✗ → deploy zip 작성 금지)

| ✗ 항목 | 차단 사유 |
|---|---|
| sheetName 누락 | 새 환경 BE 가 "sheet not registered" 응답 |
| BTN_MPG SHT_NM 누락 | 새 환경 BE 가 권한 거부 (403) |
| API_M API_URL 미일치 | BE 가 다른 SP 호출 → ORA-06550 PLS-00201 |
| PROC_M COL_NM 매핑 오류 | PLS-00306 (인수의 갯수나 유형이 잘못되었습니다) |
| SP body 누락 | ORA-04063 (PROCEDURE 가 유효 상태가 아닙니다) |

---

## §2. POST-DEPLOY 자동 검증 grep

```bash
# 1. FE sheetName ↔ deploy SQL SHT_NM 1:1 매칭
FE_SHEETS=$(grep -rhE "sheetName:\s*['\"]\w+['\"]" nscm-fe/features/.../{화면-slug}/ | grep -oE "['\"]\w+['\"]" | sort -u)
SQL_SHEETS=$(grep -hE "^\s*SELECT\s*'\w+'\s*AS\s*SHT_NM" _artifacts/_deploy_packages/{화면}/02_DB_Meta_SQL/*.sql | grep -oE "'\w+'" | sort -u)
diff <(echo "$FE_SHEETS") <(echo "$SQL_SHEETS")
# 기대: 0건 차이

# 2. SP body 카운트 vs API_URL 카운트
SP_BODY_CNT=$(grep -cE "^\s*CREATE OR REPLACE.*PROCEDURE" _artifacts/_deploy_packages/{화면}/03_SP_PKG/*.sql)
API_URL_CNT=$(grep -hE "AS API_URL FROM DUAL" _artifacts/_deploy_packages/{화면}/02_DB_Meta_SQL/*.sql | wc -l)
# 기대: SP_BODY_CNT >= API_URL_CNT (wrapper / 공용 동봉 시 SP_BODY_CNT 가 더 큼)

# 3. POPUP modal 카운트 vs popup sheet 메타 카운트
MODAL_CNT=$(grep -rohE "<\w+Modal " nscm-fe/features/.../{화면-slug}/ | sort -u | wc -l)
POPUP_BTN_CNT=$(grep -cE "'.*[Pp]opup.*' AS SHT_NM\|'.*Modal.*' AS SHT_NM" _artifacts/_deploy_packages/{화면}/02_DB_Meta_SQL/*.sql)
# 기대: 화면별 일치 (공용 modal 은 별도 차감)

# 4. 4-파일 세트 완전성
ls _artifacts/_deploy_packages/{화면}/02_DB_Meta_SQL/*meta*.sql       # base
ls _artifacts/_deploy_packages/{화면}/02_DB_Meta_SQL/*_DBeaver.sql    # DBeaver
ls _artifacts/_deploy_packages/{화면}/04_Verify/*_Verify.sql          # Verify
ls _artifacts/_deploy_packages/{화면}/04_Verify/*_Diagnose.sql        # Diagnose (선택)
```

---

## §3. 누락 보강 표준 절차 (사후 인지 시)

1. **인벤토리 완전성 grep** (§1.1) — 누락 항목 식별
2. **누락 SP body 추출** — `DBMS_METADATA.GET_DDL` 일괄 + awk 정제 → `03_SP_PKG/{N}_{purpose}_SP_bodies.sql`
3. **누락 메타 보강 SQL 4-파일 세트** (룰 22 §9.3) → `02_DB_Meta_SQL/{N}_{purpose}_meta_boost.sql` (NOT EXISTS 멱등)
4. **DBeaver / Verify / Diagnose 변환본 작성** (룰 21 §X DBeaver 변환 명령)
5. **로컬 멱등 적용 + 사후 카운트 검증** (BLOCK 6)
6. **zip 재생성** (룰 22 §5 + §6)

---

## §4. cross-ref

- **룰 22 §9** "SP / 메타 완전성 (Combo / POPUP / Action SP 모두 포함)" — 본 hook 의 entry point
- **룰 08 §4.4** PROC_M 자동 변환 표 (P_USER_ID→sesUserId 등)
- **룰 25 §1.5.1 / §1.5.3** 신규 화면 As-Is 분석 → To-Be 매핑 (CRUD + Search Aux)
- **룰 21 §10** SCM_ADM_PROC_M 트러블슈팅
- 메모리 `feedback_proc_meta_mandatory.md` / `feedback_proc_meta_col_nm_be_auto_keys.md` / `feedback_sql_idempotent_insert_all.md` / `feedback_deploy_package_completeness.md`

---

## §4.5 ⭐ 2026-07-02 보강 — "후속 보강" 잔류 금지 + PROC_M 이관 방식 표준

1. **패키지 내 "후속 보강" 주석 금지**: DMF0020 클라우드 저장 SQL ERROR 의 근본 원인 =
   0630 패키지 `010_core_meta` 에 "SAVE_SCM_MST_FUTURE_PRICE_ALL/POPUP 은 후속 보강" 주석만 남기고
   SAVE SP+PROC_M+GRANT 를 **미포함** → 그대로 잊혀 클라우드 저장 불능. 패키지는 그 시점의
   **완결 세트**여야 하며, 부득이 제외 시 README 최상단 "미포함/차기 필수" 표에 명시 + 다음 패키지 1순위.
2. **PROC_M 이관은 `DELETE(SP 단위) 후 INSERT`** — `MERGE ON (PROC_NM, SORT_ORD)` + COL_NM UPDATE 는
   PK(PROC_NM, COL_NM, COL_TP_CD) 환경에서 **ORA-00001** (SYS0012 클라우드 사고).
   상세: `proc-meta-signature-match.md` §0.4.
3. **메타 존재 검사는 정확 키로**: API_M 은 `API_ID` 정확 일치 (`API_URL LIKE '%메뉴ID%'` 오진 —
   API_URL=SP명이라 메뉴ID 미포함 다수). 체인 확정 = `PR_GET_PROC_INFO_LIST` 1콜.
4. **적용 후 검증 SQL 을 패키지에 동봉** (90_DIAGNOSE 폴더 표준 — SYS0012_APPROVAL_20260702 참조):
   SP 시그니처 vs PROC_M **위치+이름** 대조 + 기대값 주석.

---

## §4.6 ⭐ 2026-07-23 DMF0003/0049 클라우드 이관 사고 3건으로 추가된 의무

| # | 의무 | 사고 근거 |
|---|---|---|
| 1 | **FE 변경분은 `fe/` 폴더에 repo 상대경로로 동봉** — README 에 경로 나열만 하고 파일 미동봉 금지. 동일 파일을 복수 패키지가 포함하면 "최신 스냅샷(양쪽 변경 포함)" 명시 + 함께 적용 권장 문구 | DMF0003 SEARCHCOND/IMMUNIZE 패키지 FE 3파일 누락 — 사용자 지적 |
| 2 | **PKG SPEC/BODY 는 문장마다 `/` 종결자** — GET_DDL('PACKAGE') 원문은 spec+body 가 구분자 없이 연결됨 → 스크립트 실행 시 `PLS-00103: 심볼 "CREATE"`. 파일 생성 시 CREATE 문 수 == `/` 수 검증 | DMF0049 PKG_DMF0049_FULL_fixed 1차 실행 실패 |
| 3 | **교차 PKG 의존은 PREREQ 로 동봉 + 번호 순서 파일명** — 본 PKG BODY 가 타 PKG 멤버를 호출하면(`PKG_A.P_...`) 그 PKG SPEC/BODY+GTT 를 `01_PREREQ_*` 로 폴더에 포함(이미 적용 환경은 skip 무해 명시). PKG BODY 는 반드시 **live 최신본 덤프**(구판 스냅샷 재사용 금지 — standalone 호출 잔존판이 클라우드에서 PLS-00201) | DMF0049 BODY 가 SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(클라우드 미존재) 호출 → PLS-00201 |
| 4 | 같은 PKG 를 여러 패키지가 갱신 중이면 **최신 BODY 단일본이 어느 패키지인지 README 상호 명기** | DMF0003 IMMUNIZE ↔ ORA12841_FIX BODY 중복 |

---

## §5. 변경 이력

- **2026-06-02 작성** (DMF0072/0008/0043/0043_01 deploy zip 누락 4건 사후 보강 작업 — 사용자 명시 요구)
- **2026-07-02 §4.5 신설** (DMF0020 SAVE '후속 보강' 잔류 → 클라우드 저장 불능 / SYS0012 PROC_M MERGE ORA-00001 사고)
- **2026-07-23 §4.6 신설** (DMF0003 FE 동봉 누락·DMF0049 `/`구분자 PLS-00103·교차 PKG PLS-00201 — 사용자 룰화 요구)
- 2026-07-29: **§1.0-B 신설** — 00_PRECHECK_CLOUD 동봉 / 신규 채번 충돌 점검 / 권한 미러링 원본 실측 3건 + §1.1 에 재사용 i18n 키 실제 문구 확인 추가 (SYS0017 이관 취합).
- 2026-08-06: **§1.0-C 신설** — 메타 "값 단언" 3종 (CTRL 화이트리스트 / INPUT_TP_CD 분포 대사 / PRECHECK [B] 단언 형식). SYS0017 근본원인 감사 계기 — 본문 = hook #98 §6.
