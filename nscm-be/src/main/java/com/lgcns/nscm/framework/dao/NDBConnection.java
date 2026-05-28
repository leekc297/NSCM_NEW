package com.lgcns.nscm.framework.dao;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Repository;

import com.lgcns.nscm.framework.interceptor.QueryLogInterceptor;
import com.lgcns.nscm.framework.property.CommonProperties;
import com.lgcns.nscm.framework.property.CommonProperties.Datasource;
import com.lgcns.nscm.framework.utils.NullUtils;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository("NDBConnection")
public class NDBConnection implements InitializingBean, DisposableBean, NDaoInterface  {

	public NDBConnection(CommonProperties commonProperties, ApplicationContext applicationContext) {
		this.commonProperties = commonProperties;
		this.dbList = commonProperties.getDatasources();
		this.applicationContext = applicationContext;
	}
	private final CommonProperties commonProperties;
	private final List<Datasource> dbList;
	private final ApplicationContext applicationContext;
	private final String sqlConType = "DBCP";

	private Map<String, HikariDataSource> mDatasource = new LinkedHashMap();				// DataSource List
	private static Map<String, SqlSessionFactory> mSessionFactory = new LinkedHashMap();	// Session Factory List


	@Override
	public void destroy() throws Exception {this.clean();}				// 종료시 처리
	@Override
	public void afterPropertiesSet() throws Exception {this.init();}	// bean 설정정보 주입완료 시점

	// 등록된 DB의 SqlSessionFactory map을 반환.
    @Override
	public Map<String, SqlSessionFactory> getSessionFactoryMap() {
		return mSessionFactory;
	}


	/**
	 * 초기 시작시
	 * @throws Exception
	 */
	public boolean init() throws Exception {
		boolean bRtn = true;
		try {
			if (sqlConType.equals("JNDI")) InitJNDI();
			else InitDBCP();
		} catch (Exception e) {
			bRtn = false;
		}
		return bRtn;
	}

	private void clean() {
		cleanFactory();
		cleanDataSource();
	}

	private void cleanFactory() {
		if(!mSessionFactory.isEmpty()) {
			Object[] arrKey = mSessionFactory.keySet().toArray();
			for(int i=0; i<arrKey.length; i++) {
				String sKey = (String) arrKey[i];
				SqlSessionFactory oVal = (SqlSessionFactory) mSessionFactory.get(sKey);
				oVal.getConfiguration().getCaches().clear();
			}
		}
	}

	private void cleanDataSource() {
		if(!mDatasource.isEmpty()) {
			Object[] arrKey = mDatasource.keySet().toArray();
			for(int i=0; i<arrKey.length; i++) {
				String sKey = (String) arrKey[i];
				Object oVal = mDatasource.get(sKey);
				try {
					if(oVal instanceof com.zaxxer.hikari.HikariDataSource) {
						((com.zaxxer.hikari.HikariDataSource) oVal).close();
					} else if(oVal instanceof AutoCloseable) {
						((AutoCloseable) oVal).close();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * jndi 사용
	 * @throws Exception
	 */
	private void InitJNDI() throws Exception {

		this.clean();

		String sDbNm = "";
		String sSqlPath = "";
		String sSqlConfPath = "";

		for(Datasource dbInfo:dbList) {
			sDbNm = dbInfo.getDatabaseName();
			sSqlPath = dbInfo.getMapperLocations();
			sSqlConfPath = dbInfo.getConfigLocations();

			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			HikariDataSource ds = (HikariDataSource) envCtx.lookup(sDbNm);

			mDatasource.put(sDbNm, ds);
			mSessionFactory.put(sDbNm, getSqlSesF(ds, sSqlPath, sSqlConfPath));
		}
	}


	/**
	 * application 에서 dbcp 구성
	 * @throws Exception
	 */
	private void InitDBCP() throws Exception {
		// 커넥션 초기화
		this.clean();

		String sDbNm = "";
		String sDbTp = "MSSQL";
		String sDriver = "net.sf.log4jdbc.sql.jdbcapi.DriverSpy";
		String sTestSql = "";
		String sSqlPath = "";
		String sSqlConfPath = "";
		String sDbUrl = "";
		String sDbUserId = "";
		String sDbUserPw = "";
		int nMaxPoolSize = 10;
		int nMinIdel = 10;
		int nTimeout = 60000;
		int nIdleTimeout = 60000;

		for(Datasource dbInfo:dbList) {
			try {
				sDbNm = dbInfo.getDatabaseName();
				sDbTp = dbInfo.getDatabaseType();
				sDriver = dbInfo.getDriverClassName();
				sSqlPath = dbInfo.getMapperLocations();
				sSqlConfPath = dbInfo.getConfigLocations();
				sDbUrl = dbInfo.getJdbcUrl();
				sDbUserId = dbInfo.getUsername();
				sDbUserPw = dbInfo.getPassword();
				nMaxPoolSize = dbInfo.getMaxPoolSize();
				nMinIdel = dbInfo.getMinIdel();
				if(NullUtils.isNone(dbInfo.getConnectionTestQuery())) sTestSql = "";
				else sTestSql = dbInfo.getConnectionTestQuery();

				/* DBCP 설정 */
				HikariConfig hikariConfig = new HikariConfig();
				hikariConfig.setDriverClassName(sDriver);
				hikariConfig.setJdbcUrl(sDbUrl);
				hikariConfig.setUsername(sDbUserId);
				hikariConfig.setPassword(sDbUserPw);
				hikariConfig.setConnectionTestQuery(sTestSql);
				hikariConfig.setValidationTimeout(1000);
				hikariConfig.setMaximumPoolSize(nMaxPoolSize);
				hikariConfig.setMinimumIdle(nMinIdel);
				hikariConfig.setConnectionTimeout(nTimeout);
				if(nMinIdel == nMaxPoolSize) nIdleTimeout = 0;
				hikariConfig.setIdleTimeout(nIdleTimeout);

				Properties prop = new Properties();
				prop.setProperty("oracle.jdbc.javaTime", "true");

				// 2. [성능 최적화] 구문 캐싱 (PreparedStatement Caching)
				// SQL 분석 시간을 줄여 1초 지연 현상을 개선합니다.
				prop.setProperty("implicitCachingEnabled", "true");
				prop.setProperty("maxStatementsLimit", "100");

				// 3. [성능 최적화] 페치 사이즈 (Fetch Size)
				// 한 번의 네트워크 통신으로 가져올 로우(Row) 수를 늘려 조회 속도를 높입니다.
				prop.setProperty("defaultRowPrefetch", "100");
				hikariConfig.setDataSourceProperties(prop);

				HikariDataSource ds = new HikariDataSource(hikariConfig);
				mDatasource.put(sDbNm, ds);
				mSessionFactory.put(sDbNm, getSqlSesF(ds, sSqlPath, sSqlConfPath));
				log.info("["+sqlConType+": "+sDbNm+"("+sDbTp+")] create sqlSessionFactory. ");
			} catch (NamingException e) {
				log.error("["+sqlConType+": "+sDbNm+"("+sDbTp+")] is NamingException. "+e.getMessage());
				continue;
			} catch (SQLException e) {
				log.error("["+sqlConType+": "+sDbNm+"("+sDbTp+")] is SQLException. "+e.getMessage());
				continue;
			} catch (Exception e) {
				log.error("["+sqlConType+": "+sDbNm+"("+sDbTp+")] is Exception. "+e.getMessage());
				continue;
			}
		}
	}

	private SqlSessionFactory getSqlSesF(DataSource dataSource, String sqlPath, String sqlConfPath) throws Exception {

	    SqlSessionFactoryBean sessionFactoryBean = new SqlSessionFactoryBean();

	    // 1. 데이터 소스 설정
	    sessionFactoryBean.setDataSource(dataSource);

	    // 2. 매퍼 XML 경로 설정 (Resource 타입으로 변환)
	    if (sqlPath != null && !sqlPath.isEmpty()) {
	        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
	        sessionFactoryBean.setMapperLocations(applicationContext.getResources(sqlPath));
	    }

	    // 3. MyBatis 설정 파일이 있는 경우 설정
	    if (sqlConfPath != null && !sqlConfPath.isEmpty()) {
	        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
	        sessionFactoryBean.setConfigLocation(applicationContext.getResource(sqlConfPath));
	    }

	    // 4. 로그데이터를 위해 QueryLogInterceptor에 데이터셋 추가
	    if (commonProperties.getMybatis().isLoggingEnabled()){
	    	sessionFactoryBean.setPlugins(new QueryLogInterceptor(dataSource, commonProperties));
        }

	    return sessionFactoryBean.getObject();
	}


}
