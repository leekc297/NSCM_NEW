CREATE VIEW [dbo].[V_CYT_ITEM_LEVEL_BOM] AS 
WITH BBOM AS
(
select m.*
  from [dbo].[SCM_BOM_M] m
      , (
      select DIVISION_ID, COMPANY_ID, PARENT_ITEM_ID ,max(key_date) key_date
        from [dbo].[SCM_BOM_M] 
        group by DIVISION_ID, COMPANY_ID, PARENT_ITEM_ID 
        ) z
 where m.KEY_DATE = z.key_date
   and m.DIVISION_ID = z.DIVISION_ID
   and m.COMPANY_ID = z.COMPANY_ID
   and m.PARENT_ITEM_ID = z.PARENT_ITEM_ID
) 
, CTE_TABLE
AS
(
       SELECT division_id, company_id, A.plant_id, A.PARENT_ITEM_ID top_item, 1 AS LEVEL, A.PARENT_ITEM_ID, A.PARENT_QTY, A.PARENT_UOM ,A.CHILD_ITEM_ID, A.CHILD_QTY , A.child_uom
       FROM  BBOM A
       WHERE /* (
        select count(1)
          from FP_WEEKLY_DEMAND_PRODUCT_H d
             ,(
              select plant_id, max(SCP_PLAN_ID) SCP_PLAN_ID
                from FP_WEEKLY_DEMAND_PRODUCT_H
                 where plant_id <> 'LG100'
                 group by plant_id
              ) k
          where d.plant_id = k.PLANT_ID
            and d.scp_plan_id =k.SCP_PLAN_ID
            and d.COMPANY_ID = A.COMPANY_ID
            and d.PLANT_ID = A.plant_id
            and d.ITEM_ID  = A.PARENT_ITEM_ID
           ) > 0
       */
       a.PARENT_ITEM_ID in (
                select u.item_id
                    from dbo.scm_item_m u
                 where u.ITEM_TYPE in ( 'P' ,'H' ) 
                   and a.PARENT_ITEM_ID = u.item_id
                          ) 
       UNION ALL       
       SELECT b.division_id, b.company_id, B.plant_id, c.top_item top_item, LEVEL + 1, B.PARENT_ITEM_ID, B.PARENT_QTY, B.parent_uom, B.CHILD_ITEM_ID, B.CHILD_QTY, B.CHILD_UOM
       FROM BBOM B 
      JOIN CTE_TABLE C 
    ON B.PARENT_ITEM_ID = C.CHILD_ITEM_ID AND B.DIVISION_ID = C.DIVISION_ID AND B.COMPANY_ID = C.COMPANY_ID --AND B.plant_id = C.plant_id
)
SELECT distinct w.* , attr.item_type, item_name, attr.ITEM_CLASS_NAME, attr.MATERIAL_CLASS_NAME, attr.ITEM_CLASS
  FROM CTE_TABLE w
  left outer join(
    select company_id, division_id, item_id, item_name, item_type, MATERIAL_CLASS_NAME,ITEM_CLASS_NAME, item_class
      from [dbo].[SCM_ITEM_M]
    ) attr
    on w.COMPANY_ID = attr.company_id
   and w.DIVISION_ID = attr.division_id
   and w.PARENT_ITEM_ID = attr.item_id

