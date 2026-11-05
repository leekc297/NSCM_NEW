# CommonSync — 공통소스 다운로드·업로드 판정 규칙 (2026-10-22)

공통소스 = `eunjoo-hwang/nscm-fe` (nscm-fe 의 remote `common`). 트리는 모노레포라 FE 파일은 `nscm-fe/` 아래에 있다.
Vibe_Manager Git 메뉴 두 항목이 이 도구(`common_sync.py`)를 쓴다. 판정 규칙은 두 방향이 같고, 역할만 바뀐다.

| 메뉴 | 방향 | 결과 |
|---|---|---|
| ⬇️🔀 Source Download & Merge | 공통 → 내 nscm-fe | 내가 안 고친 파일은 공통 원문, 내가 고친 파일은 내 수정분 유지 + 공통 수정분 병합 |
| 📤 Source Upload(UI) | 내 화면 → 공통 `feat/<id>-<날짜>` | 공통 최신 위에 **내 작업분만** 얹은 커밋 |

`git merge` / `git pull` 은 쓰지 않는다(사내 GitLab 이력과 섞임). 다운로드는 `common` 의 push URL 이 `no_push` 일 때만 진행한다.
업로드는 Upload(UI) 로만(fetch URL 명시 푸시 · remote 설정 불변). 도구 소스는 공통에 올리지 않으며 보관은 Source Backup 만.

### 업로드 내용의 도구 흔적 (§3 판정 뒤 적용)
공통 저장소의 파일 내용·커밋 메시지·브랜치명에 도구 이름·경로를 남기지 않는다.
- 코드 파일: 주석 속 `생성기: tools/…` 같은 조각을 지우고, 그래도 흔적이 있는 주석 줄은 뺀다. **코드 줄**에 흔적이 있으면 그 파일은 올리지 않는다(직접 정리).
- Markdown: 줄을 지우지 않고 흔적 표현만 중립어로 바꾼다(`Doc/gen/…` → 등록 SQL · `Doc/asisfacts/…` → AS-IS 분석자료 · `Fact Pack` → AS-IS 분석 · 생성기 이름 삭제).
- 커밋 메시지·브랜치명에 흔적 단어가 있으면 입력 단계에서 받지 않는다.

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
