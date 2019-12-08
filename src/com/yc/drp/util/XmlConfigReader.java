package com.yc.drp.util;

import java.io.InputStream;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class XmlConfigReader {
	// 懒汉式（延迟加载lazy）
	private static XmlConfigReader instance = null;
	// 保存jdbc相关配置信息
	private JdbcConfig jdbcConfig = new JdbcConfig();

	private XmlConfigReader() {

		SAXReader reader = new SAXReader();
		InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream("sys-config.xml");
		try {
			Document doc = reader.read(in);

			// 取得jdbc相关配置信息
			Element driverNameElt = (Element) doc.selectObject("/config/db-info/driver-name");
			Element urlElt = (Element) doc.selectObject("/config/db-info/url");
			Element userNameElt = (Element) doc.selectObject("/config/db-info/user-name");
			Element passwordElt = (Element) doc.selectObject("/config/db-info/password");

			// 设置jdbc相关的配置
			jdbcConfig.setDriverName(driverNameElt.getStringValue());
			jdbcConfig.setUrl(urlElt.getStringValue());
			jdbcConfig.setUserName(userNameElt.getStringValue());
			jdbcConfig.setPassword(passwordElt.getStringValue());
		} catch (DocumentException e) {
			e.printStackTrace();
		}

	}

	public static synchronized XmlConfigReader getInstance() {
		if (instance == null) {
			instance = new XmlConfigReader();
		}
		return instance;
	}

	/**
	 * 返回jdbc相关配置
	 * 
	 * @return
	 */
	public JdbcConfig getJdbcConfig() {
		return jdbcConfig;
	}

	public static void main(String[] args) {
		JdbcConfig jdbcConfig = XmlConfigReader.getInstance().getJdbcConfig();
		 System.out.println(jdbcConfig.getDriverName());
		 System.out.println(jdbcConfig.getUrl());
		 System.out.println(jdbcConfig.getUserName());
		System.out.println(jdbcConfig);
	}
}