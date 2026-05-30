# Hook — 메뉴 클릭 후 화면 미표시 5단계 디버깅

> ⭐ 작성 사유 (2026-05-29): 사용자가 "DMF0043 / DMF0043_01 / DMF0072 / DMF0008 메뉴 클릭 시 화면이 안 나옴 → 권한 부여 요청"으로 진단했으나, 실제 원인은 `SCM_ADM_MNU_M.MNU_URL` ↔ `nscm-fe/packages/foundation/src/constants/route-paths.ts` slug 불일치 (3건) 였음. 권한만 의심하다가 진단 시간 낭비.
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

## 5단계 진단 순서 (반드시 1 → 5 순서)

권한은 **5단계 중 3번째**. 1·2·4 를 건너뛰고 권한 보강만 하면 헛수고.

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
