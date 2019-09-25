package procomment;

import java.sql.Timestamp;

public class ComtDto {
	private String photo,comment,username;
	private int postNum,num;
	private Timestamp reg_time;
	public ComtDto(){}
	public ComtDto(String photo, String comment, String username, int postNum, int num, Timestamp reg_time) {
		this.photo = photo;
		this.comment = comment;
		this.username = username;
		this.postNum = postNum;
		this.num = num;
		this.reg_time = reg_time;
	}
	
	public ComtDto(String photo, String comment, String username, int postNum, Timestamp reg_time) {
		this.reg_time = reg_time;
		this.photo = photo;
		this.comment = comment;
		this.username = username;
		this.postNum = postNum;
	}
	public Timestamp getReg_time() {
		return reg_time;
	}
	public void setReg_time(Timestamp reg_time) {
		this.reg_time = reg_time;
	}
	public String getPhoto() {
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public int getPostNum() {
		return postNum;
	}
	public void setPostNum(int postNum) {
		this.postNum = postNum;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
}
