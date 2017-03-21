**Where Is Wally -- Image Processing Object Recognition**
========================


## Introduction
This script demonstrates using correlation matching and color segmentation to find desired object (Wally) in an image. This project aims to locate an object from an image. Please see [Template Matching and Color Segmentation in Image Processing: Where's Wally?](http://chenyumin.com/p/template-matching-and-color-segmentation-in-image-processing-wheres-wally).

- Correlation Matching:  
    This method loops through the image in an attempt to find the object template. For each location, the difference between the template and the neighborhood is calculated and recorded. The location with minimum difference is returned.

- Color Segmentation:
   This method firstly converts the image to HSV color space and use the Hue and Saturation to segment the red and write stripes. Then a vertical linear structuring element is used to dilate the stripes and find their overlapped area so the result will be only connected red and white area.


## Scenario
Wally ([Wally.png](Wally.png)) is lost at a Cosplay convention ([Where.jpg](Where.jpg)). Find him.

- Correlation matching would work well here for starters;

- Challenge : Using this method on the full-size image ([WhereLarge.jpg](WhereLarge.jpg)) is painfully slow. See if you can find Wally without using the template image but instead by recognising Wally and his stylish red and white T-shirt. (try colour segmentation then morphology here);


## Results
| Correlation Matching | Color Segmentation |
| :---: | :---: |
| ![Correlation Matching](results/correlation-matching.jpg) | ![Color Segmentation](results/color-segmentation.jpg) |


## Licensing
Please see the file named [LICENSE.md](LICENSE.md).


## Author
* Chen Yumin  


## Contact
* Chen Yumin: [*http://chenyumin.com/*][1]
* CharmySoft: [*http://CharmySoft.com/*][2]  
* Email: [*hello@chenyumin.com*](mailto:hello@chenyumin.com)  

[1]: http://chenyumin.com/ "Chen Yumin"
[2]: http://www.CharmySoft.com/ "CharmySoft"
