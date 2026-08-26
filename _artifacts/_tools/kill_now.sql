-- PKG_DMF0020 배포 차단 세션 (조회 세션 — 데이터 손상 없음)
-- ⚠ SCMP_APP 공용계정: 아래 SID 만

ALTER SYSTEM KILL SESSION '880,14661,@1' IMMEDIATE;   -- 197s direct path read temp
