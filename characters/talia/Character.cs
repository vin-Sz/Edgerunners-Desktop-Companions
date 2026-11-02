namespace CapriDesktop
{
    // Talia's own words, first drafts. Building with -Character talia uses this in place of app/Character.cs (see NOTES.md here)
    internal static class Character
    {
        internal const string Speaker = "TALIA: ";
        internal const string Declined = "Nope. Not touching that one. Ask me something else?";
        // The note her memories go in when they pick an Obsidian vault.
        internal const string VaultNote = "Talia Memories.md";
        internal const string Sparked = "Ugh. My chrome just kicked. Give it a sec and try me again?";
        internal static readonly string[] PopLines = { "Still alive? Good.", "Don't mind me.", "Found you.", "Bored. Got anything to hit?", "Hey. You good?", "Just making sure nobody's messing with you." };
        internal static readonly string[] HalloweenLines = { "Happy Halloween, choom.", "Trick or treat. I'd pick trick.", "Happy Halloween. Night City looks the same to me." };
    }
}
