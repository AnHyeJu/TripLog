package procomment;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

@WebServlet({"/doComment/*"})
public class CommentControl extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ComtDao dao;

	public void init() throws ServletException {
		this.dao = new ComtDao();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doHandle(request, response);
	}

	@SuppressWarnings("unchecked")
	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
//		String path = request.getContextPath();
//		String nextPage = path + "/index.jsp";
		String action = request.getPathInfo();
		System.out.println(action);
		
		if("/comment.do".equals(action)){
			String photo = request.getParameter("photo");
			String username = request.getParameter("username");
			String comment = request.getParameter("comment");
			int postNum = Integer.parseInt(request.getParameter("postNum"));
			Timestamp reg_time =new Timestamp(System.currentTimeMillis());
			
			ComtDto dto = new ComtDto(photo, comment, username, postNum, reg_time);
			
			dao.insertComt(dto);
			
			SimpleDateFormat fm = new SimpleDateFormat("MMM-d h:mm a");
			
			JSONObject jobj = new JSONObject();
			jobj.put("photo", photo);
			jobj.put("comment", comment);
			jobj.put("username", username);
			jobj.put("postNum", postNum);
			jobj.put("reg_time", fm.format(reg_time));
			
			System.out.println(String.valueOf(jobj.toString()));
			response.setContentType("application/json");
			response.getWriter().print(String.valueOf(jobj.toString()));
		}
		
	}
}