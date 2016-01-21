using System.Runtime.InteropServices;

using Windows.ApplicationModel;
using Windows.ApplicationModel.Activation;

using Unchained.Features;

namespace Unchained
{
    public class UView
    {
        public UView()
        {
            Log.WriteV();

            _camera = new Camera();

            PlatformData platformData = new PlatformData();
            platformData.startCam = _camera.Start;
            platformData.stopCam = _camera.Stop;
            unchainedInit(platformData);




            /*
            Debug.WriteLine("UView: Constructor");
            try
            {
                unchainedStop();
            }
            catch (DllNotFoundException e) { Debug.WriteLine(e.Message); }
            Debug.WriteLine("UView: DONE");
            */

            /* Debug.WriteLine(String.Format("ResultA: {0}", Camera.Instance.test.ToString()));


            

            Debug.WriteLine("UView: Constructor");
            try {
                int res = unchainedReady();
                Debug.WriteLine(String.Format("ResultB: {0}", res.ToString()));
            }
            catch (DllNotFoundException e) { Debug.WriteLine(e.Message); }



            Debug.WriteLine(String.Format("ResultC: {0}", Camera.Instance.test.ToString()));
            */


            /* test = 999;

            startCamFunc myCallBack = new startCamFunc(Start);
            unchainedTest(myCallBack);
            */




        }

        ////// Application
        public void InitializeComponent()
        {
            Log.WriteV();



        }
        public void OnLaunched(LaunchActivatedEventArgs e)
        {
            Log.WriteV(string.Format(" - e:{0}", e.ToString()));



        }
        public void OnSuspending(object sender, SuspendingEventArgs e)
        {
            Log.WriteV(string.Format(" - s:{0};e:{1}", sender.ToString(), e.ToString()));



        }

        ////// Core
        [StructLayout(LayoutKind.Sequential)]
        public struct PlatformData
        {
            public float xDpi;
            public float yDpi;

            public StartCamDelegate startCam;
            public StopCamDelegate stopCam;
        }
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedInit(PlatformData data);
        /* [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern String unchainedKey();
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern bool unchainedReady();
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedPermission(short allowed);
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern char unchainedReset(String url);

        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern char unchainedStart(String url, String version);
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedResume();
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedPause();
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedStop(); */


        //UNCHAINED_API void unchainedAccel(float x, float y, float z);
        //UNCHAINED_API void unchainedCamera(const unsigned char* data);




        ////// Resources
        private Camera _camera;

    }
}
