<%@page  import ="java.math.*;" %>
<%@page import="java.time.LocalTime"%>
<%@page import="myPackage.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Properties" %>
<%@page import="javax.mail.*" %>
<%@page import="javax.mail.internet.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
 <jsp:useBean id="pDAO" class="myPackage.DatabaseClass" scope="page"/>
<%
if(request.getParameter("page").toString().equals("login")){
if(pDAO.loginValidate(request.getParameter("username").toString(), request.getParameter("password").toString())){
    session.setAttribute("userStatus", "1");
    session.setAttribute("userId",pDAO.getUserId(request.getParameter("username")));
    response.sendRedirect("dashboard.jsp");

}else{
    request.getSession().setAttribute("userStatus", "-1");
    response.sendRedirect("login.jsp");
}

}else if(request.getParameter("page").toString().equals("register")){
        
        String fName =request.getParameter("fname");
        String lName =request.getParameter("lname");
        String uName=request.getParameter("uname");
        String email=request.getParameter("email");
        String pass=request.getParameter("pass");
        String user=request.getParameter("type");
        String contactNo =request.getParameter("contactno");
        String city =request.getParameter("city");
        String address =request.getParameter("address");
        
        if(!request.getParameter("fname").equals("")&& !request.getParameter("lname").equals("")
                &&!request.getParameter("uname").equals("")&&!request.getParameter("email").equals("")
                &&!request.getParameter("pass").equals("") &&!request.getParameter("type").equals("")){
         pDAO.addNewStudent(fName,lName,uName,email,pass,user,contactNo,city,address);
         
         response.sendRedirect("adm-page.jsp?pgprt=1"); 
        }
        else{%>
        <script language="Javascript"> alert("Attention !!! All required fields can't be empty");
         window.location = "http://localhost:8080/examination-system/register.html";
            </script>
        
        
        <%}
         
               
}else if(request.getParameter("page").toString().equals("profile")){
        
        String fName =request.getParameter("fname");
        String lName =request.getParameter("lname");
        String uName=request.getParameter("uname");
        String email=request.getParameter("email");
        String pass=request.getParameter("pass");
        String contactNo =request.getParameter("contactno");
        String city =request.getParameter("city");
        String address =request.getParameter("address");
         String uType =request.getParameter("utype");
        int uid=Integer.parseInt(session.getAttribute("userId").toString());
    
         
    pDAO.updateStudent(uid,fName,lName,uName,email,pass,contactNo,city,address,uType);
    response.sendRedirect("dashboard.jsp");
}else if(request.getParameter("page").toString().equals("courses")){ 
 
    if(request.getParameter("operation").toString().equals("addnew")){
        String cname = request.getParameter("coursename");
        if(!pDAO.CourseNameValid(cname)){
            %>
        <script language="Javascript"> alert("Attention !!! All required fields can't be empty"); </script>
        <%}
        else{
        pDAO.addNewCourse(request.getParameter("coursename"),Integer.parseInt(request.getParameter("totalmarks")),
                request.getParameter("time"));
        }
     
        response.sendRedirect("prof-page.jsp?pgprt=2");
        
    }else if(request.getParameter("operation").toString().equals("del")){
        pDAO.delCourse(request.getParameter("cname").toString());
        response.sendRedirect("prof-page.jsp?pgprt=2");
    }

}else if(request.getParameter("page").toString().equals("accounts")){
    if(request.getParameter("operation").toString().equals("del")){
        pDAO.delUser(Integer.parseInt(request.getParameter("uid")));
        response.sendRedirect("adm-page.jsp?pgprt=1");
    }

}else if(request.getParameter("page").toString().equals("questions")){
    if(request.getParameter("operation").toString().equals("addnew")){
        if((request.getParameter("correct").contentEquals(request.getParameter("opt2"))) ||(request.getParameter("correct").contentEquals(request.getParameter("opt1")))||(request.getParameter("correct").contentEquals(request.getParameter("opt3")))){
        pDAO.addQuestion(request.getParameter("coursename"),request.getParameter("question"),
                request.getParameter("opt1"), request.getParameter("opt2"),request.getParameter("opt3"),
        request.getParameter("opt4"), request.getParameter("correct"));
        response.sendRedirect("prof-page.jsp?pgprt=3");
        }
        else{
            %><script language="Javascript"> alert("Attention !!! The correct answer has to be one of the proposed choices.");
            window.location = "prof-page.jsp?pgprt=3";
            </script> <%
        }
 
    }
    else if(request.getParameter("operation").toString().equals("del")){
        pDAO.delCourse(request.getParameter("cname").toString());
        response.sendRedirect("prof-page.jsp?pgprt=3");
    }else if(request.getParameter("operation").toString().equals("delQuestion")){
        pDAO.delQuestion(Integer.parseInt(request.getParameter("qid")));
        response.sendRedirect("prof-page.jsp?pgprt=3");
       
    }

}else if(request.getParameter("page").toString().equals("exams")){
    if(request.getParameter("operation").toString().equals("startexam")){
        String cName=request.getParameter("coursename");
        int userId=Integer.parseInt(session.getAttribute("userId").toString());
        
        if(pDAO.ExamValid(userId,cName))
        {
        int examId=pDAO.startExam(cName,userId);
        session.setAttribute("examId",examId);
        session.setAttribute("examStarted","1");
        response.sendRedirect("std-page.jsp?pgprt=1&coursename="+cName);}
        else{%><script language="Javascript"> alert("Sorry !!You have passed this exam before.");
            window.location=" http://localhost:8080/examination-system/std-page.jsp?pgprt=1";
            </script> <%
        }
         
    }else if(request.getParameter("operation").toString().equals("submitted")){
        try{
        String time=LocalTime.now().toString();
        int size=Integer.parseInt(request.getParameter("size"));
        int eId=Integer.parseInt(session.getAttribute("examId").toString());
        int tMarks=Integer.parseInt(request.getParameter("totalmarks"));
        session.removeAttribute("examId");
        session.removeAttribute("examStarted");
        for(int i=0;i<size;i++){
            String question=request.getParameter("question"+i);
            String ans=request.getParameter("ans"+i);
            int qid=Integer.parseInt(request.getParameter("qid"+i));
            pDAO.insertAnswer(eId,qid,question,ans);
        }
        System.out.println(tMarks+" conn\t Size: "+size);
        pDAO.calculateResult(eId,tMarks,time,size);
        %>
        <%! 
        public static class SMTPAuthenticator extends Authenticator {
           public PasswordAuthentication getPasswordAuthentication (){
           return new PasswordAuthentication("hajararfaoui97","CD639666@arf");
           }
        }
        %>
        <% 
        int result=0;
        if(request.getParameter("send") != null)
        {
            String d_uname="hajararfaoui97";
            String d_password="CD639666@arf";
            String d_host="smtp.gmail.com";
            int d_port = 465;
            String m_to = pDAO.getUserEmail(session.getAttribute("userId").toString());
            String m_from ="hajararfaoui97@gmail.com";
            String m_subject="Recent Exam Result";
            String m_text=new String();
            
            String Date = pDAO.getExamDate(eId).toString();
            String StdName=pDAO.getUserName(session.getAttribute("userId").toString());
            String cName=pDAO.getCourseName(eId).toString();
           //String mark= pDAO.getMark(eId).toString();
           int mark1= (Integer.parseInt(pDAO.getMark(eId))*100)/pDAO.getTotalMarksByName(cName);
           String mark2 = String.valueOf(mark1);
          String Status=pDAO.getStatus(eId).toString();
            m_text="<h1>Thank you For Passing The Exam</h1></br></br><h3><i>Date: </i></h3>";
            m_text = m_text.concat(Date);
            m_text = m_text.concat("<h3><i>Student Name: </i></h3>");
            m_text=m_text.concat(StdName);
            m_text = m_text.concat("<h3><i>Course Name: </i></h3>");
            m_text=m_text.concat(cName);
            m_text = m_text.concat("<h3><i>Mark: </i></h3>");
            m_text=m_text.concat(mark2)+"%";
            m_text = m_text.concat("<h3><i>Status: </i></h3>");
            m_text= m_text.concat(Status);
            
            Properties props = new Properties();
            SMTPAuthenticator auth = new SMTPAuthenticator();
            Session ses= Session.getInstance(props,auth);
            
            //MIME style email message
            MimeMessage msg = new MimeMessage(ses);
            msg.setContent(m_text,"text/html");
            msg.setSubject(m_subject);
            msg.setFrom(new InternetAddress(m_from));
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(m_to));
            try{
                Transport transport =ses.getTransport("smtps");
                transport.connect(d_host, d_port, d_uname,d_password);
                transport.sendMessage(msg, msg.getAllRecipients());
                transport.close();
                result =1;
                
            }catch(Exception e)
            {
                out.println(e);
            }
        }
        %>
        <%
        response.sendRedirect("std-page.jsp?pgprt=1&eid="+eId+"&showresult=1");
        }catch(Exception e){
            e.printStackTrace();
        }  
    }

}else if(request.getParameter("page").toString().equals("logout")){
    session.setAttribute("userStatus","0");
    session.removeAttribute("examId");
    session.removeAttribute("examStarted");
    response.sendRedirect("login.jsp");
}

%>