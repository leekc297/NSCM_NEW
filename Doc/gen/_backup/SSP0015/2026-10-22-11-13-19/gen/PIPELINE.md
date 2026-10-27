# PIPELINE SSP0015 — 2026-10-21 23:43 ⚠ 사람 확인 필요

페이지: `C:\Projects\NSCM\nscm-fe\features\shipping\src\pages\shipment-plan-mobility-it` · FE 게이트 BLOCK/WARN - · DoD - · PKG 게이트 - · 수선 -

| 단계 | 결과 | 소요 |
|---|---|---|
| 1 FE 골격 생성 + nscm-fe 적용(gen --apply) | exit 3 | 2s |

## 다음 할 일

- E2E 스모크: FE/BE 기동 후 `tools\E2E\run-e2e.cmd smoke SSP0015`
- DB 반영: python tools\DbConn\run_sql.py Doc\gen\SSP0015\SSP0015_PKG.sql --commit → SSP0015_registration.sql(미리보기 후 --commit)

## 단계 로그(꼬리)

### 1 FE 골격 생성 + nscm-fe 적용(gen --apply)
```
To-Be 메뉴 메타: SSP0015 → feature=shipping pageDir=shipment-plan-mobility-it 상위=Shipping_Schedule USE_YN=Y (Shipment Plan(Mobility & IT))
SSP0015 → C:\Projects\NSCM\Doc\gen\SSP0015  (16 files)  page=features\shipping\src\pages\shipment-plan-mobility-it  fields=17 buttons=6 sheets=15+0popup procs=39 handlers=25 tcs=121 V=16 E=127
이미 존재: C:\Projects\NSCM\nscm-fe\features\shipping\src\pages\shipment-plan-mobility-it — 적용하지 않음(수동 병합). 골격만 있는 상태면 --overwrite 로 재적용
```
