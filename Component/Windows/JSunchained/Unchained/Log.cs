using System.Diagnostics;
using System.Runtime.CompilerServices;

namespace Unchained
{
    public static class Log
    {
        public static void WriteU(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { if (Constant.DEBUG) Debug.WriteLine(string.Format("UNKNOWN (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }
        public static void WriteD(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { if (Constant.DEBUG) Debug.WriteLine(string.Format("DEFAULT (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }
        public static void WriteV(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { if (Constant.DEBUG) Debug.WriteLine(string.Format("VERBOSE (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }
        public static void WriteDE(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { if (Constant.DEBUG) Debug.WriteLine(string.Format("DEBUG (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }
        public static void WriteI(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { if (Constant.DEBUG) Debug.WriteLine(string.Format("INFO (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }
        public static void WriteS(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { if (Constant.DEBUG) Debug.WriteLine(string.Format("SILENT (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }

        public static void WriteW(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("WARNING (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }
        public static void WriteE(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("ERROR (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }
        public static void WriteF(string className, string message = null, [CallerMemberName] string callerName = "",
            [CallerLineNumber] int callerLine = -1)
        { Debug.WriteLine(string.Format("FATAL (Unchained): {0}.{1}[{2}]{3}", className, callerName, callerLine, message)); }

    }
}
