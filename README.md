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

Comme vous pouvez le voir ci-dessous, lorsqu'une même page Web utilisant la librairie **JSunchained** est affiché depuis un **OS** non géré (comme **Linux**, sur **Firefox**), et via une application 

**NB:** Avant toute installation veillez à importer les sous-modules avec les commandes **git** ci-dessous.

```bash
$ cd JSunchained/
$ git submodule init
$ git submodule update --remote
```
