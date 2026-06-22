-- ============================================================
-- SYS0013 — TYPE objects (FN_DQ_* + T_DQ_* / table function row/tab)
-- 실행 계정: SCM_MGR
-- ============================================================

-- ===== FN_DQ_PROD_PLAN_ROW =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."FN_DQ_PROD_PLAN_ROW" AS OBJECT

(

     DIVISION_ID     VARCHAR2(30 CHAR)

    ,OPERATION_GROUP VARCHAR2(10 CHAR)

    ,SCM_SITE_ID     VARCHAR2(30 CHAR)

    ,PLANT_NAME      VARCHAR2(30 CHAR)

    ,LINE_ID         VARCHAR2(30 CHAR)

    ,ITEM_ID_PROD    VARCHAR2(30 CHAR)

    ,ITEM_ID         VARCHAR2(30 CHAR)

    ,NICK_NAME       VARCHAR2(100 CHAR)

    ,MEASURE         VARCHAR2(100 CHAR)

    ,YYYYPW          VARCHAR2(30 CHAR)

    ,QTY             NUMBER(30,3)        -- KCell ?⑥쐞濡??뚯닔??3?먮━源뚯? ?쒖떆 ?붿껌

);


------------------------------------------------------------------------------------------------------

-- 諛섑솚 而щ젆??Table) ???------------------------------------------------------------------------------------------------------
/

-- ===== FN_DQ_PROD_PLAN_TAB =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."FN_DQ_PROD_PLAN_TAB" AS TABLE OF FN_DQ_PROD_PLAN_ROW;


------------------------------------------------------------------------------------------------------

-- 蹂??⑥닔

------------------------------------------------------------------------------------------------------
/

-- ===== FN_DQ_STOCK_ROW =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."FN_DQ_STOCK_ROW" AS OBJECT
(
  CUTOFF_DATE      VARCHAR2(32 CHAR),
  DIVISION_ID      VARCHAR2(120 CHAR),
  SCM_SITE_ID      VARCHAR2(120 CHAR),
  NICK_NAME        VARCHAR2(200 CHAR),
  OPERATION_GROUP  VARCHAR2(40 CHAR),
  ITEM_ID          VARCHAR2(200 CHAR),
  FACTORY_ID       VARCHAR2(240 CHAR),
  OPERATION_ID     VARCHAR2(120 CHAR),
  OPERATION_NAME   VARCHAR2(600 CHAR),
  WIPHOLD_YN       VARCHAR2(4 CHAR),
  ITEM_UOM         VARCHAR2(40 CHAR),
  SCM_QTY          NUMBER,
  CELL_CONVERSION  NUMBER,
  KCELL            NUMBER
);
/

-- ===== FN_DQ_STOCK_TAB =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."FN_DQ_STOCK_TAB" AS TABLE OF FN_DQ_STOCK_ROW
/

-- ===== T_DQ_STOCK_ROW =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."T_DQ_STOCK_ROW" AS OBJECT
(
  CUTOFF_DATE      VARCHAR2(32 CHAR),
  DIVISION_ID      VARCHAR2(120 CHAR),
  SCM_SITE_ID      VARCHAR2(120 CHAR),
  NICK_NAME        VARCHAR2(200 CHAR),
  OPERATION_GROUP  VARCHAR2(40 CHAR),
  ITEM_ID          VARCHAR2(200 CHAR),
  FACTORY_ID       VARCHAR2(240 CHAR),
  OPERATION_ID     VARCHAR2(120 CHAR),
  OPERATION_NAME   VARCHAR2(600 CHAR),
  WIPHOLD_YN       VARCHAR2(4 CHAR),
  ITEM_UOM         VARCHAR2(40 CHAR),
  SCM_QTY          NUMBER,
  CELL_CONVERSION  NUMBER,
  KCELL            NUMBER
);
/

-- ===== T_DQ_STOCK_TAB =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."T_DQ_STOCK_TAB" AS TABLE OF T_DQ_STOCK_ROW;
/

-- ===== T_FN_DQ_MKT_FCST_81_ROW =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."T_FN_DQ_MKT_FCST_81_ROW" AS OBJECT
(
    DIVISION_ID             VARCHAR2(1000 CHAR),
    VERSION                 VARCHAR2(4000 CHAR),
    PROJECT_CODE            VARCHAR2(4000 CHAR),
    FCST_TYPE               VARCHAR2(4000 CHAR),
    PROJECT                 VARCHAR2(4000 CHAR),
    TO_SITE                 VARCHAR2(4000 CHAR),
    INCOTERMS               VARCHAR2(4000 CHAR),
    ITEM_TYPE               VARCHAR2(4000 CHAR),
    CELL_ITEM_ID            VARCHAR2(4000 CHAR),
    ITEM_ID                 VARCHAR2(4000 CHAR),
    CELL_MODEL              VARCHAR2(4000 CHAR),
    MEASURE                 VARCHAR2(4000 CHAR),
    YYYYPW                  VARCHAR2(100 CHAR),
    QTY                     NUMBER,
    CELL_CONV               NUMBER,
    KCELL                   NUMBER
);
/

-- ===== T_FN_DQ_MKT_FCST_81_TAB =====
CREATE OR REPLACE EDITIONABLE TYPE "SCM_MGR"."T_FN_DQ_MKT_FCST_81_TAB" AS TABLE OF T_FN_DQ_MKT_FCST_81_ROW;
/
