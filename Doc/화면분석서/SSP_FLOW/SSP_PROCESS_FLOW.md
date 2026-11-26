# SSP 프로세스 흐름(Process Flow) — 2026-11-23 13:44 생성

- **업무 프로세스(운영 순서)의 기준 = `SSP_REF_PROCESS.md`**(PI SSP CUTOFF Process 22 Seq · 통합테스트 흐름 단계(V2 2026-11-12) — 사용자 제공 기존 분석 자료). 이 문서는 SP 본문에서 뽑은 **데이터 의존**을 보여 주며 운영 순서를 대신하지 않는다
- 근거: 화면 A 가 쓰는(W) 테이블을 화면 B 가 읽으면(R) A → B 선행(데이터 의존) · 공통 마스터·로그 표는 제외 · 메뉴 그룹 = TO-BE menu.csv(Shipping Master / Shipping Schedule) · AS-IS 전용 화면은 별도 묶음
- 이 순서는 데이터가 흐르는 방향이지 운영 절차서의 순서가 아니다 — 업무 절차 확정은 화면정의서 재작성 때 담당자 확인

## 1. TO-BE 메뉴 구조

```mermaid
flowchart LR
  M0["Shipping"]
  M0 --> Shipping_Master["Shipping Master"]
  Shipping_Master --> SCP0005["SCP0005 Distribution Route"]
  Shipping_Master --> SSP0014["SSP0014 Shipment Model PIC"]
  Shipping_Master --> SCP0028["SCP0028 Shipment Lot Size"]
  Shipping_Master --> SSP0020["SSP0020 Delegate"]
  Shipping_Master --> SSP0024["SSP0024 Shipment Master Electrode"]
  Shipping_Master --> SSP0025["SSP0025 Shipment Requestor PIC"]
  Shipping_Master --> SCP0033["SCP0033 Shipment Semi Dept Day"]
  Shipping_Master --> SSP0005["SSP0005 Shipment Working Day"]
  M0 --> Shipping_Schedule["Shipping Schedule"]
  Shipping_Schedule --> DMF0045["DMF0045 Shipment Request(Auto &amp; ESS)"]
  Shipping_Schedule --> SSP0015["SSP0015 Shipment Plan(Mobility &amp; IT)"]
  Shipping_Schedule --> SSP0023["SSP0023 Shipment Plan(Electrode)"]
  Shipping_Schedule --> SSP0012["SSP0012 Shipment Plan Detail"]
  Shipping_Schedule --> SSP0060["SSP0060 Shipment Plan(Auto &amp; ESS)-WA_UC"]
  Shipping_Schedule --> SSP0019["SSP0019 Shipment Change History"]
  Shipping_Schedule --> SSP0021["SSP0021 Shipment Plan(Auto &amp; ESS)"]
  Shipping_Schedule --> SSP0026["SSP0026 Shipment Request(Mobility &amp; IT)"]
  Shipping_Schedule --> SSP0022["SSP0022 Shipment Request(Electrode)"]
  Shipping_Schedule --> SSP0200["SSP0200 Shipment Change Request"]
  Shipping_Schedule --> SSP0003["SSP0003 Shipment Change Request Confirm"]
  Shipping_Schedule --> SSP0017["SSP0017 Inventory Raw(Mobility &amp; IT)"]
  Shipping_Schedule --> SSP0201["SSP0201 Shipment Change Request(Packer)"]
  Shipping_Schedule --> SSP0202["SSP0202 Shipment Change Request Confirm(Packer)"]
  Shipping_Schedule --> SSP0045["SSP0045 Shipment Request SEMI"]
```

## 2. 업무 단계 흐름(데이터 의존 집계) — 단계 = 화면 이름·TO-BE 메뉴명 규칙 · 간선 라벨 = 선행 단계 화면이 쓰고 후행 단계 화면이 읽는 (화면쌍, 테이블) 수

- 노드 = 단계(화면 수 · TO-BE 수) · 실선 = (화면쌍,테이블) 5 이상 · 점선 = 5 미만 · 화면 단위는 §2-1(단계별)·§2-2(TO-BE 화면만) · 전체 쌍은 §3 표

```mermaid
flowchart LR
  ST_Master["Master<br/>9화면 · TO-BE 8"]
  ST_Request["Request<br/>6화면 · TO-BE 4"]
  ST_Plan["Plan<br/>13화면 · TO-BE 3"]
  ST_Confirm["Confirm<br/>3화면 · TO-BE 2"]
  ST_Change["Change<br/>5화면 · TO-BE 3"]
  ST_ChangeConfirm["ChangeConfirm<br/>2화면 · TO-BE 2"]
  ST_Analysis["Analysis<br/>5화면 · TO-BE 1"]
  ST_Plan -->|72| ST_Change
  ST_Change -->|61| ST_Plan
  ST_Plan -->|60| ST_Request
  ST_ChangeConfirm -->|40| ST_Plan
  ST_Plan -->|36| ST_ChangeConfirm
  ST_Plan -->|34| ST_Confirm
  ST_Master -->|26| ST_Plan
  ST_ChangeConfirm -->|24| ST_Change
  ST_Change -->|21| ST_Request
  ST_Change -->|20| ST_ChangeConfirm
  ST_Confirm -->|19| ST_Plan
  ST_ChangeConfirm -->|18| ST_Request
  ST_Request -->|16| ST_Plan
  ST_Change -->|16| ST_Confirm
  ST_Plan -->|14| ST_Analysis
  ST_ChangeConfirm -->|12| ST_Confirm
  ST_Confirm -->|12| ST_Change
  ST_Master -->|9| ST_Request
  ST_Confirm -->|8| ST_Request
  ST_Master -->|8| ST_Change
  ST_Confirm -->|6| ST_ChangeConfirm
  ST_Master -->|6| ST_ChangeConfirm
  ST_Master -->|6| ST_Confirm
  ST_Request -->|5| ST_ChangeConfirm
  ST_Request -->|5| ST_Confirm
  ST_Change -.->|4| ST_Analysis
  ST_ChangeConfirm -.->|4| ST_Analysis
  ST_Master -.->|3| ST_Analysis
  ST_Confirm -.->|2| ST_Analysis
  ST_Change -.->|1| ST_Master
```

### 2-1. 단계별 화면 의존 — 단계 안 화면은 개별, 다른 단계는 한 노드로 접음(라벨 = 테이블 수)

#### Master (9화면)

```mermaid
flowchart LR
  SCP0005["SCP0005<br/>DistributionRoute ★TO-BE"]
  SSP0014["SSP0014<br/>ShipmentModelPIC ★TO-BE"]
  SCP0028["SCP0028<br/>Shipment_Lot_Size ★TO-BE"]
  SSP0020["SSP0020<br/>Delegate ★TO-BE"]
  SSP0024["SSP0024<br/>ItembyDivisionPopup / Shipme ★TO-BE"]
  SSP0025["SSP0025<br/>ItembyDivisionPopup / Shipme ★TO-BE"]
  SCP0033["SCP0033<br/>Shipment_semi_dept_day ★TO-BE"]
  SSP0005["SSP0005<br/>ShipmentWorkingDay ★TO-BE"]
  SSP0100["SSP0100<br/>LTManagement"]
  IN_Change["◀ Change 단계"]
  OUT_Analysis["Analysis 단계 ▶"]
  OUT_Change["Change 단계 ▶"]
  OUT_ChangeConfirm["ChangeConfirm 단계 ▶"]
  OUT_Confirm["Confirm 단계 ▶"]
  OUT_Plan["Plan 단계 ▶"]
  OUT_Request["Request 단계 ▶"]
  IN_Change -.->|1| SSP0014
  SCP0005 -.->|2| OUT_Analysis
  SCP0005 -.->|1| OUT_Change
  SCP0005 -.->|2| OUT_ChangeConfirm
  SCP0005 -.->|2| OUT_Confirm
  SCP0005 -.->|6| OUT_Plan
  SCP0005 -.->|2| OUT_Request
  SCP0028 -.->|1| OUT_Analysis
  SCP0028 -.->|1| OUT_Confirm
  SCP0028 -.->|2| OUT_Plan
  SSP0005 -.->|1| OUT_Plan
  SSP0005 -.->|3| OUT_Request
  SSP0014 -.->|4| OUT_Change
  SSP0014 -.->|2| OUT_ChangeConfirm
  SSP0014 -.->|1| OUT_Confirm
  SSP0014 -.->|6| OUT_Plan
  SSP0014 -.->|1| OUT_Request
  SSP0020 -.->|3| OUT_Change
  SSP0020 -.->|2| OUT_ChangeConfirm
  SSP0020 -.->|1| OUT_Confirm
  SSP0020 -.->|5| OUT_Plan
  SSP0020 -.->|1| OUT_Request
  SSP0024 -.->|1| OUT_Request
  SSP0025 -.->|1| OUT_Confirm
  SSP0025 -.->|6| OUT_Plan
  SSP0025 -.->|1| OUT_Request
```

#### Request (6화면)

```mermaid
flowchart LR
  DMF0045["DMF0045<br/>ShipmentRequest / ShipmentRe ★TO-BE"]
  SSP0026["SSP0026<br/>BodItemPopup / ItembyDivisio ★TO-BE"]
  SSP0022["SSP0022<br/>BodItemPopup / ShipmentReque ★TO-BE"]
  SSP0045["SSP0045<br/>ShipmentRequest ★TO-BE"]
  SSP0016["SSP0016<br/>ShipmentRequest"]
  SSP0046["SSP0046<br/>GetBODItemPrjRoutePopup / It"]
  IN_Change["◀ Change 단계"]
  IN_ChangeConfirm["◀ ChangeConfirm 단계"]
  IN_Confirm["◀ Confirm 단계"]
  IN_Master["◀ Master 단계"]
  IN_Plan["◀ Plan 단계"]
  OUT_ChangeConfirm["ChangeConfirm 단계 ▶"]
  OUT_Confirm["Confirm 단계 ▶"]
  OUT_Plan["Plan 단계 ▶"]
  DMF0045 -->|1| SSP0026
  DMF0045 -->|1| SSP0045
  DMF0045 -->|1| SSP0046
  SSP0026 -->|1| DMF0045
  SSP0026 -->|1| SSP0045
  SSP0026 -->|1| SSP0046
  SSP0045 -->|1| DMF0045
  SSP0045 -->|1| SSP0026
  SSP0045 -->|1| SSP0046
  SSP0046 -->|1| DMF0045
  SSP0046 -->|1| SSP0026
  SSP0046 -->|1| SSP0045
  IN_Change -.->|4| DMF0045
  IN_Change -.->|3| SSP0022
  IN_Change -.->|7| SSP0026
  IN_Change -.->|3| SSP0045
  IN_Change -.->|4| SSP0046
  IN_ChangeConfirm -.->|4| DMF0045
  IN_ChangeConfirm -.->|2| SSP0022
  IN_ChangeConfirm -.->|5| SSP0026
  IN_ChangeConfirm -.->|3| SSP0045
  IN_ChangeConfirm -.->|4| SSP0046
  IN_Confirm -.->|2| DMF0045
  IN_Confirm -.->|1| SSP0022
  IN_Confirm -.->|2| SSP0026
  IN_Confirm -.->|1| SSP0045
  IN_Confirm -.->|2| SSP0046
  IN_Master -.->|1| DMF0045
  IN_Master -.->|1| SSP0016
  IN_Master -.->|4| SSP0022
  IN_Master -.->|2| SSP0026
  IN_Master -.->|1| SSP0046
  IN_Plan -.->|13| DMF0045
  IN_Plan -.->|2| SSP0016
  IN_Plan -.->|7| SSP0022
  IN_Plan -.->|15| SSP0026
  IN_Plan -.->|10| SSP0045
  IN_Plan -.->|13| SSP0046
  DMF0045 -.->|1| OUT_ChangeConfirm
  DMF0045 -.->|1| OUT_Confirm
  DMF0045 -.->|3| OUT_Plan
  SSP0022 -.->|1| OUT_ChangeConfirm
  SSP0022 -.->|1| OUT_Confirm
  SSP0022 -.->|2| OUT_Plan
  SSP0026 -.->|1| OUT_ChangeConfirm
  SSP0026 -.->|1| OUT_Confirm
  SSP0026 -.->|5| OUT_Plan
  SSP0045 -.->|1| OUT_ChangeConfirm
  SSP0045 -.->|1| OUT_Confirm
  SSP0045 -.->|3| OUT_Plan
  SSP0046 -.->|1| OUT_ChangeConfirm
  SSP0046 -.->|1| OUT_Confirm
  SSP0046 -.->|3| OUT_Plan
```

#### Plan (13화면)

```mermaid
flowchart LR
  SSP0015["SSP0015<br/>ShipmentPSI / ShipmentPSICom ★TO-BE"]
  SSP0023["SSP0023<br/>ShipmentPlanElectrode ★TO-BE"]
  SSP0021["SSP0021<br/>ShipmentPlan ★TO-BE"]
  SSP0006["SSP0006<br/>Plan_Problem"]
  SSP0007["SSP0007<br/>ProductionPlan"]
  SSP0008["SSP0008<br/>ProductionPlanLine"]
  SSP0009["SSP0009<br/>Shipment_Plan_FG"]
  SSP0010["SSP0010<br/>Shipment_Plan_SEMI"]
  SSP0011["SSP0011<br/>PSI"]
  SSP0013["SSP0013<br/>ShipmentPlanAdjustment"]
  SSP0018["SSP0018<br/>ProductionPlanOSP"]
  SSP0027["SSP0027<br/>ShipmentPlanEss"]
  SSP0029["SSP0029<br/>ShipmentPlanPack / ShipmentP"]
  IN_Change["◀ Change 단계"]
  IN_ChangeConfirm["◀ ChangeConfirm 단계"]
  IN_Confirm["◀ Confirm 단계"]
  IN_Master["◀ Master 단계"]
  IN_Request["◀ Request 단계"]
  OUT_Analysis["Analysis 단계 ▶"]
  OUT_Change["Change 단계 ▶"]
  OUT_ChangeConfirm["ChangeConfirm 단계 ▶"]
  OUT_Confirm["Confirm 단계 ▶"]
  OUT_Request["Request 단계 ▶"]
  SSP0007 -->|1| SSP0021
  SSP0013 -->|4| SSP0015
  SSP0013 -->|3| SSP0021
  SSP0013 -->|3| SSP0023
  SSP0013 -->|4| SSP0027
  SSP0013 -->|4| SSP0029
  SSP0015 -->|3| SSP0013
  SSP0015 -->|4| SSP0021
  SSP0015 -->|3| SSP0023
  SSP0015 -->|4| SSP0027
  SSP0015 -->|7| SSP0029
  SSP0021 -->|3| SSP0013
  SSP0021 -->|3| SSP0015
  SSP0021 -->|3| SSP0023
  SSP0021 -->|4| SSP0027
  SSP0021 -->|3| SSP0029
  SSP0023 -->|3| SSP0013
  SSP0023 -->|3| SSP0015
  SSP0023 -->|3| SSP0021
  SSP0023 -->|4| SSP0027
  SSP0023 -->|3| SSP0029
  SSP0027 -->|3| SSP0013
  SSP0027 -->|3| SSP0015
  SSP0027 -->|3| SSP0021
  SSP0027 -->|3| SSP0023
  SSP0027 -->|3| SSP0029
  SSP0029 -->|3| SSP0013
  SSP0029 -->|7| SSP0015
  SSP0029 -->|4| SSP0021
  SSP0029 -->|3| SSP0023
  SSP0029 -->|4| SSP0027
  IN_Change -.->|10| SSP0013
  IN_Change -.->|10| SSP0015
  IN_Change -.->|10| SSP0021
  IN_Change -.->|10| SSP0023
  IN_Change -.->|11| SSP0027
  IN_Change -.->|10| SSP0029
  IN_ChangeConfirm -.->|6| SSP0013
  IN_ChangeConfirm -.->|7| SSP0015
  IN_ChangeConfirm -.->|6| SSP0021
  IN_ChangeConfirm -.->|6| SSP0023
  IN_ChangeConfirm -.->|8| SSP0027
  IN_ChangeConfirm -.->|7| SSP0029
  IN_Confirm -.->|3| SSP0013
  IN_Confirm -.->|3| SSP0015
  IN_Confirm -.->|3| SSP0021
  IN_Confirm -.->|3| SSP0023
  IN_Confirm -.->|4| SSP0027
  IN_Confirm -.->|3| SSP0029
  IN_Master -.->|3| SSP0013
  IN_Master -.->|4| SSP0015
  IN_Master -.->|5| SSP0021
  IN_Master -.->|5| SSP0023
  IN_Master -.->|5| SSP0027
  IN_Master -.->|4| SSP0029
  IN_Request -.->|5| SSP0015
  IN_Request -.->|5| SSP0021
  IN_Request -.->|1| SSP0023
  IN_Request -.->|5| SSP0029
  SSP0007 -.->|1| OUT_Confirm
  SSP0007 -.->|2| OUT_Request
  SSP0009 -.->|1| OUT_Analysis
  SSP0010 -.->|1| OUT_Analysis
  SSP0010 -.->|1| OUT_Request
  SSP0013 -.->|2| OUT_Analysis
  SSP0013 -.->|12| OUT_Change
  SSP0013 -.->|6| OUT_ChangeConfirm
  SSP0013 -.->|6| OUT_Confirm
  SSP0013 -.->|10| OUT_Request
  SSP0015 -.->|2| OUT_Analysis
  SSP0015 -.->|12| OUT_Change
  SSP0015 -.->|6| OUT_ChangeConfirm
  SSP0015 -.->|6| OUT_Confirm
  SSP0015 -.->|11| OUT_Request
  SSP0021 -.->|2| OUT_Analysis
  SSP0021 -.->|12| OUT_Change
  SSP0021 -.->|6| OUT_ChangeConfirm
  SSP0021 -.->|5| OUT_Confirm
  SSP0021 -.->|8| OUT_Request
  SSP0023 -.->|2| OUT_Analysis
  SSP0023 -.->|12| OUT_Change
  SSP0023 -.->|6| OUT_ChangeConfirm
  SSP0023 -.->|5| OUT_Confirm
  SSP0023 -.->|9| OUT_Request
  SSP0027 -.->|2| OUT_Analysis
  SSP0027 -.->|12| OUT_Change
  SSP0027 -.->|6| OUT_ChangeConfirm
  SSP0027 -.->|5| OUT_Confirm
  SSP0027 -.->|8| OUT_Request
  SSP0029 -.->|2| OUT_Analysis
  SSP0029 -.->|12| OUT_Change
  SSP0029 -.->|6| OUT_ChangeConfirm
  SSP0029 -.->|6| OUT_Confirm
  SSP0029 -.->|11| OUT_Request
```

#### Confirm (3화면)

```mermaid
flowchart LR
  SSP0012["SSP0012<br/>ShipmentPlanConfirmDetail ★TO-BE"]
  SSP0060["SSP0060<br/>ShipmentPlan / ShipmentPlanC ★TO-BE"]
  SSP0001["SSP0001<br/>ShipmentPlanConfirm"]
  IN_Change["◀ Change 단계"]
  IN_ChangeConfirm["◀ ChangeConfirm 단계"]
  IN_Master["◀ Master 단계"]
  IN_Plan["◀ Plan 단계"]
  IN_Request["◀ Request 단계"]
  OUT_Analysis["Analysis 단계 ▶"]
  OUT_Change["Change 단계 ▶"]
  OUT_ChangeConfirm["ChangeConfirm 단계 ▶"]
  OUT_Plan["Plan 단계 ▶"]
  OUT_Request["Request 단계 ▶"]
  SSP0060 -->|1| SSP0001
  SSP0060 -->|1| SSP0012
  IN_Change -.->|3| SSP0001
  IN_Change -.->|3| SSP0012
  IN_Change -.->|10| SSP0060
  IN_ChangeConfirm -.->|4| SSP0001
  IN_ChangeConfirm -.->|2| SSP0012
  IN_ChangeConfirm -.->|6| SSP0060
  IN_Master -.->|1| SSP0012
  IN_Master -.->|5| SSP0060
  IN_Plan -.->|7| SSP0001
  IN_Plan -.->|6| SSP0012
  IN_Plan -.->|21| SSP0060
  IN_Request -.->|5| SSP0060
  SSP0060 -.->|2| OUT_Analysis
  SSP0060 -.->|12| OUT_Change
  SSP0060 -.->|6| OUT_ChangeConfirm
  SSP0060 -.->|19| OUT_Plan
  SSP0060 -.->|8| OUT_Request
```

#### Change (5화면)

```mermaid
flowchart LR
  SSP0019["SSP0019<br/>ShipmentChangeHistory ★TO-BE"]
  SSP0200["SSP0200<br/>ShipmentChangeRequest / Ship ★TO-BE"]
  SSP0201["SSP0201<br/>ShipmentChangeRequest ★TO-BE"]
  SSP0002["SSP0002<br/>ShipmentChangeRequest / Ship"]
  SSP0050["SSP0050<br/>ShipmentChangeRequestIntegra"]
  IN_ChangeConfirm["◀ ChangeConfirm 단계"]
  IN_Confirm["◀ Confirm 단계"]
  IN_Master["◀ Master 단계"]
  IN_Plan["◀ Plan 단계"]
  OUT_Analysis["Analysis 단계 ▶"]
  OUT_ChangeConfirm["ChangeConfirm 단계 ▶"]
  OUT_Confirm["Confirm 단계 ▶"]
  OUT_Master["Master 단계 ▶"]
  OUT_Plan["Plan 단계 ▶"]
  OUT_Request["Request 단계 ▶"]
  SSP0002 -->|3| SSP0019
  SSP0002 -->|3| SSP0200
  SSP0002 -->|3| SSP0201
  SSP0050 -->|1| SSP0002
  SSP0050 -->|1| SSP0019
  SSP0050 -->|1| SSP0200
  SSP0050 -->|1| SSP0201
  SSP0200 -->|3| SSP0002
  SSP0200 -->|3| SSP0019
  SSP0200 -->|3| SSP0201
  SSP0201 -->|3| SSP0002
  SSP0201 -->|3| SSP0019
  SSP0201 -->|3| SSP0200
  IN_ChangeConfirm -.->|6| SSP0002
  IN_ChangeConfirm -.->|6| SSP0019
  IN_ChangeConfirm -.->|6| SSP0200
  IN_ChangeConfirm -.->|6| SSP0201
  IN_Confirm -.->|3| SSP0002
  IN_Confirm -.->|3| SSP0019
  IN_Confirm -.->|3| SSP0200
  IN_Confirm -.->|3| SSP0201
  IN_Master -.->|2| SSP0002
  IN_Master -.->|1| SSP0019
  IN_Master -.->|3| SSP0200
  IN_Master -.->|2| SSP0201
  IN_Plan -.->|18| SSP0002
  IN_Plan -.->|18| SSP0019
  IN_Plan -.->|18| SSP0200
  IN_Plan -.->|18| SSP0201
  SSP0002 -.->|1| OUT_Analysis
  SSP0002 -.->|6| OUT_ChangeConfirm
  SSP0002 -.->|5| OUT_Confirm
  SSP0002 -.->|18| OUT_Plan
  SSP0002 -.->|6| OUT_Request
  SSP0050 -.->|2| OUT_ChangeConfirm
  SSP0050 -.->|1| OUT_Confirm
  SSP0050 -.->|1| OUT_Master
  SSP0050 -.->|6| OUT_Plan
  SSP0050 -.->|1| OUT_Request
  SSP0200 -.->|2| OUT_Analysis
  SSP0200 -.->|6| OUT_ChangeConfirm
  SSP0200 -.->|5| OUT_Confirm
  SSP0200 -.->|19| OUT_Plan
  SSP0200 -.->|8| OUT_Request
  SSP0201 -.->|1| OUT_Analysis
  SSP0201 -.->|6| OUT_ChangeConfirm
  SSP0201 -.->|5| OUT_Confirm
  SSP0201 -.->|18| OUT_Plan
  SSP0201 -.->|6| OUT_Request
```

#### ChangeConfirm (2화면)

```mermaid
flowchart LR
  SSP0003["SSP0003<br/>ShipmentChangeRequestConfirm ★TO-BE"]
  SSP0202["SSP0202<br/>ShipmentChangeRequestConfirm ★TO-BE"]
  IN_Change["◀ Change 단계"]
  IN_Confirm["◀ Confirm 단계"]
  IN_Master["◀ Master 단계"]
  IN_Plan["◀ Plan 단계"]
  IN_Request["◀ Request 단계"]
  OUT_Analysis["Analysis 단계 ▶"]
  OUT_Change["Change 단계 ▶"]
  OUT_Confirm["Confirm 단계 ▶"]
  OUT_Plan["Plan 단계 ▶"]
  OUT_Request["Request 단계 ▶"]
  SSP0003 -->|3| SSP0202
  SSP0202 -->|3| SSP0003
  IN_Change -.->|10| SSP0003
  IN_Change -.->|10| SSP0202
  IN_Confirm -.->|3| SSP0003
  IN_Confirm -.->|3| SSP0202
  IN_Master -.->|3| SSP0003
  IN_Master -.->|3| SSP0202
  IN_Plan -.->|18| SSP0003
  IN_Plan -.->|18| SSP0202
  IN_Request -.->|5| SSP0003
  SSP0003 -.->|2| OUT_Analysis
  SSP0003 -.->|12| OUT_Change
  SSP0003 -.->|6| OUT_Confirm
  SSP0003 -.->|21| OUT_Plan
  SSP0003 -.->|10| OUT_Request
  SSP0202 -.->|2| OUT_Analysis
  SSP0202 -.->|12| OUT_Change
  SSP0202 -.->|6| OUT_Confirm
  SSP0202 -.->|19| OUT_Plan
  SSP0202 -.->|8| OUT_Request
```

#### Analysis (5화면)

```mermaid
flowchart LR
  SSP0017["SSP0017<br/>InventoryRaw ★TO-BE"]
  SSP0028["SSP0028<br/>Delivery_Tracking_LT"]
  SSP0030["SSP0030<br/>Logistics_Simulation"]
  SSP0300["SSP0300(팝업)<br/>OrderDetailPopup"]
  SSP0301["SSP0301(팝업)<br/>SqlPopup / SqlPopup.designer"]
  IN_Change["◀ Change 단계"]
  IN_ChangeConfirm["◀ ChangeConfirm 단계"]
  IN_Confirm["◀ Confirm 단계"]
  IN_Master["◀ Master 단계"]
  IN_Plan["◀ Plan 단계"]
  IN_Change -.->|4| SSP0028
  IN_ChangeConfirm -.->|4| SSP0028
  IN_Confirm -.->|2| SSP0028
  IN_Master -.->|1| SSP0028
  IN_Master -.->|2| SSP0030
  IN_Plan -.->|12| SSP0028
  IN_Plan -.->|2| SSP0030
```

### 2-2. TO-BE 메뉴 화면 간 흐름(19 화면만 · 단계별 색)

- Master 단계 화면(기준정보 · 거의 모든 화면이 읽음)은 한 노드로 접음 · AS-IS 전용 화면을 거치는 의존은 제외 · 라벨 = 매개 테이블 수(쓰는 화면 → 읽기만 하는 화면 · 단방향 전달) · 여러 TO-BE 화면이 함께 쓰는 허브 표는 그림 아래 표 · 화면정의서 재작성 순서 검토용

<div class="spf-svg"><div class="tbl-wrap"><table class="mx"><thead><tr><th rowspan="2">쓰는 화면</th><th class="mx-g mx-g0" colspan="14">읽기만 하는 화면</th></tr><tr><th class="mx-g0">DMF0045<small>Shipment Request</small></th><th class="mx-g0">SSP0026<small>Shipment Request</small></th><th class="mx-g0">SSP0022<small>Shipment Request</small></th><th class="mx-g0">SSP0045<small>Shipment Request</small></th><th class="mx-g0">SSP0015<small>Shipment Plan(Mo</small></th><th class="mx-g0">SSP0023<small>Shipment Plan(El</small></th><th class="mx-g0">SSP0021<small>Shipment Plan(Au</small></th><th class="mx-g0">SSP0012<small>Shipment Plan De</small></th><th class="mx-g0">SSP0060<small>Shipment Plan(Au</small></th><th class="mx-g0">SSP0019<small>Shipment Change </small></th><th class="mx-g0">SSP0200<small>Shipment Change </small></th><th class="mx-g0">SSP0201<small>Shipment Change </small></th><th class="mx-g0">SSP0003<small>Shipment Change </small></th><th class="mx-g0">SSP0202<small>Shipment Change </small></th></tr></thead><tbody><tr><th class="mx-e">Master 화면 8<small>SCP0005, SCP0028, SCP0033, SSP0005, SSP0014, SSP0020, SSP002</small></th><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE"><b class="mx-w">1</b></td><td class="mx-c" title="SSP_MST_MODEL_USER, SSP_MST_SHIP_CALENDAR"><b class="mx-w">2</b></td><td class="mx-c" title="SSP_MST_DELEGATE, SSP_MST_MODEL_USER_EE, SSP_MST_SHIP_CALENDAR, SSP_MST_SHIP_MASTER_EE"><b class="mx-w">4</b></td><td class="mx-0"></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE, SSP_MST_DELEGATE, SSP_MST_MODEL_USER, SSP_MST_MODEL_USER_EE"><b class="mx-w">4</b></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE, SSP_MST_DELEGATE, SSP_MST_MODEL_USER, SSP_MST_MODEL_USER_EE, SSP_MST_SHIP_CALENDAR"><b class="mx-w">5</b></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE, SCP_MST_SHIPMENT_LOT_SIZE, SSP_MST_DELEGATE, SSP_MST_MODEL_USER, SSP_MST_MODEL_USER_EE"><b class="mx-w">5</b></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE"><b class="mx-w">1</b></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE, SCP_MST_SHIPMENT_LOT_SIZE, SSP_MST_DELEGATE, SSP_MST_MODEL_USER, SSP_MST_MODEL_USER_EE"><b class="mx-w">5</b></td><td class="mx-c" title="SSP_MST_MODEL_USER"><b class="mx-w">1</b></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE, SSP_MST_DELEGATE, SSP_MST_MODEL_USER"><b class="mx-w">3</b></td><td class="mx-c" title="SSP_MST_DELEGATE, SSP_MST_MODEL_USER"><b class="mx-w">2</b></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE, SSP_MST_DELEGATE, SSP_MST_MODEL_USER"><b class="mx-w">3</b></td><td class="mx-c" title="SCP_MST_DISTRIBUTION_ROUTE, SSP_MST_DELEGATE, SSP_MST_MODEL_USER"><b class="mx-w">3</b></td></tr><tr><th class="mx-e" data-k="DMF0045">DMF0045<small>Shipment Request(Auto &amp; ESS)</small></th><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0026">SSP0026<small>Shipment Request(Mobility &amp; IT)</small></th><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_REQ_P"><b class="mx-w">2</b></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0022">SSP0022<small>Shipment Request(Electrode)</small></th><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_SHIP_REQ_EE"><b class="mx-w">1</b></td><td class="mx-c" title="SSP_ANL_SHIP_REQ_EE"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_SHIP_REQ_EE"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_SHIP_REQ_EE"><b class="mx-w">1</b></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0045">SSP0045<small>Shipment Request SEMI</small></th><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="DM_PLN_SHIPMENT_REQ"><b class="mx-w">1</b></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0015">SSP0015<small>Shipment Plan(Mobility &amp; IT)</small></th><td class="mx-c" title="DM_PLN_MKT_FCST"><b class="mx-w">1</b></td><td class="mx-c" title="SSP_ANL_SHIP_PLAN_40"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_SHIP_PLAN_40"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_HOLD_STOCK"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_HOLD_STOCK"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0023">SSP0023<small>Shipment Plan(Electrode)</small></th><td class="mx-c" title="DM_PLN_MKT_FCST"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_SHIP_PLAN_EE"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0021">SSP0021<small>Shipment Plan(Auto &amp; ESS)</small></th><td class="mx-c" title="DM_PLN_MKT_FCST"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0060">SSP0060<small>Shipment Plan(Auto &amp; ESS)-WA_UC</small></th><td class="mx-c" title="DM_PLN_MKT_FCST"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0200">SSP0200<small>Shipment Change Request</small></th><td class="mx-c" title="DM_PLN_MKT_FCST"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0003">SSP0003<small>Shipment Change Request Confirm</small></th><td class="mx-c" title="DM_PLN_MKT_FCST"><b class="mx-w">1</b></td><td class="mx-c" title="SSP_ANL_SHIP_PLAN_40"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-c" title="SSP_ANL_SHIP_PLAN_40"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td></tr><tr><th class="mx-e" data-k="SSP0202">SSP0202<small>Shipment Change Request Confirm(Packer)</small></th><td class="mx-c" title="DM_PLN_MKT_FCST"><b class="mx-w">1</b></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td><td class="mx-0"></td></tr></tbody></table></div><div class="bd-cap">칸의 숫자 = 왼쪽 화면이 쓰고 위쪽 화면이 읽기만 하는 테이블 수. 칸에 마우스를 올리면 테이블 이름이 보입니다. 화면 ID 를 누르면 그 화면의 상세가 열립니다. 쓰는 TO-BE 화면이 4개 이상인 허브 표는 아래 표에 있습니다. 같은 내용의 그래프는 아래 「그래프로 보기」.</div></div>

<div class="spf-fold" data-label="그래프로 보기(같은 내용)"></div>

```mermaid
flowchart TB
  classDef Master fill:#e3f2fd,stroke:#777
  classDef Request fill:#fff3e0,stroke:#777
  classDef Plan fill:#e8f5e9,stroke:#777
  classDef Confirm fill:#f3e5f5,stroke:#777
  classDef Change fill:#fce4ec,stroke:#777
  classDef ChangeConfirm fill:#ede7f6,stroke:#777
  classDef Analysis fill:#f1f8e9,stroke:#777
  MST["Master 화면 8<br/>SCP0005, SCP0028, SCP0033, SSP0005, SSP0014, SSP0020, SSP0024, SSP0025"]:::Master
  DMF0045["DMF0045<br/>Shipment Request(Auto &amp; ES"]:::Request
  SSP0026["SSP0026<br/>Shipment Request(Mobility &amp"]:::Request
  SSP0022["SSP0022<br/>Shipment Request(Electrode)"]:::Request
  SSP0045["SSP0045<br/>Shipment Request SEMI"]:::Request
  SSP0015["SSP0015<br/>Shipment Plan(Mobility &amp; I"]:::Plan
  SSP0023["SSP0023<br/>Shipment Plan(Electrode)"]:::Plan
  SSP0021["SSP0021<br/>Shipment Plan(Auto &amp; ESS)"]:::Plan
  SSP0012["SSP0012<br/>Shipment Plan Detail"]:::Confirm
  SSP0060["SSP0060<br/>Shipment Plan(Auto &amp; ESS)-"]:::Confirm
  SSP0019["SSP0019<br/>Shipment Change History"]:::Change
  SSP0200["SSP0200<br/>Shipment Change Request"]:::Change
  SSP0201["SSP0201<br/>Shipment Change Request(Packer"]:::Change
  SSP0003["SSP0003<br/>Shipment Change Request Confir"]:::ChangeConfirm
  SSP0202["SSP0202<br/>Shipment Change Request Confir"]:::ChangeConfirm
  SSP0017["SSP0017<br/>Inventory Raw(Mobility &amp; I"]:::Analysis
  MST -->|5| SSP0023
  MST -->|5| SSP0060
  MST -->|5| SSP0021
  MST -->|4| SSP0015
  MST -->|4| SSP0022
  MST -->|3| SSP0003
  MST -->|3| SSP0202
  MST -->|3| SSP0200
  SSP0026 -->|2| SSP0015
  MST -->|2| SSP0026
  MST -->|2| SSP0201
  DMF0045 -->|1| SSP0021
  DMF0045 -->|1| SSP0060
  DMF0045 -->|1| SSP0015
  DMF0045 -->|1| SSP0003
  SSP0045 -->|1| SSP0021
  SSP0045 -->|1| SSP0060
  SSP0045 -->|1| SSP0015
  SSP0045 -->|1| SSP0003
  SSP0026 -->|1| SSP0021
  SSP0026 -->|1| SSP0060
  SSP0026 -->|1| SSP0003
  SSP0023 -->|1| DMF0045
  SSP0003 -->|1| DMF0045
  SSP0202 -->|1| DMF0045
  SSP0060 -->|1| DMF0045
  SSP0200 -->|1| DMF0045
  SSP0015 -->|1| DMF0045
  SSP0021 -->|1| DMF0045
  MST -->|1| DMF0045
  MST -->|1| SSP0012
  MST -->|1| SSP0019
  SSP0022 -->|1| SSP0060
  SSP0022 -->|1| SSP0023
  SSP0022 -->|1| SSP0021
  SSP0022 -->|1| SSP0003
  SSP0015 -->|1| SSP0045
  SSP0015 -->|1| SSP0026
  SSP0003 -->|1| SSP0045
  SSP0003 -->|1| SSP0026
  SSP0015 -->|1| SSP0060
  SSP0015 -->|1| SSP0021
  SSP0023 -->|1| SSP0022
  LEG["범례: Master · Request · Plan · Confirm · Change · ChangeConfirm · Analysis — 전달 간선 43 · 허브 표 6개는 아래 표"]
```

**허브 표** — 쓰는 TO-BE 화면 ≥ 4: 여러 화면이 함께 쓰고 읽는 표라 화면쌍 간선 대신 표로 제시(그림에 넣으면 간선이 폭발)

| 허브 표 | 쓰는 TO-BE 화면 | 읽기만 하는 TO-BE 화면 |
|---|---|---|
| SSP_ANL_SHIP_CONFIRM | SSP0003, SSP0015, SSP0021, SSP0023, SSP0060, SSP0200, SSP0201, SSP0202 | DMF0045, SSP0012, SSP0019, SSP0022, SSP0026, SSP0045 |
| SSP_ANL_SHIP_CONFIRM_CHG_REQ | SSP0003, SSP0015, SSP0021, SSP0023, SSP0060, SSP0200, SSP0201, SSP0202 | SSP0019 |
| SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | SSP0003, SSP0015, SSP0021, SSP0023, SSP0060, SSP0200, SSP0201, SSP0202 | SSP0019, SSP0026 |
| SSP_ANL_SHIP_CONFIRM_ROUTE | SSP0003, SSP0015, SSP0021, SSP0023, SSP0060, SSP0200, SSP0202 | - |
| SSP_ANL_SHIP_ERP_ERROR_CONFIRM | SSP0003, SSP0015, SSP0021, SSP0023, SSP0060, SSP0200 | - |
| SSP_MST_SEND_MAIL_REQ | SSP0015, SSP0021, SSP0023, SSP0060 | - |

## 3. 의존 표(선행 화면 → 후행 화면 · 매개 테이블)

| 선행(쓰기) | 후행(읽기) | 매개 테이블 |
|---|---|---|
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0003 ShipmentChangeRequestConfirm | DM_PLN_SHIPMENT_REQ |
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | DM_PLN_SHIPMENT_REQ |
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0021 ShipmentPlan | DM_PLN_SHIPMENT_REQ |
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | DM_PLN_SHIPMENT_REQ |
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | DM_PLN_SHIPMENT_REQ |
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0045 ShipmentRequest | DM_PLN_SHIPMENT_REQ |
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_SHIPMENT_REQ |
| DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | DM_PLN_SHIPMENT_REQ |
| SCP0005 DistributionRoute | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0003 ShipmentChangeRequestConfirm | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0012 ShipmentPlanConfirmDetail | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0013 ShipmentPlanAdjustment | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0021 ShipmentPlan | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0023 ShipmentPlanElectrode | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0027 ShipmentPlanEss | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0028 Delivery_Tracking_LT | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0030 Logistics_Simulation | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0005 DistributionRoute | SSP0202 ShipmentChangeRequestConfirm | SCP_MST_DISTRIBUTION_ROUTE |
| SCP0028 Shipment_Lot_Size | SSP0021 ShipmentPlan | SCP_MST_SHIPMENT_LOT_SIZE |
| SCP0028 Shipment_Lot_Size | SSP0027 ShipmentPlanEss | SCP_MST_SHIPMENT_LOT_SIZE |
| SCP0028 Shipment_Lot_Size | SSP0030 Logistics_Simulation | SCP_MST_SHIPMENT_LOT_SIZE |
| SCP0028 Shipment_Lot_Size | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SCP_MST_SHIPMENT_LOT_SIZE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP_ANL_SHIP_CONFIRM |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0027 ShipmentPlanEss | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP_ANL_SHIP_CONFIRM |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0003 ShipmentChangeRequestConfirm | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN |
| SSP0003 ShipmentChangeRequestConfirm | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0003 ShipmentChangeRequestConfirm | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0003 ShipmentChangeRequestConfirm | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0003 ShipmentChangeRequestConfirm | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0003 ShipmentChangeRequestConfirm | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0003 ShipmentChangeRequestConfirm | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN_40 |
| SSP0003 ShipmentChangeRequestConfirm | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0003 ShipmentChangeRequestConfirm | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0003 ShipmentChangeRequestConfirm | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0005 ShipmentWorkingDay | SSP0016 ShipmentRequest | SSP_MST_SHIP_CALENDAR |
| SSP0005 ShipmentWorkingDay | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_MST_SHIP_CALENDAR |
| SSP0005 ShipmentWorkingDay | SSP0023 ShipmentPlanElectrode | SSP_MST_SHIP_CALENDAR |
| SSP0005 ShipmentWorkingDay | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_MST_SHIP_CALENDAR |
| SSP0007 ProductionPlan | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SCP_ANL_PRODUCTION_PLAN |
| SSP0007 ProductionPlan | SSP0021 ShipmentPlan | SCP_ANL_PRODUCTION_PLAN |
| SSP0007 ProductionPlan | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SCP_ANL_PRODUCTION_PLAN |
| SSP0007 ProductionPlan | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SCP_ANL_PRODUCTION_PLAN |
| SSP0009 Shipment_Plan_FG | SSP0030 Logistics_Simulation | SCP_ANL_SHIPMENT_PLAN_FG |
| SSP0010 Shipment_Plan_SEMI | SSP0030 Logistics_Simulation | SCP_ANL_SHIPMENT_PLAN_SEMI |
| SSP0010 Shipment_Plan_SEMI | SSP0045 ShipmentRequest | SCP_ANL_SHIPMENT_PLAN_SEMI |
| SSP0013 ShipmentPlanAdjustment | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0013 ShipmentPlanAdjustment | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN |
| SSP0013 ShipmentPlanAdjustment | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0013 ShipmentPlanAdjustment | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0013 ShipmentPlanAdjustment | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0013 ShipmentPlanAdjustment | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0013 ShipmentPlanAdjustment | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0013 ShipmentPlanAdjustment | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0013 ShipmentPlanAdjustment | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN_40 |
| SSP0013 ShipmentPlanAdjustment | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0013 ShipmentPlanAdjustment | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0013 ShipmentPlanAdjustment | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0014 ShipmentModelPIC | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0003 ShipmentChangeRequestConfirm | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0013 ShipmentPlanAdjustment | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0019 ShipmentChangeHistory | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0021 ShipmentPlan | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0023 ShipmentPlanElectrode | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0027 ShipmentPlanEss | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0201 ShipmentChangeRequest | SSP_MST_MODEL_USER |
| SSP0014 ShipmentModelPIC | SSP0202 ShipmentChangeRequestConfirm | SSP_MST_MODEL_USER |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0016 ShipmentRequest | SSP_ANL_HOLD_STOCK |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0021 ShipmentPlan | SSP_ANL_HOLD_STOCK, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_HOLD_STOCK, SSP_ANL_MES_FCS_STOCK_40_C, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN_40 |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_HOLD_STOCK, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0020 Delegate | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0003 ShipmentChangeRequestConfirm | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0021 ShipmentPlan | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0023 ShipmentPlanElectrode | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0027 ShipmentPlanEss | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0201 ShipmentChangeRequest | SSP_MST_DELEGATE |
| SSP0020 Delegate | SSP0202 ShipmentChangeRequestConfirm | SSP_MST_DELEGATE |
| SSP0021 ShipmentPlan | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0021 ShipmentPlan | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0021 ShipmentPlan | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0021 ShipmentPlan | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0021 ShipmentPlan | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0021 ShipmentPlan | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0021 ShipmentPlan | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0021 ShipmentPlan | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0021 ShipmentPlan | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_REQ_EE |
| SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP0021 ShipmentPlan | SSP_ANL_SHIP_REQ_EE |
| SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_REQ_EE |
| SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_REQ_EE |
| SSP0023 ShipmentPlanElectrode | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0023 ShipmentPlanElectrode | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0023 ShipmentPlanElectrode | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0023 ShipmentPlanElectrode | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN_EE |
| SSP0023 ShipmentPlanElectrode | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0023 ShipmentPlanElectrode | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0023 ShipmentPlanElectrode | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0023 ShipmentPlanElectrode | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0023 ShipmentPlanElectrode | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0024 ItembyDivisionPopup / ShipmentMasterElectrode | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_MST_SHIP_MASTER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0013 ShipmentPlanAdjustment | SSP_MST_MODEL_USER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_MST_MODEL_USER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0021 ShipmentPlan | SSP_MST_MODEL_USER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_MST_MODEL_USER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0023 ShipmentPlanElectrode | SSP_MST_MODEL_USER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0027 ShipmentPlanEss | SSP_MST_MODEL_USER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_MST_MODEL_USER_EE |
| SSP0025 ItembyDivisionPopup / ShipmentRequestorPIC | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_MST_MODEL_USER_EE |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_SHIPMENT_REQ |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP0003 ShipmentChangeRequestConfirm | DM_PLN_SHIPMENT_REQ |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_REQ_P |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP0021 ShipmentPlan | DM_PLN_SHIPMENT_REQ |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | DM_PLN_SHIPMENT_REQ, SSP_ANL_SHIP_REQ_P |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP0045 ShipmentRequest | DM_PLN_SHIPMENT_REQ |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_SHIPMENT_REQ |
| SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | DM_PLN_SHIPMENT_REQ |
| SSP0027 ShipmentPlanEss | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0027 ShipmentPlanEss | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0027 ShipmentPlanEss | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0027 ShipmentPlanEss | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0027 ShipmentPlanEss | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0027 ShipmentPlanEss | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0027 ShipmentPlanEss | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0027 ShipmentPlanEss | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0027 ShipmentPlanEss | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_HOLD_STOCK, SSP_ANL_MES_FCS_STOCK_40_C, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40, SSP_ANL_SHIP_PLAN_40_WH_IN_CMT |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0016 ShipmentRequest | SSP_ANL_HOLD_STOCK |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0021 ShipmentPlan | SSP_ANL_HOLD_STOCK, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SSP_ANL_SHIP_PLAN_40 |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN_40 |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_HOLD_STOCK, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0045 ShipmentRequest | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_SHIPMENT_REQ |
| SSP0045 ShipmentRequest | SSP0003 ShipmentChangeRequestConfirm | DM_PLN_SHIPMENT_REQ |
| SSP0045 ShipmentRequest | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | DM_PLN_SHIPMENT_REQ |
| SSP0045 ShipmentRequest | SSP0021 ShipmentPlan | DM_PLN_SHIPMENT_REQ |
| SSP0045 ShipmentRequest | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | DM_PLN_SHIPMENT_REQ |
| SSP0045 ShipmentRequest | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | DM_PLN_SHIPMENT_REQ |
| SSP0045 ShipmentRequest | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_SHIPMENT_REQ |
| SSP0045 ShipmentRequest | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP0003 ShipmentChangeRequestConfirm | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP0021 ShipmentPlan | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP0045 ShipmentRequest | DM_PLN_SHIPMENT_REQ |
| SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | DM_PLN_SHIPMENT_REQ |
| SSP0050 ShipmentChangeRequestIntegration | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0003 ShipmentChangeRequestConfirm | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0013 ShipmentPlanAdjustment | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0014 ShipmentModelPIC | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0019 ShipmentChangeHistory | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0021 ShipmentPlan | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0023 ShipmentPlanElectrode | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0027 ShipmentPlanEss | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0201 ShipmentChangeRequest | SSP_MST_MODEL_USER |
| SSP0050 ShipmentChangeRequestIntegration | SSP0202 ShipmentChangeRequestConfirm | SSP_MST_MODEL_USER |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | SSP_ANL_SHIP_CONFIRM |
| SSP0201 ShipmentChangeRequest | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM |
| SSP0201 ShipmentChangeRequest | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0201 ShipmentChangeRequest | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0201 ShipmentChangeRequest | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0027 ShipmentPlanEss | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM |
| SSP0201 ShipmentChangeRequest | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0201 ShipmentChangeRequest | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | SSP_ANL_SHIP_CONFIRM |
| SSP0201 ShipmentChangeRequest | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0201 ShipmentChangeRequest | SSP0202 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | DMF0045 ShipmentRequest / ShipmentRequest_POPUP_DMF0046_GetBODItemPrjRoute | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0202 ShipmentChangeRequestConfirm | SSP0001 ShipmentPlanConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_PLAN |
| SSP0202 ShipmentChangeRequestConfirm | SSP0002 ShipmentChangeRequest / ShipmentChangeRequest_Backup / ShipmentConfirmInsertPopup / UserInfoPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0003 ShipmentChangeRequestConfirm | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0012 ShipmentPlanConfirmDetail | SSP_ANL_SHIP_CONFIRM |
| SSP0202 ShipmentChangeRequestConfirm | SSP0013 ShipmentPlanAdjustment | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0015 ShipmentPSI / ShipmentPSICommentsPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0019 ShipmentChangeHistory | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0021 ShipmentPlan | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0022 BodItemPopup / ShipmentRequestElectrode / ShipmentRequestPopup | SSP_ANL_SHIP_CONFIRM |
| SSP0202 ShipmentChangeRequestConfirm | SSP0023 ShipmentPlanElectrode | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0026 BodItemPopup / ItembyDivisionPopup / ShipmentRequestPack | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0027 ShipmentPlanEss | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0028 Delivery_Tracking_LT | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_ROUTE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0029 ShipmentPlanPack / ShipmentPlanPackPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0045 ShipmentRequest | SSP_ANL_SHIP_CONFIRM |
| SSP0202 ShipmentChangeRequestConfirm | SSP0046 GetBODItemPrjRoutePopup / ItembyDivisionPopupEx / ProjectbyDivisionPopupEx / ShipmentRequest / TitleSetForm_Popup | DM_PLN_MKT_FCST, SSP_ANL_SHIP_CONFIRM |
| SSP0202 ShipmentChangeRequestConfirm | SSP0060 ShipmentPlan / ShipmentPlanConfirmDetailPopup / ShipmentPlanRequestPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0200 ShipmentChangeRequest / ShipmentChangeRequestInsertPopup | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |
| SSP0202 ShipmentChangeRequestConfirm | SSP0201 ShipmentChangeRequest | SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE |

## 4. 단계(위상 정렬 — 선행 의존이 없는 화면부터)

1. SCP0005(DistributionRoute) → SCP0028(Shipment_Lot_Size) → SCP0033(Shipment_semi_dept) → SSP0005(ShipmentWorkingDay) → SSP0006(Plan_Problem) → SSP0007(ProductionPlan) → SSP0008(ProductionPlanLine) → SSP0009(Shipment_Plan_FG) → SSP0010(Shipment_Plan_SEMI) → SSP0011(PSI) → SSP0017(InventoryRaw) → SSP0018(ProductionPlanOSP) → SSP0020(Delegate) → SSP0024(ItembyDivisionPopu) → SSP0025(ItembyDivisionPopu) → SSP0050(ShipmentChangeRequ) → SSP0100(LTManagement) → SSP0300(OrderDetailPopup) → SSP0301(SqlPopup / SqlPopu) → SSP0030(Logistics_Simulati) → SSP0014(ShipmentModelPIC)

- 상호 의존(사이클)으로 순서를 못 정한 화면 22: DMF0045, SSP0001, SSP0002, SSP0003, SSP0012, SSP0013, SSP0015, SSP0016, SSP0019, SSP0021, SSP0022, SSP0023, SSP0026, SSP0027, SSP0028, SSP0029, SSP0045, SSP0046, SSP0060, SSP0200, SSP0201, SSP0202 — 같은 표를 서로 쓰고 읽음(의존 표 참조)

## 5. 화면 내부 표준 프로세스

```mermaid
sequenceDiagram
  participant U as 사용자
  participant UI as SSP 화면
  participant BE as Spring BE(call-proc)
  participant DB as Oracle PKG_SSPxxxx
  U->>UI: 조회조건 입력 → Search(F5)
  UI->>BE: /SSPxxxx/<sheet>/SEARCH/call-proc
  BE->>DB: P_SSPxxxx_GET_*(조건 인자)
  DB-->>UI: 결과 커서
  U->>UI: 편집(Insert/수정/Delete) → Save(F7)
  UI->>UI: 화면 사전검증(필수·중복·형식)
  UI->>BE: /SSPxxxx/<sheet>/SAVE/call-proc(CRUD_TYPE I/M/D)
  BE->>DB: P_SSPxxxx_SAVE_*(행 단위) + PR_SCM_SYS_LOG_BATCH
  DB-->>UI: RESULT_CODE/MESSAGE
```

> 화면별 실제 SP 이름·호출 종류(GET/SAVE)는 `SSP_DATA_FLOW_DETAIL.md` 각 절의 다이어그램 참조
