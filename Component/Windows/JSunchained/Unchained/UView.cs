﻿using System;
using System.Runtime.InteropServices;
using Windows.ApplicationModel;

using Unchained.Features;
using Windows.UI.Xaml.Controls;
using Windows.Foundation;
using Windows.Devices.Sensors;
using Windows.UI.Xaml;
using Windows.UI.Core;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.IO;

namespace Unchained
{
    public class UView
    {
        public UView()
        {
            Log.WriteV(this.GetType().Name);

            _relativePanel = new RelativePanel();
            _webView = new WebView();
            _camera = new Camera(_relativePanel);

            _relativePanel.Children.Add(_webView);

            Application.Current.Resuming += Resuming;
            Application.Current.Suspending += Suspending;

            //_webView.AllowedScriptNotifyUris = WebView.AnyScriptNotifyUri;
            //_webView.ClearTemporaryWebDataAsync();
            _webView.NavigationStarting += NavigationStarting;
            _webView.ContentLoading += ContentLoading;
            _webView.ScriptNotify += ScriptNotify;

            _accelerometer = Accelerometer.GetDefault();
            if (_accelerometer != null)
            {
                // Establish the report interval
                _accelerometer.ReportInterval = (_accelerometer.MinimumReportInterval > Constant.ACCEL_MIN_REPORT) ?
                    _accelerometer.MinimumReportInterval : Constant.ACCEL_MIN_REPORT;

                Window.Current.VisibilityChanged += new WindowVisibilityChangedEventHandler(VisibilityChanged);
                _accelerometer.ReadingChanged += new TypedEventHandler<Accelerometer,
                    AccelerometerReadingChangedEventArgs>(AccelChanged);
            }
            else
                Log.WriteI(this.GetType().Name, " - No accelerometer found");

            PlatformData platformData = new PlatformData();
            platformData.xDpi = 0.0f;
            platformData.yDpi = 0.0f;
            platformData.startCam = _camera.Start;
            platformData.stopCam = _camera.Stop;
            platformData.appPath = Directory.GetCurrentDirectory();

            try { unchainedInit(ref platformData); }
            catch (DllNotFoundException e) { Log.WriteF(this.GetType().Name, String.Format(" - {0}", e.Message)); }
        }

        //
        private void NavigationStarting(WebView sender, WebViewNavigationStartingEventArgs args)
        {
            Log.WriteV(this.GetType().Name, String.Format(" - s:{0};e:{1}", sender.ToString(), args.Uri.ToString()));
            if (_started)
            {
                int pos = args.Uri.ToString().IndexOf('/', args.Uri.ToString().LastIndexOf("//") + 2);
                if (pos < 0)
                    unchainedReset(args.Uri.ToString());
                else
                    unchainedReset(args.Uri.ToString().Substring(0, pos));
            }
            _started = true;
        }
        private void ContentLoading(WebView sender, WebViewContentLoadingEventArgs args)
        {
            Log.WriteV(this.GetType().Name, String.Format(" - s:{0};e:{1}", sender.ToString(), args.Uri.ToString()));
            _webView.InvokeScriptAsync("eval", new string[] { "console.log=function(msg){window.external.notify(msg);};" });
        }
        private void ScriptNotify(object sender, NotifyEventArgs e)
        {
            // Log JavaScript console
            Log.WriteI(this.GetType().Name, String.Format(" - {0}", e.Value));
        }

        ////// Tools
        private static String ASSETS_PROTOCOL = "assets://";
        private bool _assetsProtocol = false;
        private bool _started = false;

        public void Load(String url, String version)
        {
            Log.WriteV(this.GetType().Name, String.Format(" - u:{0};v:{1}", url, version));
            if (version == null)
                version = Constant.VERSION_LAST;

            _assetsProtocol = url.StartsWith(ASSETS_PROTOCOL);
            if (_assetsProtocol)
                throw new NotImplementedException();

            int pos = url.IndexOf('/', url.LastIndexOf("//") + 2);
            if (pos < 0)
                unchainedStart(url, version);
            else
                unchainedStart(url.Substring(0, pos), version);

            _camera.CoreDispatcher = CoreWindow.GetForCurrentThread().Dispatcher;
            while (!unchainedReady())
                Task.Delay(1);

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

            public string appPath;

        }
        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedInit(ref PlatformData data);
        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool unchainedReady();
        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern char unchainedReset(string url);

        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern char unchainedStart(string url, string version);
        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedResume();
        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedPause();
        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedStop();

        [DllImport("JSunchained.dll", ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedAccel(float x, float y, float z);

        ////// UI
        private WebView _webView;
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
        public RelativePanel Control
        {
            get { return _relativePanel; }
        }

        ////// Application
        private void Suspending(object sender, SuspendingEventArgs e)
        {
            Log.WriteV(this.GetType().Name, string.Format(" - s:{0};e:{1}", sender.ToString(), e.ToString()));

            unchainedPause();
            unchainedStop();
        }
        private void Resuming(object sender, object o)
        {
            Log.WriteV(this.GetType().Name, string.Format(" - s:{0};o:{1}", sender.ToString(), o.ToString()));
            unchainedResume();
        }

        ////// Resources
        private Camera _camera;

        private Accelerometer _accelerometer;
        private void VisibilityChanged(object sender, VisibilityChangedEventArgs e)
        {
            Log.WriteV(this.GetType().Name, string.Format(" - s:{0};e:{1}", sender.ToString(), e.Visible));
            if (_accelerometer == null)
                return;

            if (e.Visible)
                _accelerometer.ReadingChanged += new TypedEventHandler<Accelerometer,
                    AccelerometerReadingChangedEventArgs>(AccelChanged);
            else
                _accelerometer.ReadingChanged -= new TypedEventHandler<Accelerometer,
                    AccelerometerReadingChangedEventArgs>(AccelChanged);
        }
        private void AccelChanged(object sender, AccelerometerReadingChangedEventArgs e)
        {
            AccelerometerReading reading = e.Reading;
            unchainedAccel((float)reading.AccelerationX * Constant.ACCEL_FACTOR,
                           (float)reading.AccelerationY * Constant.ACCEL_FACTOR,
                           (float)reading.AccelerationZ * Constant.ACCEL_FACTOR);
        }
    }
}
