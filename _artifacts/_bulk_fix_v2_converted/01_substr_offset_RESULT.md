# Stage 3a — SUBSTR offset 긴급 fix 결과

작성: 2026-06-01
관련 Plan: `C:\Users\ejene\.claude\plans\hashed-fluttering-seahorse.md`

## 적용 패치

| 파일 | 줄 | Before | After |
|---|---:|---|---|
| `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0005.sql` | 1281 | `SUBSTR(p_item_id_before, 0, v_index_item_id_before)` | `SUBSTR(p_item_id_before, 1, v_index_item_id_before - 1)` |
| `04_Package_PKG_DMF0005.sql` | 1282 | `SUBSTR(p_item_id_after, 0, v_index_item_id_after)` | `SUBSTR(p_item_id_after, 1, v_index_item_id_after - 1)` |
| `04_Package_PKG_DMF0005.sql` | 1283 | `SUBSTR(p_last_updated_by, 0, v_index_last_updated_by)` | `SUBSTR(p_last_updated_by, 1, v_index_last_updated_by - 1)` |

## 미적용 (이유)

| 파일 | 줄 | 패턴 | 이유 |
|---|---:|---|---|
| `04_Package_PKG_DMF0042.sql` | 1966~1973 | `SUBSTR(vp_CELL_PER, 0, v_index_CELL_PER_PACK)` 등 3건 | **`/* ... */` 블록 주석 안 — 활성 코드 아님** |
| `04_Package_PKG_DMF0043.sql` | 1174~1690 (22건) | `SUBSTR(VP_X, 0, V_INDEX_X - 1)` | **이미 fix 완료** (`- 1` 명시). Oracle 에서 position=0 은 1 로 처리되므로 의미적으로 동일 |

## 검증

```
$ grep -nE "SUBSTR\([^,]+,\s*0\s*,\s*v_index_\w+\s*\)" To-be_v2_converted/06_Packages/*.sql -i
# DMF0042 L1966/1969/1972 만 (주석 블록) — 활성 0건

$ docker exec nscm-oracle sqlplus ... -e "ALTER PACKAGE PKG_DMF0005 COMPILE BODY;"
# 결과: STATUS=VALID (기존 DB body 이미 다른 경로로 컴파일되어 있음)
```

## 발견 — 후속 Stage 작업

DMF0005 raw 소스 파일을 다시 deploy 하면 PLS-00103 발생. 원인:
- L1272~1274: `PATINDEX` (MSSQL only) — Oracle `INSTR` 필요
- L1286~1288: `LENGTH(...) || 1` (MSSQL `||` cast) — Oracle `+ 1` 필요
- L1277: `IF LENGTH(v_index_item_id_before) > 0` (v_index 가 NUMBER 인데 LENGTH 적용)

→ Stage 3c/3e 범위에 포함. **이번 DB 상태는 prior fix 가 적용되어 VALID 유지** — 영향 없음.

## 백업

```
_artifacts/_bulk_fix_v2_converted/_backup_2026-06-01/
├── 04_Package_PKG_DMF0005.sql  (101 KB)
├── 04_Package_PKG_DMF0042.sql  (322 KB)
└── 04_Package_PKG_DMF0043.sql  (159 KB)
```

## 후속 권고

| Stage | 작업 |
|---|---|
| 3c | DMF0005 PATINDEX → INSTR 일괄 변환 |
| 3e | DMF0005 L1277 LENGTH(NUMBER) 검출 + IF 조건 보정 |
| 4 | As-Is DB cross-check 로 SP 본문 diff 시 위 3 패턴 검출 |
