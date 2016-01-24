using System;
using System.Runtime.InteropServices;
using Windows.ApplicationModel;

using Unchained.Features;
using Windows.UI.Xaml.Controls;
using Windows.Foundation;

namespace Unchained
{
    public class UView
    {
        public UView()
        {
            Log.WriteV(" - UView");

            _relativePanel = new RelativePanel();
            _webView = new WebView();
            _camera = new Camera(_relativePanel);

            _relativePanel.Children.Add(_webView);

            PlatformData platformData = new PlatformData();
            platformData.startCam = _camera.Start;
            platformData.stopCam = _camera.Stop;
            try
            {
                unchainedInit(platformData);
            }
            catch (DllNotFoundException e)
            {
                Log.WriteF(e.Message);
            }
        }

        ////// Tools
        public void Load(String url, String version)
        {





            _webView.Navigate(new Uri(url));






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





        ////// UI element
        private static WebView _webView;
        public double Width
        {
            get { return _webView.Width; }
            set { _webView.Width = value; }
        }
        public double Height
        {
            get { return _webView.Height; }
            set { _webView.Height = value; }
        }

        private RelativePanel _relativePanel;
        public RelativePanel Panel
        {
            get { return _relativePanel; }
        }

        ////// Application
        public void Suspending(object sender, SuspendingEventArgs e)
        {
            Log.WriteV(string.Format(" - s:{0};e:{1}", sender.ToString(), e.ToString()));




        }
        public void Resuming(object sender, object o)
        {
            Log.WriteV(string.Format(" - s:{0};o:{1}", sender.ToString(), o.ToString()));




        }

        ////// Resources
        private Camera _camera;

    }
}
