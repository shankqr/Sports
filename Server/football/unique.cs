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

public partial class GameEngine
{
	private string GetConnectionString()
    {
        return @"Data Source=(local);Initial Catalog=football;User ID=sa;Password=H1d@y@tul88";
    }
	
	[WebGet(UriTemplate = "PasswordRequest/{game_id}/{uid}/{email}")]
    public Stream PasswordRequest(string game_id, string uid, string email)
    {
    	string result = "0";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	int count = 0;
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM club WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        	
        	if (count > 0)
        	{
	            using (SqlCommand cmd = new SqlCommand("INSERT INTO password_request (request_date, request_game_id, request_uid, request_email) VALUES (GETDATE(), '" + game_id + "', '" + uid + "', '" + email + "')", cn))
	            {
	                cmd.ExecuteNonQuery();
	            }
	            
	            string request_id = string.Empty;
	            
	            using (SqlCommand cmd = new SqlCommand("SELECT request_id FROM password_request WHERE request_uid='" + uid + "'", cn))
            	{
	                SqlDataReader r1 = cmd.ExecuteReader();
	                while (r1.Read())
	                {
	                    if (!(r1.IsDBNull(0)))
	                    {
	                        request_id = r1["request_id"].ToString();
	                    }
	                }
	                r1.Close();
	            }
	            
	            result = SendMessage(email, "Password for App", "Click on this link to see your password: http://football.tapfantasy.com/football/GetPassword/" + request_id);
        	}
        }

        Encoding encoding = Encoding.GetEncoding("ISO-8859-1");
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
	
	[WebGet(UriTemplate = "LoginFromFacebook/{uid}/{fb_id}")]
    public Stream LoginFromFacebook(string uid, string fb_id) //Facebook App specefic
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT club_id, club_name, last_login FROM club WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                string cid = string.Empty;
                string cname = string.Empty;
                string last_login = string.Empty;
                string sql_update_club = string.Empty;
                string result = "0";

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
                	result = "1"; //No dailly login bonus
                	sql_update_club = "UPDATE club SET fb_id='" + fb_id + "', last_login=GETUTCDATE() WHERE uid='" + uid + "'";
                    
                    Thread oThread = new Thread(new ParameterizedThreadStart(ExecuteNonQuery));
                    oThread.Start(sql_update_club);

                    Thread oThread2 = new Thread(new ParameterizedThreadStart(ExecuteNonQuery));
                    oThread2.Start("INSERT INTO chat VALUES (" + cid + ", N'" + cname + "', 'Manager has just logged in from Facebook.', GETUTCDATE(), 0, '')");
                }

                Encoding encoding = Encoding.UTF8;
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(result);
                return new MemoryStream(returnBytes);
            }
        }
    }
	
	private void Push(string gameid, string devtoken, string message)
    {
        string p12File = "fmcpush.p12";

        if (gameid == "4")
            p12File = "ffpush.p12";

        if (gameid == "3")
            p12File = "fmhdpush.p12";

        if(gameid == "2")
            p12File = "fmpush.p12";

        if (gameid == "1")
            p12File = "ffcpush.p12";

        if (gameid == "0")
            p12File = "fmcpush.p12";


        if (devtoken != "0" && devtoken != "(null)" && devtoken != "" && message.Length>0)
        {
            bool sandbox = false;
            string p12FilePassword = "Inf0b1n@";
            string p12Filename = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, p12File);
            NotificationService service = new NotificationService(sandbox, p12Filename, p12FilePassword, 1);
            service.SendRetries = 10;
            service.ReconnectDelay = 5000;

            Notification alertNotification = new Notification(devtoken);
            alertNotification.Payload.Alert.Body = message;
            alertNotification.Payload.Sound = "default";
            alertNotification.Payload.Badge = 1;

            service.QueueNotification(alertNotification);
            service.Close();
            service.Dispose();
        }
    }
	
    [WebGet(UriTemplate = "ChangeFormation/{uid}/{fid}")]
    public Stream ChangeFormation(string uid, string fid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql1 = string.Empty;
            switch (fid)
            {
                case "1":
                    sql1 = "UPDATE club SET cd3=0, im3=0, fw3=0";
                    break;
                case "2":
                    sql1 = "UPDATE club SET cd3=0, im2=0, im3=0";
                    break;
                case "3":
                    sql1 = "UPDATE club SET cd2=0, cd3=0, im3=0";
                    break;
                case "4":
                    sql1 = "UPDATE club SET im3=0, fw2=0, fw3=0";
                    break;
                case "5":
                    sql1 = "UPDATE club SET im2=0, im3=0, fw3=0";
                    break;
                case "6":
                    sql1 = "UPDATE club SET cd2=0, cd3=0, fw3=0";
                    break;
                case "7":
                    sql1 = "UPDATE club SET cd3=0, fw2=0, fw3=0";
                    break;
                default:
                    sql1 = "UPDATE club SET cd3=0, im3=0, fw3=0";
                    break;
            }

            using (SqlCommand cmd = new SqlCommand(sql1 + ", formation=" + fid + " WHERE uid='" + uid + "'", cn))
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
	    
    [WebGet(UriTemplate = "ChangePlayerFormation/{uid}/{player_id}/{formation_pos}")]
    public Stream ChangePlayerFormation(string uid, string player_id, string formation_pos)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd = new SqlCommand(@"SELECT formation, [gk], [rb], [lb], [rw], [lw], [cd1], [cd2], [cd3], [im1], [im2], [im3], [fw1], [fw2], [fw3], [sgk], [sd], [sim], [sfw], [sw] FROM club WHERE uid='" + uid + "'", cn))
            {
        		string result = "1"; 
             	Encoding encoding = Encoding.UTF8;
              	WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
              	byte[] returnBytes = encoding.GetBytes(result);
        		
                string formation, gk, rb, lb, rw, lw, cd1, cd2, cd3, im1, im2, im3, fw1, fw2, fw3, sgk, sd, sim, sfw, sw;
                formation = gk = rb = lb = rw = lw = cd1 = cd2 = cd3 = im1 = im2 = im3 = fw1 = fw2 = fw3 = sgk = sd = sim = sfw = sw = string.Empty;

                cn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                while (r.Read())
                {
                    if (!(r.IsDBNull(0)))
                    {
                        formation = r["formation"].ToString();
                    }
                    if (!(r.IsDBNull(1)))
                    {
                        gk = r["gk"].ToString();
                    }
                    if (!(r.IsDBNull(2)))
                    {
                        rb = r["rb"].ToString();
                    }
                    if (!(r.IsDBNull(3)))
                    {
                        lb = r["lb"].ToString();
                    }
                    if (!(r.IsDBNull(4)))
                    {
                        rw = r["rw"].ToString();
                    }
                    if (!(r.IsDBNull(5)))
                    {
                        lw = r["lw"].ToString();
                    }
                    if (!(r.IsDBNull(6)))
                    {
                        cd1 = r["cd1"].ToString();
                    }
                    if (!(r.IsDBNull(7)))
                    {
                        cd2 = r["cd2"].ToString();
                    }
                    if (!(r.IsDBNull(8)))
                    {
                        cd3 = r["cd3"].ToString();
                    }
                    if (!(r.IsDBNull(9)))
                    {
                        im1 = r["im1"].ToString();
                    }
                    if (!(r.IsDBNull(10)))
                    {
                        im2 = r["im2"].ToString();
                    }
                    if (!(r.IsDBNull(11)))
                    {
                        im3 = r["im3"].ToString();
                    }
                    if (!(r.IsDBNull(12)))
                    {
                        fw1 = r["fw1"].ToString();
                    }
                    if (!(r.IsDBNull(13)))
                    {
                        fw2 = r["fw2"].ToString();
                    }
                    if (!(r.IsDBNull(14)))
                    {
                        fw3 = r["fw3"].ToString();
                    }
                    if (!(r.IsDBNull(15)))
                    {
                        sgk = r["sgk"].ToString();
                    }
                    if (!(r.IsDBNull(16)))
                    {
                        sd = r["sd"].ToString();
                    }
                    if (!(r.IsDBNull(17)))
                    {
                        sim = r["sim"].ToString();
                    }
                    if (!(r.IsDBNull(18)))
                    {
                        sfw = r["sfw"].ToString();
                    }
                    if (!(r.IsDBNull(19)))
                    {
                        sw = r["sw"].ToString();
                    }
                }
                r.Close();
                
            	string sql1 = string.Empty;
	            switch (formation)
	            {
	                case "1":
	                    sql1 = "UPDATE club SET cd3=0, im3=0, fw3=0";
	                    break;
	                case "2":
	                    sql1 = "UPDATE club SET cd3=0, im2=0, im3=0";
	                    break;
	                case "3":
	                    sql1 = "UPDATE club SET cd2=0, cd3=0, im3=0";
	                    break;
	                case "4":
	                    sql1 = "UPDATE club SET im3=0, fw2=0, fw3=0";
	                    break;
	                case "5":
	                    sql1 = "UPDATE club SET im2=0, im3=0, fw3=0";
	                    break;
	                case "6":
	                    sql1 = "UPDATE club SET cd2=0, cd3=0, fw3=0";
	                    break;
	                case "7":
	                    sql1 = "UPDATE club SET cd3=0, fw2=0, fw3=0";
	                    break;
	                default:
	                    sql1 = "UPDATE club SET cd3=0, im3=0, fw3=0";
	                    break;
	            }
	            
	            if (gk==player_id)
	            {
	            	if(formation_pos=="gk")
	            	{
	            		//Player is already set to this pos: no need to update db
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", gk=0"; //Clear up the previous pos
	            	}
	            }
	            
	            if (rb==player_id)
	            {
	            	if(formation_pos=="rb")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", rb=0";
	            	}
	            }
	            
	            if (lb==player_id)
	            {
	            	if(formation_pos=="lb")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", lb=0";
	            	}
	            }
	            
	            if (rw==player_id)
	            {
	            	if(formation_pos=="rw")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", rw=0";
	            	}
	            }
	            
	            if (lw==player_id)
	            {
	            	if(formation_pos=="lw")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", lw=0";
	            	}
	            }
	            
	            if (cd1==player_id)
	            {
	            	if(formation_pos=="")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", cd1=0";
	            	}
	            }
	            
	            if (cd2==player_id)
	            {
	            	if(formation_pos=="cd2")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", cd2=0";
	            	}
	            }
	            
	            if (cd3==player_id)
	            {
	            	if(formation_pos=="cd3")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", cd3=0";
	            	}
	            }
	            
	            if (im1==player_id)
	            {
	            	if(formation_pos=="im1")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", im1=0";
	            	}
	            }
	            
	            if (im2==player_id)
	            {
	            	if(formation_pos=="im2")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", im2=0";
	            	}
	            }
	            
	            if (im3==player_id)
	            {
	            	if(formation_pos=="im3")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", im3=0";
	            	}
	            }
	            
	            if (fw1==player_id)
	            {
	            	if(formation_pos=="fw1")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", fw1=0";
	            	}
	            }
	            
	            if (fw2==player_id)
	            {
	            	if(formation_pos=="fw2")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", fw2=0";
	            	}
	            }
	            
	            if (fw3==player_id)
	            {
	            	if(formation_pos=="fw3")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", fw3=0";
	            	}
	            }
	            
	            if (sgk==player_id)
	            {
	            	if(formation_pos=="sgk")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", sgk=0";
	            	}
	            }
	            
	            if (sd==player_id)
	            {
	            	if(formation_pos=="sd")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", sd=0";
	            	}
	            }
	            
	            if (sim==player_id)
	            {
	            	if(formation_pos=="sim")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", sim=0";
	            	}
	            }
	            
	            if (sfw==player_id)
	            {
	            	if(formation_pos=="sfw")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", sfw=0";
	            	}
	            }
	            
	            if (sw==player_id)
	            {
	            	if(formation_pos=="sw")
	            	{
	            		return new MemoryStream(returnBytes);
	            	}
	            	else
	            	{
	            		sql1 = sql1 + ", sw=0";
	            	}
	            }
        	
            	using (SqlCommand cmd2 = new SqlCommand(sql1 + ", " + formation_pos + "=" + player_id + " WHERE uid='" + uid + "'", cn))
            	{
                	cmd2.ExecuteNonQuery();

                	return new MemoryStream(returnBytes);
            	}
            }
        }
    }
    
    private void UpdateLeaguePosition(object dt)
    {
        SqlConnection cn = new SqlConnection(GetConnectionString());
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = cn;
        cmd.CommandType = CommandType.Text;
        cn.Open();

        int pos = 0;
        foreach (DataRow dr in ((DataTable)dt).Rows)
        {
            pos += 1;
            cmd.CommandText = "UPDATE club SET league_ranking=" + pos.ToString() + " WHERE club_id=" + dr[0].ToString(); //Basketball and baseball use dr[1] otherwise dr[0]
            cmd.ExecuteNonQuery();

            SendLeaguePushMessage(dr[0].ToString(), pos.ToString()); //Basketball and baseball use dr[1] otherwise dr[0]
        }
        cn.Close();
    }

    private string UpdateLeague(string division, string series)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_Series WHERE division=" + division + " AND series=" + series + " ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC", cn))
            {
                cmd.CommandTimeout = 0;
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                //Update League Buffer Table
                cmd.CommandText = "UPDATE league SET table_xml='" + PlistDocument.CreateDocument(dt) + "', last_update=GETUTCDATE() WHERE division=" + division + " AND series=" + series;
                cmd.ExecuteNonQuery();

                //Update league ranking
                Thread t = new Thread(new ParameterizedThreadStart(UpdateLeaguePosition));
                t.Start(dt);

                return PlistDocument.CreateDocument(dt);
            }
        }
    }

    private string InsertLeague(string division, string series)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_Series WHERE division=" + division + " AND series=" + series + " ORDER BY Pts DESC, GD DESC, Win DESC, Draw DESC, Lose ASC, GF DESC, GA ASC", cn))
            {
                cmd.CommandTimeout = 0;
                cn.Open();
                cmd.ExecuteNonQuery();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                //Insert League Buffer Table
                cmd.CommandText = "INSERT INTO league VALUES (" + division + ", " + series + ", GETUTCDATE(), '" + PlistDocument.CreateDocument(dt) + "')";
                cmd.ExecuteNonQuery();

                //Update league ranking Must be disabled when running PromoteDemote!
                Thread t = new Thread(new ParameterizedThreadStart(UpdateLeaguePosition));
                t.Priority = ThreadPriority.Highest;
                //t.Start(dt);

                return PlistDocument.CreateDocument(dt);
            }
        }
    }
}
