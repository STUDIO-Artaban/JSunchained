using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Windows.Media.Capture;

using System.Diagnostics;
using System.Runtime.InteropServices;

namespace Unchained.Features
{
    ////// Core (delegates)
    public delegate bool StartCamDelegate(char device, short width, short height);
    public delegate bool StopCamDelegate();

    public class Camera
    {
        public Camera()
        {
            Log.WriteV();



        }

        //
        private MediaCapture _mediaCapture;

        public bool Start(char device, short width, short height)
        {
            Log.WriteV(String.Format(" - d:{0};w:{1};h:{2}", device, width, height));




            return true;
        }
        public bool Stop()
        {
            Log.WriteV();




            return true;
        }
    }
}
