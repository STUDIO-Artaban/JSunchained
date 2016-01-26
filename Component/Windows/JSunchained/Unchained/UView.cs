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

namespace Unchained
{
    public class UView
    {
        public UView()
        {
            Log.WriteV(this.GetType().Name);
            _assetsProtocol = false;
            _started = false;

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

                Application.Current.Resuming += Resuming;
                Application.Current.Suspending += Suspending;

                //_webView.AllowedScriptNotifyUris = WebView.AnyScriptNotifyUri;
                _webView.NavigationStarting += NavigationStarting;
                _webView.NavigationCompleted += NavigationCompleted;
                _webView.ScriptNotify += ScriptNotify;

                _accelerometer = Accelerometer.GetDefault();
                if (_accelerometer != null)
                {
                    // Establish the report interval
                    _accelerometer.ReportInterval = (_accelerometer.MinimumReportInterval > ACCEL_MIN_REPORT) ?
                        _accelerometer.MinimumReportInterval : ACCEL_MIN_REPORT;

                    Window.Current.VisibilityChanged += new WindowVisibilityChangedEventHandler(VisibilityChanged);
                    _accelerometer.ReadingChanged += new TypedEventHandler<Accelerometer,
                        AccelerometerReadingChangedEventArgs>(AccelChanged);
                }
                else
                    Log.WriteI(this.GetType().Name, " - No accelerometer found");
            }
            catch (DllNotFoundException e)
            {
                Log.WriteF(this.GetType().Name, String.Format(" - {0}", e.Message));
            }
            catch (Exception e)
            {
                Log.WriteE(this.GetType().Name, String.Format(" - {0}", e.Message));
            }
        }

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
            _webView.InvokeScriptAsync("eval", new string[] { "window.console.log=function(msg){window.external.notify(msg);};" });
        }
        private void NavigationCompleted(WebView sender, WebViewNavigationCompletedEventArgs args)
        {
            Log.WriteV(this.GetType().Name, String.Format(" - s:{0};e:{1}", sender.ToString(), args.IsSuccess));
            if (!args.IsSuccess)
                Log.WriteW(this.GetType().Name, String.Format(" - {0}", args.WebErrorStatus.ToString()));

            while (!unchainedReady())
                Task.Delay(1);

            Log.WriteI(this.GetType().Name, " - Ready!");
        }
        private void ScriptNotify(object sender, NotifyEventArgs e)
        {
            Log.WriteI("JavaScript", String.Format(" - {0}", e.Value));
        }

        ////// Version
        private static String VERSION_LAST = " ";
	    private static String VERSION_1_0_0 = "1.0.0";

        ////// Tools
        private static String ASSETS_PROTOCOL = "assets://";
        private bool _assetsProtocol;
        private bool _started;

        public void Load(String url, String version)
        {
            Log.WriteV(this.GetType().Name, String.Format(" - u:{0};v:{1}", url, version));
            if (version == null)
                version = VERSION_LAST;

            _assetsProtocol = url.StartsWith(ASSETS_PROTOCOL);
            if (_assetsProtocol)
                throw new NotImplementedException();

            int pos = url.IndexOf('/', url.LastIndexOf("//") + 2);
            if (pos < 0)
                unchainedStart(url, version);
            else
                unchainedStart(url.Substring(0, pos), version);

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
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern bool unchainedReady();
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern char unchainedReset(string url);

        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern char unchainedStart(string url, string version);
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedResume();
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedPause();
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedStop();

        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedAccel(float x, float y, float z);

        ////// UI element
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

        private static uint ACCEL_MIN_REPORT = 16;
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
            //Log.WriteV(this.GetType().Name, string.Format(" - s:{0};e:{1}", sender.ToString(), e.Reading.ToString()));
            AccelerometerReading reading = e.Reading;
            unchainedAccel((float)reading.AccelerationX, (float)reading.AccelerationY, (float)reading.AccelerationZ);
        }
    }
}
