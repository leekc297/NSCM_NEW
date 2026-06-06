# 02_SEED_DATA (DMF0072)

## 의도된 빈 폴더 — 클라우드 운영 데이터 사용

DMF0072 (NN Master Mapping) 의 main sheet + 4 lookup combo + Project/Item popup 은 모두 **운영 환경의 마스터 데이터** 를 SELECT:

| sheet | SELECT 대상 |
|---|---|
| main | DMF0072 NN Master 매핑 (운영 트랜잭션) |
| dataType | 정적 코드 (SP 내부 hardcode) |
| team | SCM_MST_SSO_DEPT_INFO + SCM_MST_SSO_USER_INFO |
| endCustomer | SCM_MST_SITE / SITE_ITEM |
| salesSite | 동일 |
| projectPopup | SCM_MST_SITE_ITEM + DM_MST_PROJECT |
| itemPopup | SCM_MST_SITE_ITEM + DM_MST_ITEM |

→ **클라우드 운영 데이터 그대로 사용**. 별도 SEED 불필요.

## 메타 보강 (03_META 안)

CMBO_SQL_M 의 lookup combo SQL 등록은 메타로 분류 (03_META/010 또는 030/040 안에 포함됨). 데이터 INSERT 아님.
