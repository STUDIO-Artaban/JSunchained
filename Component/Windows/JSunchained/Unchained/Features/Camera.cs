using System;
using System.Linq;
using System.Threading.Tasks;

using Windows.Media.Capture;

using Windows.Devices.Enumeration;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml;
using Windows.Media.MediaProperties;
using Windows.Media;
using Windows.Graphics.Imaging;
using Windows.Foundation;
using Windows.UI.Xaml.Media.Imaging;
using System.IO;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Runtime.InteropServices;
using Windows.UI.Core;

namespace Unchained.Features
{
    ////// Core (delegates)
    public delegate bool StartCamDelegate(char device, short width, short height);
    public delegate bool StopCamDelegate();

    public class Camera
    {
        public Camera(RelativePanel panel)
        {
            Log.WriteV(this.GetType().Name);

            // Create and add UI capture element to the relative panel
            _captureElement = new CaptureElement
            {
                HorizontalAlignment = HorizontalAlignment.Left,
                VerticalAlignment = VerticalAlignment.Top,
                MaxWidth = 1,
                MaxHeight = 1,
            };
            panel.Children.Add(_captureElement);
        }

        //
        public CoreDispatcher CoreDispatcher { get; set; }

        private MediaCapture _mediaCapture;
        private CaptureElement _captureElement;

        public async Task<bool> Initialize(short width, short height)
        {
            Log.WriteV(this.GetType().Name);
            if (_mediaCapture == null)
            {
                // Attempt to get the default camera if one is available
                var allVideoDevices = await DeviceInformation.FindAllAsync(DeviceClass.VideoCapture);

                var cameraDevice = allVideoDevices.FirstOrDefault();
                if (cameraDevice == null)
                {
                    Log.WriteE(this.GetType().Name, " - No camera device found!");
                    return false;
                }








                /* Get camera according expected resolution
                // Get information about the preview
                var previewProperties = _mediaCapture.VideoDeviceController.GetMediaStreamProperties(MediaStreamType.VideoPreview) as VideoEncodingProperties;
                IMediaEncodingProperties properties = _mediaCapture.VideoDeviceController.GetAvailableMediaStreamProperties(MediaStreamType.VideoPreview).FirstOrDefault();
                (properties as VideoEncodingProperties).Width = (uint)width;
                (properties as VideoEncodingProperties).Height = (uint)height;
                await _mediaCapture.VideoDeviceController.SetMediaStreamPropertiesAsync(MediaStreamType.VideoPreview, properties);
                */






                // Create MediaCapture and its settings
                _mediaCapture = new MediaCapture();
                var settings = new MediaCaptureInitializationSettings
                {
                    VideoDeviceId = cameraDevice.Id,
                    StreamingCaptureMode = StreamingCaptureMode.Video
                };

                // Initialize MediaCapture
                try
                {
                    await _mediaCapture.InitializeAsync(settings);
                }
                catch (UnauthorizedAccessException)
                {
                    Log.WriteF(this.GetType().Name, " - The app was denied access to the camera");
                    _mediaCapture = null;
                    return false;
                }
            }
            return true;
        }


        private bool initializing;


        private Task _previewTask;
        private bool _running;
        public bool Start(char device, short width, short height)
        {
            Log.WriteV(this.GetType().Name, String.Format(" - d:{0};w:{1};h:{2}", (int)device, width, height));

            CoreDispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
            {
                if (!await Initialize(width, height))
                    return;

                // Set the preview source in the UI and mirror it if necessary
                _captureElement.Source = _mediaCapture;
                _captureElement.FlowDirection = FlowDirection.LeftToRight;

                // Start the preview
                await _mediaCapture.StartPreviewAsync();

                _running = true;
                _previewTask = new Task(async () =>
                {
                    Windows.Storage.Streams.Buffer data = new Windows.Storage.Streams.Buffer((uint)(width * height * 4));
                    MemoryStream memory = new MemoryStream((int)(width * height * 4));


                    while (_running)
                    {
                        // Create the video frame to request a SoftwareBitmap preview frame
                        var videoFrame = new VideoFrame(BitmapPixelFormat.Rgba8, (int)width, (int)height);

                        using (var currentFrame = await _mediaCapture.GetPreviewFrameAsync(videoFrame))
                        {
                            // Collect the resulting frame
                            currentFrame.SoftwareBitmap.CopyToBuffer(data);
                            data.AsStream().CopyTo(memory);

                            unchainedCamera(memory.ToArray());
                        }
                    }
                }, TaskCreationOptions.None);
                _previewTask.Start();
            });
            return true;
        }

        public bool Stop()
        {
            Log.WriteV(this.GetType().Name);

            if (!_running)
                return false;

            CoreDispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
            {
                _running = false;
                await _previewTask;

                await _mediaCapture.StopPreviewAsync();
            });
            return true;
        }

        ////// Core
        [DllImport("JSunchained.dll", CallingConvention = CallingConvention.Cdecl)]
        private static extern void unchainedCamera(byte[] data);

    }
}
