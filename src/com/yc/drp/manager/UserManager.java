package com.yc.drp.manager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.yc.drp.bean.User;
import com.yc.drp.util.DbUtil;
import com.yc.drp.util.PageModel;

/**
 * 采用单例
 * 
 * @author zsxdmsr115
 *
 */
public class UserManager {
	public static void main(String[] args) {
		UserManager um = new UserManager();
		PageModel pm = um.findUserList(1, 3);
		List<User> list = pm.getList();
		for (User u : list) {
			System.out.println(u);
		}
	}
	private static UserManager instance = new UserManager();

	private UserManager() {
		
	}

	public static UserManager getInstance() {
		return instance;
	}

	/**
	 * 分页查询
	 * 
	 * @param user
	 */
	public PageModel findUserList(int pageNo, int pageSize) {
		int start = (pageNo - 1) * pageSize;
		String sql = "select user_id, user_name, password, contact_tel, email, create_date from t_user limit ?,? ";
		Connection connection = DbUtil.getConnection();
		PreparedStatement psmt = null;
		ResultSet rs = null;
		PageModel pageModel = null;
		try {
			psmt = connection.prepareStatement(sql);
			psmt.setInt(1, start);
			psmt.setInt(2, pageSize);
			rs = psmt.executeQuery();
			
			List userList = new ArrayList();
			while (rs.next()) {
				User user = new User();
				user.setUserId(rs.getString("user_id"));
				user.setUserName(rs.getString("user_name"));
				user.setPassword(rs.getString("password"));
				user.setContactTel(rs.getString("contact_tel"));
				user.setEmail(rs.getString("email"));
				user.setCreateDate(rs.getTimestamp("create_date"));
				userList.add(user);
			}
			pageModel = new PageModel();
			pageModel.setList(userList);
			pageModel.setTotalRecords(getTotalRecords(connection));
			pageModel.setPageSize(pageSize);
			pageModel.setPageNo(pageNo);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return pageModel;
	}

	public int getTotalRecords(Connection conn) throws SQLException {
		String sql = "select count(user_id) from t_user ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {

			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			count = rs.getInt(1);

		} finally {
			DbUtil.closeAll(conn, pstmt, rs);
		}
		return count;
	}

	public void addUser(User user) {
		String sql = "insert into t_user (user_id, user_name, password, contact_tel, email, create_date) "
				+ " values (?, ?, ?, ?, ?, ?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		conn = DbUtil.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserId());
			pstmt.setString(2, user.getUserName());
			pstmt.setString(3, user.getPassword());
			pstmt.setString(4, user.getContactTel());
			pstmt.setString(5, user.getEmail());
			// pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
			pstmt.setTimestamp(6, new Timestamp(new Date().getTime()));
			// pstmt.setTimestamp(6, new Timestamp(new Date().getTime()));
			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DbUtil.closeAll(conn, pstmt, null);
			DbUtil.closeAll(conn, pstmt, null);
		}
	}

	/**
	 * 根据用户代码查询
	 */
	public User findUserById(String userId) {
		System.out.println("UserManager.findUserById() -- userId=" + userId);
		String sql = "select user_id, user_name, password, contact_tel, email, create_date from t_user where user_id=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = null;
		try {
			conn = DbUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				user = new User();
				user.setUserId(rs.getString("user_id"));
				user.setUserName(rs.getString("user_name"));
				user.setPassword(rs.getString("password"));
				user.setContactTel(rs.getString("contact_tel"));
				user.setEmail(rs.getString("email"));
				user.setCreateDate(rs.getTimestamp("create_date"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DbUtil.closeAll(conn, pstmt, rs);
		}
		return user;
	}
}
