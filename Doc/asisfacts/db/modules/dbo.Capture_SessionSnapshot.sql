
CREATE   PROC DBO.Capture_SessionSnapshot
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO DBO.SessionSnapshot
  (
    spid, status, login_name, host_name, program_name, db_name, command,
    blocked_by_spid, wait_type, wait_time_ms, cpu_time_ms, logical_reads, writes, request_id, sql_text
  )
  SELECT
    r.session_id                                         AS spid,
    s.status,
    s.login_name,
    s.host_name,
    s.program_name,
    DB_NAME(r.database_id)                               AS db_name,
    r.command,
    NULLIF(r.blocking_session_id, 0)                     AS blocked_by_spid,
    r.wait_type,
    r.wait_time                                          AS wait_time_ms,
    r.cpu_time                                           AS cpu_time_ms,
    r.logical_reads,
    r.writes,
    r.request_id,
    t.text                                               AS sql_text
  FROM sys.dm_exec_requests r
  JOIN sys.dm_exec_sessions s ON s.session_id = r.session_id
  OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) t;
  -- 주: '수면(sleeping)' 세션은 dm_exec_requests에 없으므로 굳이 안 담았습니다.
  -- 필요하면 s.status='sleeping'도 별도 UNION으로 담을 수 있어요.
END