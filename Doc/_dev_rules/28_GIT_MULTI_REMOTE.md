# 28. Git Multi-Remote 운영 — NSCM 모노레포 + GitHub 개인 백업

> ⭐ **이 PC 단독 운영 — 사내 GitLab 동기화는 별도 PC**
> NSCM 작업 시행착오를 개인 GitHub 에 백업하면서 사내 GitLab origin 은 별도 PC 에서 안정 코드만 push.

작성: 2026-05-28
관련 메모리: `feedback_github_personal_repo.md`, `feedback_md_organize_trigger.md`
관련 hook: `hooks/encoding-check.md`

---

## §1. 아키텍처

```
┌───────────────────────────────────────────────────────────────────┐
│ 이 PC (Local Dev)                                                 │
│                                                                   │
│  C:\Projects\NSCM\                                                │
│    ├── .git/                  ← 모노레포 git (이 PC 단독)         │
│    │   └── remote: origin → github.com/leekc297/NSCM.git          │
│    ├── nscm-fe/               ← 일반 sub-folder (nested git 없음) │
│    ├── nscm-be/               ← 일반 sub-folder (nested git 없음) │
│    ├── Doc/                                                       │
│    ├── _artifacts/                                                │
│    └── .gitignore                                                 │
│                                                                   │
│  C:\Projects\NSCM_gitlab_backup\   ← 사내 GitLab .git 백업 보관   │
│    ├── nscm-fe.git/           ← 원래 nscm-fe/.git                 │
│    └── nscm-be.git/           ← 원래 nscm-be/.git                 │
└───────────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────────┐
│ 별도 PC (Cloud Sync)                                              │
│                                                                   │
│  ~/work/nscm-fe-cloud/         ← 사내 GitLab origin clone          │
│  ~/work/nscm-be-cloud/                                            │
│                                                                   │
│  이 PC 로부터 검증된 코드만 수동 복사 → commit → push origin       │
└───────────────────────────────────────────────────────────────────┘
```

## §2. 초기 설정 (한 번만)

```bash
# 1) 사내 GitLab .git 폴더를 외부로 백업 (nested git 회피)
mkdir -p C:/Projects/NSCM_gitlab_backup
mv C:/Projects/NSCM/nscm-fe/.git C:/Projects/NSCM_gitlab_backup/nscm-fe.git
mv C:/Projects/NSCM/nscm-be/.git C:/Projects/NSCM_gitlab_backup/nscm-be.git

# 2) NSCM root 신규 git init
cd C:/Projects/NSCM
git init
git branch -M main
git remote add origin https://github.com/leekc297/NSCM.git

# 3) .gitignore 작성 (다음 §3 참조)

# 4) 첫 commit + push
git add .
git commit -m "chore: NSCM 모노레포 첫 백업"
git push -u origin main
```

## §3. 필수 `.gitignore` 패턴

### 3.1 민감 파일 (절대 commit 금지)

```gitignore
# DB 비밀번호 / 인증 정보
**/config/config-local.yml
**/config/config-dev.yml
**/config/config-prod.yml
**/config/config-production.yml
**/credentials*
**/secrets*
**/*secret*
*.pem *.key *.pfx *.p12
.env .env.*
!.env.example

# 사내 npm registry 토큰
**/.npmrc
**/.npmrc.cloud
**/.npmrc.local
**/.npmrc.backup
```

### 3.2 회사 자산 (외부 노출 금지)

```gitignore
# AS-IS 분석 자료 (LG Energy Solution 내부 자산)
_phase1/ _phase2/ _phase3/ _phase4/
_analysis/
Doc/_analysis/
Doc/_archive/
Doc/_figma/
Doc/_legacy_source/
Doc/output/
Doc/ui_cap/

# DB admin 권한 부여 SQL
_artifacts/*sysdba*.sql
_artifacts/grant_*.sql
_artifacts/local-docker-oracle/
_artifacts/cloud-to-local-mirror/

# 이전 화면 패키지 (zip + 회사 자산)
_dmf0020_artifacts/
_dmf0099_artifacts/
*_artifacts/*.zip
```

### 3.3 빌드 산출물 / 캐시 / 대용량

```gitignore
**/node_modules/
**/dist/ **/build/ **/.turbo/ **/.vite/ **/.cache/
**/.gradle/ **/.idea/
nscm-be/bin/ nscm-be/out/ nscm-be/logs/ nscm-be/output/
**/target/ **/*.class **/*.jar **/*.war

# 대용량 압축 (GitHub 100MB 제한)
*.7z *.zip *.tar.gz *.tar.bz2 *.rar

# 임시
tmp_*.sql tmp_*.csv tmp_*.txt
**/.uuid **/.uuid.LCK **/.uuid.TMP-*
**/*.log **/*.tmp **/*.swp

# 사내 GitLab .git 백업 폴더
NSCM_gitlab_backup/

# Claude Code 사용자 캐시 (개인 PC 전용)
.claude/projects/
.claude/settings.local.json
.claude/sessions/
```

## §4. 일상 운영 — "소스 업로드" 트리거

> ⭐ **사용자 명령 패턴**: "**소스 업로드 해줘**" / "**소스 올려줘**" / "**github 에 올려**"
> → 다음 명령 자동 실행:

```bash
cd C:/Projects/NSCM
git status -s | head -20         # 변경 사항 확인
git add .                        # 전체 stage (gitignore 자동 적용)
git commit -m "<작업 요약 메시지>"
git push origin main
```

### 4.1 commit 메시지 작성 규칙

- 최근 세션의 핵심 작업을 1-2줄로 요약
- 신규 룰/hook 추가 시 명시
- 화면 작업 시 MNU_ID 명시 (예: `feat(DMF0007): ...`)

예시:
```
chore: DMF0007 PSI Tab + PivotGrid 추가 + 룰 27/28 신규

- BE: P_DMF0007_GET_CUST_PSI_PIVOT_DATA SP + customerPsiPivot 매핑 시드
- FE: SHEETS enum + 3-tab (FCST/PSI/PSI-Pivot) + PivotGrid useMemo 패턴
- 룰 27 (Wijmo 모듈 중복/머지 조건/PivotGrid) + hooks 2종 추가
```

## §5. 사내 GitLab 동기화 (별도 PC)

이 PC 에서는 사내 GitLab push 안 함. 별도 클라우드 PC 에서:

```bash
# 별도 PC 에서 사내 origin clone (한 번만)
git clone http://10.94.57.6:8080/project/nscm-2025/nscm-fe.git
git clone http://10.94.57.6:8080/project/nscm-2025/nscm-be.git

# 이 PC 의 검증된 코드 → 별도 PC 로 수동 복사
#   (cherry-pick, manual copy, scp 등)
# 별도 PC 에서 commit + push origin
```

### 5.1 이 PC 로 임시 사내 GitLab 복구 (드문 경우)

```bash
# 사내 GitLab .git 복구
mv C:/Projects/NSCM_gitlab_backup/nscm-fe.git C:/Projects/NSCM/nscm-fe/.git
mv C:/Projects/NSCM_gitlab_backup/nscm-be.git C:/Projects/NSCM/nscm-be/.git

# 작업 후 NSCM root commit 전에 다시 외부 백업
mv C:/Projects/NSCM/nscm-fe/.git C:/Projects/NSCM_gitlab_backup/nscm-fe.git
mv C:/Projects/NSCM/nscm-be/.git C:/Projects/NSCM_gitlab_backup/nscm-be.git
```

⚠️ NSCM root commit 시 sub-folder 의 `.git` 폴더가 존재하면 git 이 nested repo 로 인식하여 commit 불가. **반드시** 외부 백업 상태에서 commit.

## §6. 주의 사항

| # | 항목 | 위반 시 |
|---:|---|---|
| 1 | GitHub repo 가 **Private** 인지 확인 | Public 이면 회사 자산 외부 노출 |
| 2 | `git add .` 전에 `.gitignore` 가 적용되었는지 `git status -s` 로 확인 | 민감 파일 push → 즉시 BFG/filter-repo 로 history rewrite 필요 |
| 3 | 100MB 초과 파일 push 시 GitHub 차단 | `*.7z/*.zip/.tar*` 패턴 이미 ignore. 신규 대용량 파일 발생 시 추가 ignore |
| 4 | nested `.git` 폴더 (nscm-fe/.git 등) 가 NSCM root 안에 있으면 commit 불가 | `NSCM_gitlab_backup` 으로 외부 이동 후 commit |
| 5 | `.gitignore` 추가 후 이미 staged 된 파일은 자동 제외 안 됨 | `rm .git/index && git add .` 로 re-stage |
| 6 | `git commit` 시 user.email 이 회사 이메일이면 GitHub 에 노출됨 | 개인 이메일로 변경하거나 GitHub no-reply 사용 권장 |

## §7. 변경 이력

- 2026-05-28 작성. NSCM root 신규 git init + leekc297/NSCM 첫 push 1,116 파일 (5,862 → 1,116 회사 자산 제외).
