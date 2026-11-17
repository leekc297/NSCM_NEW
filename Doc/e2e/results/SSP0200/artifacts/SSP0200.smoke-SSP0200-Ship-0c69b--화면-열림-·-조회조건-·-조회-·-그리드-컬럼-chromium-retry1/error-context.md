# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0200.smoke.spec.ts >> SSP0200 ShipmentChangeRequest 스모크 @smoke >> 화면 열림 · 조회조건 · 조회 · 그리드 컬럼
- Location: ..\..\Doc\e2e\specs\SSP0200.smoke.spec.ts:11:7

# Error details

```
Error: 조회조건 'Request No' (InputField) — 후보 [Request No]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'Item Id' (ItemField) — 후보 [Item | Item Id]

expect(received).toBeTruthy()

Received: false
```

```
Error: 헤더 시각적 단 수 ≥ 2 (As-is SetSheetHeaderColumn 2행 · 월간은 Qty 2행 병합 = 2단) — 1단이면 columnGroups leaf 라벨 점검

expect(received).toBeGreaterThanOrEqual(expected)

Expected: >= 2
Received:    1
```

```
Error: As-is 병합 헤더 리터럴 노출 [Plan, Confirm, L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty, Shipment Date*, Qty*, Confirmed, Change]

expect(received).toBe(expected) // Object.is equality

Expected: 0
Received: 10
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/SSP0200
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SSP0200
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SSP0200
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SSP0200
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SSP0200
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SSP0200
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/SSP0200
      - generic [ref=f2e17]:
        - button "KOR" [ref=f2e19] [cursor=pointer]
        - button "이 이민용" [ref=f2e23] [cursor=pointer]:
          - paragraph [ref=f2e28]: 이
          - generic [ref=f2e29]: 이민용
    - generic [ref=f2e30]:
      - button [ref=f2e31] [cursor=pointer]
      - complementary [ref=f2e37]:
        - navigation [ref=f2e38]:
          - paragraph [ref=f2e39]: Shipping
          - generic [ref=f2e40]:
            - link [ref=f2e41] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0200
              - paragraph [ref=f2e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0200
              - paragraph [ref=f2e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0200
              - paragraph [ref=f2e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0200
              - paragraph [ref=f2e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0200
              - paragraph [ref=f2e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0200
              - paragraph [ref=f2e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0200
              - paragraph [ref=f2e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0200
              - paragraph [ref=f2e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f2e53]:
            - link [ref=f2e54] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e55]: Shipping Schedule
            - link [ref=f2e58] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e59]: Shipment Request
            - link [ref=f2e60] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e61]: Shipment Plan(Mobility & IT)
            - link [ref=f2e62] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e63]: Shipment Plan(Electrode)
            - link [ref=f2e64] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f2e66] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e67]: Shipment Plan Detail
            - link [ref=f2e68] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e69]: Shipment Change History
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e71]: Shipment Plan(Auto & ESS)
            - link [ref=f2e72] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e73]: Shipment Request(Mobility & IT)
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e75]: Shipment Request(Electrode)
            - link [ref=f2e76] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e77]: Shipment Change Request
            - link [ref=f2e78] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e79]: Shipment Change Request Confirm
            - link [ref=f2e80] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e81]: Inventory Raw(Mobility & IT)
            - link [ref=f2e82] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e83]: Shipment Change Request(Packer)
            - link [ref=f2e84] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/SSP0200
              - paragraph [ref=f2e87]: Shipment Request SEMI
      - main [ref=f2e88]:
        - generic [ref=f2e90]:
          - generic [ref=f2e91]:
            - generic [ref=f2e92]:
              - button "Home" [ref=f2e93] [cursor=pointer]
              - button "Shipment Change Request" [ref=f2e95] [cursor=pointer]
            - generic [ref=f2e100]:
              - button "Scroll tabs left" [disabled] [ref=f2e101]
              - button "Scroll tabs right" [disabled] [ref=f2e104]
              - button "Close others" [ref=f2e107] [cursor=pointer]
              - button "Close All" [ref=f2e108] [cursor=pointer]
          - generic [ref=f2e109]:
            - generic [ref=f2e112]:
              - generic [ref=f2e114]:
                - generic [ref=f2e115]:
                  - img [aria-hidden] [ref=f2e117] [cursor=pointer]
                  - paragraph [ref=f2e120]: Shipment Change Request
                - generic [ref=f2e121]:
                  - generic [ref=f2e122]: Shipping
                  - generic [ref=f2e127]: Shipping Schedule
                  - generic [ref=f2e132]: Shipment Change Request
                - generic [ref=f2e134]:
                  - generic [ref=f2e135]: Search Area
                  - switch [checked] [ref=f2e138] [cursor=pointer]
                - button "Full screen" [ref=f2e141] [cursor=pointer]
              - generic [ref=f2e150]:
                - generic [ref=f2e151]:
                  - generic [ref=f2e152]:
                    - generic [ref=f2e154]:
                      - generic [ref=f2e155]: Div
                      - generic [ref=f2e163]:
                        - combobox [ref=f2e164]: 40 Mobility & IT Battery
                        - button "Open" [ref=f2e166] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e171]:
                      - generic [ref=f2e172]: From Site
                      - generic [ref=f2e180] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e181]
                        - button "Open" [ref=f2e183]
                        - group [aria-hidden]
                    - generic [ref=f2e188]:
                      - generic [ref=f2e189]: To Site
                      - generic [ref=f2e197] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e198]
                        - button "Open" [ref=f2e200]
                        - group [aria-hidden]
                    - generic [ref=f2e205]:
                      - generic [ref=f2e206]: Status
                      - generic [ref=f2e214]:
                        - combobox [ref=f2e215]: ALL
                        - button "Open" [ref=f2e217] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e222]:
                      - generic [ref=f2e223]: Shipment Date
                      - generic [ref=f2e230]:
                        - generic [ref=f2e233]:
                          - img [aria-hidden] [ref=f2e235] [cursor=pointer]
                          - textbox "YYYY.MM.DD" [ref=f2e243]: 2026.11.15
                        - generic [ref=f2e244]: ~
                        - generic [ref=f2e247]:
                          - img [aria-hidden] [ref=f2e249] [cursor=pointer]
                          - textbox "YYYY.MM.DD" [ref=f2e257]: 2026.12.15
                    - generic [ref=f2e259]:
                      - generic [ref=f2e260]: Model/Nickname
                      - generic [ref=f2e266]:
                        - textbox [ref=f2e267]
                        - button [ref=f2e268] [cursor=pointer]
                    - generic [ref=f2e274]:
                      - generic [ref=f2e275]: SO No
                      - textbox [ref=f2e282]
                    - generic [ref=f2e284]:
                      - generic [ref=f2e285]: Confirm ID
                      - textbox [ref=f2e292]
                  - generic [ref=f2e293]:
                    - button [active] [ref=f2e294] [cursor=pointer]
                    - button [ref=f2e299] [cursor=pointer]
                - generic [ref=f2e304]:
                  - separator [ref=f2e305]
                  - generic [ref=f2e310]:
                    - generic [ref=f2e311]: Single Process
                    - checkbox [ref=f2e316] [cursor=pointer]
              - generic [ref=f2e317]:
                - generic [ref=f2e318]:
                  - paragraph
                  - generic [ref=f2e319]: 총25건
                - generic [ref=f2e320]:
                  - generic "New" [ref=f2e321]:
                    - button "New" [ref=f2e322] [cursor=pointer]
                  - generic "Insert Multiple" [ref=f2e323]:
                    - button "Insert Multiple" [ref=f2e324] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e325]:
                    - button [ref=f2e326] [cursor=pointer]
                  - generic "Remove" [ref=f2e331]:
                    - button [ref=f2e332] [cursor=pointer]
                  - generic "Save" [ref=f2e339]:
                    - button [ref=f2e340] [cursor=pointer]
                  - generic "Sort" [ref=f2e344]:
                    - button [ref=f2e345] [cursor=pointer]
                  - generic "Filter" [ref=f2e350]:
                    - button [ref=f2e351] [cursor=pointer]
                  - generic "Condition" [ref=f2e356]:
                    - button [ref=f2e357] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e367]:
                    - button [ref=f2e368] [cursor=pointer]
                  - generic "Excel" [ref=f2e375]:
                    - button [ref=f2e376] [cursor=pointer]
              - generic [ref=f2e385]:
                - generic [ref=f2e389]:
                  - grid [ref=f2e390]:
                    - rowgroup [ref=f2e391]:
                      - generic:
                        - row "Div SO No Status Confirm/Plan ID Model Nick Name End Customer FCST Type From Site To Site Incoterms Shipment Qty Shipment Date Trans Mode Building Remarks Customer Requirement No":
                          - columnheader "Div" [ref=f2e392]
                          - columnheader "SO No" [ref=f2e393]
                          - columnheader "Status" [ref=f2e394]
                          - columnheader "Confirm/Plan ID" [ref=f2e395]
                          - columnheader "Model" [ref=f2e396]
                          - columnheader "Nick Name" [ref=f2e397]
                          - columnheader "End Customer" [ref=f2e398]
                          - columnheader "FCST Type" [ref=f2e399]
                          - columnheader "From Site" [ref=f2e400]
                          - columnheader "To Site" [ref=f2e401]
                          - columnheader "Incoterms" [ref=f2e402]
                          - columnheader "Shipment Qty" [ref=f2e403]
                          - columnheader "Shipment Date" [ref=f2e404]
                          - columnheader "Trans Mode" [ref=f2e405]
                          - columnheader "Building" [ref=f2e406]
                          - columnheader "Remarks" [ref=f2e407]
                          - columnheader "Customer Requirement" [ref=f2e408]
                          - gridcell "No" [ref=f2e409]
                          - gridcell [ref=f2e410]
                    - rowgroup [ref=f2e411]:
                      - generic [ref=f2e412]:
                        - row "40 Mobility & IT Battery Confirm C20261008211404 MCCH129520B1 HJ2 Unit Pack Power Mass LGESNJ Cell NJ01 Unit Pack Power_HK_KWN DDP 200,000 2026-11-16 TRK test5 1":
                          - gridcell "40 Mobility & IT Battery" [selected] [ref=f2e413]
                          - gridcell [ref=f2e414]
                          - gridcell "Confirm" [ref=f2e415]
                          - gridcell "C20261008211404" [ref=f2e416]
                          - gridcell "MCCH129520B1" [ref=f2e417]
                          - gridcell "HJ2" [ref=f2e418]
                          - gridcell "Unit Pack Power" [ref=f2e419]
                          - gridcell "Mass" [ref=f2e420]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e421]
                          - gridcell "Unit Pack Power_HK_KWN" [ref=f2e422]
                          - gridcell "DDP" [ref=f2e423]
                          - gridcell "200,000" [ref=f2e424]
                          - gridcell "2026-11-16" [ref=f2e425]
                          - gridcell "TRK" [ref=f2e426]
                          - gridcell [ref=f2e427]
                          - gridcell [ref=f2e428]
                          - gridcell "test5" [ref=f2e429]
                          - gridcell "1" [ref=f2e430]
                          - gridcell [ref=f2e431]
                        - row "40 Mobility & IT Battery Confirm C20261113201060 MCCH129520B1 HJ2 Unit Pack Power Mass LGESNJ Cell NJ01 Unit Pack Power_HK_KWN DDP 11,200 2026-11-16 TRK test5 2":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e432]
                          - gridcell [ref=f2e433]
                          - gridcell "Confirm" [ref=f2e434]
                          - gridcell "C20261113201060" [ref=f2e435]
                          - gridcell "MCCH129520B1" [ref=f2e436]
                          - gridcell "HJ2" [ref=f2e437]
                          - gridcell "Unit Pack Power" [ref=f2e438]
                          - gridcell "Mass" [ref=f2e439]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e440]
                          - gridcell "Unit Pack Power_HK_KWN" [ref=f2e441]
                          - gridcell "DDP" [ref=f2e442]
                          - gridcell "11,200" [ref=f2e443]
                          - gridcell "2026-11-16" [ref=f2e444]
                          - gridcell "TRK" [ref=f2e445]
                          - gridcell [ref=f2e446]
                          - gridcell [ref=f2e447]
                          - gridcell "test5" [ref=f2e448]
                          - gridcell "2" [ref=f2e449]
                          - gridcell [ref=f2e450]
                        - row "40 Mobility & IT Battery Confirm C20261113201059 MCCH129520B1 HJ2 Unit Pack Power Mass LGESNJ Cell NJ01 Unit Pack Power_HK_KWN DDP 10 2026-11-16 TRK test4 3":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e451]
                          - gridcell [ref=f2e452]
                          - gridcell "Confirm" [ref=f2e453]
                          - gridcell "C20261113201059" [ref=f2e454]
                          - gridcell "MCCH129520B1" [ref=f2e455]
                          - gridcell "HJ2" [ref=f2e456]
                          - gridcell "Unit Pack Power" [ref=f2e457]
                          - gridcell "Mass" [ref=f2e458]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e459]
                          - gridcell "Unit Pack Power_HK_KWN" [ref=f2e460]
                          - gridcell "DDP" [ref=f2e461]
                          - gridcell "10" [ref=f2e462]
                          - gridcell "2026-11-16" [ref=f2e463]
                          - gridcell "TRK" [ref=f2e464]
                          - gridcell [ref=f2e465]
                          - gridcell "test4" [ref=f2e466]
                          - gridcell [ref=f2e467]
                          - gridcell "3" [ref=f2e468]
                          - gridcell [ref=f2e469]
                        - row "40 Mobility & IT Battery Confirm C20261113201058 MCCH129520B1 HJ2 Unit Pack Power Mass LGESNJ Cell NJ01 Unit Pack Power_HK_KWN DDP 10 2026-11-16 TRK test4 4":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e470]
                          - gridcell [ref=f2e471]
                          - gridcell "Confirm" [ref=f2e472]
                          - gridcell "C20261113201058" [ref=f2e473]
                          - gridcell "MCCH129520B1" [ref=f2e474]
                          - gridcell "HJ2" [ref=f2e475]
                          - gridcell "Unit Pack Power" [ref=f2e476]
                          - gridcell "Mass" [ref=f2e477]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e478]
                          - gridcell "Unit Pack Power_HK_KWN" [ref=f2e479]
                          - gridcell "DDP" [ref=f2e480]
                          - gridcell "10" [ref=f2e481]
                          - gridcell "2026-11-16" [ref=f2e482]
                          - gridcell "TRK" [ref=f2e483]
                          - gridcell [ref=f2e484]
                          - gridcell "test4" [ref=f2e485]
                          - gridcell [ref=f2e486]
                          - gridcell "4" [ref=f2e487]
                          - gridcell [ref=f2e488]
                        - row "40 Mobility & IT Battery Confirm C20261113201057 MCCH129520B1 HJ2 Unit Pack Power Mass LGESNJ Cell NJ01 Unit Pack Power_HK_KWN DDP 10 2026-11-16 TRK test4 5":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e489]
                          - gridcell [ref=f2e490]
                          - gridcell "Confirm" [ref=f2e491]
                          - gridcell "C20261113201057" [ref=f2e492]
                          - gridcell "MCCH129520B1" [ref=f2e493]
                          - gridcell "HJ2" [ref=f2e494]
                          - gridcell "Unit Pack Power" [ref=f2e495]
                          - gridcell "Mass" [ref=f2e496]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e497]
                          - gridcell "Unit Pack Power_HK_KWN" [ref=f2e498]
                          - gridcell "DDP" [ref=f2e499]
                          - gridcell "10" [ref=f2e500]
                          - gridcell "2026-11-16" [ref=f2e501]
                          - gridcell "TRK" [ref=f2e502]
                          - gridcell [ref=f2e503]
                          - gridcell "test4" [ref=f2e504]
                          - gridcell [ref=f2e505]
                          - gridcell "5" [ref=f2e506]
                          - gridcell [ref=f2e507]
                        - row "40 Mobility & IT Battery Confirm C20261012212351 MCCH129520B1 HJ2 Unit Pack Power Mass LGESNJ Cell NJ01 Unit Pack Power_HK_KWN DDP 200,000 2026-11-16 TRK test4 6":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e508]
                          - gridcell [ref=f2e509]
                          - gridcell "Confirm" [ref=f2e510]
                          - gridcell "C20261012212351" [ref=f2e511]
                          - gridcell "MCCH129520B1" [ref=f2e512]
                          - gridcell "HJ2" [ref=f2e513]
                          - gridcell "Unit Pack Power" [ref=f2e514]
                          - gridcell "Mass" [ref=f2e515]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e516]
                          - gridcell "Unit Pack Power_HK_KWN" [ref=f2e517]
                          - gridcell "DDP" [ref=f2e518]
                          - gridcell "200,000" [ref=f2e519]
                          - gridcell "2026-11-16" [ref=f2e520]
                          - gridcell "TRK" [ref=f2e521]
                          - gridcell [ref=f2e522]
                          - gridcell "test4" [ref=f2e523]
                          - gridcell [ref=f2e524]
                          - gridcell "6" [ref=f2e525]
                          - gridcell [ref=f2e526]
                        - row "40 Mobility & IT Battery Confirm C20261113201056 MCCH129520B1 HJ2 Airbus Sample(Mass/Chargeable) LGESNJ Cell NJ01 Airbus_FR_SCY DAP 2,300 2026-11-23 AIR insert test 7":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e527]
                          - gridcell [ref=f2e528]
                          - gridcell "Confirm" [ref=f2e529]
                          - gridcell "C20261113201056" [ref=f2e530]
                          - gridcell "MCCH129520B1" [ref=f2e531]
                          - gridcell "HJ2" [ref=f2e532]
                          - gridcell "Airbus" [ref=f2e533]
                          - gridcell "Sample(Mass/Chargeable)" [ref=f2e534]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e535]
                          - gridcell "Airbus_FR_SCY" [ref=f2e536]
                          - gridcell "DAP" [ref=f2e537]
                          - gridcell "2,300" [ref=f2e538]
                          - gridcell "2026-11-23" [ref=f2e539]
                          - gridcell "AIR" [ref=f2e540]
                          - gridcell [ref=f2e541]
                          - gridcell [ref=f2e542]
                          - gridcell "insert test" [ref=f2e543]
                          - gridcell "7" [ref=f2e544]
                          - gridcell [ref=f2e545]
                        - row "40 Mobility & IT Battery Confirm C20261026211943 MCCM348014A3 M50LT Jinle Mass LGESNJ Cell NJ01 Jinle_KR_SEL CIF 600 2026-11-23 SEA TEST insert test 1/4 8":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e546]
                          - gridcell [ref=f2e547]
                          - gridcell "Confirm" [ref=f2e548]
                          - gridcell "C20261026211943" [ref=f2e549]
                          - gridcell "MCCM348014A3" [ref=f2e550]
                          - gridcell "M50LT" [ref=f2e551]
                          - gridcell "Jinle" [ref=f2e552]
                          - gridcell "Mass" [ref=f2e553]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e554]
                          - gridcell "Jinle_KR_SEL" [ref=f2e555]
                          - gridcell "CIF" [ref=f2e556]
                          - gridcell "600" [ref=f2e557]
                          - gridcell "2026-11-23" [ref=f2e558]
                          - gridcell "SEA" [ref=f2e559]
                          - gridcell [ref=f2e560]
                          - gridcell "TEST" [ref=f2e561]
                          - gridcell "insert test 1/4" [ref=f2e562]
                          - gridcell "8" [ref=f2e563]
                          - gridcell [ref=f2e564]
                        - row "40 Mobility & IT Battery Confirm C20261113201067 MCCM348014A3 M50LT Jinle Mass LGESNJ Cell NJ01 Jinle_KR_SEL CIF 50 2026-11-23 SEA insert test 1/4 9":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e565]
                          - gridcell [ref=f2e566]
                          - gridcell "Confirm" [ref=f2e567]
                          - gridcell "C20261113201067" [ref=f2e568]
                          - gridcell "MCCM348014A3" [ref=f2e569]
                          - gridcell "M50LT" [ref=f2e570]
                          - gridcell "Jinle" [ref=f2e571]
                          - gridcell "Mass" [ref=f2e572]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e573]
                          - gridcell "Jinle_KR_SEL" [ref=f2e574]
                          - gridcell "CIF" [ref=f2e575]
                          - gridcell "50" [ref=f2e576]
                          - gridcell "2026-11-23" [ref=f2e577]
                          - gridcell "SEA" [ref=f2e578]
                          - gridcell [ref=f2e579]
                          - gridcell [ref=f2e580]
                          - gridcell "insert test 1/4" [ref=f2e581]
                          - gridcell "9" [ref=f2e582]
                          - gridcell [ref=f2e583]
                        - row "40 Mobility & IT Battery Confirm C20261113201066 MCCM348014A3 M50LT Jinle Mass LGESNJ Cell NJ01 Jinle_KR_SEL CIF 100 2026-11-23 SEA insert test 1/4 10":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e584]
                          - gridcell [ref=f2e585]
                          - gridcell "Confirm" [ref=f2e586]
                          - gridcell "C20261113201066" [ref=f2e587]
                          - gridcell "MCCM348014A3" [ref=f2e588]
                          - gridcell "M50LT" [ref=f2e589]
                          - gridcell "Jinle" [ref=f2e590]
                          - gridcell "Mass" [ref=f2e591]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e592]
                          - gridcell "Jinle_KR_SEL" [ref=f2e593]
                          - gridcell "CIF" [ref=f2e594]
                          - gridcell "100" [ref=f2e595]
                          - gridcell "2026-11-23" [ref=f2e596]
                          - gridcell "SEA" [ref=f2e597]
                          - gridcell [ref=f2e598]
                          - gridcell [ref=f2e599]
                          - gridcell "insert test 1/4" [ref=f2e600]
                          - gridcell "10" [ref=f2e601]
                          - gridcell [ref=f2e602]
                        - row "40 Mobility & IT Battery Confirm C20261113201062 MCCM348014A3 M50LT Jinle Mass LGESNJ Cell NJ01 Jinle_KR_SEL CIF 400 2026-11-23 SEA insert test 1/4 11":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e603]
                          - gridcell [ref=f2e604]
                          - gridcell "Confirm" [ref=f2e605]
                          - gridcell "C20261113201062" [ref=f2e606]
                          - gridcell "MCCM348014A3" [ref=f2e607]
                          - gridcell "M50LT" [ref=f2e608]
                          - gridcell "Jinle" [ref=f2e609]
                          - gridcell "Mass" [ref=f2e610]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e611]
                          - gridcell "Jinle_KR_SEL" [ref=f2e612]
                          - gridcell "CIF" [ref=f2e613]
                          - gridcell "400" [ref=f2e614]
                          - gridcell "2026-11-23" [ref=f2e615]
                          - gridcell "SEA" [ref=f2e616]
                          - gridcell [ref=f2e617]
                          - gridcell [ref=f2e618]
                          - gridcell "insert test 1/4" [ref=f2e619]
                          - gridcell "11" [ref=f2e620]
                          - gridcell [ref=f2e621]
                        - row "40 Mobility & IT Battery Confirm C20261113201055 MCCM348014A3 M50LT Jinle Mass LGESNJ Cell NJ01 Jinle_KR_SEL CIF 10 2026-11-23 SEA insert test 2/4 12":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e622]
                          - gridcell [ref=f2e623]
                          - gridcell "Confirm" [ref=f2e624]
                          - gridcell "C20261113201055" [ref=f2e625]
                          - gridcell "MCCM348014A3" [ref=f2e626]
                          - gridcell "M50LT" [ref=f2e627]
                          - gridcell "Jinle" [ref=f2e628]
                          - gridcell "Mass" [ref=f2e629]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e630]
                          - gridcell "Jinle_KR_SEL" [ref=f2e631]
                          - gridcell "CIF" [ref=f2e632]
                          - gridcell "10" [ref=f2e633]
                          - gridcell "2026-11-23" [ref=f2e634]
                          - gridcell "SEA" [ref=f2e635]
                          - gridcell [ref=f2e636]
                          - gridcell [ref=f2e637]
                          - gridcell "insert test 2/4" [ref=f2e638]
                          - gridcell "12" [ref=f2e639]
                          - gridcell [ref=f2e640]
                        - row "40 Mobility & IT Battery Confirm C20261113201054 MCCM348014A3 M50LT Jinle Mass LGESNJ Cell NJ01 Jinle_KR_SEL CIF 10 2026-11-23 SEA insert test 3/4 13":
                          - gridcell "40 Mobility & IT Battery" [ref=f2e641]
                          - gridcell [ref=f2e642]
                          - gridcell "Confirm" [ref=f2e643]
                          - gridcell "C20261113201054" [ref=f2e644]
                          - gridcell "MCCM348014A3" [ref=f2e645]
                          - gridcell "M50LT" [ref=f2e646]
                          - gridcell "Jinle" [ref=f2e647]
                          - gridcell "Mass" [ref=f2e648]
                          - gridcell "LGESNJ Cell NJ01" [ref=f2e649]
                          - gridcell "Jinle_KR_SEL" [ref=f2e650]
                          - gridcell "CIF" [ref=f2e651]
                          - gridcell "10" [ref=f2e652]
                          - gridcell "2026-11-23" [ref=f2e653]
                          - gridcell "SEA" [ref=f2e654]
                          - gridcell [ref=f2e655]
                          - gridcell [ref=f2e656]
                          - gridcell "insert test 3/4" [ref=f2e657]
                          - gridcell "13" [ref=f2e658]
                          - gridcell [ref=f2e659]
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e660]
                    - generic [aria-hidden]:
                      - gridcell [selected] [ref=f2e661]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e662]
                      - gridcell [ref=f2e663]: Confirm
                      - gridcell [ref=f2e664]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e665]
                      - gridcell [ref=f2e666]: Confirm
                      - gridcell [ref=f2e667]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e668]
                      - gridcell [ref=f2e669]: Confirm
                      - gridcell [ref=f2e670]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e671]
                      - gridcell [ref=f2e672]: Confirm
                      - gridcell [ref=f2e673]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e674]
                      - gridcell [ref=f2e675]: Confirm
                      - gridcell [ref=f2e676]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e677]
                      - gridcell [ref=f2e678]: Confirm
                      - gridcell [ref=f2e679]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e680]
                      - gridcell [ref=f2e681]: Confirm
                      - gridcell [ref=f2e682]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e683]
                      - gridcell [ref=f2e684]: Confirm
                      - gridcell [ref=f2e685]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e686]
                      - gridcell [ref=f2e687]: Confirm
                      - gridcell [ref=f2e688]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e689]
                      - gridcell [ref=f2e690]: Confirm
                      - gridcell [ref=f2e691]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e692]
                      - gridcell [ref=f2e693]: Confirm
                      - gridcell [ref=f2e694]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e695]
                      - gridcell [ref=f2e696]: Confirm
                      - gridcell [ref=f2e697]: 40 Mobility & IT Battery
                      - gridcell [ref=f2e698]
                      - gridcell [ref=f2e699]: Confirm
                    - generic [ref=f2e700]:
                      - generic:
                        - row "1"
                        - row "2"
                        - row "3"
                        - row "4"
                        - row "5"
                        - row "6"
                        - row "7"
                        - row "8"
                        - row "9"
                        - row "10"
                        - row "11"
                        - row "12"
                        - row "13"
                    - generic [ref=f2e701]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e702]:
                    - status
                    - generic [ref=f2e703]: "0"
                  - generic:
                    - generic [ref=f2e706]:
                      - combobox "InputDate Input" [ref=f2e707]: 2026-11-15
                      - button "Choose Date" [ref=f2e709] [cursor=pointer]
                    - generic [ref=f2e713]:
                      - combobox "InputDate Input" [ref=f2e714]: 2026-11-15
                      - button "Choose Date" [ref=f2e716] [cursor=pointer]
                    - generic [ref=f2e720]:
                      - combobox "InputDate Input" [ref=f2e721]: 2026-11-15
                      - button "Choose Date" [ref=f2e723] [cursor=pointer]
                    - generic [ref=f2e727]:
                      - combobox "InputDateTime Input" [ref=f2e728]: 2026-11-15 05:36:39
                      - generic [ref=f2e729]:
                        - button "Toggle Calendar" [ref=f2e730] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e732] [cursor=pointer]
                    - generic [ref=f2e736]:
                      - combobox "InputDate Input" [ref=f2e737]: 2026-11-15
                      - button "Choose Date" [ref=f2e739] [cursor=pointer]
                    - generic [ref=f2e743]:
                      - combobox "InputDate Input" [ref=f2e744]: 2026-11-15
                      - button "Choose Date" [ref=f2e746] [cursor=pointer]
                    - generic [ref=f2e750]:
                      - combobox "InputDate Input" [ref=f2e751]: 2026-11-15
                      - button "Choose Date" [ref=f2e753] [cursor=pointer]
                    - generic [ref=f2e757]:
                      - combobox "InputDateTime Input" [ref=f2e758]: 2026-11-15 05:36:40
                      - generic [ref=f2e759]:
                        - button "Toggle Calendar" [ref=f2e760] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e762] [cursor=pointer]
                    - generic [ref=f2e766]:
                      - combobox "InputDate Input" [ref=f2e767]: 2026-11-15
                      - button "Choose Date" [ref=f2e769] [cursor=pointer]
                    - generic [ref=f2e773]:
                      - combobox "InputDate Input" [ref=f2e774]: 2026-11-15
                      - button "Choose Date" [ref=f2e776] [cursor=pointer]
                    - generic [ref=f2e780]:
                      - combobox "InputDate Input" [ref=f2e781]: 2026-11-15
                      - button "Choose Date" [ref=f2e783] [cursor=pointer]
                    - generic [ref=f2e787]:
                      - combobox "InputDateTime Input" [ref=f2e788]: 2026-11-15 05:36:40
                      - generic [ref=f2e789]:
                        - button "Toggle Calendar" [ref=f2e790] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e792] [cursor=pointer]
                    - generic [ref=f2e796]:
                      - combobox "InputDate Input" [ref=f2e797]: 2026-11-15
                      - button "Choose Date" [ref=f2e799] [cursor=pointer]
                    - generic [ref=f2e803]:
                      - combobox "InputDate Input" [ref=f2e804]: 2026-11-15
                      - button "Choose Date" [ref=f2e806] [cursor=pointer]
                    - generic [ref=f2e810]:
                      - combobox "InputDate Input" [ref=f2e811]: 2026-11-15
                      - button "Choose Date" [ref=f2e813] [cursor=pointer]
                    - generic [ref=f2e817]:
                      - combobox "InputDateTime Input" [ref=f2e818]: 2026-11-15 05:36:40
                      - generic [ref=f2e819]:
                        - button "Toggle Calendar" [ref=f2e820] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e822] [cursor=pointer]
                - separator [ref=f2e824]
                - generic [ref=f2e829]:
                  - generic [ref=f2e830]:
                    - generic [ref=f2e831]: Request Info
                    - generic [ref=f2e832]:
                      - button [ref=f2e833] [cursor=pointer]
                      - button [ref=f2e838] [cursor=pointer]
                    - generic [ref=f2e845]:
                      - button "Request Complete" [ref=f2e846] [cursor=pointer]
                      - button "Cancel" [ref=f2e847] [cursor=pointer]
                  - generic [ref=f2e849]:
                    - generic [ref=f2e851]:
                      - generic [ref=f2e852]: Requestor
                      - textbox [disabled] [ref=f2e859]: 이민용
                    - generic [ref=f2e861]:
                      - generic [ref=f2e862]: Dept Name
                      - textbox [disabled] [ref=f2e869]: LG CNS
                    - generic [ref=f2e871]:
                      - generic [ref=f2e872]: Approval
                      - textbox [disabled] [ref=f2e881]
                    - generic [ref=f2e883]:
                      - generic [ref=f2e884]: Dept Name
                      - generic [ref=f2e890]:
                        - textbox [disabled] [ref=f2e891]
                        - button [ref=f2e892] [cursor=pointer]
                    - generic [ref=f2e898]:
                      - generic [ref=f2e899]: Title
                      - textbox [ref=f2e908]
                    - generic [ref=f2e910]:
                      - generic [ref=f2e911]: Change Reason
                      - generic [ref=f2e921]:
                        - combobox [ref=f2e922]
                        - button "Open" [ref=f2e924] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e929]:
                      - generic [ref=f2e930]: Reason Detail
                      - textbox [ref=f2e939]
                - separator [ref=f2e940]
                - generic [ref=f2e944]:
                  - grid [ref=f2e945]:
                    - rowgroup [ref=f2e946]:
                      - generic:
                        - row "all SO No Change Req.No Project Name Confirm id FCST Type Model Nick Name From Site To Site Incoterms Confirmed Change No":
                          - columnheader [ref=f2e947]:
                            - checkbox "all" [disabled] [ref=f2e948]
                          - columnheader "SO No" [ref=f2e949]
                          - columnheader "Change Req.No" [ref=f2e950]
                          - columnheader "Project Name" [ref=f2e951]
                          - columnheader "Confirm id" [ref=f2e952]
                          - columnheader "FCST Type" [ref=f2e953]
                          - columnheader "Model" [ref=f2e954]
                          - columnheader "Nick Name" [ref=f2e955]
                          - columnheader "From Site" [ref=f2e956]
                          - columnheader "To Site" [ref=f2e957]
                          - columnheader "Incoterms" [ref=f2e958]
                          - columnheader "Confirmed" [ref=f2e959]
                          - columnheader "Change" [ref=f2e960]
                          - gridcell "No" [ref=f2e961]
                        - row "L/T(Day) ETD ETA Trans Mode Shipment Date Qty L/T(Day) ETD ETA Trans Mode Shipment Date":
                          - columnheader "L/T(Day)" [ref=f2e962]
                          - columnheader "ETD" [ref=f2e963]
                          - columnheader "ETA" [ref=f2e964]
                          - columnheader "Trans Mode" [ref=f2e965]
                          - columnheader "Shipment Date" [ref=f2e966]
                          - columnheader "Qty" [ref=f2e967]
                          - columnheader "L/T(Day)" [ref=f2e968]
                          - columnheader "ETD" [ref=f2e969]
                          - columnheader "ETA" [ref=f2e970]
                          - columnheader "Trans Mode" [ref=f2e971]
                          - columnheader "Shipment Date" [ref=f2e972]
                    - rowgroup [ref=f2e973]:
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e975]
                    - generic [ref=f2e977]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e978]:
                    - status
                    - generic [ref=f2e979]: "0"
                  - generic:
                    - generic [ref=f2e982]:
                      - combobox "InputDate Input" [ref=f2e983]: 2026-11-15
                      - button "Choose Date" [ref=f2e985] [cursor=pointer]
                    - generic [ref=f2e989]:
                      - combobox "InputDate Input" [ref=f2e990]: 2026-11-15
                      - button "Choose Date" [ref=f2e992] [cursor=pointer]
                    - generic [ref=f2e996]:
                      - combobox "InputDate Input" [ref=f2e997]: 2026-11-15
                      - button "Choose Date" [ref=f2e999] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1004]: "0.000"
                    - generic [ref=f2e1007]:
                      - combobox "InputDate Input" [ref=f2e1008]: 2026-11-15
                      - button "Choose Date" [ref=f2e1010] [cursor=pointer]
                    - generic [ref=f2e1014]:
                      - combobox "InputDate Input" [ref=f2e1015]: 2026-11-15
                      - button "Choose Date" [ref=f2e1017] [cursor=pointer]
                    - generic [ref=f2e1021]:
                      - combobox "InputDate Input" [ref=f2e1022]: 2026-11-15
                      - button "Choose Date" [ref=f2e1024] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1029]: "0.000"
                    - generic [ref=f2e1032]:
                      - combobox "InputDate Input" [ref=f2e1033]: 2026-11-15
                      - button "Choose Date" [ref=f2e1035] [cursor=pointer]
                    - generic [ref=f2e1039]:
                      - combobox "InputDate Input" [ref=f2e1040]: 2026-11-15
                      - button "Choose Date" [ref=f2e1042] [cursor=pointer]
                    - generic [ref=f2e1046]:
                      - combobox "InputDate Input" [ref=f2e1047]: 2026-11-15
                      - button "Choose Date" [ref=f2e1049] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1054]: "0.000"
                    - generic [ref=f2e1057]:
                      - combobox "InputDate Input" [ref=f2e1058]: 2026-11-15
                      - button "Choose Date" [ref=f2e1060] [cursor=pointer]
                    - generic [ref=f2e1064]:
                      - combobox "InputDate Input" [ref=f2e1065]: 2026-11-15
                      - button "Choose Date" [ref=f2e1067] [cursor=pointer]
                    - generic [ref=f2e1071]:
                      - combobox "InputDate Input" [ref=f2e1072]: 2026-11-15
                      - button "Choose Date" [ref=f2e1074] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1079]: "0.000"
            - alert [ref=f2e1080]:
              - generic [ref=f2e1081] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1084] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  1   | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-14) · 원천: Doc/gen/SSP0200/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2   | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3   | import * as fs from 'node:fs';
  4   | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SSP0200.plan.json', 'utf8'));
  5   | const MENU = "SSP0200";
  6   | import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
  7   | import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)
  8   | 
  9   | test.describe(`${MENU} ShipmentChangeRequest 스모크 @smoke`, () => {
  10  |   test.use({ account: PLAN.sample.account || undefined });
  11  |   test('화면 열림 · 조회조건 · 조회 · 그리드 컬럼', async ({ nscm, page }) => {
  12  |     const r = await nscm.openScreen(MENU);
  13  |     expect(r.notFound, '404 아님').toBeFalsy();
  14  |     expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  15  |     await nscm.snapshot(`${MENU}_open`);
  16  |     // 2026-10-21: 화면 열자마자 콘솔 치명 오류를 먼저 확인 — 그리드 생성이 Wijmo 단언으로 죽으면(SCP0100 "Unknown property inner") 뒤의 라벨/그리드 검사는 전부 부수 증상이다
  17  |     { await page.waitForTimeout(800); const errs0 = nscm.consoleErrors; const fatal0 = errs0.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
  18  |       if (errs0.length) test.info().annotations.push({ type: 'console', description: `열림 직후 오류 ${errs0.length}(치명 ${fatal0.length}): ${[...fatal0, ...errs0.filter(e => !fatal0.includes(e))].slice(0, 3).join(' || ')}` });
  19  |       expect.soft(fatal0.length, `화면 열림 직후 브라우저 콘솔 치명 오류 0 — ${fatal0[0] || ''}`).toBe(0); }
  20  |     // 조회조건 라벨 존재(soft) — 2026-10-21: 접힌 조건(extraConditions) 펼친 뒤, To-Be LBL 문구 → As-is 라벨('*' 제거) → '/' 분할 후보 순으로 찾는다.
  21  |     //   __asis-mapping__.md 에서 '제외' 로 닫힌 As-is 컨트롤(dead control·NO-OP)은 검사하지 않고 어노테이션만 남긴다.
  22  |     const expanded = await nscm.expandSearchArea();
  23  |     const labelHits: string[] = [], labelMiss: string[] = [], labelSkip: string[] = [];
  24  |     for (const f of PLAN.fields) {
  25  |       if (f.excluded) { labelSkip.push(`${f.label}(${f.asis}: ${f.excludedWhy})`); continue; }
  26  |       // 2026-11-08 (a): 별칭 표의 TO-BE 명칭(예 Valid→Active)도 후보 — 검사기와 기대값 원천을 같이 쓴다(종전엔 smoke 만 별칭 없이 '누락' → 검사기 PASS 와 불일치)
  27  |       const cands0: string[] = f.labels && f.labels.length ? f.labels : [f.label];
  28  |       const AL = loadLabelAliases(MENU); const cands = [...new Set([...cands0, ...cands0.map((l: string) => aliasFor(l, AL)?.tobe_label || '').filter(Boolean)])];
  29  |       const hit = await nscm.fieldExistsAny(cands);
  30  |       if (hit) labelHits.push(`${f.label}→${hit}`); else labelMiss.push(f.label);
  31  |       expect.soft(!!hit, `조회조건 '${f.label}' (${f.component}) — 후보 [${(f.labels || [f.label]).join(' | ')}]`).toBeTruthy();
  32  |     }
  33  |     test.info().annotations.push({ type: 'labels', description: `펼침=${expanded} 일치 ${labelHits.length} / 누락 ${labelMiss.length}${labelMiss.length ? ': ' + labelMiss.join(', ') : ''}${labelSkip.length ? ' / 제외 ' + labelSkip.length + ': ' + labelSkip.join('; ') : ''}` });
  34  |     // 그리드 수 ≥ 1 (다그리드는 탭/패널이라 1 이상이면 통과, 메인시트 수와 함께 기록)
  35  |     const gridCount = await nscm.grids().count();
  36  |     expect(gridCount, `그리드 ≥1 (메인시트 ${PLAN.mainSheets.length})`).toBeGreaterThanOrEqual(1);
  37  |     // Division 선택(있으면) 후 조회
  38  |     if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
  39  |     const calls = await nscm.search();
  40  |     const search = calls.filter(c => /SEARCH|GET|_|^$/i.test(c.btn));
  41  |     expect(calls.length, 'call-proc 호출 발생').toBeGreaterThan(0);
  42  |     for (const c of calls) expect.soft(c.status, `call-proc ${c.sheet}/${c.btn} HTTP`).toBeLessThan(400);
  43  |     // 2026-10-21: 브라우저 콘솔 오류/페이지 예외 — Wijmo 단언(그리드 생성 실패)·Uncaught 는 화면 결함으로 FAIL, 나머지는 기록만
  44  |     { const errs = nscm.consoleErrors; const fatal = errs.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
  45  |       test.info().annotations.push({ type: 'console', description: errs.length ? `오류 ${errs.length}(치명 ${fatal.length}): ${[...fatal, ...errs.filter(e => !fatal.includes(e))].slice(0, 3).join(' || ')}` : '오류 0' });
  46  |       expect.soft(fatal.length, `브라우저 콘솔 치명 오류 0 — ${fatal[0] || ''}`).toBe(0); }
  47  |     const alert = await nscm.alertText(); if (alert) { await nscm.closeAlert(); }
  48  |     expect.soft(alert, '조회 후 오류 알림 없음').not.toMatch(/ORA-|Exception|오류|error/i);
  49  |     // 컬럼 대사: 메타(sheet_columns) 있으면 메타, 없으면 As-is 라벨(soft)
  50  |     const headers = await nscm.gridHeadersAll(0);  // T162: 가로 가상화로 DOM 헤더가 일부만 보여 허위 누락
  51  |     // 기대 컬럼의 시트 = 실제 조회된 시트(첫 SEARCH call-proc 의 sheet → register.json adminSheetName). 매핑이 없으면 mainSheets[0]
  52  |     const titleSheets: string[] = (PLAN.dynamicHeader && PLAN.dynamicHeader.titleSheets) || [];
  53  |     const firstSearch = calls.find(c => /SEARCH/i.test(c.btn) && !titleSheets.includes(c.sheet)) || calls.find(c => /SEARCH/i.test(c.btn)) || calls[0]; // 타이틀(기간 헤더) 시트 호출은 제외
  54  |     const mappedSheet = firstSearch && PLAN.sheetMap ? PLAN.sheetMap[firstSearch.sheet] : '';
  55  |     const sheetName = mappedSheet && PLAN.mainSheets.some((s: { name: string }) => s.name === mappedSheet) ? mappedSheet : PLAN.mainSheets[0]?.name;
  56  |     const expectCols = PLAN.hasMeta ? (PLAN.expectedCols[sheetName]?.[PLAN.sample.div] || []) : (PLAN.mainSheets.find((s: { name: string }) => s.name === sheetName)?.labels || []);
  57  |     const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
  58  |     // 2026-10-21: As-is SetLayout(조회조건에 따라 표시/숨김)이 다루는 컬럼은 기본 조회에서 안 보여도 '누락' 이 아니다(SCP0100 Product Level1~3)
  59  |     const condSet = new Set(((PLAN.condLabels || []) as string[]).map(norm));
  60  |     const missingAll = expectCols.filter((c: string) => c && !headers.some(h => norm(h) === norm(c) || norm(h).includes(norm(c))));
  61  |     const condHidden = missingAll.filter((c: string) => condSet.has(norm(c)));
  62  |     const missing = missingAll.filter((c: string) => !condSet.has(norm(c)));
  63  |     test.info().annotations.push({ type: 'columns', description: `시트 ${sheetName}(${firstSearch ? firstSearch.sheet : '-'}) 헤더 ${headers.length} / 기대 ${expectCols.length} / 누락 ${missing.length}: ${missing.slice(0, 10).join(', ')}${condHidden.length ? ' / 조건부 표시(SetLayout) 제외 ' + condHidden.length + ': ' + condHidden.join(', ') : ''}` });
  64  |     expect.soft(missing.length, `그리드 컬럼 누락 (${PLAN.hasMeta ? '메타' : 'As-is 라벨'} 기준)`).toBeLessThanOrEqual(Math.ceil(expectCols.length * 0.2));
  65  |     // 동적 헤더(기간 컬럼) — As-is 타이틀 SP/DB루프가 있으면 정적 메타 밖 컬럼 ≥1 + 사내 배선 타이틀 시트 조회(2026-10-20 SCP0096)
  66  |     // As-is 헤더 사양 대조(2026-10-21 SCP0100: 대조표 '구현' 인데 3단 헤더가 144px 한 칸으로 병합되고 "Qty" 행이 없었다) — 행 수·병합 리터럴·행 높이
  67  |     if (PLAN.headerSpec && PLAN.headerSpec.rows > 1) {
  68  |       const HS = PLAN.headerSpec; const hr = await nscm.gridHeaderRows(0);
  69  |       const texts = new Set(hr.rows.flatMap(r => r.texts));
  70  |       const missLit = (HS.literals || []).filter((l: string) => !texts.has(l));
  71  |       test.info().annotations.push({ type: 'header', description: `As-is 헤더 ${HS.rows}행(병합 리터럴 ${(HS.literals || []).join('/') || '-'}) ↔ To-Be 행 ${hr.rows.length}(높이 ${hr.rows.map(r => r.h).join('+')}=${hr.height}px)${missLit.length ? ' · 리터럴 누락 ' + missLit.join(',') : ''}` });
  72  |       // 행 수는 '시각적 단' 기준 — As-is 월간은 3행이어도 Qty 가 1~2행을 병합해 2단으로 보인다. 따라서 2단 이상이면 통과(리터럴·분리·높이 검사가 실질 판정)
  73  |       expect.soft(hr.rows.length, `헤더 시각적 단 수 ≥ 2 (As-is SetSheetHeaderColumn ${HS.rows}행 · 월간은 Qty 2행 병합 = 2단) — 1단이면 columnGroups leaf 라벨 점검`).toBeGreaterThanOrEqual(Math.min(HS.rows, 2));
> 74  |       expect.soft(missLit.length, `As-is 병합 헤더 리터럴 노출 [${(HS.literals || []).join(', ')}]`).toBe(0);
      |                                                                                             ^ Error: As-is 병합 헤더 리터럴 노출 [Plan, Confirm, L/T(Day), ETD, ETA, Trans Mode, Shipment Date, Qty, Shipment Date*, Qty*, Confirmed, Change]
  75  |       expect.soft(hr.height, `헤더 총 높이 ≤ ${HS.maxRowPx}px × ${HS.rows}행 (headerRowHeight 재적용 — check.js H01)`).toBeLessThanOrEqual(HS.maxRowPx * HS.rows);
  76  |       // 2026-10-21 사용자 지적: ① 리터럴(Qty) 칸은 상단 월 칸이 분리돼 있으면 하단도 분리(가로 병합 1칸 금지) ② leaf(Qty) 행이 그룹(월) 행보다 낮으면 As-is 와 역전
  77  |       if (HS.literals && HS.literals.length && hr.rows.length >= 2) {
  78  |         const top = hr.rows[0]; const litRow = hr.rows.find(r => (HS.literals as string[]).some((l: string) => r.texts.includes(l)));
  79  |         if (litRow) {
  80  |           const topDyn = top.cells.filter(c => !/^[A-Za-z가-힣 ./()]+$/.test(c)).length; // 상단 행에서 문자 라벨(고정 컬럼)이 아닌 칸(연월·주차) 수
  81  |           test.info().annotations.push({ type: 'header', description: `리터럴 행 칸 ${litRow.n} / 상단 동적 칸 ${topDyn} · 높이 상단 ${top.h} vs 리터럴 행 ${litRow.h}` });
  82  |           if (topDyn >= 2) expect.soft(litRow.n, `리터럴(${HS.literals.join('/')}) 칸이 월마다 분리(상단 동적 칸 ${topDyn}) — 1칸이면 헤더 가로 병합(check.js H05)`).toBeGreaterThanOrEqual(Math.min(topDyn, 2));
  83  |           expect.soft(litRow.h >= top.h, `leaf(${HS.literals.join('/')}) 행 높이(${litRow.h}) ≥ 상단 그룹 행(${top.h}) — As-is 는 Qty 영역이 더 높다(1~2행 병합)`).toBeTruthy();
  84  |         }
  85  |       }
  86  |     }
  87  |     if (PLAN.dynamicHeader) {
  88  |       const DH = PLAN.dynamicHeader;
  89  |       const binds = await nscm.gridBindings(0);
  90  |       const stat = new Set((DH.staticBindings || []).map((s: string) => s.toUpperCase()));
  91  |       const dyn = (binds || []).filter((b: string) => !stat.has(b.toUpperCase()));
  92  |       const titleCalls = nscm.calls.filter(c => (DH.titlePairs || []).some((p: { sheet: string; btn: string }) => p.sheet === c.sheet && p.btn.toUpperCase() === c.btn.toUpperCase()));
  93  |       test.info().annotations.push({ type: 'dynamic', description: `As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || '-'} · DB루프 ${(DH.dbLoop || []).join(',') || '-'} · 컬럼정의 ${binds ? binds.length : '판정불가'} / 정적밖 ${dyn.length} (${dyn.slice(0, 5).join(',')}) · 타이틀 시트 ${(DH.titleSheets || []).join(',') || '(사내 배선 없음)'} 호출 ${titleCalls.length}` });
  94  |       expect.soft(binds, '그리드 컬럼 정의 판독(Wijmo columns) — null 이면 판정 불가(ERROR)').not.toBeNull();
  95  |       expect.soft(dyn.length, `동적 기간 컬럼 ≥1 (As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || 'DB루프'} — 정적 메타 ${stat.size}개 밖 컬럼)`).toBeGreaterThan(0);
  96  |       if ((DH.titleSheets || []).length) expect.soft(titleCalls.some(c => c.status < 400), `타이틀 시트 '${DH.titleSheets.join("','")}' call-proc 조회`).toBeTruthy();
  97  |     }
  98  |     await nscm.snapshot(`${MENU}_searched`);
  99  |     test.info().annotations.push({ type: 'calls', description: JSON.stringify(calls.map(c => [c.sheet, c.btn, c.status, c.rows, c.ms])) });
  100 |     // 2026-10-23 사용자 지시: 다국어 미적용(코드 미등록 → '_기본문구' 노출) = 오류 — 조회조건 펼침·조회 후 보이는 글자 전체
  101 |     { const u = await nscm.untranslatedTexts();
  102 |       test.info().annotations.push({ type: 'i18n', description: u.length ? `'_' 노출 ${u.length}: ${u.slice(0, 15).join(' | ')}` : "'_' 노출 0" });
  103 |       expect.soft(u.length, `다국어 미적용 '_' 노출 0 — ${u.slice(0, 8).join(' | ')} (SCM_ADM_MSG_M 에 코드 등록 또는 기존 LBL/MSG 재사용 · 하네스 I18N1)`).toBe(0); }
  104 |   });
  105 |   // 2026-10-23 사용자 지시: 조회조건 각각의 동작 · 공통 기능 동작 (lib/smoke-extra.ts) — 결과는 cond:/common: 어노테이션 → _summary · 대조표(recon) 열
  106 |   test('조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인', async ({ nscm }) => {
  107 |     test.setTimeout(1_200_000);
  108 |     const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  109 |     const items = await conditionCycle(nscm, test.info(), PLAN);
  110 |     const s = record(test.info(), 'cond', items);
  111 |     await nscm.snapshot(`${MENU}_cond`);
  112 |     expect.soft(s.fail, `조회조건 동작 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  113 |     expect.soft(s.error, `조회조건 판정 불가(ERROR) ${s.error}: ${items.filter(i => i.verdict === 'ERROR').map(i => i.name).join(', ')}`).toBe(0);
  114 |   });
  115 |   test('공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual', async ({ nscm }) => {
  116 |     test.setTimeout(600_000);
  117 |     const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  118 |     const items = await commonCycle(nscm, test.info(), PLAN);
  119 |     const s = record(test.info(), 'common', items);
  120 |     await nscm.snapshot(`${MENU}_common`);
  121 |     expect.soft(s.fail, `공통 기능 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  122 |   });
  123 | });
  124 | 
```