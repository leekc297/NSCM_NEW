# 17. 신규 화면 5분 Quickstart

> 신규 화면 1개를 추가하는 최단 경로. 9 step 압축본 + 핵심 명령어 한 줄씩.
> 자세한 사항은 각 step 의 → 링크 참조.
>
> ⭐ **필독 (3 분)**: [`01_CLAUDE.md`](01_CLAUDE.md) §1-5 + [`07_DO_AND_DONT.md`](07_DO_AND_DONT.md) + 본 문서.
> ⭐ **참조 표준 화면**: `nscm-fe/features/admin/src/pages/user-management/` (FE) + `nscm-be/.../admin/menu/` (BE)

---

## 사전 결정 (5초)

| 항목 | 결정 |
|---|---|
| MENU_ID | `DMF0099` (도메인 코드 + 4자리) |
| 도메인 | `demand` / `master` / `admin` / `factory` / `supply` / `shipping` 중 1 |
| FE 페이지 폴더 (kebab) | `dmf0099-sales-monitor` |
| FE 컴포넌트 (Pascal) | `Dmf0099SalesMonitor` |
| BE 패키지 | `com.lgcns.nscm.demand.dmf0099` |
| nameSpace | `"demand.dmf0099."` |
| As-Is 화면 (마이그레이션) | `DMF0099.cs` 또는 `없음` |

---

## Step 1 — As-Is 자료 사전 확인 (As-Is 화면 마이그레이션만)

```bash
# 필수 4 자료 Read 후 카운트 기록
Doc/_analysis/domain_DM/screens/DMF0099/validation.md     → __ 건
Doc/_analysis/domain_DM/screens/DMF0099/expressions.md    → __ 건
Doc/_analysis/domain_DM/screens/DMF0099/analysis.md
_analysis/_screens/27_DM_Screens/DMF0099.xlsx                       → 12 시트 데이터
```

→ 상세: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md) §1

## Step 2 — DB Procedure 작성 + 컴파일

```sql
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0099 AS
  PROCEDURE P_DMF0099_GET_MAIN_DATA (
    P_DIVISION_ID   IN  VARCHAR2,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  );
END PKG_DMF0099;
/
GRANT EXECUTE ON SCM_MGR.PKG_DMF0099 TO SCMD_APP;
```

> 패턴: GET 은 `O_RC1` + `O_RESULT_CURSOR` 2 커서. SAVE 는 `O_RESULT_CURSOR` 1 커서.

→ 상세: [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) §3 Step 1

## Step 3 — 7개 영역 메타 등록 (자기완결형 인라인 DML, 4-파일 SQL 세트)

```
registrations/
├── 99_DMF0099_Registration.sql                  ← SQL*Plus / SQLcl 용
├── 99_DMF0099_Registration_DBeaver.sql          ← DBeaver 등록 (PL/SQL 1 블록)
├── 99_DMF0099_Registration_DBeaver_Verify.sql   ← DBeaver 검증 (UNION ALL 단일 SELECT)
└── 99_DMF0099_Registration_DBeaver_Diagnose.sql ← DBeaver 라우팅 진단
```

7-BLOCK 의무 등록 (의존 선후 순):

```sql
BEGIN
  -- BLOCK 1: SCM_ADM_MSG_M      (i18n × KO/EN/CN 3행)
  -- BLOCK 2: SCM_ADM_MNU_M      (메뉴 마스터)
  -- BLOCK 3: SCM_ADM_PROC_M     (SP IN/OUT ★ 누락 시 빈 결과)
  -- BLOCK 4: SCM_ADM_API_M      (API 메타, API_MSG_ID NOT NULL)
  -- BLOCK 5: SCM_ADM_MNU_BTN_MPG_M  (라우팅)
  -- BLOCK 6: SCM_MST_SHEET_COLUMNS  (Grid 컬럼)
  -- BLOCK 7: SCM_ADM_USER_GR_MNU_MPG_M + SCM_ADM_USER_GR_MNU_BTN_MPG_M (권한 2 테이블)
  COMMIT;
END;
```

❌ **금지**: `PKG_NSCM_SCREEN_REGISTRATION` 호출 (2026-05-19 폐기).
❌ **DBeaver 금지**: `SET DEFINE` / `DEFINE` / `&변수` / `PROMPT` / `END; /` / PL+SELECT 혼재.

→ 상세: [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) §3, §7.1

## Step 4 — 빈 매핑 매트릭스 생성 (As-Is 마이그레이션만)

```bash
python3 Doc/_analysis/scripts/gen_asis_mapping.py \
    --out C:/Projects/NSCM/nscm-fe/features/demand/src/pages/dmf0099-sales-monitor/__asis-mapping__.md \
    DMF0099
```

모든 행이 ❌ 상태로 시작 — To-Be 코드 작성 후 각 행을 ✅ 로 마킹.

## Step 5 — FE 폴더 생성 (표준 7 파일)

```
features/demand/src/pages/dmf0099-sales-monitor/
├── Dmf0099SalesMonitor.tsx               ← 페이지 메인
├── dmf0099-sales-monitor.constants.ts    ← MENU_ID / SHEETS / RESPONSE_SET
├── useDmf0099SalesMonitorStore.ts        ← Zustand store
├── __asis-mapping__.md                   ← As-Is ↔ To-Be 매트릭스 (Step 4)
├── index.ts                              ← export *
└── components/
    ├── Dmf0099SalesMonitorForm.tsx       ← 검색 영역
    ├── Dmf0099SalesMonitorForm.module.scss
    └── Dmf0099SalesMonitorGrid.tsx       ← Wijmo FlexGrid
```

→ 코드 템플릿: [`05_SCREEN_TEMPLATE.md`](05_SCREEN_TEMPLATE.md) §2

## Step 6 — BE 패키지 생성 (특수 로직 있을 때만)

> NSCM 은 동적 SP 호출 아키텍처라 대부분 GeneralController 가 처리. 다음 4 파일은 **특수 비즈니스 로직이 필요한 경우에만** 작성.

```
src/main/java/com/lgcns/nscm/demand/dmf0099/
├── Dmf0099Controller.java
├── Dmf0099Service.java          (interface)
├── Dmf0099ServiceImpl.java      (extends BaseService)
└── dto/
    ├── Dmf0099Request.java
    └── Dmf0099Response.java

src/main/resources/sql/demand/Dmf0099.xml   (namespace = "demand.dmf0099")
```

→ 코드 템플릿: [`01_CLAUDE.md`](01_CLAUDE.md) §6 / [`04_BE_RULES.md`](04_BE_RULES.md)
→ 동적 호출 아키텍처: [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md)

## Step 7 — `procedures.d.ts` 갱신

```bash
cd nscm-fe
pnpm gen:procedures      # 자동 생성 (메타 → DB → procedures.d.ts)
git diff configs/types/procedures.d.ts   # 변경분 확인
```

## Step 8 — i18n JSON 갱신 (신규 MSG/LBL 추가 시)

```bash
python3 Doc/_analysis/scripts/gen_i18n_msg_json.py \
    --out C:/Projects/NSCM/nscm-fe/apps/web/src/locales/

# 새로 추가된 MSG 가 SCM_ADM_MSG_M 에 없으면 (TODO 표시) → DB 등록 필요
```

## Step 9 — 100% 매핑 검증 + PR 머지 게이트

```bash
# As-Is 적용 카운트 검증
PENDING=$(grep -c '| ❌ |$' features/demand/src/pages/dmf0099-sales-monitor/__asis-mapping__.md)
[ $PENDING -eq 0 ] || { echo "❌ 미적용 $PENDING 건"; exit 1; }

# 빌드 / 테스트
pnpm lint:fix && pnpm type-check && pnpm build && pnpm test
./gradlew spotlessApply && ./gradlew build && ./gradlew test
```

→ PR 머지 게이트 5종 체크: [`18_CODE_REVIEW_CHECKLIST.md`](18_CODE_REVIEW_CHECKLIST.md)

---

## 자기 점검 (PR 직전 9 자문)

1. user-management 와 나란히 두고 폴더 구조/스타일 차이 없나?
2. import alias (@shared/@foundation) 만 사용했나?
3. console.log / any / inline style / @Autowired / Hardcoded SQL ID 0건?
4. MSSQL 키워드 0건? (DATEADD / GETDATE / ISNULL / N' / NOLOCK)
5. **As-Is validation.md / expressions.md 행 수 == 적용 건수**? __asis-mapping__.md ✅ 100% ?
6. **7개 영역 메타 검증 SQL 실행 결과 모두 CNT ≥ EXPECT_MIN** ?
7. 4-파일 SQL 세트 (SQL\*Plus 1 + DBeaver 3) 동봉?
8. procedures.d.ts / msg.json 동기화 완료?
9. Wijmo `gridRef.current.invalidate()` 핸들러 직접 호출 0건? (`finishEditing` 사고 방지)

→ 상세 hook: [`hooks/pre-write.md`](hooks/pre-write.md) → [`hooks/post-write.md`](hooks/post-write.md) → [`hooks/pre-submit.md`](hooks/pre-submit.md)

---

## 흔히 빠뜨리는 4 가지 (DMF0007 / DMF0099 사례 기록)

1. **`SCM_ADM_PROC_M` 누락** → SP 가 NULL 파라미터로 호출되어 **빈 결과 반환** (가장 잦은 사고)
2. **`SCM_ADM_USER_GR_MNU_BTN_MPG_M` (버튼 권한) 누락** → 'No Permission' 오류
3. **`MNU_URL` 에 전체 경로 저장** → leaf slug 만 저장해야 함 (`sales-future-price` ✓, `/master/.../sales-future-price` ✗)
4. **`SCM_ADM_API_M.API_MSG_ID` NULL** → NOT NULL 위반. `MSG_API_{MENU}_{SHEET}_{ACTION}` 패턴 사용 + BLOCK 1 에 i18n 동반 INSERT

→ 트러블슈팅: [`21_TROUBLESHOOTING.md`](21_TROUBLESHOOTING.md)
