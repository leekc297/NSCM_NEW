# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: DMF0005.smoke.spec.ts >> DMF0005 SaleSite_PjtModelMapping 스모크 @smoke >> 조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인
- Location: ..\..\Doc\e2e\specs\DMF0005.smoke.spec.ts:106:7

# Error details

```
Error: 조회조건 판정 불가(ERROR) 4: Project Null, Project, End Customer(Report) Null, Detail

expect(received).toBe(expected) // Object.is equality

Expected: 0
Received: 4
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/DMF0005
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/DMF0005
      - generic [ref=f2e17]:
        - button "KOR" [ref=f2e19] [cursor=pointer]
        - button "이 이민용" [ref=f2e23] [cursor=pointer]:
          - paragraph [ref=f2e28]: 이
          - generic [ref=f2e29]: 이민용
    - generic [ref=f2e30]:
      - button [ref=f2e31] [cursor=pointer]
      - complementary [ref=f2e37]:
        - navigation [ref=f2e38]:
          - paragraph [ref=f2e39]: Demand
          - generic [ref=f2e40]:
            - link [ref=f2e41] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e42]: Demand Master
            - link [ref=f2e45] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e46]: Sales Site
            - link [ref=f2e47] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e48]: Sales Site Project Model
            - link [ref=f2e49] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e50]: Sales Site Project Model
            - link [ref=f2e51] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e52]: Customer Model Mapping
            - link [ref=f2e53] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e54]: Customer FCST Master
            - link [ref=f2e55] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e56]: Sales Price
            - link [ref=f2e57] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e58]: Sales Price(82)
            - link [ref=f2e59] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e60]: Model Group Sales Price
            - link [ref=f2e61] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e62]: Contribution Rate Reg.
            - link [ref=f2e63] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e64]: Contribution Sales
            - link [ref=f2e65] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e66]: ERP EDI Master Validation
            - link [ref=f2e67] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e68]: "N: N Master Mapping"
          - generic [ref=f2e69]:
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e71]: Demand Plan
            - link "MKT FCST":
              - /url: /view/DMF0005
              - paragraph [ref=f2e74] [cursor=pointer]: MKT FCST
            - link "MKT FCST_01":
              - /url: /view/DMF0005
              - paragraph [ref=f2e75] [cursor=pointer]: MKT FCST_01
            - link "Sales Monitoring":
              - /url: /view/DMF0005
              - paragraph [ref=f2e76] [cursor=pointer]: Sales Monitoring
            - link "Customer FCST Upload":
              - /url: /view/DMF0005
              - paragraph [ref=f2e77] [cursor=pointer]: Customer FCST Upload
            - link "Business Plan":
              - /url: /view/DMF0005
              - paragraph [ref=f2e78] [cursor=pointer]: Business Plan
            - link "Sales Reports":
              - /url: /view/DMF0005
              - paragraph [ref=f2e79] [cursor=pointer]: Sales Reports
            - link "ETC Sales Reports":
              - /url: /view/DMF0005
              - paragraph [ref=f2e80] [cursor=pointer]: ETC Sales Reports
            - link "Metal Link Price":
              - /url: /view/DMF0005
              - paragraph [ref=f2e81] [cursor=pointer]: Metal Link Price
            - link "Fcst&Price MGMT":
              - /url: /view/DMF0005
              - paragraph [ref=f2e82] [cursor=pointer]: Fcst&Price MGMT
            - link "Sales Plan":
              - /url: /view/DMF0005
              - paragraph [ref=f2e83] [cursor=pointer]: Sales Plan
            - link "Sales Plan_01":
              - /url: /view/DMF0005
              - paragraph [ref=f2e84] [cursor=pointer]: Sales Plan_01
          - generic [ref=f2e85]:
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e87]: Waterfall
            - link "Demand Plan Waterfall":
              - /url: /view/DMF0005
              - paragraph [ref=f2e90] [cursor=pointer]: Demand Plan Waterfall
            - link "MKT FCST Comparison":
              - /url: /view/DMF0005
              - paragraph [ref=f2e91] [cursor=pointer]: MKT FCST Comparison
            - link "Demand Manager":
              - /url: /view/DMF0005
              - paragraph [ref=f2e92] [cursor=pointer]: Demand Manager
            - link "Customer FCST Waterfall":
              - /url: /view/DMF0005
              - paragraph [ref=f2e93] [cursor=pointer]: Customer FCST Waterfall
            - link "Demand Plan Waterfall_01":
              - /url: /view/DMF0005
              - paragraph [ref=f2e94] [cursor=pointer]: Demand Plan Waterfall_01
      - main [ref=f2e95]:
        - generic [ref=f2e97]:
          - generic [ref=f2e98]:
            - generic [ref=f2e99]:
              - button "Home" [ref=f2e100] [cursor=pointer]
              - button "Sales Site Project Model" [ref=f2e102] [cursor=pointer]
            - generic [ref=f2e107]:
              - button "Scroll tabs left" [disabled] [ref=f2e108]
              - button "Scroll tabs right" [disabled] [ref=f2e111]
              - button "Close others" [ref=f2e114] [cursor=pointer]
              - button "Close All" [ref=f2e115] [cursor=pointer]
          - generic [ref=f2e116]:
            - generic [ref=f2e119]:
              - generic [ref=f2e121]:
                - generic [ref=f2e122]:
                  - img [aria-hidden] [ref=f2e124] [cursor=pointer]
                  - paragraph [ref=f2e127]: Sales Site Project Model
                - generic [ref=f2e128]:
                  - generic [ref=f2e129]: Demand
                  - generic [ref=f2e134]: Demand Master
                  - generic [ref=f2e139]: Sales Site Project Model
                - generic [ref=f2e141]:
                  - generic [ref=f2e142]: Search Area
                  - switch [checked] [ref=f2e145] [cursor=pointer]
                - button "Full screen" [ref=f2e148] [cursor=pointer]
              - generic [ref=f2e158]:
                - generic [ref=f2e159]:
                  - generic [ref=f2e161]:
                    - generic [ref=f2e162]: Div
                    - generic [ref=f2e172]:
                      - combobox [ref=f2e173]: 81 Automotive Battery
                      - button "Open" [ref=f2e175] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e180]:
                    - generic [ref=f2e181]: Team
                    - generic [ref=f2e189] [cursor=pointer]:
                      - combobox "ALL" [ref=f2e190]
                      - button "Open" [ref=f2e192]
                      - group [aria-hidden]
                  - generic [ref=f2e197]:
                    - generic [ref=f2e198]: End Customer
                    - generic [ref=f2e206] [cursor=pointer]:
                      - combobox "ALL" [ref=f2e207]
                      - button "Open" [ref=f2e209]
                      - group [aria-hidden]
                  - generic [ref=f2e214]:
                    - generic [ref=f2e215]: Sales Site
                    - generic [ref=f2e223] [cursor=pointer]:
                      - combobox "ALL" [ref=f2e224]
                      - button "Open" [ref=f2e226]
                      - group [aria-hidden]
                  - generic [ref=f2e231]:
                    - generic [ref=f2e232]: Project
                    - generic [ref=f2e238]:
                      - textbox [ref=f2e239]
                      - button [ref=f2e240] [cursor=pointer]
                  - generic [ref=f2e246]:
                    - generic [ref=f2e247]: Model/Nickname
                    - generic [ref=f2e253]:
                      - textbox [ref=f2e254]
                      - button [ref=f2e255] [cursor=pointer]
                  - generic [ref=f2e261]:
                    - generic [ref=f2e262]: Owner
                    - generic [ref=f2e268]:
                      - textbox [ref=f2e269]: kunwonsaw
                      - button [ref=f2e270] [cursor=pointer]
                  - generic [ref=f2e275]:
                    - generic [ref=f2e276]:
                      - generic [ref=f2e277]: Active
                      - generic [ref=f2e287]:
                        - combobox [ref=f2e288]: ALL
                        - button "Open" [ref=f2e290] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e296]:
                      - checkbox [checked] [ref=f2e299] [cursor=pointer]
                      - generic [ref=f2e302]: Detail
                - button [active] [ref=f2e306] [cursor=pointer]
              - generic [ref=f2e311]:
                - generic [ref=f2e312]:
                  - paragraph
                  - generic [ref=f2e313]: 총114건
                - generic [ref=f2e314]:
                  - generic "Insert Row" [ref=f2e315]:
                    - button [ref=f2e316] [cursor=pointer]
                  - generic "Remove" [ref=f2e321]:
                    - button [ref=f2e322] [cursor=pointer]
                  - generic "Save" [ref=f2e329]:
                    - button [ref=f2e330] [cursor=pointer]
                  - generic "Sort" [ref=f2e334]:
                    - button [ref=f2e335] [cursor=pointer]
                  - generic "Filter" [ref=f2e340]:
                    - button [ref=f2e341] [cursor=pointer]
                  - generic "Condition" [ref=f2e346]:
                    - button [ref=f2e347] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e357]:
                    - button [ref=f2e358] [cursor=pointer]
                  - generic "Excel" [ref=f2e365]:
                    - button [ref=f2e366] [cursor=pointer]
              - generic [ref=f2e374]:
                - generic [ref=f2e377]:
                  - grid [ref=f2e378]:
                    - rowgroup [ref=f2e379]:
                      - generic:
                        - row "Div. Team End Customer Sold-To Rep Ship-To Sales Site Sales Company Sales Plant PJT Code PJT Owner Owner Name Model No":
                          - columnheader "Div." [ref=f2e380]
                          - columnheader "Team" [ref=f2e381]
                          - columnheader "End Customer" [ref=f2e382]
                          - columnheader "Sold-To" [ref=f2e383]
                          - columnheader "Rep Ship-To" [ref=f2e384]
                          - columnheader "Sales Site" [ref=f2e385]
                          - columnheader "Sales Company" [ref=f2e386]
                          - columnheader "Sales Plant" [ref=f2e387]
                          - columnheader "PJT Code" [ref=f2e388]
                          - columnheader "PJT" [ref=f2e389]
                          - columnheader "Owner" [ref=f2e390]
                          - columnheader "Owner Name" [ref=f2e391]
                          - columnheader "Model" [ref=f2e392]
                          - gridcell "No" [ref=f2e393]
                          - gridcell [ref=f2e394]
                    - rowgroup [ref=f2e395]:
                      - generic [ref=f2e396]:
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW AALN1010I-A1T004 1":
                          - gridcell "81" [selected] [ref=f2e397]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e398] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e399]
                          - gridcell [ref=f2e400]
                          - gridcell [ref=f2e401]
                          - gridcell "MI00-81-AS" [ref=f2e402]
                          - gridcell [ref=f2e403]
                          - gridcell [ref=f2e404]
                          - gridcell "A15CR7002" [ref=f2e405]
                          - gridcell "DT PPU(48V)" [ref=f2e406]
                          - gridcell "kunwonsaw" [ref=f2e407] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e408]
                          - gridcell "AALN1010I-A1T004" [ref=f2e409]
                          - gridcell "1" [ref=f2e410]
                          - gridcell [ref=f2e411]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW AALN1010I-A1T005 2":
                          - gridcell "81" [ref=f2e412]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e413] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e414]
                          - gridcell [ref=f2e415]
                          - gridcell [ref=f2e416]
                          - gridcell "MI00-81-AS" [ref=f2e417]
                          - gridcell [ref=f2e418]
                          - gridcell [ref=f2e419]
                          - gridcell "A15CR7002" [ref=f2e420]
                          - gridcell "DT PPU(48V)" [ref=f2e421]
                          - gridcell "kunwonsaw" [ref=f2e422] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e423]
                          - gridcell "AALN1010I-A1T005" [ref=f2e424]
                          - gridcell "2" [ref=f2e425]
                          - gridcell [ref=f2e426]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS MI00 MI00 A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1 3":
                          - gridcell "81" [ref=f2e427]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e428] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e429]
                          - gridcell [ref=f2e430]
                          - gridcell [ref=f2e431]
                          - gridcell "MI00-81-AS" [ref=f2e432]
                          - gridcell "MI00" [ref=f2e433]
                          - gridcell "MI00" [ref=f2e434]
                          - gridcell "A15CR7002" [ref=f2e435]
                          - gridcell "DT PPU(48V)" [ref=f2e436]
                          - gridcell "kunwonsaw" [ref=f2e437] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e438]
                          - gridcell "ACLN1010I-A1" [ref=f2e439]
                          - gridcell "3" [ref=f2e440]
                          - gridcell [ref=f2e441]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1-000 4":
                          - gridcell "81" [ref=f2e442]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e443] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e444]
                          - gridcell [ref=f2e445]
                          - gridcell [ref=f2e446]
                          - gridcell "MI00-81-AS" [ref=f2e447]
                          - gridcell [ref=f2e448]
                          - gridcell [ref=f2e449]
                          - gridcell "A15CR7002" [ref=f2e450]
                          - gridcell "DT PPU(48V)" [ref=f2e451]
                          - gridcell "kunwonsaw" [ref=f2e452] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e453]
                          - gridcell "ACLN1010I-A1-000" [ref=f2e454]
                          - gridcell "4" [ref=f2e455]
                          - gridcell [ref=f2e456]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1-100 5":
                          - gridcell "81" [ref=f2e457]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e458] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e459]
                          - gridcell [ref=f2e460]
                          - gridcell [ref=f2e461]
                          - gridcell "MI00-81-AS" [ref=f2e462]
                          - gridcell [ref=f2e463]
                          - gridcell [ref=f2e464]
                          - gridcell "A15CR7002" [ref=f2e465]
                          - gridcell "DT PPU(48V)" [ref=f2e466]
                          - gridcell "kunwonsaw" [ref=f2e467] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e468]
                          - gridcell "ACLN1010I-A1-100" [ref=f2e469]
                          - gridcell "5" [ref=f2e470]
                          - gridcell [ref=f2e471]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1-101 6":
                          - gridcell "81" [ref=f2e472]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e473] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e474]
                          - gridcell [ref=f2e475]
                          - gridcell [ref=f2e476]
                          - gridcell "MI00-81-AS" [ref=f2e477]
                          - gridcell [ref=f2e478]
                          - gridcell [ref=f2e479]
                          - gridcell "A15CR7002" [ref=f2e480]
                          - gridcell "DT PPU(48V)" [ref=f2e481]
                          - gridcell "kunwonsaw" [ref=f2e482] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e483]
                          - gridcell "ACLN1010I-A1-101" [ref=f2e484]
                          - gridcell "6" [ref=f2e485]
                          - gridcell [ref=f2e486]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1-102 7":
                          - gridcell "81" [ref=f2e487]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e488] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e489]
                          - gridcell [ref=f2e490]
                          - gridcell [ref=f2e491]
                          - gridcell "MI00-81-AS" [ref=f2e492]
                          - gridcell [ref=f2e493]
                          - gridcell [ref=f2e494]
                          - gridcell "A15CR7002" [ref=f2e495]
                          - gridcell "DT PPU(48V)" [ref=f2e496]
                          - gridcell "kunwonsaw" [ref=f2e497] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e498]
                          - gridcell "ACLN1010I-A1-102" [ref=f2e499]
                          - gridcell "7" [ref=f2e500]
                          - gridcell [ref=f2e501]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1-103 8":
                          - gridcell "81" [ref=f2e502]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e503] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e504]
                          - gridcell [ref=f2e505]
                          - gridcell [ref=f2e506]
                          - gridcell "MI00-81-AS" [ref=f2e507]
                          - gridcell [ref=f2e508]
                          - gridcell [ref=f2e509]
                          - gridcell "A15CR7002" [ref=f2e510]
                          - gridcell "DT PPU(48V)" [ref=f2e511]
                          - gridcell "kunwonsaw" [ref=f2e512] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e513]
                          - gridcell "ACLN1010I-A1-103" [ref=f2e514]
                          - gridcell "8" [ref=f2e515]
                          - gridcell [ref=f2e516]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS MI00 MI00 A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1-D02 9":
                          - gridcell "81" [ref=f2e517]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e518] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e519]
                          - gridcell [ref=f2e520]
                          - gridcell [ref=f2e521]
                          - gridcell "MI00-81-AS" [ref=f2e522]
                          - gridcell "MI00" [ref=f2e523]
                          - gridcell "MI00" [ref=f2e524]
                          - gridcell "A15CR7002" [ref=f2e525]
                          - gridcell "DT PPU(48V)" [ref=f2e526]
                          - gridcell "kunwonsaw" [ref=f2e527] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e528]
                          - gridcell "ACLN1010I-A1-D02" [ref=f2e529]
                          - gridcell "9" [ref=f2e530]
                          - gridcell [ref=f2e531]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1T002 10":
                          - gridcell "81" [ref=f2e532]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e533] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e534]
                          - gridcell [ref=f2e535]
                          - gridcell [ref=f2e536]
                          - gridcell "MI00-81-AS" [ref=f2e537]
                          - gridcell [ref=f2e538]
                          - gridcell [ref=f2e539]
                          - gridcell "A15CR7002" [ref=f2e540]
                          - gridcell "DT PPU(48V)" [ref=f2e541]
                          - gridcell "kunwonsaw" [ref=f2e542] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e543]
                          - gridcell "ACLN1010I-A1T002" [ref=f2e544]
                          - gridcell "10" [ref=f2e545]
                          - gridcell [ref=f2e546]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1T004 11":
                          - gridcell "81" [ref=f2e547]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e548] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e549]
                          - gridcell [ref=f2e550]
                          - gridcell [ref=f2e551]
                          - gridcell "MI00-81-AS" [ref=f2e552]
                          - gridcell [ref=f2e553]
                          - gridcell [ref=f2e554]
                          - gridcell "A15CR7002" [ref=f2e555]
                          - gridcell "DT PPU(48V)" [ref=f2e556]
                          - gridcell "kunwonsaw" [ref=f2e557] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e558]
                          - gridcell "ACLN1010I-A1T004" [ref=f2e559]
                          - gridcell "11" [ref=f2e560]
                          - gridcell [ref=f2e561]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1T005 12":
                          - gridcell "81" [ref=f2e562]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e563] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e564]
                          - gridcell [ref=f2e565]
                          - gridcell [ref=f2e566]
                          - gridcell "MI00-81-AS" [ref=f2e567]
                          - gridcell [ref=f2e568]
                          - gridcell [ref=f2e569]
                          - gridcell "A15CR7002" [ref=f2e570]
                          - gridcell "DT PPU(48V)" [ref=f2e571]
                          - gridcell "kunwonsaw" [ref=f2e572] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e573]
                          - gridcell "ACLN1010I-A1T005" [ref=f2e574]
                          - gridcell "12" [ref=f2e575]
                          - gridcell [ref=f2e576]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW ACLN1010I-A1T006 13":
                          - gridcell "81" [ref=f2e577]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e578] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e579]
                          - gridcell [ref=f2e580]
                          - gridcell [ref=f2e581]
                          - gridcell "MI00-81-AS" [ref=f2e582]
                          - gridcell [ref=f2e583]
                          - gridcell [ref=f2e584]
                          - gridcell "A15CR7002" [ref=f2e585]
                          - gridcell "DT PPU(48V)" [ref=f2e586]
                          - gridcell "kunwonsaw" [ref=f2e587] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e588]
                          - gridcell "ACLN1010I-A1T006" [ref=f2e589]
                          - gridcell "13" [ref=f2e590]
                          - gridcell [ref=f2e591]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW AMDAU0327G 14":
                          - gridcell "81" [ref=f2e592]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e593] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e594]
                          - gridcell [ref=f2e595]
                          - gridcell [ref=f2e596]
                          - gridcell "MI00-81-AS" [ref=f2e597]
                          - gridcell [ref=f2e598]
                          - gridcell [ref=f2e599]
                          - gridcell "A15CR7002" [ref=f2e600]
                          - gridcell "DT PPU(48V)" [ref=f2e601]
                          - gridcell "kunwonsaw" [ref=f2e602] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e603]
                          - gridcell "AMDAU0327G" [ref=f2e604]
                          - gridcell "14" [ref=f2e605]
                          - gridcell [ref=f2e606]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW AMDAU0327H 15":
                          - gridcell "81" [ref=f2e607]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e608] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e609]
                          - gridcell [ref=f2e610]
                          - gridcell [ref=f2e611]
                          - gridcell "MI00-81-AS" [ref=f2e612]
                          - gridcell [ref=f2e613]
                          - gridcell [ref=f2e614]
                          - gridcell "A15CR7002" [ref=f2e615]
                          - gridcell "DT PPU(48V)" [ref=f2e616]
                          - gridcell "kunwonsaw" [ref=f2e617] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e618]
                          - gridcell "AMDAU0327H" [ref=f2e619]
                          - gridcell "15" [ref=f2e620]
                          - gridcell [ref=f2e621]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW AMDAU0751A 16":
                          - gridcell "81" [ref=f2e622]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e623] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e624]
                          - gridcell [ref=f2e625]
                          - gridcell [ref=f2e626]
                          - gridcell "MI00-81-AS" [ref=f2e627]
                          - gridcell [ref=f2e628]
                          - gridcell [ref=f2e629]
                          - gridcell "A15CR7002" [ref=f2e630]
                          - gridcell "DT PPU(48V)" [ref=f2e631]
                          - gridcell "kunwonsaw" [ref=f2e632] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e633]
                          - gridcell "AMDAU0751A" [ref=f2e634]
                          - gridcell "16" [ref=f2e635]
                          - gridcell [ref=f2e636]
                        - row "81 AI/빅데이터1.빅데이터분석팀 ESMI(AS) MI00-81-AS MI00 MI00 A15CR7002 DT PPU(48V) kunwonsaw KUN WON SAW APFCA48V0-A2 17":
                          - gridcell "81" [ref=f2e637]
                          - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e638] [cursor=pointer]
                          - gridcell "ESMI(AS)" [ref=f2e639]
                          - gridcell [ref=f2e640]
                          - gridcell [ref=f2e641]
                          - gridcell "MI00-81-AS" [ref=f2e642]
                          - gridcell "MI00" [ref=f2e643]
                          - gridcell "MI00" [ref=f2e644]
                          - gridcell "A15CR7002" [ref=f2e645]
                          - gridcell "DT PPU(48V)" [ref=f2e646]
                          - gridcell "kunwonsaw" [ref=f2e647] [cursor=pointer]
                          - gridcell "KUN WON SAW" [ref=f2e648]
                          - gridcell "APFCA48V0-A2" [ref=f2e649]
                          - gridcell "17" [ref=f2e650]
                          - gridcell [ref=f2e651]
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e652]
                    - generic [aria-hidden]:
                      - gridcell [selected] [ref=f2e653]: "81"
                      - gridcell [ref=f2e654]: "81"
                      - gridcell [ref=f2e655]: "81"
                      - gridcell [ref=f2e656]: "81"
                      - gridcell [ref=f2e657]: "81"
                      - gridcell [ref=f2e658]: "81"
                      - gridcell [ref=f2e659]: "81"
                      - gridcell [ref=f2e660]: "81"
                      - gridcell [ref=f2e661]: "81"
                      - gridcell [ref=f2e662]: "81"
                      - gridcell [ref=f2e663]: "81"
                      - gridcell [ref=f2e664]: "81"
                      - gridcell [ref=f2e665]: "81"
                      - gridcell [ref=f2e666]: "81"
                      - gridcell [ref=f2e667]: "81"
                      - gridcell [ref=f2e668]: "81"
                      - gridcell [ref=f2e669]: "81"
                    - generic [ref=f2e670]:
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
                        - row "14"
                        - row "15"
                        - row "16"
                        - row "17"
                    - generic [ref=f2e671]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e672]:
                    - status
                    - generic [ref=f2e673]: "0"
                  - generic:
                    - spinbutton "InputNumber Input" [ref=f2e677]: "0.000"
                    - generic [ref=f2e680]:
                      - combobox "InputDateTime Input" [ref=f2e681]: 2026-11-14 05:54:05
                      - generic [ref=f2e682]:
                        - button "Toggle Calendar" [ref=f2e683] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e685] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e690]: "0.000"
                    - generic [ref=f2e693]:
                      - combobox "InputDateTime Input" [ref=f2e694]: 2026-11-14 05:54:05
                      - generic [ref=f2e695]:
                        - button "Toggle Calendar" [ref=f2e696] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e698] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e703]: "0.000"
                    - generic [ref=f2e706]:
                      - combobox "InputDateTime Input" [ref=f2e707]: 2026-11-14 05:54:06
                      - generic [ref=f2e708]:
                        - button "Toggle Calendar" [ref=f2e709] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e711] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e716]: "0.000"
                    - generic [ref=f2e719]:
                      - combobox "InputDateTime Input" [ref=f2e720]: 2026-11-14 05:54:07
                      - generic [ref=f2e721]:
                        - button "Toggle Calendar" [ref=f2e722] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e724] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e729]: "0.000"
                    - generic [ref=f2e732]:
                      - combobox "InputDateTime Input" [ref=f2e733]: 2026-11-14 05:54:20
                      - generic [ref=f2e734]:
                        - button "Toggle Calendar" [ref=f2e735] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e737] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e742]: "0.000"
                    - generic [ref=f2e745]:
                      - combobox "InputDateTime Input" [ref=f2e746]: 2026-11-14 05:54:20
                      - generic [ref=f2e747]:
                        - button "Toggle Calendar" [ref=f2e748] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e750] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e755]: "0.000"
                    - generic [ref=f2e758]:
                      - combobox "InputDateTime Input" [ref=f2e759]: 2026-11-14 05:54:24
                      - generic [ref=f2e760]:
                        - button "Toggle Calendar" [ref=f2e761] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e763] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e768]: "0.000"
                    - generic [ref=f2e771]:
                      - combobox "InputDateTime Input" [ref=f2e772]: 2026-11-14 05:54:24
                      - generic [ref=f2e773]:
                        - button "Toggle Calendar" [ref=f2e774] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e776] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e781]: "0.000"
                    - generic [ref=f2e784]:
                      - combobox "InputDateTime Input" [ref=f2e785]: 2026-11-14 05:54:29
                      - generic [ref=f2e786]:
                        - button "Toggle Calendar" [ref=f2e787] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e789] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e794]: "0.000"
                    - generic [ref=f2e797]:
                      - combobox "InputDateTime Input" [ref=f2e798]: 2026-11-14 05:54:29
                      - generic [ref=f2e799]:
                        - button "Toggle Calendar" [ref=f2e800] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e802] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e807]: "0.000"
                    - generic [ref=f2e810]:
                      - combobox "InputDateTime Input" [ref=f2e811]: 2026-11-14 05:54:33
                      - generic [ref=f2e812]:
                        - button "Toggle Calendar" [ref=f2e813] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e815] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e820]: "0.000"
                    - generic [ref=f2e823]:
                      - combobox "InputDateTime Input" [ref=f2e824]: 2026-11-14 05:54:33
                      - generic [ref=f2e825]:
                        - button "Toggle Calendar" [ref=f2e826] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e828] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e833]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e837]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e841]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e845]: "0.000"
                    - generic [ref=f2e848]:
                      - combobox "InputDateTime Input" [ref=f2e849]: 2026-11-14 05:54:37
                      - generic [ref=f2e850]:
                        - button "Toggle Calendar" [ref=f2e851] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e853] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e858]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e862]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e866]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e870]: "0.000"
                    - generic [ref=f2e873]:
                      - combobox "InputDateTime Input" [ref=f2e874]: 2026-11-14 05:54:37
                      - generic [ref=f2e875]:
                        - button "Toggle Calendar" [ref=f2e876] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e878] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e883]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e887]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e891]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e895]: "0.000"
                    - generic [ref=f2e898]:
                      - combobox "InputDateTime Input" [ref=f2e899]: 2026-11-14 05:54:38
                      - generic [ref=f2e900]:
                        - button "Toggle Calendar" [ref=f2e901] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e903] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e908]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e912]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e916]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e920]: "0.000"
                    - generic [ref=f2e923]:
                      - combobox "InputDateTime Input" [ref=f2e924]: 2026-11-14 05:54:38
                      - generic [ref=f2e925]:
                        - button "Toggle Calendar" [ref=f2e926] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e928] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e933]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e937]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e941]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e945]: "0.000"
                    - generic [ref=f2e948]:
                      - combobox "InputDateTime Input" [ref=f2e949]: 2026-11-14 05:54:47
                      - generic [ref=f2e950]:
                        - button "Toggle Calendar" [ref=f2e951] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e953] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e958]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e962]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e966]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e970]: "0.000"
                    - generic [ref=f2e973]:
                      - combobox "InputDateTime Input" [ref=f2e974]: 2026-11-14 05:54:47
                      - generic [ref=f2e975]:
                        - button "Toggle Calendar" [ref=f2e976] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e978] [cursor=pointer]
                - generic [ref=f2e982]:
                  - grid [ref=f2e983]:
                    - rowgroup [ref=f2e984]:
                      - generic:
                        - row "Div. Sales Site Sales Company Sales Plant PJT Code PJT Owner Owner Name Model Model Type Nick Name Item Type KWh/Cell Cell/Car Cell/Module Module/Car No":
                          - columnheader "Div." [ref=f2e985]
                          - columnheader "Sales Site" [ref=f2e986]
                          - columnheader "Sales Company" [ref=f2e987]
                          - columnheader "Sales Plant" [ref=f2e988]
                          - columnheader "PJT Code" [ref=f2e989]
                          - columnheader "PJT" [ref=f2e990]
                          - columnheader "Owner" [ref=f2e991]
                          - columnheader "Owner Name" [ref=f2e992]
                          - columnheader "Model" [ref=f2e993]
                          - columnheader "Model Type" [ref=f2e994]
                          - columnheader "Nick Name" [ref=f2e995]
                          - columnheader "Item Type" [ref=f2e996]
                          - columnheader "KWh/Cell" [ref=f2e997]
                          - columnheader "Cell/Car" [ref=f2e998]
                          - columnheader "Cell/Module" [ref=f2e999]
                          - columnheader "Module/Car" [ref=f2e1000]
                          - gridcell "No" [ref=f2e1001]
                          - gridcell [ref=f2e1002]
                    - rowgroup [ref=f2e1003]:
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e1005]
                    - generic [ref=f2e1007]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e1008]:
                    - status
                    - generic [ref=f2e1009]: "0"
                  - generic:
                    - spinbutton "InputNumber Input" [ref=f2e1013]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1017]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1021]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1025]: "0.000"
                    - generic [ref=f2e1028]:
                      - combobox "InputDateTime Input" [ref=f2e1029]: 2026-11-14 05:54:37
                      - generic [ref=f2e1030]:
                        - button "Toggle Calendar" [ref=f2e1031] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1033] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1038]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1042]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1046]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1050]: "0.000"
                    - generic [ref=f2e1053]:
                      - combobox "InputDateTime Input" [ref=f2e1054]: 2026-11-14 05:54:37
                      - generic [ref=f2e1055]:
                        - button "Toggle Calendar" [ref=f2e1056] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1058] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1063]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1067]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1071]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1075]: "0.000"
                    - generic [ref=f2e1078]:
                      - combobox "InputDateTime Input" [ref=f2e1079]: 2026-11-14 05:54:37
                      - generic [ref=f2e1080]:
                        - button "Toggle Calendar" [ref=f2e1081] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1083] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1088]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1092]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1096]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1100]: "0.000"
                    - generic [ref=f2e1103]:
                      - combobox "InputDateTime Input" [ref=f2e1104]: 2026-11-14 05:54:37
                      - generic [ref=f2e1105]:
                        - button "Toggle Calendar" [ref=f2e1106] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1108] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1113]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1117]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1121]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1125]: "0.000"
                    - generic [ref=f2e1128]:
                      - combobox "InputDateTime Input" [ref=f2e1129]: 2026-11-14 05:54:38
                      - generic [ref=f2e1130]:
                        - button "Toggle Calendar" [ref=f2e1131] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1133] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1138]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1142]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1146]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1150]: "0.000"
                    - generic [ref=f2e1153]:
                      - combobox "InputDateTime Input" [ref=f2e1154]: 2026-11-14 05:54:38
                      - generic [ref=f2e1155]:
                        - button "Toggle Calendar" [ref=f2e1156] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1158] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1163]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1167]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1171]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1175]: "0.000"
                    - generic [ref=f2e1178]:
                      - combobox "InputDateTime Input" [ref=f2e1179]: 2026-11-14 05:54:47
                      - generic [ref=f2e1180]:
                        - button "Toggle Calendar" [ref=f2e1181] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1183] [cursor=pointer]
                    - spinbutton "InputNumber Input" [ref=f2e1188]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1192]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1196]: "0.000"
                    - spinbutton "InputNumber Input" [ref=f2e1200]: "0.000"
                    - generic [ref=f2e1203]:
                      - combobox "InputDateTime Input" [ref=f2e1204]: 2026-11-14 05:54:47
                      - generic [ref=f2e1205]:
                        - button "Toggle Calendar" [ref=f2e1206] [cursor=pointer]
                        - button "Toggle Time List" [ref=f2e1208] [cursor=pointer]
            - alert [ref=f2e1210]:
              - generic [ref=f2e1211] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1214] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
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
  74  |       expect.soft(missLit.length, `As-is 병합 헤더 리터럴 노출 [${(HS.literals || []).join(', ')}]`).toBe(0);
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
> 113 |     expect.soft(s.error, `조회조건 판정 불가(ERROR) ${s.error}: ${items.filter(i => i.verdict === 'ERROR').map(i => i.name).join(', ')}`).toBe(0);
      |                                                                                                                                   ^ Error: 조회조건 판정 불가(ERROR) 4: Project Null, Project, End Customer(Report) Null, Detail
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