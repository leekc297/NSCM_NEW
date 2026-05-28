# procedures.d.ts 자동 생성 가이드

> FE `configs/types/procedures.d.ts`를 `SCM_MST_SHEET_COLUMNS` + `SCM_ADM_API_M` 메타로부터 자동 생성하는 가이드.

## ⭐ 실제 코드 (2026-05-13 추가 — 즉시 적용 가능)

본 문서의 §2~§4 는 설계 스케치였고, 아래는 실제 사용 가능한 소스:

| # | 파일 | 위치 (To-Be) | 용도 |
|---|---|---|---|
| 03 | `03_PR_Get_Procedures_Metadata.sql` | `SCM_MGR.PKG_NSCM_UI_COMM` (ALTER) | DB SP — 메뉴×시트×버튼×PKG.SP×컬럼 메타 일괄 조회 |
| 04 | `04_gen-procedures.ts` | `nscm-fe/scripts/gen-procedures.ts` | FE 스크립트 — BE 호출 → procedures.d.ts 작성 |
| 05 | `05_DevToolsController_skeleton.java` | `nscm-be/.../admin/devtools/` | BE Controller |
| 06 | `06_DevToolsServiceImpl_skeleton.java` | `nscm-be/.../admin/devtools/` | BE Service + DTO + Mapper.xml |

**적용 순서**:
1. SQL 적용: `sqlplus SCM_MGR @03_PR_Get_Procedures_Metadata.sql` (PUBLIC SYNONYM + GRANT 포함)
2. BE 적용: 05/06 의 클래스를 `nscm-be/src/main/java/com/lgcns/nscm/admin/devtools/` 에 배치 + 05 의 `<select>` 두 개를 `sql/admin/DevTools.xml` 에 추가 → `./gradlew build`
3. FE 적용: 04 의 `gen-procedures.ts` 를 `nscm-fe/scripts/` 에 배치 + `package.json` 에 `"gen:procedures": "tsx scripts/gen-procedures.ts"` 추가 → `pnpm gen:procedures`
4. 자동화: `.gitlab-ci.yml` 에 §6 CI 통합 블록 추가

## 1. 동작 원리

```
[DB]
SCM_ADM_MENU_M      : 메뉴 목록
SCM_ADM_API_M       : 메뉴별 API (Sheet × Button × PKG.SP)
SCM_MST_SHEET_COLUMNS : Sheet별 컬럼 정의
   ↓
[BE API] GET /admin/dev/procedures-metadata
   ↓
[FE Script] pnpm gen:procedures
   ↓
[Output] nscm-fe/configs/types/procedures.d.ts
```

## 2. BE — 메타 조회 API 추가 (권장)

`com.lgcns.nscm.admin.devtools` 패키지에 추가:

### `DevToolsController.java`

```java
@Tag(name = "99. 개발 도구")
@RestController
@RequiredArgsConstructor
public class DevToolsController extends BaseController {

    private final DevToolsService devToolsService;

    @Operation(summary = "procedures.d.ts 메타 조회",
               description = "FE 자동 타입 생성용 화면별 컬럼/API 메타")
    @GetMapping("/admin/dev/procedures-metadata")
    public ResponseEntity<BaseResponse<List<ProcedureMetadata>>> retrieveProceduresMetadata()
            throws Exception {
        return successResponseEntity(devToolsService.retrieveProceduresMetadata());
    }
}
```

### `DevToolsServiceImpl.java`

```java
@Slf4j
@Service
@RequiredArgsConstructor
public class DevToolsServiceImpl extends BaseService implements DevToolsService {

    private final String nameSpace = "admin.devtools.";

    @Override
    public List<ProcedureMetadata> retrieveProceduresMetadata() throws Exception {
        Map<String, Object> result = selectList(nameSpace + "retrieveProceduresMetadata",
                                                 new HashMap<>());
        List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);
        return ProcedureMetadata.listOf(data);
    }
}
```

### `dto/ProcedureMetadata.java`

```java
@Getter
@Builder
@AllArgsConstructor
public class ProcedureMetadata {
    private String menuId;        // 'DMF0099'
    private String menuDesc;      // 'Sales Monitor'
    private String sheetName;     // 'main'
    private String buttonCode;    // 'SEARCH', 'SAVE'
    private String pkgName;       // 'PKG_DMF0099'
    private String procName;      // 'P_DMF0099_GET_MAIN_DATA'
    private List<ColumnMeta> columns;  // SP의 OUT 컬럼들

    @Getter @Builder @AllArgsConstructor
    public static class ColumnMeta {
        private String columnName;    // 'DIVISION_ID'
        private String dataType;      // 'string' / 'number' / 'date'
        private String columnLabel;   // 'Division'
    }
}
```

### `sql/admin/DevTools.xml`

```xml
<mapper namespace="com.lgcns.nscm.admin.devtools">

    <resultMap id="devToolsResultMap" type="java.util.HashMap" />

    <select id="retrieveProceduresMetadata" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA(
            #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet,
              resultMap=devToolsResultMap}
        ) }
    </select>

</mapper>
```

### DB — `PR_GET_PROCEDURES_METADATA`

```sql
-- PKG_NSCM_UI_COMM에 추가
PROCEDURE PR_GET_PROCEDURES_METADATA (
    o_rc OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN o_rc FOR
        SELECT
            M.MNU_ID                  AS MENU_ID,
            M.MNU_DESC                AS MENU_DESC,
            A.SHT_NM                  AS SHEET_NAME,
            A.MNU_BTN_CD              AS BUTTON_CODE,
            A.PKG_NM                  AS PKG_NAME,
            A.PROC_NM                 AS PROC_NAME,
            -- 컬럼은 JSON_ARRAYAGG로 1행에 집계
            (SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'columnName'  VALUE C.COLUMN_NAME,
                    'columnLabel' VALUE C.COLUMN_LABEL_NAME,
                    'dataType'    VALUE
                        CASE C.CELL_CONTROL_OBJECT_TYPE_CODE
                            WHEN 'FPNumber' THEN 'number'
                            WHEN 'FPDate'   THEN 'string'  -- ISO date
                            ELSE 'string'
                        END,
                    'sortOrder'   VALUE C.SORT_ORDER_NO
                ) ORDER BY C.SORT_ORDER_NO
                RETURNING CLOB)
             FROM SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID = M.MNU_ID
               AND C.SHEET_NAME = A.SHT_NM
               AND C.VALID_YN = 'Y'
            )                         AS COLUMNS_JSON
        FROM SCM_ADM_MENU_M M
        JOIN SCM_ADM_API_M  A ON A.MNU_ID = M.MNU_ID
        WHERE M.USE_YN = 'Y'
          AND A.USE_YN = 'Y'
        ORDER BY M.MNU_ID, A.SHT_NM, A.MNU_BTN_CD;
END;
```

## 3. FE — 자동 생성 스크립트

`nscm-fe/scripts/gen-procedures.mjs` 신규 작성:

```js
import path from 'node:path';
import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
import { createJiti } from 'jiti';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const jiti = createJiti(import.meta.url);

const foundationAxiosPath = path.resolve(__dirname, '../packages/foundation/src/apis/axios.ts');
const { apiClient } = jiti(foundationAxiosPath);

const OUTPUT = path.resolve(__dirname, '../configs/types/procedures.d.ts');

async function run() {
  console.log('🚀 procedures.d.ts 자동 생성 시작...');

  let metadata;
  try {
    const response = await apiClient.get('/admin/dev/procedures-metadata');
    metadata = response.data.result;
    console.log(`✅ ${metadata.length} 메뉴×시트×버튼 메타 수신`);
  } catch (e) {
    console.error('❌ 메타 조회 실패:', e.message);
    process.exit(1);
  }

  // menuId → sheetName → request/response 구조
  const byMenu = {};
  for (const row of metadata) {
    const { menuId, menuDesc, sheetName, buttonCode, columns } = row;
    if (!byMenu[menuId]) {
      byMenu[menuId] = { desc: menuDesc, sheets: {} };
    }
    if (!byMenu[menuId].sheets[sheetName]) {
      byMenu[menuId].sheets[sheetName] = { request: {}, response: { o_rc: {} } };
    }
    // 검색 버튼의 입력 파라미터 정도는 다른 메타에서 가져와야 함
    // 여기는 응답 컬럼만 우선 처리
    if (buttonCode === 'SEARCH' && columns) {
      const cols = typeof columns === 'string' ? JSON.parse(columns) : columns;
      for (const c of cols) {
        byMenu[menuId].sheets[sheetName].response.o_rc[c.columnName] = c.dataType;
      }
    }
  }

  // procedures.d.ts 생성
  let out = `export {};

// 자동 생성된 파일입니다. \`pnpm gen:procedures\`로 재생성하세요.
// DO NOT EDIT MANUALLY.

type Unpacked<T> = T extends (infer U)[] ? U : T;

interface Base {
  [key: string]: {
    [key: string]: {
      request: Record<string, JsonPrimitive>;
      response: Record<string, WijmoRowItem>;
    };
  };
}

interface RawProcedureMap extends Base {
`;

  for (const [menuId, { desc, sheets }] of Object.entries(byMenu)) {
    out += `\n  /**\n   * ${desc}\n   */\n`;
    out += `  ${menuId}: {\n`;
    for (const [sheetName, { request, response }] of Object.entries(sheets)) {
      out += `    ${sheetName}: {\n`;
      out += `      request: {\n`;
      // request는 별도 메타가 있으면 채워넣음. 없으면 빈 객체
      for (const [k, v] of Object.entries(request)) {
        out += `        ${k}: ${v};\n`;
      }
      out += `      };\n`;
      out += `      response: {\n`;
      out += `        o_rc: {\n`;
      for (const [col, type] of Object.entries(response.o_rc)) {
        out += `          ${col}: ${type};\n`;
      }
      out += `          [key: string]: string | number;\n`;
      out += `        };\n`;
      out += `      };\n`;
      out += `    };\n`;
    }
    out += `  };\n`;
  }

  out += `}\n`;

  fs.writeFileSync(OUTPUT, out, 'utf-8');
  console.log(`✅ ${OUTPUT} 생성 완료 — ${Object.keys(byMenu).length} 메뉴`);
}

run();
```

## 4. `package.json` scripts 추가

```json
{
  "scripts": {
    "gen:procedures": "node scripts/gen-procedures.mjs",
    "gen": "pnpm gen:icons && pnpm gen:i18n && pnpm gen:procedures"
  }
}
```

## 5. 사용 흐름

```
신규 화면 등록
   ↓
1. PKG/SP 생성 (Oracle 컴파일)
   ↓
2. PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN(...) 호출
   → 4 Table에 메타 등록
   ↓
3. pnpm gen:procedures
   → BE API 호출 → 메타 조회 → procedures.d.ts 자동 갱신
   ↓
4. FE 화면 파일 작성 (타입 자동 인식)
   ↓
5. 라우팅 등록 → 동작 검증
```

## 6. CI 통합

`.gitlab-ci.yml`에 추가 (PR 시 procedures.d.ts 최신화 검증):

```yaml
fe:check-procedures:
  stage: lint
  script:
    - pnpm gen:procedures
    - git diff --exit-code configs/types/procedures.d.ts || (echo "procedures.d.ts is outdated. Run 'pnpm gen:procedures'." && exit 1)
```

---

> 이 자동화로 SP 컬럼 변경 → FE 타입 갱신 → 사용처 type-check 가 1회 명령으로 동기화됩니다.
