
CREATE procedure [dbo].[DMF_SPECVIEW]    
 @TABLE_NAME as varchar(40)    
as    
    
set nocount on    
 declare @COLUMNS varchar(5000), @COLUMNS1 varchar(5000), @CNT int, @MAX_CNT int, @TABLE_ID int, @FirstCheck int    
 declare @InsertClause varchar(5000), @SelectClause varchar(5000)    
  
 select @TABLE_ID = (select ID from sysobjects where NAME = @TABLE_NAME )    
  
 select @CNT = 1, @FirstCheck = 0, @MAX_CNT = (select max(COLID) from syscolumns where ID = @TABLE_ID)    
     
 --select -1 as SERNO, @COLUMNS as TEMP_DESCR into #TEMP    
-- insert into #TEMP select 0 as SERNO, @COLUMNS     
   
create table #Table_Temp(  
 AltKey   decimal(19) identity ,  
 FieldName  varchar(40) collate Latin1_General_CI_AI not null,  
 DataType  varchar(20) collate Latin1_General_CI_AI not null,  
 NullCheck  varchar(20) collate Latin1_General_CI_AI not null,  
  
  
)  
  
 while @CNT <= @MAX_CNT    
  begin    
 insert into #Table_Temp  
 select A.name ,  UPPER(B.name) +   
 case
  WHEN B.Name in('INT', 'smallint', 'tinyint', 'datetime') then '' 
  WHEN B.NAME = 'NUMERIC' THEN '(' + CAST(A.XPREC AS VARCHAR(5)) + ',' + CAST(A.XSCALE AS VARCHAR(5)) + ')'
  ELSE  '(' + CAST(A.PREC AS VARCHAR(10)) + ')'
        end   as DataType   
  ,case when isnullable = '1' then 'Y' else '' end as NullCheck  
  
 from syscolumns A, systypes B where ID = @TABLE_ID and COLID = @CNT and A.xusertype = B.xusertype  
    set @CNT= @CNT + 1    
 end     
    
  
--select FieldName, DataType, NullCheck  from #Table_Temp  
--order by Altkey  
  
IF NOT EXISTS(  
 SELECT @TABLE_NAME AS TableName, B.FieldName, B.DataType, CAST(a.[value] AS NVARCHAR(200)) AS Val, B.NullCheck
 FROM ::fn_listextendedproperty (NULL, 'user', 'dbo', 'table', @TABLE_NAME, 'column', default) as A inner join #Table_Temp B   
 on a.objname = b.fieldname  
 )
 select @TABLE_NAME AS TableName, FieldName, DataType, CAST('' AS NVARCHAR(200)) as Val, NullCheck  from #Table_Temp  
 order by Altkey  
ELSE 
 SELECT @TABLE_NAME AS TableName, B.FieldName, B.DataType, CAST(a.[value] AS NVARCHAR(200)) AS Val   , B.NullCheck
 FROM ::fn_listextendedproperty (NULL, 'user', 'dbo', 'table', @TABLE_NAME, 'column', default) as A 
  Right OUTER join #Table_Temp B   
 on a.objname = b.fieldname  

set nocount off    
    
-- spS 'DeptMaster'  
  
/*  
  
select A.name ,  B.name +   
   case  when B.Name = 'decimal' then '(19)'  
             when B.Name in('int', 'smallint') then ''  
             when A.Length = 9 then '(18,8)'  
                          when A.Length = 13 then '(28,8)'  
                  else  '(' + convert (varchar(4), A.length/2) + ') ' end   as DataType   
  ,case when isnullable = '1' then 'null' else 'not null' end as NullCheck  
  
 from syscolumns A, systypes B where ID = @TABLE_ID and COLID = @CNT and A.xusertype = B.xusertype  
  
  
*/








