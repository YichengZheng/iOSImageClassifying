## iOS Image Recognition App
This  is an iOS image classifying mobile app using Google's Pre-trained Inception v3 model. 

The image select function is accomplished by using existing UIImagePickerController object.  After image is selected, it is converted to CIImage object (Core Image). Inception v3 model is loaded via Apple's CoreML frameworks. The Core Image object previously obtained is then provided to the pre-trained model for image recognition task. 

