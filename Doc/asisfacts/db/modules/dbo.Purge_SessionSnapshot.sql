CREATE   PROC DBO.Purge_SessionSnapshot @days INT = 14 AS
BEGIN
  DELETE TOP (200000) FROM DBO.SessionSnapshot
  WHERE snapshot_time_utc < DATEADD(DAY, -@days, SYSUTCDATETIME());
END
