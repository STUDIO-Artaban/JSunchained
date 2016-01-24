using System;
using System.Linq;
using System.Threading.Tasks;

using Windows.Media.Capture;

using Windows.Devices.Enumeration;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml;

namespace Unchained.Features
{
    ////// Core (delegates)
    public delegate Task<bool> StartCamDelegate(char device, short width, short height);
    public delegate Task<bool> StopCamDelegate();

    public class Camera
    {
        public Camera(RelativePanel panel)
        {
            Log.WriteV(" - Camera");

            // Create and add UI capture element to the relative panel
            _captureElement = new CaptureElement();
            panel.Children.Add(_captureElement);
        }

        private MediaCapture _mediaCapture;
        private CaptureElement _captureElement;

        public async Task<bool> Initialize()
        {
            Log.WriteV();
            if (_mediaCapture == null)
            {
                // Attempt to get the back camera if one is available, but use any camera device if not

                // Get available devices for capturing pictures
                var allVideoDevices = await DeviceInformation.FindAllAsync(DeviceClass.VideoCapture);

                // Get the default camera
                var cameraDevice = allVideoDevices.FirstOrDefault();

                if (cameraDevice == null)
                {
                    Log.WriteE(" - No camera device found!");
                    return false;
                }

                // Create MediaCapture and its settings
                _mediaCapture = new MediaCapture();
                var settings = new MediaCaptureInitializationSettings { VideoDeviceId = cameraDevice.Id };

                // Initialize MediaCapture
                try
                {
                    await _mediaCapture.InitializeAsync(settings);
                }
                catch (UnauthorizedAccessException)
                {
                    Log.WriteF(" - The app was denied access to the camera");
                    return false;
                }
            }
            return true;
        }

        public async Task<bool> Start(char device, short width, short height)
        {
            Log.WriteV(String.Format(" - d:{0};w:{1};h:{2}", device, width, height));

            if (!await Initialize())
                return false;

            // Set the preview source in the UI and mirror it if necessary
            _captureElement.Source = _mediaCapture;
            _captureElement.FlowDirection = FlowDirection.LeftToRight;

            // Start the preview
            await _mediaCapture.StartPreviewAsync();



            /*
            // Get information about the preview
            var previewProperties = _mediaCapture.VideoDeviceController.GetMediaStreamProperties(MediaStreamType.VideoPreview) as VideoEncodingProperties;

            // Create the video frame to request a SoftwareBitmap preview frame
            var videoFrame = new VideoFrame(BitmapPixelFormat.Rgba8, (int)previewProperties.Width, (int)previewProperties.Height);

            // Capture the preview frame
            using (var currentFrame = await _mediaCapture.GetPreviewFrameAsync(videoFrame))
            {
                // Collect the resulting frame
                SoftwareBitmap previewFrame = currentFrame.SoftwareBitmap;



                Debug.WriteLine(String.Format("{0}x{1} {2}", previewFrame.PixelWidth, previewFrame.PixelHeight, previewFrame.BitmapPixelFormat));



            }
            */





            /*
            private unsafe void EditPixels(SoftwareBitmap bitmap)
            {
                // Effect is hard-coded to operate on BGRA8 format only
                if (bitmap.BitmapPixelFormat == BitmapPixelFormat.Bgra8)
                {
                    // In BGRA8 format, each pixel is defined by 4 bytes
                    const int BYTES_PER_PIXEL = 4;

                    using (var buffer = bitmap.LockBuffer(BitmapBufferAccessMode.ReadWrite))
                    using (var reference = buffer.CreateReference())
                    {
                        // Get a pointer to the pixel buffer
                        byte* data;
                        uint capacity;
                        ((IMemoryBufferByteAccess)reference).GetBuffer(out data, out capacity);

                        // Get information about the BitmapBuffer
                        var desc = buffer.GetPlaneDescription(0);

                        // Iterate over all pixels
                        for (uint row = 0; row < desc.Height; row++)
                        {
                            for (uint col = 0; col < desc.Width; col++)
                            {
                                // Index of the current pixel in the buffer (defined by the next 4 bytes, BGRA8)
                                var currPixel = desc.StartIndex + desc.Stride * row + BYTES_PER_PIXEL * col;

                                // Read the current pixel information into b,g,r channels (leave out alpha channel)
                                var b = data[currPixel + 0]; // Blue
                                var g = data[currPixel + 1]; // Green
                                var r = data[currPixel + 2]; // Red

                                // Boost the green channel, leave the other two untouched
                                data[currPixel + 0] = b;
                                data[currPixel + 1] = (byte)Math.Min(g + 80, 255);
                                data[currPixel + 2] = r;
                            }
                        }
                    }
                }
            }
            */










            return true;
        }

        public async Task<bool> Stop()
        {
            Log.WriteV();




            return true;
        }
    }
}
