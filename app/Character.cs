namespace CapriDesktop
{
    // Capri's own words, for a build without -Character. A character's characters/<name>/Character.cs takes this file's place,
    // so her lines stay out of Capri's files and syncing capri-desktop stays easy (see characters/lucy/NOTES.md)
    internal static class Character
    {
        internal const string Speaker = "CAPRI: ";
        internal const string Declined = "[SIGNAL CORRUPTED] Lost that one in the static. Ask me something else?";
        // The note her memories go in when they pick an Obsidian vault.
        internal const string VaultNote = "Capri Memories.md";
        internal const string Sparked = "[SIGNAL CORRUPTED] Something in my head just sparked. Try me again?";
        internal static readonly string[] PopLines = { "Boo. Just checking on you.", "Hi! Don't mind me.", "Peekaboo.", "Miss me? I missed you.", "Hey, you. Having fun?", "Surprise. I got bored without you.", "Don't get up.", "Just passing through.", "Thought I heard my name.", "Pretend I'm not here." };
        internal static readonly string[] HalloweenLines = { "Happy Halloween, choom!", "Happy Halloween, choom. Trick or treat?", "Boo! Happy Halloween, choom." };
    }
}
