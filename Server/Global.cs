using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Global
/// </summary>
public static class Global
{
    static string _lastChat;
    static string _lastPost;
    static string _lastRegister;

	public static string LastChat
	{
		get
        {
            return _lastChat;
        }
        set
        {
            _lastChat = value;
        }
	}
	
	public static string LastPost
	{
		get
        {
            return _lastPost;
        }
        set
        {
            _lastPost = value;
        }
	}
	
	public static string LastRegister
	{
		get
        {
            return _lastRegister;
        }
        set
        {
            _lastRegister = value;
        }
	}
}