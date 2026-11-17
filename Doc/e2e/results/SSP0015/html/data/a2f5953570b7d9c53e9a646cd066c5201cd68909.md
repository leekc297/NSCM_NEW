# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0015.smoke.spec.ts >> SSP0015 ShipmentPSI 스모크 @smoke >> 공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual
- Location: ..\..\Doc\e2e\specs\SSP0015.smoke.spec.ts:115:7

# Error details

```
TimeoutError: locator.click: Timeout 20000ms exceeded.
Call log:
  - waiting for getByRole('combobox').first()
    - locator resolved to <input disabled id=":r9:" type="text" role="combobox" autocomplete="off" spellcheck="false" aria-invalid="false" aria-expanded="false" autocapitalize="none" aria-autocomplete="list" value="40 Mobility & IT Battery" class="MuiInputBase-input MuiOutlinedInput-input Mui-disabled MuiInputBase-inputAdornedStart MuiInputBase-inputAdornedEnd MuiAutocomplete-input MuiAutocomplete-inputFocused css-1e3onoi-MuiInputBase-input-MuiOutlinedInput-input"/>
  - attempting click action
    2 × waiting for element to be visible, enabled and stable
      - element is not enabled
    - retrying click action
    - waiting 20ms
    2 × waiting for element to be visible, enabled and stable
      - element is not enabled
    - retrying click action
      - waiting 100ms
    37 × waiting for element to be visible, enabled and stable
       - element is not enabled
     - retrying click action
       - waiting 500ms

```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/SSP0015
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SSP0015
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SSP0015
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SSP0015
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SSP0015
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SSP0015
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/SSP0015
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
              - /url: /view/SSP0015
              - paragraph [ref=f2e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0015
              - paragraph [ref=f2e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0015
              - paragraph [ref=f2e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0015
              - paragraph [ref=f2e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0015
              - paragraph [ref=f2e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0015
              - paragraph [ref=f2e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0015
              - paragraph [ref=f2e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0015
              - paragraph [ref=f2e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0015
              - paragraph [ref=f2e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f2e53]:
            - link [ref=f2e54] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e55]: Shipping Schedule
            - link [ref=f2e58] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e59]: Shipment Request
            - link [ref=f2e60] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e61]: Shipment Plan(Mobility & IT)
            - link [ref=f2e62] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e63]: Shipment Plan(Electrode)
            - link [ref=f2e64] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f2e66] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e67]: Shipment Plan Detail
            - link [ref=f2e68] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e69]: Shipment Change History
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e71]: Shipment Plan(Auto & ESS)
            - link [ref=f2e72] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e73]: Shipment Request(Mobility & IT)
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e75]: Shipment Request(Electrode)
            - link [ref=f2e76] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e77]: Shipment Change Request
            - link [ref=f2e78] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e79]: Shipment Change Request Confirm
            - link [ref=f2e80] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e81]: Inventory Raw(Mobility & IT)
            - link [ref=f2e82] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e83]: Shipment Change Request(Packer)
            - link [ref=f2e84] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/SSP0015
              - paragraph [ref=f2e87]: Shipment Request SEMI
      - main [ref=f2e88]:
        - generic [ref=f2e90]:
          - generic [ref=f2e91]:
            - generic [ref=f2e92]:
              - button "Home" [ref=f2e93] [cursor=pointer]
              - button "Shipment Plan(Mobility & IT)" [active] [ref=f2e95] [cursor=pointer]
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
                  - paragraph [ref=f2e120]: Shipment Plan(Mobility & IT)
                - generic [ref=f2e121]:
                  - generic [ref=f2e122]: Shipping
                  - generic [ref=f2e127]: Shipping Schedule
                  - generic [ref=f2e132]: Shipment Plan(Mobility & IT)
                - generic [ref=f2e134]:
                  - generic [ref=f2e135]: Search Area
                  - switch [checked] [ref=f2e138] [cursor=pointer]
                - button "Full screen" [ref=f2e141] [cursor=pointer]
              - generic [ref=f2e151]:
                - generic [ref=f2e152]:
                  - generic [ref=f2e154]:
                    - generic [ref=f2e155]: Div
                    - generic [ref=f2e163]:
                      - combobox [disabled] [ref=f2e164]: 40 Mobility & IT Battery
                      - generic [ref=f2e165]:
                        - button "Open" [disabled]
                      - group [aria-hidden]
                  - generic [ref=f2e167]:
                    - generic [ref=f2e168]: From Site
                    - generic [ref=f2e176] [cursor=pointer]:
                      - combobox "ALL" [ref=f2e177]
                      - button "Open" [ref=f2e179]
                      - group [aria-hidden]
                  - generic [ref=f2e184]:
                    - generic [ref=f2e185]: Bucket
                    - generic [ref=f2e193]:
                      - combobox [ref=f2e194]: Daily
                      - button "Open" [ref=f2e196] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e201]:
                    - generic [ref=f2e202]: Model/Nickname
                    - generic [ref=f2e208]:
                      - textbox [ref=f2e209]
                      - button [ref=f2e210] [cursor=pointer]
                  - generic [ref=f2e216]:
                    - generic [ref=f2e217]: Plan Date*
                    - generic [ref=f2e225]:
                      - combobox [ref=f2e226]: 2026-10-10
                      - button "Open" [ref=f2e228] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e233]:
                    - generic [ref=f2e234]: Period*
                    - generic [ref=f2e241]:
                      - generic [ref=f2e244]:
                        - img [aria-hidden] [ref=f2e246] [cursor=pointer]
                        - textbox "YYYY.MM.DD" [ref=f2e254]: 2026.10.10
                      - generic [ref=f2e255]: ~
                      - generic [ref=f2e258]:
                        - img [aria-hidden] [ref=f2e260] [cursor=pointer]
                        - textbox "YYYY.MM.DD" [ref=f2e268]: 2026.11.10
                  - generic [ref=f2e275]:
                    - generic [ref=f2e276] [cursor=pointer]:
                      - checkbox "My Model" [ref=f2e278]
                      - generic [ref=f2e279]: My Model
                    - generic [ref=f2e280] [cursor=pointer]:
                      - checkbox "Part Leader" [ref=f2e282]
                      - generic [ref=f2e283]: Part Leader
                    - generic [ref=f2e284] [cursor=pointer]:
                      - checkbox "Team Leader" [ref=f2e286]
                      - generic [ref=f2e287]: Team Leader
                    - generic [ref=f2e288] [cursor=pointer]:
                      - checkbox "Delegatee Model" [ref=f2e290]
                      - generic [ref=f2e291]: Delegatee Model
                    - generic [ref=f2e293] [cursor=pointer]:
                      - checkbox "Sum" [ref=f2e295]
                      - generic [ref=f2e296]: Sum
                - button [ref=f2e298] [cursor=pointer]
              - generic [ref=f2e303]:
                - generic:
                  - paragraph
                - generic [ref=f2e304]:
                  - generic "Measure" [ref=f2e305]:
                    - button "Measure" [ref=f2e306] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e310]:
                    - button [ref=f2e311] [cursor=pointer]
                  - generic "Remove" [ref=f2e316]:
                    - button [ref=f2e317] [cursor=pointer]
                  - generic "Save" [ref=f2e324]:
                    - button [ref=f2e325] [cursor=pointer]
                  - generic "Sort" [ref=f2e329]:
                    - button [ref=f2e330] [cursor=pointer]
                  - generic "Filter" [ref=f2e335]:
                    - button [ref=f2e336] [cursor=pointer]
                  - generic "Condition" [ref=f2e341]:
                    - button [ref=f2e342] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e352]:
                    - button [ref=f2e353] [cursor=pointer]
                  - generic "Excel" [ref=f2e360]:
                    - button [ref=f2e361] [cursor=pointer]
              - generic [ref=f2e370]:
                - generic [ref=f2e373]:
                  - generic [ref=f2e376]:
                    - button "Shipment PSI(Mobility & IT)" [ref=f2e377]
                    - button "Shipment PSI(Packer)" [ref=f2e379]
                  - generic [ref=f2e382]:
                    - grid [ref=f2e383]:
                      - rowgroup [ref=f2e384]:
                        - generic:
                          - row "Div From Site Model Nick Name Aging L/T Yield(%) BOH PSI Measure No":
                            - columnheader "Div" [ref=f2e385]
                            - columnheader "From Site" [ref=f2e386]
                            - columnheader "Model" [ref=f2e387]
                            - columnheader "Nick Name" [ref=f2e388]
                            - columnheader "Aging L/T" [ref=f2e389]
                            - columnheader "Yield(%)" [ref=f2e390]
                            - columnheader "BOH" [ref=f2e391]
                            - columnheader "PSI" [ref=f2e392]
                            - columnheader "Measure" [ref=f2e393]
                            - gridcell "No" [ref=f2e394]
                            - gridcell [ref=f2e395]
                          - row "TYPE Figure":
                            - columnheader "TYPE" [ref=f2e396]
                            - columnheader "Figure" [ref=f2e397]
                      - rowgroup [ref=f2e398]:
                        - row "Focus helper":
                          - gridcell "Focus helper" [ref=f2e400]
                      - generic [ref=f2e402]:
                        - generic:
                          - row "No"
                    - generic [ref=f2e403]:
                      - status
                      - generic [ref=f2e404]: "0"
                - separator [ref=f2e405]
                - generic [ref=f2e408]:
                  - generic [ref=f2e409]:
                    - generic [ref=f2e410]:
                      - generic [ref=f2e412]:
                        - generic [ref=f2e413]: Shipment Date
                        - generic [ref=f2e420]:
                          - generic [ref=f2e423]:
                            - img [aria-hidden] [ref=f2e425] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e433]: 2026.10.10
                          - generic [ref=f2e434]: ~
                          - generic [ref=f2e437]:
                            - img [aria-hidden] [ref=f2e439] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e447]: 2026.11.10
                      - generic [ref=f2e449]:
                        - generic [ref=f2e450]: Model/Nickname
                        - generic [ref=f2e456]:
                          - textbox [ref=f2e457]
                          - button [ref=f2e458] [cursor=pointer]
                      - generic [ref=f2e464]:
                        - generic [ref=f2e465]: Requestor
                        - generic [ref=f2e471]:
                          - textbox [ref=f2e472]
                          - button [ref=f2e473] [cursor=pointer]
                    - button "Search" [ref=f2e479] [cursor=pointer]
                  - generic [ref=f2e480]:
                    - generic [ref=f2e481]:
                      - button "Shipment Confirm Detail" [ref=f2e482]
                      - button "W/H stock" [ref=f2e484]
                      - button "W/H stock Detail" [ref=f2e486]
                      - button "Hold stock" [ref=f2e488]
                      - button "Hold stock Detail" [ref=f2e490]
                      - button "Stock Detail" [ref=f2e492]
                      - button "WH In Plan Detail" [ref=f2e494]
                      - button "Shipment Result" [ref=f2e496]
                    - generic [ref=f2e501]:
                      - grid [ref=f2e502]:
                        - rowgroup [ref=f2e503]:
                          - generic:
                            - row "Div Status SO No Confirm/Plan ID Model Nick Name From Site To Site End Customer MKT Owner Team FCST Type Shipment Qty Shipment Date Trans Mode Building No":
                              - columnheader "Div" [ref=f2e504]
                              - columnheader "Status" [ref=f2e505]
                              - columnheader "SO No" [ref=f2e506]
                              - columnheader "Confirm/Plan ID" [ref=f2e507]
                              - columnheader "Model" [ref=f2e508]
                              - columnheader "Nick Name" [ref=f2e509]
                              - columnheader "From Site" [ref=f2e510]
                              - columnheader "To Site" [ref=f2e511]
                              - columnheader "End Customer" [ref=f2e512]
                              - columnheader "MKT Owner" [ref=f2e513]
                              - columnheader "Team" [ref=f2e514]
                              - columnheader "FCST Type" [ref=f2e515]
                              - columnheader "Shipment Qty" [ref=f2e516]
                              - columnheader "Shipment Date" [ref=f2e517]
                              - columnheader "Trans Mode" [ref=f2e518]
                              - columnheader "Building" [ref=f2e519]
                              - gridcell "No" [ref=f2e520]
                              - gridcell [ref=f2e521]
                        - rowgroup [ref=f2e522]:
                          - row "Focus helper":
                            - gridcell "Focus helper" [ref=f2e524]
                        - generic [ref=f2e526]:
                          - generic:
                            - row "No"
                      - generic [ref=f2e527]:
                        - status
                        - generic [ref=f2e528]: "0"
                      - generic:
                        - spinbutton "InputNumber Input" [ref=f2e532]: "0"
                        - generic [ref=f2e535]:
                          - combobox "InputDate Input" [ref=f2e536]: 2026-11-14
                          - button "Choose Date" [ref=f2e538] [cursor=pointer]
                        - generic [ref=f2e542]:
                          - combobox "InputDate Input" [ref=f2e543]: 2026-11-14
                          - button "Choose Date" [ref=f2e545] [cursor=pointer]
                        - generic [ref=f2e549]:
                          - combobox "InputDate Input" [ref=f2e550]: 2026-11-14
                          - button "Choose Date" [ref=f2e552] [cursor=pointer]
                        - generic [ref=f2e556]:
                          - combobox "InputDateTime Input" [ref=f2e557]: 2026-11-14 21:29:46
                          - generic [ref=f2e558]:
                            - button "Toggle Calendar" [ref=f2e559] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e561] [cursor=pointer]
                        - generic [ref=f2e565]:
                          - combobox "InputDate Input" [ref=f2e566]: 2026-11-14
                          - button "Choose Date" [ref=f2e568] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e573]: "0"
                        - generic [ref=f2e576]:
                          - combobox "InputDate Input" [ref=f2e577]: 2026-11-14
                          - button "Choose Date" [ref=f2e579] [cursor=pointer]
                        - generic [ref=f2e583]:
                          - combobox "InputDate Input" [ref=f2e584]: 2026-11-14
                          - button "Choose Date" [ref=f2e586] [cursor=pointer]
                        - generic [ref=f2e590]:
                          - combobox "InputDate Input" [ref=f2e591]: 2026-11-14
                          - button "Choose Date" [ref=f2e593] [cursor=pointer]
                        - generic [ref=f2e597]:
                          - combobox "InputDateTime Input" [ref=f2e598]: 2026-11-14 21:29:46
                          - generic [ref=f2e599]:
                            - button "Toggle Calendar" [ref=f2e600] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e602] [cursor=pointer]
                        - generic [ref=f2e606]:
                          - combobox "InputDate Input" [ref=f2e607]: 2026-11-14
                          - button "Choose Date" [ref=f2e609] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e614]: "0"
                        - generic [ref=f2e617]:
                          - combobox "InputDate Input" [ref=f2e618]: 2026-11-14
                          - button "Choose Date" [ref=f2e620] [cursor=pointer]
                        - generic [ref=f2e624]:
                          - combobox "InputDate Input" [ref=f2e625]: 2026-11-14
                          - button "Choose Date" [ref=f2e627] [cursor=pointer]
                        - generic [ref=f2e631]:
                          - combobox "InputDate Input" [ref=f2e632]: 2026-11-14
                          - button "Choose Date" [ref=f2e634] [cursor=pointer]
                        - generic [ref=f2e638]:
                          - combobox "InputDateTime Input" [ref=f2e639]: 2026-11-14 21:29:46
                          - generic [ref=f2e640]:
                            - button "Toggle Calendar" [ref=f2e641] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e643] [cursor=pointer]
                        - generic [ref=f2e647]:
                          - combobox "InputDate Input" [ref=f2e648]: 2026-11-14
                          - button "Choose Date" [ref=f2e650] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e655]: "0"
                        - generic [ref=f2e658]:
                          - combobox "InputDate Input" [ref=f2e659]: 2026-11-14
                          - button "Choose Date" [ref=f2e661] [cursor=pointer]
                        - generic [ref=f2e665]:
                          - combobox "InputDate Input" [ref=f2e666]: 2026-11-14
                          - button "Choose Date" [ref=f2e668] [cursor=pointer]
                        - generic [ref=f2e672]:
                          - combobox "InputDate Input" [ref=f2e673]: 2026-11-14
                          - button "Choose Date" [ref=f2e675] [cursor=pointer]
                        - generic [ref=f2e679]:
                          - combobox "InputDateTime Input" [ref=f2e680]: 2026-11-14 21:29:46
                          - generic [ref=f2e681]:
                            - button "Toggle Calendar" [ref=f2e682] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e684] [cursor=pointer]
                        - generic [ref=f2e688]:
                          - combobox "InputDate Input" [ref=f2e689]: 2026-11-14
                          - button "Choose Date" [ref=f2e691] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e696]: "0"
                        - generic [ref=f2e699]:
                          - combobox "InputDate Input" [ref=f2e700]: 2026-11-14
                          - button "Choose Date" [ref=f2e702] [cursor=pointer]
                        - generic [ref=f2e706]:
                          - combobox "InputDate Input" [ref=f2e707]: 2026-11-14
                          - button "Choose Date" [ref=f2e709] [cursor=pointer]
                        - generic [ref=f2e713]:
                          - combobox "InputDate Input" [ref=f2e714]: 2026-11-14
                          - button "Choose Date" [ref=f2e716] [cursor=pointer]
                        - generic [ref=f2e720]:
                          - combobox "InputDateTime Input" [ref=f2e721]: 2026-11-14 21:29:47
                          - generic [ref=f2e722]:
                            - button "Toggle Calendar" [ref=f2e723] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e725] [cursor=pointer]
                        - generic [ref=f2e729]:
                          - combobox "InputDate Input" [ref=f2e730]: 2026-11-14
                          - button "Choose Date" [ref=f2e732] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e737]: "0"
                        - generic [ref=f2e740]:
                          - combobox "InputDate Input" [ref=f2e741]: 2026-11-14
                          - button "Choose Date" [ref=f2e743] [cursor=pointer]
                        - generic [ref=f2e747]:
                          - combobox "InputDate Input" [ref=f2e748]: 2026-11-14
                          - button "Choose Date" [ref=f2e750] [cursor=pointer]
                        - generic [ref=f2e754]:
                          - combobox "InputDate Input" [ref=f2e755]: 2026-11-14
                          - button "Choose Date" [ref=f2e757] [cursor=pointer]
                        - generic [ref=f2e761]:
                          - combobox "InputDateTime Input" [ref=f2e762]: 2026-11-14 21:29:47
                          - generic [ref=f2e763]:
                            - button "Toggle Calendar" [ref=f2e764] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e766] [cursor=pointer]
                        - generic [ref=f2e770]:
                          - combobox "InputDate Input" [ref=f2e771]: 2026-11-14
                          - button "Choose Date" [ref=f2e773] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e778]: "0"
                        - generic [ref=f2e781]:
                          - combobox "InputDate Input" [ref=f2e782]: 2026-11-14
                          - button "Choose Date" [ref=f2e784] [cursor=pointer]
                        - generic [ref=f2e788]:
                          - combobox "InputDate Input" [ref=f2e789]: 2026-11-14
                          - button "Choose Date" [ref=f2e791] [cursor=pointer]
                        - generic [ref=f2e795]:
                          - combobox "InputDate Input" [ref=f2e796]: 2026-11-14
                          - button "Choose Date" [ref=f2e798] [cursor=pointer]
                        - generic [ref=f2e802]:
                          - combobox "InputDateTime Input" [ref=f2e803]: 2026-11-14 21:29:47
                          - generic [ref=f2e804]:
                            - button "Toggle Calendar" [ref=f2e805] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e807] [cursor=pointer]
                        - generic [ref=f2e811]:
                          - combobox "InputDate Input" [ref=f2e812]: 2026-11-14
                          - button "Choose Date" [ref=f2e814] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e819]: "0"
                        - generic [ref=f2e822]:
                          - combobox "InputDate Input" [ref=f2e823]: 2026-11-14
                          - button "Choose Date" [ref=f2e825] [cursor=pointer]
                        - generic [ref=f2e829]:
                          - combobox "InputDate Input" [ref=f2e830]: 2026-11-14
                          - button "Choose Date" [ref=f2e832] [cursor=pointer]
                        - generic [ref=f2e836]:
                          - combobox "InputDate Input" [ref=f2e837]: 2026-11-14
                          - button "Choose Date" [ref=f2e839] [cursor=pointer]
                        - generic [ref=f2e843]:
                          - combobox "InputDateTime Input" [ref=f2e844]: 2026-11-14 21:29:47
                          - generic [ref=f2e845]:
                            - button "Toggle Calendar" [ref=f2e846] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e848] [cursor=pointer]
                        - generic [ref=f2e852]:
                          - combobox "InputDate Input" [ref=f2e853]: 2026-11-14
                          - button "Choose Date" [ref=f2e855] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e860]: "0"
                        - generic [ref=f2e863]:
                          - combobox "InputDate Input" [ref=f2e864]: 2026-11-14
                          - button "Choose Date" [ref=f2e866] [cursor=pointer]
                        - generic [ref=f2e870]:
                          - combobox "InputDate Input" [ref=f2e871]: 2026-11-14
                          - button "Choose Date" [ref=f2e873] [cursor=pointer]
                        - generic [ref=f2e877]:
                          - combobox "InputDate Input" [ref=f2e878]: 2026-11-14
                          - button "Choose Date" [ref=f2e880] [cursor=pointer]
                        - generic [ref=f2e884]:
                          - combobox "InputDateTime Input" [ref=f2e885]: 2026-11-14 21:29:47
                          - generic [ref=f2e886]:
                            - button "Toggle Calendar" [ref=f2e887] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e889] [cursor=pointer]
                        - generic [ref=f2e893]:
                          - combobox "InputDate Input" [ref=f2e894]: 2026-11-14
                          - button "Choose Date" [ref=f2e896] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e901]: "0"
                        - generic [ref=f2e904]:
                          - combobox "InputDate Input" [ref=f2e905]: 2026-11-14
                          - button "Choose Date" [ref=f2e907] [cursor=pointer]
                        - generic [ref=f2e911]:
                          - combobox "InputDate Input" [ref=f2e912]: 2026-11-14
                          - button "Choose Date" [ref=f2e914] [cursor=pointer]
                        - generic [ref=f2e918]:
                          - combobox "InputDate Input" [ref=f2e919]: 2026-11-14
                          - button "Choose Date" [ref=f2e921] [cursor=pointer]
                        - generic [ref=f2e925]:
                          - combobox "InputDateTime Input" [ref=f2e926]: 2026-11-14 21:29:47
                          - generic [ref=f2e927]:
                            - button "Toggle Calendar" [ref=f2e928] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e930] [cursor=pointer]
                        - generic [ref=f2e934]:
                          - combobox "InputDate Input" [ref=f2e935]: 2026-11-14
                          - button "Choose Date" [ref=f2e937] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e942]: "0"
                        - generic [ref=f2e945]:
                          - combobox "InputDate Input" [ref=f2e946]: 2026-11-14
                          - button "Choose Date" [ref=f2e948] [cursor=pointer]
                        - generic [ref=f2e952]:
                          - combobox "InputDate Input" [ref=f2e953]: 2026-11-14
                          - button "Choose Date" [ref=f2e955] [cursor=pointer]
                        - generic [ref=f2e959]:
                          - combobox "InputDate Input" [ref=f2e960]: 2026-11-14
                          - button "Choose Date" [ref=f2e962] [cursor=pointer]
                        - generic [ref=f2e966]:
                          - combobox "InputDateTime Input" [ref=f2e967]: 2026-11-14 21:29:47
                          - generic [ref=f2e968]:
                            - button "Toggle Calendar" [ref=f2e969] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e971] [cursor=pointer]
                        - generic [ref=f2e975]:
                          - combobox "InputDate Input" [ref=f2e976]: 2026-11-14
                          - button "Choose Date" [ref=f2e978] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e983]: "0"
                        - generic [ref=f2e986]:
                          - combobox "InputDate Input" [ref=f2e987]: 2026-11-14
                          - button "Choose Date" [ref=f2e989] [cursor=pointer]
                        - generic [ref=f2e993]:
                          - combobox "InputDate Input" [ref=f2e994]: 2026-11-14
                          - button "Choose Date" [ref=f2e996] [cursor=pointer]
                        - generic [ref=f2e1000]:
                          - combobox "InputDate Input" [ref=f2e1001]: 2026-11-14
                          - button "Choose Date" [ref=f2e1003] [cursor=pointer]
                        - generic [ref=f2e1007]:
                          - combobox "InputDateTime Input" [ref=f2e1008]: 2026-11-14 21:29:47
                          - generic [ref=f2e1009]:
                            - button "Toggle Calendar" [ref=f2e1010] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1012] [cursor=pointer]
                        - generic [ref=f2e1016]:
                          - combobox "InputDate Input" [ref=f2e1017]: 2026-11-14
                          - button "Choose Date" [ref=f2e1019] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1024]: "0"
                        - generic [ref=f2e1027]:
                          - combobox "InputDate Input" [ref=f2e1028]: 2026-11-14
                          - button "Choose Date" [ref=f2e1030] [cursor=pointer]
                        - generic [ref=f2e1034]:
                          - combobox "InputDate Input" [ref=f2e1035]: 2026-11-14
                          - button "Choose Date" [ref=f2e1037] [cursor=pointer]
                        - generic [ref=f2e1041]:
                          - combobox "InputDate Input" [ref=f2e1042]: 2026-11-14
                          - button "Choose Date" [ref=f2e1044] [cursor=pointer]
                        - generic [ref=f2e1048]:
                          - combobox "InputDateTime Input" [ref=f2e1049]: 2026-11-14 21:29:47
                          - generic [ref=f2e1050]:
                            - button "Toggle Calendar" [ref=f2e1051] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1053] [cursor=pointer]
                        - generic [ref=f2e1057]:
                          - combobox "InputDate Input" [ref=f2e1058]: 2026-11-14
                          - button "Choose Date" [ref=f2e1060] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1065]: "0"
                        - generic [ref=f2e1068]:
                          - combobox "InputDate Input" [ref=f2e1069]: 2026-11-14
                          - button "Choose Date" [ref=f2e1071] [cursor=pointer]
                        - generic [ref=f2e1075]:
                          - combobox "InputDate Input" [ref=f2e1076]: 2026-11-14
                          - button "Choose Date" [ref=f2e1078] [cursor=pointer]
                        - generic [ref=f2e1082]:
                          - combobox "InputDate Input" [ref=f2e1083]: 2026-11-14
                          - button "Choose Date" [ref=f2e1085] [cursor=pointer]
                        - generic [ref=f2e1089]:
                          - combobox "InputDateTime Input" [ref=f2e1090]: 2026-11-14 21:29:47
                          - generic [ref=f2e1091]:
                            - button "Toggle Calendar" [ref=f2e1092] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1094] [cursor=pointer]
                        - generic [ref=f2e1098]:
                          - combobox "InputDate Input" [ref=f2e1099]: 2026-11-14
                          - button "Choose Date" [ref=f2e1101] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1106]: "0"
                        - generic [ref=f2e1109]:
                          - combobox "InputDate Input" [ref=f2e1110]: 2026-11-14
                          - button "Choose Date" [ref=f2e1112] [cursor=pointer]
                        - generic [ref=f2e1116]:
                          - combobox "InputDate Input" [ref=f2e1117]: 2026-11-14
                          - button "Choose Date" [ref=f2e1119] [cursor=pointer]
                        - generic [ref=f2e1123]:
                          - combobox "InputDate Input" [ref=f2e1124]: 2026-11-14
                          - button "Choose Date" [ref=f2e1126] [cursor=pointer]
                        - generic [ref=f2e1130]:
                          - combobox "InputDateTime Input" [ref=f2e1131]: 2026-11-14 21:29:47
                          - generic [ref=f2e1132]:
                            - button "Toggle Calendar" [ref=f2e1133] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1135] [cursor=pointer]
                        - generic [ref=f2e1139]:
                          - combobox "InputDate Input" [ref=f2e1140]: 2026-11-14
                          - button "Choose Date" [ref=f2e1142] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1147]: "0"
                        - generic [ref=f2e1150]:
                          - combobox "InputDate Input" [ref=f2e1151]: 2026-11-14
                          - button "Choose Date" [ref=f2e1153] [cursor=pointer]
                        - generic [ref=f2e1157]:
                          - combobox "InputDate Input" [ref=f2e1158]: 2026-11-14
                          - button "Choose Date" [ref=f2e1160] [cursor=pointer]
                        - generic [ref=f2e1164]:
                          - combobox "InputDate Input" [ref=f2e1165]: 2026-11-14
                          - button "Choose Date" [ref=f2e1167] [cursor=pointer]
                        - generic [ref=f2e1171]:
                          - combobox "InputDateTime Input" [ref=f2e1172]: 2026-11-14 21:29:47
                          - generic [ref=f2e1173]:
                            - button "Toggle Calendar" [ref=f2e1174] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1176] [cursor=pointer]
                        - generic [ref=f2e1180]:
                          - combobox "InputDate Input" [ref=f2e1181]: 2026-11-14
                          - button "Choose Date" [ref=f2e1183] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1188]: "0"
                        - generic [ref=f2e1191]:
                          - combobox "InputDate Input" [ref=f2e1192]: 2026-11-14
                          - button "Choose Date" [ref=f2e1194] [cursor=pointer]
                        - generic [ref=f2e1198]:
                          - combobox "InputDate Input" [ref=f2e1199]: 2026-11-14
                          - button "Choose Date" [ref=f2e1201] [cursor=pointer]
                        - generic [ref=f2e1205]:
                          - combobox "InputDate Input" [ref=f2e1206]: 2026-11-14
                          - button "Choose Date" [ref=f2e1208] [cursor=pointer]
                        - generic [ref=f2e1212]:
                          - combobox "InputDateTime Input" [ref=f2e1213]: 2026-11-14 21:29:47
                          - generic [ref=f2e1214]:
                            - button "Toggle Calendar" [ref=f2e1215] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1217] [cursor=pointer]
                        - generic [ref=f2e1221]:
                          - combobox "InputDate Input" [ref=f2e1222]: 2026-11-14
                          - button "Choose Date" [ref=f2e1224] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1229]: "0"
                        - generic [ref=f2e1232]:
                          - combobox "InputDate Input" [ref=f2e1233]: 2026-11-14
                          - button "Choose Date" [ref=f2e1235] [cursor=pointer]
                        - generic [ref=f2e1239]:
                          - combobox "InputDate Input" [ref=f2e1240]: 2026-11-14
                          - button "Choose Date" [ref=f2e1242] [cursor=pointer]
                        - generic [ref=f2e1246]:
                          - combobox "InputDate Input" [ref=f2e1247]: 2026-11-14
                          - button "Choose Date" [ref=f2e1249] [cursor=pointer]
                        - generic [ref=f2e1253]:
                          - combobox "InputDateTime Input" [ref=f2e1254]: 2026-11-14 21:29:47
                          - generic [ref=f2e1255]:
                            - button "Toggle Calendar" [ref=f2e1256] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1258] [cursor=pointer]
                        - generic [ref=f2e1262]:
                          - combobox "InputDate Input" [ref=f2e1263]: 2026-11-14
                          - button "Choose Date" [ref=f2e1265] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1270]: "0"
                        - generic [ref=f2e1273]:
                          - combobox "InputDate Input" [ref=f2e1274]: 2026-11-14
                          - button "Choose Date" [ref=f2e1276] [cursor=pointer]
                        - generic [ref=f2e1280]:
                          - combobox "InputDate Input" [ref=f2e1281]: 2026-11-14
                          - button "Choose Date" [ref=f2e1283] [cursor=pointer]
                        - generic [ref=f2e1287]:
                          - combobox "InputDate Input" [ref=f2e1288]: 2026-11-14
                          - button "Choose Date" [ref=f2e1290] [cursor=pointer]
                        - generic [ref=f2e1294]:
                          - combobox "InputDateTime Input" [ref=f2e1295]: 2026-11-14 21:29:47
                          - generic [ref=f2e1296]:
                            - button "Toggle Calendar" [ref=f2e1297] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1299] [cursor=pointer]
                        - generic [ref=f2e1303]:
                          - combobox "InputDate Input" [ref=f2e1304]: 2026-11-14
                          - button "Choose Date" [ref=f2e1306] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e1311]: "0"
                        - generic [ref=f2e1314]:
                          - combobox "InputDate Input" [ref=f2e1315]: 2026-11-14
                          - button "Choose Date" [ref=f2e1317] [cursor=pointer]
                        - generic [ref=f2e1321]:
                          - combobox "InputDate Input" [ref=f2e1322]: 2026-11-14
                          - button "Choose Date" [ref=f2e1324] [cursor=pointer]
                        - generic [ref=f2e1328]:
                          - combobox "InputDate Input" [ref=f2e1329]: 2026-11-14
                          - button "Choose Date" [ref=f2e1331] [cursor=pointer]
                        - generic [ref=f2e1335]:
                          - combobox "InputDateTime Input" [ref=f2e1336]: 2026-11-14 21:29:47
                          - generic [ref=f2e1337]:
                            - button "Toggle Calendar" [ref=f2e1338] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1340] [cursor=pointer]
                        - generic [ref=f2e1344]:
                          - combobox "InputDate Input" [ref=f2e1345]: 2026-11-14
                          - button "Choose Date" [ref=f2e1347] [cursor=pointer]
            - alert [ref=f2e1349]:
              - generic [ref=f2e1350] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1353] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  286 | 
  287 |   /** 알림/확인 다이얼로그 닫기 (확인 우선) */
  288 |   async closeAlert(prefer: 'ok' | 'cancel' = 'ok') {
  289 |     // 보이는 대화상자만(닫힌 요소 잔존 오인 방지). 확인 쪽 = Confirm 포함 — 'Cancel·Confirm' 확인창에서 /./ 대체 규칙이 첫 버튼 Cancel 을 눌러
  290 |     //   저장이 취소되던 사고(2026-10-24 DMF0082 'Would you like to save it?'). 해당 버튼이 없으면 마지막 버튼(주 동작)
  291 |     const dlg = this.page.locator('[role="dialog"]:visible, [role="alertdialog"]:visible, .MuiDialog-root:visible').last();
  292 |     if (!(await dlg.isVisible({ timeout: 1_000 }).catch(() => false))) return false;
  293 |     const names = prefer === 'ok' ? [/^(확인|OK|Yes|예|Confirm|저장|Save|닫기|Close)$/i] : [/^(취소|Cancel|No|아니오)$/i, /^(확인|OK|닫기|Close)$/i];
  294 |     for (const n of names) { const b = dlg.getByRole('button', { name: n }).first(); if (await b.isVisible().catch(() => false)) { await b.click({ timeout: 5_000 }).catch(() => undefined); return true; } }
  295 |     if (prefer === 'ok') { const last = dlg.getByRole('button').last(); if (await last.isVisible().catch(() => false)) { await last.click({ timeout: 5_000 }).catch(() => undefined); return true; } }
  296 |     await this.page.keyboard.press('Escape'); return true;
  297 |   }
  298 | 
  299 |   /** 열려 있는 에러/경고 알림 텍스트(없으면 '') */
  300 |   async alertText() {
  301 |     const dlg = this.page.locator('[role="dialog"], [role="alertdialog"], .MuiDialog-root').last();
  302 |     return (await dlg.isVisible({ timeout: 500 }).catch(() => false)) ? (await dlg.innerText({ timeout: 2_000 }).catch(() => '')).trim() : '';  // 닫히는 중인 대화상자(W9 저장 직후) 예외 방지 2026-10-27
  303 |   }
  304 | 
  305 |   searchArea(): Locator { return this.page.locator('[class*="SearchArea"], [class*="searchArea"], form').first(); }
  306 | 
  307 |   /** 라벨 텍스트로 조회조건 입력 컨트롤을 찾는다(FormItem 라벨 → 형제 input/combobox) */
  308 |   /**
  309 |    * 보이는 첫 요소 — MDI 는 keep-alive 라 Home 등 비활성 탭의 DOM 이 숨은 채 남아 있다(Home 의 'Division' 표 헤더 등).
  310 |    * `.first()` 가 숨은 요소를 집으면 isVisible=false 로 오판 → 앞에서부터 보이는 것을 찾는다(Playwright 1.49 는 filter({visible}) 미지원).
  311 |    */
  312 |   async visibleFirst(loc: Locator, max = 12): Promise<Locator | null> {
  313 |     const n = Math.min(await loc.count().catch(() => 0), max);
  314 |     for (let i = 0; i < n; i++) { const l = loc.nth(i); if (await l.isVisible().catch(() => false)) return l; }
  315 |     return null;
  316 |   }
  317 | 
  318 |   fieldByLabel(label: string): Locator {
  319 |     const lab = this.page.getByText(new RegExp(`^\\s*${escapeRe(label)}\\s*\\*?\\s*$`, 'i')).first();
  320 |     return lab.locator('xpath=ancestor::*[self::div or self::label][1]/following-sibling::*[1]//input | ancestor::*[self::div][2]//input').first();
  321 |   }
  322 | 
  323 |   /**
  324 |    * 조회조건 라벨 존재. 2026-10-21(SCP0100): As-is 라벨의 필수표시 '*'(Plan date*) 는 To-Be 에서 라벨 밖 별도 요소라 떼고 비교 —
  325 |    *   앞/뒤 '*' 허용, 'Unit (Qty)'·'From (YYYYMMDD)' 처럼 괄호 접미는 허용(라벨 'From' 으로도 매칭), 대소문자 무시.
  326 |    */
  327 |   async fieldExists(label: string, waitMs = 5_000) {
  328 |     const core = String(label).replace(/^\s*\*+\s*|\s*\*+\s*$/g, '').trim(); if (!core) return false;
  329 |     const loc = this.page.getByText(new RegExp(`^\\s*\\*?\\s*${escapeRe(core)}(\\s*\\([^)]*\\))?\\s*\\*?\\s*$`, 'i'));
  330 |     const deadline = Date.now() + waitMs;
  331 |     do { if (await this.visibleFirst(loc)) return true; await this.page.waitForTimeout(250); } while (Date.now() < deadline);
  332 |     return false;
  333 |   }
  334 |   /** 후보 라벨 중 하나라도 보이면 그 라벨(없으면 ''). 첫 후보만 기본 대기, 나머지는 짧게 */
  335 |   async fieldExistsAny(labels: string[]) {
  336 |     const list = [...new Set(labels.map(s => String(s || '').trim()).filter(Boolean))];
  337 |     for (let i = 0; i < list.length; i++) if (await this.fieldExists(list[i], i === 0 ? 4_000 : 1_000)) return list[i];
  338 |     return '';
  339 |   }
  340 | 
  341 |   /**
  342 |    * 조회조건 펼치기 — 공용 SearchArea 는 extraConditions(2행 이후)를 접어 두고 Search 버튼 오른쪽의 화살표(텍스트 없는 버튼)로 펼친다.
  343 |    * 2026-10-21 SCP0100: 접힌 조건(Search Mode·Display·Plan Type·Cell Qty…)을 라벨 검사가 못 찾아 smoke FAIL → 라벨 검사 전에 한 번 펼친다.
  344 |    * 화면당 1회(openScreen 이 플래그 초기화). 화살표가 없으면(extraConditions 없음) false.
  345 |    */
  346 |   async expandSearchArea(force = false) {
  347 |     // force(2026-10-23 조회조건 동작 검사): 플래그와 무관하게 '지금 접혀 있으면' 다시 펼친다 — 접힘 판정 = 보이는 조회영역 안 MUI Collapse 가 hidden
  348 |     if (force) {
  349 |       const collapsed = await this.page.evaluate(() => Array.from(document.querySelectorAll('.MuiCollapse-hidden')).some(e => !!(e as HTMLElement).closest('form, [class*="SearchArea"], [class*="searchArea"]'))).catch(() => false);
  350 |       // 2026-10-29(SCP0100): MuiCollapse 가 아니라 자체 토글(_toggleButton_)로 두 번째 줄을 숨기는 조회영역 — 크기 0 인 formItem 이 있으면 접힌 것으로 본다
  351 |       const hiddenItems = await this.hiddenFormItems();
  352 |       if (!collapsed && !hiddenItems) return true;
  353 |       this.searchExpanded = false;
  354 |       if (!collapsed && hiddenItems) { if (await this.clickSearchToggle(hiddenItems)) { this.searchExpanded = true; return true; } }
  355 |     }
  356 |     if (this.searchExpanded) return true;
  357 |     const searchBtn = await this.visibleFirst(this.page.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }));
  358 |     if (!searchBtn) return false;
  359 |     const arrow = searchBtn.locator('xpath=following-sibling::button[1]').first();
  360 |     if (!(await arrow.isVisible({ timeout: 1_000 }).catch(() => false))) return false;
  361 |     if ((await arrow.innerText().catch(() => '')).trim()) return false; // 텍스트가 있으면 펼침 화살표가 아니다
  362 |     await arrow.click({ timeout: 5_000 }).catch(() => undefined);
  363 |     await this.page.waitForTimeout(600); // Collapse 애니메이션
  364 |     this.searchExpanded = true; return true;
  365 |   }
  366 |   private searchExpanded = false;
  367 |   /** 크기 0(숨김) 인 조회조건 칸 수 */
  368 |   private async hiddenFormItems(): Promise<number> {
  369 |     return this.page.evaluate(() => Array.from(document.querySelectorAll('[class*="_formItem_"]')).filter(e => !e.closest('.wj-flexgrid, [role="dialog"], .MuiDialog-root')).filter(e => { const b = (e as HTMLElement).getBoundingClientRect(); return b.width === 0 || b.height === 0; }).length).catch(() => 0);
  370 |   }
  371 |   /** 조회영역 토글 버튼(_toggleButton_ · 텍스트 없는 아이콘 버튼)을 눌러 숨은 칸이 줄면 성공, 아니면 되돌린다 */
  372 |   private async clickSearchToggle(before: number): Promise<boolean> {
  373 |     const btn = this.page.locator('[class*="_toggleButton_"], [class*="toggleButton"]').filter({ hasNot: this.page.locator('.wj-flexgrid') }).first();
  374 |     if (!(await btn.isVisible({ timeout: 1_000 }).catch(() => false))) return false;
  375 |     await btn.click({ timeout: 3_000 }).catch(() => undefined); await this.page.waitForTimeout(600);
  376 |     const after = await this.hiddenFormItems();
  377 |     if (after < before) return true;
  378 |     await btn.click({ timeout: 3_000 }).catch(() => undefined); await this.page.waitForTimeout(400);
  379 |     return false;
  380 |   }
  381 | 
  382 |   /** Division 선택 — DivisionField(콤보) 가 있으면 옵션 선택 */
  383 |   async setDivision(code: string) {
  384 |     const combo = await this.visibleFirst(this.page.getByRole('combobox'));
  385 |     if (!combo) return false;
> 386 |     await combo.click();
      |                 ^ TimeoutError: locator.click: Timeout 20000ms exceeded.
  387 |     const opt = this.page.getByRole('option', { name: new RegExp(`^\\s*${escapeRe(code)}(\\s|$|\\b)`) }).first();
  388 |     if (await opt.isVisible({ timeout: 3_000 }).catch(() => false)) { await opt.click(); return true; }
  389 |     await this.page.keyboard.press('Escape'); return false;
  390 |   }
  391 | 
  392 |   /** 조회 실행 — SearchArea 조회 버튼 → call-proc(SEARCH 류) 응답 대기 */
  393 |   /** 사용자 지정 조회조건 적용 — 라벨 트랙 글자로 FormItem 칸을 찾아 콤보면 값(숫자만 비교)이 들어있는 옵션을, 아니면 첫 입력칸에 값을 넣는다. 적용 결과는 userCondsNote 에 남긴다 */
  394 |   async applyUserConds(): Promise<string> {
  395 |     const notes: string[] = [];
  396 |     for (const [label, value] of Object.entries(this.userConds || {})) {
  397 |       try {
  398 |         await this.expandSearchArea().catch(() => undefined);
  399 |         const nrm = (s: string) => String(s || '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
  400 |         const item = this.page.locator('[class*="_formItem_"], [class*="formItem"]').filter({ has: this.page.locator(':scope > :first-child', { hasText: new RegExp(label.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i') }) }).first();
  401 |         if (!(await item.isVisible({ timeout: 3_000 }).catch(() => false))) { notes.push(`${label}: 칸 없음`); continue; }
  402 |         const combo = item.locator('[role="combobox"]').first();
  403 |         if (await combo.count()) {
  404 |           await combo.click({ timeout: 3_000 }).catch(() => undefined);
  405 |           const opts = this.page.locator('.MuiAutocomplete-popper [role="option"], [role="listbox"] [role="option"]');
  406 |           await opts.first().waitFor({ state: 'visible', timeout: 4_000 }).catch(() => undefined);
  407 |           const texts = await opts.allInnerTexts().catch(() => [] as string[]);
  408 |           const digits = value.replace(/\D/g, '');
  409 |           let idx = texts.findIndex(t => nrm(t) === nrm(value) || (digits.length >= 6 && t.replace(/\D/g, '').includes(digits)) || nrm(t).includes(nrm(value)));
  410 |           if (idx >= 0) { await opts.nth(idx).click({ timeout: 3_000 }).catch(() => undefined); notes.push(`${label}='${texts[idx].trim().slice(0, 30)}'`); }
  411 |           else { await this.page.keyboard.press('Escape').catch(() => undefined); notes.push(`${label}: 옵션 '${value}' 없음(후보 ${texts.length})`); }
  412 |         } else {
  413 |           const inp = item.locator('input:not([type="hidden"]), textarea').first();
  414 |           if (await inp.count()) { await inp.fill(value, { timeout: 3_000 }).catch(() => undefined); await inp.press('Tab').catch(() => undefined); notes.push(`${label}='${value}'`); } else notes.push(`${label}: 입력칸 없음`);
  415 |         }
  416 |       } catch (e) { notes.push(`${label}: 적용 실패 ${String((e as Error).message || e).slice(0, 60)}`); }
  417 |     }
  418 |     this.userCondsNote = notes.join(' · ');
  419 |     if (notes.length) console.log(`[userConds] ${this.userCondsNote}`);
  420 |     return this.userCondsNote;
  421 |   }
  422 |   /** 2026-11-06 T59: 필수 알림이 가리킨 조회조건 칸을 화면 콤보 후보(ALL·빈 값 제외 첫 후보)로 채운다 — 사전 데이터셋 아님(화면 후보만).
  423 |    *  반환 '선택 …' = 채움 · 그 밖 = 실패 사유. 다중선택은 첫 후보 1개만 체크한다(index 로 다른 후보 지정 가능) */
  424 |   requiredNotes: string[] = [];
  425 |   requiredFilled: string[] = [];
  426 |   async fillRequired(label: string, index = 0): Promise<string> {
  427 |     await this.expandSearchArea().catch(() => undefined);
  428 |     const core = label.replace(/^\s*\*+\s*|\s*\*+\s*$/g, '').trim(); if (!core) return '항목명 없음';
  429 |     const item = this.page.locator('[class*="_formItem_"], [class*="formItem"]').filter({ has: this.page.locator(':scope > :first-child', { hasText: new RegExp(`^\\s*\\*?\\s*${escapeRe(core)}\\s*\\*?\\s*$`, 'i') }) }).first();
  430 |     if (!(await item.isVisible({ timeout: 3_000 }).catch(() => false))) return `칸 없음(${core})`;
  431 |     const combo = item.locator('[role="combobox"]').first();
  432 |     if (!(await combo.count())) return '콤보 아님(입력값을 만들 근거 없음 — 채우지 않음)';
  433 |     await combo.click({ timeout: 3_000 }).catch(() => undefined);
  434 |     const opts = this.page.locator('.MuiAutocomplete-popper [role="option"], [role="listbox"] [role="option"]');
  435 |     await opts.first().waitFor({ state: 'visible', timeout: 6_000 }).catch(() => undefined);
  436 |     const texts = (await opts.allInnerTexts().catch(() => [] as string[])).map(s => s.replace(/\s+/g, ' ').trim());
  437 |     const cand = texts.map((t, i) => ({ t, i })).filter(x => x.t && !/^\(?(all|전체|select|선택|select all|전체\s*선택|모두\s*선택)\)?$/i.test(x.t));  // 전체 선택 항목 제외(11-06 실측 'SELECT ALL')
  438 |     if (!cand.length) { await this.page.keyboard.press('Escape').catch(() => undefined); return `후보 없음(목록 ${texts.length}개)`; }
  439 |     const pick = cand[Math.min(index, cand.length - 1)];
  440 |     await opts.nth(pick.i).click({ timeout: 3_000 }).catch(() => undefined);
  441 |     await this.page.keyboard.press('Escape').catch(() => undefined); await this.page.waitForTimeout(500);
  442 |     if (!this.requiredFilled.includes(core)) this.requiredFilled.push(core);
  443 |     return `선택 '${pick.t.slice(0, 40)}'(후보 ${cand.length}개 중 ${Math.min(index, cand.length - 1) + 1}번째)`;
  444 |   }
  445 |   async search(opts: { timeout?: number } = {}) {
  446 |     await this.clearDialogs();
  447 |     if (!this.userCondsApplied && Object.keys(this.userConds || {}).length) { this.userCondsApplied = true; await this.applyUserConds(); }
  448 |     const before = this.calls.length;
  449 |     const btn = await this.visibleFirst(this.page.getByRole('button', { name: /^(조회|Search)(\(F5\))?$/ }));
  450 |     const t0 = Date.now();
  451 |     // 메인 조회(call-proc) 응답을 기다린다 — 초기기간 조회(dayRange)는 조회 버튼과 무관하므로 제외.
  452 |     // 2026-10-20: 감시를 클릭 '전에' 걸어 빠른 응답을 놓치지 않는다(실측: 뒤에 걸면 재조회 121s). 조회 버튼이 없는 계정은 F5 도 무동작 → 10s 만
  453 |     const waitSearch = this.page.waitForResponse(r => /call-proc/.test(r.url()) && !/\/dayRange\//i.test(r.url()) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(r.url()), { timeout: btn ? (opts.timeout ?? CFG.searchTimeoutMs) : 10_000 }).catch(() => undefined);
  454 |     // 2026-11-10 T207(SSP0023 G1·G8 허위 FAIL 4건): 조회 버튼 1회에 call-proc 이 여러 개 나가는 화면(SSP0023 main 30~37s + calendar 0.2s)에서
  455 |     //   waitSearch 는 먼저 끝난 calendar 응답으로 풀려 main 응답 전에 빈(로딩 중) 그리드를 읽었다 — 서버는 22행. 클릭 뒤 시작된 조회 call-proc 이 모두 끝날 때까지 기다린다.
  456 |     const pend = new Set<import('@playwright/test').Request>(); const isQ = (u: string) => /call-proc/.test(u) && !/\/dayRange\//i.test(u) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(u);
  457 |     const onReq = (r: import('@playwright/test').Request) => { if (isQ(r.url())) pend.add(r); }; const onDone = (r: import('@playwright/test').Request) => { pend.delete(r); };
  458 |     this.page.on('request', onReq); this.page.on('requestfinished', onDone); this.page.on('requestfailed', onDone);
  459 |     if (btn) await btn.click({ timeout: 10_000 }).catch(() => undefined); else await this.page.keyboard.press('F5');
  460 |     // 2026-11-06 T59(SCP0016): 필수 조회조건이 비어 화면이 '… 필수 입력 항목입니다' 알림으로 조회를 막으면 call-proc 이 안 나가
  461 |     //   응답 대기(searchTimeoutMs 120s)를 다 쓰고 0행으로 끝났다(테스트당 8~15분 · 7시간). 알림을 감시해 그 칸을 화면 콤보 후보로 채우고 재조회한다.
  462 |     let got = false; void waitSearch.then(r => { if (r) got = true; });
  463 |     for (let fill = 0; fill < 4; fill++) {
  464 |       let req = '';
  465 |       for (const t1 = Date.now(); !got && Date.now() - t1 < 12_000;) { const m = await this.alertText().catch(() => ''); if (m && REQUIRED_RX.test(m)) { req = m; break; } await this.page.waitForTimeout(400); }
  466 |       if (!req || got) break;
  467 |       const label = requiredLabelOf(req);
  468 |       await this.clearDialogs();
  469 |       const note = label ? await this.fillRequired(label) : '';
  470 |       this.requiredNotes.push(`${label || '(항목명 해석 불가)'}: ${note || '채우기 실패'} ← '${req.replace(/\s+/g, ' ').slice(0, 60)}'`);
  471 |       console.log(`[required] ${this.requiredNotes[this.requiredNotes.length - 1]}`);
  472 |       if (!note.startsWith('선택')) { this.page.off('request', onReq); this.page.off('requestfinished', onDone); this.page.off('requestfailed', onDone); return this.calls.slice(before); }  // 채우지 못함 — 응답 대기 없이 반환(호출부는 0행 처리)
  473 |       const ws2 = this.page.waitForResponse(r => /call-proc/.test(r.url()) && !/\/dayRange\//i.test(r.url()) && !/\/(SAVE|INS|UPD|DEL)[^/]*\/call-proc/i.test(r.url()), { timeout: opts.timeout ?? CFG.searchTimeoutMs }).catch(() => undefined);
  474 |       void ws2.then(r => { if (r) got = true; });
  475 |       if (btn) await btn.click({ timeout: 10_000 }).catch(() => undefined); else await this.page.keyboard.press('F5');
  476 |       await Promise.race([ws2, this.page.waitForTimeout(12_500)]);
  477 |       if (got) break;
  478 |     }
  479 |     if (!got) await waitSearch;
  480 |     { const lim = opts.timeout ?? CFG.searchTimeoutMs; const t2 = Date.now(); await this.page.waitForTimeout(300); while (pend.size && Date.now() - t2 < lim) await this.page.waitForTimeout(300);
  481 |       if (pend.size) console.log(`[search] 조회 요청 ${pend.size}건이 ${Math.round(lim / 1000)}s 안에 끝나지 않음: ${[...pend].map(r => r.url().replace(/^.*\/api\//, '')).join(', ')}`); }
  482 |     this.page.off('request', onReq); this.page.off('requestfinished', onDone); this.page.off('requestfailed', onDone);
  483 |     await this.page.waitForLoadState('networkidle', { timeout: 8_000 }).catch(() => undefined);
  484 |     const mine = this.calls.slice(before); mine.forEach(c => (c.ms = Date.now() - t0));
  485 |     await applyGridMutations(this.page);  // 조회 직후 그리드 변이 주입(CL_MUTATE 지정 시만)
  486 |     return mine;
```