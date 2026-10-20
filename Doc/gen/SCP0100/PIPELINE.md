# PIPELINE SCP0100 — 2026-10-20 23:47 ✅ 게이트 PASS

페이지: `C:\Projects\NSCM\nscm-fe\features\supply\src\pages\global-psi-report` · FE 게이트 BLOCK/WARN 0/2 · DoD 29/29 · PKG 게이트 0/0 · 수선 SCP0100=PASS · SCP0100:PKG=PASS

| 단계 | 결과 | 소요 |
|---|---|---|
| 1 FE 골격 생성 + nscm-fe 적용(gen --apply) | exit 3 | 5s |
| 2 Oracle 메타 등록 SQL(gen-register-sql) | OK | 2s |
| 3 Oracle PKG 골격(gen-pkg) | OK | 1s |
| 4 FE 수선 루프(Claude ×3 + 게이트 --final) | OK | 5114s |
| 5 PKG 이식 루프(Claude ×3 + check-pkg) | OK | 925s |
| 6 E2E 스펙 생성(gen-e2e) | OK | 1s |
| 7 대사표 갱신(recon) | OK | 16s |

## 다음 할 일

- E2E 스모크: FE/BE 기동 후 `tools\E2E\run-e2e.cmd smoke SCP0100`
- DB 반영: python tools\DbConn\run_sql.py Doc\gen\SCP0100\SCP0100_PKG.sql --commit → SCP0100_registration.sql(미리보기 후 --commit)

## 단계 로그(꼬리)

### 1 FE 골격 생성 + nscm-fe 적용(gen --apply)
```
To-Be 메뉴 메타: SCP0100 → feature=supply pageDir=global-psi-report 상위=Supply_Plan USE_YN=Y (Global PSI New)
SCP0100 → C:\Projects\NSCM\Doc\gen\SCP0100  (13 files)  page=features\supply\src\pages\global-psi-report  fields=17 buttons=5 sheets=3+0popup procs=4 handlers=18 tcs=42 V=0 E=0
이미 존재: C:\Projects\NSCM\nscm-fe\features\supply\src\pages\global-psi-report — 적용하지 않음(수동 병합). 골격만 있는 상태면 --overwrite 로 재적용
```

### 2 Oracle 메타 등록 SQL(gen-register-sql)
```
SCP0100_registration.sql → C:\Projects\NSCM\Doc\gen\SCP0100  (PROC 4 · 시트컬럼 33+0 · 그룹 4 · 상위메뉴 확정)
```

### 3 Oracle PKG 골격(gen-pkg)
```
SCP0100_PKG.sql → C:\Projects\NSCM\Doc\gen\SCP0100  (PROC 3, 메모 3)
```

### 4 FE 수선 루프(Claude ×3 + 게이트 --final)
```
SCP0100 round 1: BLOCK 4 / WARN 2
  SCP0100 round 2: BLOCK 0 / WARN 2
[PASS] SCP0100  rounds=2 BLOCK=0 WARN=2
요약 → C:\Projects\NSCM\Doc\gen\_repair_summary.csv
```

### 5 PKG 이식 루프(Claude ×3 + check-pkg)
```
SCP0100 round 1: BLOCK 0 / WARN 0
[PASS] SCP0100  rounds=1 BLOCK=0 WARN=0
요약 → C:\Projects\NSCM\Doc\gen\_repair_summary.csv
```

### 6 E2E 스펙 생성(gen-e2e)
```
SCP0100 테스트 모드 division (auto(Division 조회조건 있음)) → 계정 5: dodae, bottle, coeogus, jaeuk.shin, hongjae.kim
  SCP0100 → SCP0100  smoke/crud(read-only)/auth(5계정)/authcrud(기대 있음 5계정)  메타컬럼 Y
스펙 1화면 × 4(smoke·crud·auth·authcrud) → C:\Projects\NSCM\Doc\e2e\specs  (계정×DIV 매트릭스 7행)
```

### 7 대사표 갱신(recon)
```
대사표: 화면 455 (대상외 315 · 대상외-구현됨 86 · OK 34 · ToBe신규 8 · 누락-ToBe 6 · 재확인 3 · 누락-파싱 3)
       SP 2017 (대상외 / 목록외 965 · 공통(제외) 375 · OK / 목록외 371 · OK 192 · 누락-ToBe 74 · 누락-ToBe / 파싱미검출(타화면 검출) 13 · OK / 파싱미검출(타화면 검출) 11 · 누락-ToBe / 목록외 7 · 누락-ToBe / 파싱미검출(전체 미검출) 5 · 공통(제외) / 파싱미검출(타화면 검출) 3 · OK / 파싱미검출(전체 미검출) 1)
       시트 951 (OK 710 · 대상외 126 · 누락-시트 93 · 누락-ToBe화면 22)
→ C:\Projects\NSCM\Doc\recon\대사표.md / index.html
```
