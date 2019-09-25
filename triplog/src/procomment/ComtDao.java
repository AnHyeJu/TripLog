package procomment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ComtDao {
	private Connection con;
	private PreparedStatement pstmt;
	private ResultSet rs;
	String sql;
	
	private Connection connect() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/jspbeginner");
		return ds.getConnection();
	}

	public void freeResource() {
		try {
			if (this.con != null) {
				this.con.close();
			}

			if (this.rs != null) {
				this.rs.close();
			}

			if (this.pstmt != null) {
				this.pstmt.close();
			}
		} catch (Exception var2) {
			System.out.println("자원해제 err: " + var2.getMessage());
			var2.printStackTrace();
		}

	}//end of free

	public void insertComt(ComtDto dto) {
		try {
			con = connect();
			
			String sql = "update procomment set pos = pos +1";
			this.pstmt = this.con.prepareStatement(sql);
			this.pstmt.executeUpdate();
			
			sql = "insert into procomment(username, photo, comment, postNum, reg_time) values(?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getPhoto());
			pstmt.setString(3, dto.getComment());
			pstmt.setInt(4, dto.getPostNum());
			pstmt.setTimestamp(5, dto.getReg_time());
			
			pstmt.executeUpdate();
		} catch (Exception var6) {
			System.out.println("insertComt err: " + var6.getMessage());
			var6.printStackTrace();
		} finally {
			freeResource();
		}
	}

	public ArrayList<ComtDto> getComtList(int postNum) {
		ArrayList<ComtDto> list = new ArrayList<>();
		try {
			con = this.connect();
			
			sql = "select * from procomment where postNum=? order by pos";
			pstmt = this.con.prepareStatement(this.sql);
			pstmt.setInt(1, postNum);
			

			this.rs = this.pstmt.executeQuery();

			while (this.rs.next()) {
				ComtDto dto = new ComtDto();
				dto.setComment(rs.getString("comment"));
				dto.setNum(rs.getInt("num"));
				dto.setPhoto(rs.getString("photo"));
				dto.setPostNum(postNum);
				dto.setReg_time(rs.getTimestamp("reg_time"));
				dto.setUsername(rs.getString("username"));
				
				list.add(dto);
			}
		} catch (Exception var9) {
			System.out.println("getComtList err: " + var9.getMessage());
			var9.printStackTrace();
		} finally {
			this.freeResource();
		}
		return list;
	}
}
