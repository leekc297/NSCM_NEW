create FUNCTION [dbo].[fn_to_date2](@date_str as nvarchar(4000), @format as nvarchar(4000))
returnS  datetime2
AS
begin

declare
  @tmp_str as nvarchar(4000),
  @tdate_str as nvarchar(4000),
  @ttime_str as nvarchar(4000),
  @tpartf as nvarchar(4000),
        @tHH as tinyint,
  @tMI as tinyint,
  @tSS as tinyint,
  @tSSSSS as int,
  @tDD as tinyint,
  @tYY as int,
  @tJ as int,
  @tMM as tinyint,
  @tML as bit,
  @tRM as tinyint,
  @tpm as bit,
  @tDDD as int,
  @tMON as varchar(9),
  @i int,
  @j int,
  @tmp_d datetime2,
  @rez datetime2,
  @rezt datetime2,
  @rezd datetime2,
  @tempday nvarchar(4000), --This variable is used only for DAY Format and should not be overloaded
        @dayName nvarchar(4000),
        @tempdayprefix nvarchar(4000); --This variable is used only for DY Format and should not be overloaded

SET @format = upper(@format);
IF @format = '' or @format is NULL
 return NULL
SET @date_str   = upper(@date_str);

SET @tmp_str=replace(@date_str, ' ', '');

if substring(@tmp_str,charindex('/',@tmp_str)+1,1) in ('/', '-', '.', ':', ';', ',')
 return NULL
if substring(@tmp_str,charindex('-',@tmp_str)+1,1) in ('/', '-', '.', ':', ';', ',')
 return NULL
if substring(@tmp_str,charindex('.',@tmp_str)+1,1) in ('/', '-', '.', ':', ';', ',')
 return NULL
if substring(@tmp_str,charindex(':',@tmp_str)+1,1) in ('/', '-', '.', ':', ';', ',')
 return NULL
if substring(@tmp_str,charindex(';',@tmp_str)+1,1) in ('/', '-', '.', ':', ';', ',')
 return NULL
if substring(@tmp_str,charindex(',',@tmp_str)+1,1) in ('/', '-', '.', ':', ';', ',')
 return NULL

SET @tmp_str='';
SET @tempdayprefix = '';
SET @tempday = '';
SET @dayName = '';

IF  patindex(N'%[0-9]'+','+N'[0-9][0-9][0-9]%',@date_str)>0
 SET @date_str = replace(@date_str,N',',N'');
IF  patindex(N'%[A-Z]'+','+N'[A-Z][A-Z][A-Z]%',@format)>0 
 SET @format = replace(@format,N',',N'');
IF (patindex('%SYYYY%',@format)>0)
 SET @format = replace(@format,'SYYYY','YYYY');
IF (patindex('%HH12%',@format)>0)
 SET @format = replace(@format,'HH12','HH');
IF (patindex('%HH24%',@format)>0 and (patindex('%AM%',@format)>0 or patindex('%A.M.%',@format)>0 or patindex('%PM%',@format)>0 or patindex('%P.M.%',@format)>0 or patindex('%AM%',@date_str)>0 or patindex('%A.M.%',@date_str)>0 or patindex('%PM%',@date_str)>0 or patindex('%P.M.%',@date_str)>0))
 return NULL;
SET @tpm=0;
SET @tML=0;
IF (patindex('%MON%',@format)>0 or patindex('%MONTH%',@format)>0)
 SET @tML=1;
SET @format = replace(@format,'MONTH','MM');
SET @format = replace(@format,'MON','MM');

IF ((patindex('%PM%',@date_str)>0 and (patindex('%PM%',@format)>0 or patindex('%AM%',@format)>0)) or (patindex('%P.M.%',@date_str)>0 and (patindex('%P.M.%',@format)>0 or patindex('%A.M.%',@format)>0)))
 SET @tpm=1;

IF ((patindex('%AM%',@date_str)>0 and (patindex('%PM%',@format)>0 or patindex('%AM%',@format)>0)) or (patindex('%A.M.%',@date_str)>0 and (patindex('%P.M.%',@format)>0 or patindex('%A.M.%',@format)>0)))
 SET @tpm=0;

IF (patindex('%BC%',@date_str)>0 or patindex('%B.C.%',@date_str)>0)
 return NULL;
SET @i=1;

WHILE (@i<=len(@format))
BEGIN
SET @tpartf=substring(@format, @i, 1);

IF substring(@date_str, @i, 1)in (' ', '/', '-', '.', ':', ';', ',') and Len(@date_str)>=@i
BEGIN
 IF @tpartf NOT IN (' ', '/', '-', '.', ':', ';', ',')
 BEGIN
  SET @date_str=isnull(substring(@date_str, 1,@i-1),'')+isnull(substring(@date_str, @i+1, len(@date_str)),'')
  continue;
 END
 ELSE
 BEGIN
  SET @i=@i+1; 
  continue;
 END
END

IF @tpartf in (' ', '/', '-', '.', ':', ';', ',')
BEGIN
 IF substring(@date_str, @i, 1) NOT IN (' ', '/', '-', '.', ':', ';', ',') OR Len(@date_str)<@i
 BEGIN
  SET @format=isnull(substring(@format, 1,@i-1),'')+isnull(substring(@format, @i+1, len(@format)),'')
  continue;
 END
 ELSE
 BEGIN
  SET @i=@i+1; 
  continue;
 END
END


SET @tpartf=substring(@format, @i, 5);
--SSSSS
 IF @tpartf='SSSSS'
 BEGIN
  IF @tSSSSS IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  IF  (substring(@date_str, @i, 1) NOT like '[0-9]' and substring(@date_str, @i, 1)<>' ' and substring(@date_str, @i, 1)is not NULL)
   return NULL;
  WHILE (@j<5 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00000'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  SET @tSSSSS=@tmp_str;
  IF (@tmp_str='')
   SET @tSSSSS=NULL;
  IF (@tSSSSS>=86400)
   return NULL;
  SET @i=@i+5;
  continue;
 END;

SET @tpartf=substring(@format, @i, 2);
--DD/DDD
 IF @tpartf='DD' 
 BEGIN
  IF substring(@format, @i+2, 1)='D' 
  BEGIN
   IF @tDDD IS NOT NULL
    return NULL;
   SET @tddd=1;
   SET @j=0;
   SET @tmp_str='';
   WHILE (@j<3 and substring(@date_str, @i+@j, 1) like '[0-9]')
   BEGIN
    SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
    SET @j=@j+1;
   END;
   SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'000'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
   IF isnumeric(@tmp_str)=1
   BEGIN
    SET @tDDD=@tmp_str;
    IF (@tDDD>366 or @tDDD<1)
     return NULL;
    SET @i=@i+3;
    continue;
   END;
   ELSE
    return NULL;
  END;
  IF @tDD IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF isnumeric(@tmp_str)=1
  BEGIN
   SET @tDD=@tmp_str;
   IF (@tDD>31 or @tDD<1)
    return NULL;
   SET @i=@i+2;
   continue;
  END;
  ELSE
   return NULL;  
 END;

--MM
 IF @tpartf='MM'
 BEGIN
  IF @tMM IS NOT NULL
   return NULL;
  SET @tmp_str='';
  SET @j=0;
  IF (substring(@date_str, @i, 1) like '[0-9]')
  BEGIN
   IF (@tML=1)
    return NULL;
   WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[0-9]')
   BEGIN
    SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
    SET @j=@j+1;
   END;
   SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
   IF isnumeric(@tmp_str)=1
   BEGIN
    SET @tMM=@tmp_str;
    IF (@tMM>12 or @tMM<1)
     return NULL;
    SET @i=@i+2;
    continue;
   END;
   ELSE
    return NULL;   
  END
  IF (substring(@date_str, @i, 1) like '[A-Z]')
  BEGIN
   WHILE (@j<9 and substring(@date_str, @i+@j, 1) like '[A-Z]')
   BEGIN
    SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
    SET @j=@j+1;
   END;
   SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
   SET @tmp_str='01/'+@tmp_str+'/1900';
   if isdate(@tmp_str)=1
    SET @tmp_str=month(CONVERT(datetime2, @tmp_str, 101));
   else
    return NULL;
   IF isnumeric(@tmp_str)=1
   BEGIN
    SET @tMM=@tmp_str;
    IF (@tMM>12 or @tMM<1)
     return NULL;
    SET @i=@i+2;
    continue;
   END;
   ELSE
    return NULL; 
  END
  
 END;

--RM
 IF @tpartf='RM'
 BEGIN
  IF @tRM IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<4 and substring(@date_str, @i+@j, 1) like '[I,V,X]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  set @tmp_str = case @tmp_str 
                                    when N'I'    then N'01'  when N'II'   then N'02'  when N'III'  then N'03'
                                    when N'IV'   then N'04'  when N'V'    then N'05'  when N'VI'   then N'06'
                                    when N'VII'  then N'07'  when N'VIII' then N'08'  when N'IX'   then N'09'
                                    when N'X'    then N'10'  when N'XI'   then N'11'  when N'XII'  then N'12'
                                 end
  IF isnumeric(@tmp_str)=1
  BEGIN
   SET @tRM=@tmp_str;
   IF (@tRM>12 or @tRM<1)
    return NULL;
   SET @i=@i+2;
   continue;
  END;
  ELSE
   return NULL;  
 END;

--AM/PM
 IF @tpartf='AM' or @tpartf='PM'
 BEGIN
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[A,P,M]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF (len(@tmp_str)=2 or len(@tmp_str)=0)
  BEGIN
   SET @i=@i+2;
   continue;
  END
  ELSE
   return NULL;  
 END;

--AD/BC
 IF @tpartf='AD' or @tpartf='BC'
 BEGIN
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[A,D,B,C]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF (len(@tmp_str)=2 or len(@tmp_str)=0)
  BEGIN
   SET @i=@i+2;
   continue;
  END
  ELSE
   return NULL;  
 END;

--HH/HH24
 IF @tpartf='HH'
 BEGIN
  IF @tHH IS NOT NULL
   return NULL;
  IF  (substring(@date_str, @i, 1) NOT like '[0-9]' and substring(@date_str, @i, 1)<>' ')
   return NULL;
  IF substring(@format, @i+2, 2)='24'
  BEGIN
   SET @j=0;
   SET @tmp_str='';
   WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[0-9]')
   BEGIN
    SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
    SET @j=@j+1;
   END;
   SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
   SET @tHH=@tmp_str;
   SET @format = replace(@format,'HH24','HH');
   IF (@tHH>23)
    return NULL;
   SET @i=@i+2;
   continue;
  END;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF (@tpm=0)
   SET @tHH=case @tmp_str when '' then 12 else @tmp_str end;
  ELSE
   SET @tHH=@tmp_str;
  IF (@tHH>12 or @tHH<1)
   return NULL;
  IF @tpm=1 and @tHH<>12
   SET @tHH=@tHH+12
  IF @tpm=0 and @tHH=12
   SET @tHH=@tHH-12
  SET @i=@i+2;
  continue;

 END;

--MI
 IF @tpartf='MI'
 BEGIN
  IF @tMI IS NOT NULL
   return NULL;
  IF  (substring(@date_str, @i, 1) NOT like '[0-9]' and substring(@date_str, @i, 1)<>' ')
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  SET @tMI=@tmp_str;
  IF (@tMI>59)
   return NULL;
  SET @i=@i+2;
  continue;
  
 END;

--SS
 IF @tpartf='SS'
 BEGIN
  IF @tSS IS NOT NULL
   return NULL;
  IF  (substring(@date_str, @i, 1) NOT like '[0-9]' and substring(@date_str, @i, 1)<>' ')
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  SET @tSS=@tmp_str;
  IF (@tSS>59)
   return NULL;
  SET @i=@i+2;
  continue;
 END;

SET @tpartf=substring(@format, @i, 4);
--A.M./P.M.
 IF @tpartf='A.M.' or @tpartf='P.M.'
 BEGIN
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<4 and substring(@date_str, @i+@j, 1) like '[A,.,P,M]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'0000'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF (len(@tmp_str)=4 or len(@tmp_str)=0)
  BEGIN
   SET @i=@i+4;
   continue;
  END
  ELSE
   return NULL;  
 END;

--A.D./B.C.
 IF @tpartf='A.D.' or @tpartf='B.C.'
 BEGIN
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<4 and substring(@date_str, @i+@j, 1) like '[A,.,D,B,C]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'0000'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF (len(@tmp_str)=4 or len(@tmp_str)=0)
  BEGIN
   SET @i=@i+4;
   continue;
  END
  ELSE
   return NULL;  
 END;

--YYYY
 IF @tpartf='YYYY'
 BEGIN
  IF @tYY IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<4 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  IF (len(@tmp_str)=3)
   SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'0'+isnull(substring(@date_str, @i, len(@date_str)),'');
        IF (len(@tmp_str)=2)
   SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i, len(@date_str)),'');
        IF (len(@tmp_str)=1)
   SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'000'+isnull(substring(@date_str, @i, len(@date_str)),'');
  IF isnumeric(@tmp_str)=1
  BEGIN
   SET @tYY=@tmp_str;
   IF (@tYY<1)
    return NULL;
   SET @i=@i+4;
   continue;
  END;
  ELSE
   return NULL;  
 END;

--RRRR
 IF @tpartf='RRRR'
 BEGIN
  IF @tYY IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<4 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  IF (len(@tmp_str)=3)
        BEGIN
            SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'0'+isnull(substring(@date_str, @i, len(@date_str)),'');
            IF isnumeric(@tmp_str)=1
    BEGIN
     SET @tYY=@tmp_str;


                    IF (@tYY<100)
                    BEGIN
                        SET @tmp_str=substring(@tmp_str,2,2);
                        set @tmp_str = case 
                                         when cast(@tmp_str as int) < 50 then cast(year(GETDATE())/100 as nvarchar(2)) + @tmp_str
                                         else cast((year(GETDATE()))/100-1 as nvarchar(2)) + @tmp_str
         end;
         SET @tYY=@tmp_str;
     END

     IF (@tYY<1)
      return NULL;
     SET @i=@i+4;
     continue;
    END;
   ELSE
    return NULL;  
        END
  IF (len(@tmp_str)=4)
  BEGIN
   IF isnumeric(@tmp_str)=1
    BEGIN
     SET @tYY=@tmp_str;
     IF (@tYY<1)
      return NULL;
     SET @i=@i+4;
     continue;
    END;
   ELSE
    return NULL;  
  END;
  IF (len(@tmp_str)<3)
  BEGIN
   IF isnumeric(@tmp_str)=1
    BEGIN
     IF (len(@tmp_str)=2)
      SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i, len(@date_str)),'');
     IF (len(@tmp_str)=1)
     BEGIN
      SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'000'+isnull(substring(@date_str, @i, len(@date_str)),'');
      SET @tmp_str='0'+@tmp_str;
     END;
     set @tmp_str = case 
                                         when cast(@tmp_str as int) < 50 then cast(year(GETDATE())/100 as nvarchar(2)) + @tmp_str
                                         else cast((year(GETDATE()))/100-1 as nvarchar(2)) + @tmp_str
         end;
     SET @tYY=@tmp_str;
     IF (@tYY<1)
      return NULL;
     SET @i=@i+4;
     continue;
    END;
   ELSE
    return NULL;
  END;
 END;

SET @tpartf=substring(@format, @i, 3);
--YYY
 IF @tpartf='YYY'
 BEGIN
  IF @tYY IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<3 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'000'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF isnumeric(@tmp_str)=1
  BEGIN
   SET @tYY=2000+@tmp_str;
   SET @i=@i+3;
   continue;
  END;
  ELSE
   return NULL;  
 END;

--DAY
 IF @tpartf='DAY'
 BEGIN
  SET @j=0;  
  /*check @j value so that substring for @date_str is less than Day Names*/
  WHILE ((@j < 9 ) AND substring(@date_str, @i+@j,1) in ('A', 'D', 'E', 'F' ,'H', 'I','M','N','O','R','S','T','U','W','Y') /*('MON,TUE,WED,THU,FRI,SAT,SUN')*/ ) 
   BEGIN
    SET @tempday = @tempday+substring(@date_str, @i+@j, 1); 
    SET @j=@j+1;
   END;
  /* Keep the Year as-is but replace the dayName with DAY so length is consistent with fmt string */
  SET @date_str=isnull(replace(@date_str, @tempday, 'DAY'),''); 
  IF( (@tempday IN ('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY')))
   BEGIN
    SET @i=@i+3;
    CONTINUE;
   END
  ELSE
   BEGIN
    RETURN NULL
   END
 END;

SET @tpartf=substring(@format, @i, 2);

--DY
 IF @tpartf='DY'
 BEGIN
  SET @j=0;  
  /*check @j value so that substring for @date_str is less than Day Names*/
  WHILE ((@j < 3 ) AND substring(@date_str, @i+@j,1) in ('A', 'D', 'E', 'F' ,'H', 'I','M','N','O','R','S','T','U','W') /*('MON,TUE,WED,THU,FRI,SAT,SUN')*/ ) 
   BEGIN
    SET @tempdayprefix = @tempdayprefix+substring(@date_str, @i+@j, 1); 
    SET @j=@j+1;
   END;
  /* Keep the Year as-is but replace the dayName with DY so length is consistent with fmt string */
  SET @date_str=isnull(replace(@date_str, @tempdayprefix, 'DY'),''); 
  IF( (@tempdayprefix IN ('MON','TUE','WED','THU','FRI','SAT','SUN')))
   BEGIN
    SET @i=@i+2;
    CONTINUE;
   END
  ELSE
   BEGIN
    RETURN NULL
   END
 END;

--YY
 IF @tpartf='YY'
 BEGIN
  IF @tYY IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<4 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'00'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF isnumeric(@tmp_str)=1
  BEGIN
   SET @tYY=substring(cast(year(GETDATE()) as char(4)),1,2)+ right(@tmp_str,2);
   SET @i=@i+2;
   continue;
  END;
  ELSE
   return NULL;  
 END;

--RR
 IF @tpartf='RR'
 BEGIN
  IF @tYY IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<2 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  
  
  IF isnumeric(@tmp_str)=1
  BEGIN
   IF (len(@tmp_str)=1)
   BEGIN
    SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'0'+isnull(substring(@date_str, @i, len(@date_str)),'');
    SET @tmp_str='0'+@tmp_str;
   END;
   set @tmp_str = case 
                                when cast(@tmp_str as int) < 50 then cast(year(GETDATE())/100 as nvarchar(2)) + @tmp_str
                                else cast((year(GETDATE()))/100-1 as nvarchar(2)) + @tmp_str
       end;
   SET @tYY=@tmp_str;

   IF (@tYY<1)
    return NULL;
   SET @i=@i+2;
   continue;
  END;
  ELSE
   return NULL;
  
 END;

SET @tpartf=substring(@format, @i, 1);
--Y
 IF @tpartf='Y'
 BEGIN
  IF @tYY IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<1 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  IF isnumeric(@tmp_str)=1
  BEGIN
   SET @tYY=2000+@tmp_str;
   SET @i=@i+1;
   continue;
  END;
  ELSE
   return NULL;  
 END;

--J
 IF @tpartf='J'
 BEGIN
  IF @tJ IS NOT NULL
   return NULL;
  SET @j=0;
  SET @tmp_str='';
  WHILE (@j<7 and substring(@date_str, @i+@j, 1) like '[0-9]')
  BEGIN
   SET @tmp_str=@tmp_str+substring(@date_str, @i+@j, 1);
   SET @j=@j+1;
  END;
  SET @date_str=isnull(substring(@date_str, 1, @i-1),'')+'0'+isnull(substring(@date_str, @i+@j, len(@date_str)),'');
  IF isnumeric(@tmp_str)=1
  BEGIN
   SET @tJ=@tmp_str-1721424;
   IF @tJ<0
    return NULL;
   SET @i=@i+1;
   continue;
  END;
  ELSE
   return NULL;  
 END;

SET @i=@i+1;  
END;

SET @format = rtrim(ltrim(@format));
SET @date_str = rtrim(ltrim(@date_str));

IF (@tRM IS NOT NULL)
BEGIN
 IF (@tRM=@tMM or @tMM IS NULL)
  SET @tMM=@tRM;
END;

IF (@tDDD IS NOT NULL)
BEGIN
 SET @tmp_d=CONVERT(datetime2, '01/01/'+replicate('0',4-len(isnull(cast(@tYY as varchar),cast(year(GetDate()) as varchar))))+isnull(cast(@tYY as varchar),cast(year(GetDate()) as varchar)), 101)
 SET @tmp_d  = dateadd(day,@tDDD-1,@tmp_d)
 IF ((month(@tmp_d)=@tMM or @tMM IS NULL) and (day(@tmp_d)=@tDD or @tDD IS NULL))
 BEGIN
  SET @tDD=day(@tmp_d);
  SET @tMM=month(@tmp_d);
 END
 ELSE
  return NULL;
END; 

IF (@tJ IS NOT NULL)
BEGIN
 SET @tmp_d=CONVERT(datetime2, '01/01/0001', 101)
 SET @tmp_d  = dateadd(day,@tJ,@tmp_d)
 IF ((month(@tmp_d)=@tMM or @tMM IS NULL) and (year(@tmp_d)=@tYY or @tYY IS NULL) and (day(@tmp_d)=@tDD or @tDD IS NULL))
 BEGIN
  SET @tYY=year(@tmp_d);
  SET @tDD=day(@tmp_d);
  SET @tMM=month(@tmp_d);
 END
 ELSE
  return NULL;
END;

IF (@tSSSSS IS NOT NULL)
BEGIN
 SET @tmp_d=CONVERT(datetime2, '01/01/1900', 101)
 SET @tmp_d  = dateadd(ss,@tSSSSS,@tmp_d)
 IF ((DATEPART (hh,@tmp_d)=@tHH or @tHH IS NULL) and (DATEPART (mi,@tmp_d)=@tMI or @tMI IS NULL) and (DATEPART (ss,@tmp_d)=@tSS or @tSS IS NULL))
 BEGIN
  SET @tHH=DATEPART (hh,@tmp_d);
  SET @tMI=DATEPART (mi,@tmp_d);
  SET @tSS=DATEPART (ss,@tmp_d);
 END
 ELSE
  return NULL;
END; 

IF (len(@format)<>len(@date_str))
 return NULL

SET @tdate_str=isnull(cast(@tMM as varchar),cast(month(GetDate()) as varchar)) +'/'+isnull(cast(@tDD as varchar),'1')+'/'+replicate('0',4-len(isnull(cast(@tYY as varchar),cast(year(GetDate()) as varchar))))+isnull(cast(@tYY as varchar),cast(year(GetDate()) as varchar));
SET @ttime_str=isnull(CAST(@tHH as varchar),0)+':'+isnull(CAST(@tMI as varchar),0)+':'+isnull(CAST(@tSS as varchar),0);


SET @rezd=CONVERT(datetime2, @tdate_str, 101);
SET @rezt=CONVERT(datetime2, @ttime_str, 108);

--DAY Validation
IF( (@tempday is not null) AND (len(@tempday) > 0))
 BEGIN
  IF((@tempday IN ('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY')))
  BEGIN 
   SET @dayName = dateName(dw,@rezd)
   IF(UPPER(@dayName) <> @tempday)
    BEGIN
      Return null
    END
  END
 ELSE
  BEGIN
   RETURN NULL
  END 
END

--DY Validation
IF( (@tempdayprefix is not null) AND (len(@tempdayprefix) > 0))
 BEGIN
  IF((@tempdayprefix IN ('MON','TUE','WED','THU','FRI','SAT','SUN')))
  BEGIN 
   SET @dayName = dateName(dw,@rezd)
   IF(SUBSTRING(UPPER(@dayName),1,3) <> @tempdayprefix)
    BEGIN
      Return null
    END
  END
 ELSE
  BEGIN
   RETURN NULL
  END 
END

IF @rezd IS NULL and @rezt IS NULL
 return NULL

SET @rezd=DATEADD(hh,DATEPART(hh,@rezt),@rezd)
SET @rezd=DATEADD(mi,DATEPART(mi,@rezt),@rezd)
SET @rezd=DATEADD(ss,DATEPART(ss,@rezt),@rezd)
 
SET @rez=@rezd;



return @rez
end
