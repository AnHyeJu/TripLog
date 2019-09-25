package proboard;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.simple.JSONObject;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import procomment.ComtDao;
import procomment.ComtDto;
import promember.MemberDao;
import promember.MemberDto;

@WebServlet({"/allonboard/*"})
public class AllaboutBoard extends HttpServlet {
	private static final long serialVersionUID = 1L;
	BoardDao dao;

	public void init() throws ServletException {
		this.dao = new BoardDao();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String nextPage;
		String category;
		String path = request.getContextPath();
		String action = request.getPathInfo();
		System.out.println(action);
		
		if (action.equals("/postUpload")) {
			int page;
			if(request.getParameter("page") ==null || request.getParameter("page").equals("") || request.getParameter("category")==null){
				page=0;
				category="all";
			}else{
				page = Integer.parseInt(request.getParameter("page"));
				category = request.getParameter("category");
			}
			
			String cate = request.getParameter("cate");
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			String username = request.getParameter("username");
			String ip = request.getRemoteAddr();
			String imgPaths= request.getParameter("imgPaths");
			String filePaths= request.getParameter("filePaths");
			System.out.println(filePaths);
			
			//글에 저장 안된 파일 삭제
			if(request.getParameter("imgPaths")!=null){
				
				String alImgPaths = request.getParameter("alImgPaths");
				if(!alImgPaths.equals("")){
					String [] depath = alImgPaths.split(",");
					for(String com : depath){
						System.out.println(com);
						if(!imgPaths.contains(com)){
							System.out.println("not contain");
							ServletContext ctx = getServletContext();
							
							//프젝 파일 경로
							String uploadPath =ctx.getRealPath("/");
							System.out.println(uploadPath);
							new File(uploadPath+"/"+com).delete();
						}
					}
				}
			}
			
			BoardDto dto = new BoardDto(cate, title, content, username, ip, imgPaths, filePaths,
					new Timestamp(System.currentTimeMillis()));
			dto.setPos(0);
			dto.setDepth(0);
			//답글시
			if(request.getParameter("pnum") != null){
				int pnum = Integer.parseInt(request.getParameter("pnum"));
				BoardDto pdto = dao.getPost(pnum);
				dto.setPos(pdto.getPos()+1);
				dto.setDepth(pdto.getDepth()+1);
			}
			
			dao.posUp(dto.getPos());
			dao.addPost(dto);
			
			nextPage = path + "/allonboard/boardList?page="+page+"&category="+category;
			response.sendRedirect(nextPage);
			
		}else if (action.equals("/boardList")) {
			category = request.getParameter("category");
			int totalcnt = this.dao.cntPosts(category);
			int postcnt = 3;
			int totalPage = (int) Math.ceil((double) totalcnt / (double) postcnt);
			int page = Integer.parseInt(request.getParameter("page"));
			if (page > totalPage) page = totalPage - 1;

			ArrayList<BoardDto> list = dao.getPosts(category, page, postcnt);
			
			request.setAttribute("totalPage", totalPage);
			request.setAttribute("page", page);
			request.setAttribute("category", category);
			request.setAttribute("list", list);
			
			RequestDispatcher dis = request.getRequestDispatcher("/board/board.jsp");
			dis.forward(request, response);
		}else if(action.equals("/imgUpload")){
			ServletContext ctx = getServletContext();

			String uploadPath =ctx.getRealPath("upload/img");
			
			System.out.println(uploadPath);
			
			int size = 10*1024*1024;
			JSONObject jobj = new JSONObject();
			String fileName ="";
			try {
				MultipartRequest multi = new MultipartRequest(request, uploadPath, size, "utf-8", new DefaultFileRenamePolicy());
				Enumeration files = multi.getFileNames();
			
					String file = (String)files.nextElement();
					System.out.println(file);
					
					fileName = multi.getFilesystemName(file);
					System.out.println(fileName);	
					
				
			} catch (Exception e) {
				System.out.println("imageUpload err");
				e.printStackTrace();
			}
			
			uploadPath = "upload/img/"+fileName;
			jobj.put("url", uploadPath);
			
			if(request.getParameter("profile") != null){
				MemberDao mdao = new MemberDao();
				String username = (String) request.getSession().getAttribute("login");
				mdao.updatePhoto(uploadPath, username);
			}
			response.setContentType("application/json");
			response.getWriter().println(jobj.toJSONString());
			
		}else if(action.equals("/fileUpload")){
		
			ServletContext ctx = getServletContext();
	
//			System.out.println(uploadPath);
	
			JSONObject jobj = new JSONObject();
			String fileNames ="";
			//클라이언트가 요청한 request객체의 정보 한글 처리
			String encoding ="utf-8";
			request.setCharacterEncoding(encoding);
			
			File currentDirPath = new File(ctx.getRealPath("upload/file"));
			
			//업로드할 파일 데이터를 임시로 저장할 객체 메모리 생성
			DiskFileItemFactory factory = new DiskFileItemFactory();
			
			//파일업로드시 사용할 임시 메모리 최대 크기
			factory.setSizeThreshold(1024*1024*1);
			
			//임시 메모리에 파일 업로드시 지정한 1메가 바이트 크기를 넘길경우
			//실제 업로드될 파일 경로를 지정함
			factory.setRepository(currentDirPath);
			
			//참고
			//DiskFileItemFactory클래스는 업로드 파일의 크기가 지정한 크기를 넘기기 전까지는
			//업로드한 파일 데이터를 메모리에 저장하고
			//지정한 크기를 넘길 경우 임시 디렉터리 파일로 저장한다
			
			//파일을 업로드할 메모리를 생성자 쪽으로 전달받아 저장한!! 파일 업로드를 처리할 객체 생성
			ServletFileUpload upload = new ServletFileUpload(factory);
			String fileName ="";
			try {
				//업로드할 파일에 대한 요청 정보를 가지고 있는 request객체를 parseRequest()메서드 호출 시
				//인자로 전달하면 request객체에 저장되어 있는 업로드할 파일의 정보들을 피싱해서
				//DiskFileItem객체에 저장한 후
				//DiskFileItem객체를 ArrayList에 추가하여 반환 받음
				List<FileItem> items = upload.parseRequest(request);
				
				//arrtlist 크기만큼 (DiskFileItem객체(업로드할 아이템 하나의 정보)의 갯수 만큼)반복
				for(int i=0; i<items.size(); i++){
					//ArrayList 가변 배열에서.. DiskFileItem객체(업로드할 아이템 하나의 정보)를 얻는다
					FileItem fileItem = items.get(i);
					
					//DiskFileItem객체(업로드 할 아이템 하나의 정보)가 파일 아이템이 아닐 경우
					if(fileItem.isFormField()){
						//업로드 진행X
						System.out.println(fileItem.getFieldName()+" = "+fileItem.getString(encoding));
					}else{
						//DiskFileItem객체가 파일 아이템일 경우
						//업로드 진행!
						System.out.println("파라미터  명: "+fileItem.getFieldName());
						System.out.println("파일 명: "+fileItem.getName());
						System.out.println("파일크기: "+fileItem.getSize()+"bytes");
						
						if(fileItem.getSize()>0){
							//업로드할 파일 명을 얻어 파일명의 뒤에서부터 \\문자열이 들어있는지(lastIndexOf())
							//인덱스 위치를 알려줌. 없으면 1반환
							int idx = fileItem.getName().lastIndexOf("\\");
							
							System.out.println(idx);
							if(idx == -1){
								idx = fileItem.getName().lastIndexOf("/");
								System.out.println("파일 경로가 포함되어 있는지? : "+idx);
							}
							//파일 중복 덮어씌우기 방지..ㅋㅋㅋ.. 컬럼 더 만들기 귀찮아서!
							String uuid = UUID.randomUUID().toString().replaceAll("-", "").substring(0, 5);
							
							//업로드할 파일 명 얻기
							fileName = fileItem.getName().substring(idx+1);
							
							fileName = fileName.substring(0, fileName.lastIndexOf("."))+uuid+fileName.substring(fileName.lastIndexOf("."));

							fileNames += "upload/file/"+fileName + ",";
							//업로드할 파일 경로+ 파일명에 대한 객체 생성
							File uploadFile = new File(currentDirPath + "\\"+fileName);
							//실제 파일 업로드
							fileItem.write(uploadFile);
						}
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			System.out.println("fileNames:"+fileNames);
			jobj.put("furl", fileNames);
			
			response.setContentType("application/json");
			System.out.println(jobj.toJSONString());
			response.getWriter().println(jobj.toJSONString());
			
			
		}else if(action.equals("/showPost")){
			int num = Integer.parseInt(request.getParameter("num"));
			
			dao.pluscnt(num);
			request.setAttribute("dto", dao.getPost(num));
			
			//글 보는 사람 정보 얻기
			if(request.getSession().getAttribute("login") != null){
				String username = (String) request.getSession().getAttribute("login");
				MemberDao mdao = new MemberDao();
				MemberDto mdto = mdao.getLine("username", username);
				request.setAttribute("mdto", mdto);
			}
			
			//댓글 정보 얻기
			ComtDao cdao = new ComtDao();
			ArrayList<ComtDto> clist = cdao.getComtList(num); //num은 post의 num
			request.setAttribute("clist", clist);
			
			RequestDispatcher dis = request.getRequestDispatcher("/board/post.jsp");
			dis.forward(request, response);
			
		}else if(action.equals("/postEdit")){
			int num = Integer.parseInt(request.getParameter("num"));
			request.setAttribute("dto", dao.getPost(num));
			
			RequestDispatcher dis = request.getRequestDispatcher("/board/edit.jsp");
			dis.forward(request, response);
			
		}else if(action.equals("/postUpdate")){
			BoardDto dto = new BoardDto();
			dto.setCate(request.getParameter("cate"));
			dto.setTitle(request.getParameter("title"));
			dto.setNum(Integer.parseInt(request.getParameter("num")));
			dto.setContent(request.getParameter("content"));
			dto.setUsername(request.getParameter("username"));
			dto.setChange_date(new Timestamp(System.currentTimeMillis()));
			dto.setImgPaths(request.getParameter("imgPaths"));
			
			//글에 저장 안된 파일 삭제
			if(request.getParameter("imgPaths")!=null){
				String imgPaths = request.getParameter("imgPaths");
				String alImgPaths = request.getParameter("alImgPaths");
				if(!alImgPaths.equals("")){
					String [] depath = alImgPaths.split(",");
					for(String com : depath){
						System.out.println(com);
						if(!imgPaths.contains(com)){
							System.out.println("not contain");
							ServletContext ctx = getServletContext();
							
							//프젝 파일 경로
							String uploadPath =ctx.getRealPath("/");
							System.out.println(uploadPath);
							new File(uploadPath+"/"+com).delete();
						}
					}
				}
			}
			
			dao.updatePost(dto);
			
//			String page = request.getParameter("page");
//			category = request.getParameter("category");
			nextPage = path + "/allonboard/showPost?num="+request.getParameter("num");
			response.sendRedirect(nextPage);
			
		}else if(action.equals("/postDelete")){
			int num = Integer.parseInt(request.getParameter("num"));
			
			//파일삭제,.. 함수만듦녀 좋을텐데시간x
			ServletContext ctx = getServletContext();
			String uploadPath =ctx.getRealPath("/");
			System.out.println(uploadPath);
			
			if(request.getParameter("imgPaths") !=null && !request.getParameter("imgPaths").equals("")){
				String cpath [] = request.getParameter("imgPaths").split(",");
				for(String c : cpath){
					new File(uploadPath+"/"+c).delete();
				}
			}
			if(request.getParameter("filePaths") !=null && !request.getParameter("filePaths").equals("")){
				String cpath [] = request.getParameter("filePaths").split(",");
				for(String c : cpath){
					new File(uploadPath+"/"+c).delete();
				}
			}
			
			dao.deletePost(num);
			
			String page = request.getParameter("page");
			category = request.getParameter("category");
			nextPage = path + "/allonboard/boardList?page="+page+"&category="+category;
			response.sendRedirect(nextPage);
			
		}else if(action.equals("/download")){
			ServletContext ctx = getServletContext();
			
			//프젝 파일 경로
			String file_repo =ctx.getRealPath("/");
			System.out.println(file_repo);
			OutputStream out = response.getOutputStream();
			
			//다운로드할 파일 명을 포함한 경로 만들기
			String downFile = file_repo + "\\"+request.getParameter("fileName");;
			System.out.println(downFile);
			//실제 타운로드할 파일에 접근하기 위해 File객체 생성
			File f = new File(downFile);
			String fileName = request.getParameter("fileName");
			if(fileName.lastIndexOf("/") != -1) fileName = fileName.substring(fileName.lastIndexOf("/")+1);
			System.out.println(fileName);
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Cache-Control", "no-store");
			
			response.setHeader("Content-Disposition", "attachment; fileName=\""+URLEncoder.encode(fileName, "UTF-8")+"\";");
			
			FileInputStream in = new FileInputStream(f);
			
			//다운로드 할 파일에서 데이터를 대략 8kb씩 일어와 저장할 용도의 byte단위 배열 생성
			byte[] buffer = new byte[1024*8];
			
			while(true){
				int count = in.read(buffer);//다운로드할 파일의 내용을 약 8kb단위로 읽어와 변수에 저장
				if(count == -1){
					break;
				}
				//다운로드할 파일로부터 읽어들인 값이 있으면
				//읽어들인 8kb전체를 출력스트림 통로를 통해 내보내기
				out.write(buffer, 0, count);
			}
			in.close();
			out.close();
		}

	}
}
