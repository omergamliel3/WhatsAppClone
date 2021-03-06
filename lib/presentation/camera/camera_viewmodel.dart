import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../../core/routes/router.dart';
import '../../locator.dart';

class CameraViewModel extends BaseViewModel {
  final router = locator<Router>();

  List<CameraDescription> cameras;

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  bool _isRearCamera = true;

  CameraController get cameraController => _controller;
  Future<void> get initializeControllerFuture => _initializeControllerFuture;

  // initialise model properties
  Future<void> init() async {
    // Obtain a list of the available cameras on the device.
    cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final camera = cameras.first;
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  // switch between rear and front camera if possible
  void switchCamera() {
    _isRearCamera = !_isRearCamera;
    CameraDescription camera;

    if (_isRearCamera) {
      // Get the first camera from the list of cameras
      camera = cameras.first;
    } else {
      // If second camera is available
      if (cameras[1] != null) {
        // Get the second camera from the list of cameras
        camera = cameras[1];
      }
    }

    // create a new CamerController with new camera
    _controller = CameraController(camera, ResolutionPreset.medium);
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    notifyListeners();
  }

  // take picture callback
  Future<void> takePicture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Construct the path where the image should be saved using the path
      // package.
      final tempDirPath = await getTemporaryDirectory();

      final path = join(
        tempDirPath.path,
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );

      // Attempt to take a picture and log where it's been saved.
      await _controller.takePicture(path);

      // If the picture was taken, display it on a new screen
      router.navigateDisplayPicture(path);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the viewmodel is disposed.
    _controller.dispose();
    super.dispose();
  }
}
