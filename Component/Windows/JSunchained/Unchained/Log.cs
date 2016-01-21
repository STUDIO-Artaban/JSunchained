using System.Diagnostics;
using System.Runtime.CompilerServices;

namespace Unchained
{
    public static class Log
    {
        public static void WriteU(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("UNKNOWN (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }
        public static void WriteD(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("DEFAULT (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }
        public static void WriteV(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("VERBOSE (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }
        public static void WriteDE(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("DEBUG (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }
        public static void WriteI(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("INFO (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }
        public static void WriteS(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("SILENT (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }

        public static void WriteW(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("WARNING (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }
        public static void WriteE(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("ERROR (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }
        public static void WriteF(string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("FATAL (Unchained): {0}[{1}] {2}", callerName, callerLine, message)); }

    }
}
