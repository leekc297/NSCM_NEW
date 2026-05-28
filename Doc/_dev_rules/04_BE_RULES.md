# 04. Backend 상세 룰 (Spring Boot 3.5 + Java 21 + MyBatis)

> 실제 nscm-be 코드(`com.lgcns.nscm.admin.menu`, `admin.user`)를 기준으로 한 표준 패턴.

## 1. 프로젝트 구조

```
nscm-be/
├── build.gradle
├── settings.gradle
├── scripts/
│   └── pre-commit                  # git hook (Spotless 자동)
├── lib/
│   └── sapjco3.jar                 # SAP RFC 라이브러리
└── src/
    ├── main/
    │   ├── java/com/lgcns/nscm/
    │   │   ├── NscmApplication.java          # @SpringBootApplication
    │   │   │
    │   │   ├── admin/                        # 시스템 관리 (Common 도메인)
    │   │   │   ├── auth/        (AuthService, AuthServiceImpl, dto/)
    │   │   │   ├── log/
    │   │   │   ├── lookup/
    │   │   │   ├── menu/        (MenuController, MenuService, MenuServiceImpl, dto/)
    │   │   │   ├── message/
    │   │   │   ├── test/
    │   │   │   ├── user/
    │   │   │   └── webservice/
    │   │   │
    │   │   ├── demand/                       # DM 도메인 (DMF*)
    │   │   ├── master/                       # SCM Master 도메인
    │   │   ├── factory/                      # FP 도메인
    │   │   ├── supply/                       # SCP 도메인
    │   │   ├── shipping/                     # SSP 도메인
    │   │   ├── general/                      # 도메인 공통 (DataPopup 등)
    │   │   │
    │   │   └── framework/                    # 프레임워크 코드
    │   │       ├── annotation/      (@LoginUser, @SystemLog)
    │   │       ├── aspect/          (SystemLogAspect)
    │   │       ├── base/            (BaseController, BaseService, BaseConstants, BaseEnum)
    │   │       ├── config/          (Security, Swagger, DataSource)
    │   │       ├── dao/             (BaseDao - MyBatis 호출 래퍼)
    │   │       ├── exception/       (SystemException, GlobalExceptionHandler)
    │   │       ├── handler/         (Authentication, JsonLoginFilter)
    │   │       ├── interceptor/     (LoggingInterceptor)
    │   │       ├── model/           (BaseResponse)
    │   │       ├── property/        (AppProperties)
    │   │       ├── provider/        (JasyptStringEncryptor)
    │   │       ├── resolver/        (LoginUserResolver)
    │   │       ├── security/        (CustomUserDetails, JwtFilter 등)
    │   │       ├── utils/           (StringUtils, WebClientUtils)
    │   │       └── webservice/      (WSDL 클라이언트)
    │   │
    │   └── resources/
    │       ├── application.yml
    │       ├── application-local.yml / -dev.yml / -prod.yml
    │       ├── logback-spring.xml
    │       ├── mybatis/
    │       │   └── mybatis-config.xml
    │       └── sql/
    │           ├── admin/        (User.xml, Menu.xml, Auth.xml, ...)
    │           ├── demand/
    │           ├── master/
    │           ├── factory/
    │           ├── supply/
    │           └── shipping/
    │
    └── test/
        └── java/com/lgcns/nscm/
            └── ... (각 패키지별 *Test.java)
```

## 2. 패키지 명명 (필수)

```
com.lgcns.nscm.{도메인}.{기능}

✅ com.lgcns.nscm.admin.user
✅ com.lgcns.nscm.admin.menu
✅ com.lgcns.nscm.demand.dmf0021
✅ com.lgcns.nscm.framework.base
❌ com.lgcns.nscm.controllers   (계층 기반 X)
❌ com.lgcns.NSCM.user           (대문자 X)
```

## 3. 클래스 표준 패턴

### 3.1 Controller

**필수 어노테이션**:
- `@Slf4j` (선택, 로깅 사용 시)
- `@Tag(name = "...")` — Swagger 그룹
- `@RestController`
- `@RequiredArgsConstructor` — final 필드 자동 주입

**필수 상속**: `extends BaseController` (successResponseEntity 헬퍼 제공)

```java
package com.lgcns.nscm.admin.menu;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.lgcns.nscm.admin.user.UserSession;
import com.lgcns.nscm.framework.annotation.LoginUser;
import com.lgcns.nscm.framework.base.BaseController;
import com.lgcns.nscm.framework.model.BaseResponse;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Tag(name = "2. 메뉴 기능")
@RestController
@RequiredArgsConstructor
public class MenuController extends BaseController {

    private final MenuService menuService;
    private final AuthService authService;

    @Operation(summary = "메뉴 목록 조회", description = "사용자가 권한이 있는 메뉴 목록을 조회합니다.")
    @GetMapping(value = "/admin/menu", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<MenuDto>>> retrieveMenus(@LoginUser UserSession userSession) throws Exception {
        return successResponseEntity(menuService.retrieveMenus(userSession.getUserId()));
    }
}
```

**규칙**:
- ✅ HTTP 메서드 명시 (`@GetMapping`, `@PostMapping`, ...)
- ✅ `@Operation` summary + description 작성 (Swagger 문서화)
- ✅ `@LoginUser UserSession` 로 인증된 사용자 정보 수신
- ✅ `@PathVariable`, `@RequestBody`, `@RequestParam` 명시
- ✅ `throws Exception` 또는 `throws SQLException` (GlobalExceptionHandler가 처리)
- ✅ 반환은 `ResponseEntity<BaseResponse<T>>` + `successResponseEntity(result)`
- ❌ `@RequestMapping` (메서드 명시 안 됨)
- ❌ Controller에서 Service 외 호출 (Repository, MyBatis 직접 호출 금지)

### 3.2 Service (Interface)

**파일명**: `{Feature}Service.java`

```java
package com.lgcns.nscm.admin.menu;

import java.util.List;
import com.lgcns.nscm.admin.menu.dto.*;

public interface MenuService {
    List<MenuDto> retrieveMenus(String userId) throws Exception;
    List<GridColumn> retrieveGridColumns(String userId, String mnuId, String sheetNm, String divisionId) throws Exception;
    void addFavorite(String userId, String mnuId) throws Exception;
    void removeFavorite(String userId, String mnuId) throws Exception;
}
```

**규칙**:
- ✅ 인터페이스로 분리 (테스트/Mock 가능)
- ✅ Primitive/String/DTO 파라미터 명확히
- ✅ `throws Exception` 명시
- ❌ 인터페이스 없이 단일 ServiceImpl 직접 사용

### 3.3 ServiceImpl

**파일명**: `{Feature}ServiceImpl.java`

```java
package com.lgcns.nscm.admin.menu;

import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DATA_RESULT;

import java.util.*;
import org.springframework.stereotype.Service;

import com.lgcns.nscm.admin.menu.dto.*;
import com.lgcns.nscm.framework.base.BaseService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MenuServiceImpl extends BaseService implements MenuService {

    private final String nameSpace = "admin.menu.";

    @Override
    public List<MenuDto> retrieveMenus(String userId) throws Exception {

        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);

        Map<String, Object> result = selectList(nameSpace + "retrieveMenus", params);
        List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);

        return MenuDto.treeOf(MenuDto.listOf(data));
    }
}
```

**필수 패턴**:
- ✅ `extends BaseService implements {Feature}Service`
- ✅ `@Service`, `@RequiredArgsConstructor`, `@Slf4j`
- ✅ `private final String nameSpace = "{도메인}.{기능}.";` — MyBatis SQL ID 접두사
- ✅ `selectList(nameSpace + "메서드명", params)` — BaseService 메서드 호출
- ✅ `(List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT)` 캐스팅
- ✅ DTO 정적 메서드 `MenuDto.of(map)`, `MenuDto.listOf(maps)`, `MenuDto.treeOf(list)` 활용
- ❌ `@Autowired` 필드 주입
- ❌ 하드코딩된 SQL ID (`"admin.menu.retrieveMenus"`)
- ❌ Service에서 Map 그대로 Controller 반환 (DTO 변환 필수)

### 3.4 DTO

**디렉토리**: `dto/` 서브패키지

**Request DTO**:
```java
package com.lgcns.nscm.admin.user.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.validation.constraints.NotBlank;

@Getter
@Setter
@NoArgsConstructor
public class LoginRequest {
    @NotBlank(message = "아이디는 필수입니다.")
    private String userId;

    @NotBlank(message = "비밀번호는 필수입니다.")
    private String password;
}
```

**Response DTO**:
```java
package com.lgcns.nscm.admin.menu.dto;

import java.math.BigDecimal;
import java.util.*;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Builder
@AllArgsConstructor
public class MenuDto {
    private String mnuId;
    private String upprMnuId;
    private String mnuUrl;
    private String mnuMsgId;
    private BigDecimal sortOrd;

    @Setter
    private boolean favorite;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    @Builder.Default
    private List<MenuDto> children = new ArrayList<>();

    public static MenuDto of(Map<String, Object> data) {
        return MenuDto.builder()
            .mnuId((String) data.get("MNU_ID"))
            .upprMnuId((String) data.get("UPPR_MNU_ID"))
            .mnuUrl((String) data.get("MNU_URL"))
            .mnuMsgId((String) data.get("MNU_MSG_ID"))
            .sortOrd((BigDecimal) data.get("SORT_ORD"))
            .favorite("Y".equals(data.get("BMK_YN")))
            .build();
    }

    public static List<MenuDto> listOf(List<Map<String, Object>> datas) {
        List<MenuDto> result = new ArrayList<>();
        for (Map<String, Object> d : datas) result.add(of(d));
        return result;
    }
}
```

**규칙**:
- ✅ `@Getter @Builder @AllArgsConstructor`
- ✅ `public static of(Map<String, Object>)` 정적 팩토리
- ✅ `public static listOf(List<Map<String, Object>>)` 일괄 변환
- ✅ DB 컬럼명(`MNU_ID`)을 Java camelCase(`mnuId`)로 매핑
- ✅ `@JsonInclude(NON_EMPTY)` 빈 컬렉션 응답 제외
- ❌ public 필드 (모두 private + Getter)
- ❌ Setter 무차별 노출 (필요한 것만 `@Setter` 메서드 레벨)

## 4. MyBatis XML

**파일 위치**: `src/main/resources/sql/{도메인}/{Feature}.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "../../mybatis/mybatis-3-mapper.dtd">
<mapper namespace="com.lgcns.nscm.admin.menu">

    <resultMap id="menuResultMap" type="java.util.HashMap" />

    <select id="retrieveMenus" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_GET_MENU_LIST(
            #{userId},
            #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet, resultMap=menuResultMap}
        ) }
    </select>

    <select id="retrieveGridColumns" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST(
            #{userId},
            #{mnuId},
            #{sheetNm},
            #{divisionId},
            #{DATARESULT, mode=OUT, jdbcType=CURSOR, javaType=java.sql.ResultSet, resultMap=menuResultMap}
        ) }
    </select>

    <select id="addFavorite" statementType="CALLABLE">
        { CALL SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_ADD_USER_BMK(
            #{userId},
            #{mnuId}
        ) }
    </select>

</mapper>
```

**규칙**:
- ✅ `namespace="com.lgcns.nscm.{도메인}.{기능}"` — 패키지와 일치
- ✅ `statementType="CALLABLE"` — 모든 호출은 PKG_*.P_* Procedure 호출
- ✅ `{ CALL PKG_XXX.PR_YYY(...) }` 표준 형식
- ✅ OUT 파라미터는 `#{DATARESULT, mode=OUT, jdbcType=CURSOR, ...}` — BaseService가 자동 처리
- ✅ `resultMap="xxxResultMap"` HashMap 매핑 (Service에서 DTO 변환)
- ✅ 인자는 `#{paramName}` 바인딩 — `${}` 사용 금지 (SQL Injection)
- ❌ Owner 명 prefix `SCM_MGR.PKG_*` (가능한 Synonym 통해 호출, 단 일부는 PKG가 SCM_MGR에 있으므로 명시 가능)
- ❌ MyBatis dynamic SQL `<if>/<foreach>` 남용 — 가능한 PL/SQL 패키지 내부 처리

## 5. 응답 표준 (BaseResponse)

```java
// 성공 (데이터 있음)
return successResponseEntity(menuList);
// → { "code": "0", "message": "success", "result": [...] }

// 성공 (데이터 없음)
return successResponseEntity();
// → { "code": "0", "message": "success", "result": null }

// 성공 + 커스텀 code/message
return successResponseEntity(data, "00", "조회 완료");

// 실패는 throw — GlobalExceptionHandler가 자동 BaseResponse 변환
throw new SystemException("ERR_001", "권한이 없습니다.");
```

**금지**:
- ❌ `ResponseEntity.ok(data)` 직접 반환 (BaseResponse 래핑 안 됨)
- ❌ `Map<String, Object>` 직접 반환

## 6. 예외 처리

### 6.1 표준 예외

```java
// com.lgcns.nscm.framework.exception.SystemException
throw new SystemException("ERR_USER_NOT_FOUND", "사용자를 찾을 수 없습니다.");

// Spring Security
throw new AccessDeniedException("권한 없음");
```

`GlobalExceptionHandler` (`framework.exception`)가 자동으로 BaseResponse로 변환.

### 6.2 ServiceImpl에서

```java
@Override
public User retrieveUser(String userId) throws Exception {
    Map<String, Object> result = selectList(nameSpace + "retrieveUser", params);
    List<Map<String, Object>> data = (List<Map<String, Object>>) result.get(DEFAULT_DATA_RESULT);

    if (data.isEmpty()) {
        throw new SystemException("ERR_USER_NOT_FOUND", "사용자 [" + userId + "]를 찾을 수 없습니다.");
    }
    return User.of(data.get(0));
}
```

## 7. 인증/인가

### 7.1 인증 사용자 정보 수신

```java
@GetMapping("/admin/menu")
public ResponseEntity<...> retrieveMenus(@LoginUser UserSession userSession) {
    String userId = userSession.getUserId();
    String langCd = userSession.getLangCd();
    // ...
}
```

`@LoginUser`는 `LoginUserResolver`가 `SecurityContextHolder`에서 추출.

### 7.2 메뉴 권한 체크

```java
@GetMapping("/admin/menu/{mnuId}/access")
public ResponseEntity<BaseResponse<Void>> checkMenuAuth(
    @LoginUser UserSession userSession,
    @PathVariable String mnuId
) {
    boolean hasMenuAuth = authService.checkMenuAuth(userSession.getUserId(), mnuId);
    if (!hasMenuAuth) throw new AccessDeniedException("메뉴 접근 권한 없음");
    return successResponseEntity();
}
```

## 8. 트랜잭션

```java
import org.springframework.transaction.annotation.Transactional;

@Transactional(rollbackFor = Exception.class)
@Override
public void saveBatch(List<Item> items) throws Exception {
    // 모든 호출이 한 트랜잭션, 예외 시 전체 롤백
}
```

**기본**:
- 읽기 전용: `@Transactional(readOnly = true)` (성능 최적화)
- 쓰기: `@Transactional(rollbackFor = Exception.class)`

## 9. 로깅

```java
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserServiceImpl {

    public void updateLangCd(String userId, String langCd) {
        log.info("Update langCd: userId={}, langCd={}", userId, langCd);

        try {
            // ...
        } catch (Exception e) {
            log.error("Failed to update langCd", e);
            throw e;
        }
    }
}
```

**규칙**:
- ✅ `@Slf4j` Lombok 어노테이션
- ✅ Parameterized 메시지 `log.info("user={}", userId)` (성능 + 보안)
- ❌ String concat `log.info("user=" + userId)`
- ❌ `System.out.println`

## 10. Swagger / OpenAPI

```java
@Tag(name = "2. 메뉴 기능")           // 그룹
@RestController
public class MenuController {

    @Operation(
        summary = "메뉴 목록 조회",
        description = "사용자가 권한이 있는 메뉴 목록을 조회합니다."
    )
    @GetMapping("/admin/menu")
    public ResponseEntity<BaseResponse<List<MenuDto>>> retrieveMenus(...) { ... }
}
```

접속: `http://localhost:8080/swagger-ui.html`

## 11. 빌드 / 실행

### 11.1 로컬 실행

```bash
./gradlew bootRun
# 또는
./gradlew clean build
java -jar build/libs/nscm.war
```

### 11.2 Spotless (포맷팅)

```bash
./gradlew spotlessCheck    # 검사만
./gradlew spotlessApply    # 자동 수정
```

설정 (`build.gradle`):
- importOrder: `java, javax, org, com, ''`
- trimTrailingWhitespace, endWithNewline
- lineEndings UNIX

### 11.3 Git Hook 설치

```bash
./gradlew installGitHooks
# .git/hooks/pre-commit에 scripts/pre-commit 복사
```

## 12. 환경 분리 (Profile)

```
application.yml          # 공통
application-local.yml    # 로컬 (Oracle 개발 DB)
application-dev.yml      # 개발 서버
application-prod.yml     # 운영
```

실행:
```bash
./gradlew bootRun -Pprofile=local
```

암호화: Jasypt 사용 (`jasypt-spring-boot-starter`).

## 13. 표준 클래스 헤더 주석

```java
/**
 * {한 줄 설명}
 *
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.demand.dmf0099
 * @FileName : Dmf0099ServiceImpl.java
 * @author   : {nickname or ID}
 * @date     : 2026. 5. 13.
 * @description : DMF0099 화면 비즈니스 로직 구현
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 5. 13.       {nickname}      최초 작성
 */
```

→ Javadoc 커스텀 태그가 `build.gradle`에 설정됨 (`@Project @Package @FileName @date @description`).

## 14. 테스트

```java
@SpringBootTest
class MenuServiceImplTest {

    @Autowired
    private MenuService menuService;

    @Test
    void retrieveMenus_returnsList() throws Exception {
        List<MenuDto> menus = menuService.retrieveMenus("testUser");
        assertThat(menus).isNotEmpty();
    }
}
```

명령: `./gradlew test`

## 15. ⭐ 개발 도구 패키지 — `admin.devtools` (2026-05-13 추가)

### 15.1 용도

FE `pnpm gen:procedures` 가 호출하는 메타데이터 조회 API. SCM_ADM_MENU_M + SCM_ADM_MNU_BTN_MPG_M + SCM_ADM_API_M + SCM_ADM_PROC_M 4 테이블을 조인하여 메뉴×시트×버튼×PKG.SP×컬럼 메타를 일괄 반환.

### 15.2 파일 구성

```
com/lgcns/nscm/admin/devtools/
├── DevToolsController.java       # GET /admin/dev/procedures-metadata
├── DevToolsService.java          # interface
├── DevToolsServiceImpl.java      # extends BaseService
└── dto/
    └── ProcedureMetadata.java    # menuId/menuDesc/sheetName/mnuBtnCd/procName/colName/dataTpCd/colTpCd/sortOrd

sql/admin/DevTools.xml            # namespace=com.lgcns.nscm.admin.devtools
```

### 15.3 DB 호출

- `SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURES_METADATA(O_CURSOR)` — 전체
- `SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROCEDURE_METADATA_BY_MENU(P_MNU_ID, O_CURSOR)` — 메뉴별

스켈레톤 코드: `To-be_v2_converted/08_Screen_Registration/05_*` ~ `06_*`

### 15.4 신규 PKG.SP 추가 시 의무 (BE 개발자)

신규 화면 PKG/SP 추가 시 반드시 `SCM_ADM_PROC_M` 에 컬럼 메타 등록:

```sql
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD)
VALUES ('PKG_DMF0099.P_DMF0099_GET_MAIN_DATA', 'DIVISION_ID', 'STRING', 'IN', 1);
-- ... OUT 컬럼들도 등록
```

자기완결형 인라인 DML 패턴 — 7-BLOCK 의 BLOCK 3 (`SCM_ADM_PROC_M`) 으로 등록. ❌ `PKG_NSCM_SCREEN_REGISTRATION.P_REGISTER_SCREEN` 호출 금지 (2026-05-19 폐기). 상세: `08_SCREEN_REGISTRATION.md` §3 + §7.1.

### 15.5 FE 동기화 의무

신규 PKG/SP + SCM_ADM_PROC_M 등록 후 **반드시 FE 측에서 동기화**:

```bash
cd C:/Projects/NSCM/nscm-fe && pnpm gen:procedures
git add configs/types/procedures.d.ts
git commit -m "feat(dmf0099): procedures.d.ts 동기화 (PKG_DMF0099 추가)"
```

→ 미동기화 시 PR pre-push Hook 에서 차단 (`06_HOOKS.md` §4.6).

---

> 본 룰은 실제 `com.lgcns.nscm.admin.menu` 패키지를 기준으로 작성됐습니다.
> 신규 도메인 추가 시 이 패턴을 정확히 따라야 합니다.
