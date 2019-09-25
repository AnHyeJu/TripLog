package promember;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Properties;
import java.util.Random;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MemberDao {
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
			if (con != null) {
				con.close();
			}

			if (rs != null) {
				rs.close();
			}

			if (pstmt != null) {
				pstmt.close();
			}
		} catch (Exception var2) {
			System.out.println("자원해제 err: " + var2.getMessage());
			var2.printStackTrace();
		}

	}

	public boolean tableCheck(String colunm, String value) {
		boolean check = false;

		try {
			this.con = this.connect();
			this.sql = "select " + colunm + " from promember where " + colunm + "=?";
			this.pstmt = this.con.prepareStatement(this.sql);
			this.pstmt.setString(1, value);
			this.rs = this.pstmt.executeQuery();
			if (this.rs.next()) {
				check = true;
			} else {
				check = false;
			}
		} catch (Exception var5) {
			System.out.println("usernameCheck err: " + var5.getMessage());
			var5.printStackTrace();
		}finally {
			freeResource();
		}
		return check;
	}

	public String loginCheck(String email, String pwd) {
		String username = "";

		try {
			con = connect();
			
			sql = "select username from promember where email=? and pwd=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, email);
			pstmt.setString(2, pwd);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				username = rs.getString("username");
			}
		} catch (Exception var5) {
			System.out.println("loginCheck err: " + var5.getMessage());
			var5.printStackTrace();
		}finally {
			freeResource();
		}
		return username;
	}

	public MemberDto getLine(String colunm, String value) {
		MemberDto dto = null;

		try {
			this.con = this.connect();
			this.sql = "select * from promember where " + colunm + "=?";
			this.pstmt = this.con.prepareStatement(this.sql);
			this.pstmt.setString(1, value);
			this.rs = this.pstmt.executeQuery();
			if (this.rs.next()) {
				String photo = this.rs.getString("photo");
				String email = this.rs.getString("email");
				String pwd = this.rs.getString("pwd");
				String username = this.rs.getString("username");
				String address = this.rs.getString("address");
				String detailAddress = this.rs.getString("detailAddress");
				String phone = this.rs.getString("phone");
				int postcode = this.rs.getInt("postcode");
				int step = this.rs.getInt("step");
				Timestamp reg_date = this.rs.getTimestamp("reg_date");
				dto = new MemberDto(email, pwd, username, address, detailAddress, phone, photo, postcode, step, reg_date);
			}
		} catch (Exception var14) {
			System.out.println("bringColum err: " + var14.getMessage());
			var14.printStackTrace();
		} finally {
			this.freeResource();
		}

		return dto;
	}

	public String sendMail(String mail, String topic) {
		String num = this.randomNum();
		String sender = "getinzng@gamil.com";
		String subject = topic + " 발송";
		String content = topic + " 코드는 " + num + " 입니다.";

		try {
			Properties p = System.getProperties();
			p.put("mail.smtp.starttls.enable", "true");
			p.put("mail.smtp.host", "smtp.gmail.com");
			p.put("mail.smtp.auth", "true");
			p.put("mail.smtp.port", "587");
			Authenticator auth = new SMTPAuthenticator();
			Session s = Session.getDefaultInstance(p, auth);
			Message message = new MimeMessage(s);
			Address s_a = new InternetAddress(sender);
			Address s_r = new InternetAddress(mail);
			message.setHeader("content-type", "text/html;charset=UTF-8");
			message.setFrom(s_a);
			message.addRecipient(RecipientType.TO, s_r);
			message.setSubject(subject);
			message.setContent(content, "text/html;charset=UTF-8");
			message.setSentDate(new Date());
			Transport.send(message);
		} catch (Exception var13) {
			System.out.println("sendMail err: " + var13.getMessage());
			var13.printStackTrace();
			num = "x";
		}finally {
			freeResource();
		}
		return num;
	}

	private String randomNum() {
		StringBuffer temp = new StringBuffer();
		Random rnd = new Random();

		for (int i = 0; i < 8; ++i) {
			int rIndex = rnd.nextInt(3);
			switch (rIndex) {
				case 0 :
					temp.append((char) (rnd.nextInt(26) + 97));
					break;
				case 1 :
					temp.append((char) (rnd.nextInt(26) + 65));
					break;
				case 2 :
					temp.append(rnd.nextInt(10));
			}
		}
		return temp.toString();
	}//end randomNum

	public void addMember(MemberDto dto) {
		try {
			this.con = this.connect();

			sql = "insert into promember"
					+ "(email, pwd, username, address, detailAddress, phone, reg_date, step, postcode)"
					+ " values(?,?,?,?,?,?,?,?,?)";
			
			this.pstmt = this.con.prepareStatement(this.sql);
			this.pstmt.setString(1, dto.getEmail());
			this.pstmt.setString(2, dto.getPwd());
			this.pstmt.setString(3, dto.getUsername());
			this.pstmt.setString(4, dto.getAddress());
			this.pstmt.setString(5, dto.getDetailAddress());
			this.pstmt.setString(6, dto.getPhone());
			this.pstmt.setTimestamp(7, dto.getReg_date());
			this.pstmt.setInt(8, 0);
			this.pstmt.setInt(9, dto.getPostcode());
			
			this.pstmt.executeUpdate();
		} catch (Exception var6) {
			System.out.println("addMembers err: " + var6.getMessage());
			var6.printStackTrace();
		} finally {
			this.freeResource();
		}
	}//end of addMember
	
	public void updateMember(MemberDto dto){
		try {
			con = connect();
			sql = "update promember set username=?, postcode=?, address=?, detailAddress=?, phone=?, pwd=? where email=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setInt(2, dto.getPostcode());
			pstmt.setString(3, dto.getAddress());
			pstmt.setString(4, dto.getDetailAddress());
			pstmt.setString(5, dto.getPhone());
			pstmt.setString(6, dto.getPwd());
			pstmt.setString(7, dto.getEmail());
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("addMembers err: " + e.getMessage());
			e.printStackTrace();
		}finally {
			freeResource();
		}
	}//end of updateMember

	public void deleteMember(String email) {
		try {
			con = connect();
			
			sql="delete from promember where email=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, email);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("deleteMember err: " + e.getMessage());
			e.printStackTrace();
		}finally {
			freeResource();
		}
	}//end of deleteMember
	
	public void updatePhoto(String uploadPath, String username) {
		try {
			con = connect();
			
			sql = "update promember set photo=? where username=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, uploadPath);
			pstmt.setString(2, username);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("updatePhoto: " + e.getMessage());
			e.printStackTrace();
		} finally {
			this.freeResource();
		}
	}//end of updatePhoto
}