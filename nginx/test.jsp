<%
out.println("x-forwarded-for: " + request.getHeader("x-forwarded-for"));
out.println("<br/>");
out.println("remote hosts: " + request.getRemoteAddr());
out.println("<br/>");
out.println("webapp dir: " + request.getSession().getServletContext().getRealPath(""));
out.println("<br/>");
out.println("catalina home: " + System.getProperty("catalina.home"));
out.println("<br/>");
%>
<% 
java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
java.util.Date currentTime = new java.util.Date();//得到当前系统时间
out.println("currentTime:"+formatter.format(currentTime));
%>