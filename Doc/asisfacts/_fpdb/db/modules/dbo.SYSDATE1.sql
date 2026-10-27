CREATE FUNCTION [dbo].[SYSDATE1] ()
RETURNS datetime
AS 
   BEGIN

      DECLARE
         @v_return datetime

         SET @v_return = GETDATE()

         RETURN @v_return
   END

