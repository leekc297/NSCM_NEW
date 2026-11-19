# CommonSync — 공통소스 다운로드·업로드 판정 규칙 (2026-10-22)

공통소스 = `eunjoo-hwang/nscm-fe` (nscm-fe 의 remote `common`). 트리는 모노레포라 FE 파일은 `nscm-fe/` 아래에 있다.
Vibe_Manager Git 메뉴 두 항목이 이 도구(`common_sync.py`)를 쓴다. 판정 규칙은 두 방향이 같고, 역할만 바뀐다.

| 메뉴 | 방향 | 결과 |
|---|---|---|
| ⬇️🔀 Source Download & Merge | 공통 → 내 nscm-fe | 내가 안 고친 파일은 공통 원문, 내가 고친 파일은 내 수정분 유지 + 공통 수정분 병합 |
| ⬇️🔀 Source Download & Merge(BE) | 공통 → 내 nscm-be/src | 같은 판정 + BE 로컬 작업환경 보호(§0-1) — 필요할 때만 |
| 📤 Source Upload(UI) | 내 화면 → 공통 `feat/<id>-<날짜>` | 공통 최신 위에 **내 작업분만** 얹은 커밋 |

`git merge` / `git pull` 은 쓰지 않는다(사내 GitLab 이력과 섞임). 다운로드는 `common` 의 push URL 이 `no_push` 일 때만 진행한다.
업로드는 Upload(UI) 로만(fetch URL 명시 푸시 · remote 설정 불변). 도구 소스는 공통에 올리지 않으며 보관은 Source Backup 만.

### 업로드 내용의 도구 흔적 (§3 판정 뒤 적용)
공통 저장소의 파일 내용·커밋 메시지·브랜치명에 도구 이름·경로를 남기지 않는다.
- 코드 파일: 주석 속 `생성기: tools/…` 같은 조각을 지우고, 그래도 흔적이 있는 주석 줄은 뺀다. **코드 줄**에 흔적이 있으면 그 파일은 올리지 않는다(직접 정리).
- Markdown: 줄을 지우지 않고 흔적 표현만 중립어로 바꾼다(`Doc/gen/…` → 등록 SQL · `Doc/asisfacts/…` → AS-IS 분석자료 · `Fact Pack` → AS-IS 분석 · 생성기 이름 삭제).
- 커밋 메시지·브랜치명에 흔적 단어가 있으면 입력 단계에서 받지 않는다.

## 0. 작업 모드 (2026-11-02)

⬇️🔀 Source Download & Merge 는 Vibe_Manager 환경설정 🧭 작업 모드를 따른다. Source Upload(UI) 는 모드와 무관하다.

| 작업 모드 | 인자 | 동작 |
|---|---|---|
| UI/DB MODE | (없음) | 로컬 소스 보호 — 아래 §1~§3 판정 |
| DB MODE | `--overwrite-local` | 로컬 소스 보호 안 함 — §1~§3 판정 없이 공통 최신 트리 기준으로 맞춘다 |

`--overwrite-local` 의 처리는 다음과 같다.
- 공통 트리에 있고 로컬과 다른 파일은 내 편집본이어도 공통 원문으로 덮어쓴다. d.ts·locales 도 병합하지 않는다.
- 기준선 이후 공통이 지운 파일은 내 편집본이어도 삭제한다.
- 공통에 없는 로컬 전용 파일은 삭제하지 않고 보고서에 '유지' 로 남긴다.
- 공통 새 커밋이 없어도 로컬과 다른 파일이 있으면 적용한다.
- §4 의 백업·미리보기·확인·적용 후 검증은 그대로 적용된다.

## 0-1. BE(nscm-be) 다운로드 — 별도 메뉴 (2026-11-12)

FE 와 BE 는 따로 받는다. ⬇️🔀 Source Download & Merge = FE(nscm-fe)만(`--areas fe` · 기본값). ⬇️🔀 Source Download & Merge(BE) = BE 만(`--areas be`) — 필요할 때만 실행한다.
Source Upload(UI) 는 FE 만 다룬다.

- 대상 = 공통 트리 `nscm-be/src` → 로컬 `nscm-be/src`. 판정 규칙(§1~§3)과 작업 모드(§0)는 FE 와 같다. d.ts·locales 규칙은 FE 전용.
- 기준선 = `state.json` 의 `baselineBe`(FE 기준선 `baseline` 과 따로 간다). 없는 첫 회차는 공통 최신 트리와 로컬을 직접 대조한다.
- 병합 후 선언 중복 검사 = Java 메서드(이름+인자)·클래스, MyBatis XML 의 `id`.
- 옵션: `--areas fe|be|all` · `--be <폴더>` · `--base-be <sha>` · `--be-work <사본>` · `--no-cfg-supplement`.
- 백업 폴더 = `_artifacts/_backup/NSCMBE_PRE_COMMON_<날짜>/`(`local_before/nscm-be/` · `be_worktree_tracked.patch` · `be_git_status_before.txt`).

### BE 로컬 작업환경 보호 — 작업 모드와 무관
로컬은 SSO 에 접속하지 않고 사용자 ID 로그인(`/user/login`)으로 쓴다. BE 를 받아도 이 상태가 유지돼야 한다.

| 보호 | 내용 |
|---|---|
| 환경 파일 유지 | `application*.yml/.yaml/.properties` · `config/*` · `mybatis/mybatis-config.xml` · `logback*.xml` · `log4j*` · `framework/config/CorsConfig.java` 는 항상 로컬 유지. 공통과 다르면 보고서에 '공통과 다름 — 필요하면 직접 반영' |
| 로컬 필수 유지 소스 | `be_local_keep.txt` 에 적은 소스도 항상 로컬 유지 — 환경 파일과 한 쌍으로 동작하는 소스(예: `CustomMap.java` ↔ `mybatis-config.xml` 의 `callSettersOnNulls`) |
| 설정 키 보충 | `application.yml` · `config/config-local.yml` 은 공통에만 있는 **단일 값 키**를 공통 기본값으로 끼워 넣는다(부모 블록이 로컬에 있을 때만). 기존 값·주석·순서는 그대로. 접속·SSO·비밀 값 계열 키와 블록째 없는 설정은 넣지 않고 보고서에 적는다. 보충본은 YAML 로 다시 읽어 기존 값 무변경·보충 키 인식을 확인하고, 하나라도 어긋나면 보충하지 않는다 |
| 로컬 로그인 점검 | 적용될 내용 기준으로 ① `/user/login` + `JsonLoginFilter` 경로 유지 ② 로컬 설정에 `id-login-disabled: true` 없음 을 확인. 실패하면 아무 파일도 바꾸지 않고 중단(exit 4) |
| 대상 밖 쓰기 차단 | 쓰기·삭제는 `nscm-be/src` 아래만. `build.gradle` · `settings.gradle` · `gradle/` · `lib/` · `.git` · `build` · `bin` · `logs` 등은 가드에 걸리면 무변경 중단 |
| 삭제 차단 | DB MODE 에서도 BE 의 내 편집본·환경 파일은 삭제하지 않는다 |
| 저장소 명령 차단 | `nscm-be/.git` 에는 읽기 명령(status · diff · config --get)만 실행 |
| 적용 후 검증 | 환경 파일 바이트 동일 · 설정 키 보충 파일의 기존 줄 삭제 0 · 대상 밖 무변경 · 로그인 점검. 실패하면 기준선 미갱신 |

### 되돌리기
```
python tools/CommonSync/common_sync.py --restore-be-from <백업 폴더> --restore-be-paths src/…/A.java,src/…/B.xml
```
그 회차 백업의 `local_before/nscm-be` 에서 지정한 파일만 되돌린다(src 아래만). 되돌리기 직전 내용은 `_artifacts/_backup/NSCMBE_RESTORE_<시각>/` 에 남는다.

### 받은 뒤 확인 (자동 실행하지 않는다)
컴파일 → 기동 → 로그인 → 화면 조회 1건. BE 는 재기동해야 반영된다.
- `build.gradle` 은 대상 밖이다. 공통 BE 가 새 라이브러리를 쓰면 로컬 `build.gradle` 에 직접 넣거나, 넣기 전까지 `be_sso.init.gradle`(SSO jar 6개)로 기동한다: `gradlew.bat bootRun --offline -I C:/Projects/NSCM/tools/CommonSync/be_sso.init.gradle`
- DB MODE 는 내 편집본도 공통 원문으로 덮어쓴다. 로컬 환경과 한 쌍인 소스가 덮이면 전 화면이 깨질 수 있다 — 그런 소스는 `be_local_keep.txt` 에 적어 둔다.
- UI/DB MODE 는 파일 단위 병합이라, 한 기능의 일부 파일만 충돌로 남으면 컴파일이 깨질 수 있다.

2026-11-12 첫 회차 실사례: ① `build.gradle` SSO jar 6줄 주석 → 컴파일 오류 ② `application.yml` 에 `config.mybatis.log-pool-size` 없음 → Oracle 풀 생성 실패 → 로그인 401 ③ `config.system-cd` 없음
④ `CustomMap.java` 의 null 가드가 공통 원문으로 덮임 → NULL 컬럼이 있는 모든 조회 NullPointerException(화면 'Sql Error'). ②③은 설정 키 보충, ④는 로컬 필수 유지 목록으로 막는다.

## 1. "내 편집본" 판정 — 내용 대조

- 개행(CRLF/LF)·BOM·줄 끝 공백을 정규화한 뒤 비교한다. 파일 수정 시각(mtime)은 쓰지 않는다(일괄 다운로드가 전부 갱신).
- 로컬 파일이 **공통의 어떤 이력본**(같은 경로 전 이력 + 같은 파일명 이력 = 이름 변경 추적)과 같으면 → 내 편집 아님.
- 차이가 공백·따옴표·세미콜론·끝 콤마뿐이면 → 내 편집 아님(포맷 차이).
- 그 외 → 내 편집본.

## 2. 출발 판본(3-way base)

내 편집본이 실제로 출발한 공통 판본을 base 로 쓴다. 후보 = 기준선 시점까지의 이력본(업로드는 공통 최신까지).
점수 = `3 × (후보에만 있는 줄) + (로컬에만 있는 줄)` 이 가장 작은 판본.

- 후보에만 있는 줄은 "내가 지운 것" 또는 "공통이 나중에 더한 것"이다. 이것이 많은 판본을 base 로 쓰면 공통 추가분이 내 삭제로 오판돼 사라진다
  (10-14 회차 재현: `forecast-price.constants.ts` 를 기준선 base 로 병합하면 공통 주석 블록 18줄 유실).
- 단순 "변경량 최소"는 아주 이른 작은 판본이 뽑히는 문제가 있어 가중합을 쓴다.

## 3. 파일 처리

| 경우 | 다운로드 | 업로드 |
|---|---|---|
| 내 편집 아님 | 공통 원문 적용(삭제 포함) | **제외** — 올리면 공통을 옛 판본으로 되돌림 |
| 공통에 없는 파일 | — | 전체(내 신규) |
| 내 편집본 · 공통이 출발 판본 이후 그대로 | 내 소스 유지 | 전체(= 공통 + 내 수정) |
| 내 편집본 · 공통도 바뀜 | 3-way → 내 수정분 + 공통 수정분 | 3-way → 공통 최신 + 내 수정분만 |
| 3-way 충돌 / 병합 후 선언 중복 증가 | 내 소스 유지 · 결정 대기 | 제외 · 사람 확인 |
| 공통과 동일 | 변경 없음 | 제외 |

### 파일 안을 나눠서 다루는 파일
- `configs/types/procedures.d.ts` — `RawProcedureMap` 메뉴 키 블록 단위. 줄 단위 병합 금지.
  - 다운로드: 블록마다 위 표 규칙 · 로컬에 없는 블록/`declare global` 이 공통에 있으면 복구(과거 유실 2건 실사고) · 중복 키 0 · `declare global` 1건 · 키 유실 0 검사.
  - 업로드: **그 화면 메뉴 키(`--keys <ID>`) 블록만** 올린다. 다른 화면의 내 블록·머리·꼬리는 공통 그대로. 로컬에 없는 블록을 삭제로 올리지 않고, 공통이 지운 블록을 되살리지 않는다.
- `**/locales/*.json` — 키 단위. 충돌 키는 다운로드 = 내 값 유지 / 업로드 = 공통 값 유지. 업로드는 키 삭제를 올리지 않는다.

## 4. 안전장치
- 다운로드: 미리보기(`--dry-run`) → 확인 → 적용(`--apply --target <미리보기 때 커밋>`; 그 사이 공통이 바뀌면 중단).
  적용 전 `_artifacts/_backup/NSCMFE_PRE_COMMON_<날짜>/` 에 `local_before/` · `worktree_tracked.patch` · `git_status_before.txt` · `conflicts/`.
  적용 후 검증(공통 원문 일치 · 충돌 마커 0 · 삭제 잔존 0 · `declare global` 1) 실패 시 기준선을 갱신하지 않는다.
- 업로드: 판정표 `.vibe/upload/<ID>_<시각>/UPLOAD_PREP.md` · 커밋 트리가 공통 최신과 달라지는 파일 = 준비한 파일뿐인지 확인 후 푸시.
- 기준선 = `state.json` (적용 성공 시에만 갱신). 정적검증(type-check)은 자동 실행하지 않는다(요청 시만).

## 5. 사용
```
python tools/CommonSync/common_sync.py --dry-run                       # 미리보기
python tools/CommonSync/common_sync.py --apply --no-fetch --target <sha>
python tools/CommonSync/common_sync.py --upload-prepare --keys DMF0082 --files-from files.txt --out <dir>
# 시험: --work <사본 폴더> (백업은 사본 안 · 기준선 미갱신) · --base/--tip 으로 과거 회차 재현
```

## screen_sync.py (2026-11-18)
- CheckList(run_verify.py, --only 제외) 시작 때 자동 실행. DB MODE(harness.json repairScope=DB_ONLY)일 때만 그 화면 FE 페이지 폴더를 Source Download & Merge 와 같은 규칙(common_sync.py --overwrite-local)으로 받는다. UI/DB MODE 는 건너뜀.
- common_sync.py --paths <nscm-fe 기준 경로>: 받을 범위를 좁힌다. 전체 기준선(state.json)은 옮기지 않는다.
- 결과 Doc/verify/<ID>/screen_sync.json · 보고·백업은 common_sync 와 같다(.vibe/common_sync · _artifacts/_backup/NSCMFE_PRE_COMMON_*).
