class SocketIoManager
{
 static  Map<String, String >  socketEvents =
  {
    "type": "ping",
    "loggedIn":"logged_in",
    "loggedOut":"logged_out",
    "tokenExpired":"token_expired",
    "sessionOut":"session_out", //remotely loggedout by admin,
    "refresh":"refresh",
    "deviceOnline":"online",
    "deviceOffline":"offline-manual",
    "reconnect":"reconnected", //reconnect after internet is back
    "tabClosed":"tab_closed_or_refresh",
    "disconnected":"disconnected",
    "disconnectServer":"disconnected_by_server"
  };  
}