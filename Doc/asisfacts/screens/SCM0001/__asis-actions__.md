# AS-IS 액션 대조표 — SCM0001

> 원천: `Doc/asisfacts/screens/SCM0001/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 79행 · 메서드 19 · 종류 ENDPOINT 16 · FLAG 14 · LIST_REBIND 13 · RETURN 12 · DATA_OP 10 · POPUP 8 · UI_PROP 4 · UI_MISC 2 · ⚠ 의미 확인 필요 0


## SCM0001_CommonListBox.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d18adce | Dispose | SCM0001_CommonListBox.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0001_CommonListBox.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3632ea68 | this.Load | SCM0001_CommonListBox.cs:33 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0001_CommonListBox.Get_Building_Data

진입점: this.usrCheckedList6.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-017b2516 | this.usrCheckedList6.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:221 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BUILDING_BY_PLANT") ⇒ SCM.SCM0001_GET_BUILDING_BY_PLANT | 엔드포인트 요청 생성 |  |  |  |
| AC-fac54995 | this.usrCheckedList6.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:222 |  | DATA_OP | request.Parameters["p_plant_id"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-a6d8135f | this.usrCheckedList6.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:223 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5df90e7 | this.usrCheckedList6.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:225 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.Get_Division_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d3dd898 | this.Load | SCM0001_CommonListBox.cs:151 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-332dae53 | this.Load | SCM0001_CommonListBox.cs:152 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ba14479 | this.Load | SCM0001_CommonListBox.cs:154 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.Get_FromSite_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bcad1e0 | this.Load | SCM0001_CommonListBox.cs:164 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_FROM_SITE") ⇒ SCM.SCM0001_GET_FROM_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-9d051bf3 | this.Load | SCM0001_CommonListBox.cs:165 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-37f8d326 | this.Load | SCM0001_CommonListBox.cs:167 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.Get_Line_Data

진입점: this.usrCheckedList8.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90b270b5 | this.usrCheckedList8.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:251 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LINE_BY_OPERATION") ⇒ SCM.SCM0001_GET_LINE_BY_OPERATION | 엔드포인트 요청 생성 |  |  |  |
| AC-68921afc | this.usrCheckedList8.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:252 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-8335904b | this.usrCheckedList8.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:253 |  | DATA_OP | request.Parameters["p_plant_site_id"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-f8c2cc67 | this.usrCheckedList8.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:254 |  | DATA_OP | request.Parameters["p_factory_id"] | sBuilding | 행/컬럼 값 대입 |  |  |  |
| AC-bd815c3b | this.usrCheckedList8.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:255 |  | DATA_OP | request.Parameters["p_operation_id"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-006ea7e1 | this.usrCheckedList8.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:256 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-166a4bdf | this.usrCheckedList8.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:258 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.Get_Operation_Data

진입점: this.usrCheckedList7.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be2476de | this.usrCheckedList7.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:235 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_OPERATION_BY_BUILDING") ⇒ SCM.SCM0001_GET_OPERATION_BY_BUILDING | 엔드포인트 요청 생성 |  |  |  |
| AC-533ca397 | this.usrCheckedList7.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:236 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-3bf6d645 | this.usrCheckedList7.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:237 |  | DATA_OP | request.Parameters["p_plant_site_id"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-3f5af614 | this.usrCheckedList7.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:238 |  | DATA_OP | request.Parameters["p_factory_id"] | sBuilding | 행/컬럼 값 대입 |  |  |  |
| AC-32d48285 | this.usrCheckedList7.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:239 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-50dca7ad | this.usrCheckedList7.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:241 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.Get_Plant_Data

진입점: this.usrCheckedList3.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fa9ee4f | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:207 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c6776fef | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:208 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-4f4e37e9 | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:209 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba5d89ff | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:211 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.Get_Site_By_Division_Data

진입점: this.usrCheckedList3.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56433b78 | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:193 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-803ec6cf | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:194 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-5e9e1f7f | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:195 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb518831 | this.usrCheckedList3.SelectedIndexChanged 외 1 | SCM0001_CommonListBox.cs:197 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.Get_ToSite_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee039c3f | this.Load | SCM0001_CommonListBox.cs:177 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TO_SITE") ⇒ SCM.SCM0001_GET_TO_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-c8d45fa6 | this.Load | SCM0001_CommonListBox.cs:178 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f66af270 | this.Load | SCM0001_CommonListBox.cs:180 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.List_SetUp

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-923ef756 | this.Load | SCM0001_CommonListBox.cs:106 |  | FLAG | clsCtrl | new CControl() | 화면 필드/플래그 변경 |  |  |  |
| AC-608caa98 | this.Load | SCM0001_CommonListBox.cs:114 |  | FLAG | dtDivision | Get_Division_Data() | 화면 필드/플래그 변경 |  |  |  |
| AC-bb480b8a | this.Load | SCM0001_CommonListBox.cs:115 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, usrCheckedList3, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b53c859 | this.Load | SCM0001_CommonListBox.cs:118 |  | FLAG | dtFromSite | Get_FromSite_Data() | 화면 필드/플래그 변경 |  |  |  |
| AC-58611017 | this.Load | SCM0001_CommonListBox.cs:119 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, usrCheckedList4, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c646b1e3 | this.Load | SCM0001_CommonListBox.cs:122 |  | FLAG | dtToSite | Get_ToSite_Data() | 화면 필드/플래그 변경 |  |  |  |
| AC-2eb5934e | this.Load | SCM0001_CommonListBox.cs:123 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, usrCheckedList5, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-28be1973 | this.Load | SCM0001_CommonListBox.cs:126 |  | FLAG | dtSiteByDivision | Get_Site_By_Division_Data(division) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0fba20d | this.Load | SCM0001_CommonListBox.cs:127 |  | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, usrCheckedList10, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bc45c77d | this.Load | SCM0001_CommonListBox.cs:130 |  | FLAG | dtPlant | Get_Plant_Data(division) | 화면 필드/플래그 변경 |  |  |  |
| AC-36eb437d | this.Load | SCM0001_CommonListBox.cs:131 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, usrCheckedList6, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-79d191cb | this.Load | SCM0001_CommonListBox.cs:134 |  | FLAG | dtBuilding | Get_Building_Data(sPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-92418b7e | this.Load | SCM0001_CommonListBox.cs:135 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, usrCheckedList7, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-72a1434d | this.Load | SCM0001_CommonListBox.cs:138 |  | FLAG | dtOpertation | Get_Operation_Data(division, sPlant, sBuilding) | 화면 필드/플래그 변경 |  |  |  |
| AC-30ab2d51 | this.Load | SCM0001_CommonListBox.cs:139 |  | LIST_REBIND | clsCtrl.setListBox | (dtOpertation, usrCheckedList8, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e7b13d96 | this.Load | SCM0001_CommonListBox.cs:142 |  | FLAG | dtLine | Get_Line_Data(division, sPlant, sBuilding, sOperation) | 화면 필드/플래그 변경 |  |  |  |
| AC-6852d55f | this.Load | SCM0001_CommonListBox.cs:143 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, usrCheckedList9, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0001_CommonListBox.RunColumnShow

진입점: this.Column.Click / this.button2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1223ed0f | this.Column.Click 외 1 | SCM0001_CommonListBox.cs:47 |  | POPUP | new SCM0002_TitleSetForm_Popup | (programID, sheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-6e80031c | this.Column.Click 외 1 | SCM0001_CommonListBox.cs:48 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5c1aca25 | this.Column.Click 외 1 | SCM0001_CommonListBox.cs:49 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c44bece7 | this.Column.Click 외 1 | SCM0001_CommonListBox.cs:49 |  | RETURN | return frm.ShowDialog(); |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.RunCustomerShow

진입점: this.button3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a33dca4 | this.button3.Click | SCM0001_CommonListBox.cs:69 |  | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-21dbc78c | this.button3.Click | SCM0001_CommonListBox.cs:70 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3d33b6de | this.button3.Click | SCM0001_CommonListBox.cs:71 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-619b1586 | this.button3.Click | SCM0001_CommonListBox.cs:71 |  | RETURN | return frm.ShowDialog(); |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.RunMeasureShow

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5d40a42 | this.button1.Click | SCM0001_CommonListBox.cs:53 |  | POPUP | new SCM0002_TitleSetForm_Popup | (programID, sheetName, false) | 팝업/폼 생성 |  |  |  |
| AC-44d1eef8 | this.button1.Click | SCM0001_CommonListBox.cs:54 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed04759c | this.button1.Click | SCM0001_CommonListBox.cs:55 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-72d8c1e1 | this.button1.Click | SCM0001_CommonListBox.cs:55 |  | RETURN | return frm.ShowDialog(); |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.RunProjectShow

진입점: this.button4.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-858c63c3 | this.button4.Click | SCM0001_CommonListBox.cs:80 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f8522db8 | this.button4.Click | SCM0001_CommonListBox.cs:81 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-64cc0e00 | this.button4.Click | SCM0001_CommonListBox.cs:82 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7049fc9d | this.button4.Click | SCM0001_CommonListBox.cs:82 |  | RETURN | return frm.ShowDialog(); |  | 처리 중단/반환 |  |  |  |

## SCM0001_CommonListBox.sBuilding_SelectedIndexChanged

진입점: this.usrCheckedList7.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0797161 | this.usrCheckedList7.SelectedIndexChanged | SCM0001_CommonListBox.cs:292 |  | FLAG | dtOpertation | Get_Operation_Data(division,sPlant,sBuilding) | 화면 필드/플래그 변경 |  |  |  |
| AC-01bf722e | this.usrCheckedList7.SelectedIndexChanged | SCM0001_CommonListBox.cs:293 |  | LIST_REBIND | clsCtrl.setListBox | (dtOpertation, usrCheckedList8, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0001_CommonListBox.sDivision_SelectedIndexChanged

진입점: this.usrCheckedList3.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-798cde9b | this.usrCheckedList3.SelectedIndexChanged | SCM0001_CommonListBox.cs:270 |  | FLAG | dtSiteByDivision | Get_Site_By_Division_Data(division) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0f937a8 | this.usrCheckedList3.SelectedIndexChanged | SCM0001_CommonListBox.cs:271 |  | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, usrCheckedList10, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02e8c104 | this.usrCheckedList3.SelectedIndexChanged | SCM0001_CommonListBox.cs:274 |  | FLAG | dtPlant | Get_Plant_Data(division) | 화면 필드/플래그 변경 |  |  |  |
| AC-041519d3 | this.usrCheckedList3.SelectedIndexChanged | SCM0001_CommonListBox.cs:275 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, usrCheckedList6, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0001_CommonListBox.sOperation_SelectedIndexChanged

진입점: this.usrCheckedList8.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02fe3502 | this.usrCheckedList8.SelectedIndexChanged | SCM0001_CommonListBox.cs:303 |  | FLAG | dtLine | Get_Line_Data(division, sPlant, sBuilding, sOperation) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf2ecf9d | this.usrCheckedList8.SelectedIndexChanged | SCM0001_CommonListBox.cs:304 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, usrCheckedList9, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0001_CommonListBox.sPlant_SelectedIndexChanged

진입점: this.usrCheckedList6.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42385592 | this.usrCheckedList6.SelectedIndexChanged | SCM0001_CommonListBox.cs:282 |  | FLAG | dtBuilding | Get_Building_Data(sPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac27996e | this.usrCheckedList6.SelectedIndexChanged | SCM0001_CommonListBox.cs:283 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, usrCheckedList7, true) | 목록 컨트롤 재구성 |  |  |  |

