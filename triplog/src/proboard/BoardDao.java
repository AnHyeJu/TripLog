package proboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDao {
	private Connection con;
	private PreparedStatement pstmt;
	private ResultSet rs;
	String sql;

	private Connection connect() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/jspbeginner");
		return ds.getConnection();
	}//end of connct

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

	}//end of freeResource
	
	public void posUp(int pos){
		try {
			con = connect();
			String sql = "update proboard set pos = pos +1 where pos >=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, pos);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("posUp err: "+e.getMessage());
			e.printStackTrace();
		}finally {
			freeResource();
		}
	}//end of posUp

	public void addPost(BoardDto dto) {
		try {
			this.con = this.connect();
	
			sql = "insert into proboard(title, content, username, cate, ip, imgPaths, filePaths, reg_date, count, pos, depth) values(?,?,?,?,?,?,?,?,?,?,?)";
			this.pstmt = this.con.prepareStatement(sql);
			this.pstmt.setString(1, dto.getTitle());
			this.pstmt.setString(2, dto.getContent());
			this.pstmt.setString(3, dto.getUsername());
			this.pstmt.setString(4, dto.getCate());
			this.pstmt.setString(5, dto.getIp());
			this.pstmt.setString(6, dto.getImgPaths());
			this.pstmt.setString(7, dto.getFilePaths());
			this.pstmt.setTimestamp(8, dto.getReg_date());
			this.pstmt.setInt(9, 0);
			this.pstmt.setInt(10, dto.getPos());
			this.pstmt.setInt(11, dto.getDepth());
			
			this.pstmt.executeUpdate();
		} catch (Exception var6) {
			System.out.println("addPost err: " + var6.getMessage());
			var6.printStackTrace();
		} finally {
			this.freeResource();
		}

	}//end of addPost

	public ArrayList<BoardDto> getPosts(String category, int page, int postcnt) {
		ArrayList<BoardDto> list = new ArrayList<>();

		try {
			this.con = this.connect();
			if (category.equals("all")) {
				this.sql = "select * from proboard order by pos limit ?, ?";
				this.pstmt = this.con.prepareStatement(this.sql);
				this.pstmt.setInt(1, page * postcnt);
				this.pstmt.setInt(2, postcnt);
			} else {
				this.sql = "select * from proboard where cate=? order by pos limit ?, ?";
				this.pstmt = this.con.prepareStatement(this.sql);
				this.pstmt.setString(1, category);
				this.pstmt.setInt(2, page * postcnt);
				this.pstmt.setInt(3, postcnt);
			}

			this.rs = this.pstmt.executeQuery();

			while (this.rs.next()) {
				BoardDto dto = new BoardDto();
				dto.setCate(this.rs.getString("cate"));
				dto.setContent(this.rs.getString("content"));
				dto.setCount(this.rs.getInt("count"));
				dto.setDepth(this.rs.getInt("depth"));
				dto.setIp(this.rs.getString("ip"));
				dto.setImgPaths(this.rs.getString("imgPaths"));
				dto.setFilePaths(this.rs.getString("filePaths"));
				dto.setNum(this.rs.getInt("num"));
				dto.setPos(this.rs.getInt("pos"));
				dto.setReg_date(this.rs.getTimestamp("reg_date"));
				dto.setTitle(this.rs.getString("title"));
				dto.setUsername(this.rs.getString("username"));
				list.add(dto);
			}
		} catch (Exception var9) {
			System.out.println("getAllPosts err: " + var9.getMessage());
			var9.printStackTrace();
		} finally {
			this.freeResource();
		}

		return list;
	}//end of getPosts

	public int cntPosts(String category) {
		int cnt = 0;

		try {
			this.con = this.connect();
			if (category.equals("all")) {
				this.sql = "select count(*) as 'cnt' from proboard";
				this.pstmt = this.con.prepareStatement(this.sql);
			} else {
				this.sql = "select count(*) as 'cnt' from proboard where cate=?";
				this.pstmt = this.con.prepareStatement(this.sql);
				this.pstmt.setString(1, category);
			}

			this.rs = this.pstmt.executeQuery();
			this.rs.next();
			cnt = this.rs.getInt("cnt");
		} catch (Exception var7) {
			System.out.println("cntPosts err: " + var7.getMessage());
			var7.printStackTrace();
		} finally {
			this.freeResource();
		}

		return cnt;
	}//end of cntPosts
	
	public void pluscnt(int num){
		try {
			con = connect();
			
			sql ="update proboard set count=count+1 where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("pluscnt err: " + e.getMessage());
			e.printStackTrace();
		} finally {
			this.freeResource();
		}
	}//end of pluscnt
	
	public BoardDto getPost(int num){
		BoardDto dto = null;
		try {
			con = connect();
			
			sql = "select b.*, m.email from proboard b left join promember m on b.username = m.username where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			
			rs = pstmt.executeQuery();
			if(rs.next()){
				dto = new BoardDto();
				dto.setCate(this.rs.getString("cate"));
				dto.setContent(this.rs.getString("content"));
				dto.setImgPaths(this.rs.getString("imgPaths"));
				dto.setFilePaths(this.rs.getString("filePaths"));
				dto.setCount(this.rs.getInt("count"));
				dto.setDepth(this.rs.getInt("depth"));
				dto.setIp(this.rs.getString("ip"));
				dto.setNum(this.rs.getInt("num"));
				dto.setPos(this.rs.getInt("pos"));
				dto.setReg_date(this.rs.getTimestamp("reg_date"));
				dto.setTitle(this.rs.getString("title"));
				dto.setUsername(this.rs.getString("username"));
				dto.setEmail(this.rs.getString("email"));
				dto.setChange_date(this.rs.getTimestamp("change_date"));
				
			}
		} catch (Exception e) {
			System.out.println("getPost err: " + e.getMessage());
			e.printStackTrace();
		} finally {
			this.freeResource();
		}
		return dto;
	}//end of getPost

	public void updatePost(BoardDto dto) {
		try {
			con = connect();
			
			sql = "update proboard set cate=?, username=?, title=?, content=?, change_date=?, imgPaths=? where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dto.getCate());
			pstmt.setString(2, dto.getUsername());
			pstmt.setString(3, dto.getTitle());
			pstmt.setString(4, dto.getContent());
			pstmt.setTimestamp(5, dto.getChange_date());
			pstmt.setString(6, dto.getImgPaths());
			pstmt.setInt(7, dto.getNum());
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("updatePost err: " + e.getMessage());
			e.printStackTrace();
		} finally {
			this.freeResource();
		}
	}//end of updatePost

	public void deletePost(int num) {
		try {
			con = connect();
			
			sql = "delete from proboard where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("deletePost err: " + e.getMessage());
			e.printStackTrace();
		} finally {
			freeResource();
		}
	}//end of deletePost
}