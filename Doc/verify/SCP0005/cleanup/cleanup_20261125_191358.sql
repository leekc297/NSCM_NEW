delete from SCP_MST_DISTRIBUTION_ROUTE_H where ROUTE_ID in (11172, 11173) and CREATED_BY = 'jooyong026' and CREATION_DATE > sysdate - 1; -- 백업 2 · 삭제 2
delete from SCP_MST_DISTRIBUTION_ROUTE where ROUTE_ID in (11172, 11173) and CREATED_BY = 'jooyong026' and CREATION_DATE > sysdate - 1; -- 백업 2 · 삭제 2
commit;
