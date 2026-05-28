# 07. DO / DON'T 빠른 참조 카드

> 작업 중 의문이 들 때 빠르게 확인하는 1-pager.

## 🟢 DO (반드시 이렇게)

### Frontend

```tsx
// ✅ Alias import
import { apiClient } from '@foundation/apis';
import { MainTitle } from '@shared/components';

// ✅ 개별 셀렉터
const filters = useStore(s => s.filters);
const setFilters = useStore(s => s.setFilters);

// ✅ Zustand 탭별 격리
createPersistedStoreWithTab(initializer, 'page-name');

// ✅ 표준 훅 사용
useTabProcQuery({ menuId, sheetName, tabId, filters, enabled });
useProcMutation({ menuId, sheetName, tabId });

// ✅ Wijmo Grid
import { FlexGrid } from '@mescius/wijmo.grid';

// ✅ SCSS Module
import styles from './Form.module.scss';
<div className={styles.container} />

// ✅ i18n
const { t } = useTranslation();
<button>{t('LBL00112', '_Search')}</button>

// ✅ MENU_ID 타입 + as const
export const MENU_ID = 'SYS0002' as const;
export type MENU_ID = typeof MENU_ID;

// ✅ 파일명 PascalCase, 폴더 kebab-case
// pages/user-management/UserManagement.tsx
```

### Backend

```java
// ✅ 표준 어노테이션 세트
@Slf4j
@Service
@RequiredArgsConstructor
public class FeatureServiceImpl extends BaseService implements FeatureService { ... }

// ✅ final 필드 + 생성자 주입
private final FeatureService featureService;

// ✅ nameSpace 변수
private final String nameSpace = "demand.dmf0099.";

// ✅ BaseService 메서드
Map<String, Object> result = selectList(nameSpace + "method", params);
List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);

// ✅ BaseResponse 래핑
return successResponseEntity(dto);

// ✅ DTO 정적 팩토리
public static FeatureDto of(Map<String, Object> data) { ... }
public static List<FeatureDto> listOf(List<Map<String, Object>> datas) { ... }

// ✅ Builder 패턴
FeatureDto.builder().mnuId(...).build();

// ✅ Slf4j 로깅
log.info("user: {}", userId);

// ✅ Swagger
@Tag(name = "도메인. 기능")
@Operation(summary = "...", description = "...")

// ✅ @LoginUser
public ResponseEntity<...> retrieve(@LoginUser UserSession userSession) { ... }
```

### SQL / MyBatis

```xml
<!-- ✅ 표준 형식 -->
<select id="retrieveMain" statementType="CALLABLE">
    { CALL SCM_MGR.PKG_DMF0099.P_DMF0099_GET_MAIN_DATA(
        #{userId},
        #{divisionId},
        #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet, resultMap=xxxResultMap}
    ) }
</select>

<!-- ✅ #{} 바인딩만 -->
WHERE user_id = #{userId}
```

```sql
-- ✅ Oracle 표준
SYSDATE
NVL(col, default)
INSTR(s, p)
SUBSTR(s, n, m)
ADD_MONTHS(d, n)
'문자' || 'a' || '결합'
A.x = B.y(+)  -- Outer Join
```

---

## 🔴 DON'T (절대 하지 말 것)

### Frontend

```tsx
// ❌ 상대 경로 깊이
import { Button } from '../../../packages/shared/src/components';

// ❌ Feature 간 직접 import
import { something } from '@demand/...'  // (admin에서)

// ❌ Foundation에서 React 사용
// packages/foundation에는 React import X

// ❌ 통째로 store 가져오기
const store = useStore();
const { filters, setFilters } = useStore();

// ❌ useState로 페이지 전역 상태
const [filters, setFilters] = useState();  // (단일 컴포넌트가 아닌 경우)

// ❌ 직접 fetch / axios
fetch('/api/...');
axios.get('/api/...');

// ❌ console.log 운영 코드
console.log('user:', user);

// ❌ inline style
<div style={{ padding: 8 }} />

// ❌ any 타입
const data: any = ...;

// ❌ 비표준 그리드
import DataGrid from '@mui/x-data-grid';  // Wijmo만 사용
```

### Backend

```java
// ❌ Controller에 SQL 직접 호출
sqlSession.selectList("user.retrieveUser");

// ❌ 필드 주입
@Autowired
private UserService userService;

// ❌ 단일 클래스 (Service interface 없음)
@Service
public class UserService { ... }  // ServiceImpl 분리해야 함

// ❌ 하드코딩 SQL ID
selectList("admin.user.retrieveUser", params);
// (nameSpace 사용)

// ❌ Map 직접 반환
public Map<String, Object> retrieveUser(...) { ... }
// (DTO 변환 필수)

// ❌ ResponseEntity 직접
return ResponseEntity.ok(data);
// (BaseResponse 래핑)

// ❌ System.out
System.out.println("user: " + userId);

// ❌ String concat 로깅
log.info("user: " + userId);
// (Parameterized로)

// ❌ try-catch swallow
try { ... } catch (Exception e) { }

// ❌ @RequestMapping (HTTP method 없음)
@RequestMapping("/admin/user")
// (@GetMapping/@PostMapping 명시)
```

### SQL / MyBatis

```xml
<!-- ❌ ${} 직접 바인딩 (SQL Injection 위험) -->
WHERE user_id = '${userId}'

<!-- ❌ Owner prefix 남발 -->
SELECT * FROM SCM_MGR.SCM_USER_M
<!-- Synonym 사용 또는 PKG 호출 권장 -->
```

```sql
-- ❌ MSSQL 함수 잔존 (컴파일 오류)
DATEADD(MONTH, 1, dt)
CHARINDEX('::', s)
STRING_SPLIT(s, ',')
GETDATE()
ISNULL(col, 0)
IIF(cond, a, b)
LEFT(s, 3)
CONVERT(VARCHAR, dt)

-- ❌ 잔존 키워드
WITH (NOLOCK)
N'유니코드'
[bracket]
dbo.table
+ '문자열' + '결합'  -- Oracle은 ||

-- ❌ ANSI Outer Join (사내 표준은 (+))
LEFT OUTER JOIN B ON A.x = B.y
```

---

## 🟡 신중하게 (검토 후)

### Frontend

| 패턴 | 검토 사항 |
|---|---|
| `useMemo` / `useCallback` | 명확한 성능 이슈가 있을 때만 |
| `React.lazy` | 큰 컴포넌트, 라우팅 분할 시만 |
| 새 라이브러리 추가 | 기존 stack(Wijmo/MUI/Zustand)에 동일 기능 있는지 |
| Custom hook | 3곳 이상에서 재사용될 때 → shared/hooks 이동 |

### Backend

| 패턴 | 검토 사항 |
|---|---|
| `@Transactional(propagation=...)` | 기본 REQUIRED 외에는 신중 |
| `MERGE INTO` | 온라인 SQL은 사용 금지, 배치만 허용 |
| Dynamic SQL (`<if>/<foreach>`) | 가능한 PL/SQL 패키지 내부 처리 |
| 새 Lombok 어노테이션 | `@Builder/@Getter/@AllArgsConstructor` 외엔 신중 |

---

## 📝 코드 작성 전 5초 체크

```
[ ] 기존 유사 화면(예: user-management) 코드를 먼저 봤는가?
[ ] Layer 의존 방향이 맞는가? (Foundation ← Shared ← App)
[ ] 명명 규약 OK? (PascalCase/camelCase/kebab-case)
[ ] import 순서 표준 OK? (foundation → shared → 같은 feature)
[ ] BaseResponse / BaseService / BaseController 표준 OK?
[ ] ⭐ As-Is validation.md + expressions.md 읽었는가? (카운트 기록)
```

## 📝 PR 제출 전 10초 체크

```
[ ] pnpm lint:fix / ./gradlew spotlessApply 통과
[ ] pnpm type-check / ./gradlew build 통과
[ ] 단위 테스트 추가
[ ] 화면 동작 직접 확인
[ ] 기존 코드와 스타일 일관성 (한 사람이 짠 것처럼)
[ ] DO/DON'T 위반 없음
[ ] ⭐ __asis-mapping__.md 작성 + Validation/Expression 카운트 일치
```

---

## 🆕 신규 화면 추가 — 메타 등록 DO/DON'T (2026-05-19 PKG 폐기)

```sql
-- ❌ DON'T: PKG_NSCM_SCREEN_REGISTRATION 호출 (2026-05-19 폐기)
-- 사유: 스키마 불일치 + 4 영역만 지원 + 누락 영역 (i18n / Procedure 메타 / 권한 2 테이블) 다수
BEGIN
    SCM_MGR.PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN(
        p_user_id          => 'admin',
        p_menu_id          => 'DMF0099',
        ...
    );
END;
```

```sql
-- ✅ DO: 자기완결형 인라인 DML 7-BLOCK + 4-파일 SQL 세트
-- 파일: {prefix}_{MENU_ID}_Registration.sql + _DBeaver.sql + _DBeaver_Verify.sql + _DBeaver_Diagnose.sql
BEGIN
  -- BLOCK 1: SCM_ADM_MSG_M     (i18n × KO/EN/CN)
  -- BLOCK 2: SCM_ADM_MNU_M     (메뉴 마스터)
  -- BLOCK 3: SCM_ADM_PROC_M    (SP IN/OUT ★ 누락 시 빈 결과)
  -- BLOCK 4: SCM_ADM_API_M     (API 메타, API_MSG_ID NOT NULL)
  -- BLOCK 5: SCM_ADM_MNU_BTN_MPG_M (라우팅)
  -- BLOCK 6: SCM_MST_SHEET_COLUMNS (Grid 컬럼)
  -- BLOCK 7: SCM_ADM_USER_GR_MNU_MPG_M + ..._BTN_MPG_M (메뉴+버튼 권한 2 테이블)
  COMMIT;
END;
/
```
→ 상세: `08_SCREEN_REGISTRATION.md` §3 (8 step) + §7.1 (DBeaver 4-파일 룰)

```ts
// ✅ DO: procedures.d.ts에 화면 entry 추가
interface RawProcedureMap extends Base {
  DMF0099: {
    main: {
      request: { divisionId: string; yyyymm: string; };
      response: { o_rc: { DIVISION_ID: string; ITEM_ID: string; QTY: number; } };
    };
  };
}
```

```ts
// ❌ DON'T: 직접 any 타입 / 화면 호출
const { data } = useTabProcQuery({menuId, sheetName, ...});  // 타입 추론 안 됨
data.o_rc[0].DIVISION_ID  // 컴파일 에러 — procedures.d.ts에 정의 안 됨
```

→ 상세: `Doc/_dev_rules/08_SCREEN_REGISTRATION.md`

---

## ⭐ As-Is Validation / Expression → Wijmo Grid DO/DON'T

```ts
// ✅ DO: validation.md 행마다 Zod schema 또는 분기로 매핑
// AS-IS: DMF0099_SalesMonitor.cs:1234 — MessageHelper.GMessageBox("MSG0001")
const schema = z.object({ DIVISION_ID: z.string().min(1, 'msg.MSG0001') });

// ✅ DO: 사업부 분기는 switch 로 보존
// AS-IS: cs:440 — Division 40/81/82 분기
switch (division) {
  case '40': break;
  case '81': break;
  case '82': break;
}

// ✅ DO: expressions.md LockRange 는 cellEditEnding 으로
// AS-IS: cs:994 — siMain.LockRange(i, j, ..., false)
const onCellEditEnding = (s, e) => { if (!editable(row, col)) e.cancel = true; };

// ✅ DO: Cell.Formula 화면은 FlexSheet 사용
import { FlexSheet } from '@mescius/wijmo.react.grid.sheet';
sheet.setCellData(r, c, '=SUM(D2:D10)', false, true);

// ✅ DO: MSG#### → i18n
showAlert(t('msg.MSG0001'));

// ✅ DO: __asis-mapping__.md 매트릭스 작성
// (Validation 카운트 일치 + Expression 카운트 일치)
```

```ts
// ❌ DON'T: validation.md 행 누락 (1건이라도 PR reject)

// ❌ DON'T: 사업부 분기 통합 (간소화 금지)
if (division !== '40') { /* ... */ }   // 41/82 처리 누락 위험

// ❌ DON'T: LockRange 무시 — 사용자가 잠금된 셀 편집 가능해짐
const onCellEditEnding = (s, e) => {};  // 빈 핸들러

// ❌ DON'T: Cell.Formula 화면에 FlexGrid 사용
import { FlexGrid } from '@mescius/wijmo.react.grid';  // FlexSheet 필요

// ❌ DON'T: MSG#### 하드코딩
showAlert('필수 항목입니다');  // i18n 키 사용

// ❌ DON'T: AS-IS 원소스 라인 주석 생략
const onCellEditEnding = (s, e) => { /* 의미 모름 */ };

// ❌ DON'T: __asis-mapping__.md 미작성 — PR 자동 reject
```

→ 상세: `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md`

---

## 🎯 "한 사람이 개발한 것처럼" 체크리스트

다음 5가지가 동일해야 합니다:

1. **파일 구조**: 신규 화면 폴더 구성이 user-management와 동일
2. **import 순서**: foundation → shared → 같은 feature → 외부
3. **함수/메서드 정의 스타일**: arrow function + named export
4. **에러 처리**: useMessageStore.setAlert + BE에서 SystemException
5. **주석 헤더**: Javadoc 표준 헤더 (BE 모든 클래스)

만약 차이가 있다면 → 기존 user-management 패턴이 표준입니다.

---

> 이 카드는 IDE 탭에 띄워두고 작업 중 자주 확인하세요.
> 룰셋 전체 상세는 00_INDEX.md 부터 06_HOOKS.md까지 참조.
