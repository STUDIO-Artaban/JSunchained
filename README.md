# [JSunchained](https://github.com/STUDIO-Artaban/JSunchained)
**JSunchained** est un projet visant à faire du langage **JavaScript** un langage système, permettant de créer des applications "cross-platform" sans les contraintes liées à la nature de ce langage.

![JSunchained icon](https://github.com/STUDIO-Artaban/JSunchained/blob/master/JSunchained.png)

En effet, **JavaScript** dépend du navigateur dans lequel l'**HTML** contenant le code est chargé. De ce fait, il est alors difficile voir impossible d'accéder à certaines ressources de l'**OS**, tel que: l'espace de stockage, la caméra (ou Webcam), le Bluetooth, la liste des contacts (si il s'agit d'un **OS** sur mobile), etc.

**JSunchained** permet justement de faire tomber ces contraintes, de libérer ce langage, et ce grâce à l'objet **JavaScript** `window.unchained` de la librairie [http://code.jsunchained.com/unchained.js](http://code.jsunchained.com/unchained.js), et à un composant de type **WebView** appelé `UView`.

Comme vous l'aurez sans doute compris, ce composant dépend de l'**OS** sur lequel vous souhaitez créer votre application. Actuellement il en existe quatre:
* [Android](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Android)
* [iOS](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/iOS)
* [Windows](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Windows) (UWP)
* [Mac](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Mac)

Comme vous pouvez le voir dans cet exemple ci-dessous, lorsqu'une page Web utilisant la librairie **JSunchained** est affichée depuis un **OS** non géré (comme **Linux**, sur un navigateur comme **Firefox** ici), ou via une application utilisant le composant `UView` d'un **OS** géré (comme [Android](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Android)), vous constaterez qu'elle met bien en oeuvre le code **JavaScript** défini dans cette même page uniquement sous l'**OS** géré (voir ligne 22 du fichier [demo.html](https://github.com/STUDIO-Artaban/JSunchained/blob/master/Test/Android/YourSiteApp/assets/demo.html) via [http://jsunchained.com/demo.html](http://jsunchained.com/demo.html)).

**OS** non géré (Linux):

![Unmanaged](https://github.com/STUDIO-Artaban/JSunchained/blob/master/Screenshots/NoJSU-demo.png)

**OS** géré (avec le composant `UView` d'[Android](https://github.com/STUDIO-Artaban/JSunchained/tree/master/Component/Android)):

![Managed](https://github.com/STUDIO-Artaban/JSunchained/blob/master/Screenshots/JSU-demo.png)

**NB:** Avant toute installation veillez à importer les sous-modules avec les commandes **git** ci-dessous.

```bash
$ cd JSunchained/
$ git submodule init
$ git submodule update --remote
```
