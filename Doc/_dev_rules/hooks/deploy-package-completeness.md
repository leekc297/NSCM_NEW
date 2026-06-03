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

### §1.1 5-종 인벤토리 작성

```
☐ FE useTabProcQuery / useProcMutation 의 모든 sheetName 추출?
   → grep -rE "useTabProcQuery|useProcMutation" nscm-fe/features/.../{화면-slug}/
   → 모든 sheetName 목록 산출 (예: 'main', 'dataType', 'team', 'endCustomer', 'salesSite', ...)

☐ FE POPUP modal 컴포넌트 모두 식별?
   → grep -rE "<\w+Modal" nscm-fe/features/.../{화면-slug}/
   → 공용 modal (master/src/components/) + 화면 전용 modal 분리

☐ 위 sheetName 별 BE SP 이름 cross-check?
   → SCM_ADM_MNU_BTN_MPG_M[MNU_ID, SHT_NM] → API_ID → SCM_ADM_API_M.API_URL = SP 이름
   → BLOCK 3 의 모든 SHT_NM 이 sheetName 과 1:1 일치 의무

☐ 위 SP 들의 SCM_ADM_PROC_M 등록 확인?
   → PROC_NM × COL_NM × COL_TP_CD 모두 등록
   → BE 자동 채움 키 (sesUserId/mnuId/sesLangCd) 정확 매핑

☐ ALL_SOURCE 의 SP body 모두 03_SP_PKG/ 동봉?
   → DBMS_METADATA.GET_DDL('PROCEDURE', name, 'SCM_MGR') 일괄 추출
   → wrapper / 공용 SP 도 동봉 (비고 표시)
```

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

## §5. 변경 이력

- **2026-06-02 작성** (DMF0072/0008/0043/0043_01 deploy zip 누락 4건 사후 보강 작업 — 사용자 명시 요구)
