# SCP0043 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0043_WOCreate\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0043_WOCreate\SCP0043_WOCreate.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0043_WOCreate\SCP0043_WOCreate.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0043_WOCreate\SCP0043_WOCreate.csproj | 519 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0043_WOCreate\SCP0043_WOCreate.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0043_WOCreate\SCP0043_WOCreate.csproj | 930 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboInstance.SelectedIndexChanged | CboInstance_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboPlanID.SelectedIndexChanged | CboPlanID_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:drpPlanDate.ValueChanged | DrpPlanDate_ValueChanged > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 351 | FP.SCP0043_GET_WO_CREATE | MATCH | SP SCP0043_GET_WO_CREATE |
| event:this.Load | Form_Load > InitControls | 109 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 199 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 199 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 202 | biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 202 | biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 203 | biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 211 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 211 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 215 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 215 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 219 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 219 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 223 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 223 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 233 | biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 233 | biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 247 | biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 247 | biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 251 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 251 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 255 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 255 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 259 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 259 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 268 | biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 268 | biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 272 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 272 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 276 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 286 | biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 286 | biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 290 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 290 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 301 | biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 301 | biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtInstance> | 44 | biz:CommonData.CommonDataList_FP [code=INSTANCE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtInstance> | 44 | biz:CommonData.CommonDataList [code=INSTANCE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCurDate> | 52 | biz:CommonData.CommonDataList_FP [code=CURRENT_DATE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCurDate> | 52 | biz:CommonData.CommonDataList [code=CURRENT_DATE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSpdTitle | 135 | biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CURRENT_DATE] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:CommonData.CommonDataList [code=FACTORY] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=INSTANCE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:CommonData.CommonDataList [code=LINE] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:CommonData.CommonDataList [code=OPERATION] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:CommonData.CommonDataList [code=PLAN_ID] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FP_PLAN_H_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:CommonData.CommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:CommonData.CommonDataList [code=SpreadTitle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_COLUMNS |
| biz:CommonData.CommonDataList_FP [code=CURRENT_DATE] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList_FP [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:CommonData.CommonDataList_FP [code=FACTORY] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList_FP [code=INSTANCE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:CommonData.CommonDataList_FP [code=LINE] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:CommonData.CommonDataList_FP [code=OPERATION] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:CommonData.CommonDataList_FP [code=PLAN_ID] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FP_PLAN_H_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:CommonData.CommonDataList_FP [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:CommonData.CommonDataList_FP [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| FP.SCP0043_GET_WO_CREATE | MATCH | 1 | SP SCP0043_GET_WO_CREATE | EXEC:SCP0043_GET_WO_CREATE | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetDayRange | dtFpPlanId.Rows[rowIdx] | PLAN_START_DATE, PLAN_END_DATE |
| SetChangedControl | dtCurDate.Rows[0] | CUR_DATE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:109 | UsrComboBox.DataBind | CODE, NAME |
| SetSheetHeaderColumn | InitSpread:128 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | SetChangedControl:190, SetChangedControl:209, SetChangedControl:213, SetChangedControl:217, SetChangedControl:221, SetChangedControl:225, SetChangedControl:245, SetChangedControl:249 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:79 |
| cboInstance | SelectedIndexChanged | CboInstance_SelectedIndexChanged | InitEvent:145 |
| drpPlanDate | ValueChanged | DrpPlanDate_ValueChanged | InitEvent:146 |
| cboPlanID | SelectedIndexChanged | CboPlanID_SelectedIndexChanged | InitEvent:147 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:148 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:149 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:150 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:151 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:152 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:153 |

## 6. 컨트롤 (37개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 14 | layoutControlItem9, PlanDate, PlanID, layoutControlItem5, layoutControlItem13, layoutControlItem10, layoutControlItem6, layoutControlItem7, Division, layoutControlItem11, layoutControlItem3, layoutControlItem2, layoutControlItem1, layoutControlItem4 |
| UsrCheckedList | 5 | clbDivision, clbLine, clbFactory, clbPlant, clbOperation |
| UsrCombo | 3 | cboSite, cboPlanID, cboInstance |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem1 |
| TextBox | 2 | txtWO, txtItem |
| UsrButton | 1 | usrButton1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl2 |
| UsrDatePicker | 1 | drpPlanDate |
| UsrDateRangePicker | 1 | drpPeriod |
| LayoutControlGroup | 1 | layoutControlGroup2 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrComboBox | 1 | cboValid |
| DateTimePicker | 1 | dateTimePicker1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: W/O Create
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:128
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 786 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 787 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 788 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 789 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
