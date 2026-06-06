package com.lgcns.nscm.framework.dao;

import static com.lgcns.nscm.framework.base.BaseConstants.DB_SESIONFACTORY_KEY;
import static com.lgcns.nscm.framework.base.BaseConstants.DEFAULT_DB_NAME;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.executor.BatchResult;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.lang.Nullable;

import com.lgcns.nscm.framework.exception.SqlException;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.lgcns.nscm.framework.utils.SecurityUtil;

/**
 * 다중DB DAO를 사용하기 위한 Interface
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.dao
 * @FileName : NDaoInterface.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : NDaoInterface
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
public interface NDaoInterface {

	static final Logger log = LoggerFactory.getLogger(NDaoInterface.class);

	Map<String, SqlSessionFactory> getSessionFactoryMap();

	/**
	 * @MethodName : getSessionFactory
	 * @Description: 기본DB의 SqlSessionFactory 객체를 반환한다.
	 *               기본DB: 설정파일에 등록된 첫번째 DB정보
	 * <pre>
	 * {@code
	 * SqlSessionFactory sqlSesFact = getSessionFactory();
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @return
	 * @return     : SqlSessionFactory
	 */
	default SqlSessionFactory getSessionFactory() {
			String defaultDB = getSessionFactoryMap().keySet().iterator().next();
		 return getSessionFactory(defaultDB);
	}


	/**
	 *
	 * @MethodName : getSessionFactory
	 * @Description: dbId와 연결된 SqlSessionFactory 객체를 반환한다.
	 * <pre>
	 * {@code
	 * SqlSessionFactory sqlSesFact = getSessionFactory("nscm_test_db");
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param dbId
	 * @param      : @return
	 * @return     : SqlSessionFactory
	 */
	default SqlSessionFactory getSessionFactory(String dbId) {
		return getSessionFactoryMap().get(dbId);
	}

	/**
	 *
	 * @MethodName : getSessionFactory
	 * @Description: Map의 DB_SESIONFACTORY_KEY키 연결된 SqlSessionFactory 객체를 반환한다.
	 * <pre>
	 * {@code
	 * SqlSessionFactory sqlSesFact = getSessionFactory(paramMap);
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param param
	 * @param      : @return
	 * @return     : SqlSessionFactory
	 */
	default SqlSessionFactory getSessionFactory(Map<String, Object> paramMap) {
        if(paramMap != null
        	&& paramMap.get(DB_SESIONFACTORY_KEY) != null
        	&& paramMap.containsKey(DB_SESIONFACTORY_KEY)) {

    		String sKey = paramMap.get(DB_SESIONFACTORY_KEY).toString();
    		for(String dbKey:getSessionFactoryMap().keySet()) {
    			if(dbKey.equals(sKey)) return getSessionFactory(dbKey);
    		}
        }
        return getSessionFactory();
	}

	/**
	 *
	 * @MethodName : getSqlSession
	 * @Description: 기본DB 커넥션을 이용하여 SqlSession 정보를 가져온다.
	 * <pre>
	 * {@code
	 * SqlSession sqlSes = getSqlSession();
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : SqlSession
	 */
	@Nullable
	default SqlSession getSqlSession() throws Exception {
		return _getSqlSession(getSessionFactory(), false, 0);
	}

	/**
	 *
	 * @MethodName : getSqlSession
	 * @Description: sDbID에 매칭되는 커넥션을 이용하여 SqlSession 정보를 가져온다.
	 * <pre>
	 * {@code
	 * SqlSession sqlSes = getSqlSession("nscm_test_db");
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @param sDbID
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : SqlSession
	 */
	@Nullable
	default SqlSession getSqlSession(String sDbID) throws Exception {
		return _getSqlSession(sDbID, false, 0);
	}

	/**
	 * SqlSession 정보를 가져온다.
	 * @param param
	 * @return SqlSession(object)
	 * @throws Exception
	 */
	@Nullable
	default SqlSession getSqlSession(Map<String, Object> param) throws Exception {
		return _getSqlSession(param, false, 0);
	}

	/**
	 * @MethodName : getBatchSqlSession
	 * @Description: 배치 사용용 SqlSession 정보를 가져온다
	 * <pre>
	 * {@code
	 * SqlSession sqlSes = getBatchSqlSession();
	 *
	 * }
	 * </pre>
	 * @author     : story55
	 * @date       : 2026. 2. 5.
	 * @param      : @return
	 * @param      : @throws Exception
	 * @return     : SqlSession
	 */
	@Nullable
	default SqlSession getBatchSqlSession() throws Exception {
		return _getSqlSession(getSessionFactory(), true, 0);
	}

	/**
	 * 배치 사용용 SqlSession 정보를 가져온다
	 * @param sDbID
	 * @return
	 */
	@Nullable
	default SqlSession getBatchSqlSession(String sDbID) throws Exception {
		return _getSqlSession(sDbID, true, 0);
	}

	/**
	 * 배치 사용용 SqlSession 정보를 가져온다
	 * @param param
	 * @return
	 */
	@Nullable
	default SqlSession getBatchSqlSession(Map<String, Object> param) throws Exception {
		return _getSqlSession(param, true, 0);
	}

	/**
	 * 배치 사용용 SqlSession 정보를 가져온다
	 * @param sDbID
	 * @return
	 */
	@Nullable
	default SqlSession getBatchSqlSession(String sDbID, int nFatchSize) throws Exception {
		return _getSqlSession(sDbID, true, nFatchSize);
	}

	/**
	 * 배치 사용용 SqlSession 정보를 가져온다
	 * @param param
	 * @return
	 */
	@Nullable
	default SqlSession getBatchSqlSession(Map<String, Object> param, int nFatchSize) throws Exception {
		return _getSqlSession(param, true, nFatchSize);
	}

	@Nullable
	default List<HashMap<String, Object>> selectStmtList(String sDbId, String sQuery) throws Exception {
		return _prepareSelect(sDbId, sQuery);
	}

	@Nullable
	default List<Integer> updateStmt(String sDbId, List<String> lstQuerys) throws Exception {
		return _prepareUpdate(sDbId, lstQuerys);
	}

	@Nullable
	default List<Map<String, Object>> selectList(String QID, List<Map<String, Object>> paramList) throws Exception {
		SqlSession sqlSes = getSqlSession();
		return _selectList(sqlSes, QID, paramList);
	}

	@Nullable
	default List<Map<String, Object>> selectList(String dbId, String QID, List<Map<String, Object>> paramList) throws Exception {
		SqlSession sqlSes = getSqlSession(dbId);
		return _selectList(sqlSes, QID, paramList);
	}

	@Nullable
	default List<Map<String, Object>> selectList(SqlSession sqlSes, String QID, List<Map<String, Object>> paramList) throws SqlException {
		return _selectList(sqlSes, QID, paramList);
	}

	@Nullable
	default List<Map<String, Object>> selectList(Map<String, Object> param, String QID, List<Map<String, Object>> paramList) throws Exception {
		return _selectList(getSqlSession(param), QID, paramList);
	}

	@Nullable
	default int insertList(String QID, List<Map<String, Object>> paramList) throws Exception{
		return _excuteBatch(getSqlSession(), QID, paramList);
	}

	@Nullable
	default int insertList(String dbId, String QID, List<Map<String, Object>> paramList) throws Exception{
		return _excuteBatch(getSqlSession(dbId), QID, paramList);
	}

	@Nullable
	default int insertList(SqlSession sqlSes, String QID, List<Map<String, Object>> paramList) throws Exception {
		return _excuteBatch(sqlSes, QID, paramList);
	}

	@Nullable
	default int updateList(String QID, List<Map<String, Object>> paramList) throws Exception {
		return _excuteBatch(getSqlSession(), QID, paramList);
	}

	@Nullable
	default int updateList(String dbId, String QID, List<Map<String, Object>> paramList) throws Exception {
		return _excuteBatch(getSqlSession(dbId), QID, paramList);
	}

	@Nullable
	default int updateList(SqlSession sqlSes, String QID, List<Map<String, Object>> paramList)throws Exception {
		return _excuteBatch(sqlSes, QID, paramList);
	}

	@Nullable
	default int deleteList(String QID, List<Map<String, Object>> paramList) throws Exception{
		return _excuteBatch(getSqlSession(), QID, paramList);
	}

	@Nullable
	default int deleteList(String dbId, String QID, List<Map<String, Object>> paramList) throws Exception {
		return _excuteBatch(getSqlSession(dbId), QID, paramList);
	}

	@Nullable
	default int deleteList(SqlSession sqlSes, String QID, List<Map<String, Object>> paramList) throws Exception{
		return _excuteBatch(sqlSes, QID, paramList);
	}


	private SqlSession _getSqlSession(String sDbID, boolean bBatch, int nFatchSize) throws SqlException {

		SqlSession sqlSes = null;
		try {

			if(bBatch) sqlSes = ((SqlSessionFactory) getSessionFactory(sDbID)).openSession(ExecutorType.BATCH, false);
			else sqlSes = ((SqlSessionFactory) getSessionFactory(sDbID)).openSession(false);

			if(NullUtils.isNone(sDbID)) sDbID = DEFAULT_DB_NAME;
			sqlSes.getConfiguration().setDatabaseId(sDbID);
			if(nFatchSize>0) sqlSes.getConfiguration().setDefaultFetchSize(nFatchSize);
			log.debug(" Fetch size >> "+sqlSes.getConfiguration().getDefaultFetchSize());
		} catch (NullPointerException e) {
			log.error(sDbID +" is not exist sqlSession. <NullPointerException>");
			throw new SqlException(e);
		} catch (Exception e) {
			log.error(sDbID +" is not exist sqlSession.");
			throw new SqlException(e);
		}

		return sqlSes;
	}

	private SqlSession _getSqlSession(SqlSessionFactory sqlSesF, boolean bBatch, int nFatchSize) throws SqlException {

		SqlSession sqlSes = null;
		try {

			if(bBatch) sqlSes = sqlSesF.openSession(ExecutorType.BATCH, false);
			else sqlSes = sqlSesF.openSession(false);
			sqlSes.getConfiguration().setDatabaseId(DEFAULT_DB_NAME);
			if(nFatchSize>0) sqlSes.getConfiguration().setDefaultFetchSize(nFatchSize);
			log.debug(" Fetch size >> "+sqlSes.getConfiguration().getDefaultFetchSize());
		} catch (NullPointerException e) {
			log.error(DEFAULT_DB_NAME +" is not exist sqlSession. <NullPointerException>");
			throw new SqlException(e);
		} catch (Exception e) {
			log.error(DEFAULT_DB_NAME +" is not exist sqlSession.");
			throw new SqlException(e);
		}

		return sqlSes;
	}

	private SqlSession _getSqlSession(Map<String, Object> param, boolean bBatch, int nFatchSize) throws SqlException {

		SqlSession sqlSes = null;
		String sDbID = DEFAULT_DB_NAME;
		try {
			if(bBatch) sqlSes = ((SqlSessionFactory) getSessionFactory(param)).openSession(ExecutorType.BATCH, false);
			else sqlSes = ((SqlSessionFactory) getSessionFactory(param)).openSession(false);

			if (param.get("dbId") != null && param.containsKey("dbId"))  sDbID = param.get("dbId").toString();
			sqlSes.getConfiguration().setDatabaseId(sDbID);
			if(nFatchSize>0) sqlSes.getConfiguration().setDefaultFetchSize(nFatchSize);
			log.debug(" Fetch size >> "+sqlSes.getConfiguration().getDefaultFetchSize());
		} catch (NullPointerException e) {
			log.error(sDbID +" is not exist sqlSession. <NullPointerException>");
			throw new SqlException(e);
		} catch (Exception e) {
			log.error(sDbID +" is not exist sqlSession.");
			throw new SqlException(e);
		}

		return sqlSes;
	}

	private List<HashMap<String, Object>> _prepareSelect(String sDbId, String sQuery) throws Exception {

		List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		SqlSession sqlSes = this.getBatchSqlSession(sDbId);
		try {
			paramMap.put("stmtQuery", sQuery);
			result = sqlSes.selectList("retributeStmt", paramMap);
		} catch (Exception e) {
			log.info("[prepareSelect] Error >> SqlSession: ["+sqlSes.getConfiguration().getDatabaseId()+"] SQL: ["+sQuery+"]" + e.getMessage());
			throw new SqlException(e);
		} finally {
			sqlSes.clearCache();
			sqlSes.close();
		}
		return result;
	}


	private List<Integer> _prepareUpdate(String sDbId, List<String> aQuerys) throws Exception {

		List<Integer> result = new ArrayList<Integer>();
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		SqlSession sqlSes = this.getBatchSqlSession(sDbId);

		try{
			for(int i=0; i<aQuerys.size(); i++) {
				int nRtn = 0;
				paramMap.put("stmtQuery", aQuerys.get(i));
				nRtn = sqlSes.update("excuteStmt", paramMap);
				List<BatchResult> batchResults = sqlSes.flushStatements();
				if(!NullUtils.isNone(batchResults)) {
					int[] updCnts = batchResults.get(0).getUpdateCounts();
					for(int updCnt:updCnts) nRtn = updCnt;
				}
				result.add(nRtn);
			}

		} catch (Exception e) {
			sqlSes.rollback();
			log.error("[prepareUpdate] Error >> SqlSession: ["+sqlSes.getConfiguration().getDatabaseId()+"] SQL: ["+paramMap.get("sQuery")+"]"+e.getMessage());
			throw new SqlException(e);
		} finally {
			sqlSes.commit();
			sqlSes.clearCache();
			sqlSes.close();

		}

		return result;
	}

	private List<Map<String, Object>> _selectList(SqlSession sqlSes, String sQID, List<Map<String, Object>> paramList) throws SqlException {

		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		int errIdx = 0;
		try {
			if(NullUtils.isNone(paramList)) result = sqlSes.selectList(sQID);
			else {
				String sUserId = SecurityUtil.getUserSession().getUserId();
				String sLangCd = SecurityUtil.getUserSession().getLangCd();
				for(int i=0; i<paramList.size(); i++) {
					Map<String, Object> paramMap = paramList.get(i);
					if(!NullUtils.isNone(sUserId)) {
						paramMap.put("sesUserId", sUserId);
						paramMap.put("createdBy", sUserId);
						paramMap.put("lastUpdatedBy", sUserId);
					}
					if(!NullUtils.isNone(sLangCd)) paramMap.put("sesLangCd", sLangCd);
					result.addAll(sqlSes.selectList(sQID, paramMap));
					errIdx++;
				}
			}
		} catch (Exception e) {
			String boundSql = sqlSes.getConfiguration().getMappedStatement(sQID).getBoundSql(paramList.get(errIdx)).getSql();
			log.error("[selectList] Error >> SqlSession: ["+sqlSes.getConfiguration().getDatabaseId()
						+"] QID: ["+sQID+"] "
						+"EXEC_SQL: ["+boundSql+"] "
						+e.getMessage());
			throw new SqlException(e);
		} finally {
			sqlSes.clearCache();
			sqlSes.close();
		}
		return result;
	}

	private int _excuteBatch(SqlSession sqlSes, String sQID, List<Map<String, Object>> paramList) throws SqlException {

		int result = 0;
		try {
			if(NullUtils.isNone(paramList)) result = sqlSes.update(sQID);
			else {
				if(paramList.size()>0) {
					for(Map<String, Object> paramMap:paramList) result += sqlSes.update(sQID, paramMap);
				} else result = sqlSes.update(sQID);
			}
			sqlSes.commit();
		} catch (Exception e) {
			result = -1;
			sqlSes.rollback();
			log.error("[update] Error >> SqlSession: ["+sqlSes.getConfiguration().getDatabaseId()+"] QID: ["+sQID+"] "+e.getMessage());
			throw new SqlException(e);
		} finally {
			sqlSes.clearCache();
			sqlSes.close();
		}

		return result;
	}

}
