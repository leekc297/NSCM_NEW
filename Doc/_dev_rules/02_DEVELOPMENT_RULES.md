# 02. 공통 개발 규약 (브랜치 / 커밋 / PR / 리뷰)

## 1. 브랜치 전략

### 1.1 보호 브랜치

- `main` — 운영 배포 (직접 push 금지, PR만)
- `dev` — 개발 통합 (직접 push 금지, PR만)

### 1.2 작업 브랜치 명명 규칙

```
{type}/{kebab-case-summary}
```

**허용 type** (husky pre-push 검증):
- `feat/` — 신규 기능
- `fix/` — 버그 수정
- `docs/` — 문서
- `style/` — 코드 스타일 (lint, format)
- `refactor/` — 리팩토링 (기능 변화 없음)
- `test/` — 테스트 추가/수정
- `chore/` — 빌드, 설정, 의존성

**예시**:
- ✅ `feat/dmf0099-sales-monitor`
- ✅ `fix/grid-pagination-bug`
- ✅ `refactor/extract-base-service`
- ❌ `feature-add-screen` (kebab 아님, 허용 type 아님)
- ❌ `feat/DMF0099_Screen` (대문자/언더스코어)

### 1.3 검증 (husky pre-push)

`.husky/pre-push`가 자동으로 검증:
```bash
valid_branch_regex="^dev$|^(feat|fix|docs|style|refactor|test|chore)\/[a-z0-9-]+$"
```

## 2. 커밋 메시지 (Conventional Commits)

### 2.1 형식

```
{type}({scope}): {subject}

{body (옵션)}

{footer (옵션, BREAKING CHANGE / Refs)}
```

### 2.2 type

| type | 용도 |
|---|---|
| `feat` | 신규 기능 |
| `fix` | 버그 수정 |
| `docs` | 문서 |
| `style` | 포맷팅 |
| `refactor` | 리팩토링 |
| `perf` | 성능 |
| `test` | 테스트 |
| `chore` | 빌드/설정 |
| `revert` | 되돌리기 |

### 2.3 scope

도메인/모듈 이름:
- `admin`, `demand`, `master`, `factory`, `supply`, `shipping`
- `dmf0021`, `scm0006` 등 화면 ID (소문자)
- `foundation`, `shared`, `web` (FE)
- `framework`, `mybatis` (BE)
- `db-migration`, `screen-registration` (메타/마이그레이션)
- `dev-rules`, `hooks` (룰셋)

### 2.4 예시

```
feat(demand): DMF0099 sales monitor 화면 추가

- Wijmo FlexGrid 기반 메인 그리드
- Zustand store: useDmf0099SomeScreenStore
- BE: PKG_DMF0099.P_DMF0099_GET_MAIN_DATA 호출

Refs: PJ2026-12345
```

```
fix(admin): 사용자 목록 조회 시 SSO 정보 누락 수정
```

## 3. PR (Pull Request) 규약

### 3.1 PR 제목

커밋 메시지와 동일 형식.

### 3.2 PR 본문 템플릿

```markdown
## 작업 내용
- 

## 변경 이유
- 

## 영향 범위
- [ ] FE
- [ ] BE
- [ ] DB
- [ ] 운영 환경 영향 없음

## 테스트
- [ ] 단위 테스트 추가
- [ ] 수동 시나리오 테스트 완료
- [ ] 데이터 검증 (Oracle ↔ 화면)

## 체크리스트
- [ ] `pnpm lint` / `./gradlew spotlessApply` 통과
- [ ] `pnpm type-check` 통과
- [ ] 기존 화면 패턴(예: user-management) 참조
- [ ] 네이밍 규약 준수
- [ ] CLAUDE.md 의 "절대 금지" 위반 없음

## 스크린샷 / 결과
(있으면 첨부)
```

### 3.3 PR 머지 조건

- ✅ CI 통과 (lint + build + test)
- ✅ 최소 1명 이상 리뷰 승인
- ✅ 충돌 해결
- ✅ 변경된 파일이 100개를 넘으면 → 작은 단위로 분리 권장

## 4. 코드 리뷰 기준

### 4.1 우선순위 (높은 순)

1. **기능 정확성**: 요구사항을 충족하는가?
2. **데이터 정합성**: AS-IS와 결과 동일한가? (특히 DM/SCM 영역)
3. **레이어 위반**: Foundation→Shared→App 방향 지켰는가?
4. **네이밍 규약**: PascalCase / camelCase / kebab-case 정확한가?
5. **테스트 커버리지**: 핵심 비즈니스 로직에 테스트 있는가?
6. **성능**: N+1, 불필요 렌더링, Wijmo Grid 옵션 적정한가?
7. **코드 일관성**: 기존 화면 패턴과 같은가? ("한 사람이 짠 것처럼")

### 4.2 리뷰 코멘트 권장 표현

```
🚨 Critical: (반드시 수정 필요)
⚠️  Warning: (개선 권장)
💡 Suggestion: (취향, 선택사항)
❓ Question: (이해 안 됨, 설명 요청)
👍 Praise: (잘했다, 학습 가치)
```

## 5. 개발 환경 셋업

### 5.1 Frontend

```bash
# Node.js 20.14.0+ , pnpm 10.0.0+
node -v
npm install -g pnpm

# 클론 후
cd nscm-fe
pnpm install            # 의존성 설치 (husky 자동 설정됨)
pnpm gen                # i18n + 아이콘 생성
pnpm local              # 로컬 개발 서버

# 빌드 / 검증
pnpm build
pnpm lint:fix
pnpm type-check
pnpm test
```

### 5.2 Backend

```bash
# Java 21
java -version

cd nscm-be
./gradlew installGitHooks    # Git Hook 설치
./gradlew bootRun            # 로컬 실행 (포트 8080)

# 빌드 / 검증
./gradlew build
./gradlew spotlessApply      # 코드 포맷팅
./gradlew test
```

### 5.3 DB (Oracle 19c)

```yaml
# application.yml (개발)
spring:
  datasource:
    url: jdbc:oracle:thin:@10.34.220.81:2521:ESSCMD
    username: SCMD_APP
    password: ********
```

→ 권한: `SCMD_APP`는 `RL_SCM_DML` Role 보유. SCM_MGR 객체에 Synonym 접근.

## 6. 의존성 관리

### 6.1 FE 추가/업데이트

```bash
# Application 레벨 (apps/web)
pnpm --filter @web add some-package

# Shared 레벨 (packages/shared)
pnpm --filter @shared add some-package

# Foundation 레벨 (packages/foundation)
pnpm --filter @foundation add some-package
```

**금지**:
- ❌ 동일 패키지 여러 버전 (workspace에서 호이스트 가능)
- ❌ Foundation에 React 추가 (Foundation은 framework agnostic)

### 6.2 BE 추가

`build.gradle`의 `dependencies` 블록에 추가. SLF4J / commons-logging 충돌 주의 (이미 제외 설정됨).

## 7. 로깅 정책

### Frontend

```ts
// ❌ 금지
console.log('data', data);

// ✅ 개발 디버깅용 (운영 빌드에서 자동 제거)
import { logger } from '@foundation/utils';
logger.debug('data', data);
```

### Backend

```java
// ❌ 금지
System.out.println("user: " + userId);

// ✅ Slf4j
@Slf4j
public class UserService {
    public void doSomething(String userId) {
        log.info("user: {}", userId);
        log.debug("detail: {}", detail);
        log.error("failed", exception);
    }
}
```

### 로그 레벨 가이드

| Level | 용도 |
|---|---|
| ERROR | 시스템 오류, 사용자 영향 |
| WARN | 회복 가능한 이상 |
| INFO | 비즈니스 이벤트 (저장/조회 성공) |
| DEBUG | 개발 디버깅 (운영에서 OFF) |
| TRACE | 상세 추적 (성능 분석) |

## 8. 보안 정책

### 8.1 절대 금지

- ❌ 패스워드/토큰 코드에 하드코딩
- ❌ `application.yml`에 평문 패스워드 (Jasypt 암호화 사용)
- ❌ SQL Injection (PreparedStatement / MyBatis 바인딩만)
- ❌ XSS — 사용자 입력 그대로 innerHTML 삽입
- ❌ 권한 체크 클라이언트만 (BE에서도 반드시 검증)

### 8.2 권장

- ✅ Spring Security 기반 인증/인가
- ✅ MyBatis `#{param}` 바인딩 (`${param}` 사용 시 검토 필수)
- ✅ React JSX 자동 escaping 신뢰 (`dangerouslySetInnerHTML` 금지)
- ✅ HTTPS 강제
- ✅ CSRF 토큰 (Spring Security 설정)

## 9. 성능 가이드

### 9.1 FE 성능

| 항목 | 권장 |
|---|---|
| 리스트 렌더링 | Wijmo Grid (가상화 내장), 최후 수단으로 React-window |
| 메모이제이션 | `useMemo`/`useCallback`은 명확한 이유 있을 때만 |
| 컴포넌트 분리 | 메인 컴포넌트는 데이터/조합만, UI는 components/ 하위 |
| Zustand 셀렉터 | **개별 셀렉터 사용** (`useStore(s => s.foo)`), 통째로 X |
| API 캐싱 | `useTabProcQuery` (TanStack Query 기반) |

### 9.2 BE 성능

| 항목 | 권장 |
|---|---|
| 대량 조회 | Oracle Cursor (`DATARESULT` OUT) + 페이징 |
| Bulk INSERT | `BULK COLLECT` + `FORALL` (PL/SQL) |
| 트랜잭션 | `@Transactional` 명시, propagation 신중 |
| 캐싱 | Spring Cache (자주 변하지 않는 마스터) |
| N+1 | MyBatis collection/association 또는 별도 쿼리 |

## 10. 문서화

### 10.1 코드 주석

**Backend**:

```java
/**
 * 기능 한줄 설명
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.demand.dmf0099
 * @FileName : Dmf0099ServiceImpl.java
 * @author   : {이름 또는 닉네임}
 * @date     : 2026. 5. 13.
 * @description : 상세 설명
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 5. 13.       {이름}       최초 작성
 */
```

**Frontend**:

```tsx
/**
 * DMF0099 — Sales Monitor 화면
 *
 * @author {이름}
 * @date 2026-05-13
 */
```

### 10.2 README

각 feature 패키지(`features/admin/`, `features/demand/` 등)는 README.md 작성:
- 도메인 설명
- 주요 화면 목록 + MENU_ID
- 외부 의존 (DB Procedure, 다른 시스템)

## 11. 변경 이력 관리

- 코드 헤더 주석에 변경 이력 누적 (작성자 / 일자 / 내용)
- 큰 변경은 `CHANGELOG.md` 별도 관리
- DB Procedure 변경은 `Doc/_analysis/db_migration/` 폴더에 변경 이력 기록

---

> 본 문서는 인간 개발자와 AI(Claude) 공통 준수 사항입니다. 각 항목 위반 시 PR 단계에서 reject 사유가 됩니다.
