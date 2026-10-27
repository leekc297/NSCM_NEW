# AS-IS 액션 대조표 — SCP0027

> 원천: `Doc/asisfacts/screens/SCP0027/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 367행 · 메서드 45 · 종류 DATA_OP 198 · RETURN 41 · GRID_SET 21 · MESSAGE 16 · FLAG 15 · GRID_LOCK 12 · CALL_EXT 11 · UI_PROP 10 · GRID_STYLE 9 · POPUP 6 · LIST_REBIND 5 · GRID_INIT 4 · ENDPOINT 4 · UI_MISC 3 · VALIDATE 3 · GRID_COMBO 3 · COMBO_DATA 2 · GRID_BIND 1 · VALUE_SET 1 · GRID_CLEAR 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 11


## SCP0027_ProjectRoute_Electrode.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1384f5e | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:360 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b2fcac65 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:361 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-242ee70a | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:364 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d330a522 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:368 |  | FLAG | _tbl | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-69c202fa | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:369 |  | FLAG | tblRoute | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-16078ea8 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:370 |  | FLAG | tblAll | ds.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-a5962b83 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:384 | if (bEdit_Mode) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0027_ProjectRoute_Electrode.BeforeFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50db1927 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:351 |  | CALL_EXT | tblRoute.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0027_ProjectRoute_Electrode.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de50e56f | this.btnItemId.Click | SCP0027_ProjectRoute_Electrode.cs:471 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dc8991b0 | this.btnItemId.Click | SCP0027_ProjectRoute_Electrode.cs:473 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e97cb50f | this.btnItemId.Click | SCP0027_ProjectRoute_Electrode.cs:474 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-52bd00a2 | this.btnItemId.Click | SCP0027_ProjectRoute_Electrode.cs:475 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a8bad8b0 | this.btnItemId.Click | SCP0027_ProjectRoute_Electrode.cs:481 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0027_ProjectRoute_Electrode.cboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d11e89d7 | cboOperationGroup.SelectedIndexChanged | SCP0027_ProjectRoute_Electrode.cs:1045 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN0

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33db11fb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1125 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | tblAll.Select | ("ITEM_ID = '" + itemId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e058f164 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1135 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00257", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e0905f99 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1138 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN1

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeaea7f4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1153 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-6288cd91 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1158 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-adeb38e5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1159 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1e084a7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1160 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-401ba6e2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1161 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1d0eb40 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1162 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-21599a71 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1163 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a06cfc70 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1164 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1b8de16 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1166 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-6305de59 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1179 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-8370c5f4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1182 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-91540a1c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1183 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-53100863 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1184 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a14458f4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1185 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-58ede0e2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1186 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-739cde71 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1187 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffd29371 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1210 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00212", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c82efb2b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1213 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN2

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94e7ce83 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1227 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-e00c688a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1232 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-2553bd29 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1233 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-8581e189 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1234 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8fd0232 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1235 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a6b3c52 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1236 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fe73d13 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1237 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-251e16a4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1238 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-a72f548a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1240 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-3562da53 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1250 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-631e3639 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1255 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-b992e1f4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1256 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-83dac41b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1257 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ea7df73 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1258 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab27a86e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1259 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-17f3988e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1260 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5c424e1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1274 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00213", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8dc12f7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1277 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN3

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9d42da0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1290 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc015016 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1293 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a736140 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1294 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-b14aa4ab | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1295 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab78fbea | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1296 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e3e7b1f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1297 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e344895 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1298 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-de177b13 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1299 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c96fac6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1300 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-6002101b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1302 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-d780d3f6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1313 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cf05082 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1316 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a50ec979 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1317 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0ad714f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1318 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-83b41fa7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1319 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3683d782 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1320 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-56605b09 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1321 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfed2efc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1322 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f47e5212 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1336 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00214", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ad8d03d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1339 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN4

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-606e0947 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1353 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2f1df16 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1356 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc9a170b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1357 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb206d30 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1358 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-807d83cb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1359 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e4032b6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1360 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-19c11f47 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1361 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c96ecbb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1362 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae00638c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1363 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-2880641b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1365 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5dbfc0f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1375 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-3296a8d8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1378 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-833ac03a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1379 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-f52dc5a5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1380 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-67f5bd8f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1381 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6905fbfb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1382 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-413b7112 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1383 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-e02eadbb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1384 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef089e0e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1397 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00215", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-464abb9b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1400 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN5

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31703ad1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1416 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-7035c14d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1419 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef517acf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1420 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa33e02c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1421 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fdad9f6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1422 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb7aabe | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1423 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-eae11082 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1424 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-06f07b2a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1425 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-10723aec | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1434 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c9eaa75 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1443 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-4346d49a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1446 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-2286ba53 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1447 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a57aa88 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1448 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8094923 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1449 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdf4654a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1450 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-78614b95 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1451 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-97cca158 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1474 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00216", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34a3a4cb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1477 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN6

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38136803 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1486 | lambda | DATA_OP | row.Field | ("VALID_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-f72f33ed | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1486 | lambda | DATA_OP | row.Field | ("ORG_TO_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-d539e8f8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1492 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fdb7e27 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1495 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cc1c8b6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1498 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbf43b68 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1499 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e95d1c5d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1500 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-47673010 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1501 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d331f196 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1502 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e400694 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1503 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8c1a394 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1505 | for (i < tblValid.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("VALID_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-b52c12a8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1506 | for (i < tblValid.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-761668c8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1507 | for (i < tblValid.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("SCM_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a45f3f45 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1508 | for (i < tblValid.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-30042b36 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1509 | for (i < tblValid.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-106eb0a6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1509 | for (i < tblValid.Rows.Count) ▸ lambda | DATA_OP | row.Field | ("ORG_TO_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-346056aa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1527 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-a49c7876 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1530 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b83d3405 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1531 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-08dfa1be | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1532 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-76af79cb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1533 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-52775f9c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1534 | for (i < tblValid.Rows.Count) ▸ for (j < tblValid.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-19daf32a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1553 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00217", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aef4760d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1557 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN7

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2ba1fb7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1572 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a599b334 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1573 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx1, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-c043bf21 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1585 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8dbc6ef | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1588 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-166aab73 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1592 | for (i < dt.Rows.Count) ▸ if (intPRIORITY < 1) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4397164 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1594 | for (i < dt.Rows.Count) ▸ if (intPRIORITY < 1) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx1, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-5f9c4199 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1599 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b10fb9e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1603 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00107", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55f1b027 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1606 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN8

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7d64eec | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1627 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b507726b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1628 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-cea0b4d0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1639 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6244571 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1642 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd1a187a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1643 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f901077 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1647 | for (i < dt.Rows.Count) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | GRID_STYLE | siMain.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-10d92b01 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1648 | for (i < dt.Rows.Count) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8c03c3e7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1657 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5880f7ad | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1659 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-de659494 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1665 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD < 17530101 \|\| intORG_TO_YYYYMMDD < 17530101) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-407a6cd6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1668 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD < 17530101 \|\| intORG_TO_YYYYMMDD < 17530101) | GRID_STYLE | siMain.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-42b97ec0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1676 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b42b88fe | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1680 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-955fe779 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1684 | else of (!isPass) ▸ if (!isDatePass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048", new object[] { strStartDate + "~" + strEndDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d178330 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1689 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.checkValidN9

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c9922d2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1703 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ACTION_FLAG_DIV) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c8dbbef | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1706 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-777bef93 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1707 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-826ea93e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1708 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c585918 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1709 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b13ca57 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1710 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-535877f3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1711 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-17b5c9a0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1712 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4b62044 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1713 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-b53089c4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1714 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.OPERATION_GROUP) | 데이터 객체 조작/조회 |  |  |  |
| AC-60c7a606 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1716 | for (i < tblValid.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b6c923a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1726 | for (i < tblValid.Rows.Count) ▸ if (OPERATION_GROUP=="E") | DATA_OP | tblValid.Select | ("PRIORITY=1 AND VALID_YN ='Y' AND ORG_FROM_YYYYMMDD='" + ORG_FROM_YYYYMMDD + "' AND ORG_T… | 데이터 객체 조작/조회 |  |  |  |
| AC-3d03c50c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1731 | for (i < tblValid.Rows.Count) ▸ else of (OPERATION_GROUP=="E") | DATA_OP | tblValid.Select | ("PRIORITY=1 AND VALID_YN ='Y' AND ORG_FROM_YYYYMMDD='" + ORG_FROM_YYYYMMDD + "' AND ORG_T… | 데이터 객체 조작/조회 |  |  |  |
| AC-c6588b1a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1747 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00220", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce7671dc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1750 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8faaf20a | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:311 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-43b90bdd | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:312 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0027_ProjectRoute_Electrode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b08a45f3 | this.Load | SCP0027_ProjectRoute_Electrode.cs:330 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-896b7994 | this.Load | SCP0027_ProjectRoute_Electrode.cs:331 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-008951d6 | this.Load | SCP0027_ProjectRoute_Electrode.cs:332 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0027_ProjectRoute_Electrode.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23258c4c | this.Load | SCP0027_ProjectRoute_Electrode.cs:262 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-8992ca9f | this.Load | SCP0027_ProjectRoute_Electrode.cs:264 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f39909d2 | this.Load | SCP0027_ProjectRoute_Electrode.cs:265 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-6616f3c6 | this.Load | SCP0027_ProjectRoute_Electrode.cs:266 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0027_ProjectRoute_Electrode.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54f60f2a | DeleteButton | SCP0027_ProjectRoute_Electrode.cs:415 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0e9e667 | DeleteButton | SCP0027_ProjectRoute_Electrode.cs:420 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0027_ProjectRoute_Electrode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcab1e36 | Dispose | SCP0027_ProjectRoute_Electrode.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0027_ProjectRoute_Electrode.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d96694a3 | EditButton | SCP0027_ProjectRoute_Electrode.cs:430 | if ((tblAll == null) \|\| (tblAll.Rows.Count == 0)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00259") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8172cf8c | EditButton | SCP0027_ProjectRoute_Electrode.cs:431 | if ((tblAll == null) \|\| (tblAll.Rows.Count == 0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a137a2f3 | EditButton | SCP0027_ProjectRoute_Electrode.cs:435 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-59ac565f | EditButton | SCP0027_ProjectRoute_Electrode.cs:439 | if (!bEdit_Mode) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc119b33 | EditButton | SCP0027_ProjectRoute_Electrode.cs:440 | if (!bEdit_Mode) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), siMain.GetColumnIndex(DefColumns.TACT_T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e32e99c | EditButton | SCP0027_ProjectRoute_Electrode.cs:441 | if (!bEdit_Mode) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dd9159e4 | EditButton | SCP0027_ProjectRoute_Electrode.cs:447 | if (!bEdit_Mode) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROU… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PRIORITY), i, siMain.GetColumnIndex(DefColumns.TO_YYY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-422cac42 | EditButton | SCP0027_ProjectRoute_Electrode.cs:448 | if (!bEdit_Mode) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROU… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), i, siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5466b46f | EditButton | SCP0027_ProjectRoute_Electrode.cs:454 | if (!bEdit_Mode) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ else of (siMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.OPERATION… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), i, siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금/해제 |  |  |  |
| AC-43481812 | EditButton | SCP0027_ProjectRoute_Electrode.cs:460 |  | FLAG | bEdit_Mode | !bEdit_Mode | 화면 필드/플래그 변경 |  |  |  |

## SCP0027_ProjectRoute_Electrode.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2118ed93 | FindButton | SCP0027_ProjectRoute_Electrode.cs:391 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-74b43ef9 | FindButton | SCP0027_ProjectRoute_Electrode.cs:392 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.FindDataMain

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba6d1eec | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:492 | if (this.QueryDics[DIC_PROJECT_ROUTE_ELECTRODE].Count > 0) | CALL_EXT | this.QueryDics[DIC_PROJECT_ROUTE_ELECTRODE].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e3e9f8f | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:497 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-798ef77d | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:498 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-ff02baaf | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:499 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-78213d2e | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:500 |  | UI_PROP | qi.QueryId | "SCP.SCP0027_GET_ProjectRoute_Electrode" | 속성 QueryId 설정 |  |  |  |
| AC-8d4357a0 | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:502 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-645afbb8 | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:503 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_site", this._plant_site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6831096e | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:504 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_group", this._operation_group)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d944ac7 | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:505 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4583be2 | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:506 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymm", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f1d6872 | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:507 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymm", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-35d19899 | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:508 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_valid_flag", this._valid)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7767da06 | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:511 |  | DATA_OP | this.QueryDics[DIC_PROJECT_ROUTE_ELECTRODE] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-cbfed59d | FindButton 외 1 | SCP0027_ProjectRoute_Electrode.cs:514 |  | ENDPOINT | this.ExecuteSQL | (siMain, DIC_PROJECT_ROUTE_ELECTRODE, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0027_ProjectRoute_Electrode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d9a64b | this.Load | SCP0027_ProjectRoute_Electrode.cs:248 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0027_ProjectRoute_Electrode.getCellValue

진입점: dsdm.Changed / spdMain.CellClick [if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ else of (division.Equals("") \|\| division.Length == 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e16dd3a9 | dsdm.Changed 외 2 | SCP0027_ProjectRoute_Electrode.cs:143 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb6b14c7 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:46 |  | RETURN | return CString.GetCheckedListValue(dtMyDivision, clbDivision.ControlValues, true… |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4aeab303 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:88 |  | RETURN | return txtItemId.Text.Trim(); |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.getOperationGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef258407 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:74 |  | RETURN | return CString.GetCheckedListValue(dtOperationGroup, cboOperationGroup.ControlVa… |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.getPlantSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-695bb479 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:60 |  | RETURN | return CString.GetCheckedListValue(dtPlantSite, clbPlantSite.ControlValues, true… |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.getValid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17ca3345 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:116 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c42fb1c | this.Load | SCP0027_ProjectRoute_Electrode.cs:280 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-29b925ee | this.Load | SCP0027_ProjectRoute_Electrode.cs:283 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-fdc3856b | this.Load | SCP0027_ProjectRoute_Electrode.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-571d6db2 | this.Load | SCP0027_ProjectRoute_Electrode.cs:287 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-7ac7c802 | this.Load | SCP0027_ProjectRoute_Electrode.cs:289 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-ede2eae4 | this.Load | SCP0027_ProjectRoute_Electrode.cs:289 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2925321 | this.Load | SCP0027_ProjectRoute_Electrode.cs:290 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0027_ProjectRoute_Electrode.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54e0c2f4 | this.Load | SCP0027_ProjectRoute_Electrode.cs:273 |  | FLAG | dsdm | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Dat… | 화면 필드/플래그 변경 |  |  |  |

## SCP0027_ProjectRoute_Electrode.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87ae9078 | this.Load | SCP0027_ProjectRoute_Electrode.cs:243 |  | DATA_OP | QueryDics.Add | (DIC_PROJECT_ROUTE_ELECTRODE, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0027_ProjectRoute_Electrode.InitSpread

진입점: this.Load / cboOperationGroup.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19496c57 | this.Load 외 2 | SCP0027_ProjectRoute_Electrode.cs:339 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5170c2be | this.Load 외 2 | SCP0027_ProjectRoute_Electrode.cs:340 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0027_ProjectRoute_Electrode.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c1d167c | InsertButton | SCP0027_ProjectRoute_Electrode.cs:549 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (pValid.ToString()=="P" \|\… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd6a0ec8 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:551 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-54108d0e | InsertButton | SCP0027_ProjectRoute_Electrode.cs:554 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8a5f1725 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:565 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-387fedbd | InsertButton | SCP0027_ProjectRoute_Electrode.cs:566 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-53bb37c2 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:567 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_GROUP, "E") | 데이터 객체 조작/조회 |  |  |  |
| AC-a91bf356 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:568 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.SCM_SITE_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e186e0b8 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:569 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5f0489c | InsertButton | SCP0027_ProjectRoute_Electrode.cs:570 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.OPERATION_GROUP_NAME, "Electrode") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ad1cc8b | InsertButton | SCP0027_ProjectRoute_Electrode.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-41f2410a | InsertButton | SCP0027_ProjectRoute_Electrode.cs:576 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7995c906 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:578 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.NI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ab68d83 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_NAME), siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2481ba03 | InsertButton | SCP0027_ProjectRoute_Electrode.cs:580 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0027_ProjectRoute_Electrode.RefreshPlantSiteForSpread

진입점: dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ if (drs.Length != 0) ▸ if (division != "")] / spdMain.CellClick [if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ else of (division.Equals("") \|\| division.Length == 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62b4a14c | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… 외 2 | SCP0027_ProjectRoute_Electrode.cs:784 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefColumns.DIVISION_ID, DefColumns.ITEM_ID, "OPERATION_GROUP" } , ne… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0246842 | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… 외 2 | SCP0027_ProjectRoute_Electrode.cs:788 | if (division == "" \|\| item_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2666c99b | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… 외 2 | SCP0027_ProjectRoute_Electrode.cs:791 |  | FLAG | dtPlantSiteForSpread | DBUtils.Filter(dtPlantSiteForSpreadAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ca51cd3 | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… 외 2 | SCP0027_ProjectRoute_Electrode.cs:791 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteForSpreadAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6fc028ef | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… 외 2 | SCP0027_ProjectRoute_Electrode.cs:792 |  | GRID_COMBO | siMain.SetCellTypeCombo | (row, col, dtPlantSiteForSpread) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0027_ProjectRoute_Electrode.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6512a81 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:619 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-35607117 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:619 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c2be9d0 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:628 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a936831 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bfa4e7a4 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:630 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN1()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2cfeedd | SaveButton | SCP0027_ProjectRoute_Electrode.cs:631 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN2()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac85742e | SaveButton | SCP0027_ProjectRoute_Electrode.cs:632 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN3()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25da09fd | SaveButton | SCP0027_ProjectRoute_Electrode.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN4()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97709e9d | SaveButton | SCP0027_ProjectRoute_Electrode.cs:634 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN5()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86e55373 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN6()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32423f8c | SaveButton | SCP0027_ProjectRoute_Electrode.cs:636 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN7(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2229f9aa | SaveButton | SCP0027_ProjectRoute_Electrode.cs:637 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7be72165 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:638 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN9()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-309d648d | SaveButton | SCP0027_ProjectRoute_Electrode.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0027_SAVE_PROJECTROUTE_ELECTRODE") ⇒ SCP.SCP0027_SAVE_PROJECTROUTE_ELECTRODE | 엔드포인트 요청 생성 |  |  |  |
| AC-dfaddb20 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:702 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6da8158d | SaveButton | SCP0027_ProjectRoute_Electrode.cs:707 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9c22abc7 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f57c52cd | SaveButton | SCP0027_ProjectRoute_Electrode.cs:710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_priority_seq"] | p_priority_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e3ead6af | SaveButton | SCP0027_ProjectRoute_Electrode.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-35edc9e5 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:712 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-5e3a5332 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:713 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b0aaac8 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:714 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-0333b1b0 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:715 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a85a0269 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:716 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-206ae1ba | SaveButton | SCP0027_ProjectRoute_Electrode.cs:717 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-aa3f6e99 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-642da18e | SaveButton | SCP0027_ProjectRoute_Electrode.cs:719 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-a723be73 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-f8c0684f | SaveButton | SCP0027_ProjectRoute_Electrode.cs:721 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-5dadb82b | SaveButton | SCP0027_ProjectRoute_Electrode.cs:722 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-5abdee22 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:723 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-05d53b2e | SaveButton | SCP0027_ProjectRoute_Electrode.cs:725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-925397a5 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-b887e560 | SaveButton | SCP0027_ProjectRoute_Electrode.cs:735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bce9d00c | SaveButton | SCP0027_ProjectRoute_Electrode.cs:744 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0027_ProjectRoute_Electrode.set_ValidDataSet

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cbe7280 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1060 |  | FLAG | tblValid | null | 화면 필드/플래그 변경 |  |  |  |
| AC-56d99e47 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1061 |  | FLAG | tblValid | tblRoute.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-718b2d90 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1061 |  | DATA_OP | tblRoute.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d5ab687 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1076 | for (i < dt.Rows.Count) ▸ if (action == CAppSetting.FlagM) | DATA_OP | dr.Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-004c558b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1078 | for (i < dt.Rows.Count) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(PRIORITY_SEQ) && orgValidYn=="Y") | DATA_OP | tblValid.Rows.Remove | (tblValid.Select("PRIORITY_SEQ = '" + PRIORITY_SEQ + "'")[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-925db12b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1078 | for (i < dt.Rows.Count) ▸ if (action == CAppSetting.FlagM) ▸ if (!String.IsNullOrEmpty(PRIORITY_SEQ) && orgValidYn=="Y") | DATA_OP | tblValid.Select | ("PRIORITY_SEQ = '" + PRIORITY_SEQ + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc496f23 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1081 | for (i < dt.Rows.Count) | DATA_OP | tblValid.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55a2305e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1083 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ORG_FROM_YYYYMMDD] | dt.Rows[i].Field<string>(DefColumns.ORG_FROM_YYYYMMDD) | 행/컬럼 값 대입 |  |  |  |
| AC-707e46dc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1083 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a6530d4 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1084 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ORG_TO_YYYYMMDD] | dt.Rows[i].Field<string>(DefColumns.ORG_TO_YYYYMMDD) | 행/컬럼 값 대입 |  |  |  |
| AC-7eeb48a0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1084 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee27db7f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1085 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.DIVISION_ID] | dt.Rows[i].Field<string>(DefColumns.DIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-a393aecd | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1085 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cc7349b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1086 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PRIORITY] | dt.Rows[i].Field<Int32>(DefColumns.PRIORITY) | 행/컬럼 값 대입 |  |  |  |
| AC-f6ccee6f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1086 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e23ad6e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1087 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PLANT_SITE_ID_B) | 데이터 객체 조작/조회 |  |  |  |
| AC-210c35de | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1089 | for (i < dt.Rows.Count) ▸ if (plantId==null \|\| plantId=="") | DATA_OP | dt.Rows[i].Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d96b3c6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1092 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PLANT_SITE_ID] | plantId | 행/컬럼 값 대입 |  |  |  |
| AC-30fdf496 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1093 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.SCM_SITE_ID] | dt.Rows[i].Field<string>(DefColumns.SCM_SITE_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-fa55c1d2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1093 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.SCM_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4010dd84 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1094 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PROJECT_CODE] | dt.Rows[i].Field<string>(DefColumns.PROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-84325ead | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1094 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-4979b55f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1095 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ITEM_ID] | dt.Rows[i].Field<string>(DefColumns.ITEM_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-1a13bbdb | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1095 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9ed4bd8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1096 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.PRIORITY_SEQ] | dt.Rows[i].Field<string>(DefColumns.PRIORITY_SEQ) | 행/컬럼 값 대입 |  |  |  |
| AC-2e35f521 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1096 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.PRIORITY_SEQ) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5196cf8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1097 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.VALID_YN] | dt.Rows[i].Field<string>(DefColumns.VALID_YN) | 행/컬럼 값 대입 |  |  |  |
| AC-3bacf70a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1097 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e21a0e5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1098 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.OPERATION_GROUP] | dt.Rows[i].Field<string>(DefColumns.OPERATION_GROUP) | 행/컬럼 값 대입 |  |  |  |
| AC-28977f52 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1098 | for (i < dt.Rows.Count) | DATA_OP | dt.Rows[i].Field | (DefColumns.OPERATION_GROUP) | 데이터 객체 조작/조회 |  |  |  |
| AC-4530a602 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1099 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ACTION_FLAG_DIV] | action | 행/컬럼 값 대입 |  |  |  |
| AC-f2ce3015 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1100 | for (i < dt.Rows.Count) | DATA_OP | newDr[DefColumns.ROW_COLOR_INDEX] | i | 행/컬럼 값 대입 |  |  |  |
| AC-300184ee | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1102 | for (i < dt.Rows.Count) | DATA_OP | tblValid.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f6e482a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0027_ProjectRoute_Electrode.cs:1105 |  | DATA_OP | tblValid.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0027_ProjectRoute_Electrode.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cfbf6cf | this.Load 외 1 | SCP0027_ProjectRoute_Electrode.cs:318 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefColumns.DIVISION_ID } , new List<string>() { _division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-826e86e7 | this.Load 외 1 | SCP0027_ProjectRoute_Electrode.cs:320 |  | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-dad79d80 | this.Load 외 1 | SCP0027_ProjectRoute_Electrode.cs:320 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5baf364a | this.Load 외 1 | SCP0027_ProjectRoute_Electrode.cs:322 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b05b7089 | this.Load 외 1 | SCP0027_ProjectRoute_Electrode.cs:324 |  | FLAG | dtPlantSiteForSpread | DBUtils.Filter(dtPlantSiteForSpreadAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8df3573e | this.Load 외 1 | SCP0027_ProjectRoute_Electrode.cs:324 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteForSpreadAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0027_ProjectRoute_Electrode.SetChangedPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c30a22b | this.Load | SCP0027_ProjectRoute_Electrode.cs:528 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-952205d0 | this.Load | SCP0027_ProjectRoute_Electrode.cs:531 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0027_ProjectRoute_Electrode.SetImageCell

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b6fcc92 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | SCP0027_ProjectRoute_Electrode.cs:768 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0027_ProjectRoute_Electrode.SetOrgData

진입점: dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD) \|\| e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1911cbcd | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… | SCP0027_ProjectRoute_Electrode.cs:1006 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_FROM_YYYYMMDD] | strFROM_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-5a373571 | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… | SCP0027_ProjectRoute_Electrode.cs:1007 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_TO_YYYYMMDD] | strTO_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-2a0069fc | dsdm.Changed [if (e.Column == siMain.GetColumnIndex(DefColum… | SCP0027_ProjectRoute_Electrode.cs:1009 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0027_ProjectRoute_Electrode.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87f631cf | spdMain.CellClick | SCP0027_ProjectRoute_Electrode.cs:1019 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-96ab78ba | spdMain.CellClick | SCP0027_ProjectRoute_Electrode.cs:1026 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, new DataTable()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c7a5b142 | spdMain.CellClick | SCP0027_ProjectRoute_Electrode.cs:1028 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ccc0be7b | spdMain.CellClick | SCP0027_ProjectRoute_Electrode.cs:1033 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].CellType | cb | 그리드 속성/값 설정 |  |  |  |

## SCP0027_ProjectRoute_Electrode.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa203d20 | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:833 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acbaa23b | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:847 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) | POPUP | new SCM0002_ElectrodeItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4ca758da | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:848 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) | POPUP | popItem.Form_Load | (division) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6829a5f8 | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:849 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-188b65eb | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:850 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-17a7abae | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:855 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-d3c41dc7 | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:856 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), divisionId) | 그리드 값 설정 |  |  |  |
| AC-c5fd9bf1 | spdMain.CellDoubleClick | SCP0027_ProjectRoute_Electrode.cs:857 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && action == CAppSetting.FlagI) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), divisionId) | 그리드 값 설정 |  |  |  |

## SCP0027_ProjectRoute_Electrode.spdMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21fb8eda | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:873 | if (_tbl == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a14fd4e9 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:876 | if (siMain.ActiveSheet.DataSource == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-491b11c0 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:879 | if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee953858 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:905 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa7ebb8b | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:909 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && !siMain.IsLock(SpdSheet.shtMain) && !siMain.IsLockCell(e.Ro… | MESSAGE | MessageHelper.GMessageBox | ("MSG00211", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5bc8f298 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:910 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && !siMain.IsLock(SpdSheet.shtMain) && !siMain.IsLockCell(e.Ro… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.VALID_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-0817e45d | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:911 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && !siMain.IsLock(SpdSheet.shtMain) && !siMain.IsLockCell(e.Ro… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-2acd4e53 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:912 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && !siMain.IsLock(SpdSheet.shtMain) && !siMain.IsLockCell(e.Ro… | GRID_STYLE | siMain.SetBGColor | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), e.Row, siMain.GetColumnIndex(CApp… | 그리드 표시 설정 |  |  |  |
| AC-a07b0106 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:914 | if (e.Column == siMain.GetColumnIndex(DefColumns.VALID_YN)) ▸ if (fps != null && !siMain.IsLock(SpdSheet.shtMain) && !siMain.IsLockCell(e.Ro… | GRID_STYLE | siMain.SetForeColor | (e.Row, siMain.GetColumnIndex(DefColumns.VALID_YN), e.Row, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-94ccfc1a | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:923 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5eb58d1b | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:930 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (null == item_id \|\| "" == item_id) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-1fa6852d | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:934 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) | DATA_OP | tblAll.Select | ("ITEM_ID = '" + item_id + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-29ddaac0 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:939 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ if (drs.Length != 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), strNick_Name) | 그리드 값 설정 |  |  |  |
| AC-2552fd9d | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:945 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ if (drs.Length != 0) ▸ if (divis… | DATA_OP | dtPlantSiteForSpread.Select | ("CODE = '" + plant_site + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1762a418 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:949 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ if (drs.Length != 0) ▸ if (divis… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), plant_site) | 그리드 값 설정 |  |  |  |
| AC-b2f69ef1 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:953 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ if (drs.Length != 0) ▸ if (divis… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), plant_site.Substring(plant_site.… | 그리드 값 설정 |  |  |  |
| AC-80a33ccd | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:958 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ if (drs.Length != 0) ▸ if (divis… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-82888aec | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:959 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ if (drs.Length != 0) ▸ if (divis… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c8eb8e71 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:966 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ else of (drs.Length != 0) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-167ad642 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:967 | if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of (null == item_id \|\| "" == item_id) ▸ else of (drs.Length != 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c93712a6 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:976 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (plant_site == "" && priority == "0" && from_yyyymmdd == "" && to_yyyy… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-16df73d8 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:977 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (plant_site == "" && priority == "0" && from_yyyymmdd == "" && to_yyyy… | GRID_STYLE | siMain.SetBGColor | (e.Row, siMain.GetColumnIndex(CAppSetting.StringAction), e.Row, siMain.GetColumnIndex(CApp… | 그리드 표시 설정 |  |  |  |
| AC-70f2a3a0 | dsdm.Changed | SCP0027_ProjectRoute_Electrode.cs:986 | if (e.Column == siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)) ▸ if (division != "" && item_id != "") ▸ if (plant_site != "") | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TACT_TIME_FLAG), plant_site.Substring(plant_site.… | 그리드 값 설정 |  |  |  |

## SCP0027_ProjectRoute_Electrode.SpdMain_ClipboardPasted

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9ec9e2a | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:800 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d163426 | (진입점 미연결) | SCP0027_ProjectRoute_Electrode.cs:803 | if (siMain.IsLock(siMain.SheetName) == true \|\| siMain.GetText(e.CellRange.Row, siMain.GetColumnIndex(CAppSetting.StringActio…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

