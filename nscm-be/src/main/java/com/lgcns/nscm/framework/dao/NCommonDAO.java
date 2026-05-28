package com.lgcns.nscm.framework.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.lgcns.nscm.framework.exception.SqlException;

/**
 * 시스템에서 사용할 DAO 구현체
 * @Project  : nscm
 * @Package  : com.lgcns.nscm.framework.dao
 * @FileName : NCommonDAO.java
 * @author   : story55
 * @date     : 2026. 2. 5.
 * @description : NCommonDAO
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2026. 2. 5.        story55       최초 생성
 */
@Repository("NCommonDAO")
public class NCommonDAO implements NDaoInterface {

    @Autowired
    protected NDBConnection ndbconnection;


    /**
     * @MethodName : getSessionFactoryMap
     * @Description: SqlSessionFactory 객체가 들어있는 Map를 반환한다.
     * @author     : story55
     * @date       : 2026. 2. 5.
     * @param      : @return
     */
	@Override
	public Map<String, SqlSessionFactory> getSessionFactoryMap() {
		return ndbconnection.getSessionFactoryMap();
	}


	/**
	 * 데이터를 조회
	 * @param sqlId
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public <E> List<E> selectList(String sqlId, Map<String, Object> param) throws Exception {
		return (List<E>) selectList(sqlId, List.of(param));
	}
/*
	public List<Map<String, Object>> selectList(String sqlId, Map<String, Object> param) throws Exception {
		return selectList(sqlId, List.of(param));
	}
*/

	public List<Map<String, Object>> selectList(String dbId, String sqlId, Map<String, Object> param) throws Exception {
		return selectList(dbId, sqlId, List.of(param));
	}

	public List<Map<String, Object>> selectList(SqlSession sqlSes, String sqlId, Map<String, Object> param) throws Exception {
		return selectList(sqlSes, sqlId, List.of(param));
	}


	/**
     * 데이터를 추가함
     *
     * @param sqlId String SQL ID
     * @param param T 파라미터 타입 클래스
     * @return int 추가 건수
	 * @throws Exception
     */
	public int insert(String sqlId, Map<String, Object> param) throws Exception {
        return insertList(sqlId, List.of(param));
    }

	public int insert(String sqlId, List<Map<String, Object>> paramList) throws Exception {
        return insertList(sqlId, paramList);
    }

	public int insert(String dbId, String sqlId, Map<String, Object> param) throws Exception {
        return insertList(dbId, sqlId, List.of(param));
    }

	public int insert(String dbId, String sqlId, List<Map<String, Object>> paramList) throws Exception {
        return insertList(dbId, sqlId, paramList);
    }

	public int insert(SqlSession sqlSes, String sqlId, Map<String, Object> param) throws Exception {
        return insertList(sqlSes, sqlId, List.of(param));
    }

	public int insert(SqlSession sqlSes, String sqlId, List<Map<String, Object>> paramList) throws Exception {
        return insertList(sqlSes, sqlId, paramList);
    }


    /**
     * 데이터를 변경
     *
     * @param sqlId String SQL ID
     * @param param T 입력 파라미터
     * @return int 변경건수
     * @throws Exception
     */
	public int update(String sqlId, Map<String, Object> param) throws Exception {
		return updateList(sqlId, List.of(param));
	}

	public int update(String sqlId, List<Map<String, Object>> paramList) throws Exception {
		return updateList(sqlId, paramList);
	}

	public int update(String dbId, String sqlId, Map<String, Object> param) throws Exception {
        return updateList(dbId, sqlId, List.of(param));
    }

	public int update(String dbId, String sqlId, List<Map<String, Object>> paramList) throws Exception {
        return updateList(dbId, sqlId, paramList);
    }

	public int update(SqlSession sqlSes, String sqlId, Map<String, Object> param) throws Exception {
		return updateList(sqlSes, sqlId, List.of(param));
	}

	public int update(SqlSession sqlSes, String sqlId, List<Map<String, Object>> paramList) throws Exception {
		return updateList(sqlSes, sqlId, paramList);
	}



    /**
     * 데이터를 삭제함
     *
     * @param sqlId String SQL ID
     * @param param T 입력 파라미터
     * @return int 삭제건수
     * @throws Exception
     */
	public int delete(String sqlId, Map<String, Object> param) throws Exception {
		return deleteList(sqlId, List.of(param));
	}

	public int delete(String sqlId, List<Map<String, Object>> paramList) throws Exception {
		return deleteList(sqlId, paramList);
	}

	public int delete(String dbId, String sqlId, Map<String, Object> param) throws Exception {
        return deleteList(dbId, sqlId, List.of(param));
    }

	public int delete(String dbId, String sqlId, List<Map<String, Object>> paramList) throws Exception {
        return deleteList(dbId, sqlId, paramList);
    }

	public int delete(SqlSession sqlSes, String sqlId, Map<String, Object> param) throws Exception {
		return deleteList(sqlSes, sqlId, List.of(param));
	}

	public int delete(SqlSession sqlSes, String sqlId, List<Map<String, Object>> paramList) throws Exception {
		return deleteList(sqlSes, sqlId, paramList);
	}

}
