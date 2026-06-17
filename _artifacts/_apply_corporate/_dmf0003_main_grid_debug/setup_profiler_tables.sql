-- DBMS_PROFILER 의무 3 테이블 생성 (Oracle 표준 proftab.sql)

CREATE SEQUENCE plsql_profiler_runnumber START WITH 1 NOCACHE NOCYCLE;

CREATE TABLE plsql_profiler_runs (
  runid           NUMBER PRIMARY KEY,
  related_run     NUMBER,
  run_owner       VARCHAR2(32),
  run_date        DATE,
  run_comment     VARCHAR2(2047),
  run_total_time  NUMBER,
  run_system_info VARCHAR2(2047),
  run_comment1    VARCHAR2(2047),
  spare1          VARCHAR2(256)
);

CREATE TABLE plsql_profiler_units (
  runid             NUMBER REFERENCES plsql_profiler_runs,
  unit_number       NUMBER,
  unit_type         VARCHAR2(32),
  unit_owner        VARCHAR2(32),
  unit_name         VARCHAR2(32),
  unit_timestamp    DATE,
  total_time        NUMBER DEFAULT 0 NOT NULL,
  spare1            NUMBER,
  spare2            NUMBER,
  PRIMARY KEY (runid, unit_number)
);

CREATE TABLE plsql_profiler_data (
  runid           NUMBER,
  unit_number     NUMBER,
  line#           NUMBER NOT NULL,
  total_occur     NUMBER,
  total_time      NUMBER,
  min_time        NUMBER,
  max_time        NUMBER,
  spare1          NUMBER,
  spare2          NUMBER,
  spare3          NUMBER,
  spare4          NUMBER,
  PRIMARY KEY (runid, unit_number, line#),
  FOREIGN KEY (runid, unit_number) REFERENCES plsql_profiler_units
);
