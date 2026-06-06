# 02_SEED_DATA (DMF0043_01)

## 의도된 빈 폴더 — DMF0043 와 데이터 공유

DMF0043_01 (Contribute View) 는 DMF0043 (Contribute Main) 와 동일한 마스터 데이터를 사용합니다:

| 마스터 테이블 | 출처 |
|---|---|
| `DM_MST_CONTRIBUTE_VER` | DMF0043 SEED (`_artifacts/_deploy_packages/DMF0043/02_SEED_DATA/010_Seed_Version_Data.sql`) |
| `DM_MST_CONTRIBUTE_RATIO_MST` | 동 `020_Seed_Ratio_MST_DTL.sql` |
| `DM_MST_CONTRIBUTE_RATIO_DTL` | 동 `020_Seed_Ratio_MST_DTL.sql` |
| `SCM_MST_SITE_ITEM` (dim) | 동 `030_SITE_ITEM_AsIs_DimData_Import.sql` |
| `SCM_MST_SHEET_COLUMNS` | DMF0043 dedupe 적용 후 공유 |

→ **DMF0043 deploy 패키지 선적용 시 자동 충족**. 본 폴더에 별도 SEED 파일 필요 없음.

## 만약 DMF0043_01 전용 SEED 가 필요해지면

향후 별도 마스터 데이터 (예: DMF0043_01 view 모드 전용 차원 데이터) 가 생기면 본 폴더에 추가:

```
010_DMF0043_01_xxx_Seed.sql
```

현재는 빈 상태 유지.
