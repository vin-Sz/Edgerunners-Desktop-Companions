using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;

namespace CapriDesktop
{
    // Lucy's side of YouTube Music for Desktop (ytmdesktop2). Its own API on this PC likes songs, says whether one is liked and
    // plays one, so she needs no buttons on its screen like she does for Spotify. The API is off until they turn it on in the app's
    // settings. Kept out of Capri's files so syncing capri-desktop stays easy: they only call in here (see characters/lucy/LEARNING.md).
    internal static class YouTubeMusic
    {
        private const int DefaultPort = 13091;
        // Sends a GET (body null) or a POST to its API and returns the answer, or null when the app or its API is off. Tests swap it out.
        internal static Func<string, string, string> Call = Ask;

        // Its media session and window: Windows names the app net.venipa.ytmdesktop, and its program is ytmdesktop.exe.
        internal static bool Owns(string app) { return !string.IsNullOrEmpty(app) && Regex.IsMatch(app, @"ytmdesktop|youtube music", RegexOptions.IgnoreCase); }

        // Whether the song on now is liked, or null when the API doesn't say.
        internal static bool? Liked()
        {
            Match liked = Regex.Match(Call("/track/state", null) ?? "", @"""liked""\s*:\s*(true|false)");
            return liked.Success ? liked.Groups[1].Value == "true" : (bool?)null;
        }

        internal static bool SetLiked(bool want) { return Took(Call("/track/like", want ? "true" : "false")); }

        // Plays a song, or a song in its playlist. With neither, it opens the app's search for what they asked.
        internal static bool Play(string video, string playlist, string search)
        {
            if (video != null) return Took(Call("/nav/watch", "{\"videoId\":\"" + video + "\"" + (playlist == null ? "" : ",\"playlistId\":\"" + playlist + "\"") + "}"));
            return Took(Call("/nav/open", "{\"url\":\"https://music.youtube.com/search?q=" + Uri.EscapeDataString(search ?? "") + "\"}"));
        }

        private static bool Took(string answer) { return answer != null && answer.IndexOf("\"error\"", StringComparison.Ordinal) < 0; }

        // "Like this song", "heart this", "unlike it", "take this out of my likes": "like", "unlike", or null. "I like this song" is chat.
        internal static string Liking(string text)
        {
            string said = Regex.Replace((text ?? "").Trim(), @"[.!]+$", "");
            const string It = @"(?:this|that|it|the)(?:\s+(?:song|track|tune|one))?(?:\s+(?:for me|please|pls))?";
            if (Regex.IsMatch(said, @"^(?:please\s+)?(?:like|heart)\s+" + It + @"$|^(?:please\s+)?add\s+" + It + @"\s+to\s+(?:my\s+)?(?:likes|liked songs)$", RegexOptions.IgnoreCase)) return "like";
            if (Regex.IsMatch(said, @"^(?:please\s+)?(?:unlike|unheart)\s+" + It + @"$|^(?:please\s+)?(?:remove|take)\s+" + It + @"\s+(?:out\s+of|from)\s+(?:my\s+)?(?:likes|liked songs)$", RegexOptions.IgnoreCase)) return "unlike";
            return null;
        }

#if !CROSS
        // Brings it up when it has no window to bring forward, like when it's tucked in the tray.
        internal static bool Show()
        {
            string program = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Programs\YouTube Music for Desktop\ytmdesktop.exe");
            if (!Hands.Exists(program)) return false;
            // Started again, it should bring up the copy that's running (not yet tried on a real PC, see characters/lucy/NOTES.md).
            Hands.Run(program);
            return true;
        }
#endif

        // The port they set for its API, from its settings file, or its default.
        private static int Port()
        {
            try
            {
                string settings = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "YouTube Music for Desktop", "app-settings.yml");
                Match port = Regex.Match(File.Exists(settings) ? File.ReadAllText(settings) : "", @"(?m)^api:[ \t]*\r?\n(?:[ \t]+.*\r?\n)*?[ \t]+port:[ \t]*(\d+)");
                int number;
                if (port.Success && int.TryParse(port.Groups[1].Value, out number) && number > 0 && number < 65536) return number;
            }
            catch (IOException) { }
            catch (UnauthorizedAccessException) { }
            return DefaultPort;
        }

        private static string Ask(string path, string body)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://127.0.0.1:" + Port() + path);
            request.Proxy = null;
            request.Timeout = 3000;
            request.ReadWriteTimeout = 3000;
            try
            {
                if (body != null)
                {
                    byte[] bytes = Encoding.UTF8.GetBytes(body);
                    request.Method = "POST";
                    request.ContentType = "application/json";
                    request.ContentLength = bytes.Length;
                    using (Stream sending = request.GetRequestStream()) sending.Write(bytes, 0, bytes.Length);
                }
                using (WebResponse response = request.GetResponse())
                using (StreamReader reader = new StreamReader(response.GetResponseStream(), Encoding.UTF8)) return reader.ReadToEnd();
            }
            catch (WebException) { return null; }
            catch (IOException) { return null; }
        }

#if !CROSS
        // Her self-test's YouTube Music checks, with its API, Windows' media session and her hands swapped out: null, or what went wrong.
        internal static string Check()
        {
            Func<string, string, string> callWas = Call;
            Func<List<Tune>> sessionsWas = Hands.Sessions;
            Func<Tune, string, bool> pressWas = Hands.SessionPress;
            Func<Tune, string, bool> sendWas = Tunes.Send;
            Func<string, string> fetchWas = Hands.Fetch;
            Action<string> runWas = Hands.Run;
            Func<string, bool> existsWas = Hands.Exists;
            Func<List<OpenWindow>> windowsWas = Hands.Windows;
            List<string> sent = new List<string>();
            List<string> ran = new List<string>();
            string state = "{\"liked\":false,\"disliked\":false}";
            try
            {
                Hands.Run = delegate(string id) { ran.Add(id); };
                Call =delegate(string path, string body) { sent.Add(path + " " + body); return state == null ? null : path == "/track/state" ? state : "true"; };
                Tune ytm = new Tune { App = "net.venipa.ytmdesktop", Title = "Numb", Artist = "Linkin Park", Playing = true };
                Tune spotify = new Tune { App = "Spotify.exe", Title = "Numb", Artist = "Linkin Park", Playing = true };
                // Her media tool likes the playing song through its session, which goes Tunes.Send's way.
                Hands.SessionPress = delegate(Tune pressing, string what) { return Tunes.Send(pressing, what); };
                if (!ytm.Hearts || !spotify.Hearts || new Tune { App = "Chrome" }.Hearts || Tunes.AppName(ytm.App) != "YouTube Music") return "YouTube Music's songs got no heart in the mini player, or Chrome's did.";
                bool? unliked = Liked();
                state = "{\"liked\":true,\"disliked\":false}";
                bool? liked = Liked();
                state = null;
                bool? off = Liked();
                state = "{\"liked\":false,\"disliked\":false}";
                if (unliked != false || liked != true || off != null) return "YouTube Music's like state read wrong: " + unliked + ", " + liked + ", " + off;

                string[,] asks = { { "like this song", "like" }, { "Like this.", "like" }, { "heart it", "like" }, { "add this to my liked songs", "like" }, { "unlike this song", "unlike" }, { "take this out of my likes", "unlike" }, { "I like this song", null }, { "like that?", null }, { "like what", null } };
                for (int i = 0; i < asks.GetLength(0); i++) if (Liking(asks[i, 0]) != asks[i, 1]) return "\"" + asks[i, 0] + "\" read as " + (Liking(asks[i, 0]) ?? "nothing") + ".";
                string tool;
                ToolArguments args;
                if (!Hands.Direct("like this song", out tool, out args) || tool != "media" || args.Action != "like") return "\"Like this song\" didn't become a like: " + tool;
                Hands.Sessions = delegate { return new List<Tune> { ytm }; };
                sent.Clear();
                string said = Hands.Do("media", args);
                if (said != "Liked the song." || !sent.Contains("/track/like true")) return "A like for YouTube Music went wrong: " + said + " / " + string.Join(", ", sent.ToArray());
                List<string> pressed = new List<string>();
                Hands.Sessions = delegate { return new List<Tune> { spotify }; };
                Tunes.Send = delegate(Tune pressing, string what) { pressed.Add(what); return true; };
                args.Action = "unlike";
                said = Hands.Do("media", args);
                if (said != "Removed the song from your likes." || pressed.Count != 1 || pressed[0] != "unlike") return "An unlike for Spotify went wrong: " + said;

                if (!Hands.Direct("play numb on youtube music", out tool, out args) || tool != "play_music" || args.App != "youtube music" || args.Song != "numb") return "\"Play numb on YouTube Music\" read wrong: " + tool + " " + (args == null ? "" : args.App + " / " + args.Song);
                Hands.Fetch = delegate { return "\"videoId\":\"kXYiU_JCYtU\""; };
                sent.Clear();
                said = Hands.Do("play_music", args);
                if (said != "Playing numb on YouTube Music." || !sent.Contains("/nav/watch {\"videoId\":\"kXYiU_JCYtU\"}")) return "Playing a song in YouTube Music went wrong: " + said + " / " + string.Join(", ", sent.ToArray());
                Hands.Fetch = delegate { return ""; };
                sent.Clear();
                said = Hands.Do("play_music", args);
                if (!sent.Contains("/nav/open {\"url\":\"https://music.youtube.com/search?q=numb\"}")) return "A song YouTube didn't find didn't open YouTube Music's search: " + said;

                if (ran.Count > 0) return "YouTube Music in the app also opened " + ran[0] + ".";
                Hands.Windows = delegate { return new List<OpenWindow>(); };
                Hands.Exists = delegate { return true; };
                if (!Tunes.Open(ytm) || ran.Count != 1 || !ran[0].EndsWith(@"\ytmdesktop.exe", StringComparison.OrdinalIgnoreCase)) return "Opening YouTube Music from the mini player went wrong: " + string.Join(", ", ran.ToArray());
                return null;
            }
            finally
            {
                Call = callWas;
                Hands.Sessions = sessionsWas;
                Hands.SessionPress = pressWas;
                Tunes.Send = sendWas;
                Hands.Fetch = fetchWas;
                Hands.Run = runWas;
                Hands.Exists = existsWas;
                Hands.Windows = windowsWas;
            }
        }
#endif
    }
}
