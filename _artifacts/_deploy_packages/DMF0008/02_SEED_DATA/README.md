# 02_SEED_DATA (DMF0008)

## 의도된 빈 폴더 — 클라우드 운영 데이터 사용

DMF0008 (ERP-EDI Master) 는 4 sheet (repair / sspm / summary / salesSite) + Update History 가 모두 **운영 환경의 마스터/트랜잭션 데이터** 를 SELECT 합니다:

| sheet | SELECT 대상 |
|---|---|
| repair | `DM_DNM_EDI_REPAIR` (운영 트랜잭션) |
| sspm | `SCM_MST_SALES_SITE` + `SCM_MST_SITE_ITEM` (운영 마스터) |
| summary | `DM_DNM_EDI_SUMMARY` (운영 트랜잭션) |
| salesSite | `SCM_MST_SALES_SITE` (운영 마스터) |
| updateHistory | `SCM_ADM_SYS_LOG` (운영 로그) |

→ **클라우드의 운영 데이터 그대로 사용** (별도 SEED 불필요).

## 만약 DMF0008 전용 차원 데이터 필요해지면

DM_DNM_EDI_* 의 reference 데이터 또는 SITE 차원 변경 시 본 폴더에 추가:

```
010_DMF0008_xxx_Seed.sql
```

현재는 빈 상태 유지.
