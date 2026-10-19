<!-- Atlas Studio 플랫폼 가이드 사본 — atlas init 시 주입. 무엇을 할 수 있는지의 안내서다. -->
# Atlas Studio — 아키텍처·운영 모델

> 이 문서는 atlas-studio 의 **현재 실체**를 기록한다. 빌드·함정·진행 과제는 루트 `CLAUDE.md`,
> 제품 컨셉 원문은 루트 `Atlas_Studio_Architecture_Proposal.md`,
> 핵심 목표(비전 — .atlas 데이터 레이크·그래프 지식구조)는 [vision.md](vision.md).

## 1. 제품 개념 — 워크벤치 호스트

atlas-studio 는 특정 도메인 도구가 아니라 **Workbench Host** 다. 도메인 작업(예: 레거시→React
마이그레이션)은 **워크벤치**가 소유하고, 호스트는 프로젝트 열기·워크벤치 로딩·전역 설정만
담당한다. 등록된 워크벤치가 0개여도 호스트는 완전히 동작한다 — 새 프로젝트는 빈 워크벤치
(또는 워크벤치 빌드 에이전트)로 시작할 수 있다.

**비전**: 워크벤치는 **하나의 거대한 실행 애플리케이션**이고, atlas-studio 는 그것을 호스팅해
수행하는 **runtime** 이자 워크벤치 애플리케이션을 만드는 **builder** 다. UI 정의든 tool 정의든,
studio 의 builtin(범용 셸·위젯 카탈로그·엔진)에 해당하는 것을 제외한 **모든 것은 워크벤치에
선언으로 정의**된다. 워크벤치가 코드가 아니라 순수 선언 팩이 되는 것이 종착점이며(§7 로드맵),
그 실증 무대였던 migration 코드 워크벤치는 경계 검증을 마치고 리포에서 분리됐다(§6).

### 개념 모델 (Stage · Activity · Tool · Feedback)

**용어: Activity = Task** — 두 말은 같은 뜻이다(에이전트·CLI·렌더 스펙 어디서든 `task` 는
`activity` 의 동의어로 수용된다. 쓰기·저장은 항상 `activity`). Stage 를 Task 라 부르지 않는다.

```
프로젝트 (A to Z)
└─ Stage                                   ← 탭은 Stage 만 가진다
   ├─ ① Activity (= Task, skill 패키지)   실행 단위 — 폴더가 skill 패키지(activity.json + skill.md + resources/)
   │    ├─ 실행방식(kind): agent(에이전트가 skill 수행) XOR exec(무개입 결정적 실행 —
   │    │    type: terminal(셸)|launch(디버그 어댑터 launch config 참조)|tool(레지스트리 툴)|code(레거시))
   │    ├─ 분류: run(실행) / eval(평가·완성도) / improve(가이드·도구 개선)
   │    ├─ 선후행: dependsOn (FS/SS/FF/SF)
   │    ├─ 도구 연결: 등록된 툴을 세션 MCP(mcp__atlas__<id>)로 호출
   │    └─ 도메인 슬롯(review·delta 등)
   (stage 안에는 Activity 뿐이다 — 구 ② Todo·③ CheckList·피드백 큐·Hook 은 2026-08-13
    **기능째 제거**(사용자 결정: stage 가 라벨 수준의 의미라 stage 스코프 부가 기능은
    의미가 없다). 사람의 백로그·진척은 **Work Item(작업 목록 화면)**이 소유한다.)
──────────────────────────────────────────
Tool    작업 단위가 아니라 도구 — 챗 에이전트(stage 세션)·🛠 툴 빌더(레지스트리·미리보기)·실행확인
```

운영 루프: **run → eval(StageScore) → HITL 보강 → improve(가이드 개정)** 를 stage 마다
반복한다. (stage 는 단순 라벨 — 구 stage decide 통과 판정은 2026-08-04 제거.)

### 선언으로 자라는 툴

도구의 행동과 화면은 코드가 아니라 **프로젝트 안의 선언**으로 정의되고, AI 와 사람이 함께 편집하며,
검증된 선언은 시드 팩으로 회수되어 다음 프로젝트의 자산이 된다.

| 확장 대상 | 선언 위치 | 자산화 경로 |
|---|---|---|
| AI 행동(skill) | `stages/<id>/activities/<id>/` | 워크벤치 템플릿으로 export |
| 단계 선언 | `stages/<id>/{stage.yaml, guide.md}` | 〃 |
| 실행 도구 | `tools/*.yaml|json` kind:code (직접 실행 프로그램 — MCP 로 노출) | 〃 |
| **interactive/render tool** | `tools/*.yaml|json` kind:ui — form(폼, 응답 대기) XOR render(화면, inside/popup), §7 | 〃 |

## 2. 아키텍처

```
apps/studio        Tauri v2 + React 호스트 셸 — 게이트·타이틀바·프로젝트 열기·새 프로젝트 위저드·
                   환경설정. Rust 는 얇은 클라이언트(파일 읽기 shaping + core spawn — 두뇌 아님)
packages/front-shell     프런트엔드 셸(2026-09-09 개명 — 구 workbench-sdk) — 화면의 실체 —
                   WorkbenchProps(root/view/reload)·WorkbenchShell(+슬롯)·ChatView/Explorer/
                   FileEditor/SkillBlueprint·Tauri 브리지 클라이언트. 소스 배포(vite 가 번들)
packages/atlas-runtime   Node 사이드카(headless 두뇌) — workspace(앵커)·stage 폴더 엔진·activity·
                   툴·score·claude 세션(chat/chat-serve)·워크벤치 발견/검증/
                   스캐폴드/패키징/적용·전역 설정·CLI 프레임워크
packages/plugins/  동봉 플러그인 패키지(2026-09-09 이동 — 구 packages/graph-editor·packages/notes.
                   패키지 이름 @atlas-studio/graph-editor·notes 는 그대로)
                   graph-editor  그래프 편집기(플러그인 1호) — insight-neo 이식 + atlas-engine 실행/디버그.
                                 MUI 6·@rjsf·react-dnd 를 여기로 격리(SDK peerDeps 오염 금지)
                   notes         개인 노트(플러그인 2호) — 전역 ~/.atlas/notes(Obsidian vault 호환)
                   둘 다 소스 배포(vite 가 번들). 호스트 등록은 apps/studio/src/host/plugins.ts
workbenches/<id>   도메인 전부 — 스키마·커맨드·시드 팩·UI(셸+패널 주입)·manifest.json
                   (**현재 0개** — 첫 워크벤치 migration 은 제거됨, §6)
apps/atlas-cli     합성 지점 — `atlas` bin. WORKBENCHES 배열에 코드 워크벤치를 정적 합성
                   (현재 빈 배열 = 순수 호스트 모드로 완전 동작)
```

- **서버·DB 없음** — per-user 데스크톱, 동기화는 VCS(git/svn). core 는 VCS-unaware.
- **core 가 유일한 writer** — Rust/React 는 스키마를 중복 구현하지 않고 CLI 에 위임한다.
- 원칙: runtime 은 도메인을 모른다(팩 미동봉 — 주입식). 새 코드는 "어느 워크벤치에도
  재사용되는가"로 runtime/workbench 를 가른다. 합성은 apps/ 에서만.
- 워크벤치 UI = **WorkbenchShell + 도메인 패널 주입** — 셸(stage 탭·activity·chat 도크·
  작업 목록·툴·뷰 패널)은 SDK 소유, 도메인은 슬롯(stageHuman/settingsSections/extraTabs/
  treeHints)로 끼운다.

### 화면 골격 (host shell ↔ WorkbenchShell)

```
┌─ appbar (.topbar)        TitleBar — 프로젝트/도움말 메뉴 · 브랜드 · 경로(readonly) · 창 컨트롤
├─ loadline                전역 로딩 인디케이터(SDK loading 스토어 구독)
├─ body (.body)            ── 항상 행(row) — 도킹과 무관 ──
│   ├─ activitybar         Activity Bar — 작업 관점 전환. 좌측 고정
│   └─ mainpanel           work area ↔ chat split. dock-* 클래스는 여기에만 걸린다
│       ├─ workspace       work area — Task(stage) 탭바 + 활성 패널(.report) + OutputPanel
│       ├─ chat-collapse   챗 접기/펼치기 스트립 (도크 방향 가장자리)
│       ├─ dock-divider    리사이즈 핸들 (mainpanel 사각형 기준 — mainRef)
│       └─ chat-dock       챗 도크 — 세션 탭 + ChatView(keep-alive 렌더)
└─ statusbar (.statusbar)  하단 상태바 — 앱 버전 + 업데이트 알림 슬롯(atlas-dist 체크, 버전당 1회)
```

- **소유권**: appbar·statusbar·전역 모달(페어링 승인·업데이트 다이얼로그)은 **호스트**
  (apps/studio App.tsx), body 안쪽(activitybar~chat-dock)은 **SDK WorkbenchShell** 소유다.
  스타일은 현재 studio styles.css 가 전부 제공한다(shell.css 분리는 로드맵 — §끝 과제).
- **챗 도킹 규칙**: `dock-right|left|bottom|top` 은 mainpanel 의 flex 방향만 바꾼다 —
  Activity Bar 는 어느 도킹에서도 좌측에 고정된다. body 레벨에 걸면 dock-left 가
  Activity Bar 를 오른쪽으로 밀고 dock-top/bottom 이 가로로 눕히는 회귀가 된다(과거 버그).
  도크 상태(chatOpen/chatDock/chatSize)는 application_context.json 에 per-user 영속.

### 프로세스 구조 — VS Code 모델을 지향 (현재 ↔ 목표)

Electron(Chromium+V8+Node 동봉)과 달리 Tauri 는 렌더러를 OS WebView 로 아끼는 대신
Node 계층(Extension Host 격)을 **우리가 직접 동봉**해야 "설치 한 번 = 실행"이 된다.

| VS Code | Atlas Studio 현재 | 격차(목표) |
|---|---|---|
| Main Process — 창·메뉴·OS 통합·업데이트·렌더러 생성 | Rust 호스트(lib.rs) — 창 생성·updater.rs·WebView 생성. 메뉴는 OS 네이티브가 아닌 React 타이틀바(의도된 선택) | Help/About — 앱·번들 패키지 버전 + third-party licenses 표시 |
| Renderer — Workbench UI·Monaco | WebView2 — WorkbenchShell + Monaco(`@monaco-editor/react`) | (거의 일치) |
| Extension Host — Node 환경·IPC | **Node 사이드카(atlas-cli/runtime)가 이 자리** — stdin/stdout NDJSON, 상주 chat-serve. 인스톨러(NSIS)에 Node+사이드카 동봉(2026-07-12 — `tauri.conf.bundle.json` overlay + `prepare-bundle.mjs`, ATLAS_CORE_DIR/ATLAS_NODE_BIN) | 워크벤치 동적 로딩(entry.ui)·Extension SDK 와 함께 확장 호스트로 정식화 |
| Shared/Utility — 파일 감시·검색·터미널 PTY·백그라운드 | 검색은 Rust invoke(search_project), 상주는 chat-serve·atlas serve | 파일 감시·터미널 PTY 미구현. 유틸 프로세스 계층 분리 미착수 |

### 다국어 (i18n) — 키 기반 사전, 드롭인 언어 팩, 즉시 적용

2026-08-30 ST-065(사용자 결정)로 **"키 = 한국어 원문"(gettext 방식)을 폐기**했다 — 원문 한 글자만
고쳐도 코드와 en.json 을 같이 손봐야 했고, 언어 추가·배포 후 번역 수정도 원문 문자열에 묶였다.

- **코드는 키만 안다**: `t('<영역>.<slug>', params?)` — 키는 소문자·숫자·`_`, 여러 영역이 같이
  쓰는 문구는 `common.*`. 파라미터는 `{name}` 자리표시자. **문구는 사전이 갖는다** — 문구 수정은
  ko.json 한 줄이고 코드는 안 건드린다.
- **사전은 패키지가 소유**(`src/locales/{ko,en}.json`): SDK(`packages/front-shell` — 공통·셸) ·
  studio(`apps/studio` — 호스트 셸) · notes · graph-editor. SDK i18n.ts 가 자기 것을 직접 적재하고
  나머지는 `registerMessages({ko,en})` 로 합류한다(각 패키지 `src/i18n.ts` — 엔트리와 index 가
  side-effect import. lazy 청크도 첫 렌더 전에 등록된다). ko 가 기준어이자 마지막 폴백.
- **조회 순서**: 외부 팩(선택 언어) → 내장(선택 언어) → 내장 ko → 키 그대로. **키가 화면에 보이면
  사전 누락**이다 — 회귀 가드 `front-shell/src/i18n-keys.test.ts`(t() 키 ⊆ ko · ko 키는 코드에
  리터럴로 존재(죽은 키 금지) · en 키 집합 = ko · 패키지 간 중복 금지 · 키 모양). 새 문구는
  **코드 키 + ko + en 세 줄**이 한 세트고 테스트가 빠진 쪽을 이름으로 알려준다.
- **즉시 적용(리로드 없음)**: `setLocale()` 이 구독자에게 통지하고 호스트 루트(main.tsx `Root`)가
  `useLocale()` 로 리렌더한다 — 아래 트리는 memo 가 없어 t() 결과가 전부 갱신된다. 예외 2종은
  각자 locale dep 을 가진다: **`useMemo` 안의 t()**(CommandPalette·FlowTab — `useLocale()` 값을 deps 에)
  와 **등록 시점에 문장을 조립하는 커맨드**(WorkbenchShell activity 이동 — locale dep 으로 재등록).
  **모듈 상수에는 키를 둔다**(`label: 'shell.explorer'` → 렌더에서 `t(x.label)`) — 상수에서 t() 를
  부르면 그 언어로 굳는다. 도움말·리허설 창은 `storage` 이벤트(다른 창의 localStorage 변경)로 따라온다.
- **언어 소스 3계층**: 내장(ko/en — 앱 번들) · **설치본 템플릿** `<설치 폴더>/locales/{ko,en}.json`
  (prepare-bundle 8단계 `stage-locales.mjs` 가 패키지 사전을 팩 포맷으로 합쳐 동봉 — 내장과 같은 내용,
  **복사해 새 언어를 만들거나 고쳐서 번역을 덮는 용도**) · `~/.atlas/locales/*.json`(user — 같은
  id 면 bundle 을 가림). Rust `locales_list`/`locale_read` → SDK `applyLocale()`(부트·설정 공용).
  **같은 locale 의 외부 팩은 내장을 덮는다**(예: `~/.atlas/locales/en.json` 한 줄로 번역 수정).
- **팩 포맷**: `{ "locale": "ja", "name": "日本語", "strings": { "common.save": "保存", … } }`.
  부분 번역 팩도 안전(빠진 키는 내장 → ko).
- 선택 언어는 localStorage(`atlas-locale`) — 설정 ⚙ › 환경 설정 › 일반 › 표시 언어(내장 + 발견된 팩).

## 3. 프로젝트 홈 — 두 레벨 + 앵커가 유일한 진실

```
<root>/
├─ .atlas/                          호스트 레벨
│   ├─ project.yaml                 앵커: version/workbench/project{name,createdAt} 만
│   ├─ application_context.json     per-user UI 상태(작업자·모델·탭 등 — VCS 제외)
│   └─ workbenches/<id>/            워크벤치 레벨 (인스턴스)
│       ├─ workbench.yaml           도메인 설정(예: 구 migration 의 source/target/screens)
│       │                           — writer 는 워크벤치 기여 CLI 뿐(구 migration 의
│       │                           atlas setup/config set — 워크벤치와 함께 제거됨, git 이력)
│       ├─ stages/<id>/             stage 하나의 전부: stage.yaml(존재의 진실)·guide.md·
│       │                           activities/<id>/·intake/·history/·results/
│       ├─ stages/stages.yaml       선후(의존) 관계만 — 폴더가 진실
│       ├─ reports/stage-scores          stage 엔진(범용) 데이터 (stage-decisions 는 legacy)
│       ├─ tools/ templates/ pack.yaml
│   ├─ atlas-studio.md              플랫폼 가이드 사본 — atlas init 이 주입(§4)
└─ <target>/docs/atlas/             도메인 산출물 SoT(워크벤치가 정의 — migration: contracts/reports/deltas)
```

- 워크벤치 홈 해석은 **앵커의 workbench 필드가 유일한 진실** — 암묵 기본 워크벤치는 없다.
  TS `detectAtlasHomeAuto()`(앵커 부재 시 undefined) ↔ Rust `atlas_dirs`(Option) 가 같은 규칙을
  **미러**한다 — 한쪽만 고치면 안 된다.
- 시드 설치 규칙(installSeedTree): 없는 파일만 복사(사용자 수정본 보존), `templates/` 는 raw 복사,
  activity 는 id 기준 중복 방지, 치환 변수는 `{{projectName}}·{{atlasHome}}` **2개뿐**.

## 4. AI 세션 (claude sidecar)

- 세션은 **상주형 serve 프로세스**(chatId 별) — 백그라운드 작업 알림·권한 승인 스트림이 턴 사이에
  유지된다. 턴 프로토콜은 stdin NDJSON 제어 / stdout AtlasEvent.
- 첫 턴에 **공통 맥락 주입**: 세션 사용자(application_context.user) + atlas CLI 실행법 +
  `project_overview.md` + 시작 가이드. 가이드 ctx: stage id → `stages/<id>/guide.md`,
  `ui`·`tool` → `tools/guide.md` → **내장 폴백 `assets/guides/tool.md`**(2026-08-20 — 시드 사본
  폐지, 내장이 진실. 통합 — 뷰=kind:'ui' 툴, 세션은 ctx 별 분리 유지),
  `activity`/`workbench` → 각 도메인 폴더의 guide.md (스킬·워크벤치 빌드 에이전트 —
  activity 는 `activities/guide.md`, ctx 'task' 는 동의어 별칭),
  `atlas` → 워크벤치 홈 루트 `guide.md`(범용 프로젝트 어시스턴트 — Explorer·설정 등
  전용 문맥이 없는 화면과 stage 탭 0개일 때의 기본 에이전트. 가이드 없으면 공통 맥락만 주입).
- `atlas init` 은 플랫폼 가이드(이 문서)를 `.atlas/atlas-studio.md` 로 주입한다 — 새 프로젝트에서
  "무엇을 할 수 있는지"의 안내서(1회 복사·이후 보존, 원본은 runtime dist/assets 빌드 자산).
- 모델 해석: 프로젝트(application_context.model) → 전역 설정(`~/.atlas/settings.json`
  defaultModel — 호스트 환경설정 메뉴/`atlas settings`) → CLI 기본값.
- activity 실행 프롬프트 골격은 runtime 내장 엔진 템플릿(`activity-run`) — 프로젝트/팩 override 우선
  (stage `templates/activity-run.md`).

## 5. 워크벤치 생애주기 — 인스턴스 ↔ 템플릿

프로젝트의 `.atlas/workbenches/<id>/` 는 그 프로젝트에 맞게 자란 **살아있는 인스턴스**다.
좋은 인스턴스는 템플릿(manifest.json + resources/{pack.yaml, seed/})으로 일반화해 배포한다:

```
[만들기]  atlas workbench create <id>       빈 템플릿 스캐폴드 (생성 직후 validate 통과 불변식)
[키우기]  프로젝트에서 stage/activity/가이드를 실전으로 발전  (빌드 에이전트: chat ctx 'workbench')
[추출]    atlas workbench export            인스턴스 → 템플릿 (실행 상태 제외·{{atlasHome}} 역치환·done 리셋)
[검증]    atlas workbench validate <dir>    구조 검증 — 시드 가드의 제품화(테스트와 동일 로직)
[배포]    atlas workbench pack <dir>        zip (루트 = manifest.json)
[등록]    atlas workbench install <zip>     ~/.atlas/workbenches/<id> (검증 통과 후에만)
                                            앱: 새 프로젝트 위저드 "워크벤치 템플릿 등록 (zip)…"
[적용]    atlas workbench apply <id>        발견된 템플릿 → 프로젝트에 범용 설치(앵커 생성 포함, 멱등)
```

발견(discover)은 ① 앱 번들(`ATLAS_WORKBENCHES_DIR`) ② 사용자 `~/.atlas/workbenches/` 스캔 +
합성 지점이 등록한 builtin. id 충돌은 builtin > user > bundled.

### 새 프로젝트 생성 4종 (위저드 → Rust kind 매핑 → core)

| kind | 실행 | 결과 |
|---|---|---|
| code | `atlas <manifest.contributes.install>` (예: migration "setup") | 도메인 시드 설치 |
| template | `atlas workbench apply <id>` | 템플릿 시드 설치, UI 는 범용 셸 |
| starter | `atlas init --workbench custom --starter` | 빈 워크벤치(stage 0개+가이드 — 'Activity 구성' 시작 페이지) |
| starter-builder | 위 + `--with-builder` | + 워크벤치 구성 가이드(guides/workbench-build.md — `atlas guide workbench-build`) |

## 6. 첫 번째 워크벤치였던 migration — 제거됨 (git 이력)

migration 워크벤치(COTIS React 전환 방법론: **S0 초기설정 → S1 소스분석 → S2 전환방침 →
S3 전환규칙 → S4 화면전환 루프 → S5 검증·인수** + activity 31종, 화면 파이프라인 커맨드
`run/delta/regen/verify`, DeltaSet/ReviewReport/MaturityIndex 스키마, 도메인 UI 패널)는
2026-07-08 리포에서 제거됐다 — 호스트/워크벤치 경계 검증을 마친 뒤 사용자가 분리를 결정했고,
추후 별도 배포(별도 리포·템플릿 팩·순수 선언 팩 중 택일)로 재등록될 예정이다.
전체 소스는 git 이력에 있다(마지막 상태: 커밋 43d6286 의 `workbenches/migration/`).
방법론 원천 문서는 `C:\project\trans\workspace\NEXT_COTIS\docs\react-migration`.
원칙 기록: "React 로 바뀔 뿐, 화면 동작은 원본과 동일해야 한다 — UI 의 진실은 화면 정의(XRW)다."

## 7. Atlas UI Renderer — interactive tool · render tool

**모든 툴은 에이전트가 호출한다**(mcp__atlas__<id>) — 상주 배치는 없다. kind:'ui' 툴은
두 형태 중 정확히 하나(XOR)를 가진다:
- `form` — **interactive tool**: 호출하면 사용자에게 폼이 뜨고 제출값이 tool_result 로 복귀(응답 대기).
- `render` — **render tool**: 복잡한 화면(위젯 그리드)을 사용자에게 보여준다.
  `display: inside`(기본 — 챗 카드 인라인, 즉시 `{"displayed":true}` 반환) |
  `display: popup`(오버레이 모달 — 사용자 확인 시 `{"acknowledged":true}` 반환).

선언 위치는 code 툴과 같은 `tools/<id>.yaml|json` — 구 `ui/layout.yaml`(단일 파일 뷰 묶음)과
stage 서브뷰 배치는 이 구조로 대체·제거됐다.

UI 스택 구도(검토 결론 2026-07): **JSON Forms/RJSF → 채택 보류**(zod3 이 검증의 진실인데 둘 다
ajv 제2 검증 스택 강제, 자체 다크테마·한국어 재스킨 비용 ≥ 자체 렌더러 유지비). 선언 어휘는
**JSON Schema subset 으로 공식화**하고(`toJsonSchema(FormSpec)` 어댑터), 렌더러는 직접
구현(Atlas UI Renderer)을 유지한다. 전환 트리거(중첩 객체·배열·조건부 rule 이 실제 요구로 등장)
발생 시 **JSON Forms 우선**(MIT·React19 peer 명시·renderer-set 모델). **FlexLayout → Studio
도킹(로드맵 4)**, **React Flow → UX 빌더(로드맵 4~5)**.

### FormSpec — 단일 폼 선언 언어 (JSON Schema subset)

폼 선언은 **FormSpec 하나**다(runtime `schemas/form-spec.ts` 의 zod 가 진실, SDK
`forms/spec.ts` 가 방어적 미러, `toJsonSchema()` 로 표준 직렬화). 필드는 flat 배열 —
`{ key, label?, description?, type: string|number|boolean, options?(enum→select),
multiple?(→multiselect), widget?: text|textarea|select|radio|checkbox|multiselect,
required?, default?, placeholder? }`. 같은 선언이 두 곳에서 렌더된다(SDK `FormRenderer` 공용):

- **render 의 form 위젯** — 제출값을 `.atlas/` 아래 파일에 저장(append=JSONL/write=프리필 수정)
- **interactive tool(form)** — 제출값이 에이전트에게 tool_result 로 복귀

### render — 화면 선언 (RenderSpec)

`render: { display?: inside|popup(기본 inside), columns?(1~4 — 챗 카드는 1 권장), widgets[] }`.
화면의 id/제목은 툴의 id/name. 에이전트가 호출하면 챗 카드(inside) 또는 오버레이 모달(popup)로
렌더된다 — 입력 수집은 render 의 몫이 아니다(그건 form). 🛠 툴 패널은 핫 리로드용으로
tools/ 를 Rust `ui_tools` 로 직접 스캔(2.5s 목록 시그니처 폴링 — 변경 시 레지스트리 재조회)한다.

- 빌트인 위젯은 SDK `shell/widgetRegistry.tsx` 의 레지스트리 1곳에 등록한다
  (+ runtime `schemas/render.ts` 의 enum/`UI_WIDGET_PROPS`, 내장 가이드 `assets/guides/tool.md`
  카탈로그 표).
  **RenderSpec 자체가 위젯별 props 를 검증**(superRefine)하므로 레지스트리 스캔·시드 검증에서
  자동으로 걸리고, 렌더는 방어적 파싱을 유지한다(롤백 안전). 챗 카드·모달·🛠 미리보기는
  단일 렌더러(SDK `RenderGrid`)를 공유한다.
- **안전 모델**: 선언은 코드를 실행하지 못한다. button 위젯은 **사전 등록 named action**
  (빌트인 `activity.run`(`task.run` 동의어)/`tool.run`/`chat.open` + 워크벤치 주입 `WorkbenchShellProps.actions`,
  `wb.` 접두)만 참조하고, `confirm` 선언 시 확인이 강제된다.

## 8. 사용자 활동 이력 (User Action History)

구 개념 모델 ②(User Activity — 실체는 피드백 큐뿐이었고 2026-08-13 제거)의 일반화로,
**"사람이 한 일의 기록"** 전체를 담는다. 목적은 하나: **에이전트가 사용자의 워크플로(행동 흐름)를
읽고 의도를 더 잘 파악**하게 한다. 턴별 `[화면 상태]`(스냅샷)와 상보적 — 스냅샷 + 흐름.

### 저장 — append-only JSONL, 파일 하나 + user 필드

`<워크벤치 홈>/history/actions.jsonl`. 한 줄 = 한 액션(Activity Streams 의
actor–verb–object–time 골격). 기존 이력(`stages/<s>/history/activities.jsonl`·
`tools/history.jsonl`)과 같은 관례이며, 사용자 구분은 파일 분리가 아니라 `user` 필드로 한다
(협업 타임라인 병합이 자연스럽다).

```jsonl
{"ts":"2026-07-10T16:14:27.000Z","user":"jai jun,Lee <j@x.com>","action":"stage.add","object":{"kind":"stage","id":"S2-querydsl-verify"},"detail":{"name":"query dsl 검증"}}
{"ts":"2026-07-10T16:15:02.000Z","user":"jai jun,Lee <j@x.com>","action":"stage.view","object":{"kind":"stage","id":"S2-querydsl-verify"}}
```

스키마는 runtime `schemas/action.ts`(zod) 가 진실:
`{ ts, user?, action(동사 — "<영역>.<동작>" 소문자), object?: {kind,id}, stage?, detail? }`.

### 동사 사전 (1차)

| 영역 | 동사 | writer |
|---|---|---|
| stage | `view`(탭 전환) · `add` · `update` · `decide` | view=앱(UI), 나머지=core 커맨드 |
| activity | `create` · `run`(ok 포함) | core (run 은 history append 지점에서 — 직접/챗 경로 공통) |
| tool | `create` · `run` | core (〃) |
| chat | `open`(새 세션, ctx id) | core (chat-serve 첫 턴) |

(구 `hook.*`·`feedback.add`·`todo/checklist.*` 동사는 2026-08-13 기능 제거와 함께 사라졌다 —
옛 actions.jsonl 에 남은 줄은 그대로 읽힌다(action 은 자유 문자열).)

(기록 동사는 `activity.*` 다.)

원칙: **원시 클릭이 아니라 의미 단위 액션만**. 네비게이션 계열은 `stage.view` 하나뿐이고
연속 중복은 기록하지 않는다(셸이 마지막 기록과 같으면 skip). 채팅 본문·파일 내용·폼 입력값은
기록하지 않는다 — 액션 메타만(프라이버시).

### writer 규칙

의미 액션은 이미 전부 core CLI/runtime 를 경유하므로 해당 커맨드 성공 지점에서
`recordAction()` 한 줄로 남긴다(**best-effort — 기록 실패가 본 작업을 막지 않는다**).
UI 전용 액션(`stage.view`)만 앱이 `atlas actions add` 로 보낸다. user 스탬프는
`application_context.user`(기존 activity history 와 동일).

### 소비 경로

1. **참조 조회** — `atlas actions list`(ST-083 이전에는 프리앰블 `[최근 사용자 활동]` 인라인).
2. **CLI** — `atlas actions list [--user u] [--since 1d|3h|ISO] [--action stage.*] [--limit n] [--json]`.
   에이전트가 세션 중 재조회하는 표준 경로.
3. (후보) 파생 요약 — 에이전트가 흐름에서 의도를 추론("S2 구성 중").

### 운영 규칙

- append-only, 손상 라인 skip(기존 이력 리더와 동일). 5MB 초과 시 `actions-<ts>.jsonl` 로 롤,
  list 는 롤 파일까지 병합.
- **VCS 비대상** — 개인 활동. `.atlas/.gitignore` 에 `workbenches/*/history/actions*.jsonl`
  (신규 init 이 쓰고, 첫 기록 시에도 라인을 보장한다).
- `atlas actions clear [--user u]` — 사용자별/전체 삭제.
- 후보(미구현): `project.open`, 파생 워크플로 요약 툴, 세션(chat) 안에서의 활동 위젯.

### 호출 시퀀스 (form·render 공통 배관)

```
에이전트 ─ mcp__atlas__<id>(context[, prefill]) ──▶ MCP 핸들러(tool-mcp, askUi 훅)
   ▲                                                    │ ui_request(requestId, form|render…)
   │ tool_result(JSON)                                   ▼
   └── chat-serve ◀─ (form/popup: answer(callId) ◀─ 앱 카드/모달 ◀ 사용자)
                  ◀─ (render inside: 즉시 {"displayed":true})
```

- 에이전트 인자는 `context`(배경)·form 은 `prefill`(초기값)뿐 — **선언 자체가 내용**이다.
- 답 배관은 AskUserQuestion 과 같은 `answer(callId)` 채널을 재사용한다(Rust 변경 0).
  단, ui 요청은 진짜 tool_result 로 복귀한다(AskUserQuestion 은 deny-message 우회).
- 해제 정책(form·render popup): 취소/닫기·10분 타임아웃·interrupt/close 모두
  `{"cancelled":true,…}` 로 resolve — 미해결 promise 로 턴이 갇히지 않는다.
  render inside 는 pending 자체가 없다(즉시 반환).
- 세션 전용: `atlas tool run`/🛠 ▶ 은 거부(executeToolModule 가드). 노출은 동적 —
  세션의 atlas MCP 서버(buildDynamicAtlasToolMcp)가 tools/ 를 감시(watchToolRegistry)해
  등록·수정·삭제를 진행 중 세션에도 tools/list_changed 로 반영한다(새 세션 불필요).
- 실증 사례(git 이력): 구 migration 시드의 `tools/s0-setup-interview.yaml` — S0 초기설정
  인터뷰가 폼으로 값을 받아 검증 후 CLI 로 기록하는 전체 루프.

### 만들기·보기

- 생성: `atlas tool create <id> -n <이름> --form '<FormSpec JSON>'` 또는 `--render '<RenderSpec
  JSON>'` (kind 자동 유도). 가이드·위젯 카탈로그는 내장 `assets/guides/tool.md`
  (`atlas guide tool` — 챗 ctx `tool`, 하위호환 별칭 `ui`).
- 앱: 🛠 툴 패널 = 레지스트리 전체(code·interactive·render, 복구 UI 겸용) + kind:'ui' 툴
  미리보기(구 ▦ 패널은 여기로 통합).

### 로드맵 (선언형 워크벤치로 가는 5단계)

1. **Atlas UI Renderer v1 + interactive/render tool** — FormSpec(JSON Schema subset)·FormRenderer·
   위젯 레지스트리(form/table/button)·named action·kind:'ui'(form XOR render, display
   inside|popup)·tools/ 레지스트리 통합·에이전트 호출 일원화 ✅ (이 절이 그 결과)
2. **도메인 화면 선언화 실증** — 코드 패널(구 migration 의 HumanZone/Intake/Runtime 급)을
   위젯·액션 선언으로 재표현, 필요한 위젯·액션을 카탈로그에 추가 (migration 재등록 시 재개)
3. **스키마·커맨드 선언화** — workbench.yaml 설정 폼·산출물 스키마·intake 를 JSON Schema 선언으로,
   범용 config/validate/intake 빌트인화
4. **레이아웃·그래프** — FlexLayout 도킹(스튜디오 레이아웃 선언), React Flow 기반 그래프 위젯
   (stage/activity 흐름 시각화·편집)
5. **워크벤치 빌더 UI** — 선언 전체(스키마·커맨드·UI·스킬)를 빌더로 저작 — 종착:
   코드 워크벤치 패키지가 불필요해짐(순수 선언 팩 + 범용 셸)
