"""05_DATA 제외 + zip 재생성"""
import os, shutil, zipfile, datetime as dt

OUT = 'C:/Projects/NSCM/_artifacts/_deploy_packages/SYS0013_20260615'
STAMP = '20260615'
ZIP = f'{OUT}.zip'

# 05_DATA 제거
data_dir = f'{OUT}/05_DATA'
if os.path.exists(data_dir): shutil.rmtree(data_dir)

# README 재작성
with open(f'{OUT}/06_DEPLOY/README.md', 'w', encoding='utf-8') as f:
    f.write(f"""# SYS0013 (Dynamic Query List) — 클라우드 이관 패키지

**빌드일자**: {dt.datetime.now().isoformat()}
**원본 환경**: 121.162.245.167:2521/ESSCMD (사내 검증 완료)

## 구조
- `01_FE/` — Frontend 5 파일 (수동 배포)
- `02_DB_DDL/` — PKG + 7 standalone SP (SCM_MGR)
- `03_GRANT_SYNONYM/` — SCMD_APP 권한 (Step 1: SCM_MGR / Step 2: SCMD_APP)
- `04_META/` — 8 메타 테이블 (멱등 NOT EXISTS)
- `06_DEPLOY/` — apply.sh + README

⚠ **DQ 데이터 (DQ_LIST/COLUMN/PARAMETER/USER_GROUP/EXECUTE_H) 는 본 패키지에서 제외** — 클라우드 환경에서 별도 관리/시드.

## 적용 순서 (수동)

### 1) DB — SCM_MGR user
```
sqlplus SCM_MGR/<PWD>@<DSN>
@02_DB_DDL/01_PKG_SYS0013_spec.sql
@02_DB_DDL/02_PKG_SYS0013_body.sql
@02_DB_DDL/03_SYS0013_GET_HISTORY.sql ~ 09_SYS0013_EXECUTE_HIST.sql (7개 순차)
@03_GRANT_SYNONYM/01_GRANT_SCMD_APP.sql
@04_META/01_MNU_M.sql ~ 08_SHEET_COLUMNS.sql (8개 순차)
```

### 2) DB — SCMD_APP user (SYNONYM 만)
```
sqlplus SCMD_APP/<PWD>@<DSN>
@03_GRANT_SYNONYM/02_SYNONYM_SCMD_APP.sql
```

### 3) FE — 5 파일 수동 배포
- `01_FE/useTabBtnPermissions.ts` → `nscm-fe/packages/shared/src/hooks/`
- `01_FE/shared_hooks_index.ts` → `nscm-fe/packages/shared/src/hooks/index.ts`
- `01_FE/DynamicQuery.tsx` → `nscm-fe/features/admin/src/pages/dynamic-query/`
- `01_FE/DynamicQueryMainGrid.tsx` → `nscm-fe/features/admin/src/pages/dynamic-query/components/`
- `01_FE/dynamic-query.constants.ts` → `nscm-fe/features/admin/src/pages/dynamic-query/`

### 4) 검증
- 클라우드 FE 재빌드/배포
- F12 → Clear site data + 재로그인
- SYS0013 메뉴 진입 → main grid + columns/parameters/history tab 동작
""")

# apply.sh 재작성
with open(f'{OUT}/06_DEPLOY/apply.sh', 'w', encoding='utf-8', newline='\n') as f:
    f.write("""#!/bin/bash
# SYS0013 클라우드 적용 — DB 만 (FE 별도 배포)
set -e
SCM_PWD=$1; APP_PWD=$2; DSN=$3
echo "=== Step 1: SCM_MGR — DDL + GRANT + META ==="
for f in ../02_DB_DDL/*.sql ../03_GRANT_SYNONYM/01_GRANT_SCMD_APP.sql ../04_META/*.sql; do
  echo "  apply: $f"
  tr -d '\\r' < "$f" | sqlplus -L -S "SCM_MGR/\\"$SCM_PWD\\"@$DSN" || exit 1
done
echo "=== Step 2: SCMD_APP — SYNONYM ==="
tr -d '\\r' < ../03_GRANT_SYNONYM/02_SYNONYM_SCMD_APP.sql | sqlplus -L -S "SCMD_APP/\\"$APP_PWD\\"@$DSN" || exit 1
echo "Done. FE: 01_FE/ 5 파일을 수동 배포."
""")

# MANIFEST 재생성
files = []
for root, _, fns in os.walk(OUT):
    for fn in fns:
        full = os.path.join(root, fn)
        if fn != 'MANIFEST.txt': files.append(full)
files.sort()
with open(f'{OUT}/MANIFEST.txt', 'w', encoding='utf-8') as f:
    f.write(f"SYS0013 Deploy Package — {STAMP}\n")
    f.write(f"Total files: {len(files)+1}\nDB 데이터 (DQ 5 테이블) 제외 — 클라우드 별도 관리\n\n")
    for fp in files:
        rel = fp.replace(OUT, '').lstrip('/').lstrip(os.sep).replace(os.sep, '/')
        size = os.path.getsize(fp)
        f.write(f"  {rel:60s} {size:>10} bytes\n")

# zip
if os.path.exists(ZIP): os.remove(ZIP)
with zipfile.ZipFile(ZIP, 'w', zipfile.ZIP_DEFLATED) as zf:
    for root, _, fns in os.walk(OUT):
        for fn in fns:
            full = os.path.join(root, fn)
            arc = full.replace(OUT, f'SYS0013_{STAMP}').replace(os.sep, '/')
            zf.write(full, arc)

print(f'Zip: {ZIP}')
print(f'Size: {os.path.getsize(ZIP)/1024:.1f} KB')
