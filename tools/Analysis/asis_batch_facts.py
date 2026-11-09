# -*- coding: utf-8 -*-
"""AS-IS 배치 정의 팩트 추출(읽기 전용) → Doc/asisfacts/db/batch/*.csv
  1) SSP_INT_SYSTEMEXE(SSP 자체 스케줄러 잡 정의) + SYSTEMEXELOG 최근 실행 집계
  2) msdb SQL Agent: sysjobs · sysjobsteps · sysschedules · sysjobschedules · sysjobhistory 최근 실행
"""
import sys, os, io, csv, datetime
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'DbConn'))
from dbconn import connect, write_csv, describe, mask
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'Doc', 'asisfacts', 'db', 'batch')
os.makedirs(OUT, exist_ok=True)
Q = {
 'ssp_int_systemexe': "SELECT * FROM dbo.SSP_INT_SYSTEMEXE ORDER BY ORDER_NUM, JOBID",
 'ssp_int_systemexelog_summary': """SELECT JOBID, COUNT(*) AS runs, MIN(EXECSTARTDTTM) AS first_run, MAX(EXECSTARTDTTM) AS last_run,
      SUM(CASE WHEN EXECRSLTCODE LIKE 'S%' OR EXECRSLTCODE LIKE 'OK%' OR EXECRSLTCODE='Y' THEN 1 ELSE 0 END) AS ok_like,
      MAX(EXECRSLTCODE) AS sample_rslt FROM dbo.SSP_INT_SYSTEMEXELOG GROUP BY JOBID ORDER BY JOBID""",
 'ssp_int_systemexelog_recent': "SELECT TOP 200 * FROM dbo.SSP_INT_SYSTEMEXELOG ORDER BY EXECSTARTDTTM DESC",
 'agent_jobs': """SELECT j.job_id, j.name, j.enabled, j.description, j.date_created, j.date_modified, c.name AS category
      FROM msdb.dbo.sysjobs j LEFT JOIN msdb.dbo.syscategories c ON c.category_id=j.category_id ORDER BY j.name""",
 'agent_jobsteps': """SELECT j.name AS job_name, s.step_id, s.step_name, s.subsystem, s.database_name, s.command, s.on_success_action, s.on_fail_action, s.last_run_outcome, s.last_run_date, s.last_run_time, s.last_run_duration
      FROM msdb.dbo.sysjobsteps s JOIN msdb.dbo.sysjobs j ON j.job_id=s.job_id ORDER BY j.name, s.step_id""",
 'agent_schedules': """SELECT j.name AS job_name, sc.name AS schedule_name, sc.enabled, sc.freq_type, sc.freq_interval, sc.freq_subday_type, sc.freq_subday_interval, sc.freq_relative_interval, sc.freq_recurrence_factor, sc.active_start_date, sc.active_end_date, sc.active_start_time, sc.active_end_time, js.next_run_date, js.next_run_time
      FROM msdb.dbo.sysjobschedules js JOIN msdb.dbo.sysjobs j ON j.job_id=js.job_id JOIN msdb.dbo.sysschedules sc ON sc.schedule_id=js.schedule_id ORDER BY j.name""",
 'agent_jobhistory_summary': """SELECT j.name AS job_name, COUNT(*) AS runs, MIN(h.run_date) AS first_run_date, MAX(h.run_date) AS last_run_date,
      SUM(CASE WHEN h.run_status=1 THEN 1 ELSE 0 END) AS succeeded, SUM(CASE WHEN h.run_status=0 THEN 1 ELSE 0 END) AS failed
      FROM msdb.dbo.sysjobhistory h JOIN msdb.dbo.sysjobs j ON j.job_id=h.job_id WHERE h.step_id=0 GROUP BY j.name ORDER BY j.name""",
}
print('[asis_batch_facts]', describe('asis'), datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
res = {}
with connect('asis') as cx:
    for name, sql in Q.items():
        try:
            cur = cx.cursor(); cur.execute(sql)
            n = write_csv(os.path.join(OUT, name + '.csv'), cur)
            res[name] = n; print(f'  {name}: {n}행')
        except Exception as e:
            res[name] = 'ERR ' + mask(str(e))[:200]; print(f'  {name}: ERROR {mask(str(e))[:200]}')
with io.open(os.path.join(OUT, '_extract_log.md'), 'a', encoding='utf-8') as f:
    f.write(f"\n## {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} {describe('asis')}\n" + '\n'.join(f'- {k}: {v}' for k, v in res.items()) + '\n')
