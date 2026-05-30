# 30. 로컬 환경 통합 백업/원복 룰

> 작성: 2026-05-30
> 적용: NSCM 모노레포 로컬 (Docker Oracle + BE + FE)
> 백업 위치: `D:\NSCM_backup\`

---

## 1. 배경 / 필요성

NSCM 로컬 환경은 4개의 독립 자산으로 구성됨:

1. **소스 코드** — git 관리 (GitHub `leekc297/NSCM` 백업 됨)
2. **FE `node_modules`** — 사내 registry 접속 불가 환경. pnpm install 으로 재생성 불가
3. **BE config-local + 빌드 산출물** — `nscm-be/src/main/resources/config/config-local.yml` 등
4. **Docker Oracle PDB FREEPDB1** — DDL + 데이터 (113 테이블 적재됨)

한 자산이 손상되면 다른 자산도 함께 손상되는 경우가 잦음 (예: `pnpm install` 사고 → FE node_modules 폭발 + BE 가 사용하는 DB 컬럼 변경 시점과 어긋남). 따라서 **4종을 한 묶음으로 백업/원복** 하는 SOP 가 필수.

---

## 2. 백업 구성 (4종 묶음)

| # | 대상 | 방법 | 산출물 | 예상 크기 |
|---:|---|---|---|---|
| 1 | 소스 전체 git 히스토리 | `git bundle create --all` | `source.bundle` | ~200 MB |
| 2 | FE node_modules + .local-packs | `tar -cf` (junction 보존) | `fe-node-modules.tar` | ~1.5 GB |
| 3 | FE/BE 환경 파일 | 직접 복사 | `fe-config\`, `be-config\` | <10 MB |
| 4 | Docker Oracle (PDB FREEPDB1) | `expdp FULL=Y COMPRESSION=ALL` | `oracle-full.dmp` + `.log` | ~3-6 GB |
| 5 | 메타데이터 | JSON | `manifest.json` + `git-head.txt` + `git-dirty.txt` | <1 KB |
| **합계** | | | | **~5-8 GB** |

---

## 3. 저장 위치 + 보존 정책

### 위치
- 기본: **`D:\NSCM_backup\`** (사용자 결정 2026-05-30)
- C 드라이브와 분리하여 디스크 손상 시 보호.

### 폴더 구조
```
D:\NSCM_backup\
  ├── daily\YYYY-MM-DD_HHMM\         (Task Scheduler 자동, 매일 02:00)
  ├── manual\YYYY-MM-DD_HHMM[_<label>]\   (수동 trigger)
  ├── state\last-pids.json           (start-all/stop-all 가 갱신)
  └── retention.log                  (자동 삭제 이력)
```

### 보존 정책
- `daily\` : 최근 **7개** 보존. 새 daily 가 추가될 때 가장 오래된 1개 자동 삭제.
- `manual\` : `CreationTime` 기준 **30일** 후 자동 삭제.
- **자동 삭제 시점**: backup-all.ps1 가 매 실행마다 retention 정책 적용.
- **긴급 보호**: 폴더 이름에 `KEEP_` 접두사가 있으면 영구 보관 (스크립트가 무시).

---

## 4. Trigger 방식

### 4.1 자동 (Windows Task Scheduler)

- Task 이름: **`NSCM_Daily_Backup`**
- 매일 **02:00** 실행
- LogonType: `S4U` (사용자 로그아웃 상태에서도 동작)
- 실패 시 10분 간격 최대 3회 재시도
- 1회 등록: `_artifacts/local-docker-oracle/install-backup-schedule.ps1`

### 4.2 수동 (Claude 작업 / 사용자 직접)

- 사용자 키워드 `"백업해줘"` / `"원복해줘"` 감지 → `backup-all.ps1` / `restore-all.ps1` 호출
- Claude 메모리 `feedback_backup_trigger.md` 에 등록
- 큰 작업 직전 권장: `.\backup-all.ps1 -Label pre-major-refactor`

### 4.3 사전 사고 보장 (이상적)

서버 기동 직전 변경 사항이 클 때 (PROC 메타 / DDL / FE 풀스택 등):
- 사용자: `"백업 받고 서버 기동해줘"` 패턴 사용
- Claude 가 `backup-all.ps1 -Label pre-restart` 호출 후 `start-all.ps1`

---

## 5. 원복 (Restore) 흐름

### 5.1 표준 흐름

```
manifest.json 정합성 확인
  → stop-all.ps1 -Force
  → git stash + git fetch <bundle> + git reset --hard
  → FE node_modules rd /s /q + tar -xf
  → BE config 복사
  → docker compose down -v + up -d + impdp FULL=Y
  → start-all.ps1 -SkipDocker
```

### 5.2 안전장치
- **사용자 확인 prompt**: `YES` 입력 시에만 진행 (-Force 로 우회 가능)
- **현재 변경사항 자동 stash**: 원복 후 `git stash pop` 으로 복귀 가능
- **DryRun 모드**: `-DryRun` 으로 실제 변경 없이 액션만 출력
- **부분 원복**: `-SkipSource` / `-SkipFeTar` / `-SkipOracleDmp` 옵션

### 5.3 절대 금지
- 원복 중 사용자 prompt 없이 `docker compose down -v` 실행 (volume 삭제)
- 사용자 확인 없는 강제 `git reset --hard` (현재 작업 손실)

---

## 6. Claude 행동 룰

### 6.1 백업 trigger 키워드 감지 시
- `"백업해줘"` / `"백업해주세요"` → `backup-all.ps1` 호출
- `"백업 받고 서버 기동해줘"` → `backup-all.ps1 -Label pre-restart` → `start-all.ps1`
- `"원복해줘"` / `"복구해줘"` → `restore-all.ps1 -BackupDir ...` 호출 (사용자에게 BackupDir 확인)

### 6.2 절대 금지
- 사용자 확인 없는 `restore-all.ps1` 호출 (volume 삭제 위험)
- `D:\NSCM_backup\` 외 경로에 백업 시도 (룰 위반)
- `nscm-fe.7z` 같은 outdated 백업으로 원복 (manifest.json 없음 → 정합성 미보장)

### 6.3 사용자에게 사전 보고 의무
백업 시작 전 콘솔에:
- 예상 시간 (~40~70분)
- 예상 용량 (~5-8GB)
- 영향 받는 파일

원복 시작 전 콘솔에:
- 현재 작업 손실 가능성
- Oracle volume 완전 reset 됨
- 사용자 확인 `YES` 요구

---

## 7. 사용 도구 / 파일

| 파일 | 역할 |
|---|---|
| `_artifacts/local-docker-oracle/backup-all.ps1` | 통합 백업 |
| `_artifacts/local-docker-oracle/restore-all.ps1` | 통합 원복 |
| `_artifacts/local-docker-oracle/install-backup-schedule.ps1` | Task Scheduler 등록 (1회) |
| `_artifacts/local-docker-oracle/README_BACKUP_RESTORE.md` | 사용자 운영 가이드 |
| `D:\NSCM_backup\` | 백업 저장소 |
| `D:\NSCM_backup\state\last-pids.json` | start-all / stop-all 간 PID 보존 |
| `D:\NSCM_backup\retention.log` | 자동 삭제 이력 |

---

## 8. Cross-Reference

- 룰 28 `28_GIT_MULTI_REMOTE.md` — GitHub 백업 (소스만 — 본 룰은 환경 전체)
- 룰 29 `29_LOCAL_DB_CSV_IMPORT.md` — Oracle 데이터 적재 (백업은 적재 결과를 보존)
- 메모리 `feedback_pnpm_install_avoidance.md` — pnpm install 환경 파괴 방지 (백업이 마지막 안전망)
- 메모리 `project_fe_node_modules_manual_hoist.md` — FE node_modules 손상 시 복구 (tar 원복이 더 안전)

---

## 9. 변경 이력

- 2026-05-30 신규 작성 — 사용자 결정: D:\NSCM_backup\, Task Scheduler 02:00 야간, daily 7개 보존
