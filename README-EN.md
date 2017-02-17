# [JSunchained](https://github.com/STUDIO-Artaban/JSunchained)
**JSunchained** is a project which purpose is to make **JavaScript** a system language to be able to create "cross-platform" applications without the constraints of its nature.

![JSunchained icon](https://github.com/STUDIO-Artaban/JSunchained/blob/master/JSunchained.png)

Indeed **JavaScript** depends on the Internet navigator on which the **HTML** containing the code is loaded. Therefore it is very hard or impossible to access some **OS** resources such as: the space storage, the camera (or webcam), the contacts list (on **OS** mobile), etc.

**JSunchained** allows you to remove all of these constraints and free this language thanks to the `window.unchained` **JavaScript** library object [http://code.jsunchained.com/unchained.js](http://code.jsunchained.com/unchained.js) and a **WebView** component called `UView`.

I guess you understand that this component depends on the **OS** on which you want to create your application. Currently there are four:
* [Android](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Android)
* [iOS](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/iOS)
* [Windows](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Windows) (UWP)
* [Mac](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Mac)

As you can see in the example below (see [Test](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Test)), when a web page using the **JSunchained** library is displayed a none managed **OS** (as **Linux** on **Firefox** browser), or via an application using the `UView` component of a managed **OS** (as [Android](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Android)), you can see that it implements the **JavaScript** code as requested only under the managed **OS** (see line 22 of file [demo.html](https://github.com/STUDIO-Artaban/JSunchained/blob/master/Test/Android/YourSiteApp/assets/demo.html) via [http://jsunchained.com/demo.html](http://jsunchained.com/demo.html)).

Unmanaged **OS** (Linux):

![Unmanaged](https://github.com/STUDIO-Artaban/JSunchained/blob/master/Screenshots/NoJSU-demo.png)

Managed **OS** (using `UView` componenet on [Android](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Android)):

![Managed](https://github.com/STUDIO-Artaban/JSunchained/blob/master/Screenshots/JSU-demo.png)

**Note:** Before any installation do not forget to import the submodules with the **git** commands below.

```bash
$ cd JSunchained/
$ git submodule init
$ git submodule update --remote
```
