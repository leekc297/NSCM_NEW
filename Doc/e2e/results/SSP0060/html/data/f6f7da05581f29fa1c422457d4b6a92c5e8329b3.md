# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0060.smoke.spec.ts >> SSP0060 ShipmentPlan 스모크 @smoke >> 화면 열림 · 조회조건 · 조회 · 그리드 컬럼
- Location: ..\..\Doc\e2e\specs\SSP0060.smoke.spec.ts:11:7

# Error details

```
Error: 조회조건 'Sum(Week)' (Checkbox) — 후보 [Sum(Week)]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'Total PSI' (Checkbox) — 후보 [Total PSI]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'Box ID' (InputField) — 후보 [Box ID]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'Result Type' (CustomDropdown) — 후보 [Result Type]

expect(received).toBeTruthy()

Received: false
```

```
Error: 그리드 컬럼 누락 (메타 기준)

expect(received).toBeLessThanOrEqual(expected)

Expected: <= 2
Received:    6
```

```
Error: As-is 병합 헤더 리터럴 노출 [SUM]

expect(received).toBe(expected) // Object.is equality

Expected: 0
Received: 1
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/SSP0060
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/SSP0060
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
              - /url: /view/SSP0060
              - paragraph [ref=f2e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0060
              - paragraph [ref=f2e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0060
              - paragraph [ref=f2e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0060
              - paragraph [ref=f2e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0060
              - paragraph [ref=f2e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0060
              - paragraph [ref=f2e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0060
              - paragraph [ref=f2e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0060
              - paragraph [ref=f2e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0060
              - paragraph [ref=f2e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f2e53]:
            - link [ref=f2e54] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e55]: Shipping Schedule
            - link [ref=f2e58] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e59]: Shipment Request
            - link [ref=f2e60] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e61]: Shipment Plan(Mobility & IT)
            - link [ref=f2e62] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e63]: Shipment Plan(Electrode)
            - link [ref=f2e64] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f2e66] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e67]: Shipment Plan Detail
            - link [ref=f2e68] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e69]: Shipment Change History
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e71]: Shipment Plan(Auto & ESS)
            - link [ref=f2e72] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e73]: Shipment Request(Mobility & IT)
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e75]: Shipment Request(Electrode)
            - link [ref=f2e76] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e77]: Shipment Change Request
            - link [ref=f2e78] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e79]: Shipment Change Request Confirm
            - link [ref=f2e80] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e81]: Inventory Raw(Mobility & IT)
            - link [ref=f2e82] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e83]: Shipment Change Request(Packer)
            - link [ref=f2e84] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f2e87]: Shipment Request SEMI
      - main [ref=f2e88]:
        - generic [ref=f2e90]:
          - generic [ref=f2e91]:
            - generic [ref=f2e92]:
              - button "Home" [ref=f2e93] [cursor=pointer]
              - button "Shipment Plan(Auto & ESS)-WA_UC" [ref=f2e95] [cursor=pointer]
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
                  - paragraph [ref=f2e120]: Shipment Plan(Auto & ESS)-WA_UC
                - generic [ref=f2e121]:
                  - generic [ref=f2e122]: Shipping
                  - generic [ref=f2e127]: Shipping Schedule
                  - generic [ref=f2e132]: Shipment Plan(Auto & ESS)-WA_UC
                - generic [ref=f2e134]:
                  - generic [ref=f2e135]: Search Area
                  - switch [checked] [ref=f2e138] [cursor=pointer]
                - button "Full screen" [ref=f2e141] [cursor=pointer]
              - generic [ref=f2e150]:
                - generic [ref=f2e151]:
                  - generic [ref=f2e152]:
                    - generic [ref=f2e154]:
                      - generic [ref=f2e155]: Div*
                      - generic [ref=f2e163]:
                        - combobox [ref=f2e164]: 82 ESS Battery
                        - button "Open" [ref=f2e166] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e171]:
                      - generic [ref=f2e172]: Company*
                      - generic [ref=f2e180]:
                        - combobox [ref=f2e181]: ESUC
                        - button "Open" [ref=f2e183] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e188]:
                      - generic [ref=f2e189]: From Site
                      - generic [ref=f2e197] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e198]
                        - button "Open" [ref=f2e200]
                        - group [aria-hidden]
                    - generic [ref=f2e205]:
                      - generic [ref=f2e206]: Bucket
                      - generic [ref=f2e214]:
                        - combobox [ref=f2e215]: Daily
                        - button "Open" [ref=f2e217] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e222]:
                      - generic [ref=f2e223]: Plan Date*
                      - generic [ref=f2e231]:
                        - combobox [ref=f2e232]: 2026-10-09
                        - button "Open" [ref=f2e234] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e239]:
                      - generic [ref=f2e240]: Period
                      - generic [ref=f2e247]:
                        - generic [ref=f2e250]:
                          - img [aria-hidden] [ref=f2e252] [cursor=pointer]
                          - textbox "YYYY.MM.DD" [ref=f2e260]: 2026.10.09
                        - generic [ref=f2e261]: ~
                        - generic [ref=f2e264]:
                          - img [aria-hidden] [ref=f2e266] [cursor=pointer]
                          - textbox "YYYY.MM.DD" [ref=f2e274]: 2026.10.23
                    - generic [ref=f2e276]:
                      - generic [ref=f2e277]: Model/Nickname
                      - generic [ref=f2e283]:
                        - textbox [ref=f2e284]
                        - button [ref=f2e285] [cursor=pointer]
                    - generic [ref=f2e291]:
                      - generic [ref=f2e292]: Product Level1
                      - generic [ref=f2e300] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e301]
                        - button "Open" [ref=f2e303]
                        - group [aria-hidden]
                  - generic [ref=f2e307]:
                    - button [active] [ref=f2e308] [cursor=pointer]
                    - button [ref=f2e313] [cursor=pointer]
                - generic [ref=f2e318]:
                  - separator [ref=f2e319]
                  - generic [ref=f2e327] [cursor=pointer]:
                    - checkbox "Sum" [ref=f2e329]
                    - generic [ref=f2e330]: Sum
              - generic [ref=f2e331]:
                - generic [ref=f2e332]:
                  - paragraph
                  - generic [ref=f2e333]: 총13건
                - generic [ref=f2e334]:
                  - generic "Measure" [ref=f2e335]:
                    - button "Measure" [ref=f2e336] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e340]:
                    - button [ref=f2e341] [cursor=pointer]
                  - generic "Remove" [ref=f2e346]:
                    - button [ref=f2e347] [cursor=pointer]
                  - generic "Save" [ref=f2e354]:
                    - button [ref=f2e355] [cursor=pointer]
                  - generic "Sort" [ref=f2e359]:
                    - button [ref=f2e360] [cursor=pointer]
                  - generic "Filter" [ref=f2e365]:
                    - button [ref=f2e366] [cursor=pointer]
                  - generic "Condition" [ref=f2e371]:
                    - button [ref=f2e372] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e382]:
                    - button [ref=f2e383] [cursor=pointer]
                  - generic "Excel" [ref=f2e390]:
                    - button [ref=f2e391] [cursor=pointer]
              - generic [ref=f2e399]:
                - generic [ref=f2e403]:
                  - grid [ref=f2e404]:
                    - rowgroup [ref=f2e405]:
                      - generic:
                        - row "Div From Site Product Level1 Model Nick Name BOH PSI Measure To Site Transmode Incoterms FCST Type 2026-10 No":
                          - columnheader "Div" [ref=f2e406]
                          - columnheader "From Site" [ref=f2e407]
                          - columnheader "Product Level1" [ref=f2e408]
                          - columnheader "Model" [ref=f2e409]
                          - columnheader "Nick Name" [ref=f2e410]
                          - columnheader "BOH" [ref=f2e411]
                          - columnheader "PSI" [ref=f2e412]
                          - columnheader "Measure" [ref=f2e413]
                          - columnheader "To Site" [ref=f2e414]
                          - columnheader "Transmode" [ref=f2e415]
                          - columnheader "Incoterms" [ref=f2e416]
                          - columnheader "FCST Type" [ref=f2e417]
                          - columnheader "2026-10" [ref=f2e418]
                          - gridcell "No" [ref=f2e419]
                          - gridcell [ref=f2e420]
                        - row "W41 W42":
                          - columnheader "W41" [ref=f2e421]
                          - columnheader "W42" [ref=f2e422]
                        - row "09 10 11 12 13 14 15 16 17":
                          - columnheader "09" [ref=f2e423]
                          - columnheader "10" [ref=f2e424]
                          - columnheader "11" [ref=f2e425]
                          - columnheader "12" [ref=f2e426]
                          - columnheader "13" [ref=f2e427]
                          - columnheader "14" [ref=f2e428]
                          - columnheader "15" [ref=f2e429]
                          - columnheader "16" [ref=f2e430]
                          - columnheader "17" [ref=f2e431]
                    - rowgroup [ref=f2e432]:
                      - generic [ref=f2e433]:
                        - row "82 virtual plant(GM01)-Cell - ECE1592F1-01-H00 JF2-H00 S Shipment Plan[R+P] 0 0 0 0 0 0 0 0 0 1":
                          - gridcell "82" [selected] [ref=f2e434]
                          - gridcell "virtual plant(GM01)-Cell" [ref=f2e435]
                          - gridcell "-" [ref=f2e436]
                          - gridcell "ECE1592F1-01-H00" [ref=f2e437]
                          - gridcell "JF2-H00" [ref=f2e438]
                          - gridcell [ref=f2e439]
                          - gridcell [ref=f2e440]
                          - gridcell "S" [ref=f2e441]
                          - gridcell "Shipment Plan[R+P]" [ref=f2e442]
                          - gridcell [ref=f2e443]
                          - gridcell [ref=f2e444]
                          - gridcell [ref=f2e445]
                          - gridcell [ref=f2e446]
                          - gridcell "0" [ref=f2e447]
                          - gridcell "0" [ref=f2e448]
                          - gridcell "0" [ref=f2e449]
                          - gridcell "0" [ref=f2e450]
                          - gridcell "0" [ref=f2e451]
                          - gridcell "0" [ref=f2e452]
                          - gridcell "0" [ref=f2e453]
                          - gridcell "0" [ref=f2e454]
                          - gridcell "0" [ref=f2e455]
                          - gridcell "1" [ref=f2e456]
                          - gridcell [ref=f2e457]
                        - row "Shipment Plan US02279100_82-P TRK FCA - 0 0 0 0 0 0 0 0 0 2":
                          - gridcell [ref=f2e458]
                          - gridcell [ref=f2e459]
                          - gridcell "Shipment Plan" [ref=f2e460]
                          - gridcell "US02279100_82-P" [ref=f2e461]
                          - gridcell "TRK" [ref=f2e462]
                          - gridcell "FCA" [ref=f2e463]
                          - gridcell "-" [ref=f2e464]
                          - gridcell "0" [ref=f2e465]
                          - gridcell "0" [ref=f2e466]
                          - gridcell "0" [ref=f2e467]
                          - gridcell "0" [ref=f2e468]
                          - gridcell "0" [ref=f2e469]
                          - gridcell "0" [ref=f2e470]
                          - gridcell "0" [ref=f2e471]
                          - gridcell "0" [ref=f2e472]
                          - gridcell "0" [ref=f2e473]
                          - gridcell "2" [ref=f2e474]
                          - gridcell [ref=f2e475]
                        - row "oWMS 98 Internal movement 0 0 0 0 0 0 0 0 0 3":
                          - gridcell "oWMS" [ref=f2e476]
                          - gridcell "98" [ref=f2e477]
                          - gridcell "Internal movement" [ref=f2e478]
                          - gridcell [ref=f2e479]
                          - gridcell [ref=f2e480]
                          - gridcell [ref=f2e481]
                          - gridcell [ref=f2e482]
                          - gridcell "0" [ref=f2e483]
                          - gridcell "0" [ref=f2e484]
                          - gridcell "0" [ref=f2e485]
                          - gridcell "0" [ref=f2e486]
                          - gridcell "0" [ref=f2e487]
                          - gridcell "0" [ref=f2e488]
                          - gridcell "0" [ref=f2e489]
                          - gridcell "0" [ref=f2e490]
                          - gridcell "0" [ref=f2e491]
                          - gridcell "3" [ref=f2e492]
                          - gridcell [ref=f2e493]
                        - row "MES 0 Container Qty 0 0 0 0 0 0 0 0 0 4":
                          - gridcell "MES" [ref=f2e494]
                          - gridcell "0" [ref=f2e495]
                          - gridcell "Container Qty" [ref=f2e496]
                          - gridcell [ref=f2e497]
                          - gridcell [ref=f2e498]
                          - gridcell [ref=f2e499]
                          - gridcell [ref=f2e500]
                          - gridcell "0" [ref=f2e501]
                          - gridcell "0" [ref=f2e502]
                          - gridcell "0" [ref=f2e503]
                          - gridcell "0" [ref=f2e504]
                          - gridcell "0" [ref=f2e505]
                          - gridcell "0" [ref=f2e506]
                          - gridcell "0" [ref=f2e507]
                          - gridcell "0" [ref=f2e508]
                          - gridcell "0" [ref=f2e509]
                          - gridcell "4" [ref=f2e510]
                          - gridcell [ref=f2e511]
                        - row "ERP 0 P Production 0 0 0 0 0 0 0 0 0 5":
                          - gridcell "ERP" [ref=f2e512]
                          - gridcell "0" [ref=f2e513]
                          - gridcell "P" [ref=f2e514]
                          - gridcell "Production" [ref=f2e515]
                          - gridcell [ref=f2e516]
                          - gridcell [ref=f2e517]
                          - gridcell [ref=f2e518]
                          - gridcell [ref=f2e519]
                          - gridcell "0" [ref=f2e520]
                          - gridcell "0" [ref=f2e521]
                          - gridcell "0" [ref=f2e522]
                          - gridcell "0" [ref=f2e523]
                          - gridcell "0" [ref=f2e524]
                          - gridcell "0" [ref=f2e525]
                          - gridcell "0" [ref=f2e526]
                          - gridcell "0" [ref=f2e527]
                          - gridcell "0" [ref=f2e528]
                          - gridcell "5" [ref=f2e529]
                          - gridcell [ref=f2e530]
                        - row "BOH 98 I Balance 98 98 98 98 98 98 98 98 98 6":
                          - gridcell "BOH" [ref=f2e531]
                          - gridcell "98" [ref=f2e532]
                          - gridcell "I" [ref=f2e533]
                          - gridcell "Balance" [ref=f2e534]
                          - gridcell [ref=f2e535]
                          - gridcell [ref=f2e536]
                          - gridcell [ref=f2e537]
                          - gridcell [ref=f2e538]
                          - gridcell "98" [ref=f2e539]
                          - gridcell "98" [ref=f2e540]
                          - gridcell "98" [ref=f2e541]
                          - gridcell "98" [ref=f2e542]
                          - gridcell "98" [ref=f2e543]
                          - gridcell "98" [ref=f2e544]
                          - gridcell "98" [ref=f2e545]
                          - gridcell "98" [ref=f2e546]
                          - gridcell "98" [ref=f2e547]
                          - gridcell "6" [ref=f2e548]
                          - gridcell [ref=f2e549]
                        - row "ECE1592F1-01-H01 JF2-H01 S Shipment Plan[R+P] 71,344 76,832 76,832 0 537,824 0 0 0 0 7":
                          - gridcell "ECE1592F1-01-H01" [ref=f2e550]
                          - gridcell "JF2-H01" [ref=f2e551]
                          - gridcell [ref=f2e552]
                          - gridcell [ref=f2e553]
                          - gridcell "S" [ref=f2e554]
                          - gridcell "Shipment Plan[R+P]" [ref=f2e555]
                          - gridcell [ref=f2e556]
                          - gridcell [ref=f2e557]
                          - gridcell [ref=f2e558]
                          - gridcell [ref=f2e559]
                          - gridcell "71,344" [ref=f2e560]
                          - gridcell "76,832" [ref=f2e561]
                          - gridcell "76,832" [ref=f2e562]
                          - gridcell "0" [ref=f2e563]
                          - gridcell "537,824" [ref=f2e564]
                          - gridcell "0" [ref=f2e565]
                          - gridcell "0" [ref=f2e566]
                          - gridcell "0" [ref=f2e567]
                          - gridcell "0" [ref=f2e568]
                          - gridcell "7" [ref=f2e569]
                          - gridcell [ref=f2e570]
                        - row "Shipment Plan US02279100_82-P TRK FCA - 0 0 0 0 537,824 0 0 0 0 8":
                          - gridcell [ref=f2e571]
                          - gridcell [ref=f2e572]
                          - gridcell "Shipment Plan" [ref=f2e573]
                          - gridcell "US02279100_82-P" [ref=f2e574]
                          - gridcell "TRK" [ref=f2e575]
                          - gridcell "FCA" [ref=f2e576]
                          - gridcell "-" [ref=f2e577]
                          - gridcell "0" [ref=f2e578]
                          - gridcell "0" [ref=f2e579]
                          - gridcell "0" [ref=f2e580]
                          - gridcell "0" [ref=f2e581]
                          - gridcell "537,824" [ref=f2e582]
                          - gridcell "0" [ref=f2e583]
                          - gridcell "0" [ref=f2e584]
                          - gridcell "0" [ref=f2e585]
                          - gridcell "0" [ref=f2e586]
                          - gridcell "8" [ref=f2e587]
                          - gridcell [ref=f2e588]
                        - row "Mass 71,344 76,832 76,832 0 0 0 0 0 0 9":
                          - gridcell [ref=f2e589]
                          - gridcell [ref=f2e590]
                          - gridcell "Mass" [ref=f2e591]
                          - gridcell "71,344" [ref=f2e592]
                          - gridcell "76,832" [ref=f2e593]
                          - gridcell "76,832" [ref=f2e594]
                          - gridcell "0" [ref=f2e595]
                          - gridcell "0" [ref=f2e596]
                          - gridcell "0" [ref=f2e597]
                          - gridcell "0" [ref=f2e598]
                          - gridcell "0" [ref=f2e599]
                          - gridcell "0" [ref=f2e600]
                          - gridcell "9" [ref=f2e601]
                          - gridcell [ref=f2e602]
                        - row "oWMS 130,732 Internal movement 0 0 0 0 0 0 0 0 0 10":
                          - gridcell "oWMS" [ref=f2e603]
                          - gridcell "130,732" [ref=f2e604]
                          - gridcell "Internal movement" [ref=f2e605]
                          - gridcell [ref=f2e606]
                          - gridcell [ref=f2e607]
                          - gridcell [ref=f2e608]
                          - gridcell [ref=f2e609]
                          - gridcell "0" [ref=f2e610]
                          - gridcell "0" [ref=f2e611]
                          - gridcell "0" [ref=f2e612]
                          - gridcell "0" [ref=f2e613]
                          - gridcell "0" [ref=f2e614]
                          - gridcell "0" [ref=f2e615]
                          - gridcell "0" [ref=f2e616]
                          - gridcell "0" [ref=f2e617]
                          - gridcell "0" [ref=f2e618]
                          - gridcell "10" [ref=f2e619]
                          - gridcell [ref=f2e620]
                        - row "MES 0 Container Qty 1 1 1 0 4 0 0 0 0 11":
                          - gridcell "MES" [ref=f2e621]
                          - gridcell "0" [ref=f2e622]
                          - gridcell "Container Qty" [ref=f2e623]
                          - gridcell [ref=f2e624]
                          - gridcell [ref=f2e625]
                          - gridcell [ref=f2e626]
                          - gridcell [ref=f2e627]
                          - gridcell "1" [ref=f2e628]
                          - gridcell "1" [ref=f2e629]
                          - gridcell "1" [ref=f2e630]
                          - gridcell "0" [ref=f2e631]
                          - gridcell "4" [ref=f2e632]
                          - gridcell "0" [ref=f2e633]
                          - gridcell "0" [ref=f2e634]
                          - gridcell "0" [ref=f2e635]
                          - gridcell "0" [ref=f2e636]
                          - gridcell "11" [ref=f2e637]
                          - gridcell [ref=f2e638]
                        - row "ERP 0 P Production 69,956 69,956 40,031 0 0 69,956 69,956 69,956 69,956 12":
                          - gridcell "ERP" [ref=f2e639]
                          - gridcell "0" [ref=f2e640]
                          - gridcell "P" [ref=f2e641]
                          - gridcell "Production" [ref=f2e642]
                          - gridcell [ref=f2e643]
                          - gridcell [ref=f2e644]
                          - gridcell [ref=f2e645]
                          - gridcell [ref=f2e646]
                          - gridcell "69,956" [ref=f2e647]
                          - gridcell "69,956" [ref=f2e648]
                          - gridcell "40,031" [ref=f2e649]
                          - gridcell "0" [ref=f2e650]
                          - gridcell "0" [ref=f2e651]
                          - gridcell "69,956" [ref=f2e652]
                          - gridcell "69,956" [ref=f2e653]
                          - gridcell "69,956" [ref=f2e654]
                          - gridcell "69,956" [ref=f2e655]
                          - gridcell "12" [ref=f2e656]
                          - gridcell [ref=f2e657]
                        - row "BOH 130,732 I Balance 59,388 52,512 45,636 85,667 -452,157 -452,157 -382,201 -312,245 -242,289 13":
                          - gridcell "BOH" [ref=f2e658]
                          - gridcell "130,732" [ref=f2e659]
                          - gridcell "I" [ref=f2e660]
                          - gridcell "Balance" [ref=f2e661]
                          - gridcell [ref=f2e662]
                          - gridcell [ref=f2e663]
                          - gridcell [ref=f2e664]
                          - gridcell [ref=f2e665]
                          - gridcell "59,388" [ref=f2e666]
                          - gridcell "52,512" [ref=f2e667]
                          - gridcell "45,636" [ref=f2e668]
                          - gridcell "85,667" [ref=f2e669]
                          - gridcell "-452,157" [ref=f2e670]
                          - gridcell "-452,157" [ref=f2e671]
                          - gridcell "-382,201" [ref=f2e672]
                          - gridcell "-312,245" [ref=f2e673]
                          - gridcell "-242,289" [ref=f2e674]
                          - gridcell "13" [ref=f2e675]
                          - gridcell [ref=f2e676]
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e677]
                    - generic [aria-hidden]:
                      - gridcell [selected] [ref=f2e678]: "82"
                      - gridcell [ref=f2e679]: virtual plant(GM01)-Cell
                      - gridcell [ref=f2e680]: "-"
                      - gridcell [ref=f2e681]: ECE1592F1-01-H00
                      - gridcell [ref=f2e682]: JF2-H00
                      - gridcell [ref=f2e683]
                      - gridcell [ref=f2e684]
                      - gridcell [ref=f2e685]: S
                      - gridcell [ref=f2e686]: Shipment Plan[R+P]
                      - gridcell [ref=f2e687]
                      - gridcell [ref=f2e688]
                      - gridcell [ref=f2e689]: Shipment Plan
                      - gridcell [ref=f2e690]: oWMS
                      - gridcell [ref=f2e691]: "98"
                      - gridcell [ref=f2e692]: Internal movement
                      - gridcell [ref=f2e693]: MES
                      - gridcell [ref=f2e694]: "0"
                      - gridcell [ref=f2e695]: Container Qty
                      - gridcell [ref=f2e696]: ERP
                      - gridcell [ref=f2e697]: "0"
                      - gridcell [ref=f2e698]: P
                      - gridcell [ref=f2e699]: Production
                      - gridcell [ref=f2e700]: BOH
                      - gridcell [ref=f2e701]: "98"
                      - gridcell [ref=f2e702]: I
                      - gridcell [ref=f2e703]: Balance
                      - gridcell [ref=f2e704]: ECE1592F1-01-H01
                      - gridcell [ref=f2e705]: JF2-H01
                      - gridcell [ref=f2e706]
                      - gridcell [ref=f2e707]
                      - gridcell [ref=f2e708]: S
                      - gridcell [ref=f2e709]: Shipment Plan[R+P]
                      - gridcell [ref=f2e710]
                      - gridcell [ref=f2e711]
                      - gridcell [ref=f2e712]: Shipment Plan
                      - gridcell [ref=f2e713]
                      - gridcell [ref=f2e714]
                      - gridcell [ref=f2e715]: oWMS
                      - gridcell [ref=f2e716]: 130,732
                      - gridcell [ref=f2e717]: Internal movement
                      - gridcell [ref=f2e718]: MES
                      - gridcell [ref=f2e719]: "0"
                      - gridcell [ref=f2e720]: Container Qty
                      - gridcell [ref=f2e721]: ERP
                      - gridcell [ref=f2e722]: "0"
                      - gridcell [ref=f2e723]: P
                      - gridcell [ref=f2e724]: Production
                      - gridcell [ref=f2e725]: BOH
                      - gridcell [ref=f2e726]: 130,732
                      - gridcell [ref=f2e727]: I
                      - gridcell [ref=f2e728]: Balance
                    - generic [ref=f2e729]:
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
                    - generic [ref=f2e730]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e731]:
                    - status
                    - generic [ref=f2e732]: "0"
                - separator [ref=f2e733]
                - generic [ref=f2e736]:
                  - generic [ref=f2e737]:
                    - generic [ref=f2e738]:
                      - generic [ref=f2e740]:
                        - generic [ref=f2e741]: Shipment Date
                        - generic [ref=f2e748]:
                          - generic [ref=f2e751]:
                            - img [aria-hidden] [ref=f2e753] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e761]: 2026.10.09
                          - generic [ref=f2e762]: ~
                          - generic [ref=f2e765]:
                            - img [aria-hidden] [ref=f2e767] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e775]: 2026.10.23
                      - generic [ref=f2e777]:
                        - generic [ref=f2e778]: Model/Nickname
                        - generic [ref=f2e784]:
                          - textbox [ref=f2e785]: ECE1592F1-01-H01
                          - button [ref=f2e786] [cursor=pointer]
                      - generic [ref=f2e792]:
                        - generic [ref=f2e793]: Requestor
                        - generic [ref=f2e799]:
                          - textbox [ref=f2e800]
                          - button [ref=f2e801] [cursor=pointer]
                      - generic [ref=f2e807]:
                        - generic [ref=f2e808]: Product Level1
                        - generic [ref=f2e816] [cursor=pointer]:
                          - combobox "ALL" [ref=f2e817]
                          - button "Open" [ref=f2e819]
                          - group [aria-hidden]
                    - generic [ref=f2e823]:
                      - button "신규" [ref=f2e824] [cursor=pointer]
                      - button "Search" [ref=f2e825] [cursor=pointer]
                  - generic [ref=f2e826]:
                    - generic [ref=f2e827]:
                      - button "Shipment Plan Detail" [ref=f2e828]
                      - button "Stock Location Detail" [ref=f2e830]
                      - button "oWMS Detail" [ref=f2e832]
                      - button "MES Stock" [ref=f2e834]
                      - button "MES Stock Detail" [ref=f2e836]
                      - button "Shipment Result" [ref=f2e838]
                    - generic [ref=f2e843]:
                      - grid [ref=f2e844]:
                        - rowgroup [ref=f2e845]:
                          - generic:
                            - row "Div Confirm/Plan ID SO No DO No Status Product Level1 Model Nick Name From Site To Site Project Code Project Name End Customer Incoterms FCST Type Shipment Qty Shipment Date Trans Mode Building Remarks Change Reason Reason Detail No":
                              - columnheader "Div" [ref=f2e846]
                              - columnheader "Confirm/Plan ID" [ref=f2e847]
                              - columnheader "SO No" [ref=f2e848]
                              - columnheader "DO No" [ref=f2e849]
                              - columnheader "Status" [ref=f2e850]
                              - columnheader "Product Level1" [ref=f2e851]
                              - columnheader "Model" [ref=f2e852]
                              - columnheader "Nick Name" [ref=f2e853]
                              - columnheader "From Site" [ref=f2e854]
                              - columnheader "To Site" [ref=f2e855]
                              - columnheader "Project Code" [ref=f2e856]
                              - columnheader "Project Name" [ref=f2e857]
                              - columnheader "End Customer" [ref=f2e858]
                              - columnheader "Incoterms" [ref=f2e859]
                              - columnheader "FCST Type" [ref=f2e860]
                              - columnheader "Shipment Qty" [ref=f2e861]
                              - columnheader "Shipment Date" [ref=f2e862]
                              - columnheader "Trans Mode" [ref=f2e863]
                              - columnheader "Building" [ref=f2e864]
                              - columnheader "Remarks" [ref=f2e865]
                              - columnheader "Change Reason" [ref=f2e866]
                              - columnheader "Reason Detail" [ref=f2e867]
                              - gridcell "No" [ref=f2e868]
                              - gridcell [ref=f2e869]
                        - rowgroup [ref=f2e870]:
                          - row "Focus helper":
                            - gridcell "Focus helper" [ref=f2e872]
                        - generic [ref=f2e874]:
                          - generic:
                            - row "0 Sum":
                              - gridcell [ref=f2e875]
                              - gridcell [ref=f2e876]
                              - gridcell [ref=f2e877]
                              - gridcell [ref=f2e878]
                              - gridcell [ref=f2e879]
                              - gridcell [ref=f2e880]
                              - gridcell [ref=f2e881]
                              - gridcell [ref=f2e882]
                              - gridcell [ref=f2e883]
                              - gridcell [ref=f2e884]
                              - gridcell [ref=f2e885]
                              - gridcell [ref=f2e886]
                              - gridcell [ref=f2e887]
                              - gridcell [ref=f2e888]
                              - gridcell [ref=f2e889]
                              - gridcell "0" [ref=f2e890]
                              - gridcell [ref=f2e891]
                              - gridcell [ref=f2e892]
                              - gridcell [ref=f2e893]
                              - gridcell [ref=f2e894]
                              - gridcell [ref=f2e895]
                              - gridcell [ref=f2e896]
                              - gridcell [ref=f2e897]
                              - gridcell [ref=f2e898]
                              - gridcell [ref=f2e899]
                              - gridcell [ref=f2e900]
                              - gridcell [ref=f2e901]
                              - gridcell [ref=f2e902]
                              - gridcell [ref=f2e903]
                              - gridcell [ref=f2e904]
                              - gridcell [ref=f2e905]
                              - gridcell [ref=f2e906]
                              - gridcell [ref=f2e907]
                              - gridcell [ref=f2e908]
                              - gridcell [ref=f2e909]
                              - gridcell [ref=f2e910]
                              - gridcell [ref=f2e911]
                              - gridcell [ref=f2e912]
                              - gridcell [ref=f2e913]
                              - gridcell [ref=f2e914]
                              - gridcell [ref=f2e915]
                              - gridcell [ref=f2e916]
                              - gridcell [ref=f2e917]
                              - gridcell "Sum" [ref=f2e918]
                              - gridcell [ref=f2e919]
                        - generic [ref=f2e920]:
                          - generic:
                            - row "Sum 0"
                        - generic [ref=f2e921]:
                          - generic:
                            - row "No"
                      - generic [ref=f2e922]:
                        - status
                        - generic [ref=f2e923]: "0"
                      - generic:
                        - generic [ref=f2e926]:
                          - combobox "InputDate Input" [ref=f2e927]: 2026-11-15
                          - button "Choose Date" [ref=f2e929] [cursor=pointer]
                        - generic [ref=f2e933]:
                          - combobox "InputDate Input" [ref=f2e934]: 2026-11-15
                          - button "Choose Date" [ref=f2e936] [cursor=pointer]
                        - generic [ref=f2e940]:
                          - combobox "InputDate Input" [ref=f2e941]: 2026-11-15
                          - button "Choose Date" [ref=f2e943] [cursor=pointer]
                        - generic [ref=f2e947]:
                          - combobox "InputDateTime Input" [ref=f2e948]: 2026-11-15 04:03:07
                          - generic [ref=f2e949]:
                            - button "Toggle Calendar" [ref=f2e950] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e952] [cursor=pointer]
                        - generic [ref=f2e956]:
                          - combobox "InputDate Input" [ref=f2e957]: 2026-11-15
                          - button "Choose Date" [ref=f2e959] [cursor=pointer]
                        - generic [ref=f2e963]:
                          - combobox "InputDate Input" [ref=f2e964]: 2026-11-15
                          - button "Choose Date" [ref=f2e966] [cursor=pointer]
                        - generic [ref=f2e970]:
                          - combobox "InputDate Input" [ref=f2e971]: 2026-11-15
                          - button "Choose Date" [ref=f2e973] [cursor=pointer]
                        - generic [ref=f2e977]:
                          - combobox "InputDateTime Input" [ref=f2e978]: 2026-11-15 04:03:07
                          - generic [ref=f2e979]:
                            - button "Toggle Calendar" [ref=f2e980] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e982] [cursor=pointer]
                        - generic [ref=f2e986]:
                          - combobox "InputDate Input" [ref=f2e987]: 2026-11-15
                          - button "Choose Date" [ref=f2e989] [cursor=pointer]
                        - generic [ref=f2e993]:
                          - combobox "InputDate Input" [ref=f2e994]: 2026-11-15
                          - button "Choose Date" [ref=f2e996] [cursor=pointer]
                        - generic [ref=f2e1000]:
                          - combobox "InputDate Input" [ref=f2e1001]: 2026-11-15
                          - button "Choose Date" [ref=f2e1003] [cursor=pointer]
                        - generic [ref=f2e1007]:
                          - combobox "InputDateTime Input" [ref=f2e1008]: 2026-11-15 04:03:08
                          - generic [ref=f2e1009]:
                            - button "Toggle Calendar" [ref=f2e1010] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1012] [cursor=pointer]
                        - generic [ref=f2e1016]:
                          - combobox "InputDate Input" [ref=f2e1017]: 2026-11-15
                          - button "Choose Date" [ref=f2e1019] [cursor=pointer]
                        - generic [ref=f2e1023]:
                          - combobox "InputDate Input" [ref=f2e1024]: 2026-11-15
                          - button "Choose Date" [ref=f2e1026] [cursor=pointer]
                        - generic [ref=f2e1030]:
                          - combobox "InputDate Input" [ref=f2e1031]: 2026-11-15
                          - button "Choose Date" [ref=f2e1033] [cursor=pointer]
                        - generic [ref=f2e1037]:
                          - combobox "InputDateTime Input" [ref=f2e1038]: 2026-11-15 04:03:08
                          - generic [ref=f2e1039]:
                            - button "Toggle Calendar" [ref=f2e1040] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1042] [cursor=pointer]
                        - generic [ref=f2e1046]:
                          - combobox "InputDate Input" [ref=f2e1047]: 2026-11-15
                          - button "Choose Date" [ref=f2e1049] [cursor=pointer]
                        - generic [ref=f2e1053]:
                          - combobox "InputDate Input" [ref=f2e1054]: 2026-11-15
                          - button "Choose Date" [ref=f2e1056] [cursor=pointer]
                        - generic [ref=f2e1060]:
                          - combobox "InputDate Input" [ref=f2e1061]: 2026-11-15
                          - button "Choose Date" [ref=f2e1063] [cursor=pointer]
                        - generic [ref=f2e1067]:
                          - combobox "InputDateTime Input" [ref=f2e1068]: 2026-11-15 04:03:08
                          - generic [ref=f2e1069]:
                            - button "Toggle Calendar" [ref=f2e1070] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1072] [cursor=pointer]
                        - generic [ref=f2e1076]:
                          - combobox "InputDate Input" [ref=f2e1077]: 2026-11-15
                          - button "Choose Date" [ref=f2e1079] [cursor=pointer]
                        - generic [ref=f2e1083]:
                          - combobox "InputDate Input" [ref=f2e1084]: 2026-11-15
                          - button "Choose Date" [ref=f2e1086] [cursor=pointer]
                        - generic [ref=f2e1090]:
                          - combobox "InputDate Input" [ref=f2e1091]: 2026-11-15
                          - button "Choose Date" [ref=f2e1093] [cursor=pointer]
                        - generic [ref=f2e1097]:
                          - combobox "InputDateTime Input" [ref=f2e1098]: 2026-11-15 04:03:08
                          - generic [ref=f2e1099]:
                            - button "Toggle Calendar" [ref=f2e1100] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1102] [cursor=pointer]
                        - generic [ref=f2e1106]:
                          - combobox "InputDate Input" [ref=f2e1107]: 2026-11-15
                          - button "Choose Date" [ref=f2e1109] [cursor=pointer]
                        - generic [ref=f2e1113]:
                          - combobox "InputDate Input" [ref=f2e1114]: 2026-11-15
                          - button "Choose Date" [ref=f2e1116] [cursor=pointer]
                        - generic [ref=f2e1120]:
                          - combobox "InputDate Input" [ref=f2e1121]: 2026-11-15
                          - button "Choose Date" [ref=f2e1123] [cursor=pointer]
                        - generic [ref=f2e1127]:
                          - combobox "InputDateTime Input" [ref=f2e1128]: 2026-11-15 04:03:08
                          - generic [ref=f2e1129]:
                            - button "Toggle Calendar" [ref=f2e1130] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1132] [cursor=pointer]
                        - generic [ref=f2e1136]:
                          - combobox "InputDate Input" [ref=f2e1137]: 2026-11-15
                          - button "Choose Date" [ref=f2e1139] [cursor=pointer]
                        - generic [ref=f2e1143]:
                          - combobox "InputDate Input" [ref=f2e1144]: 2026-11-15
                          - button "Choose Date" [ref=f2e1146] [cursor=pointer]
                        - generic [ref=f2e1150]:
                          - combobox "InputDate Input" [ref=f2e1151]: 2026-11-15
                          - button "Choose Date" [ref=f2e1153] [cursor=pointer]
                        - generic [ref=f2e1157]:
                          - combobox "InputDateTime Input" [ref=f2e1158]: 2026-11-15 04:03:08
                          - generic [ref=f2e1159]:
                            - button "Toggle Calendar" [ref=f2e1160] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1162] [cursor=pointer]
                        - generic [ref=f2e1166]:
                          - combobox "InputDate Input" [ref=f2e1167]: 2026-11-15
                          - button "Choose Date" [ref=f2e1169] [cursor=pointer]
                        - generic [ref=f2e1173]:
                          - combobox "InputDate Input" [ref=f2e1174]: 2026-11-15
                          - button "Choose Date" [ref=f2e1176] [cursor=pointer]
                        - generic [ref=f2e1180]:
                          - combobox "InputDate Input" [ref=f2e1181]: 2026-11-15
                          - button "Choose Date" [ref=f2e1183] [cursor=pointer]
                        - generic [ref=f2e1187]:
                          - combobox "InputDateTime Input" [ref=f2e1188]: 2026-11-15 04:03:08
                          - generic [ref=f2e1189]:
                            - button "Toggle Calendar" [ref=f2e1190] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1192] [cursor=pointer]
                        - generic [ref=f2e1196]:
                          - combobox "InputDate Input" [ref=f2e1197]: 2026-11-15
                          - button "Choose Date" [ref=f2e1199] [cursor=pointer]
                        - generic [ref=f2e1203]:
                          - combobox "InputDate Input" [ref=f2e1204]: 2026-11-15
                          - button "Choose Date" [ref=f2e1206] [cursor=pointer]
                        - generic [ref=f2e1210]:
                          - combobox "InputDate Input" [ref=f2e1211]: 2026-11-15
                          - button "Choose Date" [ref=f2e1213] [cursor=pointer]
                        - generic [ref=f2e1217]:
                          - combobox "InputDateTime Input" [ref=f2e1218]: 2026-11-15 04:03:09
                          - generic [ref=f2e1219]:
                            - button "Toggle Calendar" [ref=f2e1220] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1222] [cursor=pointer]
                        - generic [ref=f2e1226]:
                          - combobox "InputDate Input" [ref=f2e1227]: 2026-11-15
                          - button "Choose Date" [ref=f2e1229] [cursor=pointer]
                        - generic [ref=f2e1233]:
                          - combobox "InputDate Input" [ref=f2e1234]: 2026-11-15
                          - button "Choose Date" [ref=f2e1236] [cursor=pointer]
                        - generic [ref=f2e1240]:
                          - combobox "InputDate Input" [ref=f2e1241]: 2026-11-15
                          - button "Choose Date" [ref=f2e1243] [cursor=pointer]
                        - generic [ref=f2e1247]:
                          - combobox "InputDateTime Input" [ref=f2e1248]: 2026-11-15 04:03:09
                          - generic [ref=f2e1249]:
                            - button "Toggle Calendar" [ref=f2e1250] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1252] [cursor=pointer]
                        - generic [ref=f2e1256]:
                          - combobox "InputDate Input" [ref=f2e1257]: 2026-11-15
                          - button "Choose Date" [ref=f2e1259] [cursor=pointer]
                        - generic [ref=f2e1263]:
                          - combobox "InputDate Input" [ref=f2e1264]: 2026-11-15
                          - button "Choose Date" [ref=f2e1266] [cursor=pointer]
                        - generic [ref=f2e1270]:
                          - combobox "InputDate Input" [ref=f2e1271]: 2026-11-15
                          - button "Choose Date" [ref=f2e1273] [cursor=pointer]
                        - generic [ref=f2e1277]:
                          - combobox "InputDateTime Input" [ref=f2e1278]: 2026-11-15 04:03:09
                          - generic [ref=f2e1279]:
                            - button "Toggle Calendar" [ref=f2e1280] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1282] [cursor=pointer]
            - alert [ref=f2e1284]:
              - generic [ref=f2e1285] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1288] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  1   | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-14) · 원천: Doc/gen/SSP0060/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2   | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3   | import * as fs from 'node:fs';
  4   | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SSP0060.plan.json', 'utf8'));
  5   | const MENU = "SSP0060";
  6   | import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
  7   | import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)
  8   | 
  9   | test.describe(`${MENU} ShipmentPlan 스모크 @smoke`, () => {
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
      |                                                                                             ^ Error: As-is 병합 헤더 리터럴 노출 [SUM]
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