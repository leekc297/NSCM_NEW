# 라벨 별칭 룰 CR-092 — Valid → Active 인벤토리 (2026-10-30 · 참고용, 적용 아님)

> 생성: `scratchpad/patch7.py`(1회) · 원천 = `Doc/tobefacts/db/sheet_columns.csv`(TO-BE 메타 스냅샷) · `Doc/asisfacts/screens/*/grid_columns_asis.csv` · `tools/Harness/rules/search_cond.csv`.
> 적용은 보완 단계(🛠️ / T18 사내 메타 적용)에서 화면별로 한다 — 이 문서는 대상 규모와 사용자 확인이 필요한 복합 명칭을 보여 준다.

## 1. TO-BE 메타 그리드 컬럼 라벨이 정확히 Valid 인 행 — 5건 · 프로그램 3개 (CR-092 변경 대상 → Active)

| PROGRAM_ID | SHEET_NAME | COLUMN_NAME | COLUMN_LABEL_NAME | VISIBLE | INPUT_TP_CD |
|---|---|---|---|---|---|
| SCP0002 | Line Master | ACTIVE_FLAG | Valid* | Y | S |
| SCP0002 | Plant | ACTIVE_FLAG | Valid* | Y | S |
| SCP0080 | Group Code Management | SALES_VALID_YN | Valid | N | S |
| SSP0020 | Delegate | VALID | Valid | Y | S |
| SSP0020 | Delegated List | VALID | Valid | Y | S |

## 2. Valid 를 포함한 복합 명칭(SCP·SSP TO-BE 메타) — 38건 · **CR-092 대상 아님 — 사용자 확인 필요**(Active From/To 등으로 바꿀지)

| 라벨 | 건수 | 예 |
|---|---|---|
| VALID INFO | 11 | SCP0039/BOD / BOD Item.MASTER_INVLD_CTN, SCP0039/BOM.MASTER_INVLD_CTN, SCP0039/CAPA : Yield (Formation).MASTER_INVLD_CTN |
| Valid To* | 7 | SCP0127/main.TO_YYYYMMDD, SCP0128/main.TO_YYYYMMDD, SCP0129/main.TO_YYYYMMDD |
| Valid From* | 6 | SCP0127/main.FROM_YYYYMMDD, SCP0128/main.FROM_YYYYMMDD, SCP0129/main.FROM_YYYYMMDD |
| Route Valid | 2 | SCP0007/bod.ROUTE_VALID, SCP0030/BOD ITEM.ROUTE_VALID |
| valid_yn | 2 | SCP0023/Outsourcing Capacity.VALID_YN, SCP0040/Characteristic Capacity.VALID_YN |
| ORG_VALID_YN | 2 | SCP0027/Main.ORG_VALID_YN, SCP0048/Main.ORG_VALID_YN |
| Validation Type | 2 | SCP0039/Validation Info.SHEET_NAME, SCP0039/Validation Info.VALIDATION_TYPE |
| Prod Valid Date | 2 | SSP0021/MES Stock Detail.PROD_VALID_DATE, SSP0060/MES Stock Detail.PROD_VALID_DATE |
| BOD Valid | 1 | SCP0030/BOD ITEM.BOD_VALID |
| S_VALID_YN | 1 | SCP0033/Shipment Semi Dept Day.S_VALID_YN |
| Site Item Valid | 1 | SCP0037/Operation LT.SITE_ITEM_VALID_YN |
| BOD Item Valid | 1 | SSP0045/bodPopup.BOD_ITEM_VALID |

## 3. AS-IS 그리드 라벨에 Valid 가 든 컬럼(SCP·SSP Fact Pack) — 라벨 종류 16

| AS-IS 라벨 | 건수 | 예 | CR-092 |
|---|---|---|---|
| Valid | 32 | SCP0001/Customer.VALID_YN, SCP0001/Location.VALID_YN, SCP0001/Location(OSP).VALID_YN | 대상(→Active) |
| Valid* | 16 | SCP0002/Line Master.ACTIVE_FLAG, SCP0002/Packer.VALID_YN, SCP0002/Plant.ACTIVE_FLAG | 대상(→Active) |
| VALID INFO | 11 | SCP0039/BOD / BOD Item.MASTER_INVLD_CTN, SCP0039/BOM.MASTER_INVLD_CTN, SCP0039/CAPA : Yield (Formation).MASTER_INVLD_CTN | 복합 명칭 — 대상 아님(확인 필요) |
| Valid To* | 7 | SCP0127/PRECEDE / SAFETY STOCK DAY.TO_YYYYMMDD, SCP0128/Safety Stock.TO_YYYYMMDD, SCP0129/Demand Exception.TO_YYYYMMDD | 복합 명칭 — 대상 아님(확인 필요) |
| Valid From* | 6 | SCP0127/PRECEDE / SAFETY STOCK DAY.FROM_YYYYMMDD, SCP0128/Safety Stock.FROM_YYYYMMDD, SCP0129/Demand Exception.FROM_YYYYMMDD | 복합 명칭 — 대상 아님(확인 필요) |
| Route Valid | 2 | SCP0007/BOD.ROUTE_VALID, SCP0030/BOD ITEM.ROUTE_VALID | 복합 명칭 — 대상 아님(확인 필요) |
| valid_yn | 2 | SCP0023/Outsourcing Capacity.valid_yn, SCP0040/Characteristic Capacity.VALID_YN | 복합 명칭 — 대상 아님(확인 필요) |
| ORG_VALID_YN | 2 | SCP0027/Main.ORG_VALID_YN, SCP0048/Main.ORG_VALID_YN | 복합 명칭 — 대상 아님(확인 필요) |
| BOD Item Valid | 2 | SCP0030/BOD ITEM.BOD_ITEM_VALID, SSP0046/.BOD_ITEM_VALID | 복합 명칭 — 대상 아님(확인 필요) |
| Prod Valid Date | 2 | SSP0021/MES Stock Detail.PROD_VALID_DATE, SSP0060/MES Stock Detail.PROD_VALID_DATE | 복합 명칭 — 대상 아님(확인 필요) |
| BOD Valid* | 1 | SCP0007/BOD.BOD_VALID | 복합 명칭 — 대상 아님(확인 필요) |
| BOD Valid | 1 | SCP0030/BOD ITEM.BOD_VALID | 복합 명칭 — 대상 아님(확인 필요) |
| S_VALID_YN | 1 | SCP0033/Shipment Semi Dept Day.S_VALID_YN | 복합 명칭 — 대상 아님(확인 필요) |
| Site Item Valid | 1 | SCP0037/Operation LT.SITE_ITEM_VALID_YN | 복합 명칭 — 대상 아님(확인 필요) |
| Validation Type | 1 | SCP0039/Validation Info.VALIDATION_TYPE | 복합 명칭 — 대상 아님(확인 필요) |
| Valid Y/N* | 1 | SCP0114/.VALID_YN | 복합 명칭 — 대상 아님(확인 필요) |

## 4. 조회조건 기준표(search_cond.csv) AS-IS Valid 행 — 18건 (이미 CR-071 로 tobe_name 반영)

| 화면 | AS-IS 명칭 | TO-BE 명칭 | usage |
|---|---|---|---|
| SCP0001 | Valid | Active | USE |
| SCP0002 | Valid | Active | USE |
| SCP0007 | Valid | Active | USE |
| SCP0030 | BOD Item Valid | BOD Item Active | USE |
| SCP0027 | Valid | Active | USE |
| SCP0048 | Valid | Active | USE |
| SCP0037 | Site Item Valid | Active | USE |
| SCP0104 | Valid | Active | USE |
| SCP0120 | Valid | Active | USE |
| SCP0127 | Valid | Active | USE |
| SCP0128 | Valid | Active | USE |
| SCP0129 | Valid | Active | USE |
| SCP0130 | Valid | Active | USE |
| SCP0131 | Valid | Active | USE |
| SCP0132 | Valid | Active | USE |
| SCP0133 | Valid | Active | USE |
| SCP0033 | Valid | Active | USE |
| SSP0014 | Valid | Active | USE |

## 5. 보완 방법(화면별 · 적용은 보완 단계)

- 그리드: 해당 화면 `SHEET_COLUMNS` 메타의 `COLUMN_LABEL_NAME` 을 `Valid` → `Active` 로 UPDATE(사내 적용 절차 T18 · 다국어 LBL 을 쓰는 화면이면 LBL 원장도 함께). 화면 코드 수정으로는 해결되지 않는다(check.js LB2 는 WARN 으로만 알린다).
- 조회조건: 기준표 `tobe_name` 이 이미 Active — Form 라벨 리터럴 `_Valid` 가 남아 있으면 `Active`(check.js LB1).
- 정합검증: judge 가 화면별 잔존을 CR-092 확정규칙 행 FAIL 로 보인다(테스트결과서 그룹 9 · CheckList 조치 필요).
