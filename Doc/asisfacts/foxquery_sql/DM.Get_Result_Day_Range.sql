SELECT MIN(basis_yyyymmdd) + ':' + MAX(basis_yyyymmdd)
FROM   [dbo].[SCM_SYS_CALENDAR_M] A
WHERE  A.basis_yyyymmdd >= CONVERT(CHAR(8), DATEADD(MM, -2, CURRENT_TIMESTAMP), 112)
AND    A.basis_yyyymmdd <= CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)