<!-- # Conways Game of Life -->

<!-- [Conways Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) extended to support different game dimensions and display modes.  -->

<!-- | Shape | Render Type | Dimension |
| :--- |:---:| :---:|
| Square | [Collection View](#collectionView) | 2D |
| Square | [Core Graphics](#coreGraphics) | 2D |
| Square | [SceneKit](#sceneKit) | 2D |
| Flattened Cube | [Core Graphics](#flatCube) | 3D |
| Cube | [SceneKit](#cube) | 3D | -->
    
<a name="collectionView"></a>
## Collection View

Original square game rendered using a Collection View

<p align="center">
  <img src="/conwayCollectionGrid2.gif">
  <br><br>  
  Each   
  <a href="https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life">tick</a>
  the collection view's data is reloaded
  <br>
  Cells are set to entirely black or white based on their state: live or dead
  <br><br>
  Optimization made to only reload cells in which state has changed during the tick
</p>
<br><br>

<a name="coreGraphics"></a>
## Core Graphics

Original square game rendered using Core Graphics

<p align="center">
  <img src="/conwaysCoreGraphics.gif">
  <br><br>  
  UIView's draw function has been overwritten to fill in a grid with black and white cells
  <br>
  Without the overhead of a Collection View we can render many more cells with a faster tick speed
</p>
<br><br>

<a name="sceneKit"></a>
## Scene Kit & Metal

Original square game rendered using a SceneKit & Metal Shader

<p align="center">
  <img src="/conwaysSquareScenekit.gif">
  <br><br>  
  SceneKit gives us graphics pipeline and touch input for free 
  <br>
  SCNPrograms can be written in Apples' Metal language and injected into a Scene to 
  <a href="https://developer.apple.com/documentation/scenekit/scnprogram">completely replace default rendering</a>
  <br><br>
  Shader modifiers can be written for minor customizations of SceneKit's default rendering, but could not contain enough data for all Game of Life cells 
</p>
<br><br>

<a name="flatCube"></a>
## Flat Cube

Game engine is expanded to handle 6 faces of data that wrap onto their neibours like a flattened cube

<p align="center">
  <img src="/conwaysFlatCube.gif">
  <br><br>  
  This view is made up of 6 Core Graphics views 
  <br>
  Each face from the engine is delegated to one of the Core Graphics views
  <br><br>
  The center column contains faces: Top, Front, Bottom, Back
  <br>
  Notice at the end the live cells wrap from the right face onto the center face
</p>
<br><br>

<a name="cube"></a>
## Cube

Cube'd game rendered using a SceneKit & Metal Shader

<p align="center">
  <img src="/conwaysCube.gif">
  <br><br>  
  Metal Shader tweaked using vertex normal values to determine appropriate face 
</p>
<br><br>
