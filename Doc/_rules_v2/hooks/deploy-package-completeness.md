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

### §1.8 ⭐⭐ FE 이관물 = **실제 저장소 디렉토리 구조 그대로** (2026-08-26 사용자 명시 — 상시 의무)

> 사용자 원문: "이관폴더 생성 시 FE 실경로 구조 재배치는 항상 반영되도록 RULE 로 적용해주세요."

이관 폴더의 FE 산출물(`B_FE/` 등)은 **nscm-fe 저장소 루트 기준 실경로를 그대로 보존**해 담는다.
적용자가 `B_FE/` 하위를 저장소 루트에 그대로 덮어쓰면 끝나는 형태가 정본이다.

```
(정본)  B_FE/features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx
(금지)  B_FE/forecast-price/components/ForecastPriceGrid.tsx        ← 축약 경로
(금지)  B_FE/ForecastPriceGrid.tsx                                   ← 평탄화
```

- 대상 = **이관대상(수정) 파일만** — 디렉토리는 실경로로 만들되 미수정 형제 파일은 담지 않는다.
- 축약/평탄화 금지 사유: 적용자가 목적지 경로를 복원 추론해야 하고, 동명 파일(index.ts 등)이
  다른 폴더에 존재하면 오배치가 조용히 발생한다. 경로 자체가 적용 명세다.
- README 의 FE 표는 `B_FE/` 하위 경로 기준으로 기재하고 "루트에 그대로 덮어쓰기" 문구를 명시한다.
- 첫 적용 사례: `DMF0082_CLOUD_20260826_PENDING/B_FE/` (2026-08-26 재배치).

#### §1.8-B ⭐⭐ FE 산출물은 **`B_FE`(통째 덮어쓰기) / `FE_MERGE`(부분 병합) 로 분리** (2026-09-04 사용자 명시 — 상시 의무)

> 사용자 원문: "클라우드 이관 폴더 생성 시, COPY 대상인 FE 와 부분적으로 복사해서 기존 SOURCE 에
> MERGE 해야 하는 FE_MERGE 는 분리해주세요. 앞으로."

| 폴더 | 대상 | 적용 방법 |
|---|---|---|
| `B_FE/` | **그 화면 전용 파일** — 화면 폴더 전체, 화면 전용 컴포넌트/유틸/scss | 저장소 루트에 **그대로 덮어쓰기** |
| `FE_MERGE/` | **여러 화면이 공유하는 한 파일**의 일부분 | 기존 파일의 **해당 구간만 교체**(전체 덮어쓰기 ⛔) |

`FE_MERGE` 로 가야 하는 전형:

- `nscm-fe/configs/types/procedures.d.ts` — MENU 블록 단위. 전체본을 덮으면 타 화면 블록이 소실된다(hook #148).
- 공용 배럴 `index.ts`(`@shared/components`, `@foundation/assets` 등) — §1.5 PATCH 안내문과 짝.
- 공용 상수·i18n JSON 처럼 화면별 항목이 한 파일에 누적되는 산출물.

의무:
1. 두 폴더를 **항상 분리**한다(대상이 없으면 그 폴더를 만들지 않고 README 에 "해당 없음"으로 적는다).
2. `FE_MERGE/` 도 **실경로 구조를 보존**한다(§1.8) — 어느 파일의 어느 구간인지 경로로 드러나게.
3. README 에 `FE_MERGE` 표를 두고 **파일별 병합 지점**(무엇을 어디부터 어디까지 교체)을 문장으로 명시한다.
4. 삭제 대상 파일(덮어쓰기로는 지워지지 않는다)은 별도 목록으로 README 에 적는다.

첫 적용 사례: `DMF0035_CLOUD_20260904/` (`B_FE/` 화면 폴더 19파일 / `FE_MERGE/` procedures.d.ts DMF0035 블록).

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
2-B. ⭐ **[E20260831-ONKEY] 무 PK 테이블 MERGE = 논리키 실측 폴백 의무** — 생성기가 "ON = PK 실측" 규약일 때
   PK/UK 가 없는 테이블(`SCM_ADM_EXCEL_COLUMNS` 실측 0건)은 **`ON ()` 빈 절이 생성되어 ORA-00936**
   (DMF0074_CLOUD_20260831 클라우드 적용 실패 — 사용자 실측 2026-08-31). 의무: ①생성기에 논리키 폴백 맵
   (`EXCEL_COLUMNS → (PROGRAM_ID, SHEET_NAME)`) + 사용 시점 유일성 실측 assert + 폴백 미등록 시 생성 차단
   ②산출물 검사 `grep "S ON ()"` = 0건 ③메모리 `feedback_merge_on_key_must_match_pk` 계보(추정 금지·실측만).
   정본 구현 = `_ui_cloud_pkg_build_20260831.py::LOGICAL_KEY_FALLBACK`.
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

## §4.7 ⭐⭐⭐ 2026-08-20 — 축 누락은 "룰 부재"가 아니라 **스윕 목록 누락**이다 (기계 적출 의무)

**실사고**: `DMF0035_CLOUD_20260820` 패키지에 **`SCM_ADM_PROC_M` 축이 통째로 빠졌다**. 클라우드 적용 후
8시트 중 6시트가 PROC_M 0행 → **PLS-00306**(인수 갯수·유형 불일치)로 화면이 죽었다.
⚠ 본 hook 은 §4.5-2 에서 이미 PROC_M 이관 방식까지 규정하고 있었다 — **룰은 있었고 실행에서 빠졌다.**

**근본원인**: 취합 시 "딕셔너리 전수 스윕"을 한다면서 **대상 테이블 목록 자체에 PROC_M 이 없었다**.
`20_MENU_META_SYNC.sql` 의 MERGE 63건 = MNU_M 1 + PROGRAM 1 + API_M 8 + BTN_MPG 8 + GR_MNU 5 + GR_BTN 40
= **정확히 63** — PROC_M 이 들어갈 자리가 처음부터 없었고, 카운트가 딱 맞아떨어져 **누락이 보이지 않았다**.
(손나열 축 누락 계보 = 2026-08-14 BTN 축 스킵과 동형. 카운트 일치는 완전성의 증거가 **아니다**.)

**의무 3**:
1. **메타 스윕 상시 축에 `SCM_ADM_PROC_M` 을 명시적으로 포함**한다. 스윕 목록은 코드/문서에 **열거된
   상수**로 두고, 패키지 README 에 축별 실측 카운트를 **축 이름과 함께** 적는다("합계 63" 만 적으면
   빠진 축이 보이지 않는다).
2. **배선 역추적 적출을 90_VERIFY 에 필수 편입**(정상 = 0행):
   `SCM_ADM_MNU_BTN_MPG_M(MNU_ID) ⋈ SCM_ADM_API_M` 로 전 시트의 호출 SP 를 뽑아
   `SCM_ADM_PROC_M` 행수와 `ALL_ARGUMENTS` 인자수를 비교 → **불일치 또는 0 이면 FAIL**.
   이 쿼리는 "무엇을 넣었는가"가 아니라 **"화면이 부르는 것 중 무엇이 없는가"** 를 묻기 때문에
   스윕 목록이 틀려도 잡힌다.
3. **공유 SP 축은 덮어쓰기 금지** — 클라우드에 이미 정상 등재된 타 화면 소관 SP(예 DMF0035 패키지의
   `P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL`)는 적재 대상에서 제외한다(회귀 방지).

### §4.7-B 같은 날 2번째 사례 — **메뉴 행(MNU_M) 부재 → 전 화면 조용한 0행** (2026-08-20)

DMF0035 클라우드에서 **3 TYPE 전부 0행**. 데이터·메타·PROC_M·PKG·캘린더·GTT·콤보를 4차수에 걸쳐
전수 확인했는데 **전부 정상**이었고, 실제 원인은 `SCM_ADM_MNU_M` 에 **DMF0035 행 자체가 없었던 것**.

기전: `PKG_DMF0035/0022/0051` 셋 다 아래 조인을 갖는다 — **3 TYPE 동시 사망의 단일 지점**.
```
INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
   ON EDY.USER_ID=<로그인> AND EDY.MNU_ID=<화면> AND EDY.UNIT_ID=A.DIVISION_ID
```
그 뷰는 `JOIN SCM_ADM_MNU_M MNU ON MNU.UNIT_TP_CD = AUTH.UNIT_TP_CD ... WHERE MNU.USE_YN='Y'` 이므로
**메뉴 행이 없거나 `UNIT_TP_CD<>'D'`/`USE_YN<>'Y'` 이면 뷰가 0행 → 조회 결과도 0행**이 된다.

⚠ 교훈 3:
1. **권한 뷰를 INNER JOIN 하는 SP 는 그 뷰가 조회 필터**다 — 권한이 "막는" 게 아니라 **데이터를 지운다**.
   (같은 날 DMF0044 환율 팝업에서 정정한 `SCM_ADM_USER_MNU_EDIT_AUTH_V` INNER JOIN 과 동일 계보)
2. **오류 없이 조용히 0행** — SP 는 성공(CODE 0)으로 끝나고 로그에도 예외가 없어 **배포 성공으로 보인다**.
   `RESULT_COUNT=0` 은 판정 근거가 아니다(callProc 은 커서를 세지 않아 정상 호출도 0으로 찍힌다).
3. 자식 메타(API_M/BTN_MPG/PROC_M)가 있어도 **부모 메뉴 행이 없을 수 있다** — 축별 존재만 세지 말고
   **화면이 실제로 의존하는 것**(메뉴 행 + 권한 뷰 반환 행)을 검증해야 한다.
⇒ `90_VERIFY` **V11** 신설: ①메뉴 행 실존 + `UNIT_TP_CD='D'`/`USE_YN='Y'` ②대상 계정의 권한 뷰 반환 행 > 0.

**부수 확인 축**: PROC_M 행이 있어도 **객체 자체가 없으면** ARG_CNT 0 으로 같은 증상이 난다
(DMF0035 실측: `DMF0073_GET_VERSION_SALESPRICE` = PROC_M 9행 / 객체 부재). 역추적 쿼리가 두 경우를
같이 잡으므로 **본문 동봉 + GRANT/시노님**까지 함께 판정할 것(GRANT 누락 = PLS-00201 계보).

---

## §4.8 ⭐⭐⭐ 2026-08-28 — §4.7-B V11 이 **생성기에 미구현되어 8일 만에 재발** + 4축 추가 (hook #148 로 분리)

2026-08-27 DMF0040/0053/0035 클라우드 이관 후 5건 실패가 전부 이관 축 누락: ①앱계정 GRANT/시노님(`40_GRANT_SYNONYM.sql`) ②동적 SQL NLS(#109 §6)
③메뉴 행 부재(§4.7-B **그대로 재발** — 4 패키지 `90_VERIFY` 에 V11 없었음) ④통합 화면 종속 PROGRAM_ID 메타(`22A_SHEET_META_DEP_PROGRAMS.sql`)
⑤`procedures.d.ts` 블록 경계 결함. 교훈 = **hook 본문의 의무는 생성기 코드에 있을 때만 룰이다.** 상세·게이트·진단 순서 = [[cloud-deploy-silent-failure-gates]](#148).
`90_VERIFY` 는 V11(메뉴 행+권한 뷰) / V12(앱계정 EXECUTE+시노님) / V13(종속 PROGRAM_ID 메타) 3 게이트 의무.

---

## §5. 변경 이력

- **2026-06-02 작성** (DMF0072/0008/0043/0043_01 deploy zip 누락 4건 사후 보강 작업 — 사용자 명시 요구)
- **2026-07-02 §4.5 신설** (DMF0020 SAVE '후속 보강' 잔류 → 클라우드 저장 불능 / SYS0012 PROC_M MERGE ORA-00001 사고)
- **2026-07-23 §4.6 신설** (DMF0003 FE 동봉 누락·DMF0049 `/`구분자 PLS-00103·교차 PKG PLS-00201 — 사용자 룰화 요구)
- 2026-07-29: **§1.0-B 신설** — 00_PRECHECK_CLOUD 동봉 / 신규 채번 충돌 점검 / 권한 미러링 원본 실측 3건 + §1.1 에 재사용 i18n 키 실제 문구 확인 추가 (SYS0017 이관 취합).
- 2026-08-20: **§4.7 신설** — PROC_M 축 통째 누락(DMF0035 클라우드 PLS-00306, 사용자 신고). 룰은 있었고
  **스윕 목록에서 빠진 것**이 원인. 상시 축 명시 + **배선 역추적 0행 적출(V10)** 필수 편입 + 공유 SP
  덮어쓰기 금지. "카운트가 딱 맞음"은 완전성의 증거가 아니라는 계보 기록.
- 2026-08-06: **§1.0-C 신설** — 메타 "값 단언" 3종 (CTRL 화이트리스트 / INPUT_TP_CD 분포 대사 / PRECHECK [B] 단언 형식). SYS0017 근본원인 감사 계기 — 본문 = hook #98 §6.
- 2026-08-26: **§1.8 신설** — FE 이관물 = 저장소 실경로 구조 보존 의무 (사용자 명시 상시 룰. DMF0082_CLOUD_20260826_PENDING 축약 경로 → 실경로 재배치 계기).

---

## §MSG. `SCM_ADM_MSG_M` 축 = `INSERT ... NOT EXISTS` 전용 ⭐ (2026-08-21 사용자 명시)

이관 패키지에 MSG/LBL 을 담을 때 **기존 코드의 문구를 덮는 문장을 만들지 않는다.**
코드는 화면 간 공유 자산이라, 한 화면 기준으로 문구를 바꾸면 그 코드를 쓰는 **다른 모든 화면이
조용히 오표기**된다.

```sql
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
                                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT '<CODE>', '<LANG>', '...', NULL, '<TP>', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M T
                    WHERE T.MSG_ID = '<CODE>' AND T.LANG_CD = '<LANG>');
```

취합 체크 (grep 으로 실측):

```
[ ] MERGE INTO SCM_ADM_MSG_M / UPDATE ... SET MSG_NM / DELETE FROM SCM_ADM_MSG_M  = 0건
[ ] INSERT 문 수 == NOT EXISTS 가드 수 (PK = MSG_ID + LANG_CD 양쪽)
[ ] 담긴 코드 = 신규분만 (대상 환경 기보유 코드 미포함)
[ ] 감사컬럼 전부 'admin'
[ ] 재실행 멱등 (두 번 돌려도 결과 동일)
```

> 본문·예외·자동 생성기 = **hook #140 `msg-table-cloud-sync-and-insert-only` §B**.
> 정본 산출물 = `_artifacts/_cloud_to_corp/MSG_SYNC/out_*/30_CLOUD_PUSH.sql`.
- 2026-08-28: §4.8 신설 — V11 미구현 재발 + 4축(GRANT/NLS/종속 PROGRAM_ID/d.ts 블록) → hook #148 분리.
