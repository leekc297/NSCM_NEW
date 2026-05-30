# NSCM 로컬 환경 백업/원복 운영 가이드

> 작성: 2026-05-30
> 대상: NSCM 모노레포 로컬 개발 (Docker Oracle + BE + FE)
> 백업 위치: `D:\NSCM_backup\`

---

## 1. 무엇이 백업되는가

| # | 대상 | 형식 | 위치 (백업 안) |
|---:|---|---|---|
| 1 | 소스 전체 git 히스토리 | `git bundle` | `source.bundle` |
| 2 | FE `node_modules` + `.local-packs` (junction 보존) | tar | `fe-node-modules.tar` |
| 3 | FE 환경 파일 | 복사 | `fe-config\` (.env.local, pnpm-lock.yaml, .npmrc) |
| 4 | BE config-local + application.yml | 복사 | `be-config\` |
| 5 | Docker Oracle (PDB FREEPDB1) 전체 | `expdp FULL=Y` | `oracle-full.dmp` + `.log` |
| 6 | 메타데이터 (시각/git rev/dirty 카운트/용량) | JSON | `manifest.json` |
| 7 | 현재 git HEAD / dirty 파일 목록 | 텍스트 | `git-head.txt` / `git-dirty.txt` |

**무엇이 백업되지 **않는**가**:
- BE `nscm-be/build/`, `nscm-be/logs/` (재생성 가능)
- nscm-fe 의 `dist/`, `.turbo/`, `.vite/` (재생성 가능)
- `_phase*` / `_analysis/` (회사 자산 — gitignore 됨)

---

## 2. 폴더 구조

```
D:\NSCM_backup\
  ├── daily\                            (Windows Task Scheduler 자동)
  │    ├── 2026-05-30_0200\
  │    │    ├── source.bundle
  │    │    ├── fe-node-modules.tar
  │    │    ├── fe-config\
  │    │    ├── be-config\
  │    │    ├── oracle-full.dmp
  │    │    ├── oracle-full.log
  │    │    ├── git-head.txt
  │    │    ├── git-dirty.txt
  │    │    └── manifest.json
  │    └── 2026-05-31_0200\
  ├── manual\
  │    ├── 2026-05-30_1430_pre-major-refactor\
  │    └── 2026-05-30_1500\
  ├── state\
  │    └── last-pids.json               (start-all.ps1 가 갱신)
  └── retention.log                     (자동 삭제 이력)
```

**보존 정책**:
- `daily\` : 최근 **7개** 보존. 나머지 자동 삭제.
- `manual\` : 30일 초과 자동 삭제.
- 매 백업 시작 시 D 드라이브 free space 10GB 미만이면 가장 오래된 daily 1개 자동 삭제.

---

## 3. 백업 (Backup)

### 3.1 수동 백업

```powershell
cd C:\Projects\NSCM\_artifacts\local-docker-oracle
.\backup-all.ps1
```

### 3.2 라벨 붙여서 (큰 작업 직전 권장)

```powershell
.\backup-all.ps1 -Label pre-major-refactor
```
→ `D:\NSCM_backup\manual\2026-05-30_1430_pre-major-refactor\`

### 3.3 자동 백업 등록 (1회만)

```powershell
.\install-backup-schedule.ps1
```
- Task 이름: `NSCM_Daily_Backup`
- 매일 **02:00** 실행
- 로그아웃 상태에서도 동작 (S4U LogonType)
- `Get-ScheduledTask -TaskName "NSCM_Daily_Backup"` 으로 상태 확인

### 3.4 일부 생략 옵션

```powershell
.\backup-all.ps1 -SkipFeTar             # FE tar 생략 (소스+config+Oracle 만)
.\backup-all.ps1 -SkipOracleDmp         # Oracle dmp 생략 (소스+FE+config 만)
.\backup-all.ps1 -SkipSource            # 소스 생략 (FE+Oracle 만)
```

### 3.5 예상 시간 / 용량

| 항목 | 예상 |
|---|---|
| 소스 (bundle) | ~200 MB / 1~2 분 |
| FE node_modules tar | ~1.5 GB / 5~10 분 |
| Oracle expdp FULL | ~3-6 GB / 30~60 분 (테이블 수 의존) |
| **합계** | **~5-8 GB / 40~70 분** |

---

## 4. 원복 (Restore)

### 4.1 드라이런 (안전 확인)

```powershell
.\restore-all.ps1 -BackupDir D:\NSCM_backup\daily\2026-05-30_0200 -DryRun
```
→ 실제 변경 없이 어떤 액션을 할지 콘솔에 나열.

### 4.2 실제 원복

```powershell
.\restore-all.ps1 -BackupDir D:\NSCM_backup\daily\2026-05-30_0200
```
**경고 prompt 가 뜸**: `YES` 입력 시에만 진행.

내부 흐름:
1. 서버 정지 (BE, FE — Docker 는 5단계에서 reset)
2. 현재 소스 변경 사항 `git stash` → `git fetch <bundle>` → `git reset --hard`
3. FE `node_modules` rd /s /q 후 tar 풀기
4. BE config-local 덮어쓰기
5. **`docker compose down -v`** (Oracle volume 완전 삭제) → `docker compose up -d` → `impdp FULL`
6. `start-all.ps1 -SkipDocker` 로 BE/FE 재기동

### 4.3 일부 원복

```powershell
.\restore-all.ps1 -BackupDir ... -SkipSource           # 소스는 그대로, 환경만
.\restore-all.ps1 -BackupDir ... -SkipOracleDmp        # DB 는 그대로, 소스/FE 만
.\restore-all.ps1 -BackupDir ... -Force                # prompt 생략
```

### 4.4 예상 시간

| 항목 | 예상 |
|---|---|
| 소스 git reset | ~30초 |
| FE tar 풀기 | ~5~10분 |
| Oracle volume 재생성 + impdp | ~40~70분 |
| BE/FE 재기동 | ~3분 |
| **합계** | **~50~85분** |

---

## 5. 트러블슈팅

### 5.1 backup-all.ps1 가 D 드라이브 없다고 종료
```
[FAIL] D:\ 드라이브 부재. 백업 중단.
```
→ D 드라이브가 마운트되지 않은 상태. Explorer 에서 D:\ 가 보이는지 확인. USB/외장 디스크라면 연결.

### 5.2 expdp 가 ORA-39082 (synonym translation error) 로 실패
→ 일부 synonym 이 무효 상태일 수 있음. dump 는 그래도 생성됨. impdp 시 동일 경고만 발생. 무시 가능.

### 5.3 FE tar 풀기 후 vite 가 안 됨
→ tar 안의 junction 일부가 손상됐을 가능성. 다음 명령으로 복구:
```powershell
C:\Projects\NSCM\nscm-fe\.local-packs\hoist-from-pnpm-store.ps1
```

### 5.4 Task Scheduler 가 02:00 에 동작 안 함
```powershell
Get-ScheduledTask -TaskName "NSCM_Daily_Backup" | Get-ScheduledTaskInfo
```
- `LastTaskResult` 가 0 이 아니면 실패. 사유: D 드라이브 미연결 / Docker 미가동 / 사용자 비밀번호 변경.
- 수동 trigger: `Start-ScheduledTask -TaskName "NSCM_Daily_Backup"`

### 5.5 백업 7개를 넘었는데 자동 삭제 안 됨
→ `retention.log` 확인. 권한 문제일 수 있음. PowerShell `관리자 권한` 으로 재실행.

---

## 6. 자주 묻는 질문

**Q. 백업 한 번 만들면 얼마나 보관되나요?**
- daily: 최근 7개 (=일주일 분) 만 보관. 새 daily 가 추가될 때마다 가장 오래된 1개 자동 삭제.
- manual: 30일 후 자동 삭제. 영구 보관하려면 폴더 이름을 `KEEP_` 접두사로 바꾸세요.

**Q. Oracle 백업이 30분 넘게 걸리는데 정상인가요?**
- 정상. expdp FULL=Y 는 모든 사용자 스키마를 dump 합니다. 데이터 양에 비례.

**Q. 원복하면 현재 작업 중인 코드는 사라지나요?**
- 자동으로 `git stash` 됩니다. 원복 후 `git stash list` 로 확인하고 `git stash pop` 으로 복귀.

**Q. 백업 파일을 다른 PC 로 옮길 수 있나요?**
- 네. 백업 폴더 전체를 압축해서 옮기면 됩니다. 다만 `fe-node-modules.tar` 의 junction 은 풀 때 Windows 환경에서만 정상 동작합니다.

**Q. D 드라이브 용량이 부족해서 백업을 줄이고 싶다면?**
- `backup-all.ps1 -SkipFeTar` 또는 `-SkipOracleDmp` 로 일부 생략 가능.
- `-DailyKeep 3` 으로 보존 개수 줄이기.

---

## 7. 관련 파일

| 파일 | 역할 |
|---|---|
| `backup-all.ps1` | 통합 백업 |
| `restore-all.ps1` | 통합 원복 |
| `install-backup-schedule.ps1` | Windows Task Scheduler 등록 (1회) |
| `start-all.ps1` | Docker + BE + FE 통합 안전 기동 |
| `stop-all.ps1` | 3종 정지 (volume 유지) |
| `check-oracle-size.ps1` | Oracle 7GB 임계 측정 |
| `bulk_load_csv.ps1` | CSV → Oracle (5건마다 size check) |
| `D:\NSCM_backup\state\last-pids.json` | start/stop 간 PID 보존 |
| `D:\NSCM_backup\retention.log` | 자동 삭제 이력 |

룰셋: `Doc/_dev_rules/30_LOCAL_BACKUP_RESTORE.md`
