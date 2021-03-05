<!DOCTYPE html>
<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="login.css">
</head>
<body style="background-image: url(exams.jpg);">
	
		<div class="loginbox">
                    <img src="avatar.png" class="avatar">
                        <h1>Login Here</h1>
			<form method='post' action="controller.jsp">
                             <input type="hidden" name="page" value="login"> 
				<p>Username</p>
            <input type="text" name="username" placeholder="Enter Username">
            <p>Password</p>
            <input type="password" name="password" placeholder="Enter Password">
					<tr>
						<td>
							
						</td>
						<td>
                                                    <% 
                                                        if(request.getSession().getAttribute("userStatus")!=null){
                                                            System.out.println("its called");
                                                      if(request.getSession().getAttribute("userStatus").equals("-1")){  
                                                          System.out.println("now inside");
                                                    %>
                                                    
                                                    <p style="color: rgba(255, 255, 51, 1);font-size: 17px">Username or Password is incorrect</p>
                                                    <br>
                                                    <%
                                                      }
                                                        }
                                                          %>
                                                    
                                                    
                                                   </td>
					</tr>
                                        <tr>
                                            
                                        </tr>
					<tr>
						<td>
						</td>
                                   
                                                
                                                <td>
							<center>
							 <input type="submit" name="" value="Login">
							</center>
						</td>
					</tr>
				</table>
			</form>
		</div>
</body>
</html>