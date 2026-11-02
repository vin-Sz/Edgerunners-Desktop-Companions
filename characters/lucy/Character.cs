namespace CapriDesktop
{
    // Lucy's own words. Building with -Character lucy uses this in place of app/Character.cs (see NOTES.md here)
    internal static class Character
    {
        internal const string Speaker = "LUCY: ";
        internal const string Declined = "[CONNECTION LOST] Dropped that one somewhere in the Net. Ask me something else?";
        // The note her memories go in when they pick an Obsidian vault.
        internal const string VaultNote = "Lucy Memories.md";
        internal const string Sparked ="[DAEMON INTERRUPT] Something got in my head for a second. Try me again?";
        internal static readonly string[] PopLines = { "Just checking on you, choom.", "Don't mind me.", "Found you.", "Miss me? ...Don't answer that.", "Hey. Having fun?", "Got quiet without you." };
        internal static readonly string[] HalloweenLines = { "Happy Halloween, choom.", "Happy Halloween. Trick or treat, choom?", "[ICE DETECTED] ...kidding. Happy Halloween, choom." };
    }
}
