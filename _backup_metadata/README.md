# `_backup_metadata/` — NSCM 백업본 메타데이터

> 작성: 2026-05-30
> 관련 룰: [`Doc/_dev_rules/30_LOCAL_BACKUP_RESTORE.md`](../Doc/_dev_rules/30_LOCAL_BACKUP_RESTORE.md)

NSCM 모노레포 + 환경 + Oracle DB 의 정기 백업 (D:\NSCM_backup\) **메타데이터**를 GitHub 에 보관합니다.

## 무엇이 여기 있나?

각 백업마다 4종 파일:

| 파일 | 크기 | 용도 |
|---|---:|---|
| `manifest.json` | ~40 KB | 백업 구성 + 크기 + 타임스탬프 + git_head |
| `oracle-full.log` | ~70 KB | expdp 실행 로그 (테이블별 row 수) |
| `git-head.txt` | <1 KB | 백업 당시 git HEAD SHA |
| `source.bundle` | ~22 MB | git bundle (전체 히스토리 — bundle 만 있으면 소스 복원 가능) |

## 무엇이 여기 **없나** (D:\NSCM_backup\ 만 보관)?

| 파일 | 크기 | 이유 |
|---|---:|---|
| `fe-node-modules.tar` | ~414 MB | GitHub 100MB 단일파일 제한 + 사내 registry 자산 |
| `oracle-full.dmp` | ~1.2 GB | GitHub 100MB 제한 + 회사 데이터 외부 노출 우려 |
| `fe-config/.env.local` | <1 KB | 환경 변수 (민감) |
| `be-config/config-local.yml` | <1 KB | DB 비밀번호 평문 (민감) |

## 폴더 구조

```
_backup_metadata/
  ├── README.md
  ├── 2026-05-30_1354_session-2026-05-30/    (이전 백업 — 차후 commit 시 추가)
  ├── 2026-05-30_1842_post-figma-stage1/     ⭐ 본 backup
  └── ...
```

## 사용 패턴

### 원복 가능 여부 확인
1. `manifest.json` 의 `git_head` 확인 → GitHub 리포의 그 commit 가 존재하는지
2. `oracle-full.log` 의 `Job ... successfully completed` (또는 1 error) 확인
3. 실제 dmp/tar 는 **D 드라이브** 의 같은 이름 폴더에서 복원

### 차후 백업
`backup-all.ps1 -Label <X>` 실행 → 자동으로 `D:\NSCM_backup\manual\YYYY-MM-DD_HHMM_<X>\` 생성. 그 후 메타 4종을 본 폴더에 복사 + push 가 권장 흐름.

## 룰

- `D:\NSCM_backup\` 의 실제 dmp/tar 는 **절대 GitHub 에 올리지 않음**
- 메타데이터만 push (회사 자산 외부 노출 위험 최소화)
- `_backup_metadata/` 폴더 자체는 git track (gitignore 안 함)
- private repo 전용 — public 으로 전환 시 본 폴더 검토 필요
