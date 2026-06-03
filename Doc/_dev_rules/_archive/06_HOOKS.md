# 06. Hook 룰 (Git Hook + Husky + AI 검증 Hook)

> 코드 일관성을 강제하는 자동화 레이어. 사람이 깜빡해도 시스템이 catch.

## 1. Frontend — Husky (이미 활성화됨)

### 1.1 위치 / 활성화

```bash
nscm-fe/.husky/
├── commit-msg       # 커밋 메시지 검증
├── pre-commit       # 커밋 전 lint-staged
└── pre-push         # 푸시 전 브랜치명 + type-check
```

활성화: `package.json`에 `"prepare": "husky"` 스크립트 → `pnpm install` 시 자동 활성화.

### 1.2 `.husky/pre-commit` (필수)

```bash
#!/usr/bin/env sh
. "$(dirname "$0")/_/husky.sh"

npx lint-staged
```

`package.json`의 `lint-staged` 설정:
```json
"lint-staged": {
  "*.{ts,tsx}": [
    "eslint --fix",
    "prettier --write"
  ]
}
```

### 1.3 `.husky/commit-msg` (필수, 추가 권장)

```bash
#!/usr/bin/env sh
. "$(dirname "$0")/_/husky.sh"

npx --no-install commitlint --edit "$1"
```

`commitlint.config.js`:
```js
module.exports = { extends: ['@commitlint/config-conventional'] };
```

### 1.4 `.husky/pre-push` (이미 적용됨, 강화)

```bash
#!/usr/bin/env sh
. "$(dirname "$0")/_/husky.sh"

# 1. 브랜치명 검증
local_branch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$local_branch" = "dev" ]; then
    exit 0
fi

valid_branch_regex="^dev$|^(feat|fix|docs|style|refactor|test|chore)\/[a-z0-9-]+$"

if [[ ! $local_branch =~ $valid_branch_regex ]]; then
    echo ""
    echo "❌ [Error] 브랜치명이 규칙에 맞지 않습니다!"
    echo "규칙: <type>/<kebab-case> (공백 금지, 소문자/하이픈만 사용)"
    echo "허용 Type: feat, fix, docs, style, refactor, test, chore"
    echo "예시: feat/login-form, fix/api-bug"
    echo ""
    exit 1
fi

echo "✅ 브랜치명 검사 통과: $local_branch"

# 2. Type Check
echo "type-check..."
pnpm type-check || exit 1

# 3. (선택) 영향 받는 패키지만 빌드
# turbo run build --filter=...[origin/dev]

echo "✅ Pre-push 통과"
```

### 1.5 (권장) `.husky/pre-merge-commit` — 머지 충돌 방지

```bash
#!/usr/bin/env sh
. "$(dirname "$0")/_/husky.sh"

# 머지 커밋 전 type-check + lint
pnpm type-check && pnpm lint
```

## 2. Backend — Git Hook (Gradle 자동 설치)

### 2.1 설치

```bash
./gradlew installGitHooks
# scripts/pre-commit → .git/hooks/pre-commit 복사 + 755
```

### 2.2 `scripts/pre-commit` (권장 구성)

```bash
#!/bin/sh
# nscm-be/scripts/pre-commit

echo "🔍 Pre-commit hook: Spotless 검사..."

# 1. 변경된 java/yml/gradle/md 파일만 대상
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(java|yml|gradle|md)$' | tr '\n' ',' | sed 's/,$//')

if [ -z "$STAGED_FILES" ]; then
    echo "✅ 변경된 대상 파일 없음 — skip"
    exit 0
fi

# 2. Spotless apply (자동 수정)
./gradlew spotlessApply -PspotlessFiles="$STAGED_FILES" --quiet

if [ $? -ne 0 ]; then
    echo "❌ Spotless apply 실패"
    exit 1
fi

# 3. 변경분 다시 staging
echo "$STAGED_FILES" | tr ',' '\n' | xargs -I{} git add {}

echo "✅ Spotless 자동 포맷팅 적용 완료"
exit 0
```

### 2.3 (권장) `scripts/pre-push` — 빌드 + 테스트

```bash
#!/bin/sh
# nscm-be/scripts/pre-push

local_branch="$(git rev-parse --abbrev-ref HEAD)"
valid_branch_regex="^(main|dev|feat\/|fix\/|docs\/|style\/|refactor\/|test\/|chore\/)"

if [[ ! $local_branch =~ $valid_branch_regex ]]; then
    echo "❌ 브랜치 이름 형식이 잘못되었습니다!"
    exit 1
fi

# 빌드 + 단위 테스트
./gradlew build --quiet || exit 1
echo "✅ Pre-push 통과: 빌드 + 테스트"
```

설치:
```bash
# build.gradle에 추가 (이미 installGitHooks 있음)
tasks.register('installGitHooks', Copy) {
  from new File(rootProject.rootDir, 'scripts/pre-commit')
  from new File(rootProject.rootDir, 'scripts/pre-push')
  into new File(rootProject.rootDir, '.git/hooks')
  fileMode 0755
}
```

## 3. AI 검증 Hook (Claude 작업 시)

> Claude Code / Cowork 환경에서 코드 작성 전후에 자동 적용할 룰.
> 본 hook 룰은 `Doc/_dev_rules/01_CLAUDE.md`를 보강합니다.

### 3.1 작업 시작 Hook (Pre-Work)

Claude가 코드 작성을 시작하기 전 자기 점검:

```yaml
pre_work_checklist:
  - "이 작업은 FE / BE / DB / 문서 중 어느 영역인가?"
  - "기존 유사 화면/기능 파일 경로는?"
  - "Read 도구로 가장 유사한 기존 코드를 먼저 읽었는가?"
  - "MENU_ID, 패키지명, 폴더명 모두 명명 규약에 맞는가?"
  - "Foundation → Shared → Application 방향을 위반하는가?"
  - "Service / ServiceImpl 분리가 되는가?"
```

### 3.2 파일 작성 직후 Hook (Post-Write)

```yaml
post_write_validation:
  ts_tsx:
    - "any 타입 사용 X"
    - "import 경로 alias (@shared/@foundation) 사용"
    - "console.log 잔존 X (운영 코드)"
    - "inline style X (SCSS Module만)"
    - "Wijmo 외 그리드 라이브러리 사용 X"
    - "useState로 페이지 전역 상태 X (Zustand 사용)"

  java:
    - "패키지 선언이 디렉토리와 일치"
    - "@RequiredArgsConstructor + final 필드"
    - "@Autowired 필드 주입 X"
    - "Service extends BaseService implements XService"
    - "private final String nameSpace = '{도메인}.{기능}.';"
    - "@Slf4j + log.info()"
    - "ResponseEntity<BaseResponse<T>> 형태"
    - "DTO는 @Builder + of() 정적 팩토리"

  xml_mybatis:
    - "namespace='com.lgcns.nscm.{도메인}.{기능}'"
    - "statementType='CALLABLE'"
    - "{ CALL PKG_*.P_*(...) } 형식"
    - "#{DATARESULT, mode=OUT, jdbcType=CURSOR, ...}"
    - "${} 직접 바인딩 사용 X (#{} 만)"

  sql:
    - "DATEADD/CHARINDEX/STRING_SPLIT 잔존 X"
    - "N' 유니코드 접두사 X"
    - "@변수 X (V_ / v_ 사용)"
    - "GETDATE() X (SYSDATE)"
    - "ISNULL() X (NVL)"
    - "WITH (NOLOCK) X"
    - "[bracket] X"
    - "dbo. prefix X"
```

### 3.3 작업 종료 Hook (Pre-Submit)

```yaml
pre_submit_checklist:
  - "변경된 파일이 명명 규약을 따르는가?"
  - "기존 화면(예: user-management)과 코드 스타일 일관성이 있는가?"
  - "관련 테스트가 추가/수정됐는가?"
  - "주석 헤더(@Project @Package @FileName @author @date @description)가 포함됐는가? (BE 클래스)"
  - "validation.md (해당 화면) 갱신이 필요하지 않은가?"
  - "Doc/_dev_rules/07_DO_AND_DONT.md 위반 사항 없는가?"
```

### 3.4 Hook 자동 실행 (Cowork 환경)

본 레포에 이미 다음 hook 체크리스트 파일이 포함되어 있습니다 (AI 작업 시 Read):

```
Doc/_dev_rules/hooks/
├── pre-write.md                       # 파일 작성 전 자기 점검 (§3.1 확장)
├── post-write.md                      # 파일 작성 직후 검증 (§3.2 확장)
├── pre-submit.md                      # 작업 종료 전 최종 검증 (§3.3 확장)
├── screen-analysis-pre-build.md       # ⭐ 화면 분석서 작성 전 자기 점검 (2026-05-19 신설)
├── screen-analysis-post-build.md      # ⭐ 화면 분석서 작성 후 자동 검증 (2026-05-19 신설)
└── screen-analysis-pre-submit.md      # ⭐ 화면 분석서 PR 머지 직전 검증 (2026-05-19 신설)
```

AI 작업 흐름:
1. 코드 작성 직전 → `Doc/_dev_rules/hooks/pre-write.md` Read
2. Edit/Write 도구 사용 직후 → `Doc/_dev_rules/hooks/post-write.md` Read 후 자체 점검
3. 작업 종료 / commit 직전 → `Doc/_dev_rules/hooks/pre-submit.md` Read 후 최종 검증

⭐ **화면 분석서 작업 시 (추가 의무 — 2026-05-19)**:
1. 화면 분석서(xlsx 12시트 + SVG + PNG) 작성 직전 → `Doc/_dev_rules/hooks/screen-analysis-pre-build.md` Read (자료 확보/꼬임/Mockup 시나리오 점검)
2. 작성 직후 → `Doc/_dev_rules/hooks/screen-analysis-post-build.md` Read 후 자동 검증 (12시트/PNG/MD5/카운트)
3. PR 머지 직전 → `Doc/_dev_rules/hooks/screen-analysis-pre-submit.md` Read 후 머지 게이트 최종 검증
4. 관련 룰: `19_MOCKUP_SVG_RULES.md` (Mockup 룰), `20_SCREEN_ANALYSIS_PIPELINE.md` (파이프라인)

`.claude/hooks/` 폴더가 필요한 경우 위 6개 파일을 symlink 또는 copy.

## 4. CI Hook (GitLab CI)

`.gitlab-ci.yml` (이미 존재):

```yaml
stages:
  - install
  - lint
  - type-check
  - test
  - build
  - sonar

# Frontend
fe:install:
  stage: install
  script: pnpm install --frozen-lockfile

fe:lint:
  stage: lint
  script: pnpm lint

fe:type-check:
  stage: type-check
  script: pnpm type-check

fe:test:
  stage: test
  script: pnpm test

fe:build:
  stage: build
  script: pnpm build
  artifacts:
    paths: [apps/web/dist/]

# Backend
be:build:
  stage: build
  script: ./gradlew build
  artifacts:
    paths: [build/libs/*.war]

be:test:
  stage: test
  script: ./gradlew test
  artifacts:
    reports:
      junit: build/test-results/test/*.xml
```

## 4.4. ⭐ As-Is Validation/Expression 매핑 매트릭스 Hook (신규 2026-05-13)

신규 화면 FE 작업 시 `__asis-mapping__.md` 매트릭스 작성 + 카운트 일치 검증.

### 4.4.1 자동 생성 스크립트 (pre-write 단계)

```bash
# 화면 1개 — To-Be FE 폴더에 빈 매트릭스 생성
python3 Doc/_analysis/scripts/gen_asis_mapping.py \
    --out C:/Projects/NSCM/nscm-fe/features/demand/src/pages/dmf0021-sales-plan/__asis-mapping__.md \
    DMF0021_SalesPlan

# 또는 전체 97 화면 (분석 폴더에 일괄)
python3 Doc/_analysis/scripts/gen_asis_mapping.py --all
```

### 4.4.2 카운트 검증 스크립트 (pre-submit 단계)

`.husky/pre-push` 또는 별도 `scripts/check-asis-mapping.sh`:

```bash
#!/bin/sh
# 변경된 features/{domain}/src/pages/* 하위에 __asis-mapping__.md 가 있는지 + ✅ 카운트 일치 검증

CHANGED_PAGES=$(git diff --cached --name-only | grep -oE 'features/[^/]+/src/pages/[^/]+' | sort -u)

for page in $CHANGED_PAGES; do
    map_md="$page/__asis-mapping__.md"
    if [ ! -f "$map_md" ]; then
        echo "❌ $map_md 누락 — As-Is 매핑 매트릭스 필요"
        exit 1
    fi
    # ✅ 카운트
    applied=$(grep -c '| ✅ |$' "$map_md")
    failed=$(grep -c '| ❌ |$' "$map_md")
    if [ "$failed" -gt 0 ]; then
        echo "❌ $map_md — 미적용 행 $failed 건 (적용 $applied)"
        exit 1
    fi
    echo "✅ $map_md — 모두 적용 완료 ($applied건)"
done
```

### 4.4.3 GitLab CI 검증

```yaml
fe:check-asis-mapping:
  stage: lint
  script:
    - sh scripts/check-asis-mapping.sh
  only:
    - merge_requests
```

## 4.5. ⭐ MSG i18n JSON 동기화 Hook (신규 2026-05-13)

GSCM `SCM_ADM_MSG_M` 마스터 또는 화면 신규 추가 시 `apps/web/src/locales/{ko|en}/msg.json` 동기화.

```bash
# 갱신 명령 (수동)
python3 Doc/_analysis/scripts/gen_i18n_msg_json.py \
    --out C:/Projects/NSCM/nscm-fe/apps/web/src/locales/
```

### 4.5.1 pre-push 검증

```bash
# validation.md 변경 시 → msg.json 동기화 의무
if git diff --cached --name-only | grep -qE "validation\.md|expressions\.md"; then
    python3 Doc/_analysis/scripts/gen_i18n_msg_json.py --out /tmp/i18n_check/
    if ! diff /tmp/i18n_check/ko/msg.json apps/web/src/locales/ko/msg.json; then
        echo "❌ msg.json 미동기화"
        exit 1
    fi
fi
```

## 4.6. procedures.d.ts 최신화 Hook ⭐ (신규)

신규 화면 추가 또는 SP 컬럼 변경 시 `configs/types/procedures.d.ts`가 outdated 상태가 되면 안 됨.

### 4.5.1 FE husky pre-push 추가

`.husky/pre-push`에 추가:

```bash
# procedures.d.ts 최신화 검증
if git diff --cached --name-only | grep -qE "(procedures\.d\.ts|sql/.*\.xml)"; then
    echo "🔍 procedures.d.ts 동기화 검증..."
    pnpm gen:procedures
    if ! git diff --exit-code configs/types/procedures.d.ts; then
        echo "❌ procedures.d.ts가 DB 메타와 불일치합니다."
        echo "   pnpm gen:procedures 실행 후 변경분을 커밋하세요."
        exit 1
    fi
    echo "✅ procedures.d.ts 동기화 OK"
fi
```

### 4.5.2 GitLab CI 검증

`.gitlab-ci.yml`:

```yaml
fe:check-procedures:
  stage: lint
  script:
    - pnpm install --frozen-lockfile
    - pnpm gen:procedures
    - git diff --exit-code configs/types/procedures.d.ts || (echo "procedures.d.ts is outdated. Run 'pnpm gen:procedures' locally." && exit 1)
  only:
    - merge_requests
    - dev
```

### 4.5.3 BE 메타 변경 시 trigger

`SCM_ADM_API_M` / `SCM_MST_SHEET_COLUMNS` 변경 SQL이 PR에 포함되면 → FE도 동시 변경 필수.

```bash
# scripts/check-screen-meta-sync.sh
CHANGED_DB_FILES=$(git diff --name-only HEAD~1 | grep -E "(SCM_ADM_API|SCM_MST_SHEET_COLUMNS|SCREEN_REGISTRATION)")
CHANGED_FE_TYPES=$(git diff --name-only HEAD~1 | grep "procedures.d.ts")

if [ -n "$CHANGED_DB_FILES" ] && [ -z "$CHANGED_FE_TYPES" ]; then
    echo "❌ DB 메타가 변경됐는데 procedures.d.ts가 미갱신!"
    echo "   변경 파일: $CHANGED_DB_FILES"
    exit 1
fi
```

## 5. 코드 품질 Hook (Sonar)

```yaml
sonar:
  stage: sonar
  script:
    - ./gradlew sonar -Dsonar.projectKey=nscm -Dsonar.host.url=$SONAR_HOST
  only:
    - merge_requests
    - dev
    - main
```

### 5.1 Sonar 룰 우선순위

| Severity | 처리 |
|---|---|
| Blocker | PR 머지 차단 |
| Critical | 머지 가능하나 별도 issue 등록 |
| Major | 검토 후 처리 |
| Minor / Info | 선택적 |

## 6. AI 자동 점검 Hook (Claude 전용)

Claude Code 환경에서 다음 룰을 hook으로 활용:

### 6.1 .claude/CLAUDE.md (workspace level)

```markdown
# NSCM 작업 시 필수 룰

이 폴더에서 작업할 때는 반드시 다음을 따르세요:

1. **첫 번째 작업 전**: `Doc/_dev_rules/01_CLAUDE.md` 를 Read 도구로 확인
2. **유사 기존 코드 확인**: 신규 파일 작성 전 유사 패턴 검색 (Grep 도구)
3. **명명 규약 검증**: PascalCase / camelCase / kebab-case 정확히
4. **import 순서**:
   - FE: foundation → shared → 같은 feature → 외부 라이브러리
   - BE: java → javax → org → com (Spotless에 정의됨)
5. **AS-IS DB 접근**: 모두 PKG_xxx.P_* 호출 (직접 테이블 SELECT X)
6. **응답 형태**: BaseResponse<T> 표준 준수
7. **state 관리**: Zustand `createPersistedStoreWithTab` (개별 셀렉터)
8. **Layer 위반 검증**: Foundation → Shared → App 방향만

## 작업 시작 시 첫 명령

```
Read: Doc/_dev_rules/01_CLAUDE.md
Read: Doc/_dev_rules/{03_FE_RULES.md or 04_BE_RULES.md}
Grep: 유사 기존 화면 패턴 (예: "user-management")
```
```

### 6.2 .claude/settings.json (옵션)

```json
{
  "hooks": {
    "PreWrite": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "echo '⚠️  CLAUDE.md 룰 준수 확인:\\n- Layer 위반?\\n- 명명 규약?\\n- 기존 패턴 참조?\\n'"
          }
        ]
      }
    ],
    "PostWrite": [
      {
        "matcher": "*.ts|*.tsx",
        "hooks": [
          {
            "type": "command",
            "command": "pnpm prettier --check ${file} 2>&1 || true"
          }
        ]
      },
      {
        "matcher": "*.java",
        "hooks": [
          {
            "type": "command",
            "command": "echo '코드 작성 완료. Spotless 검증 권장: ./gradlew spotlessApply'"
          }
        ]
      }
    ]
  }
}
```

## 7. Hook 실행 순서 (전체 흐름)

```
0. ⭐ 작업 시작 시 (신규 화면 FE)
   - Read: validation.md + expressions.md
   - python3 Doc/_analysis/scripts/gen_asis_mapping.py --out {feature}/__asis-mapping__.md {ID}
   ↓
1. 개발자/AI가 코드 작성 (Validation/Expression Hook + 매트릭스 ✅ 마킹)
   ↓
2. 파일 저장 시 (IDE/Editor)
   - ESLint auto-fix (FE)
   - Prettier format (FE)
   - Spotless format (BE, IDE 플러그인)
   ↓
3. git add → git commit
   ↓
4. .husky/pre-commit (FE) or scripts/pre-commit (BE)
   - FE: lint-staged (eslint --fix + prettier --write)
   - BE: spotlessApply (staged 파일만)
   ↓
5. .husky/commit-msg (FE)
   - commitlint 검증
   ↓
6. git push → .husky/pre-push or scripts/pre-push
   - 브랜치명 검증
   - type-check (FE) / build + test (BE)
   - ⭐ __asis-mapping__.md ✅ 카운트 검증 (§4.4)
   - ⭐ msg.json 동기화 검증 (§4.5)
   - ⭐ procedures.d.ts 동기화 검증 (§4.6)
   ↓
7. GitLab CI
   - install / lint / type-check / test / build / sonar
   - ⭐ check-asis-mapping / check-procedures
   ↓
8. PR 머지
   - 리뷰어 승인
   - 최종 CI 통과
```

## 7.5. ⭐ 자동화 스크립트 호출 시점 요약 (2026-05-13)

| 시점 | 명령 | 용도 |
|---|---|---|
| 작업 시작 (신규 화면) | `python3 Doc/_analysis/scripts/gen_asis_mapping.py {ID}` | 빈 매트릭스 생성 |
| 작업 중 (MSG 추가) | `python3 Doc/_analysis/scripts/gen_i18n_msg_json.py --out ...` | i18n JSON 갱신 |
| 작업 후 (BE 메타 변경) | `pnpm gen:procedures` | procedures.d.ts 갱신 |
| PR 제출 직전 | `sh scripts/check-asis-mapping.sh` | 매트릭스 ✅ 카운트 검증 |
| CI (GitLab) | `fe:check-procedures` + `fe:check-asis-mapping` | 최종 자동 검증 |

## 8. Hook 실패 시 대응

| 단계 | 실패 사유 | 대응 |
|---|---|---|
| pre-commit | lint 오류 | `pnpm lint:fix` 수동 실행 |
| pre-commit | spotless | `./gradlew spotlessApply` |
| commit-msg | 메시지 형식 | Conventional Commits 형식으로 재작성 |
| pre-push | 브랜치명 | `git branch -m new-name` |
| pre-push | type-check | TypeScript 오류 수정 |
| CI | 테스트 실패 | 로컬 재현 후 수정 |

## 9. Hook 우회 (응급 상황만)

```bash
# Husky hook 우회 (사용 자제)
git commit --no-verify -m "fix(urgent): hotfix"
git push --no-verify
```

**원칙**: hook 우회는 운영 장애 대응 등 응급 상황만. PR 머지 시점에는 반드시 모든 검증 통과.

## 10. Hook 개선 정책

- Hook 룰 변경은 `feat(chore): hook 강화` 커밋으로 PR
- 모든 개발자가 동일 hook 사용 (개인별 우회 금지)
- Hook 실행 시간이 5초를 넘으면 최적화 필요

---

> 본 Hook 룰은 "한 사람이 개발한 것처럼" 일관성을 강제하는 마지막 안전망입니다.
> 사람이 깜빡해도 시스템이 catch하여 PR 단계에서 일관성을 확보합니다.


---

## ⚠️ Anti-Simplification Hook (2026-05-22 신규, 최우선 룰)

> **이 룰은 본 문서의 다른 모든 룰을 압도하는 최우선 룰입니다.**
> 상세: [`hooks/anti-simplification.md`](hooks/anti-simplification.md)

### 배경

사용자 명시 요청 (2026-05-22):
> "강력한 Rule 로 전체적인 작업에 대한 속도문제로 일을 단순화 하는 일은 절대 하지 않도록 hook 파일로 정의해주세요.
> 단순화 해서 잘못된 결과나 산출물을 도출하면 그건 신뢰성만 손상시키고, 클로드를 사용하지 않게 되는 결과를 이어질거에요."

### 핵심 원칙

| # | 원칙 | 위반 시 |
|---:|---|---|
| 1 | 정규식 1개·자동화 1회 통과 결과로 산출 금지 | 신뢰성 손상 → 사용 중단 |
| 2 | 사용자가 "모두/전체/정밀/상세" 요청 시 **다중 패턴 + Cross-check 의무** | 동일 |
| 3 | 기존 분석 자료 (`_phase{1~4}`, `_screens`, `_asis_mappings`) **활용 의무** | 동일 |
| 4 | 추출 한계가 있으면 **명시** (사용자에게 숨기지 않음) | 동일 |
| 5 | 시간/토큰 절약을 위한 단독 결정 금지 | 동일 |

### 위반 시 절차

1. 즉시 인정 (변명 금지)
2. 원인 분석 (어떤 단순화를 했는지)
3. 영향 평가 (산출물의 어느 부분이 잘못)
4. 보완 계획 제시
5. 사용자 승인 후 재작업

### 다른 Hook 과의 관계

- 본 룰은 `pre-write.md`, `post-write.md`, `pre-submit.md`, `screen-analysis-*.md` 모두에 **선행 적용**
- 충돌 시 anti-simplification 우선

### 변경 이력

- 2026-05-22: 신규 작성. SCP/SSP/FP v7.3 메타 자동 생성 + 매트릭스 SP 누락 사건 후.
