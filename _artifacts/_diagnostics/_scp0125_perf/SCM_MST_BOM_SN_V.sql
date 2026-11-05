SELECT
/****************************************************************************
  * PROJECT       : PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
  * VIEW NAME     : SCM_MST_BOM_SN_V
  * DESCRIPTION   : SCP 대치 BOM
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-03-08   SDS          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선: SCM_MST_BOM_SN_V VIEW
  *								- 대치 BOM에서 계획 수립 대상은 한 개로 제한
  *************************************************************************** */
       "COMPANY_ID","DIVISION_ID","SITE_ID","PLANT_ID","MODEL_ID","PARENT_ITEM_ID","CHILD_ITEM_ID","CHILD_QTY","CHILD_UOM","ACCUMULATED_CHILD_QTY","CONCATENATE_ITEM","SORT_ORDER","LEAF_LEVEL","NLEVEL","CHILD_COMPANY_ID","CHILD_DIVISION_ID","CHILD_SITE_ID","CHILD_PLANT_ID","ALT_ID","ALT_PRIORITY","ALT_RATE","INSERT_ID","INSERT_TIME","UPDATE_ID","UPDATE_TIME","ATTRIBUTE1","ATTRIBUTE2","ATTRIBUTE3","ATTRIBUTE4","ATTRIBUTE5","ATTRIBUTE6","ATTRIBUTE7","ATTRIBUTE8","ATTRIBUTE9","ATTRIBUTE10","ATTRIBUTE11","ATTRIBUTE12","ATTRIBUTE13","ATTRIBUTE14","ATTRIBUTE15","CONCAT_ALT_PRIORITY","COPY_ALT_PRIORITY","SCP_PLAN_YN","ENG_ALT_ID","ENG_ALT_PRIORITY","ORG_ALT_ID","ORG_ALT_PRIORITY","CHILD_SEQ"
  FROM SCM_MST_MODEL_BOM
 WHERE 1 = 1