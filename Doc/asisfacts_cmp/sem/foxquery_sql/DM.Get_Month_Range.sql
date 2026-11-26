SELECT MIN(basis_yyyymm) + ':' + MAX(basis_yyyymm)
FROM   [dbo].[SCM_SYS_CALENDAR_M] A
WHERE  A.basis_yyyymm >= CONVERT(CHAR(6), CURRENT_TIMESTAMP, 112)
AND    A.basis_yyyymm <= CONVERT(CHAR(6), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)