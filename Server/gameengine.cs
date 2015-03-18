using System;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.IO;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Threading;
using System.Text.RegularExpressions;
using System.Net;
using System.Net.Mail;
using System.Collections.Generic;
using JdSoft.Apple.Apns.Notifications;
using JdSoft.Apple.AppStore;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

[ServiceContract]
[AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
[ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
public partial class GameEngine
{
	Encoding encoding = Encoding.UTF8;
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostReportError", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostReportError(Stream streamdata)
    {
		string result = "0";
		
        StreamReader reader = new StreamReader(streamdata);
    	string sr = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(sr);
    	
    	string error_id = dic["error_id"];
    	string uid = dic["uid"];
    	string json = dic["json"];
    	
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql_command = string.Empty;
            string total = "0";

            if (error_id == "14")
            {
                sql_command = "UPDATE club SET e=energy WHERE uid='" + uid + "'";
            }
            
            if (error_id == "5192348")
            {
                sql_command = "UPDATE club SET currency_second=currency_second+10 WHERE uid='" + uid + "'";
                total = "10";
            }

            if (error_id == "4069157")
            {
                sql_command = "UPDATE club SET currency_second=currency_second+22 WHERE uid='" + uid + "'";
                total = "22";
            }

            if (error_id == "6145148")
            {
                sql_command = "UPDATE club SET currency_second=currency_second+60 WHERE uid='" + uid + "'";
                total = "60";
            }

            if (error_id == "9425144")
            {
                sql_command = "UPDATE club SET currency_second=currency_second+150 WHERE uid='" + uid + "'";
                total = "150";
            }

            if (error_id == "1736703")
            {
                sql_command = "UPDATE club SET currency_second=currency_second+275 WHERE uid='" + uid + "'";
                total = "275";
            }

            if (error_id == "6597164")
            {
                sql_command = "UPDATE club SET currency_second=currency_second+800 WHERE uid='" + uid + "'";
                total = "800";
            }

            if (error_id == "2792559")
            {
                sql_command = "UPDATE club SET currency_second=currency_second+1700 WHERE uid='" + uid + "'";
                total = "1700";
            }

            if (sql_command.Length > 0)
            {
                if (ReceiptVer(json))
                {
                	result = "1";
                	
                    using (SqlCommand cmd = new SqlCommand(sql_command, cn))
                    {
                        cn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    
                    if(!total.Equals("0"))
                    {
                    	using (SqlCommand cmd2 = new SqlCommand("EXEC usp_BuyDiamonds '" + uid + "', " + total, cn))
	    				{
	        				cmd2.ExecuteNonQuery();
	    				}
                    }
                }
                else
                {
                    //Cheat Detected
                }

            }

        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostRegisterSale", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostRegisterSale(Stream streamdata)
    {
		string result = "0";
		
        StreamReader reader = new StreamReader(streamdata);
    	string sr = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(sr);
    	
    	string error_id = dic["error_id"];
    	string uid = dic["uid"];
    	string json = dic["json"];
    	
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql_command = string.Empty;
			sql_command = "EXEC usp_RegisterSale '" + uid + "', " + error_id;

            if (ReceiptVer(json))
            {
            	result = "1";
            	
                using (SqlCommand cmd = new SqlCommand(sql_command, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            else
            {
                //Cheat Detected
            }
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
	[OperationContract]
	[WebInvoke(UriTemplate="/PostMailReply", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public string PostMailReply(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string msg = dic["message"];
    	string club_id = dic["club_id"];
    	string club_name = dic["club_name"];
    	string mail_id = dic["mail_id"];
    	string from_id = dic["from_id"];
    	string reply_counter = dic["reply_counter"];
    	
    	using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	string strSql = "INSERT INTO mail_reply VALUES (" + mail_id + ", GETUTCDATE(), N'" + msg + "', " + club_id + ", N'" + club_name + "')";
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
            
            strSql = "UPDATE mail SET reply_counter=reply_counter+1 WHERE mail_id=" + mail_id;
            using (SqlCommand cmd2 = new SqlCommand(strSql, cn))
            {
                cmd2.ExecuteNonQuery();
            }
            
            if (reply_counter.Equals("0"))
    		{
            	strSql = "INSERT INTO mailclub VALUES (" + mail_id + ", " + from_id + ")";
	            using (SqlCommand cmd3 = new SqlCommand(strSql, cn))
	            {
	                cmd3.ExecuteNonQuery();
	            }
            }
        }
        
        return "Received: " + msg;
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostMailCompose", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public string PostMailCompose(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string msg = dic["message"];
    	string club_id = dic["club_id"];
    	string club_name = dic["club_name"];
    	string is_alliance = dic["is_alliance"];
    	string to_id = dic["to_id"];
    	string to_name = dic["to_name"];
    	string strSql = string.Empty;
    	
    	using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
    		if (is_alliance.Equals("0"))
    		{
        		strSql = "INSERT INTO mail VALUES (GETUTCDATE(), N'', N'" + msg + "', 0, -1, " + to_id + ", N'" + to_name + "', " + club_id + ", N'" + club_name + "', 0, 0)";
    		}
    		else
    		{
    			strSql = "INSERT INTO mail VALUES (GETUTCDATE(), N'', N'" + msg + "', 0, " + to_id + ", " + to_id + ", N'" + to_name + "', " + club_id + ", N'" + club_name + "', 0, 0)";
    		}
        	
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        
        return "Received: " + msg;
	}
	
	[WebGet(UriTemplate = "GetMail/{mail_id}/{club_id}/{alliance_id}")]
    public Stream GetMail(string mail_id, string club_id, string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            strSql = "SELECT * FROM mail LEFT JOIN mailclub ON mail.mail_id=mailclub.mail_id WHERE ( (mailclub.club_id=" + club_id + ") OR (mail.everyone=1) OR (mail.alliance_id=" + alliance_id + ") ) AND mail.mail_id>" + mail_id + " ORDER BY mail.mail_id DESC";

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "DeleteMail/{mail_id}/{club_id}")]
    public Stream DeleteMail(string mail_id, string club_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            strSql = "DELETE FROM mailclub WHERE mail_id=" + mail_id + " AND club_id=" + club_id;

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
				
                string result = "1";
            	Encoding encoding = Encoding.UTF8;
            	WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            	byte[] returnBytes = encoding.GetBytes(result);
           		return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetMailReply/{mail_id}")]
    public Stream GetMailReply(string mail_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            strSql = "SELECT * FROM mail_reply WHERE mail_id=" + mail_id + " ORDER BY reply_id ASC";

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
	
    //END MAIL
    
	[WebGet(UriTemplate = "GetChat1/{last_chat_id}")]
    public Stream GetChat1(string last_chat_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            last_chat_id = last_chat_id.Replace(",", "");
            if (last_chat_id != "0")
            {
                strSql = "SELECT * FROM chat WHERE chat_id>" + last_chat_id + " ORDER BY chat_id ASC";
            }
            else
            {
                strSql = "SELECT * FROM (SELECT TOP 10 * FROM chat ORDER BY chat_id DESC) AS TOP10 ORDER BY chat_id ASC";
            }

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceChat/{last_chat_id}/{alliance_id}")]
    public Stream GetAllianceChat(string last_chat_id, string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            last_chat_id = last_chat_id.Replace(",", "");
            if (last_chat_id != "0")
            {
                strSql = "SELECT * FROM alliance_wall WHERE target_alliance_id=" + alliance_id + " AND chat_id>" + last_chat_id + " ORDER BY chat_id ASC";
            }
            else
            {
                strSql = "SELECT * FROM (SELECT TOP 10 * FROM alliance_wall WHERE target_alliance_id=" + alliance_id + " ORDER BY chat_id DESC) AS TOP10 ORDER BY chat_id ASC";
            }

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceWall/{alliance_id}")]
    public Stream GetAllianceWall(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "SELECT * FROM alliance_wall WHERE target_alliance_id=" + alliance_id + " ORDER BY chat_id ASC";

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [OperationContract]
	[WebInvoke(UriTemplate="/PostChat", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public string PostChat(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string msg = dic["message"];
    	string club_id = dic["club_id"];
    	string club_name = dic["club_name"];
    	string alliance_id = dic["alliance_id"];
    	string alliance_name = dic["alliance_name"];
    	string table_name = dic["table_name"];
    	string target_alliance_id = dic["target_alliance_id"];
    	
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            if (string.Equals(target_alliance_id, "0"))
    		{
            	strSql = "INSERT INTO " + table_name + " VALUES (" + club_id + ", N'" + club_name + "', N'" + msg + "', GETUTCDATE(), " + alliance_id + ", N'" + alliance_name +  "')";
            }
            else
            {
            	strSql = "INSERT INTO alliance_wall VALUES (" + club_id + ", N'" + club_name + "', N'" + msg + "', GETUTCDATE(), " + alliance_id + ", N'" + alliance_name +  "', " + target_alliance_id + ")";
            }
            
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        
        return "Received: " + msg;
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostAllianceEdit", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public string PostAllianceEdit(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string club_id = dic["club_id"];
    	string alliance_id = dic["alliance_id"];
    	string name = dic["name"];
    	string msg = dic["message"];
    	
    	using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	string strSql = "UPDATE alliance SET name=N'" + name + "', introduction_text=N'" + msg + "' WHERE leader_id=" + club_id + " AND alliance_id=" + alliance_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        
        return "Received: " + msg;
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostAllianceCreate", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public string PostAllianceCreate(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string club_id = dic["club_id"];
    	string club_name = dic["club_name"];
    	string name = dic["name"];
    	string msg = dic["message"];
    	
    	using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	string strSql = "INSERT INTO alliance (leader_id, leader_name, name, date_found, alliance_level, currency_first, currency_second, introduction_text) VALUES (" + club_id + ", N'" + club_name + "', N'" + name + "', GETUTCDATE(), 1, 0, 0, N'" + msg + "')";
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        
        return "Received: " + msg;
	}
    
	[WebGet(UriTemplate = "Login/{uid}/{email}/{password}/{latitude}/{longitude}/{devicetoken}")]
    public Stream Login(string uid, string email, string password, string latitude, string longitude, string devicetoken)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	string result = "-1";
        	int count = 0;
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM club WHERE uid LIKE '%" + uid.Substring(1) + "'", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        	
        	if (count == 1) //Replace UID if open from another game_id if only 1 id exists
        	{
		        	string str_sql = "SELECT club_id, club_name, last_login FROM club WHERE uid LIKE '%" + uid.Substring(1) + "' AND password='" + password + "'";
	
		        	if(password == "0")
		        	{
		        		str_sql = "SELECT club_id, club_name, last_login FROM club WHERE uid LIKE '%" + uid.Substring(1) + "'";
		        	}
		        	
		        	using (SqlCommand cmd = new SqlCommand(str_sql, cn))
		        	{
		        		string cid = string.Empty;
		        		string cname = string.Empty;
		        		string last_login = string.Empty;
		        		string sql_update_club = string.Empty;
	
		        		SqlDataReader r1 = cmd.ExecuteReader();
		        		while (r1.Read())
		        		{
		        			if (!(r1.IsDBNull(0)))
		        			{
		        				cid = r1["club_id"].ToString();
		        				cname = r1["club_name"].ToString();
		        				last_login = r1["last_login"].ToString();
		        			}
		        		}
		        		r1.Close();
	
		        		if ((cid.Length > 0) && (cid != "0"))
		        		{
		        			result = "0"; //No dailly login bonus
		        			sql_update_club = "UPDATE club SET last_login=GETDATE(), latitude=" + latitude + ", longitude=" + longitude + ", devicetoken='" + devicetoken + "', email='" + email + "', uid='" + uid + "' WHERE uid LIKE '%" + uid.Substring(1) + "'";
		        			
		        			Thread oThread = new Thread(new ParameterizedThreadStart(ExecuteNonQuery));
		        			oThread.Start(sql_update_club);
	
		        			Thread oThread2 = new Thread(new ParameterizedThreadStart(ExecuteNonQuery));
		        			oThread2.Start("INSERT INTO chat VALUES (" + cid + ", '" + cname + "', 'Manager has just logged in...', GETUTCDATE(), 0, '')");
		        		}
		        	}
        	} 
        	else if (count > 1) //Do not replace UID
        	{
		        	string str_sql = "SELECT club_id, club_name, last_login FROM club WHERE uid = '" + uid + "' AND password='" + password + "'";
	
		        	if(password == "0")
		        	{
		        		str_sql = "SELECT club_id, club_name, last_login FROM club WHERE uid = '" + uid + "'";
		        	}
		        	
		        	using (SqlCommand cmd = new SqlCommand(str_sql, cn))
		        	{
		        		string cid = string.Empty;
		        		string cname = string.Empty;
		        		string last_login = string.Empty;
		        		string sql_update_club = string.Empty;
	
		        		SqlDataReader r1 = cmd.ExecuteReader();
		        		while (r1.Read())
		        		{
		        			if (!(r1.IsDBNull(0)))
		        			{
		        				cid = r1["club_id"].ToString();
		        				cname = r1["club_name"].ToString();
		        				last_login = r1["last_login"].ToString();
		        			}
		        		}
		        		r1.Close();
	
		        		if ((cid.Length > 0) && (cid != "0"))
		        		{
		        			result = "0"; //No dailly login bonus
		        			sql_update_club = "UPDATE club SET last_login=GETDATE(), latitude=" + latitude + ", longitude=" + longitude + ", devicetoken='" + devicetoken + "', email='" + email + "' WHERE uid='" + uid + "'";
		        			
		        			Thread oThread = new Thread(new ParameterizedThreadStart(ExecuteNonQuery));
		        			oThread.Start(sql_update_club);
	
		        			Thread oThread2 = new Thread(new ParameterizedThreadStart(ExecuteNonQuery));
		        			oThread2.Start("INSERT INTO chat VALUES (" + cid + ", '" + cname + "', 'Manager has just logged in...', GETUTCDATE(), 0, '')");
		        		}
		        	}
        	}

            Encoding encoding = Encoding.GetEncoding("ISO-8859-1");
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes = encoding.GetBytes(result);
            return new MemoryStream(returnBytes);

        }
    }

    [WebGet(UriTemplate = "Register2/{game_id}/{uid}/{password}/{fid}/{email}/{name}/{username}/{gender}/{timezone}/{devicetoken}")]
    public Stream Register2(string game_id, string uid, string password, string fid, string email, string name, string username, string gender, string timezone, string devicetoken)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	int count = 0;
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM club WHERE uid LIKE '%" + uid.Substring(1) + "'", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        	
        	if (count == 0)
        	{
        		if (string.Equals(uid, Global.LastRegister))
        		{
					//Duplicate UID
        		}
        		else
        		{
	        		string s = "UPDATE TOP(1) club SET email='" + email + "', password='" + password + "', last_login=GETUTCDATE(), date_found=GETUTCDATE(), game_id='" + game_id + "', uid='" + uid + "', devicetoken='" + devicetoken + "' WHERE uid='0'";
	        		
	        		if(fid != "0")
	        		{
	        			s = "UPDATE TOP(1) club SET fb_name='" + name + "', face_pic='http://graph.facebook.com/" + fid + "/picture?type=large', fb_pic='http://graph.facebook.com/" + fid + "/picture?type=large', fb_id='" + fid + "', fb_username='" + username + "', fb_gender='" + gender + "', fb_timezone='" + timezone + "', email='" + email + "', password='" + password + "', last_login=GETUTCDATE(), date_found=GETUTCDATE(), game_id='" + game_id + "', uid='" + uid + "', devicetoken='" + devicetoken + "' WHERE uid='0'";
	        		}
	        		
		            using (SqlCommand cmd = new SqlCommand(s, cn))
		            {
		                int rowsUpdatedCount = cmd.ExecuteNonQuery();
		                if (rowsUpdatedCount > 0)
		                {
		                	Global.LastRegister = uid;
		                	using (SqlCommand cmd2 = new SqlCommand("EXEC usp_ResetClub '" + uid + "'", cn))
		                	{
		                    	cmd2.ExecuteNonQuery();
		                	}
		                }
		            }
        		}
        	}
        	else
        	{
        		//Replace UID on other GAME_ID to this GAME_ID
        		string s = "UPDATE TOP(1) club SET email='" + email + "', password='" + password + "', last_login=GETUTCDATE(), date_found=GETUTCDATE(), game_id='" + game_id + "', uid='" + uid + "', devicetoken='" + devicetoken + "' WHERE uid LIKE '%" + uid.Substring(1) + "'";
	            using (SqlCommand cmd = new SqlCommand(s, cn))
	            {
	            	cmd.ExecuteNonQuery();
	            	//DONT RESET CLUB
	            }
	            
        	}
        	
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetPassword/{guid}")]
    public Stream GetPassword(string guid)
    {
    	string result = "0";
    	string request_uid = "0";
    	string hmac_password = "0";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd = new SqlCommand("SELECT request_uid FROM password_request WHERE request_id='" + guid + "'", cn))
            {
                SqlDataReader r1 = cmd.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        request_uid = r1["request_uid"].ToString();
                    }
                }
                r1.Close();
	        }
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT password FROM club WHERE uid='" + request_uid + "'", cn))
            {
                SqlDataReader r1 = cmd.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        hmac_password = r1["password"].ToString();
                    }
                }
                r1.Close();
	        }
        	
        	result = "Your password is: " + ConvertHexToString(hmac_password);
        	
        }

        Encoding encoding = Encoding.GetEncoding("ISO-8859-1");
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    public string ConvertHexToString(string HexValue)
	{
	    string StrValue = "";
	    while (HexValue.Length > 0)
	    {
	        StrValue += System.Convert.ToChar(System.Convert.ToUInt32(HexValue.Substring(0, 2), 16)).ToString();
	        HexValue = HexValue.Substring(2, HexValue.Length - 2);
	    }
	    return StrValue;
	}
    
    public string SendMessage(string mailTo, string subject, string body)
	{
    	string result = "1";
    	
    	MailMessage mailObj = new MailMessage("support@tapfantasy.com", mailTo, subject, body);
        SmtpClient smtp = new SmtpClient("smtp.elasticemail.com");
        
        //smtp.Host = "37.220.10.138";
        //smtp.UseDefaultCredentials = true;
        smtp.Credentials = new System.Net.NetworkCredential("support@tapfantasy.com", "810d7bec-524c-4bed-ad92-7ddbecc51b22");
        smtp.Port = 2525;
        //smtp.EnableSsl = true;
        //smtp.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
        //smtp.Credentials = CredentialCache.DefaultNetworkCredentials;
		//smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        
        try
        {
        	smtp.Send(mailObj);
        }
        catch (Exception ex)
        {
            result = ex.ToString();
        }
        
        return result;
	}
	
    [WebGet(UriTemplate = "CurrentTime")]
    public Stream CurrentTime()
    {
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(String.Format("{0:dd/MM/yyyy HH:mm:ss}", DateTime.UtcNow));
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "Updateuser/{uid_new}/{uid_old}")]
    public Stream Updateuser(string uid_new, string uid_old)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("UPDATE club SET uid='" + uid_new + "' WHERE uid='" + uid_old + "'", cn))
            {
                cmd1.ExecuteNonQuery();
                result = "1";
            }
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "CheckUID/{uid}")]
    public Stream CheckUID(string uid) //Facebook App specefic
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id FROM club WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                string cid = string.Empty;
                string result = "0";

                SqlDataReader r1 = cmd.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        cid = r1["club_id"].ToString();
                    }
                }
                r1.Close();

                if ((cid.Length > 0) && (cid != "0"))
                {
                	result = "1";
                }
                
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    private static string PostRequest(string url, string postData)
    {
        byte[] byteArray = Encoding.UTF8.GetBytes(postData);
        return PostRequest(url, byteArray);
    }

    private static string PostRequest(string url, byte[] byteArray)
    {
        try
        {
            WebRequest request = HttpWebRequest.Create(url);
            request.Method = "POST";
            request.ContentLength = byteArray.Length;
            request.ContentType = "text/plain";

            using (System.IO.Stream dataStream = request.GetRequestStream())
            {
                dataStream.Write(byteArray, 0, byteArray.Length);
                dataStream.Close();
            }

            using (WebResponse r = request.GetResponse())
            {
                using (System.IO.StreamReader sr = new System.IO.StreamReader(r.GetResponseStream()))
                {
                    return sr.ReadToEnd();
                }
            }
        }
        catch (Exception ex)
        {
            return string.Empty;
        }
    }
    
    private bool ReceiptVer(string receiptData)
	{
	    string returnmessage = "";
	    try
	    {
	        var json = new JObject(new JProperty("receipt-data", receiptData)).ToString();
			
	        ASCIIEncoding ascii = new ASCIIEncoding();
	        byte[] postBytes = Encoding.UTF8.GetBytes(json);
			
	        string url_1 = "https://sandbox.itunes.apple.com/verifyReceipt";
        	string url_2 = "https://buy.itunes.apple.com/verifyReceipt";
        	
	        var request = HttpWebRequest.Create(url_2);
	        request.Method = "POST";
	        request.ContentType = "application/json";
	        request.ContentLength = postBytes.Length;
			
	        using (var stream = request.GetRequestStream())
	        {
	            stream.Write(postBytes, 0, postBytes.Length);
	            stream.Flush();
	        }
			
	        var sendresponse = request.GetResponse();
			
	        string sendresponsetext = "";
	        using (var streamReader = new StreamReader(sendresponse.GetResponseStream()))
	        {
	            sendresponsetext = streamReader.ReadToEnd().Trim();
	        }
	        returnmessage = sendresponsetext;
			
	    }
	    catch (Exception ex)
	    {
	        ex.Message.ToString();
	    }
	    
	    var o = JObject.Parse(returnmessage);
		int status = (int)o["status"];
		
		bool result = false;
		if (status == 0)
		{
			result = true;
		}
	    
		return result;
    }
	
    private bool ReceiptVerify(string uid, string receiptData)
    {
    	string url_1 = "https://sandbox.itunes.apple.com/verifyReceipt";
        string url_2 = "https://buy.itunes.apple.com/verifyReceipt";
        bool result = false;
        string toPost = string.Format(@"{{""receipt-data"":""{0}""}}", receiptData);
        Receipt receipt = null;

        string post = PostRequest(url_2, toPost);

        if (!string.IsNullOrEmpty(post))
        {
            try { receipt = new Receipt(post); }
            catch { receipt = null; }
        }

        if (receipt != null && receipt.Status == 0)
        {
            string rid = "0";
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                cn.Open();

                using (SqlCommand cmd1 = new SqlCommand("SELECT receipt_id FROM receipt WHERE transaction_id='" + receipt.TransactionId.Trim('"') + "'", cn))
                {
                    SqlDataReader r1 = cmd1.ExecuteReader();
                    while (r1.Read())
                    {
                        if (!(r1.IsDBNull(0)))
                        {
                            rid = r1["receipt_id"].ToString();
                        }
                    }
                    r1.Close();

                    if ((rid.Length > 0) && (rid != "0"))
                    {
                        //Duplicate receipt
                        result = false;
                    }
                    else
                    {
                        string strSql = "INSERT INTO receipt VALUES ('" + uid + "', '" + receipt.TransactionId.Trim('"') + "', '" + receipt.ProductId.Trim('"') + "', '" + receipt.PurchaseDate + "')";
                        using (SqlCommand cmd2 = new SqlCommand(strSql, cn))
                        {
                            cmd2.ExecuteNonQuery();
                        }
                        result = true;
                    }
                }
            }
        }
        else
        {
            result = false;
        }

        return result;
    }

    [WebGet(UriTemplate = "ReceiptTest/{receiptData}")]
    public Stream ReceiptTest(string receiptData)
    {
        string result = "0";

        if (ReceiptVerify("0", receiptData))
        {
            result = "1";
        }
        else
        {
            result = "0";
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "receipt/{receiptData}")]
    public Stream receipt(string receiptData)
    {
        string url_1 = "https://sandbox.itunes.apple.com/verifyReceipt";
        string url_2 = "https://buy.itunes.apple.com/verifyReceipt";
        string result = "1";
        string toPost = string.Format(@"{{""receipt-data"":""{0}""}}", receiptData);
        Receipt receipt = null;

        string post = PostRequest(url_2, toPost);

        if (!string.IsNullOrEmpty(post))
        {
            try { receipt = new Receipt(post); }
            catch { receipt = null; }
        }

        if (receipt != null && receipt.Status == 0)
        {
            StringBuilder s = new StringBuilder();
            //s.AppendLine("RECEIPT DATA:");
            //s.AppendLine(string.Format("  Bvrs: {0}", receipt.Bvrs));
            //s.AppendLine(string.Format("  OriginalPurchaseDate: {0}", receipt.OriginalPurchaseDate));
            //s.AppendLine(string.Format("  OriginalTransactionId: {0}", receipt.OriginalTransactionId));
            //s.AppendLine(string.Format("  Quantity: {0}", receipt.Quantity));
            s.AppendLine(string.Format("  ProductId: {0}", receipt.ProductId.Trim('"')));
            s.AppendLine(string.Format("  PurchaseDate: {0}", receipt.PurchaseDate));
            s.AppendLine(string.Format("  TransactionId: {0}", receipt.TransactionId.Trim('"')));

            result = s.ToString();
        }
        else
        {
            result = "0";
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "BuyProductNew/{isVirtualMoney}/{product_id}/{uid}/{json}")]
    public Stream BuyProductNew(string isVirtualMoney, string product_id, string uid, string json)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT sql_command, price_virtual, price_real FROM product WHERE product_id=" + product_id, cn))
            {
                string sql_command = string.Empty;
                string price_virtual = string.Empty;
                string price_real = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!(r.IsDBNull(0)))
                    {
                        sql_command = r["sql_command"].ToString();
                    }
                    if (!(r.IsDBNull(1)))
                    {
                        price_virtual = r["price_virtual"].ToString();
                    }
                    if (!(r.IsDBNull(2)))
                    {
                        price_real = r["price_real"].ToString();
                    }
                }
                r.Close();

                string where_command = string.Empty;

                if (sql_command.Length > 1)
                {
                    if (isVirtualMoney == "1") //USE 1st currency
                    {
                        where_command = ", expenses_purchases=expenses_purchases+" + price_virtual + ", expenses_total=expenses_total+" + price_virtual + ", balance=balance-" + price_virtual + " WHERE uid='" + uid + "' AND balance>=" + price_virtual;
                        if(int.Parse(product_id) < 12)
                        {
                        	where_command = ", e=e-10" + where_command + " AND e >= 9";
                        }
                        using (SqlCommand cmd2 = new SqlCommand(sql_command + where_command, cn))
                        {
                            cmd2.ExecuteNonQuery();
                        }
                    }
                    else if (isVirtualMoney == "2") //USE 2nd currency
                    {
                        where_command = ", currency_second=currency_second-" + price_real + " WHERE uid='" + uid + "' AND currency_second>=" + price_real;
                        using (SqlCommand cmd2 = new SqlCommand(sql_command + where_command, cn))
                        {
                            cmd2.ExecuteNonQuery();
                        }
                    }
                    else 
                    {
                        if (ReceiptVerify(uid, json))
                        {
                            where_command = " WHERE uid='" + uid + "'";
                            using (SqlCommand cmd2 = new SqlCommand(sql_command + where_command, cn))
                            {
                                cmd2.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            //Cheat Detected
                        }
                    }
                }
                else
                {
                    if (isVirtualMoney == "1")
                    {
                        where_command = "UPDATE club SET expenses_purchases=expenses_purchases+" + price_virtual + ", expenses_total=expenses_total+" + price_virtual + ", balance=balance-" + price_virtual + " WHERE uid='" + uid + "' AND balance>=" + price_virtual;

                        using (SqlCommand cmd3 = new SqlCommand(where_command, cn))
                        {
                            cmd3.ExecuteNonQuery();
                        }
                    } 
                    else if (isVirtualMoney == "2") //USE 2nd Currency
                    {
                        where_command = "UPDATE club SET currency_second=currency_second-" + price_real + " WHERE uid='" + uid + "' AND currency_second>=" + price_real;

                        using (SqlCommand cmd3 = new SqlCommand(where_command, cn))
                        {
                            cmd3.ExecuteNonQuery();
                        }
                    }

                }

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "DoSlot/{uid}/{bet}")]
    public Stream DoSlot(string uid, string bet)
    {
    	Random rnd = new Random();
		int random_win = rnd.Next(0, 35);
		
		int input_bet = int.Parse(bet);
		
		if ((random_win == 8) || (random_win == 10)) //Harder to get jackpot
		{
			random_win = rnd.Next(4, 10);
		}
		
		if ((random_win == 0) || (random_win == 5) || (random_win == 7) || (random_win == 9)) //No Rewards
		{
			random_win = rnd.Next(1, 3);
		}
		
		int total_win = random_win * input_bet;
		
		if (random_win > 10) //No Rewards
		{
			total_win = 0;
		}
		
		string result = random_win.ToString();
    	
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql_command = string.Empty;
            
            sql_command = "UPDATE club SET xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5, currency_second=currency_second-" + bet + "+" + total_win.ToString() + " WHERE uid='" + uid + "'";

            using (SqlCommand cmd = new SqlCommand(sql_command, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
            
            if (total_win > 0) //Rewards
			{
           		using (SqlCommand cmd2 = new SqlCommand("EXEC usp_DoSlot '" + uid + "'", cn))
		    	{
		        	cmd2.ExecuteNonQuery();
		    	}
            }
        }
        
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "ReportError/{error_id}/{uid}/{json}")]
    public Stream ReportError(string error_id, string uid, string json)
    {
        if (int.Parse(error_id) > 0)
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string sql_command = string.Empty;
                string total = "0";

                if (error_id == "14")
                {
                    sql_command = "UPDATE club SET e=energy WHERE uid='" + uid + "'";
                }
                
                if (error_id == "5192348")
                {
                    sql_command = "UPDATE club SET currency_second=currency_second+10 WHERE uid='" + uid + "'";
                    total = "10";
                }

                if (error_id == "4069157")
                {
                    sql_command = "UPDATE club SET currency_second=currency_second+22 WHERE uid='" + uid + "'";
                    total = "22";
                }

                if (error_id == "6145148")
                {
                    sql_command = "UPDATE club SET currency_second=currency_second+60 WHERE uid='" + uid + "'";
                    total = "60";
                }

                if (error_id == "9425144")
                {
                    sql_command = "UPDATE club SET currency_second=currency_second+150 WHERE uid='" + uid + "'";
                    total = "150";
                }

                if (error_id == "1736703")
                {
                    sql_command = "UPDATE club SET currency_second=currency_second+275 WHERE uid='" + uid + "'";
                    total = "275";
                }

                if (error_id == "6597164")
                {
                    sql_command = "UPDATE club SET currency_second=currency_second+800 WHERE uid='" + uid + "'";
                    total = "800";
                }

                if (error_id == "2792559")
                {
                    sql_command = "UPDATE club SET currency_second=currency_second+1700 WHERE uid='" + uid + "'";
                    total = "1700";
                }

                if (sql_command.Length > 0)
                {
                    if (ReceiptVerify(uid, json))
                    {
                        using (SqlCommand cmd = new SqlCommand(sql_command, cn))
                        {
                            cn.Open();
                            cmd.ExecuteNonQuery();
                        }
                        
                        if(!total.Equals("0"))
                        {
                        	using (SqlCommand cmd2 = new SqlCommand("EXEC usp_BuyDiamonds '" + uid + "', " + total, cn))
		    				{
		        				cmd2.ExecuteNonQuery();
		    				}
                        }
                    }
                    else
                    {
                        //Cheat Detected
                    }

                }

            }
        }
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "DoJobNew/{uid}/{xp_gain}/{time}")]
    public Stream DoJobNew(string uid, string xp_gain, string time)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql = string.Empty;

            switch (xp_gain)
            {
                case "1":
                    sql = "UPDATE club SET e=e-1, xp=xp+1, xp_gain=xp_gain+1, xp_gain_a=xp_gain_a+1 WHERE uid='" + uid + "' AND e >= 1";
                    break;
                case "3":
                    sql = "UPDATE club SET e=e-2, xp=xp+3, xp_gain=xp_gain+3, xp_gain_a=xp_gain_a+3 WHERE uid='" + uid + "' AND e >= 2";
                    break;
                case "5":
                    sql = "UPDATE club SET e=e-3, xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5 WHERE uid='" + uid + "' AND e >= 3";
                    break;
                case "7":
                    sql = "UPDATE club SET e=e-4, xp=xp+7, xp_gain=xp_gain+7, xp_gain_a=xp_gain_a+7 WHERE uid='" + uid + "' AND e >= 4";
                    break;
                case "9":
                    sql = "UPDATE club SET e=e-5, xp=xp+9, xp_gain=xp_gain+9, xp_gain_a=xp_gain_a+9 WHERE uid='" + uid + "' AND e >= 5";
                    break;
                case "11":
                    sql = "UPDATE club SET e=e-6, xp=xp+11, xp_gain=xp_gain+11, xp_gain_a=xp_gain_a+11 WHERE uid='" + uid + "' AND e >= 6";
                    break;
                case "13":
                    sql = "UPDATE club SET e=e-7, xp=xp+13, xp_gain=xp_gain+13, xp_gain_a=xp_gain_a+13 WHERE uid='" + uid + "' AND e >= 7";
                    break;
                case "15":
                    sql = "UPDATE club SET e=e-8, xp=xp+15, xp_gain=xp_gain+15, xp_gain_a=xp_gain_a+15 WHERE uid='" + uid + "' AND e >= 8";
                    break;
                case "10":
                    sql = "UPDATE club SET e=e-5, xp=xp+10, xp_gain=xp_gain+10, xp_gain_a=xp_gain_a+10 WHERE uid='" + uid + "' AND e >= 5";
                    break;
                case "12":
                    sql = "UPDATE club SET e=e-6, xp=xp+12, xp_gain=xp_gain+12, xp_gain_a=xp_gain_a+12 WHERE uid='" + uid + "' AND e >= 6";
                    break;
                case "14":
                    sql = "UPDATE club SET e=e-7, xp=xp+14, xp_gain=xp_gain+14, xp_gain_a=xp_gain_a+14 WHERE uid='" + uid + "' AND e >= 7";
                    break;
                case "16":
                    sql = "UPDATE club SET e=e-8, xp=xp+16, xp_gain=xp_gain+16, xp_gain_a=xp_gain_a+16 WHERE uid='" + uid + "' AND e >= 8";
                    break;
                case "18":
                    sql = "UPDATE club SET e=e-9, xp=xp+18, xp_gain=xp_gain+18, xp_gain_a=xp_gain_a+18 WHERE uid='" + uid + "' AND e >= 9";
                    break;
                case "20":
                    sql = "UPDATE club SET e=e-10, xp=xp+20, xp_gain=xp_gain+20, xp_gain_a=xp_gain_a+20 WHERE uid='" + uid + "' AND e >= 10";
                    break;
                case "22":
                    sql = "UPDATE club SET e=e-11, xp=xp+22, xp_gain=xp_gain+22, xp_gain_a=xp_gain_a+22 WHERE uid='" + uid + "' AND e >= 11";
                    break;
                case "24":
                    sql = "UPDATE club SET e=e-12, xp=xp+24, xp_gain=xp_gain+24, xp_gain_a=xp_gain_a+24 WHERE uid='" + uid + "' AND e >= 12";
                    break;
                case "19":
                    sql = "UPDATE club SET e=e-9, xp=xp+19, xp_gain=xp_gain+19, xp_gain_a=xp_gain_a+19 WHERE uid='" + uid + "' AND e >= 9";
                    break;
                case "21":
                    sql = "UPDATE club SET e=e-10, xp=xp+21, xp_gain=xp_gain+21, xp_gain_a=xp_gain_a+21 WHERE uid='" + uid + "' AND e >= 10";
                    break;
                case "23":
                    sql = "UPDATE club SET e=e-11, xp=xp+23, xp_gain=xp_gain+23, xp_gain_a=xp_gain_a+23 WHERE uid='" + uid + "' AND e >= 11";
                    break;
                case "25":
                    sql = "UPDATE club SET e=e-12, xp=xp+25, xp_gain=xp_gain+25, xp_gain_a=xp_gain_a+25 WHERE uid='" + uid + "' AND e >= 12";
                    break;
                case "27":
                    sql = "UPDATE club SET e=e-13, xp=xp+27, xp_gain=xp_gain+27, xp_gain_a=xp_gain_a+27 WHERE uid='" + uid + "' AND e >= 13";
                    break;
                case "29":
                    sql = "UPDATE club SET e=e-14, xp=xp+29, xp_gain=xp_gain+29, xp_gain_a=xp_gain_a+29 WHERE uid='" + uid + "' AND e >= 14";
                    break;
                case "31":
                    sql = "UPDATE club SET e=e-15, xp=xp+31, xp_gain=xp_gain+31, xp_gain_a=xp_gain_a+31 WHERE uid='" + uid + "' AND e >= 15";
                    break;
                case "33":
                    sql = "UPDATE club SET e=e-16, xp=xp+33, xp_gain=xp_gain+33, xp_gain_a=xp_gain_a+33 WHERE uid='" + uid + "' AND e >= 16";
                    break;
                default:
                    sql = "UPDATE club SET balance=balance-10000, xp=xp-1000 WHERE uid='" + uid + "'";
                    break;
            }

            using (SqlCommand cmd = new SqlCommand(sql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "HarvestNew/{uid}/{id}/{time}")]
    public Stream HarvestNew(string uid, string id, string time)
    {
        string cheat_sql = string.Empty;
        string sql = string.Empty;
        if (id.Equals("1")) //Hotel
        {
            cheat_sql = @"SELECT xp FROM club WHERE building1_dt<GETUTCDATE()-1 AND uid='" + uid + "'";
            sql = @"UPDATE club SET balance=balance+dbo.fx_minOf(10000, stadium+(building1*building1)), building1_dt=GETUTCDATE() WHERE building1_dt<GETUTCDATE()-1 AND uid='" + uid + "'";
        }
        if (id.Equals("2")) //Retail
        {
            cheat_sql = @"SELECT xp FROM club WHERE building2_dt<DATEADD(hh, -8, GETUTCDATE()) AND uid='" + uid + "'";
            sql = @"UPDATE club SET balance=balance+dbo.fx_minOf(5000, (building2*stadium)), building2_dt=GETUTCDATE() WHERE building2_dt<DATEADD(hh, -8, GETUTCDATE()) AND uid='" + uid + "'";
        }
        if (id.Equals("3")) //Office
        {
            cheat_sql = @"SELECT xp FROM club WHERE building3_dt<DATEADD(hh, -1, GETUTCDATE()) AND uid='" + uid + "'";
            sql = @"UPDATE club SET balance=balance+dbo.fx_minOf(1000, building2+stadium+(building3*building1)), building3_dt=GETUTCDATE() WHERE building3_dt<DATEADD(hh, -1, GETUTCDATE()) AND uid='" + uid + "'";
        }

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(cheat_sql, cn))
            {
                string pvalue = string.Empty;
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!(r.IsDBNull(0)))
                    {
                        pvalue = r["xp"].ToString();
                    }
                }
                r.Close();

                if ((pvalue.Length > 0) && (int.Parse(pvalue) > -1))
                {
                    using (SqlCommand cmd2 = new SqlCommand(sql, cn))
                    {
                        cmd2.ExecuteNonQuery();
                    }
                }
                else //CHEAT DETECTED
                {
                    cheat_sql = @"SELECT xp FROM club WHERE building" + id + "_dt<DATEADD(ss, -10, GETUTCDATE()) AND uid='" + uid + "'";
                    using (SqlCommand cmd3 = new SqlCommand(cheat_sql, cn))
                    {
                        string pvalue2 = string.Empty;
                        SqlDataReader r2 = cmd3.ExecuteReader();
                        while (r2.Read())
                        {
                            if (!(r2.IsDBNull(0)))
                            {
                                pvalue2 = r2["xp"].ToString();
                            }
                        }
                        r2.Close();

                        if ((pvalue2.Length > 0) && (int.Parse(pvalue2) > -1))
                        {
                            string strSql = "INSERT INTO admin_block VALUES ('" + uid + "')";
                            using (SqlCommand cmd4 = new SqlCommand(strSql, cn))
                            {
                                cmd4.ExecuteNonQuery();
                            }
                        }
                    }

                }
            }
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "CreateChallenge/{uid}/{club_id}/{win}/{lose}/{draw}/{note}")]
    public Stream CreateChallenge(string uid, string club_id, string win, string lose, string draw, string note)
    {
        string result = "1";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("EXECUTE usp_MatchFriendly '" + uid + "' ," + club_id + " ," + win + " ," + lose + " ," + draw + " ,N'" + note + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                SendChallengedPushMessage(uid, club_id);
            }
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "UpdatePurchases/{uid}/{price}")]
    public Stream UpdatePurchases(string uid, string price)
    {
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "SellPlayers/{uid}/{player_value}/{player_id}")]
    public Stream SellPlayers(string uid, string player_value, string player_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT player.player_value FROM player INNER JOIN club ON player.club_id=club.club_id WHERE club.uid='" + uid + "' AND player.player_id=" + player_id, cn))
            {
                string pvalue = string.Empty;
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!(r.IsDBNull(0)))
                    {
                        pvalue = r["player_value"].ToString();
                    }
                }
                r.Close();

                if ((pvalue.Length > 0) && (pvalue != "0"))
                {
                    using (SqlCommand cmd2 = new SqlCommand("UPDATE player SET club_id=0 WHERE player_id=" + player_id, cn))
                    {
                        cmd2.ExecuteNonQuery();

                        int halfpvalue = int.Parse(pvalue) / 2;

                        string sql_command = "UPDATE club SET xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5, e=e-10, revenue_sales=revenue_sales+" + halfpvalue.ToString() + ", revenue_total=revenue_total+" + halfpvalue.ToString() + ", balance=balance+" + halfpvalue.ToString() + " WHERE uid='" + uid + "' AND e >= 9";
                        using (SqlCommand cmd3 = new SqlCommand(sql_command, cn))
                        {
                            cmd3.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "EnergizePlayer/{uid}/{player_id}")]
    public Stream EnergizePlayer(string uid, string player_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("UPDATE player SET fitness=fitness+10 WHERE fitness<192 AND player_id=" + player_id, cn))
            {
                cmd1.ExecuteNonQuery();
                
                using (SqlCommand cmd2 = new SqlCommand("EXEC usp_PlayerEnergize '" + uid + "', " + player_id, cn))
                {
                    cmd2.ExecuteNonQuery();
                }

                result = "1";
            }
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "HealPlayer/{uid}/{player_id}")]
    public Stream HealPlayer(string uid, string player_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("UPDATE player SET player_condition_days=player_condition_days-1 WHERE player_condition_days>0 AND player_id=" + player_id, cn))
            {
                cmd1.ExecuteNonQuery();
                
                using (SqlCommand cmd2 = new SqlCommand("EXEC usp_PlayerHeal '" + uid + "', " + player_id, cn))
                {
                    cmd2.ExecuteNonQuery();
                }
                
                result = "1";
            }
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "BuyCoachs/{uid}/{coach_id}")]
    public Stream BuyCoachs(string uid, string coach_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand("SELECT coach_value FROM coach WHERE coach_id=" + coach_id, cn))
            {
                string coach_value = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!(r.IsDBNull(0)))
                    {
                        coach_value = r["coach_value"].ToString();
                    }
                }
                r.Close();

            	using (SqlCommand cmd2 = new SqlCommand("UPDATE club SET coach_id=" + coach_id + ", balance=balance-" + coach_value + " WHERE uid='" + uid + "' AND balance>=" + coach_value, cn))
            	{
                	cmd2.ExecuteNonQuery();

                	string result = "1";
                	Encoding encoding = Encoding.UTF8;
                	WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                	byte[] returnBytes = encoding.GetBytes(result);
                	return new MemoryStream(returnBytes);
           	 	}
        	}
        }
    }

    [WebGet(UriTemplate = "GetChallengeds/{uid}")]
    public Stream GetChallengeds(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 6 match_id, match_type_id, challenge_datetime, challenge_note, challenge_win, challenge_lose, challenge_draw, club_home, club_home_name, club_away, club_away_name FROM View_Match WHERE club_home_uid='" + uid + "' AND match_type_id=3 AND match_played=0 ORDER BY challenge_datetime DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetChallenge/{uid}")]
    public Stream GetChallenge(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 6 match_id, match_type_id, challenge_datetime, challenge_note, challenge_win, challenge_lose, challenge_draw, club_home, club_home_name, club_away, club_away_name FROM View_Match WHERE club_away_uid='" + uid + "' AND match_type_id=3 AND match_played=0 ORDER BY challenge_datetime DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMatchPlayeds/{uid}")]
    public Stream GetMatchPlayeds(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 20 match_id, match_type_id, match_datetime, club_home, club_home_name, club_away, club_away_name, club_winner, club_loser, home_score, away_score, challenge_win, challenge_lose, spectators, ticket_sales FROM View_Match WHERE (club_home_uid = '" + uid + "' OR club_away_uid = '" + uid + "') AND match_played = 1 AND match_datetime > GETUTCDATE()-30 ORDER BY match_id DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMatchPlayedTops/{uid}")]
    public Stream GetMatchPlayedTops(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 match_id, match_type_id, match_datetime, club_home, club_home_name, club_away, club_away_name, club_winner, club_loser, home_score, away_score FROM View_Match WHERE (club_home_uid = '" + uid + "' OR club_away_uid = '" + uid + "') AND match_played = 1 ORDER BY match_datetime DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMatchUpcomings/{uid}")]
    public Stream GetMatchUpcomings(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 10 match_id, match_type_id, match_datetime, club_home, club_home_name, club_away, club_away_name FROM View_Match WHERE (club_home_uid = '" + uid + "' OR club_away_uid = '" + uid + "') AND match_type_id <> 3 AND match_played = 0 ORDER BY match_datetime ASC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMatchUpcomingTops/{uid}")]
    public Stream GetMatchUpcomingTops(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 match_id, match_type_id, match_datetime, club_home, club_home_name, club_away, club_away_name FROM View_Match WHERE (club_home_uid = '" + uid + "' OR club_away_uid = '" + uid + "') AND match_type_id <> 3 AND match_played = 0 ORDER BY match_datetime ASC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "AcceptChallenge/{match_id}/{uid}")]
    public Stream AcceptChallenge(string match_id, string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE match SET match_played=1 WHERE match_played=0 AND match_id=" + match_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                Thread t = new Thread(new ParameterizedThreadStart(SendAcceptChallengePushMessage));
                t.Start(match_id);
            }
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "AcceptChallenge2/{match_id}/{uid}")]
    public Stream AcceptChallenge2(string match_id, string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand("SELECT club_id FROM club WHERE uid='" + uid + "'", cn))
            {
                string club_id = "0";

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!(r.IsDBNull(0)))
                    {
                        club_id = r["club_id"].ToString();
                    }
                }
                r.Close();
                
                if(int.Parse(club_id) > 0)
                {
		            using (SqlCommand cmd1 = new SqlCommand("UPDATE match SET match_played=1 WHERE match_played=0 AND club_away=" + club_id + " AND match_id=" + match_id, cn))
		            {
		                cmd1.ExecuteNonQuery();
		
		                Thread t = new Thread(new ParameterizedThreadStart(SendAcceptChallengePushMessage));
		                t.Start(match_id);
		            }
                }
        	}
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "DeclineChallenge/{match_id}/{uid}")]
    public Stream DeclineChallenge(string match_id, string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand("DELETE match WHERE match_id=" + match_id, cn))
            {
                cn.Open();
				cmd.ExecuteNonQuery();
        	}
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    private void SendAcceptChallengePushMessage(object match_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT match.home_score, match.away_score, match.ticket_sales, club.game_id, club.devicetoken FROM match INNER JOIN club ON club.club_id=match.club_home WHERE match_id=" + match_id.ToString(), cn))
            {
                string gameid = string.Empty;
                string devtoken = string.Empty;
                string homescore = string.Empty;
                string awayscore = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    gameid = r["game_id"].ToString();
                    devtoken = r["devicetoken"].ToString();

                    homescore = r["home_score"].ToString();
                    awayscore = r["away_score"].ToString();
                }
                r.Close();

                string pushMessage = "Your challenge has been accepted. The score is " + homescore + "-" + awayscore;
                this.Push(gameid, devtoken, pushMessage);
            }
        }
    }

    [WebGet(UriTemplate = "PushNewsClub")]
    public Stream PushNewsClub()
    {
        string result = "1";
        Thread oThread = new Thread(new ThreadStart(PushNewsClubs));
        oThread.Start();

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    private void PushNewsClubs()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql = @"SELECT news.headline, club.game_id, club.devicetoken FROM news inner join club ON news.club_id=club.club_id 
                WHERE club.devicetoken!='(null)' AND club.devicetoken!='' AND club.devicetoken!='0' AND club.uid!='0' AND club.uid!='1' 
                AND news.push=1 AND news.news_datetime>GETUTCDATE()-1";
            using (SqlCommand cmd = new SqlCommand(sql, cn))
            {
                string gameid = string.Empty;
                string devtoken = string.Empty;
                string message = string.Empty;
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    message = r["headline"].ToString();
                    gameid = r["game_id"].ToString();
                    devtoken = r["devicetoken"].ToString();

                    this.Push(gameid, devtoken, message);
                }
                r.Close();

                string sql2 = @"UPDATE news SET news.push=0 WHERE news.push=1 AND news.news_datetime>GETUTCDATE()-1";
                using (SqlCommand cmd2 = new SqlCommand(sql2, cn))
                {
                    cmd2.ExecuteNonQuery();
                }
            }
        }
    }

    [WebGet(UriTemplate = "PushNewsSeries")]
    public Stream PushNewsSeries()
    {
        string result = "1";
        Thread oThread = new Thread(new ThreadStart(PushNewsSeriess));
        oThread.Start();

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    private void PushNewsSeriess()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql = @"SELECT news.headline, club.game_id, club.devicetoken FROM news inner join club ON (news.division=club.division AND news.series=club.series) 
                WHERE club.devicetoken!='(null)' AND club.devicetoken!='' AND club.devicetoken!='0' AND club.uid!='0' AND club.uid!='1' 
                AND news.push=1 AND news.news_datetime>GETUTCDATE()-1";
            using (SqlCommand cmd = new SqlCommand(sql, cn))
            {
                string gameid = string.Empty;
                string devtoken = string.Empty;
                string message = string.Empty;
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    message = r["headline"].ToString();
                    gameid = r["game_id"].ToString();
                    devtoken = r["devicetoken"].ToString();

                    this.Push(gameid, devtoken, message);
                }
                r.Close();
            }
        }
    }

    [WebGet(UriTemplate = "PushNewsAll")]
    public Stream PushNewsAll()
    {
        string result = "1";
        Thread oThread = new Thread(new ThreadStart(PushNewsAlls));
        oThread.Start();

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    private void PushNewsAlls()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql = @"SELECT news.headline FROM news WHERE news.everyone=1 AND news.push=1 AND news.news_datetime>GETUTCDATE()-1";
            using (SqlCommand cmd = new SqlCommand(sql, cn))
            {
                string message = string.Empty;
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    message = r["headline"].ToString();

                    this.PushMultiple(message);
                }
                r.Close();
            }
        }
    }
    
    [WebGet(UriTemplate = "RegisterFromFacebook/{uid}/{fb_id}/{name}/{username}/{gender}/{timezone}")]
    public Stream RegisterFromFacebook(string uid, string fb_id, string name, string username, string gender, string timezone) //Facebook App specefic
    {
        string result = "0";
        
        string nameUpper = name.ToUpper();
        
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	int count = 0;
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM club WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        	
        	if (count == 0)
        	{
        		if (string.Equals(uid, Global.LastRegister))
        		{
					//Duplicate UID
        		}
        		else
        		{
	        		Global.LastRegister = uid;
	        		
		            using (SqlCommand cmd = new SqlCommand("UPDATE TOP(1) club SET club_name='" + name + " FC', fb_id='" + fb_id + "', fb_name='" + name + "', fb_username='" + username + "', fb_gender='" + gender + "', fb_timezone='" + timezone + "', last_login=GETUTCDATE(), date_found=GETUTCDATE(), game_id='11', uid='" + uid + "' WHERE uid='0'", cn))
		            {
		                cmd.ExecuteNonQuery();
		
		                using (SqlCommand cmd2 = new SqlCommand("EXEC usp_ResetClub '" + uid + "'", cn))
		                {
		                    cmd2.ExecuteNonQuery();
		                    
		                    result = "1";
		                }
		            }
        		}
        	}
        }
        
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "Register/{game_id}/{uid}/{clubname}/{latitude}/{longitude}/{devicetoken}")]
    public Stream Register(string game_id, string uid, string clubname, string latitude, string longitude, string devicetoken)
    {
        CreateNewClub(game_id, uid, clubname, latitude, longitude, devicetoken);

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "Rename/{uid}/{clubname}")]
    public Stream Rename(string uid, string clubname)
    {
        string result = "0";

        if (clubname.Length > 2 && clubname.Length < 50)
        {
            result = "1";
                
            string clubnameUpper = clubname.ToUpper();
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE club SET club_name=N'" + clubnameUpper + "' WHERE uid='" + uid + "'", cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
 
    [WebGet(UriTemplate = "RenamePlayer/{uid}/{pid}/{name}")]
    public Stream RenamePlayer(string uid, string pid, string name)
    {
        string result = "0";

        if (name.Length > 2 && name.Length < 50)
        {
            int count = 0;
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_id = " + pid + " AND club.uid = '" + uid + "' AND club.currency_second>9", cn))
                {
                    cn.Open();
                    count = (int)cmd.ExecuteScalar();
                }
            }

            if (count != 1)
            {
                result = "0";
            }
            else
            {
                result = "1";
                //Update new name for player
                TextInfo textInfo = new CultureInfo("en-US",false).TextInfo;
                
                using (SqlConnection cn = new SqlConnection(GetConnectionString()))
                {
                    using (SqlCommand cmd = new SqlCommand("UPDATE player SET player_name=N'" + textInfo.ToTitleCase(name) + "' WHERE player_id=" + pid, cn))
                    {
                        cn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                
                using (SqlConnection cn = new SqlConnection(GetConnectionString()))
                {
                    using (SqlCommand cmd = new SqlCommand("EXEC usp_PlayerRename '" + uid + "', " + pid, cn))
                    {
                        cn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }
        else
        {
            result = "0";
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    
    [WebGet(UriTemplate = "UpgradePlayer/{uid}/{pid}")]
    public Stream UpgradePlayer(string uid, string pid)
    {
        string result = "0";

        int count = 0;
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_id = " + pid + " AND club.uid = '" + uid + "' AND club.currency_second>4", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        }

        if (count != 1)
        {
            result = "0";
        }
        else
        {
        	string strsql = "";
        	Random rnd = new Random();
			int skill = rnd.Next(1, 4);
			result = skill.ToString();
			
			if(skill==1)
			{
				strsql = "UPDATE player SET defend=defend+2 WHERE player_id=" + pid;
			}
			if(skill==2)
			{
				strsql = "UPDATE player SET playmaking=playmaking+2 WHERE player_id=" + pid;
			}
			if(skill==3)
			{
				strsql = "UPDATE player SET attack=attack+2 WHERE player_id=" + pid;
			}
			if(skill==4)
			{
				strsql = "UPDATE player SET passing=passing+2 WHERE player_id=" + pid;
			}
            
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand(strsql, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand("EXEC usp_PlayerUpgrade '" + uid + "', " + pid, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "MoralePlayer/{uid}/{pid}")]
    public Stream MoralePlayer(string uid, string pid)
    {
        string result = "0";

        int count = 0;
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM player INNER JOIN club ON player.club_id = club.club_id WHERE player.player_id = " + pid + " AND club.uid = '" + uid + "' AND club.currency_second>4", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        }

        if (count != 1)
        {
            result = "0";
        }
        else
        {
        	result = "1";
        	string strsql = "";
        	strsql = "UPDATE player SET happiness=happiness+10 WHERE player_id=" + pid;
            
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand(strsql, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand("EXEC usp_PlayerMorale '" + uid + "', " + pid, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    private string urlEncode(string str)
    {
        str = str.Replace(';', ':');
        str = str.Replace('=', '/');
        str = str.Replace(',', '?');

        return str;
    }

    [WebGet(UriTemplate = "PushVbs")]
    public Stream PushVbs()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("EXEC usp_push '71e1b0f692f4fedb0f262bc4d5c5264a9036146e379c6fcc331d4360d93e5d3e', 'from iis7'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    private void ExecuteNonQuery(object sql)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(sql.ToString(), cn))
            {
                cn.Open();
                cmd.CommandTimeout = 0;
                cmd.ExecuteNonQuery();
            }
        }
    }

    private void UpdateUID(string uid, string gameid, string latitude, string longitude, string devicetoken)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE club SET uid='"+gameid+uid+"', game_id='"+gameid+"', last_login=GETUTCDATE(), latitude=" + latitude + ", longitude=" + longitude + ", devicetoken='" + devicetoken + "' WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

    private void UpdateClubName(string uid, string clubname)
    {
        string clubnameUpper = clubname.ToUpper();

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE club SET club_name=N'" + clubnameUpper + "' WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

    private void CreateNewClub(string game_id, string uid, string clubname, string latitude, string longitude, string devicetoken)
    {
        string clubnameUpper = clubname.ToUpper();

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	int count = 0;
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM club WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        	
        	if (count == 0)
        	{
        		if (string.Equals(uid, Global.LastRegister))
        		{
					//Duplicate UID
        		}
        		else
        		{
	        		Global.LastRegister = uid;
	        		
		            using (SqlCommand cmd = new SqlCommand("UPDATE TOP(1) club SET fb_name='', last_login=GETUTCDATE(), date_found=GETUTCDATE(), game_id='" + game_id + "', uid='" + uid + "', latitude=" + latitude + ", longitude=" + longitude + ", devicetoken='" + devicetoken + "' WHERE uid='0'", cn))
		            {
		                cmd.ExecuteNonQuery();
		
		                using (SqlCommand cmd2 = new SqlCommand("EXEC usp_ResetClub '" + uid + "'", cn))
		                {
		                    cmd2.ExecuteNonQuery();
		                }
		            }
        		}
        	}
        }
    }

    private void SendChallengedPushMessage(string home_id, string club_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT game_id, devicetoken FROM club WHERE club_id="+club_id, cn))
            {
                string gameid = string.Empty;
                string devtoken = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    gameid = r["game_id"].ToString();
                    devtoken = r["devicetoken"].ToString();
                }
                r.Close();

                this.Push(gameid, devtoken, "Your club is challenged by another club! Players will Level UP faster if you accept challenge");
            }
        }
    }

    [WebGet(UriTemplate = "PushFast/{gameid}/{devtoken}/{message}")]
    public Stream PushFast(string gameid, string devtoken, string message)
    {
        this.Push(gameid, devtoken, message);

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "PushSingle/{devtoken}/{message}")]
    public Stream PushSingle(string devtoken, string message)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT game_id FROM club WHERE devicetoken='" + devtoken + "' AND uid!='0'", cn))
            {
                string gameid = string.Empty;
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    gameid = r["game_id"].ToString();
                    if (gameid != "")
                    {
                        this.Push(gameid, devtoken, message);
                    }
                }
                r.Close();
            }
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "PushMultiple/{message}")]
    public Stream PushMultiple(string message)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT game_id, devicetoken FROM club WHERE uid!='0' AND uid!='1' AND devicetoken!='(null)' AND devicetoken!='' AND devicetoken!='0' AND devicetoken IS NOT NULL", cn))
            {
                string gameid = string.Empty;
                string devtoken = string.Empty;
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    gameid = r["game_id"].ToString();
                    devtoken = r["devicetoken"].ToString();
                    if (gameid != "")
                    {
                        this.Push(gameid, devtoken, message);
                    }
                }
                r.Close();
            }
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "RestTest/{param1}")]
    public Stream RestTest(string param1)
    {
        string result = param1;
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "ChangeTraining/{uid}/{tid}")]
    public Stream ChangeTraining(string uid, string tid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE club SET training=" + tid + " WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1"; 
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "ChangeTactic/{uid}/{tid}")]
    public Stream ChangeTactic(string uid, string tid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE club SET tactic=" + tid + " WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1"; 
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "ImportFacebook/{uid}/{fb_uid}/{fb_name}/{fb_pic}/{fb_sex}/{fb_email}")]
    public Stream ImportFacebook(string uid, string fb_uid, string fb_name, string fb_pic, string fb_sex, string fb_email)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string facebookname = "John Doe";
            if (Regex.IsMatch(fb_name, @"^[a-zA-Z''-'\s]{1,40}$"))
            {
                facebookname = fb_name;
            }

            using (SqlCommand cmd = new SqlCommand("UPDATE club SET fb_uid='" + fb_uid
                + "', fb_name='" + urlEncode(facebookname)
                + "', fb_pic='" + urlEncode(fb_pic)
                + "', fb_gender='" + fb_sex
                + "', fb_username='" + urlEncode(fb_email) + "' WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "ResetClub/{uid}")]
    public Stream ResetClub(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("EXECUTE usp_ResetJump '" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "ResetUid/{uid}")]
    public Stream ResetUid(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE club SET uid=0 WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetEventSolo")]
    public Stream GetEventSolo()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM event_solo WHERE event_starting < GETUTCDATE() AND event_active = 1 ORDER BY event_id DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventAlliance")]
    public Stream GetEventAlliance()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM event_alliance WHERE event_starting < GETUTCDATE() AND event_active = 1 ORDER BY event_id DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventSoloNow")]
    public Stream GetEventSoloNow()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) club_id, club_name, alliance_id, alliance_name, logo_pic, xp, xp_gain FROM View_ClubInfo ORDER BY xp_gain DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventAllianceNow")]
    public Stream GetEventAllianceNow()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) * FROM View_AllianceEvent ORDER BY xp_gain DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventSoloResult/{event_id}")]
    public Stream GetEventSoloResult(string event_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd1 = new SqlCommand("EXECUTE usp_EventSoloResult", cn))
            {
                cn.Open();
                cmd1.ExecuteNonQuery();
        	}
        	
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) club_id, club_name, alliance_id, alliance_name, logo_pic, xp, xp_history as xp_gain FROM View_ClubInfo ORDER BY xp_history DESC", cn))
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventAllianceResult/{event_id}")]
    public Stream GetEventAllianceResult(string event_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd1 = new SqlCommand("EXECUTE usp_EventAllianceResult", cn))
            {
                cn.Open();
                cmd1.ExecuteNonQuery();
        	}
        	
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) * FROM View_AllianceEventResult ORDER BY xp_gain DESC", cn))
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetSales")]
    public Stream GetSales()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM sales WHERE sale_starting < GETUTCDATE() AND sale_ending > GETUTCDATE() ORDER BY sale_id DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "RegisterSale/{sale_id}/{uid}/{json}")]
    public Stream RegisterSale(string sale_id, string uid, string json)
    {
        if (int.Parse(sale_id) > 0)
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string sql_command = string.Empty;
				sql_command = "EXEC usp_RegisterSale '" + uid + "', " + sale_id;

                if (ReceiptVerify(uid, json))
                {
                    using (SqlCommand cmd = new SqlCommand(sql_command, cn))
                    {
                        cn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    //Cheat Detected
                }
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetAlliance")]
    public Stream GetAlliance()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT  alliance_id, leader_id, leader_name, name, date_found, alliance_level, currency_first, currency_second, leader_firstname, leader_secondname, logo_id, flag_id, 
                      fanpage_url, introduction_text, cup_name, cup_first_prize, cup_second_prize, cup_start, cup_round, cup_totalround, cup_first_id, cup_first_name, cup_second_id, 
                      cup_second_name, total_members, score, row_number() over (order by score desc) as rank
 					FROM View_Alliance WHERE total_members > 0 ORDER BY score DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceDetail/{alliance_id}")]
    public Stream GetAllianceDetail(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT alliance_id, leader_id, leader_name, name, date_found, alliance_level, currency_first, currency_second, leader_firstname, leader_secondname, logo_id, flag_id, 
                      fanpage_url, introduction_text, cup_name, cup_first_prize, cup_second_prize, cup_start, cup_round, cup_totalround, cup_first_id, cup_first_name, cup_second_id, 
                      cup_second_name, total_members, score, row_number() over (order by score desc) as rank FROM View_Alliance WHERE alliance_id=" + alliance_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceMembers/{alliance_id}")]
    public Stream GetAllianceMembers(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id, club_name, fan_members, xp, longitude, latitude, logo_pic FROM club WHERE alliance_id=" + alliance_id + " ORDER BY xp DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "AllianceCreate/{club_id}/{club_name}/{alliance_name}")]
    public Stream AllianceCreate(string club_id, string club_name, string alliance_name)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance VALUES (" + club_id + ", N'" + club_name + "', N'" + alliance_name + "', GETUTCDATE(), 1, 0, 0, '', '', 0, 0, '', '', '', 0, 0, GETUTCDATE(), 0, 0, 0, '', 0, '')", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetAllianceEvents/{alliance_id}")]
    public Stream GetAllianceEvents(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 30 * FROM alliance_event WHERE alliance_id=" + alliance_id + " ORDER BY event_id DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceDonations/{alliance_id}")]
    public Stream GetAllianceDonations(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id, max(club_name) club_name, SUM(currency_first) AS currency_first, SUM(currency_second) AS currency_second FROM alliance_donation WHERE alliance_id=" + alliance_id + " GROUP BY club_id ORDER BY currency_second DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "AllianceDonate/{alliance_id}/{club_id}/{club_name}/{currency_first}/{currency_second}")]
    public Stream AllianceDonate(string alliance_id, string club_id, string club_name, string currency_first, string currency_second)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_donation VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', " + currency_first + ", " + currency_second + ", GETUTCDATE())", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            
            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_event VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', '" + club_name + " donated $" + currency_first + " and " + currency_second + " diamonds.', GETUTCDATE())", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            
            string strSql = "UPDATE club SET balance=balance-" + currency_first + ", currency_second=currency_second-" + currency_second + " WHERE club_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            
            strSql = "UPDATE alliance SET currency_first=currency_first+" + currency_first + ", currency_second=currency_second+" + currency_second + " WHERE alliance_id=" + alliance_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceUpgrade/{alliance_id}/{club_id}")]
    public Stream AllianceUpgrade(string alliance_id, string club_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_event VALUES (" + alliance_id + ", " + club_id + ", 'Leader', 'Congratulations! The leader has upgraded this alliance to the next level.', GETUTCDATE())", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            
            string strSql = "UPDATE alliance SET alliance_level=alliance_level+1, currency_second=currency_second-(alliance_level+1) WHERE alliance_id=" + alliance_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetAllianceApply/{alliance_id}")]
    public Stream GetAllianceApply(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT club_id, club_name, alliance_id FROM alliance_apply WHERE alliance_id=" + alliance_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "AllianceApply/{alliance_id}/{club_id}/{club_name}")]
    public Stream AllianceApply(string alliance_id, string club_id, string club_name)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	int count = 0;
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM alliance_apply WHERE alliance_id=" + alliance_id + " AND club_id=" + club_id, cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
                cn.Close();
            }
        	
        	if (count == 0) //If no request was made before from the same club to the same alliance
        	{
	            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_apply VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', GETUTCDATE())", cn))
	            {
	                cn.Open();
	                cmd.ExecuteNonQuery();
	                cn.Close();
	            }
	            
	            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_event VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', N'" + club_name + " applied to join.', GETUTCDATE())", cn))
	            {
	                cn.Open();
	                cmd.ExecuteNonQuery();
	                cn.Close();
	            }
        	}
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceReject/{alliance_id}/{club_id}/{club_name}")]
    public Stream AllianceReject(string alliance_id, string club_id, string club_name)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("DELETE alliance_apply WHERE alliance_id=" + alliance_id + " AND club_id=" + club_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            
            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_event VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', N'" + club_name + " application to join was Rejected by the President.', GETUTCDATE())", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceApprove/{alliance_id}/{club_id}/{club_name}")]
    public Stream AllianceApprove(string alliance_id, string club_id, string club_name)
    {
    	string result = "0";
    	
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand("SELECT alliance_level, total_members FROM View_Alliance WHERE alliance_id=" + alliance_id, cn))
            {
                string alliance_level = string.Empty;
                string total_members = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    alliance_level = r["alliance_level"].ToString();
                    total_members = r["total_members"].ToString();
                }
                r.Close();

                int lvl = int.Parse(alliance_level);
                int members = int.Parse(total_members);
                
                if(members >= (lvl*10))
                {
                	
                }
                else
                {
                	result = "1";
                	
		            using (SqlCommand cmd1 = new SqlCommand("UPDATE club SET alliance_id=" + alliance_id + " WHERE alliance_id=0 AND club_id=" + club_id, cn))
		            {
		                cmd1.ExecuteNonQuery();
		            }
		        	
		            using (SqlCommand cmd2 = new SqlCommand("DELETE alliance_apply WHERE club_id=" + club_id, cn))
		            {
		                cmd2.ExecuteNonQuery();
		            }
		            
		            using (SqlCommand cmd3 = new SqlCommand("INSERT INTO alliance_event VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', N'" + club_name + " application to join was Approved by the leader.', GETUTCDATE())", cn))
		            {
		                cmd3.ExecuteNonQuery();
		            }
                }
        	}
        }
        
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceKick/{alliance_id}/{club_id}/{club_name}")]
    public Stream AllianceKick(string alliance_id, string club_id, string club_name)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand("UPDATE club SET alliance_id=0 WHERE club_id=" + club_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            
            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_event VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', N'" + club_name + " was kicked OUT by the leader.', GETUTCDATE())", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceResign/{alliance_id}/{club_id}/{club_name}")]
    public Stream AllianceResign(string alliance_id, string club_id, string club_name)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand("UPDATE club SET alliance_id=0 WHERE club_id=" + club_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
            
            using (SqlCommand cmd = new SqlCommand("INSERT INTO alliance_event VALUES (" + alliance_id + ", " + club_id + ", N'" + club_name + "', N'" + club_name + " has resigned from the alliance.', GETUTCDATE())", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AlliancePost/{alliance_id}/{club_id}/{club_name}/{msg}")]
    public Stream AlliancePost(string alliance_id, string club_id, string club_name, string msg)
    {
        if (string.Equals(alliance_id+msg, Global.LastPost))
        {

        }
        else
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = "INSERT INTO alliance_wall VALUES (" + club_id + ", N'" + club_name + "', N'" + msg + "', GETUTCDATE(), " + alliance_id + ", '')";
                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            Global.LastPost = alliance_id+msg;
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditName/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditName(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET name=N'" + text + "' WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditFirstname/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditFirstname(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET leader_firstname=N'" + text + "' WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditSecondname/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditSecondname(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET leader_secondname=N'" + text + "' WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditWebsite/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditWebsite(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET fanpage_url=N'" + text + "' WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditCup/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditCup(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET cup_name=N'" + text + "' WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditFirstprize/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditFirstprize(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET cup_first_prize=" + text + " WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditSecondprize/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditSecondprize(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET cup_second_prize=" + text + " WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceEditIntro/{alliance_id}/{club_id}/{text}")]
    public Stream AllianceEditIntro(string alliance_id, string club_id, string text)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "UPDATE alliance SET introduction_text=N'" + text + "' WHERE alliance_id=" + alliance_id + " AND leader_id=" + club_id;
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
            }
        }
        
        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetClubInfoFb/{name}/{fb_uid}")]
    public Stream GetClubInfoFb(string name, string fb_uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id, date_found, club_name, coach_id, stadium, balance, revenue_sponsors, fan_members, xp, division, series, league_ranking, longitude, latitude, home_pic, away_pic, logo_pic, fb_pic, fb_name FROM club WHERE fb_id='" + fb_uid + "' OR fb_name='" + name + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetClubInfo/{club_id}")]
    public Stream GetClubInfo(string club_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	string sql = "1";
        	int num;
            bool isNumeric = int.TryParse(club_id, out num);
            if (isNumeric)
            {
                sql = "SELECT * FROM View_ClubInfo WHERE club_id=" + club_id;
            }
        	else
        	{
        		sql = "SELECT club_id, date_found, club_name, coach_id, stadium, balance, revenue_sponsors, fan_members, xp, division, series, league_ranking, longitude, latitude, home_pic, away_pic, logo_pic, fb_pic, fb_name FROM club WHERE uid='" + club_id + "'";
        	}
        	
            using (SqlCommand cmd = new SqlCommand(sql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetClubFB/{fb_id}")]
    public Stream GetClubFB(string fb_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 club_id, date_found, club_name, coach_id, stadium, balance, revenue_sponsors, fan_members, xp, division, series, league_ranking, longitude, latitude, home_pic, away_pic, logo_pic, fb_pic, fb_name FROM club WHERE uid LIKE '%" + fb_id + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetTrophy/{club_id}")]
    public Stream GetTrophy(string club_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM trophy WHERE club_id=" + club_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetPlayers/{club_id}")]
    public Stream GetPlayers(string club_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM player WHERE club_id=" + club_id + " ORDER BY player_id", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetAchievements/{club_id}")]
    public Stream GetAchievements(string club_id)
    {
        if (int.Parse(club_id) > 0)
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = @"SELECT achievement_type.achievement_type_id, achievement_type.name, achievement_type.description, achievement_type.reward, achievement_type.image_url, achievement_type.tutorial, 
				achievement.achievement_id, achievement.club_id, achievement.claimed 
                FROM achievement_type LEFT JOIN achievement ON achievement_type.achievement_type_id=achievement.achievement_type_id AND achievement_type.valid=1 AND achievement.club_id=" + club_id +
                @" WHERE achievement_type.valid=1 ORDER BY achievement_type.reward DESC";
                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    Encoding encoding = Encoding.UTF8;
                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                    return new MemoryStream(returnBytes);
                }
            }
        }
        else
        {
            string result = "1";
            Encoding encoding = Encoding.UTF8;
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes = encoding.GetBytes(result);
            return new MemoryStream(returnBytes);
        }
    }
    
    [WebGet(UriTemplate = "ClaimAchievement/{club_id}/{achievement_id}/{achievement_type_id}")]
    public Stream ClaimAchievement(string club_id, string achievement_id, string achievement_type_id)
    {
    	string reward_value = "0";
    	
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand("SELECT achievement_type.reward FROM achievement INNER JOIN achievement_type ON achievement.achievement_type_id=achievement_type.achievement_type_id AND achievement.achievement_id=" + achievement_id + " AND achievement.club_id=" + club_id + " AND achievement.claimed=0", cn))
            {
                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!(r.IsDBNull(0)))
                    {
                        reward_value = r["reward"].ToString();
                    }
                }
                r.Close();
        	}
        	if (reward_value != "0")
        	{
	        	using (SqlCommand cmd3 = new SqlCommand("UPDATE achievement SET claimed=1 WHERE achievement_id=" + achievement_id, cn))
	        	{
	            	cmd3.ExecuteNonQuery();
	       	 	}
	        	using (SqlCommand cmd2 = new SqlCommand("UPDATE club SET balance=balance+" + reward_value + " WHERE club_id=" + club_id, cn))
	        	{
	            	cmd2.ExecuteNonQuery();
	       	 	}
        	}
        }
        
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(reward_value);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "DoChat/{club_id}/{club_name}/{msg}")]
    public Stream DoChat(string club_id, string club_name, string msg)
    {
        if (string.Equals(msg, Global.LastChat))
        {

        }
        else
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = "INSERT INTO chat VALUES (" + club_id + ", N'" + club_name + "', N'" + msg + "', GETUTCDATE(), 0, '')";
                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            Global.LastChat = msg;
        }

        string result = "1";
        Encoding encoding = Encoding.UTF8;
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "GetChat/{last_chat_id}/{club_id}/{division}/{series}/{playing_cup}")]
    public Stream GetChat(string last_chat_id, string club_id, string division, string series, string playing_cup)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            last_chat_id = last_chat_id.Replace(",", "");
            if (last_chat_id != "0")
            {
                strSql = "SELECT * FROM chat WHERE chat_id>" + last_chat_id + " ORDER BY chat_id ASC";
            }
            else
            {
                strSql = "SELECT * FROM (SELECT TOP 10 * FROM chat ORDER BY chat_id DESC) AS TOP10 ORDER BY chat_id ASC";
            }

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "Upgrade/{uid}/{id}")]
    public Stream Upgrade(string uid, string id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql = @"UPDATE club SET balance=balance";
            if (id.Equals("1")) //Hotel
            {
                sql = @"UPDATE club SET e=e-10, balance=balance-50000";
            }
            if (id.Equals("2")) //Retail
            {
                sql = @"UPDATE club SET e=e-10, balance=balance-10000";
            }
            if (id.Equals("3")) //Office
            {
                sql = @"UPDATE club SET e=e-10, balance=balance-20000";
            }
            using (SqlCommand cmd = new SqlCommand(sql + ", building" + id + "=building" + id + "+1, building" + id + "_dt=GETUTCDATE() WHERE uid='" + uid + "' AND e >= 9", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "Upgrade2/{uid}/{id}")]
    public Stream Upgrade2(string uid, string id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql = @"UPDATE club SET balance=balance";
            if (id.Equals("1")) //Hotel
            {
                sql = @"UPDATE club SET currency_second=currency_second-15, xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5";
            }
            if (id.Equals("2")) //Retail
            {
                sql = @"UPDATE club SET currency_second=currency_second-5, xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5";
            }
            if (id.Equals("3")) //Office
            {
                sql = @"UPDATE club SET currency_second=currency_second-10, xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5";
            }
            using (SqlCommand cmd = new SqlCommand(sql + ", building" + id + "=building" + id + "+1, building" + id + "_dt=GETUTCDATE() WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "DoBid/{uid}/{club_id}/{club_name}/{player_id}/{value}")]
    public Stream DoBid(string uid, string club_id, string club_name, string player_id, string value)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	string result = "1";
        	string bal = "0";
        	string pval = "0";
        	string lastbid = "0";

            using (SqlCommand cmd1 = new SqlCommand("SELECT TOP(2) club_id, bid_value FROM bid WHERE club_id!=" + club_id + " AND player_id=" + player_id + " ORDER BY bid_value DESC", cn))
            {
                cn.Open();
                SqlDataReader r1 = cmd1.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        string pcid = r1["club_id"].ToString();
                        ThreadStart starter = delegate { CounterBidPushMessage(pcid, club_name, value); };
                        Thread thread = new Thread(starter);
                        thread.Start();
                        //CounterBidPushMessage(pcid, club_name, value);
                        
                        lastbid = r1["bid_value"].ToString();
                    }
                }
                r1.Close();
                cn.Close();
            }
            
            using (SqlCommand cmd2 = new SqlCommand("SELECT balance FROM club WHERE club_id=" + club_id, cn))
            {
                cn.Open();
                SqlDataReader r2 = cmd2.ExecuteReader();
                while (r2.Read())
                {
                    if (!(r2.IsDBNull(0)))
                    {
                        bal = r2["balance"].ToString();
                    }
                }
                r2.Close();
                cn.Close();
            }
            
            using (SqlCommand cmd3 = new SqlCommand("SELECT player_value FROM player WHERE player_id=" + player_id, cn))
            {
                cn.Open();
                SqlDataReader r3 = cmd3.ExecuteReader();
                while (r3.Read())
                {
                    if (!(r3.IsDBNull(0)))
                    {
                        pval = r3["player_value"].ToString();
                    }
                }
                r3.Close();
                cn.Close();
            }

            if( (long.Parse(bal) >= long.Parse(value)) && (long.Parse(value) > long.Parse(pval))  && (long.Parse(value) > long.Parse(lastbid)) )
            {
	            string strSql = "INSERT INTO bid VALUES ('" + uid + "', " + club_id + ", N'" + club_name + "', " + player_id + ", " + value + ", GETUTCDATE())";
	            using (SqlCommand cmd = new SqlCommand(strSql, cn))
	            {
	                cn.Open();
	                cmd.ExecuteNonQuery();
	                cn.Close();
	            }
            }
            else
            {
            	result = "0";
            }
            
            Encoding encoding = Encoding.UTF8;
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes = encoding.GetBytes(result);
            return new MemoryStream(returnBytes);
        }
    }

    private void CounterBidPushMessage(string club_id, string club_name, string bid_value)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT game_id, devicetoken FROM club WHERE club_id=" + club_id, cn))
            {
                string gameid = string.Empty;
                string devtoken = string.Empty;
                string msg = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    gameid = r["game_id"].ToString();
                    devtoken = r["devicetoken"].ToString();
                }
                r.Close();

                int val = int.Parse(bid_value);
                val.ToString("N0");
                msg = club_name + " has counter bid the player you bid for $" + val.ToString("N0") + ". Bid higher and show them who is boss.";
                this.Push(gameid, devtoken, msg);
            }
        }
    }

    [WebGet(UriTemplate = "GetBid/{player_id}")]
    public Stream GetBid(string player_id)
    {
        string pcid = "-1";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd1 = new SqlCommand("SELECT club_id FROM player WHERE player_id=" + player_id, cn))
            {
                cn.Open();
                SqlDataReader r1 = cmd1.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        pcid = r1["club_id"].ToString();
                    }
                }
                r1.Close();

                if ((pcid.Length > 0) && (pcid == "-1"))
                {
                    string strSql = string.Empty;
                    strSql = "SELECT club_id, club_name, player_id, bid_value, bid_datetime FROM bid WHERE player_id=" + player_id + " ORDER BY bid_id ASC";

                    using (SqlCommand cmd = new SqlCommand(strSql, cn))
                    {
                        cmd.ExecuteNonQuery();
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        Encoding encoding = Encoding.UTF8;
                        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                        byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                        return new MemoryStream(returnBytes);
                    }
                }
                else
                {
                    string result = "0";
                    Encoding encoding = Encoding.UTF8;
                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(result);
                    return new MemoryStream(returnBytes);
                }
            }
        }
    }

    [WebGet(UriTemplate = "GetNews/{club_id}/{division}/{series}/{playing_cup}")]
    public Stream GetNews(string club_id, string division, string series, string playing_cup)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            if (playing_cup == "1")
            {
                strSql = "SELECT * FROM news WHERE (everyone=1) OR (club_id=" + club_id + ") OR (playing_cup=1) OR (division=" + division + " AND series=" + series + ") ORDER BY news_datetime DESC";
            }
            else
            {
                strSql = "SELECT * FROM news WHERE (everyone=1) OR (club_id=" + club_id + ") OR (division=" + division + " AND series=" + series + ") ORDER BY news_datetime DESC";
            }
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMarquee/{club_id}/{division}/{series}/{playing_cup}")]
    public Stream GetMarquee(string club_id, string division, string series, string playing_cup)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            if (playing_cup == "1")
            {
                strSql = "SELECT TOP 20 * FROM news WHERE (marquee=1) AND ( (everyone=1) OR (club_id=" + club_id + ") OR (playing_cup=1) OR (division=" + division + " AND series=" + series + ") ) ORDER BY news_datetime DESC";
            }
            else
            {
                strSql = "SELECT TOP 20 * FROM news WHERE (marquee=1) AND ( (everyone=1) OR (club_id=" + club_id + ") OR (division=" + division + " AND series=" + series + ") ) ORDER BY news_datetime DESC";
            }
            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GeneratePlayersSale")]
    public Stream GeneratePlayersSale()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("EXECUTE usp_PlayerSalesBulk", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();

                string result = "1";
                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetCoaches")]
    public Stream GetCoaches()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM coach ORDER BY coach_star DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetProducts")]
    public Stream GetProducts()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM product WHERE type!='Others' ORDER BY product_star DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetCurrentSeason")]
    public Stream GetCurrentSeason()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM season", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "ProductIdentifiers/{game_id}")]
    public Stream ProductIdentifiers(string game_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM identifier WHERE game_id='" + game_id + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetClub/{uid}")]
    public Stream GetClub(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_Club WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetPlayerInfo/{player_id}")]
    public Stream GetPlayerInfo(string player_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM player WHERE player_id=" + player_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetPlayersBid")]
    public Stream GetPlayersBid()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM player WHERE club_id=-1 ORDER BY player_goals DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetPlayersSale")]
    public Stream GetPlayersSale()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM player WHERE club_id=0 ORDER BY player_goals DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMatchInfo/{match_id}")]
    public Stream GetMatchInfo(string match_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_Match WHERE match_id = " + match_id, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMatchFixtures/{division}/{series}")]
    public Stream GetMatchFixtures(string division, string series)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT match_id, match_type_id, match_played, match_datetime, season_week, club_home, club_home_name, club_away, club_away_name, club_winner, club_loser, home_score, away_score FROM View_Match WHERE division=" + division + " AND series=" + series + " AND match_type_id=1 ORDER BY season_week ASC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetCupRounds")]
    public Stream GetCupRounds()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT MAX(season_week) FROM match WHERE match_type_id=2", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetCupFixtures/{round}")]
    public Stream GetCupFixtures(string round)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT match_id, match_type_id, match_played, match_datetime, season_week, club_home, club_home_name, club_away, club_away_name, club_winner, club_loser, home_score, away_score FROM View_Match WHERE season_week=" + round + " AND match_type_id=2 ORDER BY match_datetime DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceCupFixtures/{alliance_id}/{round}")]
    public Stream GetAllianceCupFixtures(string alliance_id, string round)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	int mtype = int.Parse(alliance_id) + 1000;
        	using (SqlCommand cmd = new SqlCommand("SELECT match_id, match_type_id, match_played, match_datetime, season_week, club_home, club_home_name, club_away, club_away_name, club_winner, club_loser, home_score, away_score FROM View_Match WHERE season_week=" + round + " AND match_type_id=" + mtype.ToString() + " ORDER BY match_datetime DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMatchHighlights/{match_id}")]
    public Stream GetMatchHighlights(string match_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM match_highlight WHERE match_id=" + match_id + " ORDER BY match_minute ASC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetLeagueTopScorers/{division}/{top}")]
    public Stream GetLeagueTopScorers(string division, string top)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP " + top + " club_id, player_id, player_name, player_age, player_salary, player_value, COUNT(player_id) AS Score FROM View_MatchHighlightPlayer WHERE (highlight_type_id = 1 OR highlight_type_id = 2) AND division = " + division + " AND match_type_id = 1 GROUP BY player_id, player_name, player_age, player_salary, player_value, club_id ORDER BY Score DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetCupTopScorers/{top}")]
    public Stream GetCupTopScorers(string top)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP " + top + " club_id, player_id, player_name, player_age, player_salary, player_value, COUNT(player_id) AS Score FROM View_MatchHighlightPlayer WHERE (highlight_type_id = 1 OR highlight_type_id = 2) AND match_type_id = 2 GROUP BY player_id, player_name, player_age, player_salary, player_value, club_id ORDER BY Score DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetSearch/{name}")]
    public Stream GetSearch(string name)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
			using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_ClubInfo WHERE club_name LIKE '%"+name+"%' AND club_name NOT LIKE 'CLUB %' ORDER BY xp DESC", cn))
			{
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetClubsSearch")]
    public Stream GetClubsSearch()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id, club_name, fan_members, longitude, latitude, logo_pic FROM club WHERE uid != '0' AND club_name NOT LIKE 'CLUB %'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetClubs")]
    public Stream GetClubs() //Facebook and IOS map view
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id, club_name, fan_members, xp, longitude, latitude, logo_pic FROM club WHERE uid != '0' AND longitude != 0 AND latitude != 0 AND xp > 100 AND club_name NOT LIKE 'CLUB %'", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetClubsTopDivision")]
    public Stream GetClubsTopDivision() //Rankings
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id, club_name, division, xp, alliance_name, logo_pic FROM View_Club WHERE uid != '0' AND uid != '1' AND division < 4 ORDER BY division ASC, xp DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetClubsTopLevel")]
    public Stream GetClubsTopLevel() //Rankings
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 200 club_id, club_name, division, xp, alliance_name, logo_pic FROM View_Club WHERE uid != '0' AND uid != '1' ORDER BY xp DESC", cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(PlistDocument.CreateDocument(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    private void SendLeaguePushMessage(string club_id, string pos)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT game_id, devicetoken FROM club WHERE club_id=" + club_id, cn))
            {
                string gameid = string.Empty;
                string devtoken = string.Empty;
                string postfix = string.Empty;
                string msg = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    gameid = r["game_id"].ToString();
                    devtoken = r["devicetoken"].ToString();
                }
                r.Close();

                if (pos == "1")
                {
                    postfix = "st";
                }
                else if (pos == "2")
                {
                    postfix = "nd";
                }
                else if (pos == "3")
                {
                    postfix = "rd";
                }
                else
                {
                    postfix = "th";
                }

                msg = "Your club is now " + pos.ToString() + postfix + " position in the league. Focus on the game, switch between tactics and formations, buy new players, in order for your club to reach 1st position";
                this.Push(gameid, devtoken, msg);
            }
        }
    }

    [WebGet(UriTemplate = "GetSeries/{division}/{series}")]
    public Stream GetSeries(string division, string series)
    {
        if (int.Parse(division) > 50)
        {
            return new MemoryStream();
        }
        else
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT last_update, table_xml FROM league WHERE division=" + division + " AND series=" + series, cn))
                {
                    Encoding encoding = Encoding.UTF8;
                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = null;
                    string last_update = string.Empty;
                    string table_xml = string.Empty;

                    cn.Open();
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.HasRows)
                    {
                        while (r.Read())
                        {
                            last_update = r["last_update"].ToString();
                            table_xml = r["table_xml"].ToString();
                        }
                        r.Close();

                        DateTime d = Convert.ToDateTime(last_update);
                        d = d.AddDays(1);

                        if (DateTime.Today > d)
                        {
                            returnBytes = encoding.GetBytes(UpdateLeague(division, series));
                        }
                        else
                        {
                            returnBytes = encoding.GetBytes(table_xml);
                        }
                    }
                    else
                    {
                        returnBytes = encoding.GetBytes(InsertLeague(division, series));
                    }

                    return new MemoryStream(returnBytes);
                }
            }
        }
    }

}
