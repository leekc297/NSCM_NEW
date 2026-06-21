# Hook — 메뉴 클릭 후 화면 미표시 7단계 디버깅

> ⭐ 작성 사유 (2026-05-29): 사용자가 "DMF0043 / DMF0043_01 / DMF0072 / DMF0008 메뉴 클릭 시 화면이 안 나옴 → 권한 부여 요청"으로 진단했으나, 실제 원인은 `SCM_ADM_MNU_M.MNU_URL` ↔ `nscm-fe/packages/foundation/src/constants/route-paths.ts` slug 불일치 (3건) 였음. 권한만 의심하다가 진단 시간 낭비.
>
> ⭐ 보강 (2026-06-03): DMF0020 신규 풀스택 작성 후 "메뉴 미표시" 사고 — `MNU_URL ↔ slug` 정합, 라우터, 권한 모두 OK 였으나 **`UPPR_MNU_ID` 대소문자 미일치** (`'DEMAND_MASTER'` 등록 vs 실제 부모 메뉴는 `'Demand_Master'`). 트리 walk-up 시 부모 미발견 → 메뉴 미표시. **Step 1.5 (UPPR_MNU_ID 대소문자 정합) 신규 추가**.
>
> 관련: 룰 08 §4.2 / 룰 11 §2 / 룰 15 / 룰 21 §0 / 룰 25

---

## 트리거

사용자 또는 본인이 다음 중 하나를 보고/감지한 경우 본 hook 실행:

- "메뉴 클릭해도 화면이 안 나옴"
- "{MENU_ID} 화면이 비어 있음"
- "권한 부여 요청" (← 권한 단정 금지, 본 hook 먼저 실행)
- 브라우저 콘솔 `No matching route` / 빈 MDI 탭 / blank screen

---

## 7단계 진단 순서 (반드시 1 → 7 순서)

권한은 **7단계 중 5번째**. 1·2·3·4·6 을 건너뛰고 권한 보강만 하면 헛수고.

### Step 1: `MNU_URL` ↔ FE `route-paths.ts` slug 정합성 ★ 1차 의심

```bash
# 1-1. DB 의 MNU_URL 조회
docker exec nscm-oracle bash -c 'sqlplus -S SCM_MGR/PASSWORD@localhost:1521/FREEPDB1 <<EOF
SELECT MNU_ID, MNU_URL FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('"'"'{TARGET_MNU_ID}'"'"');
EXIT
EOF'

# 1-2. FE route-paths.ts 의 slug 조회
grep -nE "^\s*{TARGET_MNU_ID}:" nscm-fe/packages/foundation/src/constants/route-paths.ts
```

→ 두 값이 **정확히 일치** 해야 함. 불일치 시:
- 해결: DB UPDATE (작은 변경) 또는 route-paths.ts 수정 (라우터/index.ts/폴더명 일관성 큰 변경)
- 자료: `_artifacts/33_DMF_MENU_URL_GUEST_Perm_Fix_*.sql` 4파일 세트 패턴 참조

### Step 1.5: `UPPR_MNU_ID` 대소문자 정합 + 부모 메뉴 존재 ★ 2026-06-03 신규

DB 의 부모 메뉴 ID 는 **케이스 센서티브**. 잘못된 케이스 (`'DEMAND_MASTER'` 대신 `'Demand_Master'`) 등록 시 트리 walk-up 실패 → 메뉴 미표시.

```sql
-- 1.5-1. 자식 메뉴의 부모 ID 확인
SELECT MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD
  FROM SCM_ADM_MNU_M WHERE MNU_ID = '{TARGET_MNU_ID}';

-- 1.5-2. 부모 메뉴 존재 + 케이스 일치 확인
SELECT MNU_ID, MNU_LV_NO FROM SCM_ADM_MNU_M WHERE MNU_ID = '{PARENT_FROM_STEP_1_5_1}';
-- → 0 rows 면 케이스 불일치 (오타) 가능성 — 1.5-3 으로 분기

-- 1.5-3. 같은 도메인의 정상 자매 화면의 UPPR 비교 (★ 진짜 부모 ID 확인)
SELECT MNU_ID, UPPR_MNU_ID, MNU_TP_CD
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0004','DMF0005','DMF0006','DMF0007','DMF0008','DMF0072');
-- → 모두 같은 UPPR_MNU_ID 를 가져야 함. {TARGET} 만 다르면 fix 대상.
```

**표준 부모 메뉴 인벤토리** (룰 08 §4.2 / 2026-06-03 적용):

| Lv 1 (Root) | Lv 2 (Domain) |
|---|---|
| `Master` | `Demand_Master`, `Demand_Plan`, `Demand_JV_Plant` |
| `Demand` | (Master 아래) |
| `Report` | `Customer_Forecast`, `Waterfall` |
| `Admin` | `Admin_Menu`, `System` |
| `Authority` | `Auth_Mgmt` |
| `Popup` | `BusinessPopup`, `CommonPopup` |
| `OPT` | `KHK` |

⚠️ **케이스 표준**:
- Lv 1: 첫 글자 대문자 (`Master`, `Admin`, `Report`) — `MASTER` 금지
- Lv 2: 첫 글자 + `_` 뒤 첫 글자 대문자 (`Demand_Master`) — `DEMAND_MASTER` 금지
- 신규 화면 등록 SQL (`BLOCK 4 MENU`) 작성 시 위 표 그대로 복사.

**MNU_TP_CD 표준**: 모든 leaf 화면 `'SCREEN'` 통일 (다른 값 — `'FN'`, `'M'` 등 — 사용 시 자매 화면과 불일치 가능).

→ 케이스 불일치 발견 시: `UPDATE SCM_ADM_MNU_M SET UPPR_MNU_ID='Demand_Master', MNU_TP_CD='SCREEN' WHERE MNU_ID='{TARGET}'`. 참조: `_artifacts/_deploy_packages/DMF0020/02_DB_Meta_SQL/11_DMF0020_fix_uppr_menu_case.sql` 패턴.

### Step 1.6: `SHT_NM` 자매 화면 정합 ★ 2026-06-03 신규 (메인 그리드 'main' 표준)

메뉴는 표시되는데 화면 진입 후 ORA-01403 at `PKG_NSCM_UI_COMM:17` 발생 시 본 step 적용.

```sql
-- 1.6-1. SHT_NM 자매 화면 cross-check
SELECT MNU_ID, SHT_NM, COUNT(*) AS BTN_CNT
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID IN ('DMF0072','DMF0007','DMF0008','{TARGET_MNU_ID}')
 GROUP BY MNU_ID, SHT_NM ORDER BY MNU_ID;
-- → 메인 그리드 sheet 이름이 자매 화면 표준 'main' 과 일치하는지 확인.
```

**표준**:
- 메인 그리드 1개 → `SHT_NM = 'main'` (DMF0072 등 자매 화면 다수 사용)
- 다중 sheet → 의미 이름 (DMF0008 의 `summary/repair/sspm/updateHistory`)
- FE `constants.ts` 의 `SHEETS.MAIN = 'main'` enum value 와 정확히 일치

→ 불일치 시: `UPDATE SCM_ADM_MNU_BTN_MPG_M SET SHT_NM='main' WHERE MNU_ID='{TARGET}' AND SHT_NM='{wrong}'` + `UPDATE SCM_MST_SHEET_COLUMNS SET SHEET_NAME='main' WHERE PROGRAM_ID='{TARGET}' AND SHEET_NAME='{wrong}'`. 참조: `_artifacts/_deploy_packages/DMF0020/02_DB_Meta_SQL/12_DMF0020_fix_sheet_name_main.sql`.

### Step 2: FE 라우터에 컴포넌트 매핑 존재 여부

```bash
# 2-1. Router.tsx 의 import 매핑
grep -nE "{slug}|{ComponentName}" nscm-fe/apps/web/src/core/Router.tsx

# 2-2. features/{domain}/src/index.ts 의 export
grep -nE "{ComponentName}" nscm-fe/features/master/src/index.ts
```

→ 매핑 + export 모두 있어야 함. 없으면 추가.

### Step 3: 사용자 그룹 × 메뉴 권한 (`SCM_ADM_USER_GR_MNU_MPG_M`)

```sql
SELECT M.USER_GR_ID, M.MNU_ID, M.USE_YN
  FROM SCM_ADM_USER_GR_MNU_MPG_M M
 WHERE M.USER_GR_ID IN (
   SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '{LOGIN_USER}'
 )
   AND M.MNU_ID IN ('{TARGET_MNU_ID}');
```

→ 적어도 1 그룹에 `USE_YN='Y'` 가 있어야 함. 없으면 형제 메뉴에서 동적 복제 (룰 11 §2, 하드코딩 그룹 금지).

### Step 4: 부모 메뉴 권한

자식 메뉴 권한이 있어도 부모 메뉴가 트리에서 차단되면 노출 안 됨.

```sql
SELECT USER_GR_ID, MNU_ID, USE_YN
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID = (SELECT UPPR_MNU_ID FROM SCM_ADM_MNU_M WHERE MNU_ID = '{TARGET_MNU_ID}')
   AND USER_GR_ID IN (
     SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '{LOGIN_USER}'
   );
```

### Step 5: 컴포넌트 런타임 오류 (1~4 모두 OK 인데 빈 화면)

- 브라우저 콘솔: `Uncaught ReferenceError` / `Cannot read properties of undefined` / `Box is not exported from @shared/mui` 등
- BE 로그 (`tail -50` BE bootRun 출력): 401 / 500 / NullPointerException
- 룰 23 §5.1 (FE import 인벤토리) + hook `runtime-error-prevention.md` 적용 점검

---

## 안티 패턴 (실수 사례)

| ❌ 잘못된 진단 | ✅ 올바른 진단 |
|---|---|
| "화면 안 나옴 → 권한 누락이겠지" → Step 3 만 보고 INSERT | Step 1 (slug 정합) 먼저 확인 — DMF0043 사고 (2026-05-29) |
| 룰셋 문서의 컬럼명 (`P_MNU_ID`, `GR_CD`) 으로 SQL 작성 | 실제 컬럼명은 `UPPR_MNU_ID`, `USER_GR_ID` — 항상 `USER_TAB_COLUMNS` 로 cross-check |
| MNU_URL 에 디렉토리 prefix (`/master/.../slug`) 저장 | leaf slug only (룰 08 §4.2) |
| 권한 INSERT 시 그룹을 하드코딩 (`'ADMIN','GUEST'`) | 형제 메뉴에서 SELECT 로 동적 복제 (룰 11 §2) |

---

## 출력 양식 (사용자에게 보고)

```markdown
## {MENU_ID} 화면 미표시 진단 결과 (hook: menu-not-displayed-debug)

| Step | 항목 | 상태 | 조치 |
|---:|---|:---:|---|
| 1 | MNU_URL ↔ FE slug 정합 | ❌ | DB UPDATE 필요 (`{actual}` → `{expected}`) |
| 2 | FE 라우터 매핑 | ✅ | - |
| 3 | 사용자 그룹 메뉴 권한 | ✅ | ADMIN/DM ADMIN 보유 |
| 4 | 부모 메뉴 권한 | ✅ | - |
| 5 | 컴포넌트 런타임 | ❓ | Step 1 해결 후 재확인 |

→ 진짜 원인: Step {N}. 권한 보강만으로는 해결 안 됨.
```
