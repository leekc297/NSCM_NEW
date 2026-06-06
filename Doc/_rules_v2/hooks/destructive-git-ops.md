# Hook — Destructive Git ops (filter-branch / force-push / reset --hard)

> ⚠ **history rewrite / shared remote 영향 작업 시 의무 hook**
> 작성: 2026-06-07 (2026-06-06 source.bundle 127MB 차단 → filter-branch + force-push 사고 후)
> 상위 룰: `Doc/_dev_rules/28_GIT_MULTI_REMOTE.md`
> Cross-ref: 룰 30 §3.5 (백업 메타 미러 정책)

---

## §0. 적용 시점

| 시점 | 행위 |
|---|---|
| **PRE-OPS** | destructive 명령 실행 전 사용자 명시 승인 + 영향 범위 보고 |
| **OPS** | stash --keep-index (untracked 제외) + filter-branch + force-with-lease |
| **POST-OPS** | fetch origin + log diff + push 결과 검증 |

---

## §1. Destructive 명령 인벤토리

다음 명령은 **사용자 명시 승인 + 영향 범위 보고 후** 실행:

| 명령 | 영향 |
|---|---|
| `git filter-branch` | 모든 history rewrite (commit hash 변경) |
| `git filter-repo` | 동일 + branch + ref 통째 rewrite |
| `git push --force` / `--force-with-lease` | remote history 덮어쓰기 |
| `git reset --hard` | working tree + index 변경 손실 |
| `git rebase --interactive` + squash/drop | commit 손실 |
| `git branch -D` (un-merged) | branch commit 손실 위험 |
| `git clean -fdx` | untracked 파일 + ignored 파일 모두 삭제 |

→ 본 hook 의 §2 사전 보고 의무.

---

## §2. PRE-OPS 사전 보고 의무

```
[DESTRUCTIVE OPS 사전 보고]

명령: git filter-branch ...
영향 범위:
  - history rewrite: N commit (oldest: {hash} → newest: {hash})
  - remote 영향: origin/main 만 (개인 백업 repo, 외부 협업 0)
  - working tree 영향: 0 (stash 보호)
  - 손실 위험: 없음 (모든 변경 다른 곳에 원본 있음)

대안 검토:
  - {alternative 1} → 부적합 사유
  - {alternative 2} → 부적합 사유

진행 승인 부탁드립니다.
```

→ 사용자 명시 "진행" / "OK" 후에만 실행.

---

## §3. filter-branch 표준 절차 (대용량 파일 history 제거)

### 3.1 stash 패턴 (광범위 untracked 회피)

⚠️ `git stash --include-untracked` 는 untracked 가 광범위 (GB 단위) 시 10분+ hang. **modified-only stash 의무**:

```bash
git stash push -m "before-{operation}-{date}"
# untracked 는 working dir 에 남음 (filter-branch 영향 없음)
```

### 3.2 filter-branch 실행

```bash
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch {path1} {path2} ..." \
  --prune-empty --tag-name-filter cat -- --all
```

⚠️ `--all` 은 모든 ref (branches + tags + stash) 를 rewrite. stash ref 가 single-commit 으로 변환되어 `git stash pop` 불가능.

### 3.3 stash 복귀 (filter-branch 후 깨진 ref 복구)

```bash
# stash 가 rewrite 됐는지 확인
git show-ref | grep "stash"

# rewritten stash 는 single-commit. cherry-pick 으로 복원
git cherry-pick --no-commit {stash_hash}
```

### 3.4 force-with-lease push

```bash
# 1. origin 의 진짜 최신 fetch (filter-branch 가 local 의 origin/main tracking ref 도 rewrite 했음)
git fetch origin main

# 2. force-with-lease 로 안전 push (다른 commit 이 push 됐다면 거부)
git push --force-with-lease origin main
```

→ `stale info` 오류 발생 시 fetch 재실행 후 재시도. `--force` 단독은 협업 안전성 손실로 비권장.

---

## §4. POST-OPS 검증

### 4.1 history 일관성

```bash
git log --oneline -10
git log origin/main -10 --oneline
git rev-list --left-right --count origin/main...HEAD
# 결과 = "0	0" 의무 (동기화)
```

### 4.2 차단 파일 제거 확인

```bash
git log --all --oneline -- "{removed_path}"
# 결과 0 lines 의무 (history 에서 완전 제거)
```

### 4.3 .gitignore 보강 의무

filter-branch 로 제거한 파일 패턴은 `.gitignore` 에 명시 추가 의무 — 향후 같은 사고 방지:

```gitignore
# 2026-06-07 사고 — backup-all.ps1 가 GitHub 100MB 초과 source.bundle commit
_backup_metadata/**/source.bundle
_backup_metadata/**/*.dmp
_backup_metadata/**/*.tar
```

---

## §5. 사고 사례 (2026-06-06 ~ 2026-06-07)

### 사례 1: source.bundle 127MB GitHub push 차단

**원인**: `backup-all.ps1 -PushMeta` 가 `source.bundle` (점진 증가) 을 GitHub mirror 에 포함. 어제 02:00 자동 backup 시 127MB grow → push 차단.

**fix 절차**:
1. `git filter-branch --index-filter "git rm --cached --ignore-unmatch _backup_metadata/*/source.bundle"` — 4 backup commits 의 source.bundle 제거 (38 commit rewrite)
2. `.gitignore` 보강 (`_backup_metadata/**/source.bundle` + `.dmp`/`.tar`/`.tar.gz`/`.zip`)
3. `git push --force-with-lease origin main`
4. `backup-all.ps1` 정책 fix — Step 7 metaFiles 에서 `source.bundle` 제거 + 95MB size guard

**룰화**: 본 hook 신규 + 룰 30 §3.5 보강 + `.gitignore` 보강.

**부수 효과**: filter-branch 가 stash ref 도 rewrite → `git stash pop` 불가 → `cherry-pick` 으로 복구.

---

## §6. Cross-ref

- 룰 28 `28_GIT_MULTI_REMOTE.md` — Multi-remote 운영 표준 (NSCM 모노레포 + GitHub + GitLab)
- 룰 30 `30_LOCAL_BACKUP_RESTORE.md §3.5` — 백업 메타 미러 정책 (source.bundle 제외)
- 메모리 `feedback_github_personal_repo.md` — "소스 업로드/올려줘" 트리거 + GitHub leekc297/NSCM private repo
- 메모리 `feedback_powershell_windows_quirks.md` — PowerShell `2>&1` + native exe NativeCommandError 회피
