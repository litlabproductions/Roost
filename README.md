# Roost
  
### 3D Motocross Game  
#### Based on the replication of 250/450cc dirt bike physics  
<br/>&nbsp;&nbsp;&nbsp;&nbsp;a [***Lit Lab Production***](https://www.litlabproductions.com)
<br/>&nbsp;&nbsp;&nbsp;&nbsp;Built with [Unity3D](https://github.com/Unity-Technologies) and the 
[Universal Render Pipeline](https://docs.unity3d.com/Packages/com.unity.render-pipelines.universal@7.1/manual/index.html)<br>
<br/>&nbsp;&nbsp;&nbsp;&nbsp;**Note:** This repo a contains a build ***not*** source code
<br>
***

## Table of contents
- [Roost](#roost)
  - [Play](#play)
  - [Features](#features)
    - [Physics Based Movement](#physics-based-movement)
    - [Post Processing V2](#post-processing-v2)
    - [Responsive UI](#responsive-ui)
    - [Color System](#color-system)
    - [Low Poly Design](#low-poly-design)
    - [Cross Platform Capability](#cross-platform-capability)
  * [Physics Development](#physics-development)
    * [Suspension](#suspension)
    * [Transmission](#transmission)
    * [Engine](#engine)
    * [Wheels](#wheels)
  * [Miscellaneous Development](#miscellaneous-development)
    * [Terrain](#terrain)
    * [UI](#ui)
    * [Current Update](#current-update)
  * [Demos](#demos)
    * [Welcome to Mirage Gameplay Trailer](#welcome-to-mirage-gameplay-trailer)
    * [Menu with Bike Color System](#menu-with-bike-color-system)
    * [Soundtrack](#soundtrack)

***

## Play

#### Try it Here:
  1. &nbsp;&nbsp;[***LitLabProductions.com / Roost***](https://www.litlabproductions.com/roost) <br>
  2. &nbsp;&nbsp;[***https://simmer.io/@LitLabProd/roost***](https://simmer.io/@LitLabProd/roost) 

***
<br><br>
![roostlogo-resize03](https://user-images.githubusercontent.com/34845402/131585723-dcd5eed5-0184-48d6-b94e-c469b5ce6758.png)
<br><br>

## Features
### Physics Based Movement

  * *Fully responsive suspension simulation defined by 20+ parameters* <br><br><br>
  * **Variable System of Balance**
<br><br>
![ezgif com-optimize](https://user-images.githubusercontent.com/34845402/71435587-7a7e3080-269e-11ea-9343-a5d79f03a868.gif)
      * *Roll, pitch & yaw move independently to simulate the true feel of a mx bike* <br><br><br>
  * **Customizable Engine and Transmission**
 <br><br>
 ![ezgif com-optimize (1)](https://user-images.githubusercontent.com/34845402/71435589-7baf5d80-269e-11ea-9432-80d7f4a6e810.gif)
      * *Set **number of gears** as well as each gears **ratio, minimum** & **maximum RPM*** <br>
      * *Set engine ignition and an **input curve** controlling torgue output per unit of input* <br><br><br>
  * **Wheel Colliders**
<br><br>
![ezgif com-optimize (2)](https://user-images.githubusercontent.com/34845402/71435590-7d792100-269e-11ea-9291-2514322c6ce4.gif)
      * Semi-realistic ground collision & tire traction<br><br><br>

### Post Processing V2
  * *Combines complete set of rendered effects into a single pipeline*<br/><br/><br>

### Responsive UI
![roost-menu-demo00](https://user-images.githubusercontent.com/34845402/131198290-7bc626e1-2459-4208-8642-014e7915e209.gif)
  * *Responsive elements fit for any landscape resolution*<br><br><br>
    
### Color System
 ![roost-menu-demo02](https://user-images.githubusercontent.com/34845402/131198475-e4dd3f9e-2a88-46c9-b65c-faba4e241489.gif)
  * *Eight customizable bike parts using **16,777,216** possible hex colors or **6** premade textures*<br><br><br>

### Low Poly Design
![campsite02](https://user-images.githubusercontent.com/34845402/131205336-930cec8a-b22d-4d61-97dd-32d5c2e781d7.png)
  * *Bike/Character models contain a ***reduced*** poly count*<br><br><br>

![campsite](https://user-images.githubusercontent.com/34845402/131205438-814026ec-0cd2-40c4-be26-f3280486861c.png)
  * *Environment models contain a ***very low*** poly count*<br><br><br>

### Cross Platform Capability
  * *Runs on PC, macOS, iOS and Android*
<br>

***

<br>

## Physics Development

&nbsp;&nbsp;&nbsp;&nbsp;***Note:** A few examples of the development process are shown below* <br><br>
  * Bike model is first split into modular components <br><br>
![roost-phys-demo01](https://user-images.githubusercontent.com/34845402/131231640-0d91fed4-75d4-4001-8a88-b31c32bfd24b.gif)
![roost-phys-demo03](https://user-images.githubusercontent.com/34845402/131231950-c000fa65-669d-41f6-b4df-6e3ccc191121.gif)<br>
      * *Back shock & swing arm are shown*<br><br>
      
### Suspension
   * A **Suspension** script is attached to the **BSusp** game object <br><br>
![roost-susp02](https://user-images.githubusercontent.com/34845402/131621390-080f0f88-217e-4ac0-a2c7-509fb40509f6.png)
      * *The **BWheel** game objects **Wheel** script is attached to this **Suspension** scripts **Wheel** parameter* <br><br><br>
   * A **Suspension Part** script is attached to the **SwingArmPivot** game object <br><br>
![roost-susp05](https://user-images.githubusercontent.com/34845402/131626129-e75d1ef3-e063-4493-9e72-38fa31c1768a.png)
      * *The **BSusp** game objects **Suspension** script is then attached to this **Suspension Part** scripts **Suspension** parameter*
      * *The **BTire** game objects **Transform** is attached to this **Suspension Part** scripts **Connect Obj** parameter* <br><br>
 
### Transmission
   * Number of gears and start gear as well as each gears ratio, minimum & maximum RPM are set  <br><br>
![roost-gear01](https://user-images.githubusercontent.com/34845402/131616716-ed811c5a-b499-4132-9493-7a9df75a7b41.png)
<br><br>

### Engine
   * Engine input curve is adjusted for desired torque <br><br>
![roost-engine01](https://user-images.githubusercontent.com/34845402/131616445-8037852f-b079-4caa-9757-2b49cd4e3570.png)
 <br><br>
 
 ### Wheels
   * Wheel collider is first fitted to tire model <br><br>
![roost-phys-demo02](https://user-images.githubusercontent.com/34845402/131231633-64165a26-16f7-4efd-85dd-f52200a966e8.gif)
 <br><br><br>
   * Various parameters are fine-tuned for the front & back wheels  <br><br>
![roost-wheel00](https://user-images.githubusercontent.com/34845402/131617393-6b21d64c-7749-430b-bd6d-b7395ce0f2da.png)
<br><br><br>
  * Bike components moving as intended<br><br>
![roost-phys-demo04](https://user-images.githubusercontent.com/34845402/131231953-3dd4a6fb-a31c-4343-9316-14f0475a46c7.gif)
![roost-phys-demo05](https://user-images.githubusercontent.com/34845402/131232110-a6a491ab-3640-44e7-9075-02b532196c06.gif)<br><br>
![roost-ui00](https://user-images.githubusercontent.com/34845402/131607060-3794b867-d929-4973-8903-85891af8f1bf.gif)<br>
      * *To scale down & back up again during a state of suspension compression (as seen with the front and back suspension above), a game object requires both an attached mesh renderer component and parent with a fully configured Suspension script*
      
<br><br>

***

<br>

## Miscellaneous Development 

### Terrain
  * Spawn, FX and MX track locations are set  <br><br>
![terriain-desing00](https://user-images.githubusercontent.com/34845402/131232468-8fe6db56-cfd8-467b-9695-48850e68e45c.gif)<br><br><br>
  * Jumps, berms and whoops are crafted  <br><br>
![terriain-desing01 (2)](https://user-images.githubusercontent.com/34845402/131232512-047d70ae-dd57-489e-a151-2c008ad16c9d.gif)<br><br><br>
  * Empty spaces are filled in with grass and props  <br><br>
![terriain-desing02](https://user-images.githubusercontent.com/34845402/131232513-2b29d9d4-38e8-48dd-a72b-e4fe7c3e46a6.gif)
![terriain-desing03](https://user-images.githubusercontent.com/34845402/131232515-a33e5938-4fe9-45ec-a224-910f4eb94c29.gif)<br><br><br>
  * Spawn point (campground) is polished  <br><br>
![terriain-desing04 (2)](https://user-images.githubusercontent.com/34845402/131232516-6624db6b-e903-4ad5-b676-03b00b02474d.gif)
![terriain-desing05](https://user-images.githubusercontent.com/34845402/131232517-567c2ef7-660e-4faa-846f-e7f08dac4042.gif) <br><br><br>

### UI
  * An early UI build *(Pre Color System)*  <br><br>
![roost-ui01](https://user-images.githubusercontent.com/34845402/131607067-b9caa977-7c53-409b-8290-5ce2d5225f19.gif) <br><br><br>

### Current Update
  * **v.1.0 *(December, 2019)*** <br><br>
![roost-illust-v02](https://user-images.githubusercontent.com/34845402/131584617-0c46bd76-2595-4eb4-b7dd-7aa39e7b8cca.png) <br><br>

<br>

***

<br>

## Demos
&nbsp;&nbsp;&nbsp;&nbsp; **Note: Click to watch on YouTube *(Readme file doesn't allow video playback)*** <br><br>

### Welcome to Mirage Gameplay Trailer
[![roost-yt-00](https://user-images.githubusercontent.com/34845402/131611284-e762c392-b6d5-469f-9c54-57f87ef487a5.png)](https://www.youtube.com/watch?v=6BNveRmHrCw)
<br><br>

### Menu with Bike Color System
[![roost-yt-01](https://user-images.githubusercontent.com/34845402/131611281-c900bca1-56eb-43c5-9681-b9fbab82a5da.png)](https://www.youtube.com/watch?v=l61BHNf-hAs) <br><br>

### Soundtrack
[![roost-st](https://user-images.githubusercontent.com/34845402/131610204-27f33b7c-67df-401a-b068-09dc82df14b7.png)](https://www.youtube.com/watch?v=u7FOEnUcaLw)

| Track | Artist | Link |
| --------------- | --------------- | --------------- |
| In Time | Stellardrone | https://www.youtube.com/watch?v=Jgm9i19joeQ |
| Another World | Bettogh | https://www.youtube.com/watch?v=mOjkP1myYgE |
| Ranger |  Chew Chew | https://www.youtube.com/watch?v=WAGBl2IRJOo |
| In the 1980's | Simon Bichbihler | https://www.youtube.com/watch?v=KhSmZ1cD1BQ |
| Light Years | Stellardrone | https://www.youtube.com/watch?v=OMPE4pO1i_Y |
| Yah | Yung Wunda | https://www.youtube.com/watch?v=jszFCfcGTYc |

* *I do not own these songs. All included song and artist names have been listed along with links to each respective original upload. These songs are used only in a non-profit, educational form. Not for commercial distribution. Special thanks to the artists listed above.* 
<br><br>

<br>

***

<br>

<br/>
Thanks for reading!<br/><br/>
 
If you like what you see give this repo  
a star and share it with your friends.

Your support is greatly appreciated!<br/><br/>


[***David Guido***](https://www.litlabproductions.com/resume-view) :rocket:  
[***Lit Lab Productions***](https://www.litlabproductions.com)
<br/><br/>
